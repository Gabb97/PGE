function [blade] = read_blade(PathStruct);

%---------------------------------------------------------------
%  This function after having read the blade details
%  from the Bladed output .txt file, return the 'blade'
%  matlab structure as follow.
%
%   REMARK:
%
%  -'blade' structure composed as follows
%            distance_from_root
%            chord
%            twist
%            thickness
%            pitch_axis
%            pre_bend
%            center_of_mass
%            mass_unit_length
%            chord_stiffness
%            bending_stiffness
%
% 03.feb.05 added (according to PAD model) by Ale:
%            moments_of_inertia
%            torsional_rigidity
%            neutral_axis_for_bending
%---------------------------------------------------
% In this version, the aerodynamic and elastic properties are defined along
% a non-dimensional coordinate. Then, I need first to determine the blade
% length and this require to know hub details #LS
[hub] = read_hub_details(PathStruct);

% I compute the blade length and inform the User #LS
blade_length = (hub.rotor_diameter/2) - (hub.root_radial_position);

clear hub

% dispstr = [' --> Computed blade length is: ' num2str(blade_length) 'm'];
% disp(' ')
% disp(dispstr)
% disp(' ')


% Then I read the blade definition as usual
[blade] = read_blade_geometry(PathStruct);
[blade] = read_blade_mass(blade,PathStruct);
[blade] = read_blade_stiffness(blade,PathStruct);

% And eventually I compute the radial position as follows:
blade.distance_from_root = blade.nondimensional_distance_from_root.*blade_length;

% I also add the blade_length to this structure. It could be useful later. #LS
blade.blade_length = blade_length;


