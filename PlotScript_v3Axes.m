clc,clear, 
close all
tempData=readmatrix('../systemIDtest/sineSwept_x_Axis_torqueMode_0To500Hz_0_05tor_0_25bias_20062022.csv');
data=tempData(6:end-1,:);

sampleTime = 0.001; % s
time    = data(:,1)*sampleTime;      % s

xTorqTarget = data(:,2)/1000*2.37; %N-m
xTorqFF= data(:,4)/1000*2.37;  % N-m
xTorqFb = data(:,6)/1000*2.37; %Nm

yTorqTarget = data(:,8)/1000*2.37; %N-m
yTorqFF= data(:,10)/1000*2.37;  % N-m
yTorqFb = data(:,12)/1000*2.37; %Nm

zTorqTarget = data(:,14)/1000*2.37; %N-m
zTorqFF= data(:,16)/1000*2.37;  % N-m
zTorqFb = data(:,18)/1000*2.37; %Nm

xVelTarget = data(:,20)/1000*2.37; %m-m/s
xVelFF = data(:,22)/10000*5/60; % mm/s
xVelFb  = data(:,24)/10000*5/60;     %mm/s

yVelTarget = data(:,26)/1000*2.37; %m-m/s
yVelFF = data(:,28)/10000*5/60; % mm/s   
yVelFb  = data(:,30)/10000*5/60;   %m-m/s

zVelTarget = data(:,32)/1000*2.37; %m-m/s
zVelFF = data(:,34)/10000*5/60; % mm/s
zVelFb  = data(:,36)/10000*5/60;      %mm/s

xPosTarget = data(:,38)*5/1048576; % mm
xPosFF= data(:,40)/1000*2.37;  % N-m
xPosFb = data(:,42)*2*pi/1048576; %rad

yPosTarget = data(:,44)*5/1048576; % mm
yPosFF= data(:,46)/1000*2.37;  % N-m
yPosFb = data(:,48)*5/1048576; %mm

zPosTarget = data(:,50)*5/1048576; % mm
zPosFF= data(:,52)/1000*2.37;  % N-m
zPosFb = data(:,54)*5/1048576; %mm
 
%%%%%%%%

xPosErr = data(:,56)*5000/1048576; %micrometer
xVelObs = data(:,58)/1000*2.37; %m-m/s

yPosErr = data(:,60)*5000/1048576; %micrometer
yVelObs = data(:,62)/1000*2.37; %m-m/s

zPosErr = data(:,64)*5000/1048576; %micrometer
zVelObs = data(:,66)/1000*2.37; %m-m/s


% Velocity of Tooltip
figure
plot(time,sqrt(xVelFb.^2+yVelFb.^2+zVelFb.^2),'r','linewidth',1.1)
hold on 
title('Velocity of Tooltip')
ylabel('Velocity (mm/s)'),xlabel('Time (s)')
grid on

% Torque feedback
figure
plot(time,zTorqFb,'b','linewidth',1)
hold on 
plot(time,yTorqFb,'k','linewidth',1)
plot(time,xTorqFb,'r','linewidth',1)
title('Torque on each axis')
ylabel('Torque (N*m)'),xlabel('Time (s)')
legend('Z axis','Y axis','X axis')
grid on

% Velocity feedback
figure
plot(time,zVelFb,'b','linewidth',1.1)
hold on 
plot(time,yVelFb,'k','linewidth',1.1)
plot(time,xVelFb,'r','linewidth',1.1)
title('Velocity of each axis')
ylabel('Velocity (mm/s)'),xlabel('Time (s)')
legend('Z axis','Y axis','X axis')
grid on

% Ref vs Actual toolpath
figure
plot3(xPosTarget,yPosTarget,zPosTarget,'k','linewidth',2)
hold on 
plot3(xPosFb,yPosFb,zPosFb,'r--','linewidth',2)
axis equal
ylabel('Y position (mm)'),xlabel('X position (mm)')
legend('reference trajectory','actual trajectory')
title('Reference vs Actual Trajectory')
grid on

% Tracking error
figure
plot(time,zPosErr)
hold on
plot(time,yPosErr)
plot(time,xPosErr)
title('Tracking error on X, Y and Z axes'),ylabel('Error (\mum)'),xlabel('Time (s)')
grid on
legend('Z axis','Y axis','X axis')








