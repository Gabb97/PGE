function [blade] = read_blade_mass(blade,PathStruct)

%--------------------------------------------------------------
% function [blade] = read_blade_mass(blade)
%
% This function reads the blade inertial property table 
% as provided by Bladed output.
%
%  Quantities read are:
%                      -Distance from root (m);
%                      -Centre of Mass (% chord);
%                      -Mass/unit length (kg/m);
%
% Blade inertial property data are stored in structure 'blade'
%--------------------------------------------------------------


%%%ALEALE 14.may.2008
% blade_mass = read_matrix_from_txt_file('input\blade_mass.txt');
blade_mass = read_matrix_from_txt_file(strcat(PathStruct.FullPathInputDir,'\blade_mass.txt'));

% blade_mass(:,1) is not processed since it is identical with blade_geometry(:,1)
blade.centre_of_mass    =  blade_mass(:,2);
blade.mass_unit_length  =  blade_mass(:,3);
blade.moment_of_inertia =  blade_mass(:,4);       % Added by Ale 03.feb.05
