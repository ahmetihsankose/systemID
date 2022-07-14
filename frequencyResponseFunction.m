% clc,clear,
tic
addpath('/home/kose/matlab/Scope/TestData')
tempData=readmatrix('sineSweept_y_Axis_torqueMode_0To70Hz_2tor_05sample_27062022.csv');
data=tempData(6:end-1,:);
sampleTime = 0.0005; %%% seconds


axis = 'Y';
switch axis
    case 'X'
        velocity  = data(:,24)/10000*5/60;     %mm/s
        torque = data(:,18)/1000*2.37; %Nm
    case 'Y'
        velocity  = data(:,30)/10000*5/60;   %m-m/s
        torque = data(:,12)/1000*2.37; %Nm
end


N = length(torque); % number of data
w_r = 1/N/sampleTime; % frequency resolution
w_m = N/2*w_r; % highest frequency content of the measured signal
freq = w_r*(0:N/2);  %create the x-axis of frequencies in Hz


torqueHat = fft(torque,N);
velocityHat = fft(velocity,N);

x = velocityHat;
F = torqueHat;

% Fh = hann(length(F)).*F; 
% xh = hann(length(x)).*x;                            % Hann taper
% Sxx_xh = fft(xh).*conj(fft(xh))/N;
% Sxx_Fh = fft(Fh).*conj(fft(Fh))/N;
% SxF_h = fft(xh).*conj(fft(Fh))/N;
% frf_h = SxF_h./Sxx_Fh;

SFF = F.*conj(F)/N;  % Power spectrum (how much power in each freq)
Sxx = x.*conj(x)/N;  % Power spectrum (how much power in each freq)
SxF = x.*conj(F)/N;   % Cross Power Spectrum
SFx = F.*conj(x)/N;   % Cross Power Spectrum

frf = SxF./SFF;

L = 1:floor(N/2);  % only plot the first half of freqs

coherence = abs(SxF) ./ (sqrt(SFF) .* sqrt(Sxx));

subplot(3,1,1)
semilogx(freq(L),SFF(L),'LineWidth',1.5)
hold on
% semilogx(freq(L),Sxx_Fh(L),'LineWidth',1.5)
title('Power Spectra of Torque')
% legend('PSD of torque','hann taper')
% xlabel('frequency [Hz]')
ylabel('[N^2*m^2]')

subplot(3,1,2)
semilogx(freq(L),Sxx(L),'LineWidth',1.5)
hold on
% semilogx(freq(L),Sxx_Fh(L),'LineWidth',1.5)
% legend('PSD of velocity','hann taper')
title('Power Spectra of Velocity')
% xlabel('frequency [Hz]')
ylabel('[rad^2/s^2]')

subplot(3,1,3)
semilogx(freq(L),20*log10(abs(frf(L))),'LineWidth',1.5)
hold on
% semilogx(freq(L),abs(frf_h(L)),'LineWidth',1.5)
% legend('frequency response','hann taper window')
title('Frequency Response')
% xlabel('frequency [Hz]')
ylabel('magnitude [dB]')


toc
