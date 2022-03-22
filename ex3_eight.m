%%
clear all
close all
clc

%% Konstanten
g = 9.81; %m/s^2 Gravitationskonstante

%% Zeit
t_start = 0; % s
t_stop = 1; % s
t_step = 0.0005; % s

t = (t_start:t_step:t_stop); % s

%% IMU Position
r = [-150e-3,-150e-3,50e-3]./2;

%% Trajektorie Nummerisch
f = 1; %Hz

sx = (0.8 .* cos(2*pi*f*t)); % m
sy = (0.8 .* sin(2*pi*f*t) .* cos(2*pi*f*t)); % m
sz = (0.3 .* cos(2*pi*3*f*t)); % m

s_S_N = [sx', sy', sz'];

%% Berechnung lineare Größen nummerisch
[s_S_N, v_S_N, a_S_N] = my_lin(s_S_N, "num",t);

%% Gravitation
a_S_N = a_S_N + [0,0,-g];

%% Berechnung Tangentialwinkel
[phi_z, phi_y, phi_x, ta] = my_tang(v_S_N, t);

phi = [phi_x, phi_y, phi_z];

%% Berechnung Winkelgrößen nummerisch
[phi, omega, alpha] = my_ang(phi,"num",t);

%% Rotation der lineare Beschleunigung
[a_S_B] = my_rotate(phi, a_S_N, t); 

%% Berechnung IMU Daten
[a_I_B] = my_imu(a_S_B, omega, alpha, r, t);

a_IMU = a_I_B;
omega_IMU = omega; 

%% Plot Trajektorie
figure
plot3(sx,sy,sz,'-')
xlabel("s_x in m")
ylabel("s_y in m")
zlabel("s_z in m")

%% Plot lineare Größen
figure
subplot(3,1,1);
plot(t,s_S_N,'-')
xlabel("t in s")
ylabel("s in m")
legend('x','y','z');

subplot(3,1,2);
plot(t,v_S_N,'-')
xlabel("t in s")
ylabel("v in m/s")
legend('x','y','z');

subplot(3,1,3);
plot(t,a_S_N,'-')
xlabel("t in s")
ylabel("a in m/s^2")
legend('x','y','z');

%% Plot Winkelgrößen
figure
subplot(3,1,1);
plot(t,phi,'-')
xlabel("t in s")
ylabel("\phi in rad")
legend('x','y','z');

subplot(3,1,2);xlabel("t in s")
ylabel("s in m")
plot(t,omega,'-')
xlabel("t in s")
ylabel("\omega in rad/s")
legend('x','y','z');

subplot(3,1,3);
plot(t,alpha,'-')
xlabel("t in s")
ylabel("\alpha in rad/s^2")
legend('x','y','z');

%% Plot IMU-Daten
figure
subplot(2,1,1);
plot(t,omega_IMU,'-')
xlabel("t in s")
ylabel("\omega in rad/s")
legend('x','y','z');

subplot(2,1,2);
plot(t,a_IMU,'-')
xlabel("t in s")
ylabel("a in m/s^2")
legend('x','y','z');

%% Animation
body.width  = 150e-3;
body.length = 150e-3;
body.heigth = 50e-3;
body.r = r;

figure
tmr = my_traAnim(t, s_S_N, phi, body);
%start(tmr);
%stop(tmr);