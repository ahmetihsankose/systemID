%%%% find transfer function
close all

u = xTorqFb; 
y = xVelFb;

data = iddata(y,u,0.001);
TF = tfest(data, 1, 0, 0)
[num, den] = tfdata(TF);

G = tf(num,den);

t = 0:0.001:(length(u)-1)/1000;

linear_model_velocity = lsim(G,u,t);

figure
plot(t,linear_model_velocity,'b')

hold on
plot(t,y,'r')
legend('model response','real response')