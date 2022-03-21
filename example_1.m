%% clear all
clear all
close all
clc


%% define trajectory

% time
t_start = 0; % s
t_stop = 1; % s
t_step = 0.01; % s

% trajectorie
t = (t_start:t_step:t_stop); % s

f = 1; % Hz

% Circle trajectory
% sx = @(t) (0.7 .* cos(2*pi*f*t)); % m
% sy = @(t) (0.7 .* sin(2*pi*f*t)); % m
% sz = @(t) (0.0 .* sin(2*pi*f*t)); % m
% 
% phix = @(t) (0 .* t); % rad
% phiy = @(t) (0 .* t); % rad
% phiz = @(t) (0 .* t); % rad

% Oszilation (Rotation)
%sx = @(t) (0 .* t); % m
%sy = @(t) (0 .* t); % m
%sz = @(t) (0 .* t); % m
%
%phix = @(t) (deg2rad(30)); % rad
%phiy = @(t) (deg2rad(30)); % rad
%phiz = @(t) (deg2rad(30) .* sin(2*pi*f*t)); % rad

% 8 trajectory
sx = @(t) (0.3 .* cos(2*pi*f*t)); % m
sy = @(t) (0.3 .* sin(2*pi*f*t)*cos(2*pi*f*t)); % m
sz = @(t) (0.0 .* cos(2*pi*3*f*t)); % m

phix = @(t) (0 .* t); % rad
phiy = @(t) (0 .* t); % rad
phiz = @(t) (0 .* t); % rad

% Acceleration straight line
% sx = @(t) (1 .* t^3); % m
% sy = @(t) (0 .* t); % m
% sz = @(t) (0 .* t); % m
%  
% phix = @(t) (deg2rad(0)); % rad
% phiy = @(t) (deg2rad(0)); % rad
% phiz = @(t) (deg2rad(45)); % rad

s = {sx, sy, sz};
phi = {phix, phiy, phiz};

%% calculation
% B ... body frame
% Ref ... reference frame

% calculate lineare
%[s, vRef, aRef] = my_lin(s,"sym",t);
[s, vRef, aRef] = my_lin(s,"sym",t);

% calculate angular

%[phi, omegaB, alphaB] = my_ang(phi_, "sym", t);
[phi_tz, phi_ty, phi_tx,ta] = my_tang(vRef, t);
phi_ = [phi_tx, phi_ty, phi_tz];

% add gravitation
aRef = aRef + [0,0,9.81];

% rotat linear Acceleration into Bodyframe
%[aB] = my_rotate(phi, aRef, t);

%[aIMU] = my_imu(aB, omega, alpha, r, t);

%% plot
