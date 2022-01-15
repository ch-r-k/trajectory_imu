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
%sx = @(t) (1 .* cos(2*pi*f*t));
%sy = @(t) (1 .* sin(2*pi*f*t));
%sz = @(t) (zeros(1,length(t)));

sx = @(t) (1 .* sin(2*pi*f*t));
sy = @(t) (1 .* sin(2*pi*f*t)*cos(2*pi*f*t));
sz = @(t) (0.1 .* cos(2*pi*f*3*t));

s = {sx, sy, sz};



%% calculation
[s, v, a] = my_lin(s,"sym",t);

figure
plot3(s(:,1),s(:,2),s(:,3))

figure; 
plot(t,s(:,2))
hold on;
plot(t,v(:,2))
plot(t,a(:,2))