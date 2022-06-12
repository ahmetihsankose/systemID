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

hmax = 100;
vmax = 20;
amax = 10;
jmax = 10;

KinematicConstraints = [hmax vmax amax jmax];
[N, Q0, Ts] = firFilterParameter(KinematicConstraints,samplingTime);
