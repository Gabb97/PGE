function print_include( fpc , dat_file_name , s_flag );

%-----------------------------------------------%
% This sub-fuction prints the list of the file  %
% which will be included in the multibody model %
%-----------------------------------------------%

num = size(dat_file_name) - 1; % -1 because the last one is the relative path model


for i = 1 : num(1);
    
    if i == 1,
        fprintf(fpc,'     File : .\\..\\..\\..\\MB_model\\%s ;\n',deblank(dat_file_name(12,:))); % Fixed frames FIRST
        full_name = strcat('.\..\..\..\MB_model\',dat_file_name(i,:));
        include_list(fpc,full_name);
        fprintf(fpc,'     File : .\\..\\..\\..\\MB_model\\Blade_properties.dat ;\n');        
    elseif i == 8,
        full_name = strcat('.\..\..\..\MB_model\',dat_file_name(i,:));
        include_list(fpc,full_name);    
        fprintf(fpc,'     File : .\\..\\..\\..\\MB_model\\Blade_Lifting_line_Properties.dat ;\n');        
    elseif i == 12,    % rotor frame
        
    elseif i == 4,    % sensors
        fprintf(fpc,'     File : .\\..\\..\\..\\MB_model\\MovingFrames.dat ;\n');        
        fprintf(fpc,'     File : .\\..\\..\\..\\MB_model\\%s ;\n',deblank(dat_file_name(i,:)));        

    elseif i == 15 && s_flag== 'd',    % Added by ALE. 29.march.2005 . No rigid rotation for dynamic simulation!
        
    else
        fprintf(fpc,'     File : .\\..\\..\\..\\MB_model\\%s ;\n',deblank(dat_file_name(i,:)));        
    end
    
end

if s_flag == 's',
    fprintf(fpc,'     File : .\\..\\..\\..\\MB_model\\Ground_static.dat ;\n');
elseif s_flag == 'd',
    fprintf(fpc,'     File : .\\..\\..\\..\\MB_model\\Ground_dynamic.dat ;\n');        
end

%-----------------------------------------------%
% Added By Ale. 28.march.2005
if s_flag == 's',
    fprintf(fpc,'     File : .\\..\\..\\..\\MB_model\\ControllerStatic.dat ;\n',deblank(dat_file_name(end,:)));
    fprintf(fpc,'\n     File : .\\input\\WindModelNoGrid.dat ;\n',deblank(dat_file_name(end,:)));
elseif s_flag == 'd',
    fprintf(fpc,'     File : .\\..\\..\\..\\MB_model\\Controller.dat ;\n',deblank(dat_file_name(end,:)));
    fprintf(fpc,'\n#    File : .\\input\\WindModel.dat ;\n',deblank(dat_file_name(end,:)));
    fprintf(fpc,'     File : .\\input\\WindModelNoGrid.dat ;\n',deblank(dat_file_name(end,:)));
end    
%     fprintf(fpc,'     File : .\\input\\%s ;\n',deblank(dat_file_name(4,:)));        
%-----------------------------------------------%

%---------------------------------
%  SUB_FUNCTION definition
%---------------------------------

function include_list(fpc,input_name),

dat_file_name_temp = deblank(input_name(1,:));
var = max(size(dat_file_name_temp));

dat_file_name_def = strcat(dat_file_name_temp(1,1:var-4),'_1','.dat');
fprintf(fpc,'     File : %s ;\n' , dat_file_name_def );

dat_file_name_def = strcat(dat_file_name_temp(1,1:var-4),'_2','.dat');
fprintf(fpc,'     File : %2s ;\n' , dat_file_name_def );

dat_file_name_def = strcat(dat_file_name_temp(1,1:var-4),'_3','.dat');
fprintf(fpc,'     File : %2s ;\n' , dat_file_name_def );
