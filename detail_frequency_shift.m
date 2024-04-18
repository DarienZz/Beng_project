% Parameters
fs = 1000; % Sampling frequency
shift_range = 0.5; % Frequency shift in Hz

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
freq_shift = shift_range; % For a fixed shift, use shift_range directly

% Apply the frequency shift to the time-domain signal using complex exponential
t = (0:length(signal)-1) / fs; % Time vector for the signal
shifted_signal = signal .* exp(-1i * 2 * pi * freq_shift * t).';

% Perform FFT on the shifted signal
X_shifted = fft(shifted_signal);

% Plot the original signal in the time domain
figure;
subplot(4,1,1);
plot(time, signal);
title('Original Signal in Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot the magnitude spectrum after FFT for positive frequencies only
subplot(4,1,2);
half_N = ceil((length(X)+1)/2); % Index of the Nyquist frequency + 1
plot(freqs(1:half_N), abs(X(1:half_N)));
title('Magnitude Spectrum After FFT');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Plot the magnitude spectrum after frequency shift for positive frequencies only
subplot(4,1,3);
plot(freqs(1:half_N), abs(X_shifted(1:half_N)));
title(sprintf('Magnitude Spectrum After Frequency Shift of %d Hz', freq_shift));
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Plot the shifted signal in the time domain
subplot(4,1,4);
plot(time, real(shifted_signal));
title('Shifted Signal in Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');

% Enhance the figure layout
sgtitle('Signal Transformations at Each Stage');

% Save the figure with high resolution (e.g., 300 DPI)
saveas(gcf, 'signal_transformations_high_res.png', 'png');
