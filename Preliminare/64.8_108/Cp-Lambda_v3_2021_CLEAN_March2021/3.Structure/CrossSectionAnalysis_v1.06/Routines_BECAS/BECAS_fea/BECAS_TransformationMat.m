function [ M ] = BECAS_TransformationMat( M, p, alpha )
%********************************************************
% File: BECAS_TransformationMat.m
%   Function to rotate and translate cross section consitutive matrices.
%
% Syntax:
%   [ M ] = BECAS_TransformationMat( M, p, alpha )
%
% Input:
%   M    :  Cross section constitutive matrix
%   p    :  Translation vector
%   alpha:  Angle of rotation
%
% Output:
%   M    :  Rotated and translated matrix
%
% Calls:
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

%Matrix translation
T2=eye(6);
T2(1,6)=p(2);T2(2,6)=-p(1);T2(3,4)=-p(2);T2(3,5)=p(1);

%Transform matrix
M=T2'*M;M=M*T2;

%Matrix rotation
c=cosd(alpha);
s=sind(alpha);

R11=[c   s  0;
    -s  c  0;
    0   0  1];
R1=[R11      zeros(3);
    zeros(3) R11];

M=R1*M*R1';

end