% Number of trials to average
N = 5; % You can change this based on your requirements

% Base path for the original and augmented files
original_base_path = 'C:\Users\Z\OneDrive - University of Edinburgh\Desktop\Beng Project\no_noise\';
augmented_base_path = 'C:\Users\Z\OneDrive - University of Edinburgh\Desktop\Beng Project\Trial_averaging\';

% Define the sessions and subjects
sessions = {'sess01', 'sess02'};
subjects = 1:3; % Array of subjects from 1 to 54

% Loop over all sessions and subjects
for sess_idx = 1:length(sessions)
    for subj_idx = subjects
        % Create the file name
        file_name = sprintf('%s_subj%02d_EEG_MI.mat', sessions{sess_idx}, subj_idx);
        original_full_path = fullfile(original_base_path, file_name);
        augmented_full_path = fullfile(augmented_base_path, file_name);

        % Check if the original file exists
        if exist(original_full_path, 'file')
            % Load the data
            load(original_full_path);

            % Verify that EEG_MI_train exists and has the expected structure
            if exist('EEG_MI_train', 'var') && isfield(EEG_MI_train, 'smt') && isfield(EEG_MI_train, 'y_dec')
                % Get the size of the data
                [time_points, trials, channels] = size(EEG_MI_train.smt);

                % Print the size of the data
                fprintf('Data size: %d time points, %d trials, %d channels\n', time_points, trials, channels);

                % Get unique labels
                unique_labels = unique(EEG_MI_train.y_dec);
                averaged_smt = [];
                averaged_labels = [];

                % Perform trial averaging for each label
                for label_idx = 1:length(unique_labels)
                    label = unique_labels(label_idx); % Extract current label as a scalar

                    % Find trials with the current label
                    label_trials_indices = find(EEG_MI_train.y_dec == label);

                    % Ensure that the maximum index is a scalar
                    max_index = max(label_trials_indices);
                    
                    % Check if any indices are out of bounds
                    if max_index > trials
                        error('Index exceeds the number of trials. Label: %d, Max Index: %d, Number of Trials: %d', ...
                              double(label), double(max_index), double(trials));
                    end

                    label_trials = EEG_MI_train.smt(:, label_trials_indices, :);

                    % Calculate the number of averaged trials for this label
                    num_label_trials = length(label_trials_indices);
                    num_averaged_label_trials = ceil(num_label_trials / N);

                    % Preallocate space for the averaged data for this label
                    averaged_label_smt = zeros(time_points, num_averaged_label_trials, channels);

                    % Average trials for the current label
                    for trial_group = 1:num_averaged_label_trials
                        % Calculate the indices of the trials to be averaged within this label
                        start_idx = (trial_group - 1) * N + 1;
                        end_idx = min(trial_group * N, num_label_trials);
                        trial_indices = start_idx:end_idx;

                        % Average the selected trials and assign to the preallocated array
                        averaged_label_smt(:, trial_group, :) = mean(label_trials(:, trial_indices, :), 2);
                    end

                    % Concatenate the averaged trials for this label with the others
                    averaged_smt = cat(2, averaged_smt, averaged_label_smt);
                    averaged_labels = [averaged_labels; repmat(label, num_averaged_label_trials, 1)];
                end
                
                % Transpose averaged_labels if it's not a row vector
                if iscolumn(averaged_labels)
                    averaged_labels = averaged_labels';
                end
                % Concatenate the averaged trials with the original trials
                EEG_MI_train.smt = cat(2, EEG_MI_train.smt, averaged_smt);
                EEG_MI_train.y_dec = cat(2, EEG_MI_train.y_dec, averaged_labels);

                % Save the averaged dataset to a new file
                save(augmented_full_path, 'EEG_MI_train', 'EEG_MI_test');
            else
                warning('The variable EEG_MI_train does not exist or is missing required fields in the loaded .mat file: %s', file_name);
            end
        else
            warning('The original file does not exist: %s', original_full_path);
        end
    end
end

disp('All files have been processed with trial averaging and saved.');