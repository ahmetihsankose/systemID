clc,clear, 
close all
tempData=readmatrix('../ScopeResults/20220530_Y_Axis_LeastSquare_0.6Nm_100ms.csv');
data=tempData(6:end-1,:);



time    = data(:,1)/1000;      % s
xPosRef = data(:,2)*5/1048576; % mm
yPosRef = data(:,4)*5/1048576; % mm
zPosRef = data(:,6)*5/1048576; % mm

xPosFb = data(:,8)*2*pi/1048576; %rad
yPosFb = data(:,10)*5/1048576; %mm
zPosFb = data(:,12)*5/1048576; %mm

xVelFb  = data(:,14)/10000*5/60;     %mm/s
yVelFb  = data(:,16)/10000*5/60;      %mm/s
zVelFb  = data(:,18)/10000*5/60;      %mm/s

xTorqFb = data(:,20)/1000*2.37; %Nm
yTorqFb = data(:,22)/1000*2.37; %Nm
zTorqFb = data(:,24)/1000*2.37; %Nm

xCurrFb = data(:,26); %A
yCurrFb = data(:,28); %A
zCurrFb = data(:,30); %A

xVelFF = data(:,32)/10000*5/60; % mm/s
yVelFF = data(:,34)/10000*5/60; % mm/s   
zVelFF = data(:,36)/10000*5/60; % mm/s

xTorqFF= data(:,38)/1000*2.37;  % N-m
yTorqFF= data(:,40)/1000*2.37;  % N-m
zTorqFF= data(:,42)/1000*2.37;  % N-m

xPosErr = data(:,44)*5000/1048576; %micrometer
yPosErr = data(:,46)*5000/1048576; %micrometer
zPosErr = data(:,48)*5000/1048576; %micrometer

xTorqDemand = data(:,50); %N-m
yTorqDemand = data(:,52); %N-m
zTorqDemand = data(:,54); %N-m

xTorqTarget = data(:,56)/1000*2.37; %N-m
yTorqTarget = data(:,58)/1000*2.37; %N-m
zTorqTarget = data(:,60)/1000*2.37; %N-m


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

% Current feedback
figure
plot(time,zCurrFb)
hold on
plot(time,yCurrFb)
plot(time,xCurrFb)
title('Actual current of X, Y and Z axes')
ylabel('Current (A)')
xlabel('Time (s)')
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
plot3(xPosRef,yPosRef,zPosFb,'k','linewidth',2)
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

