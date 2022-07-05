function [frequency,frequencyResponseFunction] = frf(torque,velocity,sampleTime)

N = length(torque); % number of data
w_r = 1/N/sampleTime; % frequency resolution
w_m = N/2*w_r; % highest frequency content of the measured signal

L = 1:floor(N/2);  % only plot the first half of freqs
freq = w_r*(0:N/2);  %create the x-axis of frequencies in Hz

torqueHat = fft(torque,N);
velocityHat = fft(velocity,N);

F = torqueHat;
x = velocityHat;

SFF = F.*conj(F)/N;  % Power spectrum (how much power in each freq)
Sxx = x.*conj(x)/N;  % Power spectrum (how much power in each freq)
SxF = x.*conj(F)/N;   % Cross Power Spectrum
SFx = F.*conj(x)/N;   % Cross Power Spectrum

frf = SxF./SFF;
frequencyResponseFunction = frf(L);
frequency = freq(L);
end