function [blade] = read_blade_geometry(PathStruct)

%-----------------------------------------------------
% This function reads the blade geometry table 
% as provided by Bladed report file. 
%
% Syntax:
%   -[blade] = read_blade_geometry;
%
%   Quantities read are:
%       -Distance from root (m)
%       -Chord (m)
%       -Twist (deg)
%       -Thickness (% chord)
%       -Pitch Axis (% chord)
%       -Pre-bend (m)
%
% Blade geometry data are stored in structure 'blade'
%------------------------------------------------------

%%%ALEALE 14.may.2008
% blade_geometry = read_matrix_from_txt_file('input\blade_geometry.txt');
blade_geometry = read_matrix_from_txt_file(strcat(PathStruct.FullPathInputDir,'\blade_geometry.txt'));

%blade structure field definition and pre-allocation
blade = struct ('nondimensional_distance_from_root'         , blade_geometry(:,1) ,...  % I've changed this to 'nondimensional' #LS 19.03.2020
                'chord'                                     , blade_geometry(:,2) ,...
                'twist'                                     , blade_geometry(:,3) ,...
                'thickness'                                 , blade_geometry(:,4) ,...
                'pitch_axis'                                , blade_geometry(:,5) ,...
                'pre_bend'                                  , blade_geometry(:,6) ,...
                'airfoil'                                   , blade_geometry(:,7) ,...
                'chord_stiffness'                           , [] ,...
                'bending_stiffness'                         , [] ,...
                'torsional_rigidity'                        , [] ,...     % Added by Ale 03.feb.05
                'neutral_axis_for_bending'                  , [], ...     % Added by Ale 03.feb.05
                'centre_of_mass'                            , [] ,...
                'mass_unit_length'                          , [] ,...
                'moment_of_inertia'                         , [] ,...     % Added by Ale 03.feb.05
                'centroid'                                  , [] ,...     % Added by Ale 11.feb.05
                'total_mass'                                , [0]);