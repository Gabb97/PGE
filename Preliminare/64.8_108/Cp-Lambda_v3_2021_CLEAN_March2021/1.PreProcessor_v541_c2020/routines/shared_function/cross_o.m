%******************************************************************
%
%   [vx] = cross_o(v)
%
%******************************************************************
%
%   Vector product operator
%
%    given vector v,
%    computes the vector product operator vx
%
%    (vector v is the axial vector of skewsymmetric tensor vx)
%
%******************************************************************
% Lorenzo Trainelli - DIA PoliMi - Nov 2002
%******************************************************************
%
function [vx] = cross_o(v)
%
% >>> Operator
%
vx = [  0   -v(3)  v(2) ;
       v(3)   0   -v(1) ;
      -v(2)  v(1)    0  ];