function [ Ms ] = BECAS_Assemble_Ms( Mass, xm, ym, Ixx, Iyy, Ixy )
%********************************************************
% File: BECAS_Assemble_Ms.m
%   Function to assemble the 6x6 cross section mass matrix.
%
% Syntax:
%   [ Ms ] = BECAS_Assemble_Ms( Mass, xm, ym, Ixx, Iyy, Ixy )
%
% Input:
%   Mass    :  Mass per unit length or mass of cross section
%   xm, ym  :  Coordinates of mass center
%   Ixx, Iyy, Ixy :  Cross section moment of inertia
%
% Output:
%   Ms      :  Cross section mass matrix
%
% Calls:
%
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%   Version 1.1    07.02.2012   José Pedro Blasques: The sign of the entry
%   Ms(4,5) has been corrected.
%
% (c) DTU Wind Energy
%********************************************************

%Assemble mass matrix w.r.t. mass center
Ms11=[ Mass     0           0   ;
    0        Mass        0   ;
    0        0           Mass];
Ms12=[ 0          0      -Mass*ym;
    0          0          Mass*xm;
    Mass*ym    -Mass*xm   0      ];
Ms22=[ Ixx     -Ixy        0      ;
    -Ixy     Iyy        0      ;
    0       0          Ixx+Iyy];
Ms=[Ms11  Ms12;
    -Ms12 Ms22];

end