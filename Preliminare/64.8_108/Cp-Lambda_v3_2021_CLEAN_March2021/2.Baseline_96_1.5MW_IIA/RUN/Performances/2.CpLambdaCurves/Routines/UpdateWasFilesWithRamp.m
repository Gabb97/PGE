function UpdateWasFilesWithRamp(Parameters)

% Send status
disp(' ')
disp('*** Updating was input files.......')
disp(' ')


RampTime    =   round(Parameters.AirGravityRampTime);                                        % Length of the time function ramp #LS
TimeRange   =   max(Parameters.AirGravityRampTime,Parameters.PitchOmegaRampTime) + 5;        % Length of the simulation [sec]

% Find all .was file in the working folder

was_files       =   dir([pwd '\*.was']);
numb_was_files  =   length(was_files);



% Update the.was files with the required ramp time and duration

for iwas = 1:numb_was_files
    
    % Identify was file and open
    filename    =   ['.\' was_files(iwas).name];
    
    dispstr     =   ['    Updating ' filename '.......'];
    disp(dispstr)

    ff = fopen(filename,'r');

    if ff<0
        fprintf('    WARNING: Unable to open %s file!!',filename);
        return
    end
    
    % scan file lines and store data
    iline = 0;
    while ~feof(ff)
        iline = iline +1;
        data{iline} = fgetl(ff);
    end

    fclose(ff);

    % Update air_rising time function

    for il = 1: iline
        if ~isempty(strfind(data{il},'TimeFunction'))
            if ~isempty(strfind(data{il+1},'air_raising'))
                 
                str_to_print_1  =   sprintf('    Time : 0.0  ;   FunctionValue : 0 ;');
                str_to_print_2  =   sprintf('    Time : %i   ;   FunctionValue : 1 ;   # Modified by MAIN_CPLambda on: %s', RampTime , datestr(datetime));
                str_to_print_3  =   sprintf('    Time : 1000 ;   FunctionValue : 1 ;');
                
                data{il+4}      =   str_to_print_1;
                data{il+5}      =   str_to_print_2;
                data{il+6}      =   str_to_print_3;
                
%                 break             
            end
        end
    end
    
    % Update gravity_schedule time function

    for il = 1: iline
        if ~isempty(strfind(data{il},'TimeFunction'))
            if ~isempty(strfind(data{il+1},'gravity_schedule'))
                 
                str_to_print_1  =   sprintf('    Time : 0.0  ;   FunctionValue : 0 ;');
                str_to_print_2  =   sprintf('    Time : %i   ;   FunctionValue : 1 ;   # Modified by MAIN_CPLambda on: %s', RampTime , datestr(datetime));
                str_to_print_3  =   sprintf('    Time : 1000 ;   FunctionValue : 1 ;');
                
                data{il+4}      =   str_to_print_1;
                data{il+5}      =   str_to_print_2;
                data{il+6}      =   str_to_print_3;
                
%                 break             
            end
        end
    end    
    
    % Update simulation length
    for il = 1: iline
        if ~isempty(strfind(data{il},'TimeRange'))
            
            str_to_print  =   sprintf('    TimeRange                 : 0.0 , %i ;   # Modified by MAIN_CPLambda on: %s', TimeRange , datestr(datetime));
            data{il}      =   str_to_print;
            
        end
    end
    
    % Overwrite file
    ff = fopen(filename, 'w');
         for il = 1: iline
             fprintf(ff,'%s \n',data{il});
         end
    fclose(ff);  
    
    clear data
    
end

disp(' ')

