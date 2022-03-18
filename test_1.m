%%
clear all
close all
clc

%% Zeit
t_start = 0; % s
t_stop = 5; % s
t_step = 0.005; % s

t = (t_start:t_step:t_stop); % s

%% Frequenz
f = 1; % Hz

%% Trajektorie
sx = 0.8 * 5 .* cos(2*pi*f*t); % m
sy = 0.8 * 5 .* sin(2*pi*f*t); % m
sz = 0.3 * 5 .* cos(2*pi*f*t); % m

s = [sx', sy', sz'];

%% Position IMU
r = [-150e-3,-150e-3,50e-3]./2; % m

%% Berechnung lineare Größen
[s_S_N, v_S_N, a_S_N] = my_lin(s,"num",t);
% lineare Größen im Schwerpunkt S und referenzerit auf das Inertialsystem N

%% Berechnung Tangentialwinkel
[phi_tz, phi_ty, phi_tx, ta] = my_tang(v_S_N, t);

phi = [phi_tx, phi_ty, phi_tz];

%% Berechnung Wineklgrößen
[phi, omega, alpha] = my_ang(phi,"num",t); 
% Winkelgrößen des starren Körpers (sind am gesammten Körper ident)

%% Rotation der lineare Beschleunigung
[a_S_B] = my_rotate(phi, a_S_N, t); 
% lineare Beschleunigung im Schwerpunkt S und referenzerit auf das Körperkoorinatensystem B

%% Berechnung IMU Daten
[a_I_B] = my_imu(a_S_B, omega, alpha, r, t);

% a_I_B entspricht gemessenen Beschleunigung der IMU
a_IMU = a_I_B;
% omega entspricht der gemessenen Winkelgeschwindigkeit der IMU
omega_IMU = omega; 