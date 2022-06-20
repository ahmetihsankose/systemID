clc,clear
run('PlotScript_v2_3Axes.m');
run('LeastSquares_v3.m');
Ts = 0.001;             % sampling time
rg = 5 / (2 * pi);      % lead screw gain mm/rad

% Rx = 1.89478 * 10^(-12);        % position variance (mm)^2
% Ru = 4.68 * 10^(-7);            % input torque variance (N-m)^2
% Rwd = 0.01                     % disturbance variance (N-m)^2
Rw = 50*10^-3;            % velocity variance (rad/s)^2

Ru = 7.761*10^-9;
Rx = 4.9671*10^-7;
Rwd = 0.01;

R_w = [ Ru      0
        0       Rwd];
    
R_v = [ Rx      0
        0       Rw];
    
Ac = [  0   rg
        0   Pw];
    
Bc = [  0
        Kw];
   
    
    
Ad = expm(Ac*Ts); 

f = @(lambda) expm(Ac.*lambda);

Bd = integral(f,0,0.001,'ArrayValued',true)*Bc;

A = [   Ad              -Bd
        0       0       1];
 
B = [   Bd 
        0   ];
    
C=  [   1       0       0
        0       1       0];
 
W = [   Bd(1)   0       
        Bd(2)   0
        0       1];
    
V = [   1       0
        0       1];
    
    
% Iterations 

P = 100*eye(3,3);

for i=1:40
    P1 = A*P*A'+W*R_w*W';
    Kobs = P1*C'*inv(R_v+C*P1*C')
    P2 = (eye(3,3)-Kobs*C)*P1;
    P = P2;
end

    
