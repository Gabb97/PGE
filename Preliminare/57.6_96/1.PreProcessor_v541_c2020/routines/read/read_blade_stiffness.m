function [blade] = read_blade_stiffness(blade,PathStruct)

%------------------------------------------------------------
% function [blade] = read_blade_stiffness(blade)
%
% This function reads the blade structural property 
% table as provided by Bladed output.
%
% Quantities read are:
%         -Radial Position (m) ---> NB - This coincides with 
%                                   'Distance from root'
%         -Stiffness about Chord Line (Nm²)
%         -Stiffness perpendicular to Chord Line (Nm²)
%
%  Blade structural property data are stored in structure 
% 'blade'.
%-------------------------------------------------------------


%%%ALEALE 14.may.2008
% blade_stiffness = read_matrix_from_txt_file('input\blade_stiffness.txt');
blade_stiffness = read_matrix_from_txt_file(strcat(PathStruct.FullPathInputDir,'\blade_stiffness.txt'));

% blade_mass(:,1) is not processed since it is identical with blade_geometry(:,1)
blade.chord_stiffness = blade_stiffness(:,2);
blade.bending_stiffness = blade_stiffness(:,3);
blade.torsional_rigidity = blade_stiffness(:,4);              % Added by Ale 03.feb.05
blade.neutral_axis_for_bending = blade_stiffness(:,5);        % Added by Ale 03.feb.05
