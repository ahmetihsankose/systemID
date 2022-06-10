clc,clear,close all
tic
tempData=readmatrix('../ScopeResults/20220530_Y_Axis_LeastSquare_0.6Nm_100ms.csv');
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

[inertia,viscousDamping,coulombTorquePositive,coulombTorqueNegative] = leastSquare(torque,velocity);


simTime = samplingTime*(length(torque)-1);
torqueInput.time = 0:samplingTime:simTime;
torqueInput.signals.values = torque;
out = sim('torqueMode.slx',simTime);

%%% plot
figure(1);
plot(out.tout,out.yout,'LineWidth',1.5)
hold on
plot(out.tout,velocity,'LineWidth',1.5)
xlabel('time [ms]'), ylabel('velocity [rad/s]')
legend('simulink result','experimental result')
set(gca,'FontSize',11)
set(gcf,'Position',[600 300 800 480])
toc
