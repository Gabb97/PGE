function [ Ag, Rg, Lg, Mg, Cg, Eg, Dg ] = BECAS_Assemble_Ks( utils )
%********************************************************
% File: BECAS_Assemble_Ks.m
%   Function to assemble the global 2D finite element matrices
%   associated with the determination of the cross section
%   stiffness matrix.
%
% Syntax:
%   [ Ag, Rg, Lg, Mg, Cg, Eg, Dg ] = BECAS_Assemble_Ks( utils )
% Input:
%   utils   :  Structure with input data, useful arrays, and
%              constants
% Output:
%   Ag      :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
%   Rg      :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
%   Lg      :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
%   Mg      :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
%   Cg      :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
%   Eg      :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
%   Dg      :  Sub-matrix of cross section equilibrium equations
%              holding the constraint equations (see Documentation)
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

%Initialize arrays and vectors for sparse storage
Ag=sparse([],[],[],6,6);

nMEC=(utils.nnpe_2d*3)*(utils.nnpe_2d*3);
iM=zeros(utils.ne_2d*nMEC,1);
jM=zeros(utils.ne_2d*nMEC,1);
vM=zeros(utils.ne_2d*nMEC,1);

iE=zeros(utils.ne_2d*nMEC,1);
jE=zeros(utils.ne_2d*nMEC,1);
vE=zeros(utils.ne_2d*nMEC,1);

iC=zeros(utils.ne_2d*nMEC,1);
jC=zeros(utils.ne_2d*nMEC,1);
vC=zeros(utils.ne_2d*nMEC,1);

nRL=(utils.nnpe_2d*3)*6;
iR=zeros(utils.ne_2d*nRL,1);
jR=zeros(utils.ne_2d*nRL,1);
vR=zeros(utils.ne_2d*nRL,1);

iL=zeros(utils.ne_2d*nRL,1);
jL=zeros(utils.ne_2d*nRL,1);
vL=zeros(utils.ne_2d*nRL,1);

%Constant associated with the storage of R and L
ntriples=0;

%Constant associated with the storage of Q
nQ=(6)*(6);

% Call each element of the 2D FE mesh in turn
edof_2d=zeros(utils.mdim_2d,utils.ne_2d);
for e=1:utils.ne_2d
    
    %Assemble material constitutive matrix for element e
    Qe=sparse(utils.iQ((e-1)*nQ+1:e*nQ),utils.jQ((e-1)*nQ+1:e*nQ),utils.vQ((e-1)*nQ+1:e*nQ));
    
    %Evaluate element matrices for the different element types
    if(utils.etype == 1)
        [Me,Ee,Ce,Re,Le,Ae]  = BECAS_Q4(e,Qe,utils);
    elseif(utils.etype == 2 || utils.etype == 3 )
        [Me,Ee,Ce,Re,Le,Ae]  = BECAS_Q8(e,Qe,utils);          
    end
    
    %Assemble matrix Ag
    Ae=sparse(Ae);
    Ag=Ag+Ae;

    
    %Mapping from local to global DOF
    for i=1:utils.nnpe_2d
        for j=1:utils.mdim_2d/utils.nnpe_2d
            edof_2d(utils.mdim_2d/utils.nnpe_2d*(i-1)+j,e) = utils.mdim_2d /utils.nnpe_2d * (utils.mapel_2d(e,i+1)-1)+j;
        end
    end
    
    %Assemble global matrices
    iM((e-1)*nMEC+1:e*nMEC)=reshape(kron(edof_2d(:,e),ones(size(Me,1),1)),size(Me,1)*size(Me,2),1);
    jM((e-1)*nMEC+1:e*nMEC)=reshape(kron(edof_2d(:,e),ones(1,size(Me,1))),size(Me,1)*size(Me,2),1);
    vM((e-1)*nMEC+1:e*nMEC)=reshape(Me,size(Me,1)*size(Me,2),1);
    
    iE((e-1)*nMEC+1:e*nMEC)=reshape(kron(edof_2d(:,e),ones(size(Ee,1),1)),size(Ee,1)*size(Ee,2),1);
    jE((e-1)*nMEC+1:e*nMEC)=reshape(kron(edof_2d(:,e),ones(1,size(Ee,1))),size(Ee,1)*size(Ee,2),1);
    vE((e-1)*nMEC+1:e*nMEC)=reshape(Ee,size(Ee,1)*size(Ee,2),1);
    
    iC((e-1)*nMEC+1:e*nMEC)=reshape(kron(edof_2d(:,e),ones(size(Ce,1),1)),size(Ce,1)*size(Ce,2),1);
    jC((e-1)*nMEC+1:e*nMEC)=reshape(kron(edof_2d(:,e),ones(1,size(Ce,1))),size(Ce,1)*size(Ce,2),1);
    vC((e-1)*nMEC+1:e*nMEC)=reshape(Ce,size(Ce,1)*size(Ce,2),1);
    
    %Storing R and L
    %Process is slightly different because this are not square matrices
    %To be improved!
    for ii = 1:6
        for j = 1:utils.mdim_2d
            ntriples=ntriples+1;
            iR(ntriples)=edof_2d(j,e);
            jR(ntriples)=ii;
            vR(ntriples)=Re(j,ii);
            iL(ntriples)=edof_2d(j,e);
            jL(ntriples)=ii;
            vL(ntriples)=Le(j,ii);
        end
    end
    
end

%Assemble global matrices
Mg=sparse(iM,jM,vM);
Eg=sparse(iE,jE,vE);
Cg=sparse(iC,jC,vC);
Rg=sparse(iR,jR,vR);
Lg=sparse(iL,jL,vL);

%Build constraint matrix
[ Dg ] = BECAS_ConstraintMatrix( utils );


end