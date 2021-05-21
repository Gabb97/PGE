function [ utils ] = BECAS_3D_Utils( k3d, nl_3d )
%********************************************************
% File: BECAS_3D_Utils.m
%   This function generates the Matlab structure utils. which holds all the
%   input data and a number of other useful constants and arrays. The data
%   structure utils. is present in most BECAS_3D* functions.
%
% Syntax:
%   [ utils ] = BECAS_3D_Utils( k3d, nl_3d )
%
% Input:
%   k3d     :  Global stiffness FE matrix of 3D solid model
%   nl_3d   :  List of nodes in the solid model
%
% Output:
%   utils.  :  Structure holding the following arrays.
%   .Kg_3d  :  Global stiffnes matrix from 3D FE mesh
%   .nl_3d  :  Matrix of nodal coordinates for cross section 3D FE mesh
%   .nl_2d  :  Matrix of nodal coordinates for cross section 2D FE mesh
%   .nn_2d  :  Number of nodes in the cross section 2D FE mesh
%
% Calls:
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

%Storing input data
utils.Kg_3d=sparse(k3d(:,1),k3d(:,2),k3d(:,3));
utils.nl_3d=nl_3d;

%Integers
utils.nn_2d=size(utils.nl_3d,1)/2; %Number of nodes
utils.DeltaZ=utils.nl_3d(end,end);

%2D data from input
utils.nl_2d=utils.nl_3d(1:utils.nn_2d,:);
