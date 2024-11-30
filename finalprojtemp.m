clear all;
close all;
clc;

[signals, temp] = rdsamp('0016'); %rdsamp is like load but for physionet wfdb

ecg1 = signals(:, 1); %ecg1 is column 1
ecg2 = signals(:, 2); %ecg2 is column 2
nibp = signals(:, 3); %ecg3 is column 3

%plotting
figure;
plot(ecg1);
title('ECG1 Signal');
xlabel('Time (ms)');
ylabel('Amplitude');
xlim([0 10000]);
grid on;

figure;
plot(ecg2);
title('ECG2 Signal');
xlabel('Time (ms)');
ylabel('Amplitude');
xlim([0 10000]);
grid on;

figure;
plot(nibp);
title('NIBP Signal');
xlabel('Time (ms)');
ylabel('Amplitude');
xlim([0 10000]);
grid on;