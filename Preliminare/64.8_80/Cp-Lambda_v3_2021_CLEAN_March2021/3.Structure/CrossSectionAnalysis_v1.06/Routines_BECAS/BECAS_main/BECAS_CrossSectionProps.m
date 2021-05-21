function [props]=...
    BECAS_CrossSectionProps(Ks,utils)
%********************************************************
% File: BECAS_CalcSectionProps.m
%   Function to evaluate the cross section properties based on the results
%   from BECAS (e.g., shear, mass, and elastic center position, etc.)
%
% Syntax:
% [ props ] = BECAS_CrossSectionProps(Ks,utils)
%
% Input:
%   Ks      :  Cross section stiffness matrix
%   utils   :  Structure with all inputdata and other data necessary (see
%              BECAS_utils).
%
% Output:
%   props.ShearX, 
%   props.ShearY  :  Coordinates of shear center with respect to mid-chord point
%              (see HAWC2 documentation)
%   props.ElasticX, 
%   props.ElasticY:  Coordinates of elastic center with respect to mid-chord
%              point (see HAWC2 documentation)
%   props.MassX, 
%   props.MassY   :  Coordinates of mass center with respect to mid-chord
%   props.Mass    :  Mass per unit length or mass of cross section
%   props.AlphaPrincipleAxis_Ref :  Orientation of the principle axis
%              with calculated at the reference point
%   props.AlphaPrincipleAxis_ElasticCenter :  Orientation of the principle axis
%              with calculated at the elastic center
%   props.AreaX, 
%   props.AreaY   :  Coordinates of area center with respect to mid-chord
%   props.AreaTotal: Total cross section area
%   props.Ixx, props.Iyy, props.Ixy :  Cross section mass moment of inertia
%   props.Axx, props.Ayy, props.Axy :  Cross section area moment of inertia
%   props.MassPerMaterial  :  Mass per unit length of each of the materials
%
% Calls:
%
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
%   Version 2.0    07.09.2012   José Pedro Blasques: Removed BECAS_utils 
%   and changed the input to receive the utils structure. Changed the ouput
%   to pass the props structure.
%
% (c) DTU Wind Energy
%********************************************************



fprintf(1,'> Started evaluating the general cross section properties...')
%Calculate shear and elastic center position
[ props.ShearX, props.ShearY, props.ElasticX, props.ElasticY ] = ...
    BECAS_CalcShearAndElasticCenter( Ks );

%Calculate shear and mass center
[ props.MassTotal, props.MassX, props.MassY, props.Ixx, props.Iyy, props.Ixy,...
  props.AreaX, props.AreaY, props.Axx, props.Ayy, props.Axy, props.AreaTotal, props.MassPerMaterial ] = ...
    BECAS_CalcSectionMassProps( utils );

%Calculate orientation of principle axis with respect to reference and
%elastic axes
[ props.AlphaPrincipleAxis_Ref, props.AlphaPrincipleAxis_ElasticCenter ] = ...
    BECAS_CalcOrientationElasticAxes( Ks, props.ElasticX, props.ElasticY );
fprintf(1,'DONE! \n');

end
