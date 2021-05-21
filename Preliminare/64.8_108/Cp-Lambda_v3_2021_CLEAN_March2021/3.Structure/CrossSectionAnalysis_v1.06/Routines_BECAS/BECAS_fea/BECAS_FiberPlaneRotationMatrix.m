function [ R ] = BECAS_FiberPlaneRotationMatrix( beta )
    
%Fiber plane orientations
cp=cosd(beta);
sp=sind(beta);
%Rotation matrices
R=[cp -sp 0; sp cp 0; 0 0 1];

end

