% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2D ANALYSIS BASED ON 3D FE MODEL
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc
format short

%% Setup path for BECAS library and SuiteSparse
BECAS_SetupPath

%% Define input data
%Cross section folder
foldername='BECAS_examples\Square Abaqus 3D 10x10';

%Load files with nodal positions and element connectivity table
cd (foldername)
load K3D.in
load N3D.in
cd '..\..'

%Storing data
inputdata.k3d=K3D;
inputdata.nl_3d=N3D;

%% Build arrays for BECAS

%Assemble and build working arrays
[ utils3D ] = BECAS_3D_Utils( inputdata.k3d, inputdata.nl_3d );

%% Call BECAS3D for the evaluation of the cross section stiffness properties

[Constitutive3D.Ks, Solutions3D.dX, Solutions3D.dY, ...
 Solutions3D.X, Solutions3D.Y ] = ...
 BECAS_3D_Constitutive_Ks( inputdata.k3d, inputdata.nl_3d );

%% Evaluate cross section properties

[CSprops3D.ShearX,CSprops3D.ShearY,...
    CSprops3D.ElasticX,CSprops3D.ElasticY,...
    CSprops3D.AlphaPrincipleAxis_Ref,CSprops3D.AlphaPrincipleAxis_ElasticAxis]=...
    BECAS_3D_CrossSectionProps(Constitutive3D.Ks); 

%% Plotting and priting routines

%Print results to file BECAS_3D.out
BECAS_3D_PrintResults(Constitutive3D.Ks,CSprops3D.ShearX,CSprops3D.ShearY,...
    CSprops3D.ElasticX,CSprops3D.ElasticY,...
    CSprops3D.AlphaPrincipleAxis_Ref,CSprops3D.AlphaPrincipleAxis_ElasticAxis);
