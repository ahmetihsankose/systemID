close, clear, clc
tempData=readmatrix('20220218_Yaxis_Torque_Excitation_Sinus_Amplitude_0.7.csv');
data=tempData(6:end,:);

yTorqFb = data(:,22)/1000*2.37; %N*m
yVelFb  = data(:,16)/10000*2*pi/60;      %rad/s

yTorqFb(end) = 0;
yVelFb(end) = 0;

Td = 0.495;
yTorqss = yTorqFb-Td*sign(yVelFb); 

T = fft(yTorqss);
W = fft(yVelFb );

data = iddata(yVelFb,yTorqss,0.001);

ge = etfe(data);
gs = spa(data);

bode(ge,gs)
etfe_bandwidth = bandwidth(ge);
spa_bandwidth = bandwidth(gs);
legend('etfe','spa')

% [mag,phase,wout] = bode(ge);
% [mag1,phase1,wout1] = bode(gs);
% figure(1)
% subplot(2,1,1)
% semilogx(wout, 20*log10(squeeze(mag)), '-b', 'LineWidth',1)
% hold on
% semilogx(wout1, 20*log10(squeeze(mag1)), '-r', 'LineWidth',2)
% legend('etfe','spa')
% grid
% subplot(2,1,2)
% semilogx(wout, squeeze(phase), '-b', 'LineWidth',1)
% hold on
% semilogx(wout1, squeeze(phase1), '-r', 'LineWidth',2)
% legend('etfe','spa')
% grid

