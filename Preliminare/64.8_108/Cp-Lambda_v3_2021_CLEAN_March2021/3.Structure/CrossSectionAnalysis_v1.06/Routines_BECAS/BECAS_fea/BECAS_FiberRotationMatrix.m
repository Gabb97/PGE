function [ R ] = BECAS_FiberRotationMatrix( alpha )

%Fiber orientations
cf=cosd(alpha);
sf=sind(alpha);
%Rotation matrices
R=[cf 0 sf;0 1 0; -sf 0 cf];

end

