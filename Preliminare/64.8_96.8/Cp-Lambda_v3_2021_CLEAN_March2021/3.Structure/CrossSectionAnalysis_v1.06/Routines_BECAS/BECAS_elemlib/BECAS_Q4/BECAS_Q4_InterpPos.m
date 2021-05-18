function [ x, y ]=BECAS_Q4_InterpPos( pr, xx, yy )
%********************************************************
% File: BECAS_2DQ4.m
%   Function to map a location in the isoparametric
%   coordinate system into the problem coordinate system
%   using a Q4 element.
%
% Syntax:
%   [ x, y ]=BECAS_Q4_InterpPos( pr, xx, yy )
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

t1 = 1 - xx;
t2 = 1 - yy;
t3 = t1 * t2;
t5 = 1 + xx;
t6 = t5 * t2;
t8 = 1 + yy;
t9 = t5 * t8;
t11 = t1 * t8;
x = (t3 * pr(1)) / 0.4e1 + (t6 * pr(3)) / 0.4e1 + (t9 * pr(5)) / 0.4e1 + (t11 * pr(7)) / 0.4e1;
y = (t3 * pr(2)) / 0.4e1 + (t6 * pr(4)) / 0.4e1 + (t9 * pr(6)) / 0.4e1 + (t11 * pr(8)) / 0.4e1;

end