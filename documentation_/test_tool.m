%%
clear all
clc
close all

%% Parameters
% Size of the RigidBody
size = [300e-3,... % width 10cm
        300e-3,... % length 10cm
        300e-3];   % heigh 10cm

        
% Distance of the IMU to the center of mass
r =   [ 100e-3,... % 3 cm
        0,...
        0]; 

%% define trajectory

% time
t_start = 0; % s
t_stop = 5; % s
t_step = 0.01; % s

% trajectorie
t = (t_start:t_step:t_stop); % s

f = 1; % Hz

% Circle trajectory
sx = @(t) (1 .* cos(2*pi*f*t)); % m
sy = @(t) (1 .* sin(2*pi*f*t)); % m
sz = @(t) (0 .* t); % m

phix = @(t) (0 .* t); % rad
phiy = @(t) (0 .* t); % rad
phiz = @(t) -(2*pi*f*t); % rad

% Oszilation (Rotation)
% sx = @(t) (0 .* t); % m
% sy = @(t) (0 .* t); % m
% sz = @(t) (0 .* t); % m
% 
% phix = @(t) (deg2rad(30)); % rad
% phiy = @(t) (deg2rad(30)); % rad
% phiz = @(t) (deg2rad(30) .* sin(2*pi*f*t)); % rad

% 8 trajectory
%sx = @(t) (1 .* sin(2*pi*f*t)); % m
%sy = @(t) (1 .* sin(2*pi*f*t)*cos(2*pi*f*t)); % m
%sz = @(t) (0.1 .* cos(2*pi*f*3*t)); % m

s = {sx, sy, sz};
phi = {phix, phiy, phiz};

%% calculation
[s, v, a] = my_lin(s,"sym",t);
[phi, omega, alpha] = my_ang(phi, "sym", t);



%% plot points
trajectory_tool.linear(t,s,phi,v,a)
