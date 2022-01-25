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
    phiz = phi(3)+pi/2;
    
    rx = r(1);
    ry = r(2);
    rz = r(3);
    
    % Rotation Matrix (z y x intrinsisch)
    %Rz = [cos(phiz), -sin(phiz), 0; sin(phiz), cos(phiz), 0; 0,0,1];
    %Ry = [cos(phiy), 0, sin(phiy); 0, 1, 0; 0, -sin(phiy), cos(phiy)];
    %Rx = [1, 0, 0; 0, cos(phix), -sin(phix); 0, sin(phix), cos(phix)];
    
    % Rotation Matrix (z y x intrinsisch)
    Rz = [  cos(phiz),   -sin(phiz),  0;...
            sin(phiz),   cos(phiz),   0;...
            0,              0,              1];

    Ry = [  cos(phiy),   0,  sin(phiy);...
            0,              1,  0;...
            -sin(phiy),  0,  cos(phiy)];

    Rx = [  1,  0,              0;...
            0,  cos(phix),   -sin(phix);...
            0,  sin(phix),   cos(phix)];
    
    R = Rz*Ry*Rx;
    
    % rigidbody
    Pr_top(1,:) = [0 +       0, 0 + length/2, 0 + high/2];
    Pr_top(2,:) = [0 - width/2, 0 - length/2, 0 + high/2];
    Pr_top(3,:) = [0 + width/2, 0 - length/2, 0 + high/2];
    Pr_top(4,:) = [0 +       0, 0 + length/2, 0 + high/2];
    %Pr_top(5,:) = [0 + width/2, 0 + length/2, 0 + high/2]; %close square
    
    Pr_bottom(1,:) = [0 +       0, 0 + length/2, 0 - high/2];
    Pr_bottom(2,:) = [0 - width/2, 0 - length/2, 0 - high/2];
    Pr_bottom(3,:) = [0 + width/2, 0 - length/2, 0 - high/2];
    Pr_bottom(4,:) = [0 +       0, 0 + length/2, 0 - high/2];
    %Pr_top(5,:) = [0 + width/2, 0 + length/2, 0 + high/2]; %close square
    
    Pr_front(1,:) = [0 + width/2, 0 - length/2, 0 + high/2];
    Pr_front(2,:) = [0 - width/2, 0 - length/2, 0 + high/2];
    Pr_front(3,:) = [0 - width/2, 0 - length/2, 0 - high/2];
    Pr_front(4,:) = [0 + width/2, 0 - length/2, 0 - high/2];
    Pr_front(5,:) = [0 + width/2, 0 - length/2, 0 + high/2]; %close square
    
    Pr_back(1,:) = [0 + 0, 0 + length/2, 0 + high/2];
    Pr_back(2,:) = [0 - 0, 0 + length/2, 0 + high/2];
    Pr_back(3,:) = [0 - 0, 0 + length/2, 0 - high/2];
    Pr_back(4,:) = [0 + 0, 0 + length/2, 0 - high/2];
    Pr_back(5,:) = [0 + 0, 0 + length/2, 0 + high/2]; %close square
    
    Pr_top = (R^(-1) * Pr_top.').';
    Pr_bottom = (R^(-1) * Pr_bottom.').';
    Pr_front = (R^(-1) * Pr_front.').';
    Pr_back = (R^(-1) * Pr_back.').';
    
    % rigidbody position
    Pr_top(:,1) = sx + Pr_top(:,1);
    Pr_top(:,2) = sy + Pr_top(:,2);
    Pr_top(:,3) = sz + Pr_top(:,3);
    
    Pr_bottom(:,1) = sx + Pr_bottom(:,1);
    Pr_bottom(:,2) = sy + Pr_bottom(:,2);
    Pr_bottom(:,3) = sz + Pr_bottom(:,3);
    
    Pr_front(:,1) = sx + Pr_front(:,1);
    Pr_front(:,2) = sy + Pr_front(:,2);
    Pr_front(:,3) = sz + Pr_front(:,3);
    
    Pr_back(:,1) = sx + Pr_back(:,1);
    Pr_back(:,2) = sy + Pr_back(:,2);
    Pr_back(:,3) = sz + Pr_back(:,3);
     
    
    % centre of gravity position
    Ps(1) = sx;
    Ps(2) = sy;
    Ps(3) = sz;
    
    % IMU position
    Pimu(1) = rx;
    Pimu(2) = ry;
    Pimu(3) = rz;
    
    Pimu = (R^(-1) * Pimu.').';
        
    Pimu(1) = sx + Pimu(1);
    Pimu(2) = sy + Pimu(2);
    Pimu(3) = sz + Pimu(3);
end