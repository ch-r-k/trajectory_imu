
% TrajectoryTool
%--------------------------------------------------------------------------
% Objective: 
%
% Syntax
%--------------------------------------------------------------------------
%
% Remarks
%--------------------------------------------------------------------------
%
% Example:
%
classdef trajectory_tool
    
    properties (Access = public, Constant = true)
        % Slider_Pos = [0.13, 0.93, 0.775, 0.05]; % up
        Slider_Pos = [0.93, 0.13, 0.05, 0.775]; % right
    end
    
    properties (Access = public, Constant = true)
        sizeRB = [150e-3,150e-3,50e-3];
        r = [-150e-3,-150e-3,50e-3]./2;
        limit = [-1,1;-1,1;-1,1];
        
    end
    
    % Public Methods
    %======================================================================
    methods (Access = public, Static = true)
        function linear(t,s,phi,v,a,ta,varargin)
            
            % colors
            c0 = [0 0.4470 0.7410];
            c1 = [0.8500 0.3250 0.0980];	
            c2 = [0.9290 0.6940 0.1250];	
            c3 = [0.4940 0.1840 0.5560];	
            c4 = [0.4660 0.6740 0.1880];	
            c5 = [0.3010 0.7450 0.9330];	
            c6 = [0.6350 0.0780 0.1840];

            %
            [Pr_t, Pr_bo, Pr_f, Pr_b1, Pr_b2, Ps, Pimu] = my_RigidBody(trajectory_tool.sizeRB, s(1,:), phi(1,:), trajectory_tool.r);
            ta = 0.5.*ta;
            %==========================================================================
            figure;
            
            %==========================================================================
            %%subplot(2,2,1);  
            title("Trajectory");
            
            h_tr = animatedline(s(:,1),s(:,2),s(:,3),"color",c0,"LineWidth",2);
            
            h_RigidBody1 = animatedline(Pr_t(:,1),Pr_t(:,2),Pr_t(:,3));
            h_RigidBody2 = animatedline(Pr_bo(:,1),Pr_bo(:,2),Pr_bo(:,3));
            h_RigidBody3 = animatedline(Pr_f(:,1),Pr_f(:,2),Pr_f(:,3));
            h_RigidBody4 = animatedline(Pr_b1(:,1),Pr_b1(:,2),Pr_b1(:,3));
            
            hold on
            h_RigidBodyf1 = fill3(Pr_t(:,1),Pr_t(:,2),Pr_t(:,3), c1);
            h_RigidBodyf2 = fill3(Pr_bo(:,1),Pr_bo(:,2),Pr_bo(:,3), c1);
            h_RigidBodyf3 = fill3(Pr_f(:,1),Pr_f(:,2),Pr_f(:,3), c1);
            h_RigidBodyf4 = fill3(Pr_b1(:,1),Pr_b1(:,2),Pr_b1(:,3), c1);
            h_RigidBodyf5 = fill3(Pr_b2(:,1),Pr_b2(:,2),Pr_b2(:,3), c1);
            
            line([0,1],[0,0],[0,0],'color', 'black',"LineWidth",2);
            line([0,0],[0,1],[0,0],'color', 'black',"LineWidth",2);
            line([0,0],[0,0],[0,1],'color', 'black',"LineWidth",2);
            line([0,-1],[0,0],[0,0],'color', 'black',"linestyle","--","LineWidth",2);
            line([0,0],[0,-1],[0,0],'color', 'black',"linestyle","--","LineWidth",2);
            line([0,0],[0,0],[0,-1],'color', 'black',"linestyle","--","LineWidth",2);
            
            
            h_s = animatedline(Ps(:,1),Ps(:,2),Ps(:,3),"marker","o");
            h_imu = animatedline(Pimu(:,1),Pimu(:,2),Pimu(:,3),"marker","o","color","black",'MarkerFaceColor',c2);
            
            h_t = animatedline([0,0], [0,0], [0,0],"color",c2);

            limit = trajectory_tool.limit;
            xlim(limit(1,:));
            ylim(limit(2,:));
            zlim(limit(3,:));
            
            xlabel("x");
            ylabel("y");
            zlabel("z");
            
            axis square
            grid off
            set(gca,'visible','off')
            set(gcf,'color','white')
            
            %==========================================================================
            %%subplot(2,2,2);
            title("Location");
            
            %animatedline(t, s(:,1)',"color","blue");
            %animatedline(t, s(:,2)',"color","red");
            %animatedline(t, s(:,3)',"color","yellow");
            
            h_st = 0;% animatedline([t(1),t(1),t(1)], s(1,1:3),"marker","o","color","blue","LineStyle",'none');
            
            %xlabel("t");
            %ylabel("s");
            grid off
            
            %==========================================================================
            %%subplot(2,2,3);
            title("Velocity");
            
            %animatedline(t, v(:,1),"color","blue");
            %animatedline(t, v(:,2),"color","red");
            %animatedline(t, v(:,3),"color","yellow");
            
            h_vt = 0;%animatedline([t(1),t(1),t(1)], v(1,1:3),"marker","o","color","blue","LineStyle",'none');
            
            %xlabel("t");
            %ylabel("v");
            
            grid off
            %==========================================================================
            %%subplot(2,2,4);
            title("Accelertation");
            
            %animatedline(t, a(:,1),"color","blue");
            %animatedline(t, a(:,2),"color","red");
            %animatedline(t, a(:,3),"color","yellow");
            
            %xlabel("t");
            %ylabel("a");
            
            h_at = 0;%animatedline([t(1),t(1),t(1)], a(1,1:3),"marker","o","color","blue","LineStyle",'none');
            grid off
            
            %==========================================================================
            [h_slider, idx_obj] = trajectory_tool.get_slider(t);
            

            
            % Save object data
            %==========================================================================           
            h_slider.UserData.obj{idx_obj,1}.hRB1   = h_RigidBody1;
            h_slider.UserData.obj{idx_obj,1}.hRB2   = h_RigidBody2;
            h_slider.UserData.obj{idx_obj,1}.hRB3   = h_RigidBody3;
            h_slider.UserData.obj{idx_obj,1}.hRB4   = h_RigidBody4;
            
            h_slider.UserData.obj{idx_obj,1}.hRBf1   = h_RigidBodyf1;
            h_slider.UserData.obj{idx_obj,1}.hRBf2   = h_RigidBodyf2;
            h_slider.UserData.obj{idx_obj,1}.hRBf3   = h_RigidBodyf3;
            h_slider.UserData.obj{idx_obj,1}.hRBf4   = h_RigidBodyf4;
            h_slider.UserData.obj{idx_obj,1}.hRBf5   = h_RigidBodyf5;
            
            h_slider.UserData.obj{idx_obj,1}.hS     = h_s;
            h_slider.UserData.obj{idx_obj,1}.hIMU   = h_imu;
            h_slider.UserData.obj{idx_obj,1}.hTr    = h_tr;
            
            %h_slider.UserData.obj{idx_obj,1}.st     = h_st;
            %h_slider.UserData.obj{idx_obj,1}.vt     = h_vt;
            %h_slider.UserData.obj{idx_obj,1}.at     = h_at;
            
            h_slider.UserData.obj{idx_obj,1}.t      = t;
            h_slider.UserData.obj{idx_obj,1}.ta     = ta;
            h_slider.UserData.obj{idx_obj,1}.s      = s;
            h_slider.UserData.obj{idx_obj,1}.phi    = phi;
            h_slider.UserData.obj{idx_obj,1}.v      = v;
            h_slider.UserData.obj{idx_obj,1}.a      = a;
            
            h_slider.UserData.obj{idx_obj,1}.hst     = h_st;
            h_slider.UserData.obj{idx_obj,1}.hvt     = h_vt;
            h_slider.UserData.obj{idx_obj,1}.hat     = h_at;
            h_slider.UserData.obj{idx_obj,1}.ht     = h_t;
        end
           
    end
    
    
    methods (Access = private, Static = true)
        
        function [h_slider, idx_obj] = get_slider(t)
            % Find Slider object
            %==========================================================================
            h_slider = findobj(gcf,'type','uicontrol', 'style','slider', 'tag', 'trajectory_tool slider');
            
            % Initialization
            %==========================================================================
            if isempty(h_slider)
                idx_obj = 1;
            else
                idx_obj = length(h_slider.UserData.obj) + 1;
            end
            
            % Initialize Slider
            %===========================================================================
            if isempty(h_slider)
                Number_of_steps = length(t);
                h_slider = uicontrol(   'style','slider',...
                                        'units','normalized',...
                                        'position',trajectory_tool.Slider_Pos,...
                                        'Min',1,'Max',Number_of_steps,...
                                        'Value',1,...
                                        'Callback', @trajectory_tool.slider);
                                    
                set(h_slider, 'SliderStep', [1/Number_of_steps , 10/Number_of_steps ]);
                h_slider.Tag = 'trajectory_tool slider';
            end
        end
        
        function slider(h_slider, eventdata)
                     
            idx_t           = round(get(h_slider, 'Value'));
            obj_cell        = h_slider.UserData.obj;
            
            h_s = h_slider.UserData.obj{1}.hS;
            h_imu = h_slider.UserData.obj{1}.hIMU;
            
            h_rb1 = h_slider.UserData.obj{1}.hRB1;
            h_rb2 = h_slider.UserData.obj{1}.hRB2;
            h_rb3 = h_slider.UserData.obj{1}.hRB3;
            h_rb4 = h_slider.UserData.obj{1}.hRB4;
            
            h_rbf1 = h_slider.UserData.obj{1}.hRBf1;
            h_rbf2 = h_slider.UserData.obj{1}.hRBf2;
            h_rbf3 = h_slider.UserData.obj{1}.hRBf3;
            h_rbf4 = h_slider.UserData.obj{1}.hRBf4;
            h_rbf5 = h_slider.UserData.obj{1}.hRBf5;
            
            h_st = h_slider.UserData.obj{1}.hst;
            h_vt = h_slider.UserData.obj{1}.hvt;  
            h_at = h_slider.UserData.obj{1}.hat;
            
            h_t = h_slider.UserData.obj{1}.ht;
            
            t = h_slider.UserData.obj{1}.t;
            ta = h_slider.UserData.obj{1}.ta;
            s = h_slider.UserData.obj{1}.s;
            v = h_slider.UserData.obj{1}.v;
            a = h_slider.UserData.obj{1}.a;
            
            phi = h_slider.UserData.obj{1}.phi;
            
            [Pr_t, Pr_bo, Pr_f, Pr_b1, Pr_b2 , Ps, Pimu] = my_RigidBody( ...
                                                trajectory_tool.sizeRB,...
                                                s(idx_t,:),...
                                                phi(idx_t,:),...
                                                trajectory_tool.r);
                               
            % sub 11
            clearpoints(h_s);
            clearpoints(h_rb1);
            clearpoints(h_rb2);
            clearpoints(h_rb3);
            clearpoints(h_rb4);
            clearpoints(h_imu);
            clearpoints(h_t);
            
            h_s.addpoints(Ps(:,1),Ps(:,2),Ps(:,3)); 
            %h_rb1.addpoints(Pr_t(:,1),Pr_t(:,2),Pr_t(:,3));     
            %h_rb2.addpoints(Pr_bo(:,1),Pr_bo(:,2),Pr_bo(:,3)); 
            %h_rb3.addpoints(Pr_f(:,1),Pr_f(:,2),Pr_f(:,3)); 
            %h_rb4.addpoints(Pr_b(:,1),Pr_b(:,2),Pr_b(:,3));   
            h_imu.addpoints(Pimu(:,1),Pimu(:,2),Pimu(:,3)); 
            
            %h_t.addpoints([0,ta(idx_t,1)]  + Ps(:,1) ,[0,ta(idx_t,2)]  + Ps(:,2), [0,ta(idx_t,3)]  + Ps(:,3));   
            
            hold on
            
            
            h_rbf1.XData = Pr_t(:,1)';
            h_rbf1.YData = Pr_t(:,2)';
            h_rbf1.ZData = Pr_t(:,3)';
            
            h_rbf2.XData = Pr_bo(:,1)';
            h_rbf2.YData = Pr_bo(:,2)';
            h_rbf2.ZData = Pr_bo(:,3)';
            
            h_rbf3.XData = Pr_f(:,1)';
            h_rbf3.YData = Pr_f(:,2)';
            h_rbf3.ZData = Pr_f(:,3)';
            
            h_rbf4.XData = Pr_b1(:,1)';
            h_rbf4.YData = Pr_b1(:,2)';
            h_rbf4.ZData = Pr_b1(:,3)';
            
            h_rbf5.XData = Pr_b2(:,1)';
            h_rbf5.YData = Pr_b2(:,2)';
            h_rbf5.ZData = Pr_b2(:,3)';
            
            hold off
            % sub 12 21 22
            %clearpoints(h_st);
            %clearpoints(h_vt);
            %clearpoints(h_at);
            
            %h_st.addpoints([t(idx_t),t(idx_t),t(idx_t)],s(idx_t,:))
            %h_vt.addpoints([t(idx_t),t(idx_t),t(idx_t)],v(idx_t,:))
            %h_at.addpoints([t(idx_t),t(idx_t),t(idx_t)],a(idx_t,:))
                       
        end
    end
end
