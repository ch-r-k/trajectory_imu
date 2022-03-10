function [phi_tz, phi_ty, phi_tx, ta] = my_tang(v, t)
    % tangential angle
    vx = v(:,1);
    vy = v(:,2);
    vz = v(:,3);
    
    tx = vx ./ sqrt(vx.^2 + vy.^2 + vz.^2);
    ty = vy ./ sqrt(vx.^2 + vy.^2 + vz.^2);
    tz = vz ./ sqrt(vx.^2 + vy.^2 + vz.^2);

    ta = [tx,ty,tz];
   
    % yaw 
    phi_tz = atan2(ty, tx);

    % pitch
    t_xyz = sqrt(tx.^2 + ty.^2 + tz.^2);
    
    phi_ty = -asin(tz./t_xyz);
    

    %roll
    phi_tx = zeros(length(t),1);
    
end