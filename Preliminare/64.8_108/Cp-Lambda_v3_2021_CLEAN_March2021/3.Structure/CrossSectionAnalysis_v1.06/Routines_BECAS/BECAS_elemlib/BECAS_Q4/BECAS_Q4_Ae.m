function [ A ] = BECAS_Q4_Ae( Cm, SZ )
%********************************************************
% File: BECAS_Q4_Ae.m
%   Function to evaluate matrix A for element Q4 (see
%   documentation).
%
% Syntax:
%   [ A ]=BECAS_Q4_Ae( Cm, SZ )
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
%   Version 1.0    07.02.2012   Jos� Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

A=(Cm*SZ)'*SZ;


end
