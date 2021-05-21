function print_hub_dat_file( hub , dat_file_name , blade_index );

%-------------------------------------------------------------
%  This function prints the .dat file for the multibody code.
%
%  Syntax:
%          -hub_configuration(hub)
%
%  Input:
%          -hub = is a structure which contains the hub 
%                 properties as defined in the bladed report;
%
%-------------------------------------------------------------



% ALE: this to have a flex or rigid hub: NEED TO MOVE THIS OUTSIDE!!!
HubFlex = 0;


%
hub_file_name =  dat_file_name(3,:);
rvj_pitch_dat_file_name = dat_file_name(13,:);
%
load names\hub_names
load names\hub_copy_names
load names\blade_names
load names\generator_names
load names\aero_names

% Send status #LS
disp('  Writing Hub.dat file.........')

numb_ident = strvcat('_1','_2','_3');
fpt = fopen( strcat(dat_file_name(end,:),'\MB_model\',hub_file_name) , 'w' );

%----------------------------------------------
% Hub point definition (pt_hub_centre)
%----------------------------------------------

fprintf(fpt,'Points :\n'); 

point_definition ( fpt , point_hub_name(1,:) , [ 0 0 0 ] , frame_name{1}(3,:) );

fprintf(fpt,' ;    \n\n\n');

%---------------------------------------------
%  Hub rigid body definition
%---------------------------------------------

if hub.number_of_blades==2,
    
    associated_names = strvcat(strcat(hub_name(2,:),numb_ident(1,:)),strcat(hub_name(2,:),numb_ident(2,:)));
    
    associated_connections = strvcat(strcat(hub_name(3,:),numb_ident(1,:)),strcat(hub_name(3,:),numb_ident(2,:)));   
    
elseif hub.number_of_blades == 3,
    
    associated_names = strvcat(strcat(hub_name(2,:),numb_ident(1,:)),strcat(hub_name(2,:),numb_ident(2,:)),strcat(hub_name(2,:),numb_ident(3,:)));
    
    associated_connections = strvcat(strcat(hub_name(3,:),numb_ident(1,:)),strcat(hub_name(3,:),numb_ident(2,:)),strcat(hub_name(3,:),numb_ident(3,:)));
    
end

fprintf(fpt,' RigidBodies : \n');

rigid_body_definition( fpt , hub_name(1,:) , point_hub_name(1,:) , generator_components_names(4,:) , point_hub_name(1,:) ,...
                       'null', hub_triad(1,:) , 'y' , 'y' , associated_names , associated_connections , strvcat(point_hub_name(1,:),point_hub_name(1,:),point_hub_name(1,:),point_hub_name(1,:)) , ...
                       'hub_mass' );

fprintf(fpt,' ;    \n\n\n');

%----------------------------------------------
% Hub mass definition
%----------------------------------------------

mass_property_definition( 'y' , fpt , 'hub_mass' , hub.mass , [ 0 -hub.mass_centre 0 ] , [ 0 0 0 hub.J_lss 0 0 ]);


%----------------------------------------------
% Hub triad definition
%----------------------------------------------

triad_definition(fpt , 'y' , hub_triad(1,:) , [ 0 1 0 ] , [ 0 0 1 ] ,  frame_name{1}(3,:));


%-----------------------------------------
% Hub BEAM definition
%-----------------------------------------

% Name Strings definitions
if hub.number_of_blades == 2,
    
    hub_names_string = strvcat(strcat(hub_name(3,:),'_1'),strcat(hub_name(3,:),'_2'));
    point0_hub_names_string = strvcat(point_hub_name(1,:),point_hub_name(1,:));
    body0_hub_names_string  = strvcat(strcat(hub_name(2,:),'_1'),strcat(hub_name(2,:),'_2'));
    point1_hub_names_string = strvcat(strcat(point_hub_name(3,:),'_1'),strcat(point_hub_name(3,:),'_2'));    
    body1_hub_names_string  = strvcat(strcat(hub_name(5,:),'_1'),strcat(hub_name(5,:),'_2'));
    curve_hub_names_string  = strvcat(strcat(hub_curve_name(1,:),'_1'),strcat(hub_curve_name(1,:),'_2'));
    prope_hub_names_string  = strvcat(hub_beam_property_name(1,:),hub_beam_property_name(1,:));
    
elseif hub.number_of_blades == 3,
    
    hub_names_string = strvcat(strcat(hub_name(3,:),'_1'),strcat(hub_name(3,:),'_2'),strcat(hub_name(3,:),'_3'));
    point0_hub_names_string = strvcat(point_hub_name(1,:),point_hub_name(1,:),point_hub_name(1,:));
    body0_hub_names_string  = strvcat(strcat(hub_name(2,:),'_1'),strcat(hub_name(2,:),'_2'),strcat(hub_name(2,:),'_3'));
    point1_hub_names_string = strvcat(strcat(point_hub_name(3,:),'_1'),strcat(point_hub_name(3,:),'_2'),strcat(point_hub_name(3,:),'_3'));
    body1_hub_names_string  = strvcat(strcat(hub_name(5,:),'_1'),strcat(hub_name(5,:),'_2'),strcat(hub_name(5,:),'_3'));
    curve_hub_names_string  = strvcat(strcat(hub_curve_name(1,:),'_1'),strcat(hub_curve_name(1,:),'_2'),strcat(hub_curve_name(1,:),'_3'));
    prope_hub_names_string  = strvcat(hub_beam_property_name(1,:),hub_beam_property_name(1,:),hub_beam_property_name(1,:));
    
end

if (HubFlex)    % classical flexible hub
        
    fprintf(fpt,'Beams : \n');
    
    beam_definition ( fpt , hub_names_string , point0_hub_names_string , body0_hub_names_string , point1_hub_names_string,...
    body1_hub_names_string , curve_hub_names_string , prope_hub_names_string );
    
    fprintf(fpt,' ;    \n\n\n');
    
    %-----------------------------------------
    % Hub BEAM PROPERTIES definition
    %-----------------------------------------
    fprintf(fpt,'BeamProperties :\n');
    
    % beam_properties_definition ( fpt , hub_beam_property_name(1,:) , [ 0 1 ] , 's' , 's' , [ 0 0 ] ,
    %     [ 0 0 0 ; 0 0 0] , 'n' , 'n' , 'n' );
    % function beam_properties_definition ( fpc , prop_name , eta , beam_stiff , torsional_stiff , mass ,   moments_of_inertia , cg , sc , cl , axial_stiffness );
    beam_properties_definition ( fpt , hub_beam_property_name(1,:) , 0  , [1.0E+12 1.0E+12 ] , 1.0E+12 , 0  ,  [ 0 0 0] , 'n' , 'n' , 'n', 1.0E+12, 0 );
    
    fprintf(fpt,' ;    \n\n\n');
    
    %-----------------------------------------
    % Hub BEAM CURVE definition
    %-----------------------------------------
    
    fprintf(fpt,' Curves : \n');
    
    for i = 1 : hub.number_of_blades,
    
    curve_definition( fpt , curve_hub_names_string(i,:) , frame_name{i}(2,:) , point0_hub_names_string(i,:) , point1_hub_names_string(i,:) , ...
        [ 0 1 ] , [ 0 , 1 , 0 ] , [ 0 , 0 , 1 ] , 'y' , hub_mesh_name(1,:) );
    
    end
    
    fprintf(fpt,' ;    \n\n\n');
    
    %-------------------------------------
    % Hub CURVE MESH definition
    %-------------------------------------
    
    mesh_definition( fpt , 'y' ,hub_mesh_name(1,:) , 2 , 1 );
    
    
    
    fclose(fpt);
else  %% ALEALE new!
        
    fprintf(fpt,'RigidBodies : \n');
    
    rigid_body_definition ( fpt , hub_names_string(1,:) , point0_hub_names_string(1,:) , body0_hub_names_string(1,:) , point1_hub_names_string(1,:), body1_hub_names_string(1,:) , hub_triad(1,:) , 'n' , 'n' );
    
    rigid_body_definition ( fpt , hub_names_string(2,:) , point0_hub_names_string(2,:) , body0_hub_names_string(2,:) , point1_hub_names_string(2,:), body1_hub_names_string(2,:) , hub_triad(1,:) , 'n' , 'n' );
    
    rigid_body_definition ( fpt , hub_names_string(3,:) , point0_hub_names_string(3,:) , body0_hub_names_string(3,:) , point1_hub_names_string(3,:), body1_hub_names_string(3,:) , hub_triad(1,:) , 'n' , 'n' );
    
    fprintf(fpt,' ;    \n\n\n');
    
    
    fclose(fpt);
end
%-------------------------------------------
% Hub RVJ BLADE PICH CONTROLLER definition
%-------------------------------------------

% Send status #LS
disp('  Writing Rvj_pitch_control.dat file.........')

fpc = fopen( strcat(dat_file_name(end,:),'\MB_model\',rvj_pitch_dat_file_name) ,'w');

for i = 1 : hub.number_of_blades,
    
    revolute_joint_definition ( fpc , 'y' , strcat(hub_name(5,:),numb_ident(i,:)) , strcat(point_hub_name(3,:),numb_ident(i,:)) , ...
                                blade_name{i}(1,:) , strcat(point_hub_name(3,:),numb_ident(i,:)) , strcat(hub_name(3,:),numb_ident(i,:)) , ...
                                strcat(hub_triad(2,:),numb_ident(i,:)) , 'n' , 'y' , 'n' , 'n' , '' , strcat('pitch_rel_rot',numb_ident(i,:)) , ...
                                strcat('pres_pitch_rel_rot',numb_ident(i,:)) , '');

    prescribed_displacement_def( fpc , 'y' , strcat('pres_pitch_rel_rot',numb_ident(i,:)) , strcat('pitch_rel_rot',numb_ident(i,:)) , ...
                                 strcat(point_hub_name(3,:),numb_ident(i,:)) , 4  , strcat('blade_pitch_control_',num2str(i)) , 'Controller_4_Wind_Turbine' );
%    
    triad_definition( fpc , 'y' , strcat(hub_triad(2,:),numb_ident(i,:)) , [ 0 1 0 ] , [ 1 0 0 ] , frame_name{i}(2,:) );
    
end

fclose(fpc);

%------------------------------------------------------------
% Hub RVJ BLADE PICH CONTROLLER definition with time function
% ALEALE 12.nov.2009
%------------------------------------------------------------

% Send status #LS
disp('  Writing Rvj_pitch_control_with_time_function.dat file.........')

filename = deblank(rvj_pitch_dat_file_name);
fpc = fopen( strcat(dat_file_name(end,:),'\MB_model\',filename(1:end-4),'_with_time_function',filename(end-3:end)) ,'w');

for i = 1 : hub.number_of_blades,
    
    revolute_joint_definition ( fpc , 'y' , strcat(hub_name(5,:),numb_ident(i,:)) , strcat(point_hub_name(3,:),numb_ident(i,:)) , ...
                                blade_name{i}(1,:) , strcat(point_hub_name(3,:),numb_ident(i,:)) , strcat(hub_name(3,:),numb_ident(i,:)) , ...
                                strcat(hub_triad(2,:),numb_ident(i,:)) , 'n' , 'y' , 'n' , 'n' , '' , strcat('pitch_rel_rot',numb_ident(i,:)) , ...
                                strcat('pres_pitch_rel_rot',numb_ident(i,:)) , '');

    prescribed_displacement_def( fpc , 'y' , strcat('pres_pitch_rel_rot',numb_ident(i,:)) , strcat('pitch_rel_rot',numb_ident(i,:)) , ...
                                 strcat(point_hub_name(3,:),numb_ident(i,:)) , 4  , strcat('blade_pitch_control_',num2str(i)));
%    
    triad_definition( fpc , 'y' , strcat(hub_triad(2,:),numb_ident(i,:)) , [ 0 1 0 ] , [ 1 0 0 ] , frame_name{i}(2,:) );
    
end

fclose(fpc);

%----------------------------------------
% Hub Lifting Line Definition
%----------------------------------------

print_hub_lifting_line_dat_file ( hub_name , point_hub_name , hub.piece_diameter , hub.extension_drag , hub.spinner_diameter , hub.root_radial_position , dat_file_name );