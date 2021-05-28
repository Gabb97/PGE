function [ B ] = BECAS_Q4_Be( xxs, yys, iJ )
%********************************************************
% File: BECAS_Q4_Be.m
%   Function to evaluate matrix B for element Q4 (see
%   documentation).
%
% Syntax:
%   [ B ]=BECAS_Q4_Be( xxb, yyb, iJ )
%
% Input:
%   xxs, yys :  Isoparametric coordinates
%   iJ       :  Inverse of Jacobian
%
% Output:
%   B        :  B matrix
%
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

B=zeros(6,12);
t1 = -1 + yys;
t3 = -1 + xxs;
t5 = (iJ(1,1) * t1) / 0.4e1 + (iJ(1,2) * t3) / 0.4e1;
t7 = -1 - xxs;
t9 = -(iJ(1,1) * t1) / 0.4e1 + (iJ(1,2) * t7) / 0.4e1;
t10 = 1 + yys;
t13 = (iJ(1,1) * t10) / 0.4e1 - (iJ(1,2) * t7) / 0.4e1;
t16 = -(iJ(1,1) * t10) / 0.4e1 - (iJ(1,2) * t3) / 0.4e1;
t19 = (iJ(2,1) * t1) / 0.4e1 + (iJ(2,2) * t3) / 0.4e1;
t22 = -(iJ(2,1) * t1) / 0.4e1 + (iJ(2,2) * t7) / 0.4e1;
t25 = (iJ(2,1) * t10) / 0.4e1 - (iJ(2,2) * t7) / 0.4e1;
t28 = -(iJ(2,1) * t10) / 0.4e1 - (iJ(2,2) * t3) / 0.4e1;
B(1,1) = t5;
B(1,4) = t9;
B(1,7) = t13;
B(1,10) = t16;
B(2,2) = t19;
B(2,5) = t22;
B(2,8) = t25;
B(2,11) = t28;
B(3,1) = t19;
B(3,2) = t5;
B(3,4) = t22;
B(3,5) = t9;
B(3,7) = t25;
B(3,8) = t13;
B(3,10) = t28;
B(3,11) = t16;
B(4,3) = t5;
B(4,6) = t9;
B(4,9) = t13;
B(4,12) = t16;
B(5,3) = t19;
B(5,6) = t22;
B(5,9) = t25;
B(5,12) = t28; 
   

end
