function [ Ms ] = BECAS_Constitutive_Ms( utils )
%% ********************************************************
% File: BECAS_Constitutive_Ks.m
%   Function to calculate the 6x6 cross section mass matrix for
%   anisotropic and inhomogeneous sections of arbitrary geometry. Mass
%   properties are obtained through integration in the FE mesh using the
%   interpolation functions from the corresponding elements.
%
% Syntax:
%   [ Ms ] = BECAS_Constitutive_Ms( utils )
%
% Input:
%   utils   :  Structure with all inputdata and other data necessary (see
%              BECAS_utils).
%
% Output:
%   Ms      :  Cross section mass matrix
%
% Calls:
%
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
%   Version 1.1    07.09.2012   José Pedro Blasques: Removed BECAS_utils 
%   and changed the input to receive the utils structure.
%
% (c) DTU Wind Energy
%********************************************************
fprintf(1,'> Started evaluating cross section mass matrix...')
%% Calculate cross section mass, center of mass, and moments of inertia
[Mass,xm,ym,Ixx,Iyy,Ixy]=BECAS_CalcSectionMassProps(utils);

%% Build cross section mass matrix
[Ms]=BECAS_Assemble_Ms(Mass,xm,ym,Ixx,Iyy,Ixy);
fprintf(1,'DONE! \n');

end

