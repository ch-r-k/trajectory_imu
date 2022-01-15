%%
clear all
clc
close all

%% Parameters
% Size of the RigidBody
size = [100e-3,... % width 10cm
        100e-3,... % length 10cm
        100e-3];   % heigh 10cm

% Position of the RigidBody (center of mass)
s = [   0,...
        0,...
        0];

% Orientation of the RigidBody (euler angles z-y-x convention)
phi =   [   0,...
            0,...
            deg2rad(30)]; % 30 deg
        
% Distance of the IMU to the center of mass
r =   [ 30e-3,... % 3 cm
        0,...
        0]; 

%% Calculation of points
[Pr_top, Pr_bottom, Pr_front, Pr_back, Ps, Pimu] = my_RigidBody(size, s, phi, r);

%% plot
figure; hold on;
xlim([-0.1,0.1])
ylim([-0.1,0.1])
zlim([-0.1,0.1])
axis square

% plot Rigid Body
plot3(Pr_top(:,1),Pr_top(:,2),Pr_top(:,3),"black","LineWidth",1);
plot3(Pr_bottom(:,1),Pr_bottom(:,2),Pr_bottom(:,3),"black","LineWidth",1);
plot3(Pr_front(:,1),Pr_front(:,2),Pr_front(:,3),"black","LineWidth",1);
plot3(Pr_back(:,1),Pr_back(:,2),Pr_back(:,3),"black","LineWidth",1);

% plot Center of mass
plot3(Ps(:,1),Ps(:,2),Ps(:,3),"o");

% plot imu
plot3(Pimu(:,1),Pimu(:,2),Pimu(:,3),"o");