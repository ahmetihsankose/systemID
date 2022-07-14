%%% coherence test from one big data
% averaged power spectrum
clc,clear,
tic

sampleTime = 0.5; %%% miliseconds
delayTime = 5000;
range = delayTime/sampleTime;
trial = 5;

addpath('/home/kose/matlab/Scope/TestData')

tempData=readmatrix('y_Axis_ImpulseTest_23torq_27062022.csv');

data=tempData(2:end-1,:);
yTorqFb = data(:,12)/1000*2.37; %Nm

threshold = 1;
firstIndex = [];

for i = 1:length(yTorqFb)
    if yTorqFb(i) > threshold
        firstIndex = [firstIndex  i];
    end
end
IndexEnd = firstIndex(1)+range/2;

data1=tempData(IndexEnd-range:IndexEnd,:);
data2=tempData(IndexEnd:IndexEnd+range,:);
data3=tempData(IndexEnd+range:IndexEnd+2*range,:);
data4=tempData(IndexEnd+2*range:IndexEnd+3*range,:);
data5=tempData(IndexEnd+3*range:IndexEnd+4*range,:);

velocity1  = data1(:,30)/10000*5/60;   %m-m/s
velocity2  = data2(:,30)/10000*5/60;   %m-m/s
velocity3  = data3(:,30)/10000*5/60;   %m-m/s
velocity4  = data4(:,30)/10000*5/60;   %m-m/s
velocity5  = data5(:,30)/10000*5/60;   %m-m/s

torque1 = data1(:,12)/1000*2.37; %Nm
torque2 = data2(:,12)/1000*2.37; %Nm
torque3 = data3(:,12)/1000*2.37; %Nm
torque4 = data4(:,12)/1000*2.37; %Nm
torque5 = data5(:,12)/1000*2.37; %Nm

numOfData = min([size(data1,1),size(data2,1),size(data3,1),size(data4,1),size(data5,1)]);

N = 1:1:numOfData; % number of data

w_r = 1/numOfData/sampleTime*1000; % frequency resolution
w_m = numOfData/2*w_r; % highest frequency content of the measured signal
freq = w_r*(0:numOfData/2);  %create the x-axis of frequencies in Hz

torqueData = [torque1(N), torque2(N), torque3(N), torque4(N), torque5(N)];
velocityData = [velocity1(N), velocity2(N), velocity3(N), velocity4(N), velocity5(N)];

K  = size(torqueData,2);                                     % number of trials.
N  = size(torqueData,1);                                     % umber of indices per trial.
SFF = zeros(N,K);                            
Sxx = zeros(N,K);
SxF = zeros(N,K);
for k=1:K                                                   % Compute the spectra for each trial.
    SFF(:,k) = fft(torqueData(:,k)) .* conj(fft(torqueData(:,k))); % power spectrum of x.
    Sxx(:,k) = fft(velocityData(:,k)) .* conj(fft(velocityData(:,k))); % power spectrum of y.
    SxF(:,k) = fft(velocityData(:,k)) .* conj(fft(torqueData(:,k))); %  cross spectrum.
end
L = 1:floor(N/2);  % only plot the first half of freqs

SFF = SFF(L,:)';                               % Ignore the negative frequencies.
Sxx = Sxx(L,:)';
SxF = SxF(L,:)';

meanSFF = mean(SFF,1);                                  % Average the spectra across trials.
meanSxx = mean(Sxx,1);
meanSxF = mean(SxF,1);

coherence = abs(meanSxF) ./ (sqrt(meanSFF) .* sqrt(meanSxx));        % Compute the coherence.


frf = meanSxF./meanSFF;

subplot(4,1,1)
semilogx(freq(L),meanSFF(L)/N,'LineWidth',1.5)
title('Power Spectra of Torque')
legend('PSD of torque')
% xlabel('frequency [Hz]')
ylabel('[N^2*m^2]')

subplot(4,1,2)
semilogx(freq(L),meanSxx(L)/N,'LineWidth',1.5)
title('Power Spectra of Velocity')
legend('PSD of velocity')
% xlabel('frequency [Hz]')
ylabel('[rad^2/s^2]')

subplot(4,1,3)
semilogx(freq(L),abs(frf(L)),'LineWidth',2)
hold on
title('Frequency Response')
legend('frequency response')
% xlabel('frequency [Hz]')
ylabel('abs')

subplot(4,1,4)
semilogx(freq(L),coherence(L),'LineWidth',1.5)
title('Coherence')
legend('coherence')
xlabel('frequency [Hz]')

toc
