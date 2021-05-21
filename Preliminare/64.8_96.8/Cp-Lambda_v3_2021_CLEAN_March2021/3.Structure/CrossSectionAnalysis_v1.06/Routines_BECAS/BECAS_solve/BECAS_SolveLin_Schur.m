function [ Ks, X1, Y1, X0, Y0 ] = BECAS_SolveLin_Schur( M, C, E, R, L, A, D )
%********************************************************
% File: BECAS_SolveLin.m
%   Function to solve the linear system of equations associated
%   with the cross section equilibrium equations using Schur complement and
%   lu factorization.
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
%   Version 1.1    27.08.2012   José and Robert: Using the Schur complement
%   of E and lu factorization. Things seem to work but for some problems
%   Matlab issues a warning about S being singular. No issues when
%   factorizing E. Many of the matrices are gathered using horzcat which is
%   faster.
%
%   Version 1.2    04.09.2012   José: Solved the problem with the
%   singularity by using a differet partition of the system matrix. This
%   implementation is about 100 times faster than the normal
%   BECAS_SolveLin and should use less memory. Preordering for increased
%   sparsity has also been included based on the symrcm (Cuthill-McKee
%   algorithm). Thank you to Mathias Stolpe and Anders Melchior-Hansen for
%   guidance.
%
%
% (c) DTU Wind Energy
%********************************************************

%% Build matrices for Schur complement calculation
E=(E+E')./2;
A=(A+A')./2;
M=(M+M')./2;

nrow=6;
nrowl=nrow-1;
D=sparse(D);
nEx=size(E,1);
As=E(1:nEx-nrow,1:nEx-nrow);
Bs=[E(end-nrowl:end,1:end-nrow) ;
    R(1:end-nrow,:)'        ;
    D(:,1:end-nrow)         ];
Cs=[E(end-nrowl:end,end-nrowl:end)  R(end-nrowl:end,:) D(:,end-nrowl:end)';
    R(end-nrowl:end,:)' A        zeros(6);
    D(:,end-nrowl:end)  zeros(6) zeros(6)];


%Reordering for sparsity
p=symrcm(As);
n=size(p,2);
pinv=zeros(1,n);
pinv(p)=1:n;

%Factorizing 
[Ls,Us,Ps,Qs]=lu(As(p,p));

%Schur complement method
L1=Ls\(Ps*Bs(:,p)');
S=Us\L1;
S=Qs*S;

S=Cs-Bs(:,p)*S;


%% Solving first linear system to determine dX and dY
%Define matrix T
T=sparse([],[],[],6,6);
T(1,5)=-1;
T(2,4)=1;

%Build right hand side
rhs1=sparse([ zeros(nrow,6); T' ; zeros(6)]);

%Determine second part of solution vectors
s12=S\rhs1;

%Determine first part of solution vectors
s111=-Bs'*s12;
s11=Ls\(Ps*s111(p,:));
s11=Us\s11;
s11=Qs*s11;

% keyboard
%  norm_res=norm(As(p,p)*s11-s111(p,:),inf);
%  norm_rhs=norm(s111(p,:),inf);
%  norm_res/norm_rhs

%Reorder solution
s11=s11(pinv,:);

%Assemble solution vector
s1=[s11; s12];

%Extracting state variables from solution vector
X1=s1(1:nEx,:);
Y1=s1(nEx+1:nEx+size(A,1),:);

%% Solving second linear system to determine X and Y
%Build right hand side using first solutions
f2x=sparse(-C'*X1+C*X1+L*Y1);
g2x=sparse([-L'*X1+eye(6)   ;
    zeros(6)        ]);
f2g2x=vertcat(f2x,g2x);

f2=f2g2x(1:nEx-nrow,:);
g2=f2g2x(nEx-nrowl:end,:);
%Building right hand side for Schur complement solution
sf1=Ls\(Ps*f2(p,:));
sf1=Us\sf1;
sf1=Qs*sf1;
sf1=sf1(pinv,:);

%Determine second part of solution vectors
rhs1=g2-Bs*sf1;
s22=S\rhs1;

%Determine first part of solution vectors
s21=Ls\(Ps*(f2(p,:)-Bs(:,p)'*s22));
s21=Us\s21;
s21=Qs*s21;
s21=s21(pinv,:);

%Assemble solution vector
s0=[s21; s22];

%Extracting state variables from solution vector
X0=s0(1:size(E,1),:);
Y0=s0(nEx+1:nEx+size(A,1),:);

%% Evaluate compliance matrix and stiffness matrix

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