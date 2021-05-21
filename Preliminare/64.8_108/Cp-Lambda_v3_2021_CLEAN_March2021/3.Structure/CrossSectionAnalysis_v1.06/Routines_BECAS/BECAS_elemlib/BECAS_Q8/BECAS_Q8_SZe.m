function [ SZ ] = BECAS_Q8_SZe( xxb, yyb )
%********************************************************
% File: BECAS_Q8_SZe.m
%   Function to evaluate matrix SZ for element Q8 (see
%   documentation).
%
% Syntax:
%   [ SZ ]=BECAS_Q8_SZe( xxb, yyb )
%
% Input:
%   xxb, yyb :  Global coordinates
%
% Output:
%   SZ       :  SZ matrix
%
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************
SZ=zeros(6,6);
SZ(4,1) = 1;
SZ(4,6) = -yyb;
SZ(5,2) = 1;
SZ(5,6) = xxb;
SZ(6,3) = 1;
SZ(6,4) = yyb;
SZ(6,5) = -xxb;

end