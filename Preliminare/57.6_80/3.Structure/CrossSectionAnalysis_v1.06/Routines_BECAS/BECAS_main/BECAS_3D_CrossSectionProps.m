function [ ShearX, ShearY, ElasticX, ElasticY, ...
    AlphaPrincipleAxis_Ref, AlphaPrincipleAxis_ElasticCenter] ...
    = BECAS_3D_CrossSectionProps( Ks )
%********************************************************
% File: BECAS_3D_CalcSectionProps.m
%   Function to evaluate the cross section properties based on the results
%   from BECAS_3D (e.g., shear and elastic center position, etc.).
%
% Syntax:
%  [ ShearX, ShearY, ElasticX, ElasticY, ...
%    AlphaPrincipleAxis_Ref, AlphaPrincipleAxis_ElasticCenter] ...
%    = BECAS_3D_CalcSectionProps( Ks )
%
% Input:
%   Ks      :  Cross section stiffness matrix
%
% Output:
%   ShearX,
%   ShearY  :  Coordinates of shear center with respect to mid-chord point
%              (see HAWC2 documentation)
%   ElasticX,
%   ElasticY:  Coordinates of elastic center with respect to mid-chord
%              point (see HAWC2 documentation)
%   AlphaPrincipleAxis_Ref :  Orientation of the principle axis
%              with calculated at the reference point
%   AlphaPrincipleAxis_ElasticCenter :  Orientation of the principle axis
%              with calculated at the elastic center
%
% Calls:
%
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

fprintf(1,'Determine the cross section mass per unit length, shear and mass center positions\n')

%Determine cross section compliance matrix
Fs=Ks\eye(6);

%Calculate shear and elastic center position
[ ShearX, ShearY, ElasticX, ElasticY ] = ...
    BECAS_CalcShearAndElasticCenter( Fs );

%Calculate orientation of principle axis with respect to reference and
%elastic axes
[ AlphaPrincipleAxis_Ref, AlphaPrincipleAxis_ElasticCenter ] = ...
    BECAS_CalcOrientationElasticAxes( Ks, ElasticX, ElasticY );

end

