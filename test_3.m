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
phix = @(t) (0.8 .* cos(2*pi*f*t)); % m
phiy = @(t) (0.8 .* sin(2*pi*f*t)); % m
phiz = @(t) (0.3 .* cos(2*pi*f*t)); % m

phi = {phix, phiy, phiz};

%% Berechnung Winkelgrößen
[phi, omega, alpha] = my_ang(phi,"sym",t);