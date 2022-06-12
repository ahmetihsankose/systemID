clc,clear,close all
tic
tempData=readmatrix('../ScopeResults/20220531_Y_Axis_Pulse_9Nm_10ms.csv');
data=tempData(6:end,:);
samplingTime = 0.001;

axis = 'Y';
switch axis
    case 'X'
        velocity  = data(:,14)/10000*5/60; velocity(end) = [];   %mm/s
        torque = data(:,20)/1000*2.37; torque(end) = [];  %Nm
    case 'Y'
        velocity  = data(:,16)/10000*5/60; velocity(end) = [];   %mm/s
        torque = data(:,22)/1000*2.37; torque(end) = [];  %Nm
end

N = length(torque); % number of data
w_r = N*samplingTime/2/pi; % frequency resolution
w_m = N/2*w_r; % highest frequency content of the measured signal
freq = w_r*(0:N/2);  %create the x-axis of frequencies in Hz

torqueHat = fft(torque,N);
velocityHat = fft(velocity,N);

x = velocityHat;
F = torqueHat;

PSD_F = F.*conj(F)/N;  % Power spectrum (how much power in each freq)
PSD_x = x.*conj(x)/N;  % Power spectrum (how much power in each freq)
CPS_xF = x.*conj(F)/N;   %% Cross Power Spectrum
CPS_Fx = F.*conj(x)/N;   %% Cross Power Spectrum

frf = CPS_xF./PSD_F;

L = 1:floor(N/2);  % only plot the first half of freqs

coherence = abs(CPS_xF) ./ (sqrt(PSD_F) .* sqrt(PSD_x));

subplot(4,1,1)
plot(PSD_F(L),'LineWidth',1.5), hold on
legend('PSD of torque')

subplot(4,1,2)
plot(PSD_x(L),'LineWidth',1.5), hold on
legend('PSD of velocity')

subplot(4,1,3)
plot(real(frf(L)),'LineWidth',1.5)
legend('frequency response')

subplot(4,1,4)
plot(coherence,'LineWidth',1.5)
legend('coherence')

