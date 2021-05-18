function [ AlphaPrincipleAxis_Ref, AlphaPrincipleAxis_ElasticCenter ] = ...
    BECAS_CalcOrientationElasticAxes( Ks, ElasticX, ElasticY )
%********************************************************
% File: BECAS_CalcSectionProps.m
%   Function to evaluate the orietation of the elastic axes at the
%   reference center and elastic center.
%
% Syntax:
% [ AlphaPrincipleAxis_Ref, AlphaPrincipleAxis_ElasticCenter ] = ...
%     BECAS_CalcOrientationElasticAxes( Ks, ElasticX, ElasticY )
%
% Input:
%   Ks      :  Cross section stiffness matrix
%   ElasticX,
%   ElasticY:  Coordinates of elastic center with respect to mid-chord
%              point (see HAWC2 documentation)
%
% Output:
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

%Calculate orientation of principle axis with respect to reference axis
ksub=Ks(4:5,4:5); [mod,val]=eig(ksub);
AlphaPrincipleAxis_Ref=atan(mod(2,1)/mod(1,1));

%Calculate orientation of principle axis with respect to elastic center
p=[ElasticX ElasticY]; alpha=BECAS_rad2deg(0);
[Ksprime]=BECAS_TransformationMat(Ks,p,alpha);
ksub=Ksprime(4:5,4:5); [mod,val]=eig(ksub);
AlphaPrincipleAxis_ElasticCenter=atan(mod(2,1)/mod(1,1));

end