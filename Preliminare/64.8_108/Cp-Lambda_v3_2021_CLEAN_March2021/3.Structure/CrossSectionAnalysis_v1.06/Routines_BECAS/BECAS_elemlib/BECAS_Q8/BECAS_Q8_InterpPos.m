function [ x, y ] = BECAS_Q8_InterpPos( pr, xxs, yys )
%********************************************************
% File: BECAS_Q8_InterpPos.m
%   Function to map a location in the isoparametric
%   coordinate system into the problem coordinate system
%   using a Q8 element.
%
% Syntax:
%   [ x, y ]=BECAS_Q8_InterpPos( pr, xx, yy )
%
% Input:
%   pr      :  Vector of nodal positions for element e
%   xx, yy  :  Isoparametric coordinates
%
% Output:
%   x, y    :  Problem coordinates
%
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************
t1 = 1 - xxs;
t2 = 1 - yys;
t4 = yys ^ 2;
t5 = 1 - t4;
t6 = t1 * t5;
t7 = xxs ^ 2;
t8 = 1 - t7;
t9 = t8 * t2;
t10 = t1 * t2 - t6 - t9;
t12 = 1 + xxs;
t14 = t12 * t5;
t15 = t12 * t2 - t9 - t14;
t17 = 1 + yys;
t21 = t8 * t17;
t22 = t21 / 0.8e1;
t23 = (t12 * t17) / 0.4e1 - t14 / 0.4e1 - t22;
t28 = (t1 * t17) / 0.4e1 - t22 - t6 / 0.4e1;
x = (t10 * pr(1)) / 0.4e1 + (t15 * pr(3)) / 0.4e1 + t23 * pr(5) + t28 * pr(7) + (t9 * pr(9)) / 0.2e1 + (t14 * pr(11)) / 0.2e1 + (t21 * pr(13)) / 0.4e1 + (t6 * pr(15)) / 0.2e1;
y = (t10 * pr(2)) / 0.4e1 + (t15 * pr(4)) / 0.4e1 + t23 * pr(6) + t28 * pr(8) + (t9 * pr(10)) / 0.2e1 + (t14 * pr(12)) / 0.2e1 + (t21 * pr(14)) / 0.4e1 + (t6 * pr(16)) / 0.2e1;


end