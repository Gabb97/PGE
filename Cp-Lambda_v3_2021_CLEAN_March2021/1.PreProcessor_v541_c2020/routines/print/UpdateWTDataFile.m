function UpdateWTDataFile(filepath,handles)

% Updating WTData File requires to know the rotor inertia:
rotor_inertia = ComputeRotorInertia(handles);

% I also need some information about the WT
hub             =   read_hub_details(handles.PathStruct);
generator       =   read_generator_details(handles.PathStruct);




% Suppress 'added specified worksheet' message
warning('off','MATLAB:xlswrite:AddSheet');

% Start updating the file
try
    disp(' ')
    disp(' Updating WTData file......')   
    
    % Write data
    xlswrite(filepath,hub.rotor_diameter,'WTData','B2:B2');                     % Rotor diameter [m]
    xlswrite(filepath,hub.tilt_from_horizontal_grad,'WTData','B3:B3');          % Tilt [deg]
    xlswrite(filepath,(generator.efficiency/100),'WTData','B6:B6');             % Efficiency [-]
    xlswrite(filepath,rotor_inertia,'WTData','B18:B18');                        % Rotor Inertia [kgm^2]
    xlswrite(filepath,generator.inertia,'WTData','B19:B19');                    % Generator Inertia [kgm^2]
    xlswrite(filepath,hub.hub_height,'WTData','B31:B31');                        % Hub height [m]
    
        
    % Write remarks
    remark = {['Updated by Cp-Lambda Pre-Processor on ' datestr(datetime)]};

    xlswrite(filepath,remark,'WTData','D2'); 
    xlswrite(filepath,remark,'WTData','D3:D3'); 
    xlswrite(filepath,remark,'WTData','D6:D6'); 
    xlswrite(filepath,remark,'WTData','D18:D18'); 
    xlswrite(filepath,remark,'WTData','D19:D19'); 
    xlswrite(filepath,remark,'WTData','D31:D31'); 
    
    disp(' Done!')
catch
    disp(' ')
    disp('WARNING: I cannot access the target xls file. Maybe is it open or in use?')
    disp(' ')
    return
end