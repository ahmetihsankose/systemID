% averaged power spectrum

clc,clear,
tic
tempData=readmatrix('../ScopeResults/20220531_Y_Axis_Pulse_9Nm_10ms.csv');
tempData1=readmatrix('../ScopeResults/20220531_Y_Axis_Pulse_9Nm_10ms_doublet.csv');
tempData2=readmatrix('../ScopeResults/20220531_Y_Axis_Pulse_6Nm_10ms.csv');
data=tempData(6:end,:);
data1=tempData1(6:end,:);
data2=tempData2(6:end,:);

samplingTime = 0.001;

axis = 'Y';
switch axis
    case 'X'
        velocity  = data(:,14)/10000*5/60; velocity(end) = [];   %mm/s
        torque = data(:,20)/1000*2.37; torque(end) = [];  %Nm
    case 'Y'
        velocity  = data(:,16)/10000*5/60; velocity(end) = [];   %mm/s
        torque = data(:,22)/1000*2.37; torque(end) = [];  %Nm

        velocity1  = data1(:,16)/10000*5/60; velocity1(end) = [];   %mm/s
        torque1 = data1(:,22)/1000*2.37; torque1(end) = [];  %Nm

        velocity2  = data2(:,16)/10000*5/60; velocity2(end) = [];   %mm/s
        torque2 = data2(:,22)/1000*2.37; torque2(end) = [];  %Nm
end
N = 1:1:length(torque1); % number of data

torqueData = [torque(N), torque1(N), torque2(N)];
velocityData = [velocity(N), velocity1(N), velocity2(N)];

K  = size(torqueData,2);                                     % Define the number of trials.
N  = size(torqueData,1);                                     % Define the number of indices per trial.
SFF = zeros(N,K);                                   % Create variables to save the spectra.
Sxx = zeros(N,K);
SxF = zeros(N,K);
for k=1:K                                                   % Compute the spectra for each trial.
    SFF(:,k) = fft(torqueData(:,k)) .* conj(fft(torqueData(:,k))); % ... power spectrum of x.
    Sxx(:,k) = fft(velocityData(:,k)) .* conj(fft(velocityData(:,k))); % ... power spectrum of y.
    SxF(:,k) = fft(velocityData(:,k)) .* conj(fft(torqueData(:,k))); % ... cross spectrum.
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
plot(meanSFF(L),'LineWidth',1.5)
legend('PSD of torque')

subplot(4,1,2)
plot(meanSxx(L),'LineWidth',1.5)
legend('PSD of velocity')

subplot(4,1,3)
plot(real(frf(L)),'LineWidth',1.5)
legend('frequency response')

subplot(4,1,4)
plot(coherence(L),'LineWidth',1.5)
legend('coherence')



toc