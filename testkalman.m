% close all
% tempData=readmatrix('20220127_Yaxis_Torque_Excitation_Variable_Amplitude_0.6.csv');
% data=tempData(6:end,:);
% 
% yPosFb = data(:,10)*5/1048576; yPosFb(end) = []; %mm
% yVelFb  = data(:,16)/10000*2*pi/60; yVelFb(end) = [];   %rad/s
% yTorqFb = data(:,22)/1000*2.37; yTorqFb(end) = [];%Nm 

x_estimated = zeros(length(yTorqFb),1); x_estimated(1) = yPosFb(1);
w_estimated = zeros(length(yTorqFb),1); w_estimated(1) = yVelFb(1);
d_estimated = zeros(length(yTorqFb),1);

for k = 1:length(yTorqFb)-1
estimated_state = (eye(3)-Kobs*C)*A*[x_estimated(k);w_estimated(k);d_estimated(k)]...
    +(eye(3)-Kobs*C)*B*yTorqFb(k) + Kobs*[yPosFb(k+1);yVelFb(k+1)];

x_estimated(k) = estimated_state(1);
w_estimated(k) = estimated_state(2);
d_estimated(k) = estimated_state(3);

end     

plot(yPosFb); hold on; plot(x_estimated*5)