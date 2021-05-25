function [ Ks, X1, Y1, X0, Y0 ] = BECAS_SolveLin( M, C, E, R, L, A, D )
%********************************************************
% File: BECAS_SolveLin.m
%   Function to solve the linear system of equations associated
%   with the cross section equilibrium equations using lu factorization.
%
% Syntax:
%   [ Ks, X1, Y1, X0, Y0 ] = BECAS_SolveLin( M, C, E, R, L, A, D )
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
%
%   Version 1.1    27.08.2012   José and Robert: lu is now called with
%   [L,U,P,Q]=lu(K1) which is faster than klu. K1 is symmeterized before
%   factorization (to eliminate small discrepancies). Matrix K1 and m2 are
%   now built by concatenation as this is faster.
%
%   Version 1.2    04.09.2012   José: included reordering before LU
%   factorization (things are faster)
%
% (c) DTU Wind Energy
%********************************************************

%% Define matrix T
T=sparse([],[],[],6,6);
T(1,5)=-1;
T(2,4)=1;

%Build right hand side
rhs1=sparse([zeros(size(E,1),6);
    T'                ;
    zeros(6)          ]);

%% Build coefficient matrix including constraints
K11=[E;   R';  D       ];
K12=[R;   A ;  zeros(6) ];
K13=[D';  zeros(6); zeros(6) ];
K1=horzcat(K11,K12,K13);
K1=(K1+K1')/2;

%Permutation vector (and its inverse) to increase sparsity
p=symrcm(K1);
n=size(p,2);
pinv=zeros(1,n);
pinv(p)=1:n;

%Factorizing coefficient matrix
[lK1,uK1,pK1,qK1]=lu(K1(p,p));

%Solving factorized system
l1b=lK1\(pK1*rhs1(p,:));
s1=uK1\l1b;
s1=qK1*s1;
s1=s1(pinv,:);

%Extracting state variables from solution vector
X1=s1(1:size(E,1),:);
Y1=s1(size(E,1)+1:size(E,1)+size(A,1),:);

%Build right hand side
rhs2=sparse([-C'*X1+C*X1+L*Y1;
    -L'*X1+eye(6)   ;
    zeros(6)        ]);

%Solving system using factorized matrix
l2b=lK1\(pK1*rhs2(p,:));
s0=uK1\l2b;
s0=qK1*s0;
s0=s0(pinv,:);

%Extracting state variables from solution vector
X0=s0(1:size(E,1),:);
Y0=s0(size(E,1)+1:size(E,1)+size(A,1),:);

%Compliance matrix
m1=[X1; X0; Y0;];
m21=[M;C';L'];
m22=[C;E;R'];
m23=[L;R;A];
m2=horzcat(m21,m22,m23);

Fs=m1'*m2*m1;

%Stiffness matrix
Ks=Fs\eye(6);

end