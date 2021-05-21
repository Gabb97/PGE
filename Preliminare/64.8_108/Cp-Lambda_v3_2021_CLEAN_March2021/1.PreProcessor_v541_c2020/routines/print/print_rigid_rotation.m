function print_rigid_rotation ( dat_file_name , PathStruct)

%-------------------------------------------------
% This function print the rigid rotation commanad
% for the multibody model.
%--------------------------------------------------

% Send status #LS
disp('  Writing Rigid_rotation.dat file.........')

rr_file_name = dat_file_name(15,:);
%
load names\blade_names blade_name point_mass_name
load names\hub_names hub_name point_hub_name
load names\generator_names generator_components_names

% These keywords are temporary while we are
% waiting for a more complex model: untill now,
% the only components of the rotor involved in
% the rotation and with inertial properties are
% the three blades and the hub centre.
rigid_rotation_name='rigid_rotation';
body_name=hub_name(1,:);
point_name=point_hub_name(1,:);
time_function_name='control_rigid_rotation';
body_list_B1 = strcat(blade_name{1}(1,:),',',blade_name{1}(2,:),',');                                % Blade 1
body_list_B2 = strcat(blade_name{2}(1,:),',',blade_name{2}(2,:),',');                                % Blade 2
body_list_B3 = strcat(blade_name{3}(1,:),',',blade_name{3}(2,:),',');                                % Blade 3
body_list_BL = strcat(strcat(hub_name(3,:),'_1'),', ',strcat(hub_name(3,:),'_2'),',',strcat(hub_name(3,:),'_3'),',');  % Linking elements between hub and rvj pitch controller
body_list_BP = strcat(point_mass_name{1}(1,:),',',point_mass_name{2}(1,:),',',point_mass_name{3}(1,:),',');            % Blade point masses
body_list_GH = strcat(generator_components_names(1,:),',',hub_name(1,:));            % Generator & Hub

hub=read_hub_details(PathStruct); 
angular_velocity = [-sin(hub.tilt_from_horizontal_rad) , cos(hub.tilt_from_horizontal_rad) , 0];
%%%%%%%%%%%%%%%%%%%%%%


fpp=fopen( strcat(dat_file_name(end,:),'\MB_model\',rr_file_name) ,'w');

fprintf(fpp,'RigidRotations :\n');
fprintf(fpp,'    RigidRotation :\n');
fprintf(fpp,'     Name : %2s ;\n',deblank(rigid_rotation_name));
fprintf(fpp,'     ConnectedTo : %2s ;\n',deblank(body_name));
fprintf(fpp,'     Where : %2s ;\n',deblank(point_name));
fprintf(fpp,'     TimeFunction : %2s ;\n',deblank(time_function_name));
fprintf(fpp,'     AngularVelocity : %1.8e , %1.8e , %1.8e ;\n',angular_velocity);
fprintf(fpp,'     BodyList : %5s \n',deblank(body_list_B1));
fprintf(fpp,'                %5s \n',deblank(body_list_B2));
fprintf(fpp,'                %5s \n',deblank(body_list_B3));
fprintf(fpp,'                %5s \n',deblank(body_list_BL));
fprintf(fpp,'                %5s \n',deblank(body_list_BP));
fprintf(fpp,'                %5s \n',deblank(body_list_GH));
fprintf(fpp,'      ;\n');
fprintf(fpp,'    ;\n');
fprintf(fpp,';\n');

fclose(fpp);