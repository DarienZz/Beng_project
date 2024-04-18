clear all; close all; clc;

% Usage of the function for subjects
subjects = 7:54;
base_dir = 'C:\Users\Z\OneDrive - University of Edinburgh\Desktop\Beng Project';

noise_level_db = 5;
num_iterations = 5;

% Define the directory where you want to save the .mat file
save_directory = fullfile(base_dir, sprintf('%ddB_noise/session1/s%d', noise_level_db, s));

% Call the function
add_noise_and_save(subjects, base_dir, noise_level_db, num_iterations);

function add_noise_and_save(subjects, base_dir, noise_level_db, num_iterations)
    % Function to calculate the power of the signal
    signal_power = @(signal) mean(signal .^ 2);
    
    % Convert SNR from dB to linear scale
    target_snr_linear = 10^(noise_level_db / 10);
    
    for s = subjects
        % Load your EEG_MI_train and EEG_MI_test structs
        data_file = fullfile(base_dir, sprintf('session1/s%d/EEG_MI.mat', s));
        load(data_file); % Assuming this file contains both EEG_MI_train and EEG_MI_test

        % Initialize a cell array to hold the augmented data for each iteration
        augmented_data = cell(1, num_iterations);
        
        % Run the noise addition process num_iterations times
        for i = 1:num_iterations
            % Make a copy of the EEG_MI_train.x to work with
            temp_EEG_MI_train_x = EEG_MI_train.x;

            % Add noise to columns 13, 14, and 15 (MATLAB uses 1-indexing)
            for column = [13, 14, 15]
                % Extract the signal from the specified column
                signal = temp_EEG_MI_train_x(:, column);

                % Calculate the power of the current signal
                current_signal_power = signal_power(signal);

                % Calculate the required noise power for the target SNR
                noise_power = current_signal_power / target_snr_linear;

                % Generate Gaussian noise with the calculated power
                noise_std_dev = sqrt(noise_power);
                noise = noise_std_dev * randn(size(signal, 1), 1);

                % Add the noise to the signal
                temp_EEG_MI_train_x(:, column) = signal + noise;
            end

            % Store the augmented data from this iteration
            augmented_data{i} = temp_EEG_MI_train_x;
        end

        % Concatenate the original and all augmented datasets vertically
        augmented_data_combined = cat(1, augmented_data{:});

        % Replace EEG_MI_train.x with the augmented_data_combined
        EEG_MI_train.x = augmented_data_combined;

       
        % Check if the directory exists, if not, create it
        if ~exist(save_directory, 'dir')
            mkdir(save_directory);
        end
        
        % Create the full file path
        save_filename = fullfile(save_directory, 'EEG_MI.mat');
        
        % Save the modified EEG_MI_train structure and the EEG_MI_test structure to the new .mat file
        save(save_filename, 'EEG_MI_train', 'EEG_MI_test', '-v7.3');
    end
end