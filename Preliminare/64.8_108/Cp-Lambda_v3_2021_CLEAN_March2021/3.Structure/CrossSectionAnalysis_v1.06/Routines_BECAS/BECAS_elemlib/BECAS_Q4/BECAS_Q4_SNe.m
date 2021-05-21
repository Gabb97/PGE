function [ SN ]=BECAS_Q4_SNe( xxs, yys )
%********************************************************
% File: BECAS_Q4_SNe.m
%   Function to evaluate matrix SN for element Q4 (see
%   documentation).
%
% Syntax:
%   [ SN ]=BECAS_Q4_SNe( xxs, yys )
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

SN=zeros(6,12);
t1 = 1 - xxs;
t2 = 1 - yys;
t4 = (t1 * t2) / 0.4e1;
t5 = 1 + xxs;
t7 = (t5 * t2) / 0.4e1;
t8 = 1 + yys;
t10 = (t5 * t8) / 0.4e1;
t12 = (t1 * t8) / 0.4e1;
SN(4,1) = t4;
SN(4,4) = t7;
SN(4,7) = t10;
SN(4,10) = t12;
SN(5,2) = t4;
SN(5,5) = t7;
SN(5,8) = t10;
SN(5,11) = t12;
SN(6,3) = t4;
SN(6,6) = t7;
SN(6,9) = t10;
SN(6,12) = t12;

end