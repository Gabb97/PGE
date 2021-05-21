function Parameters = MainIECWind(Parameters,GustWindMainFolder)
% This function drives the gusty wind writing file
% using the PPP scripts       
%       
% INPUT:
%
% OUTPUT
%
% Author: A.C.,  March 2018


%
%  Input:
%      - WTG_class = number (1:5) which define the wind turbine generator IEC "class" ;
%      - WTG_category = 'A','B', 'C', 'S' character which define the wind turbine generator IEC turbulence"category" ;
%      - IECEdition     flag containing the IEC Edition
%      - V_hub = number which define the hub heigth wind velocity as required in IEC Table 2-design load cases;
%      - z_hub = huib height from ground [m];
%      - rotor_diameter = WTG rotor diameter [m];
%      - EWS_flag = 'Y' or 'N', define if the extreme wind shear model should be computed.
%                   If not expressed required, is strongly suggested to not calculate.
%      -time_before_gust = it is a number which define the time[s] before the gust when the wind speed
%                          is constat to the V_hub value;
%      -time_after_gust  = it is a number which define the time[s] after the gust when the wind speed is
%                          constant to the final value of the gusts.
%      -time_nwp         = it is a number which define the NWP duration time.
%
%
%  Output:
%      REMARK= these values are useful only for the SIMULINK controller design tool!!!!!!
%      - IEC_gusts_data = it is a Matlab data structure whose fields are:
%
%         'time_EOG_1'  = it is a row vector which define time[s] at which istantaneous wind speed
%                         is evaluated during Extreme Operative Gust with 1 year of recourrence period;
%         'Wind_EOG_1'  = it is a row vector which define the istantaneous EOG wind speed[m/s];
%         'time_EOG_50' = it is a row vector which define time[s] at which istantaneous wind speed
%                         is evaluated during Extreme Operative Gust with 50 year of recourrence period;
%         'Wind_EOG_50' = it is a row vector which define the istantaneous EOG wind speed[m/s];
%         'time_ECG'    = it is a row vector which define time[s] at which istantaneous wind speed
%                         is evaluated during Extreme Coherenr Gust;
%         'Wind_ECG'    = it is a row vector which define the istantaneous ECG wind speed[m/s];
%         'time_EDC'    = it is a row vector which define time[s] at which istantaneous wind direction
%                         is evaluated during Extreme Direction Change (equal for 1 year and 50 years
%                         recourrence period);
%         'Wind_direction_EDC_1' = it is a row vector which define the istantaneous EDC wind direction[rad]
%                                  for 1 year recourrence period case;
%         'Wind_direction_EDC_50'= it is a row vector which define the istantaneous EDC wind direction[rad]
%                                  for 50 years recourrence period case;
%         'time_ECD'  = it is a row vector which define time[s] at which istantaneous wind direction
%                       is evaluated during Extreme coherent gust and Direction change;
%         'Wind_direction_ECD' = it is a row vector which define the istantaneous ECD wind direction[rad];
%         'time_EWS_vertical'  = it is a row vector which define time[s] at which istantaneous wind speed
%                                is evaluated during Extreme Wind Shear for transient vertical shear;
%         'Wind_direction_EWS_vertical' = it is a row vector which define the istantaneous vertical EWS wind speed[m/s];
%         'time_EWS_horizontal' = it is a row vector which define time[s] at which istantaneous wind speed
%                                 is evaluated during Extreme Wind Shear for transient horizontal shear;
%         'Wind_direction_EWS_horizontal' = it is a row vector which define the istantaneous horizontal EWS wind speed[m/s];
%
%--------------------------------------------------------------------------------------------------------------

% create structure as for PPP
WindData.category       = strjoin(Parameters.WindData.WTCategory);
WindData.class          = Parameters.WindData.WTClass;
WindData.hub_height     = Parameters.WindData.HubHeight;
WindData.rotor_diameter = Parameters.Rotor.RotorDiameter ;
WindData.t_before       = Parameters.WindData.TimeBeforeGust ;
WindData.grid_size      = Parameters.WindData.WindGridSize ;
WindData.grid_resolution= Parameters.WindData.WindGridResol ;
WindData.sample_time    = Parameters.WindData.WindGridSample ;

% Default values
WindData.t_after    = Parameters.WindData.TimeBeforeGust ; % as before
WindData.EOG1       = 'yes';
WindData.EOG50      = 'yes';
WindData.EWS_v      = 'yes';
WindData.EWS_h      = 'yes';
WindData.EDC1       = 'no';
WindData.EDC50      = 'no';
WindData.ECD        = 'no';
WindData.NWP        = 'no';
WindData.ECG        = 'no';
WindData.IECEdition = 6140012;   % IEC edition (6140013 == 61400-1 Ed.3 ; 6140012 == 61400-1 Ed.2 ; 6140022 = 61400-2 Ed.2)

% wind values and folder names
WindValues = [Parameters.CP_TSR.maxWindSpeed_at_maxCp-2 Parameters.CP_TSR.maxWindSpeed_at_maxCp Parameters.CP_TSR.maxWindSpeed_at_maxCp+2 Parameters.maxWindSpeed];
GustWindLocalFolders = {'Wind_r-2' 'Wind_r' 'Wind_r+2' 'Wind_o'};

% start loop
for iWind = 1:length(WindValues)
 WindData.v_hub = WindValues(iWind);
 FullFolder = strcat(GustWindMainFolder,GustWindLocalFolders{iWind});
 Parameters.IEC_gusts_data = IEC_wind(WindData,FullFolder);    
    
end

