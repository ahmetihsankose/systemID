% averaged power spectrum

clc,clear,
tic
addpath('C:\Users\Ahmet\Desktop\working_directory\Scope\TestData')

tempData=readmatrix('../ScopeResults/20220531_Y_Axis_Pulse_9Nm_10ms.csv');
tempData1=readmatrix('../ScopeResults/20220531_Y_Axis_Pulse_9Nm_10ms_doublet.csv');
tempData2=readmatrix('../ScopeResults/20220531_Y_Axis_Pulse_6Nm_10ms.csv');
tempData3=readmatrix('../ScopeResults/20220531_Y_Axis_Pulse_9Nm_20ms.csv');
tempData4=readmatrix('../ScopeResults/20220531_Y_Axis_Pulse_9Nm_5ms.csv');

data=tempData(6:end,:);
data1=tempData1(6:end,:);
data2=tempData2(6:end,:);
data3=tempData3(6:end,:);
data4=tempData4(6:end,:);

velocity  = data(:,16)/10000*5/60; velocity(end) = [];   %mm/s
velocity1  = data1(:,16)/10000*5/60; velocity1(end) = [];   %mm/s
velocity2  = data2(:,16)/10000*5/60; velocity2(end) = [];   %mm/s
velocity3  = data3(:,16)/10000*5/60; velocity3(end) = [];   %mm/s
velocity4  = data4(:,16)/10000*5/60; velocity4(end) = [];   %mm/s

torque = data(:,22)/1000*2.37; torque(end) = [];  %Nm
torque1 = data1(:,22)/1000*2.37; torque1(end) = [];  %Nm
torque2 = data2(:,22)/1000*2.37; torque2(end) = [];  %Nm
torque3 = data3(:,22)/1000*2.37; torque3(end) = [];  %Nm
torque4 = data4(:,22)/1000*2.37; torque4(end) = [];  %Nm


samplingTime = 0.001;

numOfData = min([size(data,1),size(data1,1),size(data2,1),size(data3,1),size(data4,1)]);

N = 1:1:numOfData-1; % number of data

torqueData = [torque(N), torque1(N), torque2(N), torque3(N), torque4(N)];
velocityData = [velocity(N), velocity1(N), velocity2(N), velocity3(N), velocity4(N)];

K  = size(torqueData,2);                                     % number of trials.
N  = size(torqueData,1);                                     % number of indices per trial.
SFF = zeros(N,K);                            
Sxx = zeros(N,K);
SxF = zeros(N,K);
for k=1:K                                                   % Compute the spectra for each trial.
    SFF(:,k) = fft(torqueData(:,k)) .* conj(fft(torqueData(:,k))); % ... power spectrum of x.
    Sxx(:,k) = fft(velocityData(:,k)) .* conj(fft(velocityData(:,k))); % ... power spectrum of y.
    SxF(:,k) = fft(velocityData(:,k)) .* conj(fft(torqueData(:,k))); % ... cross spectrum.
end
L = 1:floor(N/2);  % only plot the first half of freqs

SFF = SFF(L,:)';                           
Sxx = Sxx(L,:)';
SxF = SxF(L,:)';

meanSFF = mean(SFF,1);                                 
meanSxx = mean(Sxx,1);
meanSxF = mean(SxF,1);

coherence = abs(meanSxF) ./ (sqrt(meanSFF) .* sqrt(meanSxx));        % Compute the coherence.


frf = meanSxF./meanSFF;

subplot(4,1,1)
plot(meanSFF(L)/N,'LineWidth',1.5)
legend('PSD of torque')
xlabel('frequency [Hz]')
% ylabel('[N*m]')


subplot(4,1,2)
plot(meanSxx(L)/N,'LineWidth',1.5)
legend('PSD of velocity')
xlabel('frequency [Hz]')
% ylabel('[mm/s]')

subplot(4,1,3)
plot(real(frf(L)),'LineWidth',2)
legend('frequency response')
xlabel('frequency [Hz]')
% ylabel('mm/(s*N*m)')

subplot(4,1,4)
plot(coherence(L),'LineWidth',1.5)
legend('coherence')
xlabel('frequency [Hz]')


toc
