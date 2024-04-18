% Parameters for noise augmentation
num_augmentations = 1; % Number of noisy copies for each trial
snr_db = 25; % Desired SNR in dB

% Base path for the original and augmented files
original_base_path = 'C:\Users\Z\OneDrive - University of Edinburgh\Desktop\notthis_Beng_Project\no_noise';
augmented_base_path = 'F:\Beng_Project\Dataset_result\25dB_noise';

% Define the sessions and subjects
sessions = {'sess01', 'sess02'};
subjects = 1:1; % Array of subjects from 1 to 54

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

            % Perform the following if 'EEG_MI_train' exists in the loaded file
            if exist('EEG_MI_train', 'var')
                % Assuming EEG_MI_train.smt is a 3D EEG data array and EEG_MI_train.y_dec is a label vector
                [time_points, trials, channels] = size(EEG_MI_train.smt);

                % Calculate the power of the signal
                signal_power = mean(EEG_MI_train.smt(:).^2);

                % Calculate the power of the noise for the desired SNR
                noise_power = signal_power / (10^(snr_db / 10));

                % Calculate the standard deviation of the noise
                noise_std_dev = sqrt(noise_power);

                % Preallocate space for the augmented data
                augmented_smt = zeros(time_points, trials * num_augmentations, channels);

                % Generate augmented data by adding noise
                for i = 1:num_augmentations
                    % Generate noise
                    noise = noise_std_dev * randn(size(EEG_MI_train.smt));
                    % Add noise to create a noisy copy
                    noisy_copy = EEG_MI_train.smt + noise;
                    % Place the noisy copy into the augmented array, excluding the original data
                    augmented_smt(:, (trials * (i - 1)) + (1:trials), :) = noisy_copy;
                end

                % Create EEG_MI_test with the original data
                EEG_MI_test = EEG_MI_train;

                % Update EEG_MI_train.smt with the augmented (noisy) data only
                EEG_MI_train.smt = augmented_smt;

                % Replicate EEG_MI_train.y_dec for each augmentation
                EEG_MI_train.y_dec = repmat(EEG_MI_train.y_dec, 1, num_augmentations);

                % Save the augmented dataset to the new location with both EEG_MI_train and EEG_MI_test
                save(augmented_full_path, 'EEG_MI_train', 'EEG_MI_test');
            else
                warning('The variable EEG_MI_train does not exist in the loaded .mat file: %s', file_name);
            end
        else
            warning('The original file does not exist: %s', original_full_path);
        end
    end
end

disp('All files have been processed and saved to the new directory.');