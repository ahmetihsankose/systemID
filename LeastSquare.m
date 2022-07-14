clc,clear,close all
tic
tempData=readmatrix('../ScopeResults/20220530_Y_Axis_LeastSquare_0.6Nm_100ms.csv');
data=tempData(6:end,:);
sampleTime = 0.001;

axis = 'Y';
switch axis
    case 'X'
        velocity  = data(:,14)/10000*5/60; velocity(end) = [];   %mm/s
        torque = data(:,20)/1000*2.37; torque(end) = [];  %Nm
    case 'Y'
        velocity  = data(:,16)/10000*5/60; velocity(end) = [];   %mm/s
        torque = data(:,22)/1000*2.37; torque(end) = [];  %Nm
end

w = velocity*2*pi/5; % rad/s
Tm = torque;

deadBand = .7;
signum = zeros(size(w));
for k=1:length(w)
    if abs(w(k)) <= deadBand
        signum(k) = 0;
    elseif w(k) > deadBand
        signum(k) = 1;
    elseif w(k) < deadBand
        signum(k) = -1;
    end
end

posVel = 1/2*signum.*(1+signum);
negVel = -1/2*signum.*(1-signum);

Y = w(2:end,1);
phi = [w(1:end-1,1) Tm(1:end-1,1) -posVel(1:end-1,1) -negVel(1:end-1,1)];
theta = pinv(phi'*phi)*phi'*Y;

p_wd = theta(1);
p_w = log(p_wd)/sampleTime;
K_wd = theta(2);
K_w = K_wd*-p_w/(1-p_wd);

inertia = 1/K_w;
viscousDamping = -inertia*p_w;
coulombTorquePositive = theta(3)/theta(2);
coulombTorqueNegative = theta(4)/theta(2);

table(inertia,coulombTorquePositive,coulombTorqueNegative,viscousDamping)