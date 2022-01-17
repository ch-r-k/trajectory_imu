%% clear all
clear all
close all
clc

%% define trajectory

% time
t_start = 0; % s
t_stop = 5; % s
t_step = 0.01; % s

% trajectorie
t = (t_start:t_step:t_stop); % s

f = 1; % Hz

% Circle trajectory
% sx = @(t) (1 .* cos(2*pi*f*t)); % m
% sy = @(t) (1 .* sin(2*pi*f*t)); % m
% sz = @(t) (0 .* t); % m
% 
% phix = @(t) (0 .* t); % rad
% phiy = @(t) (0 .* t); % rad
% phiz = @(t) -(2*pi*f*t); % rad

% Oszilation (Rotation)
%sx = @(t) (0 .* t); % m
%sy = @(t) (0 .* t); % m
%sz = @(t) (0 .* t); % m
%
%phix = @(t) (deg2rad(30)); % rad
%phiy = @(t) (deg2rad(30)); % rad
%phiz = @(t) (deg2rad(30) .* sin(2*pi*f*t)); % rad

% 8 trajectory
%sx = @(t) (1 .* sin(2*pi*f*t)); % m
%sy = @(t) (1 .* sin(2*pi*f*t)*cos(2*pi*f*t)); % m
%sz = @(t) (0.1 .* cos(2*pi*f*3*t)); % m

% Acceleration straight line
sx = @(t) (1 .* t^3); % m
sy = @(t) (0 .* t); % m
sz = @(t) (0 .* t); % m
 
phix = @(t) (deg2rad(0)); % rad
phiy = @(t) (deg2rad(0)); % rad
phiz = @(t) (deg2rad(45)); % rad

s = {sx, sy, sz};
phi = {phix, phiy, phiz};

%% calculation
% B ... body frame
% Ref ... reference frame

% calculate lineare
[s, vRef, aRef] = my_lin(s,"sym",t);

% calculate angular
[phi, omegaB, alphaB] = my_ang(phi, "sym", t);

% add gravitation
aRef = aRef + [0,0,9.81];

% rotat linear Acceleration into Bodyframe
[aB] = my_rotate(phi, aRef, t);

%[aIMU] = my_imu(aB, omega, alpha, r, t);

%% plot
figure
plot3(s(:,1),s(:,2),s(:,3))

figure; 
plot(t,s(:,2))
hold on;
plot(t,v(:,2))
plot(t,a(:,2))

figure; 
plot(t,phi(:,3))
hold on;
plot(t,omegaB(:,3))
plot(t,alphaB(:,3))