%%
clear all
close all
clc

%% Konstanten
g = 9.81; %m/s^2 Gravitationskonstante

%% Zeit
t_start = 0; % s
t_stop = 4.7854; % s
t_step = 0.0005; % s

t = (t_start:t_step:t_stop); % s

%% IMU Position
r = [0,0,0]./2; % IMU im Schwerpunkt

%% Trajektorie Nummerisch
v = 0.8; % Geschwindigkeit
rad = 0.1; % Radius der Rundung
omega_ = v / rad; % Winkelgeschwindigkeit in den Rundungen

w2 = 0.5; % Halbe Breite des Rechtecks
h2 = 0.5; % Halbe Höhe des Rechtecks

% 1. line 1
t0 = 0;
st0 = -(w2-rad);
s01 = st0 - v * t0;

st1 = w2-rad;
t1 = (st1 - s01) / v;

% 2. circle 1
t2 = t1 + 2*pi/(4*omega_);
phi2 = - omega_ * t1;

% 3. line 2
st2 = (h2-rad);
s02 = st2 + v * t2;

st3 = -(h2-rad);
t3 = (st3 - s02) / (-v);

% 4. circle 2
t4 = t3 + 2*pi/(4*omega_);
phi4 = - omega_ * t3;

% 5. line 3
st4 = (w2-rad);
s04 = st4 + v * t4;

st5 = -(w2-rad);
t5 = (st5 - s04) / (-v);

% 6. circle 3
t6 = t5 + 2*pi/(4*omega_);
phi6 = - omega_ * t5;

% 7. line 4
st6 = -(h2-rad);
s06 = st6 - v * t6;

st7 = (h2-rad);
t7 = (st7 - s06) / (v);

% 8. circle 4
t8 = t7 + 2*pi/(4*omega_);
phi8 = - omega_ * t8;



sx =    ( s01 + v .* t) .* (t >= t0 & t < t1) +...
        ( rad*sin(omega_*t + phi2) + (+w2-rad)) .* (t >= t1 & t <= t2) +...
        ( w2 + 0.0 .* t) .* (t > t2 & t < t3) + ...
        ( rad*cos(omega_*t + phi4) + (+w2-rad) ) .* (t >= t3 & t <= t4) +...
        ( s04 - v .* t) .* (t > t4 & t < t5) + ...
        (-rad*sin(omega_*t + phi6) + (-w2+rad) ) .* (t >= t5 & t <= t6) + ...
        (-w2 - 0.0 .* t) .* (t > t6 & t < t7) + ...
        ( rad*sin(omega_*t + phi8) + (-w2+rad) ) .* (t >= t7 & t <= t8);
        
    
sy =    ( h2 + 0.0 .* t) .* (t >= 0 & t < t1) +...
        ( rad*cos(omega_*t + phi2) + (+h2-rad) ) .* (t >= t1 & t <= t2) + ...
        ( s02 - v .* t) .* (t > t2 & t < t3) +...
        (-rad*sin(omega_*t + phi4) + (-h2+rad) ) .* (t >= t3 & t <= t4) +...
        (-h2 + 0.0 .* t) .* (t > t4 & t < t5) + ...
        (-rad*cos(omega_*t + phi6) + (-h2+rad) ) .* (t >= t5 & t <= t6) + ...
        ( s06 + v .* t) .* (t > t6 & t < t7) + ...
        ( rad*cos(omega_*t + phi8) + (+h2-rad) ) .* (t >= t7 & t <= t8);



sz =    0.0 .* t; % m

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
plot(sx,sy,'-')
xlabel("s_x in m")
ylabel("s_y in m")
xlim([-0.6,0.6]);
ylim([-0.6,0.6]);

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