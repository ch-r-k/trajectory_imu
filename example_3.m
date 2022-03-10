%% clear all
clear all
close all
clc

%% define trajectory

% time
t_start = 0; % s
t_stop = 5; % s
t_step = 0.005; % s

t = (t_start:t_step:t_stop); % s

% frequency
f = 1; % Hz


% wobly circle ------------------------------------------------------------
sx = @(t) (0.8 .* cos(2*pi*f*t)); % m
sy = @(t) (0.8 .* sin(2*pi*f*t)); % m
sz = @(t) (0.3 .* cos(2*pi*3*f*t)); % m

phix = @(t) (0 .* t); % rad
phiy = @(t) (0 .* t); % rad
phiz = @(t) (0 .* t); % rad


% wobly 8 -----------------------------------------------------------------
% sx = @(t) (0.8 .* cos(2*pi*f*t)); % m
% sy = @(t) (0.8 .* sin(2*pi*f*t) * cos(2*pi*f*t)); % m
% sz = @(t) (0.3 .* cos(2*pi*3*f*t)); % m
% 
% phix = @(t) (0 .* t); % rad
% phiy = @(t) (0 .* t); % rad
% phiz = @(t) (0 .* t); % rad


% Acceleration straight line ----------------------------------------------
% sx = @(t) (1 .* t^3); % m
% sy = @(t) (0 .* t); % m
% sz = @(t) (0 .* t); % m
%  
% phix = @(t) (deg2rad(0)); % rad
% phiy = @(t) (deg2rad(0)); % rad
% phiz = @(t) (deg2rad(45)); % rad

% define

s = [sx(t)',sy(t)',sz(t)'];
phi = [phix(t)',phiy(t)',phiz(t)'];


%% calculation
% B ... body frame
% Ref ... reference frame

% calculate lineare
%[s, vRef, aRef] = my_lin(s,"sym",t);
[s, vRef, aRef] = my_lin(s,"num",t);

% calculate tang
[phi_tz, phi_ty, phi_tx, ta] = my_tang(vRef, t);
phi_ = [phi_tx, phi_ty, phi_tz];

% add gravitation
aRef = aRef + [0,0,9.81];

% angular
[phi_calc, omega_B, alpha_B] = my_ang(phi_, 'num', t);

% rotat linear Acceleration into Bodyframe
[aB] = my_rotate(phi, aRef, t);

% calculate IMU data
r = [1,0,0]; %m distance form center of mass to imu
[aIMU] = my_imu(aB, omega_B, alpha_B, r, t);