function print_inflow_model( hub_radius, tip_radius , dat_file_name , blade_number );
% Ale. 04.feb.05 the old version was....


%disp('------INFLOW DEFINITION-----------');


% Send status #LS
disp('  Writing Inflow.dat file.........')

%
infl_file_name = dat_file_name(16,:);
%
load names\aero_names
load names\hub_names
load names\blade_names

fpc=fopen(strcat(dat_file_name(end,:),'\MB_model\',infl_file_name) ,'w');

% Ale. 03.feb.05.  Old version :
% inflow_type='Three_Dimensional';
% New (default) inflow model
inflow_type='BEM';
%

if blade_number == 2,
    
    lifting_lines_string = strcat(lifting_line_name(1,:),'_1',',',lifting_line_name(1,:),'_2');
    
else
    
    lifting_lines_string = strcat(lifting_line_name(1,:),'_1',',',lifting_line_name(1,:),'_2',',',lifting_line_name(1,:),'_3');
    
end

% Ale. 04.feb.05: Old version:
% inflow_model_definition( fpc , inflow_model_names(1,:) , hub_name(1,:) , point_hub_name(1,:) , inflow_model_names(2,:) , rotor_diameter , ...
%                          ( rotor_diameter * 0.5 ) , inflow_type , lifting_lines_string , [ 0 , 0 , 0 ] , 3 , 0 );
% inflow BEM
inflow_model_definition( fpc , inflow_model_names(1,:) , hub_name(1,:) , point_hub_name(1,:) , inflow_model_names(2,:) , ...
                        inflow_type , lifting_lines_string , [blade_number hub_radius tip_radius] );
% inflo 3D
% inflow_model_definition( fpc , inflow_model_names(1,:) , hub_name(1,:) , point_hub_name(1,:) , inflow_model_names(2,:) , ...
%                         inflow_type , lifting_lines_string , [3 4 tip_radius] );


triad_definition( fpc , 'y' , inflow_model_names(2,:) , [ 0 , 0 , -1 ] , [ 0 , 1 , 0 ] , frame_name{1}(3,:) );
                     


fclose(fpc);