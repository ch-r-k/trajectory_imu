function [aB] = my_rotate(phi, aN, t)

    aB = zeros(length(t),3);
    
        
    for it = 1:length(t)
        phix = phi(it,1);
        phiy = phi(it,2);
        phiz = phi(it,3);
        
        Rz = [cos(phiz), -sin(phiz), 0; sin(phiz), cos(phiz), 0; 0,0,1];
        Ry = [cos(phiy), 0, sin(phiy); 0, 1, 0; 0, -sin(phiy), cos(phiy)];
        Rx = [1, 0, 0; 0, cos(phix), -sin(phix); 0, sin(phix), cos(phix)];

        R = Rz*Ry*Rx;
    
        aB(it,:) = (R * aN(it,:).').'; 
    end
    
    
end

