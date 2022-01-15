function [Pr_top, Pr_bottom, Pr_front, Pr_back, Ps, Pimu] = my_RigidBody(size, s, phi, r)
    

    % rigidbody size
    width = size(1);  %x
    length = size(2); %y
    high = size(3);   %z

    % parameter
    sx = s(1);
    sy = s(2);
    sz = s(3);
    
    phix = phi(1);
    phiy = phi(2);
    phiz = phi(3);
    
    rx = r(1);
    ry = r(2);
    rz = r(3);
    
    % Rotation Matrix (z y x intrinsisch)
    Rz = [cos(phiz), -sin(phiz), 0; sin(phiz), cos(phiz), 0; 0,0,1];
    Ry = [cos(phiy), 0, sin(phiy); 0, 1, 0; 0, -sin(phiy), cos(phiy)];
    Rx = [1, 0, 0; 0, cos(phix), -sin(phix); 0, sin(phix), cos(phix)];
    
    R = Rz*Ry*Rx;
    
    
    % rigidbody position
    Pr_top(1,:) = [sx + width/2, sy + length/2, sz + high/2];
    Pr_top(2,:) = [sx - width/2, sy + length/2, sz + high/2];
    Pr_top(3,:) = [sx - width/2, sy - length/2, sz + high/2];
    Pr_top(4,:) = [sx + width/2, sy - length/2, sz + high/2];
    Pr_top(5,:) = [sx + width/2, sy + length/2, sz + high/2]; %close square
    
    Pr_bottom(1,:) = [sx + width/2, sy + length/2, sz - high/2];
    Pr_bottom(2,:) = [sx - width/2, sy + length/2, sz - high/2];
    Pr_bottom(3,:) = [sx - width/2, sy - length/2, sz - high/2];
    Pr_bottom(4,:) = [sx + width/2, sy - length/2, sz - high/2];
    Pr_bottom(5,:) = [sx + width/2, sy + length/2, sz - high/2]; %close square
    
    Pr_front(1,:) = [sx + width/2, sy - length/2, sz + high/2];
    Pr_front(2,:) = [sx - width/2, sy - length/2, sz + high/2];
    Pr_front(3,:) = [sx - width/2, sy - length/2, sz - high/2];
    Pr_front(4,:) = [sx + width/2, sy - length/2, sz - high/2];
    Pr_front(5,:) = [sx + width/2, sy - length/2, sz + high/2]; %close square
    
    Pr_back(1,:) = [sx + width/2, sy + length/2, sz + high/2];
    Pr_back(2,:) = [sx - width/2, sy + length/2, sz + high/2];
    Pr_back(3,:) = [sx - width/2, sy + length/2, sz - high/2];
    Pr_back(4,:) = [sx + width/2, sy + length/2, sz - high/2];
    Pr_back(5,:) = [sx + width/2, sy + length/2, sz + high/2]; %close square
    
    Pr_top = (R^(-1) * Pr_top.').';
    Pr_bottom = (R^(-1) * Pr_bottom.').';
    Pr_front = (R^(-1) * Pr_front.').';
    Pr_back = (R^(-1) * Pr_back.').';
    
    % centre of gravity position
    Ps(1) = sx;
    Ps(2) = sy;
    Ps(3) = sz;
    
    % IMU position
    Pimu(1) = sx + rx;
    Pimu(2) = sy + ry;
    Pimu(3) = sz + rz;
    
    Pimu = (R^(-1) * Pimu.').';
end