function print_sensors( dat_file_name );

%------------------------------------------------------
%  This function prints in a .dat file
%  the sensors models in a form suitable for the 
%  multibody code.
%
%  Syntax:
%         -print_sensors( dat_file_name );
%
%  Input:
%         - dat_file_name : is a string which contains
%                           the name of the .dat file;
%
%------------------------------------------------------
%
sensor_file_name = dat_file_name(4,:);
%


%------------------------------------------------------------------------------------
% Here the function is calling all name strings needed to print the sensors.dat file
load names\sensors_names
load names\tower_names tower_name
load names\blade_names blade_name
load names\hub_names hub_name
load names\generator_names generator_components_names
%------------------------------------------------------------------------------------

%------------------------------------------------------------------------------------
% Here the function is reading the details necessary to define the sensors position
sensors    =  read_sensors('input\sensors.txt');
tower      =  read_tower_details;
point_mass =  read_point_mass;
hub        =  read_hub_details;
blade      =  read_blade_geometry;
%------------------------------------------------------------------------------------
% I also copy the sensor PPP for post processor use!!!
dos_copy = ['copy .\input\sensors.txt ',deblank(dat_file_name(end,:)),'\RUN\U\DLCxx\output\sensors.txt'];
% [status,result] = dos(dos_copy); % ERROR in MEX mode
dos(dos_copy);
%
fpc = fopen( strcat(dat_file_name(end,:),'\RUN\U\DLCxx\input\',sensor_file_name) ,'w');

fprintf(fpc,' Sensors :\n');

%-------------------------
%          BLADE
%--------------------------
%REMARK: with this routine, the software run
%correctly when the blade has only one point mass!!!!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WHEN I WILL DECIDE TO NOT USE THE COPY COMMAND, THISFUNCTION WILL BE
% STILL SUITABLE...................................
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1 : max(size(sensors.eta_blade));
    
    eta_point_mass = point_mass.position / blade.distance_from_root(end);
    
    if sensors.eta_blade(i) <= eta_point_mass;
        
        eta_blade_temp = ( sensors.eta_blade(i) * blade.distance_from_root(end)) / (point_mass.position);
        beam_name = blade_name{1}(1,:);
        
    else
        
        eta_blade_temp = (( sensors.eta_blade(i) * blade.distance_from_root(end)) - point_mass.position ) / (blade.distance_from_root(end) - point_mass.position);
        beam_name = blade_name{1}(2,:);
        
    end
    
    if sensors.blade_studied(1,1:3) == 'all',
        
        if hub.number_of_blades == 2,           

            sensor_definition( fpc , 'n' , blade_1_forces_sensors_names(i,:) , 'Beam  ' , beam_name , 'Forces' , 'LOCAL' , eta_blade_temp , 1 );   
            sensor_definition( fpc , 'n' , blade_1_displacements_sensors_names(i,:) , 'Beam ' , beam_name , 'Displacements' , 'INERTIAL' , eta_blade_temp , 1 );
            
            sensor_definition( fpc , 'n' , blade_2_forces_sensors_names(i,:) , 'Beam  ' , strcat(beam_name(1:end-2),'_2') , 'Forces' , 'LOCAL' , eta_blade_temp , 1 );   
            sensor_definition( fpc , 'n' , blade_2_displacements_sensors_names(i,:) , 'Beam ' , strcat(beam_name(1:end-2),'_1') , 'Displacements' , 'INERTIAL' , eta_blade_temp , 1 );
            
        elseif hub.number_of_blades == 3,

            sensor_definition( fpc , 'n' , blade_1_forces_sensors_names(i,:) , 'Beam  ' , beam_name , 'Forces' , 'LOCAL' , eta_blade_temp , 1 );   
            sensor_definition( fpc , 'n' , blade_1_displacements_sensors_names(i,:) , 'Beam ' , beam_name , 'Displacements' , 'INERTIAL' , eta_blade_temp , 1 );                       
            
            sensor_definition( fpc , 'n' , blade_2_forces_sensors_names(i,:) , 'Beam  ' , strcat(beam_name(1:end-2),'_2') , 'Forces' , 'LOCAL' , eta_blade_temp , 1 );   
            sensor_definition( fpc , 'n' , blade_2_displacements_sensors_names(i,:) , 'Beam ' , strcat(beam_name(1:end-2),'_2') , 'Displacements' , 'INERTIAL' , eta_blade_temp , 1 );
            
            sensor_definition( fpc , 'n' , blade_3_forces_sensors_names(i,:) , 'Beam  ' , strcat(beam_name(1:end-2),'_3') , 'Forces' , 'LOCAL' , eta_blade_temp , 1 );   
            sensor_definition( fpc , 'n' , blade_3_displacements_sensors_names(i,:) , 'Beam ' , strcat(beam_name(1:end-2),'_3') , 'Displacements' , 'INERTIAL' , eta_blade_temp , 1 );
            
        end       
        
    elseif ( sensors.blade_studied(1,1:3) ~='non' & sensors.blade_studied(1,1:3) ~='all' ),

        sensor_definition( fpc , 'n' , blade_1_forces_sensors_names(i,:) , 'Beam  ' , beam_name(1,:) , 'Forces' , 'LOCAL' , eta_blade_temp , 1 );   
        sensor_definition( fpc , 'n' , blade_1_displacements_sensors_names(i,:) , 'Beam ' , beam_name(1,:) , 'Displacements' , 'INERTIAL' , eta_blade_temp , 1 );        
        
    end
            
end

% -------------------------
%         TOWER
% -------------------------

if ( sensors.tower_flag(1,1:2) == 'ye' | sensors.tower_flag(1,1:2) == 'YE' ),
    
    [ usable_height , sensor_height , ii ] = service_routine01( tower.height , sensors.eta_tower );
    
    for i = 1 :max(size(sensors.eta_tower));
        
        if sensors.eta_tower(i) == 0 ,            
            
            sensor_definition( fpc , 'n' , tower_forces_sensors_names(i,:) , 'Beam  ' , tower_name(1,:) , 'Forces' , 'LOCAL' , sensors.eta_tower(i) , 1 );
            
            sensor_definition( fpc , 'n' , tower_displacements_sensors_names(i,:) , 'Beam  ' , tower_name(1,:) , 'Displacements' , 'INERTIAL' , sensors.eta_tower(i) , 1 );
            
        elseif sensors.eta_tower(i) == 1 ;            
            
            sensor_definition( fpc , 'n' , tower_forces_sensors_names(i,:) , 'Beam  ' , tower_name(ii-1,:) , 'Forces' , 'LOCAL' , sensors.eta_tower(i) , 1 );
            
            sensor_definition( fpc , 'n' , tower_displacements_sensors_names(i,:) , 'Beam  ' , tower_name(ii-1,:) , 'Displacements' , 'INERTIAL' , sensors.eta_tower(i) , 1 );
            
        else
            
            num = 1 ;
            
            while 1,
                
                if ( sensor_height(i) >= usable_height(num) & sensor_height(i) <= usable_height(num+1) ),
                    
                    eta_tower_temp = ( sensor_height(i) - usable_height(num) ) / ( usable_height(num+1) - usable_height(num) ) ;
                    
                    beam_name = tower_name(num,:);
                    
                    sensor_definition( fpc , 'n' , tower_forces_sensors_names(i,:) , 'Beam  ' , beam_name , 'Forces' , 'LOCAL' , eta_tower_temp , 1 );
                    
                    sensor_definition( fpc , 'n' , tower_displacements_sensors_names(i,:) , 'Beam  ' , beam_name , 'Displacements' , 'INERTIAL' , eta_tower_temp , 1 );
                    
                    break;
                    
                else
                    
                    num = num + 1 ;
                    
                end
                
            end
            
        end
        
    end
    
end


% --------------------------
%         HUB
% --------------------------

if ( sensors.hub_flag(1,1:2) == 'ye' | sensors.hub_flag(1,1:2) == 'YE' ),
    
    % Forces with respect the Inertial reference
    % sensor_definition( fpc , 'n' , hub_forces_sensors_names(1,:) , 'key_word' , 'element_name' , 'sensor_type' , 'frame_name' , eta_blade_forces(i) , 1 );
    
    % Forces with respect the Rotating reference
    % sensor_definition( fpc , 'n' , hub_forces_sensors_names(2,:) , 'key_word' , 'element_name' , 'sensor_type' , 'frame_name' , eta_blade_forces(i) , 1 );
    
    % Velocities with respect the Inertial reference
    sensor_definition( fpc , 'n' , hub_velocities_sensors_names(1,:) , 'RigidBody' , hub_name(1,:) , 'Velocities' , 'INERTIAL' , 2 , 1 );
    
    % Velocities with respect the Rotating reference
    sensor_definition( fpc , 'n' , hub_velocities_sensors_names(2,:) , 'RigidBody' , hub_name(1,:) , 'Velocities' , 'LOCAL' , 2 , 1 );
    
    % Displacements with respect the Inertial reference
    sensor_definition( fpc , 'n' , hub_displacements_sensors_names , 'RigidBody' , hub_name(1,:) , 'Displacements_0' , 'INERTIAL' , 2 , 1 );
    
end

%-----------------------------------
% DRIVE TRAIN SENSORS DEFINITIONS  |
%-----------------------------------


if ( sensors.drive_train(1,1:2) == 'ye' | sensors.drive_train(1,1:2) == 'YE' ),
    
    sensor_definition( fpc , 'n' , drive_train_forces_sensors_names(1,:) , 'Beam' , generator_components_names(4,:) , 'forces' , 'local' , [0.5] , 1 );
  
    % ALE 30.march.2005
    % this may be used with the old drive train model (with 2 rvjs)
%     sensor_definition( fpc , 'n' , drive_train_forces_sensors_names(2,:) , 'Beam' , generator_components_names(5,:) , 'forces' , 'local' , [0.5] , 1 );
    
    sensor_definition( fpc , 'n' , drive_train_forces_sensors_names(3,:) , 'Beam' , generator_components_names(8,:) , 'forces' , 'local' , [0.5] , 1 );
        
end

fprintf(fpc,';\n');


fclose(fpc);