% Parameters for noise augmentation
num_augmentations = 1; % Number of noisy copies for each trial
snr_db = 25; % Desired SNR in dB

% Base path for the original and augmented files
original_base_path = 'C:\Users\Z\OneDrive - University of Edinburgh\Desktop\notthis_Beng_Project\no_noise\';
augmented_base_path = 'C:\Users\Z\OneDrive - University of Edinburgh\Desktop\notthis_Beng_Project\25dB_noise';

% Define the sessions and subjects
sessions = {'sess01', 'sess02'};
subjects = 1:54; % Array of subjects from 1 to 54

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
                % Assuming EEG_MI_train.smt is a 3D EEG data array
                [time_points, trials, channels] = size(EEG_MI_train.smt);

                % Calculate the power of the signal
                signal_power = mean(EEG_MI_train.smt(:).^2);

                % Calculate the power of the noise for the desired SNR
                noise_power = signal_power / (10^(snr_db / 10));

                % Calculate the standard deviation of the noise
                noise_std_dev = sqrt(noise_power);

                % Generate noise
                noise = noise_std_dev * randn(size(EEG_MI_train.smt));

                % Replace the original data with the noisy version
                EEG_MI_train.smt = EEG_MI_train.smt + noise;

                % EEG_MI_train.y_dec remains unchanged

                % Save the noisy dataset to the new location with EEG_MI_train
                % Check if EEG_MI_test exists and save it; otherwise, throw an error
                if exist('EEG_MI_test', 'var')
                   save(augmented_full_path, 'EEG_MI_train', 'EEG_MI_test');
                else
                   error('EEG_MI_test does not exist. The operation cannot be completed without it.');
                end
            else
                warning('The variable EEG_MI_train does not exist in the loaded .mat file: %s', file_name);
            end
        else
            warning('The original file does not exist: %s', original_full_path);
        end
    end
end

disp('All files have been processed and saved with noise to the new directory.');