function [ Ks, X1, Y1, X0, Y0 ] = ...
    BECAS_SolveLin_SuiteSparse( M, C, E, R, L, A, D )
%********************************************************
% File: BECAS_SolveLin_SuiteSparse.m
%   Function to solve the linear system of equations associated
%   with the cross section equilibrium equations.
%
%   *NOTE*: This function makes use of the KLU function part of the
%   SuiteSparse package. (see
%   http://www.cise.ufl.edu/research/sparse/SuiteSparse/ )
%
% Syntax:
%   [ Ks, X1, Y1, X0, Y0 ] = ...
%    BECAS_SolveLin_SuiteSparse( M, C, E, R, L, A, D )
% Input:
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
% Output:
%   Ks      :  Cross section stiffness matrix
%   X1      :  Matrix of solutions dX/dz to cross section equilibrium
%              equations ( du/dz = dX/dz * theta )
%   Y1      :  Matrix of solutions dY/dz to cross section equilibrium
%              equations ( dpsi/dz = dY/dz * theta )
%   X0      :  Matrix of solutions X to cross section equilibrium
%              equations ( u = X * theta )
%   Y0      :  Matrix of solutions Y to cross section equilibrium
%              equations ( psi = Y * theta )
% Calls:
%
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%   Version 1.1    29.08.2012   José Pedro Blasques: K1 is symmeterized before
%   factorization (to eliminate small discrepancies). Matrix K1 and m2 are
%   now built by concatenation as this is faster.
%
% (c) DTU Wind Energy
%********************************************************

%Define matrix T
T=zeros(6,6);
T(1,5)=-1;
T(2,4)=1;

%Build coefficient matrix including constraints
K11=[E;   R';  D       ];
K12=[R;   A ;  zeros(6) ];
K13=[D';  zeros(6); zeros(6) ];
K1=horzcat(K11,K12,K13);
K1=(K1+K1')/2;

%Build right hand side
rhs1=sparse2([zeros(size(E,1),6);
    T'                ;
    zeros(6)          ]);

%Using UMPACK
LU=klu(K1);
s1 = klu (LU,'\',full(rhs1));

%Extracting state variables from solution vector
X1=s1(1:size(E,1),:);
Y1=s1(size(E,1)+1:size(E,1)+size(A,1),:);


%Build right hand side
rhs21=sparse([-C'+C               L         zeros(size(C,1),6);
    -L'                 zeros(6)  zeros(6)          ;
    zeros(6,size(C,1))  zeros(6)  zeros(6)          ]);
rhs22=sparse2([X1 ;
    Y1 ;
    zeros(6)     ]);
rhs23=sparse2([zeros(size(C,1),6);
    eye(6)            ;
    zeros(6)          ]);
rhs2=rhs21*rhs22+rhs23;

%Using UMPACK
s0 = klu (LU,'\',full(rhs2));

%Extracting state variables from solution vector
X0=s0(1:size(E,1),:);
Y0=s0(size(E,1)+1:size(E,1)+size(A,1),:);

%Flexibility matrix
m1=[X1; X0; Y0;];
m21=[M;C';L'];
m22=[C;E;R'];
m23=[L;R;A];
m2=horzcat(m21,m22,m23);

Fs=m1'*m2*m1;

%Stiffness matrix
Ks=Fs\eye(6);

end