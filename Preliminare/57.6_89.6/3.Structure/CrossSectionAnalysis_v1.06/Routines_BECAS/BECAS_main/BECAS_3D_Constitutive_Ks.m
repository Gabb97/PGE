function [ Ks, dX, dY, X, Y ] = BECAS_3D_Constitutive_Ks( k3d, nl_3d )
%********************************************************
% File: BECAS_3D_Constitutive_Ks.m
%   Function to calculate the 6x6 cross section stiffness matrix for
%   anisotropic and inhomogeneous sections of arbitrary geometry based on
%   a 3D FE model of a cross section slice. The function also returns the 
%   solutions matrices which are used for the evaluation of the strains in 
%   the cross section for a given vector of forces and moments.
%
% Syntax:
%   [ Ks, dX, dY, X, Y ]=BECAS_Constitutive_Ks( nl_2d, el_2d, emat,
%   matprops )
% Input:
%   k3d     :  Global stiffness FE matrix of 3D solid model
%   nl_3d   :  List of nodes in the solid model
%
% Output:
%   Ks      :  Cross section stiffness matrix
%   dX      :  Matrix of solutions dX/dz to cross section equilibrium
%              equations ( du/dz = dX/dz * theta )
%   dY      :  Matrix of solutions dY/dz to cross section equilibrium
%              equations ( dpsi/dz = dY/dz * theta )
%   dX      :  Matrix of solutions X to cross section equilibrium
%              equations ( u = X * theta )
%   dX      :  Matrix of solutions Y to cross section equilibrium
%              equations ( psi = Y * theta )
% Calls:
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

%% Print header for function
BECAS_PrintHeader

%% Gathering input data and building working arrays
[ utils ] = BECAS_3D_Utils( k3d, nl_3d);

%% Assemble global matrices
fprintf(1,'Started assembling matrices \n')
[Mg,Cg,Eg,Rg,Lg,Ag,Dg] = BECAS_3D_Assemble(utils.Kg_3d,utils);
fprintf(1,'Finished assembling matrices \n')

%% Uncomment to use with Matlab's LU
%Calculate cross section stiffness matrix using Matlab's lu solver (slow)
fprintf(1,'Started solving\n')
[Ks,dX,dY,X,Y] = BECAS_SolveLin(Mg,Cg,Eg,Rg,Lg,Ag,Dg);
fprintf(1,'Finished solving \n')

%% Uncomment to use with SuiteSparse
%Calculate cross section stiffness matrix using SuiteSparse KLU solver
%(fast)
% fprintf(1,'Started solving using SuiteSparse\n')
% [Ks,dX,dY,X,Y] = BECAS_SolveLin_SuiteSparse(Mg,Cg,Eg,Rg,Lg,Ag,Dg);
% fprintf(1,'Finished solving \n')

  
end