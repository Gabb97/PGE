function print_nacelle_dat_file( nacelle , tower_height , dat_file_name );

%---------------------------------------------------
%  This function prints in a .dat file the
%  nacelle model in a form suitable for the 
%  multibody code.
%
%  Syntax:
%         -print_nacelle_dat_file(nacelle)
%
%  Input:
%         -nacelle = is a structure which contains
%                    the nacelle properties from 
%                    the Bladed code report;
%
%---------------------------------------------------

% Send status #LS
disp('  Writing Nacelle.dat file.........')

load names\nacelle_names
load names\tower_names pt_tower rvj_yaw_control_name frame_name
load names\generator_names pt_generator_names generator_components_names

%
nac_file_name = dat_file_name(11,:);
%
fpc = fopen( strcat(dat_file_name(end,:),'\MB_model\',nac_file_name) ,'w');

%--------------------------------
% Point definitions
%--------------------------------

fprintf(fpc,' Points :\n'); 

point_definition ( fpc , pt_nacelle_name(1,:) , [tower_height+nacelle.height 0 0 ] , frame_name(1,:) );

fprintf(fpc,' ; \n\n\n');

%---------------------------------------
% Rigid body nacelle definition
%---------------------------------------
fprintf(fpc,'RigidBodies : \n');

% rigid_body_definition( fpc , nacelle_rb_name(1,:) , pt_tower(nacelle.npoint,:) , rvj_yaw_control_name(1,:),...
%                        pt_tower(nacelle.npoint,:) , 'null' , nacelle_triad(1,:) , 'y' , 'y' , nacelle_associated(1:2,:) ,...
%                        strvcat(nacelle_aero_names(1,:),generator_components_names(8,:)) , strvcat(pt_tower(nacelle.npoint,:) , ...
%                        pt_generator_names(2,:)) , nacelle_mass(1,:) );
                   
rigid_body_definition( fpc , nacelle_rb_name(1,:) , pt_tower(nacelle.npoint,:) , rvj_yaw_control_name(1,:),...
                       pt_tower(nacelle.npoint,:) , 'null' , nacelle_triad(1,:) , 'y' , 'y' , nacelle_associated(2:2,:) ,...
                       strvcat(generator_components_names(8,:)) , strvcat(pt_generator_names(2,:)) , nacelle_mass(1,:) );
                   
fprintf(fpc,' ; \n\n\n');

%---------------------------------------
% Rigid body nacelle MASS definition
%---------------------------------------
Jx = (nacelle.mass * (nacelle.front^2));
Jy = (nacelle.mass * (nacelle.above^2));
Jz = Jx + Jy + nacelle.J_yaw ;

mass_property_definition( 'y' , fpc , nacelle_mass(1,:) , nacelle.mass,...
                          [ nacelle.above -nacelle.front  -nacelle.lateral ] , [ Jx 0 0 Jy 0 Jz ] );

%---------------------------------------
% Rigid body nacelle TRIAD definition
%---------------------------------------
triad_definition(fpc , 'y' , nacelle_triad(1,:) , [ 0 1 0 ] , [ 0 0 1 ] , 'INERTIAL' );


%----------------------------------------------
%  In this section, the function will defines
%  the aerodynamic model of the nacelle by mean
%  of a make-belive beam element.
%----------------------------------------------

%--------------------------------------------------------------------
% fprintf(fpc,'Beams : \n');
% 
% beam_definition ( fpc , nacelle_aero_names(1,:) , pt_tower(nacelle.npoint,:) , nacelle_associated(1,:) ,...
%                   pt_nacelle_name(1,:) , 'null' , nacelle_aero_names(3,:) , nacelle_aero_names(2,:) );
% 
% fprintf(fpc,' ; \n\n\n');


%--------------------------------------------------------------------
% fprintf(fpc,'BeamProperties : \n');
% 
% % beam_properties_definition ( fpc , nacelle_aero_names(2,:) , [ 0 1 ] , 's' , 's' , [ 0 0 ; 0 0 ] , ...
% %                              [ 0 0 0 ; 0 0 0 ] , [ 0 0 ; 0 0 ] , [ 0 0 ; 0 0 ] , [ 0 0 ; 0 0 ] );
% % function beam_properties_definition ( fpc , prop_name , eta , beam_stiff , torsional_stiff , mass ,   moments_of_inertia , cg , sc , cl , axial_stiffness );
% beam_properties_definition ( fpc , nacelle_aero_names(2,:) , 0  , [1.0E+12 1.0E+12] , 1.0E+12 , 0  ,  [ 0 0 0] , 'n' , 'n' , 'n', 1.0E+12 );
% 
% fprintf(fpc,' ; \n\n\n');


%--------------------------------------------------------------------
% fprintf(fpc,' Curves : \n');
% 
% curve_definition( fpc , nacelle_aero_names(3,:) , frame_name(1,:) , pt_tower(nacelle.npoint,:) , pt_nacelle_name(1,:) , ...
%                   [ 0 1 ] , [ 0 1 0 ] , [ 0 0 1 ] , 'y' , nacelle_aero_names(4,:) );
% 
% fprintf(fpc,' ; \n\n\n');

%--------------------------------------------------------------------

% mesh_definition( fpc , 'y' ,nacelle_aero_names(4,:) , 1 , 1 );



%--------------------------------------------------------------------
% fprintf(fpc,'LiftingLines :\n');
% lifting_line_definition ( fpc , nacelle_aero_names(7,:) , nacelle_aero_names(3,:) , nacelle_aero_names(5,:) , ...
%                           nacelle_aero_names(6,:) , 'EQUALLY_SPACED' , 2 , '2D_AIRFOIL' , nacelle_aero_names(1,:) , 'y' , 0);
% fprintf(fpc,'; \n\n\n');        
% 

%--------------------------------------------------------------------
% lifting_line_properties_definition( fpc , 'y' , nacelle_aero_names(6,:) , [ 0 1 ] , [nacelle.width nacelle.width] ,...
%                                    -[nacelle.width nacelle.width]/4 , [0] , nacelle_aero_names(8,:) , 'n' );

%--------------------------------------------------------------------
% triad_definition( fpc , 'y' , nacelle_aero_names(5,:) , [ 0 1 0 ] , [ 1 0 0 ] , frame_name(1,:) );


%--------------------------------------------------------------------
% airtable{1}=[ 0 nacelle.cd 0 ; 0 nacelle.cd 0 ; 0 nacelle.cd 0 ];
% % In order to avoid warning message in WASP's files .out
% airtable{2}=[ 0 nacelle.cd 0 ; 0 nacelle.cd 0 ; 0 nacelle.cd 0 ];
% airtables_definition ( fpc , 'y' , nacelle_aero_names(8,:) , [ 0 1 ] , [ -180 0 180 ] , airtable );


fclose(fpc);