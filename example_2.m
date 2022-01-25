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
sx = @(t) (0.7 .* cos(2*pi*f*t)); % m
sy = @(t) (0.7 .* sin(2*pi*f*t)); % m
sz = @(t) (0.0 .* sin(2*pi*f*t)); % m

phix = @(t) (0 .* t); % rad
phiy = @(t) (0 .* t); % rad
phiz = @(t) (0 .* t); % rad

% Oszilation (Rotation)
% sx = @(t) (0 .* t); % m
% sy = @(t) (0 .* t); % m
% sz = @(t) (0 .* t); % m
% 
% phix = @(t) (deg2rad(0) .* t); % rad
% phiy = @(t) (deg2rad(0) .* t); % rad
% phiz = @(t) (deg2rad(30) .* sin(2*pi*f*t)); % rad

% define
s_sym = {sx, sy, sz};
phi_sym = {phix, phiy, phiz};


s_num = [sx(t)', sy(t)', sz(t)'];
phi_num = [phix(t)', phiy(t)', phiz(t)'];
%% calculation
% B ... body frame
% Ref ... reference frame

% calculate lineare
%[s, vRef, aRef] = my_lin(s,"sym",t);
[~, vRef_sym, aRef_sym] = my_lin(s_sym,"sym",t);
[~, vRef_num, aRef_num] = my_lin(s_num,"num",t);


% calculate angular
%[s, vRef, aRef] = my_lin(s,"sym",t);
[phi_sym, omega_sym, alpha_sym] = my_ang(phi_sym,"sym",t);
[phi_num, omega_num, alpha_num] = my_ang(phi_num,"num",t);
