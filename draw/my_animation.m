function my_animation(s, phi, t)
    
    figure(1); hold on;
    xlim([-2,2]);
    ylim([-2,2])
    zlim([-2,2])
    axis square
    grid on
    
    size = [400e-3;400e-3;400e-3];
    r = [100e-3,0,0];
    h_RigidBody1 = animatedline();
    h_RigidBody2 = animatedline();
    h_RigidBody3 = animatedline();
    h_RigidBody4 = animatedline();
    
    h_s = animatedline("marker","o");
    h_imu = animatedline("marker","o");
    h_tr = animatedline("color","blue");
    
    
    addpoints(h_tr, s(:,1), s(:,2), s(:,3));
    [Pr_top, Pr_bottom, Pr_front, Pr_back, ~, ~] = my_RigidBody(size, s(1,:), phi(1,:), r);
    addpoints(h_RigidBody1, Pr_top(:,1), Pr_top(:,2), Pr_top(:,3));
    addpoints(h_RigidBody2, Pr_bottom(:,1), Pr_bottom(:,2), Pr_bottom(:,3));
    addpoints(h_RigidBody3, Pr_front(:,1), Pr_front(:,2), Pr_front(:,3));
    addpoints(h_RigidBody4, Pr_back(:,1), Pr_back(:,2), Pr_back(:,3));
        
    pause
    
    for it = 1:length(t)
        [Pr_top, Pr_bottom, Pr_front, Pr_back, Ps, Pimu] = my_RigidBody(size, s(it,:), phi(it,:), r);
        
        clearpoints(h_RigidBody1)
        clearpoints(h_RigidBody2)
        clearpoints(h_RigidBody3)
        clearpoints(h_RigidBody4)
        
        clearpoints(h_s)
        clearpoints(h_imu)


        addpoints(h_RigidBody1, Pr_top(:,1), Pr_top(:,2), Pr_top(:,3));
        addpoints(h_RigidBody2, Pr_bottom(:,1), Pr_bottom(:,2), Pr_bottom(:,3));
        addpoints(h_RigidBody3, Pr_front(:,1), Pr_front(:,2), Pr_front(:,3));
        addpoints(h_RigidBody4, Pr_back(:,1), Pr_back(:,2), Pr_back(:,3));
        
        
        addpoints(h_s, Ps(:,1), Ps(:,2), Ps(:,3));
        addpoints(h_imu, Pimu(:,1), Pimu(:,2), Pimu(:,3));

        drawnow
        pause(0.02)
    
%         % plot Rigid Body
%         plot3(Pr_top(:,1),Pr_top(:,2),Pr_top(:,3),"black","LineWidth",1);
%         plot3(Pr_bottom(:,1),Pr_bottom(:,2),Pr_bottom(:,3),"black","LineWidth",1);
%         plot3(Pr_front(:,1),Pr_front(:,2),Pr_front(:,3),"black","LineWidth",1);
%         plot3(Pr_back(:,1),Pr_back(:,2),Pr_back(:,3),"black","LineWidth",1);
% 
%         % plot Center of mass
%         plot3(Ps(:,1),Ps(:,2),Ps(:,3),"o");
% 
%         % plot imu
%         plot3(Pimu(:,1),Pimu(:,2),Pimu(:,3),"o");   
        
    end
end