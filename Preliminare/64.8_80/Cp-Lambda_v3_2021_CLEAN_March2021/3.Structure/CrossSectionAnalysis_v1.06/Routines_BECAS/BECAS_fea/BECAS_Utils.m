function [ utils ] = BECAS_Utils( options )
%********************************************************
% File: BECAS_Utils.m
%   This function generates the Matlab structure utils. which holds all the
%   input data and a number of other useful constants and arrays. The data
%   structure utils. is present in most BECAS functions.
%
% Syntax:
%   [ utils ] = BECAS_Utils( foldername )
%
% Input:
%   options.foldername:  foldername where the BECAS input files are located
%   options.etype:  Element type definition.
%
% Output:
%   utils.  :  Structure holding the following arrays.
%   .nl_2d  : Matrix of nodal coordinates for cross section FE mesh
%   .el_2d  : Matrix of element connectivity for cross section FE mesh
%   .emat   : Matix of element material attribution
%   .matprops : Matrix of material properties
%   .ne_2d  : Number of elements in the cross section FE mesh
%   .nn_2d  : Number of nodes in the cross section FE mesh
%   .etype  : Constant indicating element type
%   .nnpe_2d: Constant indicating the number of nodes per element in
%             the cross section FE mesh
%   .mdim_2d: Constant indicating the dimension of the element
%             stiffness matrix for the selected element type
%   .gpoints: Number of Gauss integration points to be used with
%             selected element type
%   .mapnn  : Constant indicating the total number of mapped nodes
%   .mapinputdata.el_2d : Matrix of mapped element connectivity for cross
%               section FE mesh
%   .mapel4mat: Matrix of mapped element order for material properties
%   .nmat   : Constant indicating the total number of materials in
%             matprop
%   .pr_2d  : Matrix holding the nodal positions for each element
%   .ElCent : Matrix holding the element centroids for all elements in
%             the FE mesh
%   .ElArea : Arrays holding the areas of each element in the cross
%             section FE mesh
%   .GQ     : Matrix with positions of Gauss points and respective weights
%   .iQ, .jQ, .vQ : Material constitutive matrix for each
%                   element in the cross section FE mesh
%                   stored in sparse format
%   .density: Material density at each element of the cross section
%             FE mesh
%
% Calls:
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%   Version 1.1    20.09.2012   José Pedro Blasques: the input is now the
%   structure inputdata. The inputdata.etype string variable has been
%   included. The new element type Q8R has been included.
%   Version 1.2    28.09.2012   José Pedro Blasques: the BECAS_CheckInput
%   function has been included. The inputdata structure is eliminated and
%   the input is now only the foldername. The input files are now loaded in
%   this function. Header is now printed in this function.
%   Version 1.3    29.09.2012   José Pedro Blasques: The input is now the
%   structure options. This is so that it is possible to control the
%   element type which was impossible in version 1.2.
%   Version 1.4    08.10.2012   José Pedro Blasques: Fixed bug related to
%   checking etype.
%
% (c) DTU Wind Energy
%********************************************************

%Print header 
BECAS_PrintHeader

fprintf(1,'> Started building working arrays...');
%Manage folder names
originalFolder = pwd;
utils.foldername=options.foldername;

%Storing input data
cd (utils.foldername)
utils.nl_2d=importdata('N2D.in');
utils.el_2d=importdata('E2D.in');
utils.emat=importdata('EMAT.in');
utils.matprops=importdata('MATPROPS.in');
cd(originalFolder) 

% Check input
check = BECAS_CheckInput( options, utils );

%Useful integers for 2D analysis
utils.ne_2d=size(utils.el_2d,1); %Number of elements
utils.nn_2d=size(utils.nl_2d,1); %Number of nodes

