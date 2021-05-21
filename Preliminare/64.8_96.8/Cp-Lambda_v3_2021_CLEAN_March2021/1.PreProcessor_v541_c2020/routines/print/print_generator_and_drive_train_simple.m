function print_generator_and_drive_train_simple( generator , dat_file_name , ActuatorFlag)

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
% 
% ALE this new routine implements the direct drive train
% with only one rvj (rvj_generator)
% the rvj_mechanical_loss is no lon necessary with the external controller
% 
%----------------------------------------------------
%
gen_file_name = dat_file_name(7,:) ;
%
%
load names\generator_names
load names\hub_names hub_name point_hub_name
load names\nacelle_names nacelle_associated

% ALEALE 12.nov.2009
if nargin==2
    ActuatorFlag = 1;
end

if ActuatorFlag
    % Send status #LS
    disp('  Writing Generator_and_drive_train.dat file.........')
    
    fpt=fopen( strcat(dat_file_name(end,:),'\MB_model\',gen_file_name) , 'w');
else
    % Send status #LS
    disp('  Writing Generator_and_drive_train_wo_actuator.dat file.........')
    
    filename = deblank(gen_file_name);
    fpt=fopen( strcat(dat_file_name(end,:),'\MB_model\',filename(1:end-4),'_wo_actuator',filename(end-3:end)) , 'w');
end

%---------------------
% Points definitions |
%---------------------
fprintf(fpt,'Points :\n'); 

points_coordinates = [ 0 generator.distance_from_hub_cg 0 ;
                       0 generator.distance_from_hub_cg*1.5 0 ] ;           % ALEALE: warning here: may be huge...

point_definition ( fpt , pt_generator_names(1:2,:) , points_coordinates , 'frame_hub' );

fprintf(fpt,' ;\n\n\n');

%-----------------------------------
% Rigid body generator definitions |
%-----------------------------------
fprintf(fpt,'RigidBodies :\n');

rigid_body_definition( fpt , generator_components_names(1,:) , pt_generator_names(1,:) , generator_components_names(4,:) , pt_generator_names(1,:) , ...
                       generator_components_names(3,:) , generator_components_names(6,:) , 'n' , 'y' , '' , '' , '' , generator_components_names(2,:) );

% SE VOLESSI TUTTO RIGIDO!!!:
% rigid_body_definition( fpt , generator_components_names(4,:) , point_hub_name(1,:) , hub_name(1,:)  , pt_generator_names(1,:) , ...
%                        generator_components_names(1,:) , generator_components_names(6,:) , 'n' , 'n' , '' , ...
%                        '' , '' , '' );
% 
% rigid_body_definition( fpt , generator_components_names(8,:) , pt_generator_names(1,:) , generator_components_names(3,:) , pt_generator_names(2,:) , ...
%                        nacelle_associated(2,:) , generator_components_names(6,:) , 'n' , 'n' , '' , ' , ...
%                        '' , '' );
                   
fprintf(fpt,';\n\n\n');            

mass_property_definition( 'y' , fpt , generator_components_names(2,:) , generator.mass , [ 0 0 0 ] , [0 0 0 generator.inertia 0 0 ]  );

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
% ALEALE 12.nov.2009
if (ActuatorFlag)
revolute_joint_definition ( fpt , 'n' , generator_components_names(3,:) , pt_generator_names(1,:) , generator_components_names(8,:) , ...
                            pt_generator_names(1,:) , generator_components_names(1,:) , generator_components_names(7,:) , 'n' , 'y' , ...
                            'y' , 'n' , '' , 'damp_rel' , 'null' , 'spring_hub_clamp' , 'generator_mechanical_loss_damper' , 'generator_actuator');
else
    revolute_joint_definition ( fpt , 'n' , generator_components_names(3,:) , pt_generator_names(1,:) , generator_components_names(8,:) , ...
                            pt_generator_names(1,:) , generator_components_names(1,:) , generator_components_names(7,:) , 'n' , 'y' , ...
                            'y' , 'n' , '' , 'damp_rel' , 'null' , 'spring_hub_clamp' , 'generator_mechanical_loss_damper' );
end
%----------------------------------
% Revolute joint mechanical loss  |
%----------------------------------

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

% SE VOLESSI LINKER FLESSIBILI:
beam_definition ( fpt , generator_components_names(4,:) , point_hub_name(1,:) , hub_name(1,:) , pt_generator_names(1,:) , ...
                  generator_components_names(1,:) , generator_names_miscellaneous(1,:) , generator_names_miscellaneous(2,:) );
beam_definition ( fpt , generator_components_names(8,:) , pt_generator_names(1,:) , generator_components_names(3,:) , pt_generator_names(2,:) , ...
                  nacelle_associated(2,:) , generator_names_miscellaneous(3,:) , generator_names_miscellaneous(4,:) );

fprintf(fpt,' ;    \n\n\n');


%---------------
% Beams curves |
%---------------

fprintf(fpt,'Curves : \n');

curve_definition( fpt , generator_names_miscellaneous(1,:) , 'frame_hub' , point_hub_name(1,:) , pt_generator_names(1,:) , ...
                  [ 0 1 ] , [ -1 , 0 , 0 ] , [ 0 , 0 , 1 ] , 'y' , 'drive_train_mesh' );

curve_definition( fpt , generator_names_miscellaneous(3,:) , 'frame_hub' , pt_generator_names(1,:) , pt_generator_names(2,:) , ...
                  [ 0 1 ] , [ -1 , 0 , 0 ] , [ 0 , 0 , 1] , 'y' , 'drive_train_linker_mesh' );

fprintf(fpt,' ;    \n\n\n');


%---------------
% Curves mesh  |
%---------------

mesh_definition( fpt , 'y' , 'drive_train_mesh' , 2 , 3 );

mesh_definition( fpt , 'y' , 'drive_train_linker_mesh' , 2 , 1 );

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
beam_properties_definition ( fpt , generator_names_miscellaneous(2,:) , 0  , [1.0E+12 1.0E+12 ] , 1.0E+12 ,  0  ,  [ 0 0 0] , 'n' , 'n' , 'n', 1.0E+12, 0 );
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
