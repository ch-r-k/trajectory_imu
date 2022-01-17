function tool(size, s, phi, r, k)

    %% figure and grid layout
    figure('units','normalized','outerposition',[0 0 1 1])
    
    %% subplot 1,1 trajectory
    subplot(2,2,1);
    
    xlim([-2,2]);
    ylim([-2,2])
    zlim([-2,2])
    axis square
    grid on

    h_RigidBody1 = animatedline();
    h_RigidBody2 = animatedline();
    h_RigidBody3 = animatedline();
    h_RigidBody4 = animatedline();

    %h_s = animatedline("marker","o");
    %h_imu = animatedline("marker","o");
    h_tr = animatedline("color","blue");

    clearpoints(h_RigidBody1)
    clearpoints(h_RigidBody2)
    clearpoints(h_RigidBody3)
    clearpoints(h_RigidBody4)

    addpoints(h_tr, s(:,1), s(:,2), s(:,3));
    [Pr_top, Pr_bottom, Pr_front, Pr_back, ~, ~] = my_RigidBody(size, s(k,:), phi(k,:), r);
    addpoints(h_RigidBody1, Pr_top(:,1), Pr_top(:,2), Pr_top(:,3));
    addpoints(h_RigidBody2, Pr_bottom(:,1), Pr_bottom(:,2), Pr_bottom(:,3));
    addpoints(h_RigidBody3, Pr_front(:,1), Pr_front(:,2), Pr_front(:,3));
    addpoints(h_RigidBody4, Pr_back(:,1), Pr_back(:,2), Pr_back(:,3));
        
    %% subplot 1,2 location
    subplot(2,2,1);
    hold on;
    
    %% subplot 2,1 velocity
    subplot(2,2,1);
    hold on;
    
    %% subplot 2,2 acceleration
    subplot(2,2,1);
    hold on;
    
    %%
%     % Device drop-down
%     dd1 = uidropdown(g);
%     dd1.Items = {'Select a device'};
% 
%     % Range drop-down
%     dd2 = uidropdown(g);
%     dd2.Items = {'Select a range'};
%     dd2.Layout.Row = 2;
%     dd2.Layout.Column = 1;
% 
%     % List box
%     chanlist = uilistbox(g);
%     chanlist.Items = {'Channel 1','Channel 2','Channel 3'};
%     chanlist.Layout.Row = 3;
%     chanlist.Layout.Column = 1;
% 
%     % Axes
%     ax = uiaxes(g);
%     
%     t = 0:0.01:1;
%     x = 1*sin(2*pi*t);
%     y = 1*cos(2*pi*t);
%     z = 1*sin(2*pi*t);
%     plot3(ax,x,y,z)
end

