function hub_names_definition

%-----------------------------------------------------
% Names associated to the BLADE definition
%-----------------------------------------------------

hub_name = strvcat ( 'rb_hub_centre'  , ...                %1
                     'rb_hub_conn-1-' , ...                %2
                     'rb_blade_fixed_root-1-' , ...        %3
                     'rb_blade_pitchable_root-1-' , ...    %4
                     'rvj_pitch_controller-1-');           %5

point_hub_name = strvcat ( 'pt_hub_centre' , ...                 %1
                           'pt_rvj_pitch_controller-1-' , ...    %2
                           'pt_blade_root_1-1-');                %3

                       
hub_triad = strvcat( 'hub_triad',...
                     'rvj_pitch_command-1-');

hub_curve_name = strvcat('hub_curve-1-');


hub_mesh_name = strvcat('hub_mesh');


hub_beam_property_name = strvcat('hub_beam_property');


hub_spring_name = strvcat('rvj_pitch_command_spring');


hub_copy_name = strvcat ( 'copy_blade_1' , ...
                          'copy_blade_2' , ...
                          'copy_blade_3' );

                     
hub_copy_frame = strvcat( 'frame_copy_a' , ...
                          'frame_copy_b' , ...
                          'frame_copy_c' );

save names\hub_names hub_name point_hub_name hub_triad hub_curve_name hub_beam_property_name hub_mesh_name hub_spring_name
save names\hub_copy_names hub_copy_name hub_copy_frame

% This syntax should be used when the function must be compiled
% save hub_names hub_name point_hub_name hub_triad hub_curve_name hub_beam_property_name hub_mesh_name hub_spring_name
% save hub_copy_names hub_copy_name hub_copy_frame