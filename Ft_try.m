% Parameters
fs = 1000; % Sampling frequency
shift_range = 300; % Frequency shift in Hz

% Assuming the necessary EEG data is loaded and available in EEG_MI_train

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

% Calculate the number of bins to shift based on the desired frequency shift
num_bins_shift = round(shift_range / (fs / length(signal)));

% Apply the frequency shift using circular shifting of FFT bins
X_shifted = fftshift(X); % Shift zero-frequency component to center of spectrum
X_shifted = circshift(X_shifted, num_bins_shift); % Circularly shift the spectrum
X_shifted = ifftshift(X_shifted); % Shift back to original FFT arrangement

% Perform the inverse FFT to get the augmented signal
augmented_signal = real(ifft(X_shifted));

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

% Prepare shifted magnitude spectrum for plotting
shifted_mag_spec = fftshift(X_shifted);

% Plot the magnitude spectrum after frequency shift for positive frequencies only
subplot(4,1,3);
plot(freqs(1:half_N), abs(shifted_mag_spec(1:half_N)));
title(sprintf('Magnitude Spectrum After Frequency Shift of %d Hz', shift_range));
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