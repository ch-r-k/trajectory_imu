%% clear all
clear all
close all
clc

%% define trajectory

% time
t_start = 0;
t_stop = 1;
t_step = 0.01;

% trajectorie
t = (t_start:t_step:t_stop);

f = 1;
sx = 1 .* cos(2*pi*f*t)';
sy = 1 .* sin(2*pi*f*t)';
sz = 0 .* t';

s = [sx,sy,sz];

% orientation
phix = 0 .* t';
phiy = 0 .* t';
phiz = -(2*pi*f*t)';

phi = [phix, phiy, phiz];



%% animation
my_animation(s, phi, t);