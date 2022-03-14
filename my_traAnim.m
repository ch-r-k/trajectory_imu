function tmr = my_traAnim(t, s, phi, body)

    % t ... time
    % s ... trajectory
    % phi ... orientation
    % body.width ... with of rigid body
    % body.length ... length of rigid body
    % body.heigth ... heigth of rigid body
    % body.r ... distance of imu from center of mass of rigid body
    
    
    % colors
    c0 = [0 0.4470 0.7410];
    c1 = [0.8500 0.3250 0.0980];	
    c2 = [0.9290 0.6940 0.1250];	
    c3 = [0.4940 0.1840 0.5560];	
    c4 = [0.4660 0.6740 0.1880];	
    c5 = [0.3010 0.7450 0.9330];	
    c6 = [0.6350 0.0780 0.1840];
    
    % parameter
    index = 1;
    size  = [body.length, body.width ,body.heigth];
    
    % coordinate of rigid body (3d triangle)
    [Pr_t, Pr_bo, Pr_f, Pr_b1, Pr_b2, Ps, Pimu] = my_RigidBody(...
                                                    size,...
                                                    s(index,:),...
                                                    phi(index,:),...
                                                    body.r);
                                                
    % plot settings
    hold on;
    axis square;
    
    % plot coordinat system
    line([0,1],[0,0],[0,0],'color', 'black',"LineWidth",2);
    line([0,0],[0,1],[0,0],'color', 'black',"LineWidth",2);
    line([0,0],[0,0],[0,1],'color', 'black',"LineWidth",2);
    line([0,-1],[0,0],[0,0],'color', 'black',"linestyle","--","LineWidth",2);
    line([0,0],[0,-1],[0,0],'color', 'black',"linestyle","--","LineWidth",2);
    line([0,0],[0,0],[0,-1],'color', 'black',"linestyle","--","LineWidth",2);
    
    % plot trajectory
    line(s(:,1),s(:,2),s(:,3),"color",c0,"LineWidth",2);
    
    % plot rigid body
    h_rb1 = fill3(Pr_t(:,1),Pr_t(:,2),Pr_t(:,3), c1,'FaceAlpha',.3,'EdgeAlpha',.3);
    h_rb2 = fill3(Pr_bo(:,1),Pr_bo(:,2),Pr_bo(:,3), c1,'FaceAlpha',.3,'EdgeAlpha',.3);
    h_rb3 = fill3(Pr_f(:,1),Pr_f(:,2),Pr_f(:,3), c1,'FaceAlpha',.3,'EdgeAlpha',.3);
    h_rb4 = fill3(Pr_b1(:,1),Pr_b1(:,2),Pr_b1(:,3), c1,'FaceAlpha',.3,'EdgeAlpha',.3);
    h_rb5 = fill3(Pr_b2(:,1),Pr_b2(:,2),Pr_b2(:,3), c1,'FaceAlpha',.3,'EdgeAlpha',.3);
    
    % timer
    tmr = timer('ExecutionMode', 'FixedRate', ...
                'Period', 0.05, ...
                'TimerFcn', {@timerCallback});



    function timerCallback(hObj, eventdata)
        % coordinate of rigid body (3d triangle)
        [Pr_t, Pr_bo, Pr_f, Pr_b1, Pr_b2, Ps, Pimu] = my_RigidBody(...
                                                    size,...
                                                    s(index,:),...
                                                    phi(index,:),...
                                                    body.r);
                                                
        h_rb1.XData = Pr_t(:,1)';
        h_rb1.YData = Pr_t(:,2)';
        h_rb1.ZData = Pr_t(:,3)';

        h_rb2.XData = Pr_bo(:,1)';
        h_rb2.YData = Pr_bo(:,2)';
        h_rb2.ZData = Pr_bo(:,3)';

        h_rb3.XData = Pr_f(:,1)';
        h_rb3.YData = Pr_f(:,2)';
        h_rb3.ZData = Pr_f(:,3)';

        h_rb4.XData = Pr_b1(:,1)';
        h_rb4.YData = Pr_b1(:,2)';
        h_rb4.ZData = Pr_b1(:,3)';

        h_rb5.XData = Pr_b2(:,1)';
        h_rb5.YData = Pr_b2(:,2)';
        h_rb5.ZData = Pr_b2(:,3)';
        
        index = index + 1;
        
        if index >= length(t)
            stop(tmr);
            delete(tmr);
        end
    end
 
end