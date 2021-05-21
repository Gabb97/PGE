function print_blade_dat_file ( np , multibody_blade , dat_file_name , blade_index )

load names\hub_names
load names\blade_names


%% Send status #LS
dispstr = ['  Writing Blade_' num2str(blade_index) '.dat file.........'];
disp(dispstr)



%% ALEALE 03.April.2012
BladeShape = 'shape_blade';
%
blade_file_name = dat_file_name(1,:);
%

blade_file_name_temp = deblank(blade_file_name);
var = max(size(blade_file_name_temp));
numb_ident = strvcat('_1','_2','_3');

if blade_index == 1,
    
    blade_file_name_def = strcat(blade_file_name_temp(1,1:var-4),'_1','.dat');
    
    fpp=fopen(strcat(dat_file_name(end,:),'\MB_model\',blade_file_name_def),'w');
    
elseif blade_index == 2,
    
    blade_file_name_def = strcat(blade_file_name_temp(1,1:var-4),'_2','.dat');
    
    fpp=fopen(strcat(dat_file_name(end,:),'\MB_model\',blade_file_name_def),'w');
    
elseif blade_index == 3,
    
    blade_file_name_def = strcat(blade_file_name_temp(1,1:var-4),'_3','.dat');
    
    fpp=fopen(strcat(dat_file_name(end,:),'\MB_model\',blade_file_name_def),'w');
    
end

%-----------------------------------
% Point definition
%-----------------------------------

fprintf(fpp,'Points : \n');
for i = 1 : np+1,
    
    point_definition ( fpp , pt_blade_root_name{blade_index}(i,:) , multibody_blade.end_point0(:,:,i) , frame_name{blade_index}(2,:) );
    
    point_definition ( fpp , pt_blade_tip_name{blade_index}(i,:)  , multibody_blade.end_point1(:,:,i) , frame_name{blade_index}(2,:) );
    
end
fprintf(fpp,' ;    \n\n\n');


%---------------------------------
% Beam definition
%---------------------------------

fprintf(fpp,'Beams : \n');

for i = 1 : np+1,
    
    if i == 1,
        beam_definition ( fpp , blade_name{blade_index}(i,:) , pt_blade_root_name{blade_index}(i,:) , strcat(hub_name(5,:),numb_ident(blade_index,:)) , pt_blade_tip_name{blade_index}(i,:),...
            point_mass_name{blade_index}(i,:) , curve_blade_name{blade_index}(i,:) ,  prop_blade_name{blade_index}(i,:) , BladeShape);
        
    elseif i == np+1,
        
        beam_definition ( fpp , blade_name{blade_index}(i,:) , pt_blade_root_name{blade_index}(i,:) , point_mass_name{blade_index}(i-1,:) , pt_blade_tip_name{blade_index}(i,:),...
            'NULL' , curve_blade_name{blade_index}(i,:) ,  prop_blade_name{blade_index}(i,:) , BladeShape);
        
    else
        
    end
end
fprintf(fpp,' ;    \n\n\n');


%-------------------------------------
% Curve definition
%-------------------------------------

fprintf(fpp,'Curves :\n');
for i = 1 : np+1,
    
    curve_definition( fpp , curve_blade_name{blade_index}(i,:) , frame_name{blade_index}(2,:) , pt_blade_root_name{blade_index}(i,:) , pt_blade_tip_name{blade_index}(i,:) ,...
        multibody_blade.eta{1,i} , multibody_blade.e2{1,i} , multibody_blade.e3{1,i} , 'y' , mesh_blade_name{1}(i,:) );
    
end

fprintf(fpp,' ;    \n\n\n');
fclose(fpp);

%%%% ALEALE moved to BladeProperties.dat file
% % % %-------------------------------------
% % % % Curve mesh definition
% % % %-------------------------------------
% % % if blade_index == 1,
% % %
% % %     fprintf(fpp,' CurveMeshParameters : \n');
% % %
% % %     for i = 1 : np+1,
% % %
% % %         % WARNIG : NOW I WILL USE A REDUED MESH IN ORDER TO REDUCE
% % %         % SIMULATION TIME.
% % %         mesh_definition( fpp , 'n' ,mesh_blade_name{blade_index}(i,:) , fix(1+(2 + max(size(multibody_blade.eta{1,i})))/3) , 3 );
% % %
% % %     end
% % %
% % %     fprintf(fpp,' ;\n\n\n');
% % %
% % % end
% % %
%--------------------------------
% Beam property definition
%--------------------------------

if blade_index == 1,
    
    
    % Send status #LS
    disp('  Writing Blade_properties.dat file.........')
    
    fbp=fopen(strcat(dat_file_name(end,:),'\MB_model\Blade_properties.dat'),'w');
    
    fprintf(fbp,'BeamProperties :\n');
    
    for i = 1 : np+1,
        
        % Original version:
        %         beam_properties_definition ( fbp , prop_blade_name{1}(i,:) , multibody_blade.eta{1,i} , [multibody_blade.chord_stiffness{1,i} multibody_blade.bending_stiffness{1,i}],...
        %             's' , multibody_blade.mass_unit_length{1,i} , multibody_blade.moments_of_inertia{1,i} ,...
        %                   multibody_blade.centre_of_mass{1,i} , 'n' , 'n' , 's' );
        % 03.feb.05 by Ale : new version (with moment of inertia):
        %         beam_properties_definition ( fbp , prop_blade_name{1}(i,:) , multibody_blade.eta{1,i} , [multibody_blade.chord_stiffness{1,i} multibody_blade.bending_stiffness{1,i}],...
        %             's' , multibody_blade.mass_unit_length{1,i} , multibody_blade.moments_of_inertia{1,i} ,...
        %                   multibody_blade.centre_of_mass{1,i} , 'n' , 'n' , 's' );
        % 03.feb.05 by Ale : new version (with moment of inertia and torsional rigidity:
        %         beam_properties_definition ( fbp , prop_blade_name{1}(i,:) , multibody_blade.eta{1,i} , [multibody_blade.chord_stiffness{1,i} multibody_blade.bending_stiffness{1,i}],...
        %             multibody_blade.torsional_rigidity{1,i} , multibody_blade.mass_unit_length{1,i} , multibody_blade.moments_of_inertia{1,i} ,...
        %             multibody_blade.centre_of_mass{1,i} , 'n' , 'n' , 's' );
        % 14.feb.05 by Ale add centroid
        % NOT USED BECAUSE THE ROTOR MODAL ANALYSIS SEEMS WORST!!!
        %         beam_properties_definition ( fbp , prop_blade_name{1}(i,:) , multibody_blade.eta{1,i} , [multibody_blade.chord_stiffness{1,i} multibody_blade.bending_stiffness{1,i}],...
        %             multibody_blade.torsional_rigidity{1,i} , multibody_blade.mass_unit_length{1,i} , multibody_blade.moments_of_inertia{1,i} ,...
        %             multibody_blade.centre_of_mass{1,i} , 'n' , multibody_blade.centroid{1,i} , 's' );
        % 14.feb.05 by Ale axial stiff~bending stiff & shear stiff~tors
        % stiff no centroid
        %         beam_properties_definition ( fbp , prop_blade_name{1}(i,:) , multibody_blade.eta{1,i} , [multibody_blade.chord_stiffness{1,i} multibody_blade.bending_stiffness{1,i}],...
        %             multibody_blade.torsional_rigidity{1,i} , multibody_blade.mass_unit_length{1,i} , multibody_blade.moments_of_inertia{1,i} ,...
        %             multibody_blade.centre_of_mass{1,i} , 'n' , 'n' , 100*multibody_blade.bending_stiffness{1,i} );
        
        %         %%% ALEALE 14.may.2008 during revision of all these files I try this solution:
        %         beam_properties_definition ( fbp , prop_blade_name{1}(i,:) , multibody_blade.eta{1,i} , [multibody_blade.chord_stiffness{1,i} multibody_blade.bending_stiffness{1,i}],...
        %             10*multibody_blade.torsional_rigidity{1,i} , multibody_blade.mass_unit_length{1,i} , multibody_blade.moments_of_inertia{1,i} ,...
        %             multibody_blade.centre_of_mass{1,i} , 'n' , multibody_blade.centroid{1,i} , 500*max(multibody_blade.chord_stiffness{1,i}, multibody_blade.bending_stiffness{1,i}) );
        
        %%% ALEALE 27.aug.2008 during revision of all these files I try this solution:
        beam_properties_definition ( fbp , prop_blade_name{1}(i,:) , multibody_blade.eta{1,i} , [multibody_blade.chord_stiffness{1,i} multibody_blade.bending_stiffness{1,i}],...
            multibody_blade.torsional_rigidity{1,i} , multibody_blade.mass_unit_length{1,i} , multibody_blade.moments_of_inertia{1,i} ,...
            multibody_blade.centre_of_mass{1,i} , 'n' , multibody_blade.centroid{1,i} , 10*max(multibody_blade.chord_stiffness{1,i}, multibody_blade.bending_stiffness{1,i}), 0.005 );
    end
    
    fprintf(fbp,';    \n\n\n');
    
    %-------------------------------------
    % Curve mesh definition
    %-------------------------------------
    
    fprintf(fbp,' CurveMeshParameters : \n');
    minVector=[9 10 10 10];
    for i = 1 : np+1,
%         mesh_definition( fpp , 'n' ,mesh_blade_name{blade_index}(i,:) , min(fix(1+(2 + max(size(multibody_blade.eta{1,i})))/3),10) , 3 );
        mesh_definition( fpp , 'n' ,mesh_blade_name{blade_index}(i,:) , min(fix(1+(2 + max(size(multibody_blade.eta{1,i})))/3),minVector(i)) , 3 );
    end
    fprintf(fbp,' ;\n\n\n');
    fclose(fbp);
    
end

%--------------------------------
% Beam property definition STIFF
%--------------------------------
StiffnessMultiplier = 50;

if blade_index == 1,
    
    % Send status #LS
    disp('  Writing Blade_properties_stiff.dat file.........')

    
    fbp=fopen(strcat(dat_file_name(end,:),'\MB_model\Blade_properties_stiff.dat'),'w');
    
    fprintf(fbp,'BeamProperties :\n');
    
    for i = 1 : np+1,        
        %%% ALEALE 27.aug.2008 during revision of all these files I try this solution:
        beam_properties_definition ( fbp , prop_blade_name{1}(i,:) , multibody_blade.eta{1,i} , ...
                                    [   multibody_blade.chord_stiffness{1,i}.*StiffnessMultiplier, ...
                                        multibody_blade.bending_stiffness{1,i}.*StiffnessMultiplier],...
                                        multibody_blade.torsional_rigidity{1,i}.*StiffnessMultiplier,...
                                        multibody_blade.mass_unit_length{1,i} , multibody_blade.moments_of_inertia{1,i} ,...
                                        multibody_blade.centre_of_mass{1,i} , 'n' , multibody_blade.centroid{1,i} ,...
                                        10*max(multibody_blade.chord_stiffness{1,i}, multibody_blade.bending_stiffness{1,i}), 0.005 );
    end
    
    fprintf(fbp,';    \n\n\n');
    
    %-------------------------------------
    % Curve mesh definition
    %-------------------------------------
    
    fprintf(fbp,' CurveMeshParameters : \n');
    for i = 1 : np+1,
        mesh_definition( fpp , 'n' ,mesh_blade_name{blade_index}(i,:) , min(fix(1+(2 + max(size(multibody_blade.eta{1,i})))/3),10) , 3 );
    end
    fprintf(fbp,' ;\n\n\n');
    fclose(fbp);
    
end


