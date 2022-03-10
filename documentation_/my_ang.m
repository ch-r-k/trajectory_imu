function [phi_calc, omega_calc, alpha_calc] = my_ang(phi, option, t_)
    %f = @(x) sin(x);
    syms t;
    
    if strcmp(option,"sym")
        phix = phi{1};
        phiy = phi{2};
        phiz = phi{3};
        
        % Rotation Matrix (z y x intrinsisch)
        Rz = @(t) [ cos(phiz(t)),   -sin(phiz(t)),  0;...
                    sin(phiz(t)),   cos(phiz(t)),   0;...
                    0,              0,              1];
        
        Ry = @(t) [ cos(phiy(t)),   0,  sin(phiy(t));...
                    0,              1,  0;...
                    -sin(phiy(t)),  0,  cos(phiy(t))];
        
        Rx = @(t) [ 1,  0,              0;...
                    0,  cos(phix(t)),   -sin(phix(t));...
                    0,  sin(phix(t)),   cos(phix(t))];

        R = @(t) Rz(t)*Ry(t)*Rx(t);
    
        % velocity
        R_(t) = diff(sym(R));
        
        Omega_s = simplify(R_(t) * R(t)^(-1));
        omega_x_s(t) = -Omega_s(2,3);
        omega_y_s(t) =  Omega_s(1,3);
        omega_z_s(t) = -Omega_s(1,2);
        
        omega_x = matlabFunction(omega_x_s);
        omega_y = matlabFunction(omega_y_s);
        omega_z = matlabFunction(omega_z_s);
        
        % acceleration
        alpha_x_s(t) = diff(omega_x_s(t));
        alpha_y_s(t) = diff(omega_y_s(t));
        alpha_z_s(t) = diff(omega_z_s(t));
        
        alpha_x = matlabFunction(alpha_x_s);
        alpha_y = matlabFunction(alpha_y_s);
        alpha_z = matlabFunction(alpha_z_s);
        
        % calc points
        phi_calc = zeros(length(t_),3);
        omega_calc = zeros(length(t_),3);
        alpha_calc = zeros(length(t_),3);
        
        for it = 1:length(t_)
            
            % phi
            temp = phix(t_(it));
            phi_calc(it,1) = temp(1);
            
            temp = phiy(t_(it));
            phi_calc(it,2) = temp(1);
            
            temp = phiz(t_(it));
            phi_calc(it,3) = temp(1);
            
            % omega
            temp = omega_x(t_(it));
            omega_calc(it,1) = temp(1);
            
            temp = omega_y(t_(it));
            omega_calc(it,2) = temp(1);
            
            temp = omega_z(t_(it));
            omega_calc(it,3) = temp(1);
            
            % alpha
            temp = alpha_x(t_(it));
            alpha_calc(it,1) = temp(1);
            
            temp = alpha_y(t_(it));
            alpha_calc(it,2) = temp(1);
            
            temp = alpha_z(t_(it));
            alpha_calc(it,3) = temp(1);
            
        end
        
    elseif strcmp(option,"num")
        phix = phi(:,1);
        phiy = phi(:,2);
        phiz = phi(:,3);
        
        phi_calc = phi;
        
        % Rotation Matrix (z y x intrinsisch)
        for it = 1:length(t_)
            Rz =  [ cos(phiz(it)),   -sin(phiz(it)),  0;...
                    sin(phiz(it)),   cos(phiz(it)),   0;...
                    0,              0,              1];

            Ry =  [ cos(phiy(it)),   0,  sin(phiy(it));...
                    0,           1,  0;...
                    -sin(phiy(it)),  0,  cos(phiy(it))];

            Rx=  [  1,  0,           0;...
                    0,  cos(phix(it)),   -sin(phix(it));...
                    0,  sin(phix(it)),   cos(phix(it))];
                
            R(:,:,it) = Rz*Ry*Rx;
        end
        
        % calc angular velocity
        
        dR11 = gradient(reshape(R(1,1,:),1,length(t_)),t_);
        dR12 = gradient(reshape(R(1,2,:),1,length(t_)),t_);
        dR13 = gradient(reshape(R(1,3,:),1,length(t_)),t_);
        
        dR21 = gradient(reshape(R(2,1,:),1,length(t_)),t_);
        dR22 = gradient(reshape(R(2,2,:),1,length(t_)),t_);
        dR23 = gradient(reshape(R(2,3,:),1,length(t_)),t_);
        
        dR31 = gradient(reshape(R(3,1,:),1,length(t_)),t_);
        dR32 = gradient(reshape(R(3,2,:),1,length(t_)),t_);
        dR33 = gradient(reshape(R(3,3,:),1,length(t_)),t_);
        
        omega_calc = zeros(length(t_),3);
         
        for it = 1:length(t_)
            temp = reshape(R(:,:,it),3,3);
            
            dtemp = [dR11(it), dR12(it), dR13(it);...
                	dR21(it), dR22(it), dR23(it);...
                    dR31(it), dR32(it), dR33(it)];
            
            Omega = dtemp * temp^(-1);
            
            omega_calc(it,1) = -Omega(2,3);
            omega_calc(it,2) =  Omega(1,3);
            omega_calc(it,3) = -Omega(1,2);
        end
        
        % calc angular acceleration
        alpha_calc(:,1) = gradient(omega_calc(:,1),t_);
        alpha_calc(:,2) = gradient(omega_calc(:,2),t_);
        alpha_calc(:,3) = gradient(omega_calc(:,3),t_);
        
    end
end

