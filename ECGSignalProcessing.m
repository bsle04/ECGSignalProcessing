clear all;
close all;
clc;

%Convolution parameters
fs = 100; %sampling frequency
T_plot = 10; %duration of time
N_plot = fs * T_plot; %number of samples for the given amt of time
pulse_width = 1; %Pulse width (s)

%prompt user to select folder
folderPath = uigetdir('Select the folder containing the .dat files');

if isequal(folderPath, 0) %if user didn't select folder
    disp('User canceled the folder selection. Script terminated.'); %display message
end

cd(folderPath); %change working directory to folder

%get a list of all .dat files in the folder
dataFiles = dir(fullfile(folderPath, '*.DAT'));
temp = dir(fullfile(folderPath, '*.dat')); %case sensitive, so try both DAT and dat
dataFiles = [dataFiles; temp]; %combine the two arrays

if isempty(dataFiles) %sanity check to see if there are any valid files
    error('No .dat files found in the selected folder.');
end

for i = 1:(length(dataFiles)/2) %divide length by 2 because there are .dat and .hea files, these are a pair of files for one set of signals
    fileName = dataFiles(i).name;
    baseName = fileName(1:end-4); %remove the extension
    
    [signals, ~] = rdsamp(baseName); %rdsamp is like "load" but for wfdb toolbox
    [rows, columns] = size(signals);

    ecg1 = signals(:, 1); %ECG1
    ecg2 = signals(:, 2); %ECG2

    t_h = (0:N_plot-1) / fs; %time vector for impulse response
    h = exp(-t_h); %exponential decay

    %signal convolution w/ impulse response
    y_ecg1 = conv(ecg1, h) / fs;
    y_ecg2 = conv(ecg2, h) / fs;

    %time vectors for plotting
    t_ecg1 = (0:length(y_ecg1)-1) / fs;
    t_ecg2 = (0:length(y_ecg2)-1) / fs;

    %plot ecg1
    figure;
    subplot(2, 1, 1);
    plot(ecg1);
    xlabel('Samples');
    ylabel('Amplitude');
    title(['ECG1 Signal from Adults Aged 85-92, Sample ', fileName]);
    grid on;
    
    if 0
    subplot(2, 1, 2);
    plot(t_h, h, 'LineWidth', 1.5);
    xlabel('Time (sec)');
    ylabel('h(t)');
    title('Impulse Response');
    grid on;
    end

    subplot(2, 1, 2);
    plot(t_ecg1, y_ecg1, 'LineWidth', 1.5);
    xlabel('Time (sec)');
    ylabel('Amplitude');
    title('Convolved ECG1 Signal');
    grid on;

    %plot ECG2
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
    
if columns > 2 %if nibp exists in the file

    nibp = signals(:, 3);
    y_nibp = conv(nibp, h) / fs; %convolution
    t_nibp = (0:length(y_nibp)-1) / fs;

    %plot NIBP
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

    %add title
    sgtitle(['Signals, Impulse Response, and Convolution for ', fileName]);
end
end