%%
clear all
clc
close all

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
[s, v, a] = my_lin(s,"num",t);

%% Berechnung Tangentialwinkel
[phi_tz, phi_ty, phi_tx, ta] = my_tang(v, t);