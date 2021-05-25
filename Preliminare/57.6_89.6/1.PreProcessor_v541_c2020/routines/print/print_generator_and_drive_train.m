function print_generator_and_drive_train( generator , dat_file_name );

%----------------------------------------------------
% This function prints the .dat file which defines 
% the generator and the drive train components of
% the wind turbine in a form siutable for the 
% multibody software.
%
% Syntax:
%   -print_generator_and_drive_train( generator );
%
% Input:
%   -generator = it is a structure whose fileds
%                define all the features of these 
%                component as defined in the input
%                data file generator_details.txt.;
%
% REMARK: untill now, this function handles direct 
% drive train models.
%----------------------------------------------------
%
gen_file_name = dat_file_name(7,:) ;
%
load names\generator_names
load names\hub_names hub_name point_hub_name
load names\nacelle_names nacelle_associated

fpt=fopen( strcat(dat_file_name(end,:),'\MB_model\',gen_file_name) , 'w');

%---------------------
% Points definitions |
%---------------------
fprintf(fpt,'Points :\n'); 

points_coordinates = [ 0 generator.distance_from_hub_cg 0 ;
                       0 generator.distance_from_hub_cg+0.1 0 ;
                       0 (generator.distance_from_hub_cg)/2 0 ] ;

point_definition ( fpt , pt_generator_names(1:3,:) , points_coordinates , 'frame_hub' );

fprintf(fpt,' ;\n\n\n');

%-----------------------------------
% Rigid body generator definitions |
%-----------------------------------
fprintf(fpt,'RigidBodies :\n');

rigid_body_definition( fpt , generator_components_names(1,:) , pt_generator_names(1,:) , generator_components_names(5,:) , pt_generator_names(1,:) , ...
                       generator_components_names(3,:) , generator_components_names(6,:) , 'n' , 'y' , '' , '' , '' , 'generator_j' );

rigid_body_definition( fpt , generator_components_names(10,:) , pt_generator_names(3,:) , generator_components_names(4,:) , pt_generator_names(3,:) , ...
                       generator_components_names(9,:) , generator_components_names(6,:) , 'y' , 'n' , generator_components_names(11,:) , ...
                       generator_components_names(5,:) , pt_generator_names(3,:) , '' );

rigid_body_definition( fpt , generator_components_names(12,:) , pt_generator_names(1,:) , generator_components_names(3,:) , pt_generator_names(1,:) , ...
                       generator_components_names(8,:) , generator_components_names(6,:) , 'y' , 'y' , generator_components_names(13,:) , generator_components_names(9,:) , ...
                       pt_generator_names(3,:) , generator_components_names(2,:) );
                   
fprintf(fpt,';\n\n\n');            


fprintf(fpt,'MassProperties : \n');
mass_property_definition( 'n' , fpt , 'generator_j' , [0] , [ 0 0 0 ] , [0 0 0 generator.inertia 0 0 ]  );
mass_property_definition( 'n' , fpt , generator_components_names(2,:) , generator.mass , [ 0 0 0 ] , [0 0 0 0 0 0 ]  );
fprintf(fpt,' ;\n\n\n');

%--------------------------------------------------------------------------
fprintf(fpt,'RevoluteJoints: \n');
%--------------------------------------
% Revolute joint generator definition |
%--------------------------------------
% Ale. 04.feb.05 old version:
% revolute_joint_definition ( fpt , 'n' , generator_components_names(3,:) , pt_generator_names(1,:) , generator_components_names(12,:) , ...
%                             pt_generator_names(1,:) , generator_components_names(1,:) , generator_components_names(7,:) , 'n' , 'y' , ...
%                             'y' , 'y' , '' , 'damp_rel' , 'null' , 'spring_hub_clamp' , 'generator_damper' );
% New version (no damper, with actuator)
revolute_joint_definition ( fpt , 'n' , generator_components_names(3,:) , pt_generator_names(1,:) , generator_components_names(12,:) , ...
                            pt_generator_names(1,:) , generator_components_names(1,:) , generator_components_names(7,:) , 'n' , 'y' , ...
                            'y' , 'n' , '' , 'damp_rel' , 'null' , 'spring_hub_clamp' , '' , 'generator_actuator');
%----------------------------------
% Revolute joint mechanical loss  |
%----------------------------------
revolute_joint_definition ( fpt , 'n' , generator_components_names(9,:) , pt_generator_names(3,:) , generator_components_names(13,:) , ...
                            pt_generator_names(3,:) , generator_components_names(10,:) , generator_components_names(7,:) , 'n' , 'y' , ...
                            'n' , 'n' , '' , 'damp_rel_mechanical_loss' , 'null' , '' , 'generator_mechanical_loss_damper' );

fprintf(fpt,' ;\n\n\n');            
%--------------------------------------------------------------------------

%----------------------------------
% Table look-up of the gnenerator |
%----------------------------------
                        
%fprintf(fpt,'Dampers :\n');

% Ale. 04.feb.05 this is without external controller!!
% damper_definition (fpt , 'n' , 't' , 'generator_damper' , 'user_defined' , [] , max(size(generator.torque_behaviour)) , [] , generator.torque_behaviour );

% ALEALE for 2018 PGE course
% damper_definition (fpt , 'n' , 't' , 'generator_mechanical_loss_damper' , 'user_defined' , [] , max(size(generator.mechanical_loss_torque)) , [] , generator.mechanical_loss_torque );

%fprintf(fpt,' ;\n\n\n');            

%------------------------------------%
%    START  -BEAMS SHAFT DEFINITION- %
%------------------------------------%

%-----------------
% Beams elements |
%-----------------

fprintf(fpt,' Beams : \n');


beam_definition ( fpt , generator_components_names(4,:) , point_hub_name(1,:) , hub_name(1,:) , pt_generator_names(3,:) , ...
                  generator_components_names(10,:) , generator_names_miscellaneous(1,:) , generator_names_miscellaneous(2,:) );

              
beam_definition ( fpt , generator_components_names(8,:) , pt_generator_names(1,:) , generator_components_names(12,:) , pt_generator_names(2,:) , ...
                  nacelle_associated(2,:) , generator_names_miscellaneous(3,:) , generator_names_miscellaneous(4,:) );

              
beam_definition ( fpt , generator_components_names(5,:) , pt_generator_names(3,:) , generator_components_names(11,:) , pt_generator_names(1,:) , ...
                  generator_components_names(1,:) , generator_names_miscellaneous(5,:) , generator_names_miscellaneous(2,:) );              
             
fprintf(fpt,' ;    \n\n\n');


%---------------
% Beams curves |
%---------------

fprintf(fpt,'Curves : \n');

curve_definition( fpt , generator_names_miscellaneous(1,:) , 'frame_hub' , point_hub_name(1,:) , pt_generator_names(3,:) , ...
                  [ 0 1 ] , [ -1 , 0 , 0 ] , [ 0 , 0 , 1 ] , 'y' , 'drive_train_mesh' );

curve_definition( fpt , generator_names_miscellaneous(5,:) , 'frame_hub' , pt_generator_names(3,:) , pt_generator_names(1,:) , ...
                  [ 0 1 ] , [ -1 , 0 , 0 ] , [ 0 , 0 , 1 ] , 'y' , 'drive_train_mesh' );              
              
curve_definition( fpt , generator_names_miscellaneous(3,:) , 'frame_hub' , pt_generator_names(1,:) , pt_generator_names(2,:) , ...
                  [ 0 1 ] , [ -1 , 0 , 0 ] , [ 0 , 0 , 1] , 'y' , 'drive_train_mesh' );

fprintf(fpt,' ;    \n\n\n');


%---------------
% Curves mesh  |
%---------------

mesh_definition( fpt , 'y' , 'drive_train_mesh' , 2 , 3 );

%-------------------
% Beams properties |
%-------------------

fprintf(fpt,'BeamProperties : \n');


% beam_properties_definition ( fpt , generator_names_miscellaneous(2,:) , [ 0 1 ] , 's' , 's' , [ 0 0 ] , ...
%                              [ 0 0 0 ; 0 0 0 ] , 'n' , 'n' , 'n' );
% 
% beam_properties_definition ( fpt , generator_names_miscellaneous(4,:) , [ 0 1 ] , 's' , 's' , [ 0 0 ] , ...
%                              [ 0 0 0 ; 0 0 0 ] , 'n' , 'n' , 'n' );
                         
% function beam_properties_definition ( fpc , prop_name , eta , beam_stiff , torsional_stiff , mass ,   moments_of_inertia , cg , sc , cl , axial_stiffness );
beam_properties_definition ( fpt , generator_names_miscellaneous(2,:) , 0  , [1.0E+12 1.0E+12 ] , 1.0E+12 ,  0  ,  [ 0 0 0] , 'n' , 'n' , 'n', 1.0E+12, 0 ); %% ALEALE: original.
beam_properties_definition ( fpt , generator_names_miscellaneous(4,:) , 0  , [1.0E+12 1.0E+12 ] , 1.0E+12 ,  0  ,  [ 0 0 0] , 'n' , 'n' , 'n', 1.0E+12, 0 );

fprintf(fpt,' ;    \n\n\n');

%--------------------------------------%
%     END    -BEAMS SHAFT DEFINITION-  %
%--------------------------------------%


%-----------------------
% Triads definitions   |
%-----------------------

fprintf(fpt,'Triads : \n');


triad_definition( fpt , 'n' , generator_components_names(6,:) , [ 0 1 0 ] , [ 0 0 1 ] , 'frame_hub' );

triad_definition( fpt , 'n' , generator_components_names(7,:) , [ 0 0 -1 ] , [ 0 1 0 ] , 'frame_hub' );


fprintf(fpt,' ; \n\n\n');



fclose(fpt);                   
