%% EXPERIMENT 6 - SIMULATION OF HEART DYNAMICS
clear; 
close all; 
clc;
%% INPUT PARAMETERS
HR=72; % beats/min
tau=0.20; % time constant (s)
Tend=10; % simulation time
dt=0.001; % step size
baseline=40; % mmHg
peak=120; % mmHg
t=0:dt:Tend;
f=HR/60;
%% PERIODIC CARDIAC ACTIVATION
activation=0.5*(1+square(2*pi*f*t,20));
%% INITIAL PRESSURE
P=zeros(size(t));
P(1)=baseline;
%% DYNAMIC EQUATION
for k=2:length(t)
    target=baseline+(peak-baseline)*activation(k);
    dPdt=(target-P(k-1))/tau;
    P(k)=P(k-1)+dt*dPdt;
end
%% FIGURE 1
figure('Name','Cardiac Activation');
plot(t,activation,'LineWidth',1.1);
grid on;
xlabel('Time (s)');
ylabel('Activation');
title('Simplified Cardiac Activation');
%% FIGURE 2
figure('Name','Simulated Pressure');
plot(t,P,'LineWidth',1.2);
grid on;
xlabel('Time (s)');
ylabel('Pressure (mmHg)');
title('Simplified Heart Dynamics');
%% NUMERICAL OBSERVATIONS
fprintf('\n===== HEART DYNAMICS OBSERVATIONS =====\n');
fprintf('Heart rate = %.1f bpm\n',HR);
fprintf('Time constant = %.3f s\n',tau);
fprintf('Mean pressure = %.2f mmHg\n',mean(P));
fprintf('Maximum pressure = %.2f mmHg\n',max(P));
fprintf('Minimum pressure = %.2f mmHg\n',min(P));
%% PARAMETER COMPARISON
HRset=[60 72 90];
figure('Name','Heart Rate Comparison');
hold on;
for h=HRset
    f2=h/60;
    a2=0.5*(1+square(2*pi*f2*t,20));
    plot(t,a2,'DisplayName',sprintf('%d bpm',h));
end
grid on;
xlabel('Time (s)');
ylabel('Activation');
title('Effect of Heart Rate');
legend('Location','best');
