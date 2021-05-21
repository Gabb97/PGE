function [ SN ] = BECAS_Q8_SNe( xxs, yys )
%********************************************************
% File: BECAS_Q8_SNe.m
%   Function to evaluate matrix SN for element Q8 (see
%   documentation).
%
% Syntax:
%   [ SN ]=BECAS_Q8_SNe( xxs, yys )
%
% Input:
%   xxs, yys :  Isoparametric coordinates
%
% Output:
%   SN       :  SN matrix
%
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

SN=zeros(6,24);
t1 = 1 - xxs;
t2 = 1 - yys;
t4 = yys ^ 2;
t5 = 1 - t4;
t6 = t1 * t5;
t7 = xxs ^ 2;
t8 = 1 - t7;
t9 = t8 * t2;
t10 = t1 * t2 - t6 - t9;
t11 = 1 + xxs;
t13 = t11 * t5;
t14 = t11 * t2 - t9 - t13;
t15 = 1 + yys;
t17 = t8 * t15;
t18 = t11 * t15 - t17 - t13;
t20 = t1 * t15 - t17 - t6;
t21 = t9 / 0.2e1;
t22 = t13 / 0.2e1;
t23 = t17 / 0.2e1;
t24 = t6 / 0.2e1;
SN(4,1) = (t10 / 0.4e1);
SN(4,4) = (t14 / 0.4e1);
SN(4,7) = (t18 / 0.4e1);
SN(4,10) = (t20 / 0.4e1);
SN(4,13) = t21;
SN(4,16) = t22;
SN(4,19) = t23;
SN(4,22) = t24;
SN(5,2) = (t10 / 0.4e1);
SN(5,5) = (t14 / 0.4e1);
SN(5,8) = (t18 / 0.4e1);
SN(5,11) = (t20 / 0.4e1);
SN(5,14) = t21;
SN(5,17) = t22;
SN(5,20) = t23;
SN(5,23) = t24;
SN(6,3) = (t10 / 0.4e1);
SN(6,6) = (t14 / 0.4e1);
SN(6,9) = (t18 / 0.4e1);
SN(6,12) = (t20 / 0.4e1);
SN(6,15) = t21;
SN(6,18) = t22;
SN(6,21) = t23;
SN(6,24) = t24;


end