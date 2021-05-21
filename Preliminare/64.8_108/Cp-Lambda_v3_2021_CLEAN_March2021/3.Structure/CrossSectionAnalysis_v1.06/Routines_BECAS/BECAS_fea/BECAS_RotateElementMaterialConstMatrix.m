function [ iQg, jQg, vQg, iQm, jQm, vQm, density ] = ...
    BECAS_RotateElementMaterialConstMatrix( utils )
%********************************************************
% File: BECAS_RotateElementMaterialConstMatrix.m
%   Function to determine the material constitutive matrix at each
%   element of the cross section FE mesh. The procedure includes
%   determining the 3D materia constitutive matrx and rotate it to
%   account for the fiber and fiber plane orientation. All the
%   matrices are storde in three column vectors for sparse storage.
%
% Syntax:
%   [ iQ, jQ, vQ, density ] = BECAS_RotateElementMaterialConstMatrix( utils )
%
% Input:
%   utils   :  Structure with input data, useful arrays, and
%              constants
% Output:
%   iQ, jQ, vQ : Material constitutive matrix for each
%                element in the cross section FE mesh
%                stored in sparse format
%   density : Material density at each element of the cross section
%             FE mesh
%
% Calls:
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

%Initialize arrays
nQ=(6)*(6);
iQg=zeros(utils.ne_2d*nQ,1);
jQg=zeros(utils.ne_2d*nQ,1);
vQg=zeros(utils.ne_2d*nQ,1);
iQm=zeros(utils.ne_2d*nQ,1);
jQm=zeros(utils.ne_2d*nQ,1);
vQm=zeros(utils.ne_2d*nQ,1);
density=zeros(utils.ne_2d,1);

for e=1:utils.ne_2d
    
    nmat=utils.emat(e,2);
    
    %Store density
    density(e)=utils.matprops(nmat,10);
    
    %EVERYTHING HERE IS IN BOOK ORDERING NOT BECAS
    %Material stiffness matrix in material coordinate system
    [ Qm, Sm ] = BECAS_ElementMaterialConsitutiveMatrix( utils, e );
    
    %Fiber orientations
    cf=cosd(-utils.emat(e,3));
    sf=sind(-utils.emat(e,3));
    %Material constitutive matrix
    [Qg]=BECAS_ElemRotateLayer(Qm,cf,sf);

    %Fiber plane orientations
    cp=cosd(-utils.emat(e,4));
    sp=sind(-utils.emat(e,4));
    %Material constitutive matrix
    [Qg]=BECAS_ElemRotateFiberPlane(Qg,cp,sp);
    
    %Make sure Qm is symmetric to remove tiny tiny discrepancies
    Qm=(Qm+Qm')./2;
    Qg=(Qg+Qg')./2;
    
    %Store matrix in material coordinate system
    iQm((e-1)*nQ+1:e*nQ)=reshape(kron((1:6)',ones(size(Qm,1),1)),size(Qm,1)*size(Qm,2),1);
    jQm((e-1)*nQ+1:e*nQ)=reshape(kron((1:6)',ones(1,size(Qm,1))),size(Qm,1)*size(Qm,2),1);
    vQm((e-1)*nQ+1:e*nQ)=reshape(Qm,size(Qm,1)*size(Qm,2),1);
    
    %Store matrix in global coordinate system
    iQg((e-1)*nQ+1:e*nQ)=reshape(kron((1:6)',ones(size(Qg,1),1)),size(Qg,1)*size(Qg,2),1);
    jQg((e-1)*nQ+1:e*nQ)=reshape(kron((1:6)',ones(1,size(Qg,1))),size(Qg,1)*size(Qg,2),1);
    vQg((e-1)*nQ+1:e*nQ)=reshape(Qg,size(Qg,1)*size(Qg,2),1);
    
end

end
