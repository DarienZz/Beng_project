% Parameters
fs = 1000; % Sampling frequency
shift_range = 5; % Maximum frequency shift in Hz (0.12 is the maximum good f)

% For simplicity, we'll only look at the first session and subject
sess_idx = 1;
subj_idx = 1;

% Load one example dataset
file_name = sprintf('sess01_subj%02d_EEG_MI.mat', subj_idx);
original_full_path = fullfile('F:\Beng_Project\Dataset_result\no_noise', file_name);

% Ensure the file exists
if exist(original_full_path, 'file')
    load(original_full_path); % Load the data
else
    error('The original file does not exist: %s', original_full_path);
end

% Select one trial and one channel for demonstration
trial = 1;
channel = 13;
signal = EEG_MI_train.smt(:, trial, channel);

% Time vector for plotting
time = (0:length(signal)-1) / fs;

% Perform FFT on the signal
X = fft(signal);

% Frequency domain representation for plotting
freqs = (0:length(X)-1) * (fs / length(signal));

% Generate random frequency shift
% freq_shift = randi([-shift_range, shift_range], 1);
freq_shift = shift_range;

% Apply the frequency shift using complex exponential
n = length(signal);
t = (0:n-1) / fs; % Time vector for the signal
% Create the complex exponential for the frequency shift
exp_shift = exp(-1i * 2 * pi * freq_shift * t);
% Apply the shift to the DFT
X_shifted = X .* exp_shift';

% Perform the inverse FFT to get the augmented signal
augmented_signal = real(ifft(X_shifted));

% Plot the original signal
figure;
subplot(4,1,1);
plot(time, signal);
title('Original Signal in Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot the magnitude spectrum after FFT
subplot(4,1,2);
plot(freqs, abs(X));
title('Magnitude Spectrum After FFT');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Plot the magnitude spectrum after frequency shift
subplot(4,1,3);
plot(freqs, abs(fft(augmented_signal)));
title(sprintf('Magnitude Spectrum After Frequency Shift of %d Hz', freq_shift));
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Plot the time-domain signal after inverse FFT
subplot(4,1,4);
plot(time, augmented_signal);
title('Signal in Time Domain After Inverse FFT');
xlabel('Time (s)');
ylabel('Amplitude');

% Enhance the figure layout
sgtitle('Signal Transformations at Each Stage');