function [ reaction, reaction_theta ] = BECAS_RecoverReactions(...
    theta0, X1, Y1, X0, Y0, utils )
%********************************************************
% File: BECAS_RecoverReactions.m
%   Function to calculate the nodal forces at each node of the cross 
%   section FE mesh.
%
% Syntax:
%   [  ] = BECAS_RecoverReactions(  )
%
% Input:
%
% Output:
%
% Calls:
%
%
% Revisions:
%   Version 1.0    07.03.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

% Calculate the reaction forces at each element
reaction=zeros(utils.ne_2d,utils.mdim_2d);
reaction_theta=zeros(utils.ne_2d,utils.mdim_2d);
for e=1:utils.ne_2d
    X=zeros(utils.mdim_2d,6);
    dX=zeros(utils.mdim_2d,6);
    ss=zeros(utils.mdim_2d,1);
    
    %Assemble material constitutive matrix for element e
    nQ=(6)*(6);
    Qe=sparse(utils.iQ((e-1)*nQ+1:e*nQ),utils.jQ((e-1)*nQ+1:e*nQ),utils.vQ((e-1)*nQ+1:e*nQ));
    
    %Evaluate element matrices for the different element types
    if(utils.etype == 1)
        [Me,Ee,Ce,Re,Le,Ae]  = BECAS_Q4(e,Qe,utils);
    elseif(utils.etype == 2)
        [Me,Ee,Ce,Re,Le,Ae]  = BECAS_Q8(e,Qe,utils);
    end
    
    %Mapping from local to global DOF
    edof_2d=zeros(utils.mdim_2d);
    for i=1:utils.nnpe_2d
        for j=1:utils.mdim_2d/utils.nnpe_2d
            edof_2d(utils.mdim_2d/utils.nnpe_2d*(i-1)+j) = utils.mdim_2d /utils.nnpe_2d * (utils.mapel_2d(e,i+1)-1)+j;
        end
    end
    
    %Assemble local solution vectors
    for i = 1:utils.mdim_2d
        X(i,:) = X(i,:) + X0(edof_2d(i),:);
        dX(i,:) = dX(i,:) + X1(edof_2d(i),:);
    end
    
    %Evaluate reaction forces
    reaction(e,:)=Me*dX*theta0'+Ce'*X*theta0'+Le*Y0*theta0';
    reaction_theta(e,1:6)=Le'*dX*theta0'+Re'*X*theta0'+Ae*Y0*theta0';
    
    
end

end