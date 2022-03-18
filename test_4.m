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
phix = 0 .* t; % rad
phiy = 0 .* t; % rad
phiz = 0.3 .* cos(2*pi*f*t); % rad

phi = [phix', phiy', phiz'];

%% Berechnung Winkelgrößen
[phi, omega, alpha] = my_ang(phi,"num",t);