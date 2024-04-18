% Parameters for time slice recombination
num_slices = 5; % Number of time slices to recombine within each trial

% Base path for the original and recombined files
original_base_path = 'C:\Users\Z\OneDrive - University of Edinburgh\Desktop\Beng Project\no_noise\';
recombined_base_path = 'C:\Users\Z\OneDrive - University of Edinburgh\Desktop\Beng Project\Recombination_of_Time_Slices\';

% Define the sessions and subjects
sessions = {'sess01', 'sess02'};
subjects = 1:3; % Array of subjects from 1 to 54

% Loop over all sessions and subjects
for sess_idx = 1:length(sessions)
    for subj_idx = subjects
        % Create the file name
        file_name = sprintf('%s_subj%02d_EEG_MI.mat', sessions{sess_idx}, subj_idx);
        original_full_path = fullfile(original_base_path, file_name);
        recombined_full_path = fullfile(recombined_base_path, file_name);

        % Check if the original file exists
        if exist(original_full_path, 'file')
            % Load the data
            load(original_full_path);

            % Perform the following if 'EEG_MI_train' exists in the loaded file
            if exist('EEG_MI_train', 'var')
                % Assuming EEG_MI_train.smt is a 3D EEG data array
                [time_points, trials, channels] = size(EEG_MI_train.smt);

                % Determine the size of each time slice
                slice_size = floor(time_points / num_slices);

                % Error handling for incompatible slice size
                if time_points ~= slice_size * num_slices
                    error('The number of time points is not divisible by the number of time slices.');
                end

                % Initialize a matrix to hold the recombined data
                recombined_data = EEG_MI_train.smt;

                % Recombine time slices within each trial
                for trial = 1:trials
                    % Extract slices for the current trial
                    slices = reshape(EEG_MI_train.smt(:, trial, :), slice_size, num_slices, channels);
                    
                    % Shuffle the order of slices
                    shuffled_order = randperm(num_slices);
                    slices = slices(:, shuffled_order, :);
                    
                    % Reconstruct the trial from the shuffled slices
                    recombined_data(:, trial, :) = reshape(slices, time_points, 1, channels);
                end

                % Concatenate the recombined data with the original data
                EEG_MI_train.smt = cat(2, EEG_MI_train.smt, recombined_data);

                % Double the labels to match the augmented dataset
                EEG_MI_train.y_dec = repmat(EEG_MI_train.y_dec, 1, 2);

                % Save the combined dataset to the new location
                save(recombined_full_path, 'EEG_MI_train', 'EEG_MI_test', '-v7.3');
            else
                warning('The variable EEG_MI_train does not exist in the loaded .mat file: %s', file_name);
            end
        else
            warning('The original file does not exist: %s', original_full_path);
        end
    end
end

disp('All files have been processed and saved to the new directory.');