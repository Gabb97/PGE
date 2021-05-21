function [ varout ] = BECAS_rad2deg( varin )
%********************************************************
% File: BECAS_rad2deg.m
%   Function to turn angles in radians into degrees
%
% Syntax:
%   [ varout ] = BECAS_rad2deg( varin )
%
% Input:
%   varin   :  Angle in radians
%
% Output:
%   varout  :  Angle in degrees
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

%Turning radians to degrees
varout=varin*180/(pi);

end