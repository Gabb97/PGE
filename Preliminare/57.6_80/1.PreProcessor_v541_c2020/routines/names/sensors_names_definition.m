function sesnors_names_definition


%-----------------------
%         BLADE        |
%-----------------------

blade_1_displacements_sensors_names = strvcat('sensor_blade_1_displacements_1' , ...
                                            'sensor_blade_1_displacements_2' , ...
                                            'sensor_blade_1_displacements_3' , ...
                                            'sensor_blade_1_displacements_4' , ...
                                            'sensor_blade_1_displacements_5' , ...
                                            'sensor_blade_1_displacements_6' , ...
                                            'sensor_blade_1_displacements_7' , ...
                                            'sensor_blade_1_displacements_8' , ...
                                            'sensor_blade_1_displacements_9' , ...
                                            'sensor_blade_1_displacements_10' );
                                        
                                        
blade_1_forces_sensors_names = strvcat('sensor_blade_1_forces_1' , ...
                                     'sensor_blade_1_forces_2' , ...
                                     'sensor_blade_1_forces_3' , ...
                                     'sensor_blade_1_forces_4' , ...
                                     'sensor_blade_1_forces_5' , ...
                                     'sensor_blade_1_forces_6' , ...
                                     'sensor_blade_1_forces_7' , ...
                                     'sensor_blade_1_forces_8' , ...
                                     'sensor_blade_1_forces_9' , ...
                                     'sensor_blade_1_forces_10');

                                 
blade_2_displacements_sensors_names = strvcat('sensor_blade_2_displacements_1' , ...
                                            'sensor_blade_2_displacements_2' , ...
                                            'sensor_blade_2_displacements_3' , ...
                                            'sensor_blade_2_displacements_4' , ...
                                            'sensor_blade_2_displacements_5' , ...
                                            'sensor_blade_2_displacements_6' , ...
                                            'sensor_blade_2_displacements_7' , ...
                                            'sensor_blade_2_displacements_8' , ...
                                            'sensor_blade_2_displacements_9' , ...
                                            'sensor_blade_2_displacements_10' );
                                        
                                        
blade_2_forces_sensors_names = strvcat('sensor_blade_2_forces_1' , ...
                                     'sensor_blade_2_forces_2' , ...
                                     'sensor_blade_2_forces_3' , ...
                                     'sensor_blade_2_forces_4' , ...
                                     'sensor_blade_2_forces_5' , ...
                                     'sensor_blade_2_forces_6' , ...
                                     'sensor_blade_2_forces_7' , ...
                                     'sensor_blade_2_forces_8' , ...
                                     'sensor_blade_2_forces_9' , ...
                                     'sensor_blade_2_forces_10');
                                 
blade_3_displacements_sensors_names = strvcat('sensor_blade_3_displacements_1' , ...
                                            'sensor_blade_3_displacements_2' , ...
                                            'sensor_blade_3_displacements_3' , ...
                                            'sensor_blade_3_displacements_4' , ...
                                            'sensor_blade_3_displacements_5' , ...
                                            'sensor_blade_3_displacements_6' , ...
                                            'sensor_blade_3_displacements_7' , ...
                                            'sensor_blade_3_displacements_8' , ...
                                            'sensor_blade_3_displacements_9' , ...
                                            'sensor_blade_3_displacements_10' );
                                        
                                        
blade_3_forces_sensors_names = strvcat('sensor_blade_3_forces_1' , ...
                                     'sensor_blade_3_forces_2' , ...
                                     'sensor_blade_3_forces_3' , ...
                                     'sensor_blade_3_forces_4' , ...
                                     'sensor_blade_3_forces_5' , ...
                                     'sensor_blade_3_forces_6' , ...
                                     'sensor_blade_3_forces_7' , ...
                                     'sensor_blade_3_forces_8' , ...
                                     'sensor_blade_3_forces_9' , ...
                                     'sensor_blade_3_forces_10');
                                                                  

%--------------------
%       TOWER       |
%--------------------
                                 
tower_displacements_sensors_names = strvcat('sensor_tower_displacements_1' , ...
                                            'sensor_tower_displacements_2' , ...
                                            'sensor_tower_displacements_3' , ...
                                            'sensor_tower_displacements_4' , ...
                                            'sensor_tower_displacements_5' , ...
                                            'sensor_tower_displacements_6' , ...
                                            'sensor_tower_displacements_7' , ...
                                            'sensor_tower_displacements_8' , ...
                                            'sensor_tower_displacements_9' , ...
                                            'sensor_tower_displacements_10' );
                                        
                                        
tower_forces_sensors_names = strvcat('sensor_tower_forces_1' , ...
                                     'sensor_tower_forces_2' , ...
                                     'sensor_tower_forces_3' , ...
                                     'sensor_tower_forces_4' , ...
                                     'sensor_tower_forces_5' , ...
                                     'sensor_tower_forces_6' , ...
                                     'sensor_tower_forces_7' , ...
                                     'sensor_tower_forces_8' , ...
                                     'sensor_tower_forces_9' , ...
                                     'sensor_tower_forces_10');
    
                                 

                                 
%-------------------------
%           HUB          |
%-------------------------

hub_displacements_sensors_names = strvcat('sensor_hub_displacements_inertial');

hub_velocities_sensors_names = strvcat('sensor_hub_velocities_inertial' , ...
                                       'sensor_hub_velocities_rotating' );

hub_forces_sensors_names = strvcat('sensor_hub_forces_inertial' , ...   %nowadays is unhelpful
                                   'sensor_hub_forces_rotating' );
                                      
                                      
%---------------------------
%     DRIVE TRAIN          |
%---------------------------

drive_train_forces_sensors_names = strvcat('sensor_drive_train_forces' , ...
                                           'sensor_drive_shaft_02' , ...
                                           'sensor_total_forces_from_generator_to_nacelle');
                                       

                                       
                                       
%save names\sensors_names tower_forces_sensors_names tower_displacements_sensors_names blade_1_forces_sensors_names blade_1_displacements_sensors_names blade_2_forces_sensors_names blade_2_displacements_sensors_names blade_3_forces_sensors_names blade_3_displacements_sensors_names hub_displacements_sensors_names hub_forces_sensors_names hub_velocities_sensors_names drive_train_forces_sensors_names

save sensors_names tower_forces_sensors_names tower_displacements_sensors_names blade_1_forces_sensors_names blade_1_displacements_sensors_names blade_2_forces_sensors_names blade_2_displacements_sensors_names blade_3_forces_sensors_names blade_3_displacements_sensors_names hub_displacements_sensors_names hub_forces_sensors_names hub_velocities_sensors_names drive_train_forces_sensors_names