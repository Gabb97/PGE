function [ M, C, E, R, L, A, D ] = BECAS_3D_Assemble( Kgs, utils )
%********************************************************
% File: BECAS_3D_Assemble.m
%   Function to assemble the global 2D finite element matrices
%   associated with the determination of the cross section
%   stiffness matrix.
%
% Syntax:
%   [ M, C, E, R, L, A, D ] = BECAS_3D_Assemble( Kgs, utils )
%
% Input:
%   utils   :  Structure with input data, useful arrays, and
%              constants
% Output:
%   A       :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
%   R       :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
%   L       :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
%   M       :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
%   C       :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
%   E       :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
%   D       :  Sub-matrix of cross section equilibrium equations
%              holding the constraint equations (see Documentation)
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

%Build auxiliary matrices based on 3D FE global stiffness matrix
K11=sparse(Kgs(1:utils.nn_2d*3,1:utils.nn_2d*3));
K22=sparse(Kgs(utils.nn_2d*3+1:utils.nn_2d*3*2,utils.nn_2d*3+1:utils.nn_2d*3*2));
K12=sparse(Kgs(1:utils.nn_2d*3,utils.nn_2d*3+1:utils.nn_2d*3*2));
K21=sparse(K12');

%Build BECAS matrices based on auxiliary matrices
M=sparse(( (K11+K22) - 2*(K12+K21) )*utils.DeltaZ/6);
C=sparse(1/2*( (K11-K22) - (K12-K21) ));
E=sparse((K11 + K22 + K12 + K21)*1/utils.DeltaZ);

%Building Z matrix
Zg=sparse([],[],[],utils.nn_2d*3,6);
for i=1:utils.nn_2d
    Zg((i-1)*3+1,1)=1;
    Zg((i-1)*3+2,2)=1;
    Zg((i-1)*3+3,3)=1;
    Zg((i-1)*3+1,6)=-utils.nl_2d(i,3);
    Zg((i-1)*3+2,6)=utils.nl_2d(i,2);
    Zg((i-1)*3+3,4)=utils.nl_2d(i,3);
    Zg((i-1)*3+3,5)=-utils.nl_2d(i,2);
end

%Build remaining BECAS matrices
R=sparse(C*Zg);
L=sparse(M*Zg);
A=sparse(Zg'*M*Zg);

%Constraint matrix
[D] = BECAS_ConstraintMatrix(utils);

end