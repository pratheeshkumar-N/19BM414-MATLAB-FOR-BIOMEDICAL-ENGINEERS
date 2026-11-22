%% EXPERIMENT 7 - BLOOD PRESSURE REGULATION
clear; 
close all; 
clc;
%% INPUT PARAMETERS
dt=0.01;
t=0:dt:60;
Pref=100; % reference BP
P0=90; % initial BP
K=2; % feedback gain
tau=5; % time constant
%% DISTURBANCE
disturbance=zeros(size(t));
disturbance(t>=20 & t<=30)=-15;
%% INITIALIZE
P=zeros(size(t));
P(1)=P0;
control=zeros(size(t));
%% CLOSED-LOOP MODEL
for k=2:length(t)
    errorSignal=Pref-P(k-1);
    control(k)=K*errorSignal;
    dPdt=(control(k)+disturbance(k)-...
        (P(k-1)-Pref))/tau;
    P(k)=P(k-1)+dt*dPdt;
end
%% RESPONSE
figure('Name','Blood Pressure Response');
plot(t,Pref*ones(size(t)),'k--','LineWidth',1.2);
hold on;
plot(t,P,'LineWidth',1.2);
grid on;
xlabel('Time (s)');
ylabel('Pressure (mmHg)');
title('Simplified Blood Pressure Regulation');
legend('Reference','Controlled pressure');
%% CONTROL AND DISTURBANCE
figure('Name','Control Signal');
plot(t,disturbance,'r','LineWidth',1.1);
hold on;
plot(t,control,'b','LineWidth',1.1);
grid on;
xlabel('Time (s)');
ylabel('Model amplitude');
title('Disturbance and Feedback Control');
legend('Disturbance','Control');
%% OBSERVATIONS
during=(t>=20 & t<=30);
fprintf('\n===== BP OBSERVATIONS =====\n');
fprintf('Reference BP = %.1f mmHg\n',Pref);
fprintf('Feedback gain = %.2f\n',K);
fprintf('Minimum BP during disturbance = %.2f mmHg\n',min(P(during)));
fprintf('Final BP = %.2f mmHg\n',P(end));
%% GAIN STUDY
Kset=[0.5 1 2 4];
figure('Name','Gain Comparison');
hold on;
for Kg=Kset
    Pg=zeros(size(t));
    Pg(1)=P0;
    for k=2:length(t)
        e=Pref-Pg(k-1);
        u=Kg*e;
        dPg=(u+disturbance(k)-...
            (Pg(k-1)-Pref))/tau;
        Pg(k)=Pg(k-1)+dt*dPg;
    end
    plot(t,Pg,'DisplayName',sprintf('K = %.1f',Kg));
end
yline(Pref,'k--','Reference');
grid on;
xlabel('Time (s)');
ylabel('Pressure (mmHg)');
title('Effect of Feedback Gain');
legend('Location','best');
