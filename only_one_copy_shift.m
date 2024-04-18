% Parameters
fs = 1000; % Sampling frequency
shift_range = 0.5; % Maximum frequency shift in Hz

% Base path for the original and recombined files
original_base_path = 'C:\Users\Z\OneDrive - University of Edinburgh\Desktop\notthis_Beng_Project\no_noise';
augmented_base_path = 'C:\Users\Z\OneDrive - University of Edinburgh\Desktop\notthis_Beng_Project\Frequency_shift_data';

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
                
                % Generate time vector for the entire signal
                t = (0:time_points-1) / fs;
                
                % Apply frequency shift to each trial and channel
                for trial = 1:trials
                    for channel = 1:channels
                        % Generate random frequency shift
                        freq_shift = shift_range;

                        % Create the complex exponential for frequency shift
                        complex_exponential = exp(-1i * 2 * pi * freq_shift * t).';

                        % Apply frequency shift using complex exponential
                        EEG_MI_train.smt(:, trial, channel) = EEG_MI_train.smt(:, trial, channel) .* complex_exponential;
                    end
                end

                % Save the frequency-shifted dataset to the new location
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