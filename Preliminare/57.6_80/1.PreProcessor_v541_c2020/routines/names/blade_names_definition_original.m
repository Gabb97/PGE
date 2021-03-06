function  blade_names_definition

%-----------------------------------------------------
% Names associated to the BLADE definition
%-----------------------------------------------------

point_mass_name = strvcat ('rb_point_mass_1-1-',...
    'rb_point_mass_2-1-',...
    'rb_point_mass_3-1-',...
    'rb_point_mass_4-1-');

pt_mass_name = strvcat ('point_mass_1',...
    'point_mass_2',...
    'point_mass_3',...
    'point_mass_4');

pt_blade_root_name = strvcat ('pt_blade_root_1-1-',...
    'pt_blade_root_2-1-',...
    'pt_blade_root_3-1-',...
    'pt_blade_root_4-1-');

pt_blade_tip_name = strvcat ('pt_blade_tip_1-1-',...
    'pt_blade_tip_2-1-',...
    'pt_blade_tip_3-1-',...
    'pt_blade_tip_4-1-');

curve_blade_name = strvcat ('curve_blade_1-1-',...
    'curve_blade_2-1-',...
    'curve_blade_3-1-',...
    'curve_blade_4-1-');

mesh_blade_name = strvcat ('mesh_blade_1',...
    'mesh_blade_2',...
    'mesh_blade_3',...
    'mesh_blade_4');

prop_blade_name = strvcat ('prop_blade_1',...
    'prop_blade_2',...
    'prop_blade_3',...
    'prop_blade_4');

blade_name = strvcat ('blade_1-1-',...
    'blade_2-1-',...
    'blade_3-1-',...
    'blade_4-1-');

frame_name = strvcat ('tower_frame',...
    'blade_root_frame',...
    'frame_hub');

save names\blade_names blade_name prop_blade_name mesh_blade_name curve_blade_name pt_blade_tip_name pt_blade_root_name point_mass_name frame_name pt_mass_name

%  This syntax should be used when the function must be compiled
% save blade_names blade_name prop_blade_name mesh_blade_name curve_blade_name pt_blade_tip_name pt_blade_root_name point_mass_name frame_name pt_mass_name