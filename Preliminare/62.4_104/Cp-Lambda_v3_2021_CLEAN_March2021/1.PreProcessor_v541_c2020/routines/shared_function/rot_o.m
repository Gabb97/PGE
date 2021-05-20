%******************************************************************
%
%   [R] = rot_o(r)
%
%******************************************************************
%
%   Exponential map of rotations - evolution operator
%
%    given vector r of magnitude phi,
%    computes the rotation tensor R=exp(rx)
%
%   NB - the general form of the exponential map is
%
%           exp(C) = I + C + C^2/2 + C^3/3! + C^4/4! + ...
%
%        (see MATLAB function 'expm')
%
%******************************************************************
% Lorenzo Trainelli - DIA PoliMi - Nov 2002
%******************************************************************
%
function [R] = rot_o(r)
%
% >>> Ingredients
%
I = eye(3);
phi2 = r'*r;
phi = sqrt(phi2);
rx = cross_o(r);
%
% >>> Coefficients
%
if phi <= .02,
    %
    % >> Taylor expansion
    %
    R1 = 1 - (phi2/6 * (1 - phi2/20 * (1 - phi2/42 * (1 - phi2/72))));
    R2 = (1 - phi2/12 * (1 - phi2/30* (1 - phi2/56 * (1 - phi2/90)))) / 2;
else
    %
    % >>> Finite form
    %
    R1 = sin(phi) / phi;
    R2 = (1 - cos(phi)) / phi2;
end
%
% >>> Rotation tensor
%
R = I + R1*rx + R2*rx*rx;