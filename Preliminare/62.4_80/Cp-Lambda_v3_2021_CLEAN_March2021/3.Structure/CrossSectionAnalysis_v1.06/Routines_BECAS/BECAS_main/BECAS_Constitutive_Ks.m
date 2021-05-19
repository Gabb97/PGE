function [ Ks, solvec]=BECAS_Constitutive_Ks( utils )
%********************************************************
% File: BECAS_Constitutive_Ks.m
%   Function to calculate the 6x6 cross section stiffness matrix for
%   anisotropic and inhomogeneous sections of arbitrary geometry. This
%   function also returns the solutions matrices which are used for the
%   evaluation of the strains in the cross section for a given vector of
%   forces and moments.
%
% Syntax:
%   [ Ks, solvec ]=BECAS_Constitutive_Ks( utils )
%
% Input:
%   utils   :  Structure with all inputdata and other data necessary (see
%              BECAS_utils).
%
% Output:
%   Ks        :  Cross section stiffness matrix
%   solvec.dX :  Matrix of solutions dX/dz to cross section equilibrium
%              equations ( du/dz = dX/dz * theta )
%   solvec.dY :  Matrix of solutions dY/dz to cross section equilibrium
%              equations ( dpsi/dz = dY/dz * theta )
%   solvec.X  :  Matrix of solutions X to cross section equilibrium
%              equations ( u = X * theta )
%   solvec.Y  :  Matrix of solutions Y to cross section equilibrium
%              equations ( psi = Y * theta )
% Calls:
%   utils.m, BECAS_Assemble.m, and BECAS_SolveLin or
%   BECAS_SolveLin_SuiteSparse if SuiteSparse is installed.
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
%   Version 1.1    07.09.2012   José Pedro Blasques: Included a new solver
%   based on the Schur complement. Significantly faster than the two
%   previous solvers (even after updating). Removed BECAS_utils and changed
%   the input to receive the utils structure. Changed output to gather the
%   solutin vectors in a structure.
%   Version 1.2    28.09.2012   José Pedro Blasques: Header to BECAS is no
%   longer printed here and is moved to BECAS_utils.
%
% (c) DTU Wind Energy
%********************************************************


%% Assemble global matrices
fprintf(1,'> Started assembling matrices... ')
[Ag,Rg,Lg,Mg,Cg,Eg,Dg] = BECAS_Assemble_Ks(utils);
fprintf(1,'DONE! \n');

%% Uncomment to use with Matlab's lu
%Calculate cross section stiffness matrix using Matlab's lu solver 
% tic
% fprintf(1,'> Started solving using Matlab lu\n')
% [Ks,solvec.dX,solvec.dY,solvec.X,solvec.Y] = BECAS_SolveLin(Mg,Cg,Eg,Rg,Lg,Ag,Dg);
% toc
% fprintf(1,'> Finished solving \n')
%% Uncomment to use with SuiteSparse
%Calculate cross section stiffness matrix using SuiteSparse KLU solver
% tic
% fprintf(1,'> Started solving using SuiteSparse\n')
% [Ks,solvec.dX,solvec.dY,solvec.X,solvec.Y] = BECAS_SolveLin_SuiteSparse(Mg,Cg,Eg,Rg,Lg,Ag,Dg);
% toc
% fprintf(1,'> Finished solving \n')
%% Uncomment to use with Schur complement and Matlab's lu 
%Calculate cross section stiffness matrix using Schur complement and
%Matlab's lu
fprintf(1,'> Started solving using Schur complement and Matlab lu...')
% tic
[ Ks, solvec.dX, solvec.dY, solvec.X, solvec.Y ] = BECAS_SolveLin_Schur( Mg, Cg, Eg, Rg, Lg, Ag, Dg );
% toc
fprintf(1,'DONE! \n');

end