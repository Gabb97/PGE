function [ E ] = BECAS_Q4_Ee( Cm, B )
%********************************************************
% File: BECAS_Q4_Ee.m
%   Function to evaluate matrix E for element Q4 (see
%   documentation).
%
% Syntax:
%   [ E ]=BECAS_Q4_Ee( Cm, B )
%
% Input:
%   Cm    : Material constitutive matrix
%   B     : B matrix
%
% Output:
%   E     : E matrix
%
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

E=(Cm*B)'*B;

end