%Setting etype
if check.exist_etype %If defined by user
    utils.etype=options.etype;
    if strcmp(utils.etype,'Q4')
        %Quad4
        utils.etype_string='Q4';
        utils.etype=1;
        utils.nnpe_2d=4; %Number of nodes per element
        utils.mdim_2d=12; %Number of dof per element
        utils.gpoints=2; %Number of gauss points
    elseif strcmp(utils.etype,'Q8')
        %Quad8
        utils.etype_string='Q8';
        utils.etype=2;
        utils.nnpe_2d=8; %Number of nodes per element
        utils.mdim_2d=24; %Number of dof per element
        utils.gpoints=3; %Number of gauss points
    elseif strcmp(utils.etype,'Q8R')
        %Quad8 with reduced integration
        utils.etype_string='Q8R';
        utils.etype=3;
        utils.nnpe_2d=8; %Number of nodes per element
        utils.mdim_2d=24; %Number of dof per element
        utils.gpoints=2; %Number of gauss points
    end
else %Not defined by user and default is used based on ELIST file
    if(size(utils.el_2d,2)==5) %In case the user has not added zeros for the extra nodes
        %Quad4
        utils.etype_string='Q4';
        utils.etype=1;
        utils.nnpe_2d=4; %Number of nodes per element
        utils.mdim_2d=12; %Number of dof per element
        utils.gpoints=2; %Number of gauss points
    elseif(size(utils.el_2d,2)>5)
        if(utils.el_2d(1,6)==0) %In case the user has added zeros for the extra nodes
            %Quad4
            utils.etype_string='Q4';
            utils.etype=1;
            utils.nnpe_2d=4; %Number of nodes per element
            utils.mdim_2d=12; %Number of dof per element
            utils.gpoints=2; %Number of gauss points
        else
            %Quad8
            utils.etype_string='Q8';
            utils.etype=2;
            utils.nnpe_2d=8; %Number of nodes per element
            utils.mdim_2d=24; %Number of dof per element
            utils.gpoints=3; %Number of gauss points
        end
    end
end


%Map node numbers
utils.mapnn(utils.nl_2d(:,1),1)=1:utils.nn_2d;

%Map element connectivity table
utils.mapel_2d=zeros(utils.ne_2d,utils.nnpe_2d+1);
utils.mapel_2d(:,1)=1:utils.ne_2d;
for ee=1:utils.nnpe_2d
    utils.mapel_2d(:,ee+1)=utils.mapnn(utils.el_2d(:,ee+1));
end

%Reordering element material properties
utils.mapel4mat=zeros(max(utils.el_2d(:,1)),1);
for enum=1:utils.ne_2d
    utils.mapel4mat(utils.el_2d(enum,1))=enum;
end
for enum=1:utils.ne_2d
    utils.emat(utils.mapel4mat(utils.emat(enum,1)),:)=utils.emat(enum,:);
end

%Number of materials
utils.nmat=size(utils.matprops,1);

%Store nodal positions for each element in a vector
[utils.pr_2d]=ReorderNodalPos(utils);

%Calculate centroid of cross section elements
[utils.ElCent]=BECAS_ElemCenter(utils);

%Calculate area of each element
[utils.ElArea]=BECAS_ElemArea(utils);

%Retrieve Gauss quadrature points and weights
[ utils.GQ ] = BECAS_GaussQuad;

%Generate element constitutive matrices according to local coordinate
%system
[utils.iQ,utils.jQ,utils.vQ,utils.iQm,utils.jQm,utils.vQm,utils.density]=BECAS_RotateElementMaterialConstMatrix(utils);

fprintf(1,'DONE! \n');

    function [pr_2d]=ReorderNodalPos(utils)
        %Reorganize nodal positions - 2D
        pr_2d=zeros((utils.nnpe_2d-1)*2+2,utils.ne_2d);
        for ii=1:utils.ne_2d
            for i=1:utils.nnpe_2d
                pr_2d((i-1)*2+1:(i-1)*2+2,ii)=utils.nl_2d(utils.mapel_2d(ii,i+1),2:3);
            end
        end
        
        
    end


end

