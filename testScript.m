clear
tempData=readmatrix('../ScopeResults/20220530_Y_Axis_LeastSquare_0.6Nm_100ms.csv');
data=tempData(6:end,:);

axis = 'Y';
switch axis
    case 'X'
        velocity  = data(:,14)/10000*5/60; velocity(end) = [];   %mm/s
        torque = data(:,20)/1000*2.37; torque(end) = [];  %Nm
    case 'Y'
        velocity  = data(:,16)/10000*5/60; velocity(end) = [];   %mm/s
        torque = data(:,22)/1000*2.37; torque(end) = [];  %Nm
end

[inertia,viscousDamping,coulombTorquePositive,coulombTorqueNegative] = leastSquare(torque,velocity);

clearvars -except coulombTorquePositive coulombTorqueNegative inertia viscousDamping

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

simTime = sampleTime*(length(torque)-1);
torqueInput.time = 0:sampleTime:simTime;
torqueInput.signals.values = torque;
out = sim('Copy_of_torqueMode.slx',simTime);

tempTorque = out.simout1;
tempVelocity = out.simout;

[freq1,frf1] = frf(torque,velocity,sampleTime);
[freq2,frf2] = frf(tempTorque,velocity,sampleTime);

sys = tf(1,[inertia,viscousDamping]);

% bode
[mag,phase,wout] = bode(sys);

% plot results, with frequency expressed at Hz

% figure;
% subplot(2,1,1);
% semilogx(wout(:,1)/(2*pi), 20*log10(squeeze(mag)), '-b'); zoom on; grid on; 
% title('magnitude'); xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
% subplot(2,1,2);
% semilogx(wout(:,1)/(2*pi), squeeze(phase), '-r'); zoom on; grid on; 
% title('Phase'); xlabel('Frequecy (Hz)'); ylabel('Phase (deg)');

figure(1)
semilogx(wout(:,1)/(2*pi),20*log10(squeeze(mag)),'b','LineWidth',3)
hold on
semilogx(freq1,20*log10(abs(frf1)),'k','LineWidth',2)
semilogx(freq2,20*log10(abs(frf2)),'--r','LineWidth',2)
legend('first order','input torque','derived torque')
xlabel('frquency [Hz]')
ylabel('magnitude [dB]')
