function [ GlobalGauss, MaterialGauss ] = BECAS_CalcStressesGaussPoints( strain, utils )
%********************************************************
% File: BECAS_CalcStressesGaussPoints
%   Function to calculate the stresses at Gauss points for given strain 
%   results.
%
% Syntax:
%   [ GlobalGauss, MaterialGauss ] = 
%    BECAS_CalcStressesGaussPoints( strain, utils )
%
% Input:
%   strain : Structure with strain values calculated at element centers and
%            Gauss points as given by BECAS_RecoverStrains.
%   utils  : Structure with input data, useful arrays, and constants.
%
% Output:
%   GlobalGauss : (ne,(6*GaussPoints)) array of stresses at Gauss points in
%                  the global coordinate system.
%   MaterialGauss : (ne,(6*GaussPoints)) array of stresses Gauss points in 
%                    the material coordinate system.
%
% Order of Gauss points
% Q4
% -----------
% | 2     4 |
% |         |
% | 1     3 |
% -----------
% Q8
% -----------
% | 3  6  9 |
% | 2  5  8 |
% | 1  4  7 |
% -----------
%
% Calls:
%
% Date:
%   Version 1.0    21.09.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

%% Initialize variables
GlobalGauss=zeros(utils.ne_2d,6*utils.gpoints^2);
MaterialGauss=zeros(utils.ne_2d,6*utils.gpoints^2);

%Mapping from global to material coord. sys. because that is the coord. 
% sys. in which the strains are given
edof=[2 6 5 3 4 1];

for e=1:utils.ne_2d
    %% Build material constitutive matrices
    %Build material constitutive matrix in global coordinate system
    nQ=(6)*(6);
    Qe_global=sparse(utils.iQ((e-1)*nQ+1:e*nQ),utils.jQ((e-1)*nQ+1:e*nQ),utils.vQ((e-1)*nQ+1:e*nQ));
    %Build material constitutive matrix in local coordinate system
    Qe_material=sparse(utils.iQm((e-1)*nQ+1:e*nQ),utils.jQm((e-1)*nQ+1:e*nQ),utils.vQm((e-1)*nQ+1:e*nQ));
    %Reordering to match strains in material coordinate system
    Qe_material(edof,edof)=Qe_material;
    
    %% Stresses at gauss points
    %Stack material constitutive matrices
    if(utils.etype == 1 || utils.etype == 3)
        Qng_global=blkdiag(Qe_global,Qe_global,Qe_global,Qe_global);
        Qng_material=blkdiag(Qe_material,Qe_material,Qe_material,Qe_material);
    elseif(utils.etype == 2 )
        Qng_global=blkdiag(...
            Qe_global,Qe_global,Qe_global,...
            Qe_global,Qe_global,Qe_global,...
            Qe_global,Qe_global,Qe_global);
        Qng_material=blkdiag(...
            Qe_material,Qe_material,Qe_material,...
            Qe_material,Qe_material,Qe_material,...
            Qe_material,Qe_material,Qe_material);
    end    
    %Gauss point stresses in global coordinate system
    GlobalGauss(e,:)=Qng_global*strain.GlobalGauss(e,:)';
    %Gauss point stresses in material coordinate system
    MaterialGauss(e,:)=Qng_material*strain.MaterialGauss(e,:)';
    
end

% %Reorder to match material coordinate system
% edof=[2 6 5 3 4 1];
% edof_mat=repmat(edof,1,utils.gpoints^2);
% MaterialGauss(:,edof_mat)=MaterialGauss;


end