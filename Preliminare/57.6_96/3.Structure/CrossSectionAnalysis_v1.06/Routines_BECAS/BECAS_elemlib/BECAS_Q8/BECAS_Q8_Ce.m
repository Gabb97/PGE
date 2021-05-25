function [ C ] = BECAS_Q8_Ce( Cm, B, SN )
%********************************************************
% File: BECAS_Q8_Ce.m
%   Function to evaluate matrix C for element Q8 (see
%   documentation).
%
% Syntax:
%   [ C ]=BECAS_Q8_Ce( Cm, B, SN )
%
% Input:
%   Cm    : Material constitutive matrix
%   B     : B matrix
%   SN    : SN matrix
%
% Output:
%   C     : C matrix
%
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

C=(Cm*B)'*SN;

end