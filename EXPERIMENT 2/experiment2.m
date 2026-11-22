%% EXPERIMENT 2: EEG FREQUENCY BAND ANALYSIS
% Complete program:
% 1. Generate simulated EEG input
% 2. Save and load the EEG file
% 3. Remove the trend
% 4. Estimate power spectral density (PSD)
% 5. Calculate EEG band powers
% 6. Plot absolute and relative band powers
% 7. Identify the dominant frequency band
%
% This version does not require the Signal Processing Toolbox.

clear;
close all;
clc;

%% STEP 1: CREATE A SIMULATED EEG INPUT FILE

fs = 256;                  % Sampling frequency in Hz
duration = 30;              % Recording duration in seconds

t = (0:1/fs:duration-1/fs)';

% Generate a simulated EEG containing several frequency components
rng(2);                     % Repeatable random noise

deltaSignal = 30*sin(2*pi*2*t);
thetaSignal = 20*sin(2*pi*6*t);
alphaSignal = 50*sin(2*pi*10*t);
betaSignal  = 15*sin(2*pi*20*t);
gammaSignal = 8*sin(2*pi*35*t);

% Combine components and add noise and slow baseline drift
eeg = deltaSignal ...
    + thetaSignal ...
    + alphaSignal ...
    + betaSignal ...
    + gammaSignal ...
    + 10*randn(size(t)) ...
    + 5*sin(2*pi*0.2*t);

% Save the EEG signal and sampling frequency
filename = 'eeg_sample.mat';
save(filename, 'eeg', 'fs');

fprintf('STEP 1: EEG input file created successfully.\n');
fprintf('File name: %s\n', filename);

%% STEP 2: LOAD THE EEG INPUT FILE

S = load(filename);

if isfield(S, 'eeg')
    eeg = S.eeg;
elseif isfield(S, 'EEG')
    eeg = S.EEG;
else
    error('EEG variable not found in the input file.');
end

if isfield(S, 'fs')
    fs = S.fs;
end

eeg = double(eeg(:));

if isempty(eeg) || any(~isfinite(eeg))
    error('EEG signal is empty or contains invalid values.');
end

if fs <= 0
    error('Sampling frequency must be positive.');
end

t = (0:length(eeg)-1)' / fs;

fprintf('\nSTEP 2: EEG file loaded successfully.\n');
fprintf('Number of samples = %d\n', length(eeg));
fprintf('Sampling frequency = %.2f Hz\n', fs);
fprintf('Signal duration = %.2f seconds\n', t(end));

%% STEP 3: PLOT THE RAW EEG SIGNAL

figure('Name', 'Figure 1 - Raw EEG');

plot(t, eeg, 'b');
grid on;
xlabel('Time (seconds)');
ylabel('EEG amplitude');
title('Raw EEG Signal');

%% STEP 4: REMOVE THE LINEAR TREND

eeg = detrend(eeg);

figure('Name', 'Figure 2 - Detrended EEG');

plot(t, eeg, 'k');
grid on;
xlabel('Time (seconds)');
ylabel('EEG amplitude');
title('EEG after Trend Removal');

%% STEP 5: ESTIMATE PSD USING WELCH'S METHOD
% Welch's method:
% Divide the signal into overlapping segments, apply a window,
% calculate each segment's periodogram, and average the results.

segmentLength = min(length(eeg), 4*fs);
segmentLength = floor(segmentLength);

if segmentLength < 2
    error('EEG signal is too short for spectral analysis.');
end

overlap = floor(0.5 * segmentLength);
stepSize = segmentLength - overlap;

nfft = max(1024, 2^nextpow2(segmentLength));

% Create a Hamming window without requiring a toolbox
n = (0:segmentLength-1)';
window = 0.54 - 0.46*cos(2*pi*n/(segmentLength-1));

windowPower = sum(window.^2);

% Initialise the PSD accumulator
Psum = zeros(floor(nfft/2)+1, 1);
numberOfSegments = 0;

startIndex = 1;

