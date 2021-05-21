function [wind_data]=read_wind_data(PathStruct);

%----------------------------------------------
% This function reads the wind gusts details.
% The output returns a MATLAB structure
% named wind_data, its fields are:
%    -category = 'a' or 'b', this character
%                 define the wtg chategory;
%    -class    = it is a number (1, 2, 3, 4)
%                definig the wtg class;
%    -hub_height = it is a numebr defining the
%                  wtg hub height experssed in 
%                  meters.
%    -rotor_diameter = it is a number definig 
%                      the wtg rotor diameter 
%                      expressed in meters.
%    -v_hub          = this number define the
%                      wind speed at hub height.
%    -t_befrore      = this number define the
%                      simulation time before
%                      the gust start, in deconds.
%    -t_after        = this number define the 
%                      simulation time after the 
%                      gust end, in seconds.
%    -EOG1, EOG50, EDC1, EDC50, ECD, EWS_v, EWS_h
%      = these flags, yes or no, definie if the 
%        .dat wind grid redable by the multibody
%         software should be printed.
%
%    -IECEdition     flag containing the IEC Edition 
%                    in order to set the right parameters  ALEALE 07.oct.2008
%------------------------------------------------

% wind_data structure definition and pre-allocation
wind_data = struct ('category' , [] , 'class' , [] , 'hub_height' , [] , 'rotor_diameter' , [] , 'v_hub' , [] , 't_before' , [] , 't_after', [] , ...
                    'EOG1' , [] , 'EOG50' , [] , 'EDC1' , [] , 'EDC50' , [] , 'ECD' , [] , 'EWS_v' , [] , 'EWS_h' , [] , 'grid_size' , [] , 'grid_resolution' , [] , ...
                    'sample_time' , [] , 'NWP' , [] , 'ECG' , [] , 'IECEdition' , 6140013 );
%%%ALEALE 07.oct.2008
%%% added IEC edition

fid=fopen(strcat(PathStruct.FullPathInputDir,'\wind.txt'),'r');

i=0;

while feof(fid) == 0 ,
     
    line = deblank(fgetl(fid));
    check_spaced_line = size(deblank(line));
    
    if (isempty(line) == false & line(1) ~= '%' & check_spaced_line(1) ~= 0 ),
        
        i = i + 1 ;
        
        switch i
            
            case 1
                
                wind_data.category = line(end);
                
            case 2
                
                wind_data.class = str2num(line);
                
            case 3
                
                temp=str2num(line);
                
                wind_data.hub_height = temp(1);
                wind_data.rotor_diameter = temp(2);                
                 
            case 4
                
                wind_data.v_hub = str2num(line);
                
            case 5
                
                temp=str2num(line);
                
                wind_data.t_before = temp(1);
                wind_data.t_after  = temp(2);
                
            case 6
                
                temp=str2num(line);
                
                wind_data.grid_size = temp(1);
                wind_data.grid_resolution  = temp(2); 
                wind_data.sample_time = temp(3);
                
            case 7
                
                wind_data.NWP = line;
                
            case 8
                
                wind_data.EOG1 = line;
                
            case 9
                
                wind_data.EOG50 = line;                
                
            case 10
                
                wind_data.EDC1 = line;                
                
            case 11
                
                wind_data.EDC50 = line;        
                
            case 12
                
                wind_data.ECG = line;
                
            case 13
                
                wind_data.ECD = line;
                
            case 14
                
                wind_data.EWS_v = line;                
                
            case 15
                
                wind_data.EWS_h = line;
            
            case 16
                
                wind_data.IECEdition = str2num(line);
                
        end
        
    end    
    
end

fclose(fid);