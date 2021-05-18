function [ GlobalElement, MaterialElement ] = BECAS_CalcStressesElementCenter( strain, utils )
%********************************************************
% File: BECAS_CalcStressesElementCenter
%   Function to calculate the stresses at element center for given strain 
%   results.
%
% Syntax:
%   [ GlobalElement, MaterialElement ] = 
%   BECAS_CalcStressesElementCenter( strain, utils )
%
% Input:
%   strain : Structure with strain values calculated at element centers and
%            Gauss points as given by BECAS_RecoverStrains.
%   utils  : Structure with input data, useful arrays, and constants.
%
% Output:
%   GlobalElement : (neX6) array of stresses at element center in the global
%                    coordinate system.
%   MaterialElement : (nex6) array of stresses at element center in the 
%                      material coordinate system.
%
% Calls:
%
% Date:
%   Version 1.0    21.09.2012   José Pedro Blasques
%   Version 1.1    01.10.2012   José Pedro Blasques: Corrected a bug
%   associated with the reordering of the material constitutive matrix when
%   determining the stresses in the local coord. sys..
%
% (c) DTU Wind Energy
%********************************************************

%% Initialize variables
GlobalElement=zeros(utils.ne_2d,6);
MaterialElement=zeros(utils.ne_2d,6);

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
    
    %% Stresses at elements
    %Element stresses in the global coordinate system
    GlobalElement(e,:)=Qe_global*strain.GlobalElement(e,:)';
    %Element stresses in the material coordinate system
    MaterialElement(e,:)=Qe_material*strain.MaterialElement(e,:)';
end


end