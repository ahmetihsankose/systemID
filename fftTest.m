tic
close all
axis = 'X';
switch axis
    case 'X'
        velocity  = yVelFb;   %mm/s
        torque = yTorqFb;  %Nm
    case 'Y'
        velocity  = xVelFb;   %mm/s
        torque = xTorqFb;  %Nm
end

N = length(torque); % number of data


sss = 1; %%%% select 2*pi for rad/s
w_r = sss/N/sampleTime; % frequency resolution
w_m = N/2*w_r; % highest frequency content of the measured signal
freq = w_r*(0:N/2);  % create the x-axis of frequencies in rad/s                              


torqueHat = fft(torque,N);
velocityHat = fft(velocity,N);

x = velocityHat;
F = torqueHat;

SFF = F.*conj(F)/N;  % Power spectrum (how much power in each freq)
Sxx = x.*conj(x)/N;  % Power spectrum (how much power in each freq)
SxF = x.*conj(F)/N;   %% Cross Power Spectrum
SFx = F.*conj(x)/N;   %% Cross Power Spectrum

frf = SxF./SFF;

L = 1:floor(N/2);  % only plot the first half of freqs

coherence = abs(SxF) ./ (sqrt(SFF) .* sqrt(Sxx));

subplot(4,1,1)
plot(freq(L),SFF(L),'LineWidth',1.5), hold on
legend('PSD of torque')

subplot(4,1,2)
plot(freq(L),Sxx(L),'LineWidth',1.5), hold on
legend('PSD of velocity')

subplot(4,1,3)
plot(freq(L),real(frf(L)),'LineWidth',1.5)
legend('frequency response')

subplot(4,1,4)
plot(freq(L),coherence(L),'LineWidth',1.5)
legend('coherence')



toc