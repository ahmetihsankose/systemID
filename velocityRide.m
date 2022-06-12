close all
tic
tempData=readmatrix('../ScopeResults/20220530_Y_Axis_VelocityRide_velocityMode_2.csv');
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

torquePos = [];
velocityPos = [];
torqueNeg = [];
velocityNeg = [];

for i=1:length(velocity)
    if velocity(i) > 0.5
        torquePos = [torquePos torque(i)];
        velocityPos = [velocityPos velocity(i)];
    elseif velocity(i) < -0.5
        torqueNeg = [torqueNeg torque(i)];
        velocityNeg = [velocityNeg velocity(i)];
    end
end

smoothFactor = .9;
filteredTorquePos = smoothdata(torquePos,'SmoothingFactor',smoothFactor);
filteredVelocityPos = smoothdata(velocityPos,'SmoothingFactor',smoothFactor);
filteredTorqueNeg = smoothdata(torqueNeg,'SmoothingFactor',smoothFactor);
filteredVelocityNeg = smoothdata(velocityNeg,'SmoothingFactor',smoothFactor);

resultFitPos = polyfit(filteredVelocityPos,filteredTorquePos,1);
resultFitNeg = polyfit(filteredVelocityNeg,filteredTorqueNeg,1);

f = figure(1);
f.Position = [150 150 1200 480];
subplot(1,2,1)
plot(torquePos)
hold on
plot(filteredTorquePos,'-r','Linewidth',2)
title('Torque')
ylabel('Torque [N*m]')
legend('main positive direction data','filtered data')
hold off 

subplot(1,2,2)
y1 = polyval(resultFitPos,filteredVelocityPos);
plot(filteredVelocityPos,y1,'Linewidth',4)
hold on
plot(filteredVelocityPos,filteredTorquePos,'-r','Linewidth',2)
title('Y Ekseni Velocity vs Torque')
xlabel('velocity [rad/s]'); ylabel('Torque [N*m]')
legend('fitting curve','filtered data')
hold off

f = figure(2);
f.Position = [150 150 1200 480];
subplot(1,2,1)
plot(torqueNeg)
hold on
plot(filteredTorqueNeg,'-r','Linewidth',2)
title('Torque')
ylabel('Torque [N*m]')
legend('main negative direction data','filtered data')
hold off 

subplot(1,2,2)
y2 = polyval(resultFitNeg,filteredVelocityNeg);
plot(filteredVelocityNeg,y2,'Linewidth',4)
hold on
plot(filteredVelocityNeg,filteredTorqueNeg,'-r','Linewidth',2)
title('Y Ekseni Velocity vs Torque')
xlabel('velocity [rad/s]'); ylabel('Torque [N*m]')
legend('fitting curve','filtered data')
hold off

viscousDampingPos = resultFitPos(1);
coulombFrictionPos = resultFitPos(2);
viscousDampingNeg = resultFitNeg(1);
coulombFrictionNeg = resultFitNeg(2);

viscousDamping = (viscousDampingPos+viscousDampingNeg)/2;
table(coulombFrictionPos,coulombFrictionNeg,viscousDamping)

toc
