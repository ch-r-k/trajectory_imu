function [aIMU] = my_imu(aB, omega, alpha, r, t)

    aIMU = zeros(length(t),3);
    
    for it = 1:length(t)
        aIMU(it,:) =    aB(it,:)...
                        + cross(omega(it,:),cross(omega(it,:),r))... 
                        + cross(alpha(it,:),r); 
    end
    
    
end

