clear all; close all; clc;

% Load your EEG_MI_train and EEG_MI_test structs if not already in the workspace
load('C:\Users\Z\OneDrive - University of Edinburgh\Desktop\Beng Project\session1\s3\EEG_MI.mat'); % Assuming this file contains both EEG_MI_train and EEG_MI_test

% Define the directory where you want to save the .mat filem
save_directory = 'C:\Users\Z\OneDrive - University of Edinburgh\Desktop\Beng Project\20dB_noise\session1\s3'; % For Windows

% Create the full file path
save_filename = fullfile(save_directory, 'EEG_MI.mat');

% Define the target SNR in dB
target_snr_db = 20;

% Convert SNR from dB to linear scale
target_snr_linear = 10^(target_snr_db / 10);

% Function to calculate the power of the signal
signal_power = @(signal) mean(signal .^ 2);

% Initialize a cell array to hold the augmented data for each iteration
augmented_data = cell(1, 5);

% Run the noise addition process 5 times
for i = 1:5
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
augmented_data_combined = [EEG_MI_train.x; cat(1, augmented_data{:})];

% Replace EEG_MI_train.x with the augmented_data_combined
EEG_MI_train.x = augmented_data_combined;

% Check if the directory exists, if not, create it
if ~exist(save_directory, 'dir')
    mkdir(save_directory);
end

% Save the modified EEG_MI_train structure and the EEG_MI_test structure to the new .mat file
save(save_filename, 'EEG_MI_train', 'EEG_MI_test', '-v7.3');