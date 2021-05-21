function [ M ] = BECAS_Q4_Me( Cm, SN )
%********************************************************
% File: BECAS_Q4_Me.m
%   Function to evaluate matrix M for element Q4 (see
%   documentation).
%
% Syntax:
%   [ M ]=BECAS_Q4_Me( Cm, SN )
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
%   Version 1.0    07.02.2012   Jos� Pedro Blasques
%
% Changes:
%   07.08.2012: Rewrote the expression to improve speed.
%
% (c) DTU Wind Energy
%********************************************************

M=SN'*Cm*SN;

end
