function [R,phi,k] = CRV_ComputeRotationTensor(CRV)

f = norm(CRV);
if f>1.0e-6
    k = CRV/f;
    phi = 4*atan(f/4);
    r = phi*k;
    R = so3(r);
else
    phi = 0;
    k = [0 0 0];
    R = eye(3);
end
return

%
%******************************************************************
%
%   Exponential map of rotations
%
%   Evolution operator
%
%   - given vector r of magnitude phi,
%     computes the rotation tensor R=exp(rx)
%
%******************************************************************
%
function [R] = so3(r)

% Check if row or column
if (size(r,1)<size(r,2))
    r = r';
end

%
% >>> Ingredients
%
I = eye(3);
phi2 = r'*r;
phi = sqrt(phi2);
rx = [    0,-r(3), r(2);
       r(3),    0,-r(1);
      -r(2), r(1),    0];
%
% >>> Coefficients
%
c1 = -.5;
%
if phi <= .0002,
 %
 % >> Taylor expansion 
 %
 a1 = 1 - (phi2/6 * (1 - phi2/20 * (1 - phi2/42 * (1 - phi2/72))));
 a2 = (1 - phi2/12 * (1 - phi2/30 * (1 - phi2/56 * (1 - phi2/90)))) / 2;
else
 %
 % >> Finite form
 %
 a1 = sin(phi) / phi;
 a2 = (1 - cos(phi)) / phi2;
end
%
% >>> Evolution tensor (rotation tensor)
%
R = I + a1*rx + a2*rx*rx;
