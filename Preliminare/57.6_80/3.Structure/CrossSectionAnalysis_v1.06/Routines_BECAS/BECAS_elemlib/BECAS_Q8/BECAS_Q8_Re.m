function [R]=BECAS_Q8_Re(Cm,B,SZ)
%********************************************************
% File: BECAS_Q8_Re.m
%   Function to evaluate matrix R for element Q8 (see
%   documentation).
%
% Syntax:
%   [ R ]=BECAS_Q8_Re( Cm, B, SZ )
%
% Input:
%   Cm    : Material constitutive matrix
%   B     : B matrix
%   SZ    : SZ matrix
%
% Output:
%   R     : R matrix
%
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   Jos? Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

R=(Cm*B)'*SZ;

end