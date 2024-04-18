% Program to interact with EEG_MI_train.smt array

% Clear the workspace and console
clear all; clc; close all;

% Load the data (update the 'your_file_path' with the actual file path)
load('C:\Users\Z\OneDrive - University of Edinburgh\Desktop\newnew\sess01_subj01_EEG_MI.mat'); % Assuming the variable smt is stored in this MAT-file

% Display the size of the EEG_MI_train.smt array
smt_size = size(EEG_MI_train.smt);
fprintf('The size of EEG_MI_train.smt is %d x %d x %d\n', smt_size);

% Define the trial and channel to visualize
trial_to_visualize = 1;
channel_to_visualize = 13;

% Extract the specific trial and channel data
trial_channel_data = squeeze(EEG_MI_train.smt(:, trial_to_visualize, channel_to_visualize));

% Visualize the specific trial and channel data
figure;
plot(trial_channel_data);
title(sprintf('EEG Data for random trial in Channel %d', channel_to_visualize));
% title(sprintf('EEG Data for Trial %d, Channel %d', trial_to_visualize, channel_to_visualize));
xlabel('Time Points');
ylabel('Amplitude');

% Compute and display basic statistics
mean_value = mean(trial_channel_data);
std_dev = std(trial_channel_data);
fprintf('Mean value for Trial %d, Channel %d: %f\n', trial_to_visualize, channel_to_visualize, mean_value);
fprintf('Standard deviation for Trial %d, Channel %d: %f\n', trial_to_visualize, channel_to_visualize, std_dev);

% Optional: Save the slice of data to a new .mat file
save('slice_of_EEG_MI_train.mat', 'trial_channel_data');