while startIndex + segmentLength - 1 <= length(eeg)

    indices = startIndex:(startIndex + segmentLength - 1);

    segment = eeg(indices);
    segment = segment - mean(segment);
    segment = segment .* window;

    % Fourier transform
    X = fft(segment, nfft);

    % Two-sided power spectral density
    P2 = abs(X).^2 / (fs * windowPower);

    % Retain the non-negative frequencies
    P1 = P2(1:floor(nfft/2)+1);

    % Convert to one-sided PSD
    if rem(nfft, 2) == 0
        P1(2:end-1) = 2 * P1(2:end-1);
    else
        P1(2:end) = 2 * P1(2:end);
    end

    Psum = Psum + P1;
    numberOfSegments = numberOfSegments + 1;

    startIndex = startIndex + stepSize;
end

if numberOfSegments == 0
    error('No EEG segments were available for PSD calculation.');
end

pxx = Psum / numberOfSegments;
f = (0:floor(nfft/2))' * fs/nfft;

%% STEP 6: PLOT THE POWER SPECTRAL DENSITY

figure('Name', 'Figure 3 - EEG PSD');

plot(f, pxx, 'LineWidth', 1.2);
grid on;
xlim([0 min(50, fs/2)]);
xlabel('Frequency (Hz)');
ylabel('Power per Hz');
title('EEG Power Spectral Density');

%% STEP 7: DEFINE THE EEG FREQUENCY BANDS

bandNames = {'Delta'; 'Theta'; 'Alpha'; 'Beta'; 'Gamma'};

% Frequency limits in Hz
bandLimits = [
     0.5   4
     4     8
     8    13
    13    30
    30    45
];

numberOfBands = length(bandNames);
bandPower = zeros(numberOfBands, 1);

%% STEP 8: CALCULATE ABSOLUTE BAND POWER

for k = 1:numberOfBands

    idx = f >= bandLimits(k,1) & ...
          f < bandLimits(k,2);

    if nnz(idx) >= 2
        bandPower(k) = trapz(f(idx), pxx(idx));
    else
        bandPower(k) = 0;
    end
end

totalPower = sum(bandPower);

%% STEP 9: CALCULATE RELATIVE BAND POWER

if totalPower > 0
    relativePower = 100 * bandPower / totalPower;
else
    relativePower = zeros(numberOfBands, 1);
    warning('Total calculated band power is zero.');
end

%% STEP 10: PLOT ABSOLUTE BAND POWER

figure('Name', 'Figure 4 - Absolute EEG Band Power');

bar(bandPower);
grid on;
set(gca, 'XTick', 1:numberOfBands, ...
    'XTickLabel', bandNames);

xlabel('EEG Frequency Band');
ylabel('Absolute Power');
title('Absolute EEG Band Power');

%% STEP 11: PLOT RELATIVE BAND POWER

figure('Name', 'Figure 5 - Relative EEG Band Power');

bar(relativePower);
grid on;
set(gca, 'XTick', 1:numberOfBands, ...
    'XTickLabel', bandNames);

xlabel('EEG Frequency Band');
ylabel('Relative Power (%)');
title('Relative EEG Band Power');

%% STEP 12: IDENTIFY THE DOMINANT FREQUENCY BAND

[maxPower, idxMax] = max(bandPower);

dominantBand = bandNames{idxMax};
dominantRelativePower = relativePower(idxMax);

%% STEP 13: DISPLAY RESULTS

fprintf('\n========================================\n');
fprintf('       EXPERIMENT 2: EEG RESULTS\n');
fprintf('========================================\n');

fprintf('Input file = %s\n', filename);
fprintf('Sampling frequency = %.2f Hz\n', fs);
fprintf('Signal duration = %.2f seconds\n', t(end));
fprintf('Number of samples = %d\n', length(eeg));
fprintf('PSD segments averaged = %d\n', numberOfSegments);

fprintf('\nEEG FREQUENCY BAND RESULTS\n');
fprintf('----------------------------------------\n');

for k = 1:numberOfBands
    fprintf('%-8s Power = %.6f | Relative = %.2f%%\n', ...
        bandNames{k}, bandPower(k), relativePower(k));
end

fprintf('----------------------------------------\n');
fprintf('Total calculated band power = %.6f\n', totalPower);
fprintf('Dominant frequency band = %s\n', dominantBand);
fprintf('Dominant band power = %.6f\n', maxPower);
fprintf('Dominant relative power = %.2f%%\n', ...
    dominantRelativePower);

fprintf('========================================\n');
fprintf('Experiment 2 completed successfully.\n');
