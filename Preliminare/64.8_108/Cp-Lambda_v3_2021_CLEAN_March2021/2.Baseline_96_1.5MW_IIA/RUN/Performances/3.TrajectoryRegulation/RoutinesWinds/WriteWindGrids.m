function WriteWindGrids(Parameters,MB_model_Folder,DLC_Folder)

% Initialize / Send status
disp(' ')
disp('*** Updating Parametric Wind Grids.......')
disp(' ')

% Define number of timesteps for turbulent and gusty winds
NumbTimeSteps_turb  = 200/Parameters.WindData.WindGridSample;
NumbTimeSteps_EOG50 = (14 + 2*Parameters.WindData.TimeBeforeGust)/Parameters.WindData.WindGridSample;                % See 'IEC_wind.m'
NumbTimeSteps_EOG1  = (10.5 + 2*Parameters.WindData.TimeBeforeGust)/Parameters.WindData.WindGridSample;              % See 'IEC_wind.m'
NumbTimeSteps_EWS   = (12 + 2*Parameters.WindData.TimeBeforeGust)/Parameters.WindData.WindGridSample;                % See 'iec_wind_auxiliary2.m'


NumbIntervals_All   =   Parameters.WindData.WindGridResol - 1;
MeshSize_All        =   Parameters.WindData.WindGridSize;


% Define DLC-specifc parameters (hardcoded in this version)
Grid.Name           =   {'DLC1_1'               'DLC1_5'                'DLC1_6'                'DLC1_7'                'DLC6_2ID_T'};
Grid.Type           =   {'turb'                 'gust'                  'gust'                  'gust'                  'turb'};
Grid.Condition      =   {'oper'                 'oper'                  'oper'                  'oper'                  'park'};
Grid.WindFileName   =   {'NTM_Par'              'EOG1_Par'              'EOG50_Par'             'EWS_Par'               'EWM_seed1'};
Grid.GridName       =   {'TurbA'                'EOG1'                  'EOG50'                 'EWS'                   'EWM'};
Grid.WShearExponent =   [0.2                    0.2                     0.2                     0.2                     0.11];
Grid.NumbTimeSteps  =   [NumbTimeSteps_turb     NumbTimeSteps_EOG1      NumbTimeSteps_EOG50     NumbTimeSteps_EWS       NumbTimeSteps_turb];


%% Read WindModelNoGrid data 
filename = [MB_model_Folder '\WindModelNoGrid.dat'];

ff = fopen(filename,'r');

if ff<0
    fprintf('    WARNING: Unable to open %s file!!',filename);
    return
end

% scan file lines and store data
iline = 0;
while ~feof(ff)
    iline = iline +1;
    wind_model_data_default{iline} = fgetl(ff);
end
fclose(ff);


%% Update the individual grids
for idlc = 1:length(Grid.Name)
    
    dlc_path = [DLC_Folder '\' Grid.Name{idlc}];
    
    if exist(dlc_path) > 0
        
        % Update the corresponding file
        %------------------------------------------------------------------
        dispstr = ['  Updating ' Grid.WindFileName{idlc} '.txt..........'];
        disp(dispstr);
        
        wind_model_data = wind_model_data_default;
        
        % Set wind shear exponent
        for il = 1: iline
            if ~isempty(strfind(wind_model_data{il},'WindShearExponent'))
                wind_model_data{il}   = sprintf('        WindShearExponent: %.2f ;', Grid.WShearExponent(idlc));
            end
        end
        
        % Set grid name
        for il = 1: iline
            if ~isempty(strfind(wind_model_data{il},'WindGridName'))
                wind_model_data{il}   = sprintf('        WindGrid        : %s ;', Grid.GridName{idlc});
            end
        end
        
        % Re-write wind model part
        %------------------------------------------------------------------
        filename = [dlc_path '\Input\Wind\' Grid.WindFileName{idlc} '.dat'];
            
        fg = fopen(filename,'w');

        if fg<0
            fprintf('    WARNING: Unable to open %s file!!',filename);
            keyboard
        end
        
        for il = 1: iline
            fprintf(fg,'%s \n',wind_model_data{il});
        end
        
        fprintf(fg,'\n');
        
        clear wind_model_data
        
        % Write grid
        %------------------------------------------------------------------
        
        fprintf(fg,'WindGrids: \n');
        fprintf(fg,'   WindGrid: \n');
        fprintf(fg,'       Name             : %s ; \n',Grid.GridName{idlc} );
        
        if strcmpi(Grid.Condition{idlc},'oper')
            fprintf(fg,'	   GoToParametricString : 1 ; \n');
        else
            
            fprintf(fg,'       File             : .\\..\\..\\..\\Wind\\Turbulent_Wind\\EWM50_seed1\\TurbA_XTRM ;  \n');
        end
        
        fprintf(fg,'       InReferenceFrame : frame_wind_file; \n');
        fprintf(fg,'       MeshSize         : %i , %i ; \n',MeshSize_All,MeshSize_All );
        fprintf(fg,'       NumberOfIntervals: %i , %i ; \n',NumbIntervals_All,NumbIntervals_All );
        fprintf(fg,'       NumberOfTimeSteps: %i ; \n',Grid.NumbTimeSteps(idlc) );
        
        if strcmpi(Grid.Type{idlc},'turb')
            fprintf(fg,'       InitialWindGridTime: 10.0; \n');
        else
            fprintf(fg,'	   GoToParametricString : 2 ; \n');
        end
        fprintf(fg,'   ; \n');
        fprintf(fg,'; \n');
        
        fclose(fg);  
    else
%         keyboard
    end
end
    
    

