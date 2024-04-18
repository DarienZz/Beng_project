% Parameters
fs = 1000; % Sampling frequency
shift_range = 0.5; % Maximum frequency shift in Hz

% Base path for the original and recombined files
original_base_path = 'C:\Users\Z\OneDrive - University of Edinburgh\Desktop\Beng Project\no_noise\';
augmented_base_path = 'C:\Users\Z\OneDrive - University of Edinburgh\Desktop\Beng Project\Frequency_Shift\';


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

            % Frequency shift augmentation if EEG_MI_train exists in the loaded file
            if exist('EEG_MI_train', 'var')
                [time_points, trials, channels] = size(EEG_MI_train.smt);
                
                % Initialize the augmented_data matrix
                augmented_data = EEG_MI_train.smt;

                % Apply frequency shift to each trial and channel
                for trial = 1:trials
                    for channel = 1:channels
                        % Perform FFT on the signal
                        X = fft(EEG_MI_train.smt(:, trial, channel));

                        % Generate random frequency shift
                        % freq_shift = randi([-shift_range, shift_range], 1);
                        freq_shift = shift_range;

                        % Shift the frequency spectrum
                        n = length(X);
                        shift_idx = round(freq_shift / fs * n);

                        if shift_idx ~= 0
                            X = circshift(X, shift_idx);
                        end

                        % Perform the inverse FFT to get the augmented signal
                        augmented_signal = real(ifft(X));

                        % Store the augmented signal in the second half of augmented_data
                        augmented_data(:, trials + trial, channel) = augmented_signal;
                    end
                end
                
                % Replace the original data in the structure
                EEG_MI_train.smt = augmented_data;

                % Save the augmented dataset to the new location
                save(augmented_full_path, 'EEG_MI_train', 'EEG_MI_test');
            else
                warning('The variable EEG_MI_train does not exist in the loaded .mat file: %s', file_name);
            end
        else
            warning('The original file does not exist: %s', original_full_path);
        end
    end
end

disp('All files have been processed with frequency shift augmentation and saved to the new directory.');