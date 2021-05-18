function [ iJ, detJ ] = BECAS_Q8_Jacobian( xxs, yys, pr )
%********************************************************
% File: BECAS_Q8_Jacobian.m
%   Function to evaluate the Jacobian of the Q4 element.
%
% Syntax:
%   [ iJ, detJ ] = BECAS_Q8_Jacobian( xxs, yys, pr )
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

%Evalaute Jacobian matrx
J=zeros(3,3);
t1 = yys / 0.4e1;
t2 = yys ^ 2;
t3 = t2 / 0.4e1;
t5 = xxs * (0.1e1 - yys);
t6 = t5 / 0.2e1;
t7 = t1 - t3 + t6;
t9 = -t1 + t6 + t3;
t12 = xxs * (0.1e1 + yys);
t13 = t12 / 0.2e1;
t14 = t1 + t13 + t3;
t16 = -t1 + t13 - t3;
t19 = 0.1e1 - t2;
t37 = xxs / 0.4e1;
t39 = (0.1e1 - xxs) * yys;
t40 = t39 / 0.2e1;
t41 = xxs ^ 2;
t42 = t41 / 0.4e1;
t43 = t37 + t40 - t42;
t46 = (0.1e1 + xxs) * yys;
t47 = t46 / 0.2e1;
t48 = -t37 - t42 + t47;
t50 = t37 + t42 + t47;
t52 = -t37 + t42 + t40;
t54 = 0.1e1 - t41;
J(1,1) = t7 * pr(1) + t9 * pr(3) + t14 * pr(5) + t16 * pr(7) - t5 * pr(9) + t19 * pr(11) / 0.2e1 - t12 * pr(13) - t19 * pr(15) / 0.2e1;
J(1,2) = t7 * pr(2) + t9 * pr(4) + t14 * pr(6) + t16 * pr(8) - t5 * pr(10) + t19 * pr(12) / 0.2e1 - t12 * pr(14) - t19 * pr(16) / 0.2e1;
J(2,1) = t43 * pr(1) + t48 * pr(3) + t50 * pr(5) + t52 * pr(7) - t54 * pr(9) / 0.2e1 - t46 * pr(11) + t54 * pr(13) / 0.2e1 - t39 * pr(15);
J(2,2) = t43 * pr(2) + t48 * pr(4) + t50 * pr(6) + t52 * pr(8) - t54 * pr(10) / 0.2e1 - t46 * pr(12) + t54 * pr(14) / 0.2e1 - t39 * pr(16);
J(3,3) = 0.1e1;

%Evaluate determinant of Jacobian
detJ=J(1,1)*J(2,2)-J(1,2)*J(2,1);

%Evaluate inverse
iJ=J\eye(3);

end