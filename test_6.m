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
sx = @(t) (0.8 .* cos(2*pi*f*t)); % m
sy = @(t) (0.8 .* sin(2*pi*f*t)); % m
sz = @(t) (0.3 .* cos(2*pi*f*t)); % m

s = {sx, sy, sz};

%% Berechnung lineare Größen
[s, v, a] = my_lin(s,"sym",t);