function [s_calc, v_calc, a_calc] = my_lin(s,option, t_)
    %f = @(x) sin(x);
    
    if strcmp(option,"sym")
        syms t;
        syms phi_tys(t);
    
        sx = s{1};
        sy = s{2};
        sz = s{3};
        
        % velocity
        temp(t) = diff(sym(sx));
        vx = matlabFunction(temp);
        temp(t) = diff(sym(sy));
        vy = matlabFunction(temp);
        temp(t) = diff(sym(sz));
        vz = matlabFunction(temp);
     
        % acceleration
        temp(t) = diff(sym(sx),2);
        ax = matlabFunction(temp);
        temp(t) = diff(sym(sy),2);
        ay = matlabFunction(temp);
        temp(t) = diff(sym(sz),2);
        az = matlabFunction(temp);
        
        
        % calc
        s_calc = zeros(length(t_),3);
        v_calc = zeros(length(t_),3);
        a_calc = zeros(length(t_),3);

        
        for it = 1:length(t_)
            s_calc(it,:) = [sx(t_(it))', sy(t_(it))', sz(t_(it))'];
            v_calc(it,:) = [vx(t_(it))', vy(t_(it))', vz(t_(it))'];
            a_calc(it,:) = [ax(t_(it))', ay(t_(it))', az(t_(it))'];
        end
        
    elseif strcmp(option,"num")
        sx = s(:,1);
        sy = s(:,2);
        sz = s(:,3);
        
        % velocity
        vx = gradient(sx,t_);
        vy = gradient(sy,t_);
        vz = gradient(sz,t_);
        
        % acceleration
        ax = gradient(vx,t_);
        ay = gradient(vy,t_);
        az = gradient(vz,t_);
        
        s_calc = [sx, sy, sz];
        v_calc = [vx, vy, vz];
        a_calc = [ax, ay, az];
        
    end
end

