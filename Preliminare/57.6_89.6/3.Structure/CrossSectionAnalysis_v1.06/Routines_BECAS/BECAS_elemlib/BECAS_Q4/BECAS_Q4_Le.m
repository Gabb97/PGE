function [ L ] = BECAS_Q4_Le( Cm, SN, SZ )
%********************************************************
% File: BECAS_Q4_Le.m
%   Function to evaluate matrix L for element Q4 (see
%   documentation).
%
% Syntax:
%   [ L ]=BECAS_Q4_Le( Cm, SN, SZ )
%
% Input:
%   Cm    : Material constitutive matrix
%   B     : B matrix
%   SZ    : SZ matrix
%
% Output:
%   L     : L matrix
%
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

L=(Cm*SN)'*SZ;

end
