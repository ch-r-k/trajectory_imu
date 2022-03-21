%%
clear all
close all
clc

%% Zeit
t_start = 0; % s
t_stop = 1; % s
t_step = 0.005; % s

t = (t_start:t_step:t_stop); % s

%% Frequenz
f = 1; % Hz

%% Trajektorie Nummerisch
sx_n = 0.8 .* cos(2*pi*f*t); % m
sy_n = 0.8 .* sin(2*pi*f*t); % m
sz_n = 0.3 .* cos(2*pi*f*t); % m

phix_n = 0 .* t; % rad
phiy_n = asin((3*sqrt(2)*sin(2*pi*f*t))./sqrt(- 9*cos(4*t*f*pi) + 137)); % rad
phiz_n = 2*pi*f*t + pi/2; % rad

s_n = [sx_n', sy_n', sz_n'];
phi_n = [phix_n', phiy_n', phiz_n'];

%% Trajektorie Symbolisch
sx_s = @(t) (0.8 .* cos(2*pi*f*t)); % m
sy_s = @(t) (0.8 .* sin(2*pi*f*t)); % m
sz_s = @(t) (0.3 .* cos(2*pi*f*t)); % m

phix_s = @(t) (0 .* t); % rad
phiy_s = @(t) (asin((3*sqrt(2)*sin(2*pi*f*t))./sqrt(- 9*cos(4*t*f*pi) + 137))); % rad
phiz_s = @(t) (2*pi*f*t + pi/2); % rad

s_s = {sx_s, sy_s, sz_s};
phi_s = {phix_s, phiy_s, phiz_s};

%% Berechnung lineare Größen nummerisch
[s_n, v_n, a_n] = my_lin(s_n,"num",t);

%% Berechnung lineare Größen symbolisch
[s_s, v_s, a_s] = my_lin(s_s,"sym",t);

%% Berechnung Winkelgrößen nummerisch
[phi_n, omega_n, alpha_n] = my_ang(phi_n,"num",t);

%% Berechnung Winkelrößen symbolisch
[phi_s, omega_s, alpha_s] = my_ang(phi_s,"sym",t);

%%
[phi_tz, phi_ty, phi_tx, ta] = my_tang(v_n, t);

%%
body.width  = 150e-3;
body.length = 150e-3;
body.heigth = 50e-3 ;
body.r = [-150e-3,-150e-3,50e-3]./2;

figure
tmr = my_traAnim(t, s_s, phi_s, body);

%%
start(tmr);


%%
figure
plot(t, omega_n-omega_s)

%%
figure
plot(t, alpha_s - alpha_n)

