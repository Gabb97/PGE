function [ iJ, detJ ] = BECAS_Q4_Jacobian( xxs, yys, pr )
%********************************************************
% File: BECAS_Q4_Jacobian.m
%   Function to evaluate the Jacobian of the Q4 element.
%
% Syntax:
%   [ iJ, detJ ] = BECAS_Q4_Jacobian( xxs, yys, pr )
%
% Input:
%   xx, yy  :  Isoparametric coordinates
%   pr      :  Vector of nodal positions for element e
%
% Output:
%   iJ      :  Inverse of Jacobian matrix
%   detJ    :  Determinant of Jacobian matrix
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% Changes:
%   07.08.2012: Determinant is calculated using the expression instead of
%   the det function. This is faster.
%
% (c) DTU Wind Energy
%********************************************************

%Evaluate Jacobian matrix
t1 = 1 - yys;
t4 = 1 + yys;
t13 = 1 - xxs;
t15 = 1 + xxs;
J(1,1) = -(t1 * pr(1)) / 0.4e1 + (t1 * pr(3)) / 0.4e1 + (t4 * pr(5)) / 0.4e1 - (t4 * pr(7)) / 0.4e1;
J(1,2) = -(t1 * pr(2)) / 0.4e1 + (t1 * pr(4)) / 0.4e1 + (t4 * pr(6)) / 0.4e1 - (t4 * pr(8)) / 0.4e1;
J(1,3) = 0.0e0;
J(2,1) = -(t13 * pr(1)) / 0.4e1 - (t15 * pr(3)) / 0.4e1 + (t15 * pr(5)) / 0.4e1 + (t13 * pr(7)) / 0.4e1;
J(2,2) = -(t13 * pr(2)) / 0.4e1 - (t15 * pr(4)) / 0.4e1 + (t15 * pr(6)) / 0.4e1 + (t13 * pr(8)) / 0.4e1;
J(2,3) = 0.0e0;
J(3,1) = 0.0e0;
J(3,2) = 0.0e0;
J(3,3) = 0.1e1;

%Determine inverse
iJ=J\eye(3);

%Evaluate the determinant
detJ=J(1,1)*J(2,2)-J(1,2)*J(2,1);

end