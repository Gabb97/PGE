function [ M ] = BECAS_Q8_Me( Cm, SN )
%********************************************************
% File: BECAS_Q8_Me.m
%   Function to evaluate matrix M for element Q8 (see
%   documentation).
%
% Syntax:
%   [ M ]=BECAS_Q8_Me( Cm, SN )
%
% Input:
%   Cm    : Material constitutive matrix
%   SN    : SN matrix
%
% Output:
%   M     :  M matrix
%
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

M=(Cm*SN)'*SN;

end