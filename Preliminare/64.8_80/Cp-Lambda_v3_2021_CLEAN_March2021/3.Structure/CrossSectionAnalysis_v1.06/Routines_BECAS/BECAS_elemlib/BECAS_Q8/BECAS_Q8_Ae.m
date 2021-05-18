function [ A ] = BECAS_Q8_Ae( Cm, SZ )
%********************************************************
% File: BECAS_Q8_Ae.m
%   Function to evaluate matrix A for element Q8 (see
%   documentation).
%
% Syntax:
%   [ A ]=BECAS_Q8_Ae( Cm, SZ )
%
% Input:
%   Cm    : Material constitutive matrix
%   SZ    : SZ matrix
%
% Output:
%   A     : A matrix
%
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

A=(Cm*SZ)'*SZ;


end

