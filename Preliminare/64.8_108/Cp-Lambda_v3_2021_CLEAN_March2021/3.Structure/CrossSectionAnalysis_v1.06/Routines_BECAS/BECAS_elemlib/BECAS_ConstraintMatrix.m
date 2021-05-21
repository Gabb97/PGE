function [ Kgc ] = BECAS_ConstraintMatrix( utils )
%********************************************************
% File: BECAS_ConstraintMatrix.m
%   Function to assemble the global 2D finite element matrix
%   associated with the constraints imposed on the cross
%   section warping displacements.
%
% Syntax:
%   [ Kgc ] = BECAS_ConstraintMatrix( utils )
% Input:
%   utils   :  Structure with input data, useful arrays, and
%              constants
% Output:
%   Kgc     :  Sub-matrix of cross section equilibrium equations
%              holding the constraint equations (see Documentation)
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

%Assemble constraint matrices
Kgc=zeros(6,utils.nn_2d*3);

%Average of displacements
Kgc(1,1:3:utils.nn_2d*3)=1;
Kgc(2,2:3:utils.nn_2d*3)=1;
Kgc(3,3:3:utils.nn_2d*3)=1;

%Average of rotations around X
for iii=1:utils.nn_2d
    Kgc(4,(iii-1)*3+2)=0;
    Kgc(4,(iii-1)*3+3)=utils.nl_2d(iii,3);
end

%Average of rotations around Y
for iii=1:utils.nn_2d
    Kgc(5,(iii-1)*3+1)=0;
    Kgc(5,(iii-1)*3+3)=-utils.nl_2d(iii,2);
end

%Average of rotations around Z
for iii=1:utils.nn_2d
    Kgc(6,(iii-1)*3+1)=-utils.nl_2d(iii,3);
    Kgc(6,(iii-1)*3+2)=utils.nl_2d(iii,2);
end
end