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

%% Berechnung lineare Größen
[s_N, v_N, a_N] = my_lin(s,"num",t);
% lineare Größen im Schwerpunkt S und referenzerit auf das Inertialsystem N

%% Berechnung Tangentialwinkel
[phi_tz, phi_ty, phi_tx, ta] = my_tang(v_N, t);

phi = [phi_tx, phi_ty, phi_tz];

%% Rotation der lineare Beschleunigung
[a_B] = my_rotate(phi, a_N, t); 
% lineare Beschleunigung im Schwerpunkt S und referenzerit auf das Körperkoorinatensystem B