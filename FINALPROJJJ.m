clear all;
close all;
clc;

% Parameters for convolution
fs = 100; % Sampling frequency for impulse response
T_plot = 10; % Desired duration for plotting in seconds
N_plot = fs * T_plot; % Number of samples for 10 seconds
pulse_width = 1; % Pulse width in seconds

% Prompt user to select the folder
folderPath = uigetdir('Select the folder containing the .dat files');

% Check if the user canceled folder selection
if isequal(folderPath, 0)
    error('User canceled the folder selection. Script terminated.');
end

% Change to the selected folder
cd(folderPath);

% Get a list of all .dat files in the folder
dataFiles = dir(fullfile(folderPath, '*.DAT'));
temp = dir(fullfile(folderPath, '*.dat'));
dataFiles = [dataFiles; temp];



% Check if there are any .dat files
if isempty(dataFiles)
    error('No .dat files found in the selected folder.');
end

% Loop through each .dat file and process
for i = 1:length(dataFiles)
    fileName = dataFiles(i).name;
    baseName = fileName(1:end-4); % Remove the .dat extension
    
    % Read the signal using rdsamp
    try
        [signals, ~] = rdsamp(baseName); % Assumes corresponding .hea file exists
        [rows, columns] = size(signals);
    catch ME
        warning('Could not read file: %s. Skipping...', fileName);
        continue;
    end

    % Extract signals
    ecg1 = signals(:, 1); % ECG1
    ecg2 = signals(:, 2); % ECG2
    
    % Define the impulse response (h(t))
    t_h = (0:N_plot-1) / fs; % Time vector for impulse response
    h = exp(-t_h); % Exponential decay

    % Convolve each signal with the impulse response
    y_ecg1 = conv(ecg1, h) / fs;
    y_ecg2 = conv(ecg2, h) / fs;

    % Time vectors for plotting
    t_ecg1 = (0:length(y_ecg1)-1) / fs;
    t_ecg2 = (0:length(y_ecg2)-1) / fs;

    % Plot ECG1
    figure;
    subplot(3, 1, 1);
    plot(ecg1);
    xlabel('Samples');
    ylabel('Amplitude');
    title(['ECG1 Signal from ', fileName]);
    grid on;

    subplot(3, 1, 2);
    plot(t_h, h, 'LineWidth', 1.5);
    xlabel('Time (sec)');
    ylabel('h(t)');
    title('Impulse Response');
    grid on;

    subplot(3, 1, 3);
    plot(t_ecg1, y_ecg1, 'LineWidth', 1.5);
    xlabel('Time (sec)');
    ylabel('Amplitude');
    title('Convolved ECG1 Signal');
    grid on;

    % Plot ECG2
    figure;
    subplot(3, 1, 1);
    plot(ecg2);
    xlabel('Samples');
    ylabel('Amplitude');
    title(['ECG2 Signal from ', fileName]);
    grid on;

    subplot(3, 1, 2);
    plot(t_h, h, 'LineWidth', 1.5);
    xlabel('Time (sec)');
    ylabel('h(t)');
    title('Impulse Response');
    grid on;

    subplot(3, 1, 3);
    plot(t_ecg2, y_ecg2, 'LineWidth', 1.5);
    xlabel('Time (sec)');
    ylabel('Amplitude');
    title('Convolved ECG2 Signal');
    grid on;
    
if columns > 2

    nibp = signals(:, 3); % NIBP
    y_nibp = conv(nibp, h) / fs;
    t_nibp = (0:length(y_nibp)-1) / fs;

    % Plot NIBP
    figure;
    subplot(3, 1, 1);
    plot(nibp);
    xlabel('Samples');
    ylabel('Amplitude');
    title(['NIBP Signal from ', fileName]);
    grid on;

    subplot(3, 1, 2);
    plot(t_h, h, 'LineWidth', 1.5);
    xlabel('Time (sec)');
    ylabel('h(t)');
    title('Impulse Response');
    grid on;

    subplot(3, 1, 3);
    plot(t_nibp, y_nibp, 'LineWidth', 1.5);
    xlabel('Time (sec)');
    ylabel('Amplitude');
    title('Convolved NIBP Signal');
    grid on;

    % Add a title for the entire figure
    sgtitle(['Signals, Impulse Response, and Convolution for ', fileName]);
end
end