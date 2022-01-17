%%
clear all
clc
close all

%% Parameters
% Size of the RigidBody
size = [100e-3,... % width 10cm
        100e-3,... % length 10cm
        100e-3];   % heigh 10cm

        
% Distance of the IMU to the center of mass
r =   [ 30e-3,... % 3 cm
        0,...
        0]; 

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


%% Calculation of points
tool(size, s, phi, r, 30)
