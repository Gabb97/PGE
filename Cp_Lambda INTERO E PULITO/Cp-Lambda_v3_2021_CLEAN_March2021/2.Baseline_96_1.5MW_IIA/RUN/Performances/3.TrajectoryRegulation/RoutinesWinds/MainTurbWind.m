function Parameters = MainTurbWind(Parameters,TurbulentWindFolder,ExtTurbulentWindFolder)
% This function drives the turbulent wind writing file
%       
% INPUT:
%
% OUTPUT
%
% Author: A.C.,  March 2018


%% change dir
LocalDir = cd;
cd(TurbulentWindFolder);

%% NTM
% write inp files
for iWind=1:length(Parameters.WindValues4StaticAnalysis)
    FileName = sprintf('TurbA_200sec_%gms.inp',Parameters.WindValues4StaticAnalysis(iWind));
    FInp = fopen(FileName,'w');
    fprintf(FInp,'TurbSim Input File. Valid for TurbSim v1.40, 12-Sep-2008, written by Matlab %s\n',date); 
    fprintf(FInp,'\n');
    fprintf(FInp,'---------Runtime Options-----------------------------------\n');
    fprintf(FInp,'18573235            RandSeed1       - First random seed  (-2147483648 to 2147483647) \n');
    fprintf(FInp,'RANLUX              RandSeed2       - Second random seed (-2147483648 to 2147483647) for intrinsic pRNG, or an alternative pRNG: "RanLux" or "RNSNLW"\n');
    fprintf(FInp,'False               WrBHHTP         - Output hub-height turbulence parameters in binary form?  (Generates RootName.bin)\n');
    fprintf(FInp,'False               WrFHHTP         - Output hub-height turbulence parameters in formatted form?  (Generates RootName.dat)\n');
    fprintf(FInp,'False               WrADHH          - Output hub-height time-series data in AeroDyn form?  (Generates RootName.hh)\n');
    fprintf(FInp,'False               WrADFF          - Output full-field time-series data in TurbSim/AeroDyn form? (Generates Rootname.bts)\n');
    fprintf(FInp,'False               WrBLFF          - Output full-field time-series data in BLADED/AeroDyn form?  (Generates RootName.wnd)\n');
    fprintf(FInp,'False               WrADTWR         - Output tower time-series data? (Generates RootName.twr)\n');
    fprintf(FInp,'True                WrFMTFF         - Output full-field time-series data in formatted (readable) form?  (Generates RootName.u, RootName.v, RootName.w)\n');
    fprintf(FInp,'False               WrACT           - Output coherent turbulence time steps in AeroDyn form? (Generates RootName.cts)\n');
    fprintf(FInp,'True                Clockwise       - Clockwise rotation looking downwind? (used only for full-field binary files - not necessary for AeroDyn)\n');
    fprintf(FInp,'True                ScaleIEC        - Scale hub-height IEC turbulence to target TI?\n');
    fprintf(FInp,'\n');
    fprintf(FInp,'--------Turbine/Model Specifications-----------------------\n');
    fprintf(FInp,'%i                  NumGrid_Z       - Vertical grid-point matrix dimension\n',Parameters.WindData.WindGridResol);
    fprintf(FInp,'%i                  NumGrid_Y       - Horizontal grid-point matrix dimension\n',Parameters.WindData.WindGridResol);
    fprintf(FInp,'%2.2f                TimeStep        - Time step [seconds]\n',Parameters.WindData.WindGridSample );
    fprintf(FInp,'200                 AnalysisTime    - Length of analysis time series [seconds] (program will add time if necessary: AnalysisTime = MAX(AnalysisTime, UsableTime+GridWidth/MeanHHWS) )\n');
    fprintf(FInp,'200                 UsableTime      - Usable length of output time series [seconds] (program will add GridWidth/MeanHHWS seconds)\n');
    fprintf(FInp,'%2.2f               HubHt           - Hub height [m] (should be > 0.5*GridHeight)\n',Parameters.WindData.HubHeight);
    fprintf(FInp,'%3.2f              GridHeight      - Grid height [m] \n',Parameters.WindData.WindGridSize);
    fprintf(FInp,'%3.2f              GridWidth       - Grid width [m] (should be >= 2*(RotorRadius+ShaftLength))\n',Parameters.WindData.WindGridSize);
    fprintf(FInp,'0                   VFlowAng        - Vertical mean flow (uptilt) angle [degrees]\n');
    fprintf(FInp,'0                   HFlowAng        - Horizontal mean flow (skew) angle [degrees]\n');
    fprintf(FInp,'  \n');
    fprintf(FInp,'--------Meteorological Boundary Conditions-------------------\n');
    fprintf(FInp,'"IECKAI"            TurbModel       - Turbulence model ("IECKAI"=Kaimal, "IECVKM"=von Karman, "GP_LLJ", "NWTCUP", "SMOOTH", "WF_UPW", "WF_07D", "WF_14D", or "NONE")\n');
    fprintf(FInp,'"1-ED3"             IECstandard     - Number of IEC 61400-x standard (x=1,2, or 3 with optional 61400-1 edition number (i.e. "1-Ed2") )\n');
    fprintf(FInp,'"%s"                 IECturbc        - IEC turbulence characteristic ("A", "B", "C" or the turbulence intensity in percent) ("KHTEST" option with NWTCUP model, not used for other models)\n',strjoin(Parameters.WindData.WTCategory));
    fprintf(FInp,'"NTM"               IEC_WindType    - IEC turbulence type ("NTM"=normal, "xETM"=extreme turbulence, "xEWM1"=extreme 1-year wind, "xEWM50"=extreme 50-year wind, where x=wind turbine class 1, 2, or 3)\n');
    fprintf(FInp,'default             ETMc            - IEC Extreme Turbulence Model "c" parameter [m/s]\n');
    fprintf(FInp,'default             WindProfileType - Wind profile type ("JET","LOG"=logarithmic,"PL"=power law,"IEC"=PL on rotor disk,LOG elsewhere, or "default")\n');
    fprintf(FInp,'%3.2f               RefHt           - Height of the reference wind speed [m]\n',Parameters.WindData.HubHeight);
    fprintf(FInp,'%2.2f                 URef            - Mean (total) wind speed at the reference height [m/s] (or "default" for JET wind profile)\n',Parameters.WindValues4StaticAnalysis(iWind));
    fprintf(FInp,'default             ZJetMax         - Jet height [m] (used only for JET wind profile, valid 70-490 m)\n');
    fprintf(FInp,'default             PLExp           - Power law exponent [-] (or "default")           \n');
    fprintf(FInp,'default             Z0              - Surface roughness length [m] (or "default")\n');
    fprintf(FInp,'\n');
    fprintf(FInp,'--------Non-IEC Meteorological Boundary Conditions------------\n');
    fprintf(FInp,'default             Latitude        - Site latitude [degrees] (or "default")\n');
    fprintf(FInp,'0.05                RICH_NO         - Gradient Richardson number \n');
    fprintf(FInp,'default             UStar           - Friction or shear velocity [m/s] (or "default")\n');
    fprintf(FInp,'default             ZI              - Mixing layer depth [m] (or "default")\n');
    fprintf(FInp,'default             PC_UW           - Hub mean u''w'' Reynolds stress (or "default")\n');
    fprintf(FInp,'default             PC_UV           - Hub mean u''v'' Reynolds stress (or "default")\n');
    fprintf(FInp,'default             PC_VW           - Hub mean v''w'' Reynolds stress (or "default")\n');
    fprintf(FInp,'default             IncDec1         - u-component coherence parameters (e.g. "10.0  0.3e-3" in quotes) (or "default")\n');
    fprintf(FInp,'default             IncDec2         - v-component coherence parameters (e.g. "10.0  0.3e-3" in quotes) (or "default")\n');
    fprintf(FInp,'default             IncDec3         - w-component coherence parameters (e.g. "10.0  0.3e-3" in quotes) (or "default")\n');
    fprintf(FInp,'default             CohExp          - Coherence exponent (or "default")\n');
    fprintf(FInp,'\n');
    fprintf(FInp,'--------Coherent Turbulence Scaling Parameters-------------------\n');
    fprintf(FInp,'"C:\\eventdata"      CTEventPath     - Name of the path where event data files are located\n');
    fprintf(FInp,'"Random"            CTEventFile     - Type of event files ("LES", "DNS", or "RANDOM")\n');
    fprintf(FInp,'true                Randomize       - Randomize the disturbance scale and locations? (true/false)\n');
    fprintf(FInp,' 1.0                DistScl         - Disturbance scale (ratio of wave height to rotor disk). (Ignored when Randomize = true.)\n');
    fprintf(FInp,' 0.5                CTLy            - Fractional location of tower centerline from right (looking downwind) to left side of the dataset. (Ignored when Randomize = true.)\n');
    fprintf(FInp,' 0.5                CTLz            - Fractional location of hub height from the bottom of the dataset. (Ignored when Randomize = true.)\n');
    fprintf(FInp,'30.0                CTStartTime     - Minimum start time for coherent structures in RootName.cts [seconds]\n');
    fprintf(FInp,'    \n');
    fprintf(FInp,'==================================================\n');
    fprintf(FInp,'NOTE: Do not add or remove any lines in this file!\n');
    fprintf(FInp,'==================================================');
    
    fclose(FInp);
    
    
end

% run TurbSim
[status, result] = dos('RunAll.cmd &', '-echo');

%% change dir
cd(LocalDir);
cd(ExtTurbulentWindFolder);

%% ETM
% write inp files
Scale = 1.0; % 1.0 for Turbulent, 1.4 for Steady)
switch Parameters.WindData.WTClass
    case 1
        XTRMWind = Scale*50;
    case 2
        XTRMWind = Scale*42.5;
    case 3
        XTRMWind = Scale*37.5;
    otherwise
        XTRMWind = input('EWM wind value [m/s] =');
end
        


for iWind=1:1
    FileName = sprintf('TurbA_XTRM.inp');
    FInp = fopen(FileName,'w');
    fprintf(FInp,'TurbSim Input File. Valid for TurbSim v1.40, 12-Sep-2008, written by Matlab %s\n',date); 
    fprintf(FInp,'\n');
    fprintf(FInp,'---------Runtime Options-----------------------------------\n');
    fprintf(FInp,'18573235            RandSeed1       - First random seed  (-2147483648 to 2147483647) \n');
    fprintf(FInp,'RANLUX              RandSeed2       - Second random seed (-2147483648 to 2147483647) for intrinsic pRNG, or an alternative pRNG: "RanLux" or "RNSNLW"\n');
    fprintf(FInp,'False               WrBHHTP         - Output hub-height turbulence parameters in binary form?  (Generates RootName.bin)\n');
    fprintf(FInp,'False               WrFHHTP         - Output hub-height turbulence parameters in formatted form?  (Generates RootName.dat)\n');
    fprintf(FInp,'False               WrADHH          - Output hub-height time-series data in AeroDyn form?  (Generates RootName.hh)\n');
    fprintf(FInp,'False               WrADFF          - Output full-field time-series data in TurbSim/AeroDyn form? (Generates Rootname.bts)\n');
    fprintf(FInp,'False               WrBLFF          - Output full-field time-series data in BLADED/AeroDyn form?  (Generates RootName.wnd)\n');
    fprintf(FInp,'False               WrADTWR         - Output tower time-series data? (Generates RootName.twr)\n');
    fprintf(FInp,'True                WrFMTFF         - Output full-field time-series data in formatted (readable) form?  (Generates RootName.u, RootName.v, RootName.w)\n');
    fprintf(FInp,'False               WrACT           - Output coherent turbulence time steps in AeroDyn form? (Generates RootName.cts)\n');
    fprintf(FInp,'True                Clockwise       - Clockwise rotation looking downwind? (used only for full-field binary files - not necessary for AeroDyn)\n');
    fprintf(FInp,'True                ScaleIEC        - Scale hub-height IEC turbulence to target TI?\n');
    fprintf(FInp,'\n');
    fprintf(FInp,'--------Turbine/Model Specifications-----------------------\n');
    fprintf(FInp,'%i                  NumGrid_Z       - Vertical grid-point matrix dimension\n',Parameters.WindData.WindGridResol);
    fprintf(FInp,'%i                  NumGrid_Y       - Horizontal grid-point matrix dimension\n',Parameters.WindData.WindGridResol);
    fprintf(FInp,'%2.2f                TimeStep        - Time step [seconds]\n',Parameters.WindData.WindGridSample );
    fprintf(FInp,'200                 AnalysisTime    - Length of analysis time series [seconds] (program will add time if necessary: AnalysisTime = MAX(AnalysisTime, UsableTime+GridWidth/MeanHHWS) )\n');
    fprintf(FInp,'200                 UsableTime      - Usable length of output time series [seconds] (program will add GridWidth/MeanHHWS seconds)\n');
    fprintf(FInp,'%2.2f               HubHt           - Hub height [m] (should be > 0.5*GridHeight)\n',Parameters.WindData.HubHeight);
    fprintf(FInp,'%3.2f              GridHeight      - Grid height [m] \n',Parameters.WindData.WindGridSize);
    fprintf(FInp,'%3.2f              GridWidth       - Grid width [m] (should be >= 2*(RotorRadius+ShaftLength))\n',Parameters.WindData.WindGridSize);
    fprintf(FInp,'0                   VFlowAng        - Vertical mean flow (uptilt) angle [degrees]\n');
    fprintf(FInp,'0                   HFlowAng        - Horizontal mean flow (skew) angle [degrees]\n');
    fprintf(FInp,'  \n');
    fprintf(FInp,'--------Meteorological Boundary Conditions-------------------\n');
    fprintf(FInp,'"IECKAI"            TurbModel       - Turbulence model ("IECKAI"=Kaimal, "IECVKM"=von Karman, "GP_LLJ", "NWTCUP", "SMOOTH", "WF_UPW", "WF_07D", "WF_14D", or "NONE")\n');
    fprintf(FInp,'"1-ED3"             IECstandard     - Number of IEC 61400-x standard (x=1,2, or 3 with optional 61400-1 edition number (i.e. "1-Ed2") )\n');
    fprintf(FInp,'"%s"                 IECturbc        - IEC turbulence characteristic ("A", "B", "C" or the turbulence intensity in percent) ("KHTEST" option with NWTCUP model, not used for other models)\n',strjoin(Parameters.WindData.WTCategory));
    fprintf(FInp,'"%iEWM50"            IEC_WindType    - IEC turbulence type ("NTM"=normal, "xETM"=extreme turbulence, "xEWM1"=extreme 1-year wind, "xEWM50"=extreme 50-year wind, where x=wind turbine class 1, 2, or 3)\n',Parameters.WindData.WTClass);
    fprintf(FInp,'default             ETMc            - IEC Extreme Turbulence Model "c" parameter [m/s]\n');
    fprintf(FInp,'default             WindProfileType - Wind profile type ("JET","LOG"=logarithmic,"PL"=power law,"IEC"=PL on rotor disk,LOG elsewhere, or "default")\n');
    fprintf(FInp,'%3.2f               RefHt           - Height of the reference wind speed [m]\n',Parameters.WindData.HubHeight);
    fprintf(FInp,'%2.2f                 URef            - Mean (total) wind speed at the reference height [m/s] (or "default" for JET wind profile)\n',XTRMWind);
    fprintf(FInp,'default             ZJetMax         - Jet height [m] (used only for JET wind profile, valid 70-490 m)\n');
    fprintf(FInp,'default             PLExp           - Power law exponent [-] (or "default")           \n');
    fprintf(FInp,'default             Z0              - Surface roughness length [m] (or "default")\n');
    fprintf(FInp,'\n');
    fprintf(FInp,'--------Non-IEC Meteorological Boundary Conditions------------\n');
    fprintf(FInp,'default             Latitude        - Site latitude [degrees] (or "default")\n');
    fprintf(FInp,'0.05                RICH_NO         - Gradient Richardson number \n');
    fprintf(FInp,'default             UStar           - Friction or shear velocity [m/s] (or "default")\n');
    fprintf(FInp,'default             ZI              - Mixing layer depth [m] (or "default")\n');
    fprintf(FInp,'default             PC_UW           - Hub mean u''w'' Reynolds stress (or "default")\n');
    fprintf(FInp,'default             PC_UV           - Hub mean u''v'' Reynolds stress (or "default")\n');
    fprintf(FInp,'default             PC_VW           - Hub mean v''w'' Reynolds stress (or "default")\n');
    fprintf(FInp,'default             IncDec1         - u-component coherence parameters (e.g. "10.0  0.3e-3" in quotes) (or "default")\n');
    fprintf(FInp,'default             IncDec2         - v-component coherence parameters (e.g. "10.0  0.3e-3" in quotes) (or "default")\n');
    fprintf(FInp,'default             IncDec3         - w-component coherence parameters (e.g. "10.0  0.3e-3" in quotes) (or "default")\n');
    fprintf(FInp,'default             CohExp          - Coherence exponent (or "default")\n');
    fprintf(FInp,'\n');
    fprintf(FInp,'--------Coherent Turbulence Scaling Parameters-------------------\n');
    fprintf(FInp,'"C:\\eventdata"      CTEventPath     - Name of the path where event data files are located\n');
    fprintf(FInp,'"Random"            CTEventFile     - Type of event files ("LES", "DNS", or "RANDOM")\n');
    fprintf(FInp,'true                Randomize       - Randomize the disturbance scale and locations? (true/false)\n');
    fprintf(FInp,' 1.0                DistScl         - Disturbance scale (ratio of wave height to rotor disk). (Ignored when Randomize = true.)\n');
    fprintf(FInp,' 0.5                CTLy            - Fractional location of tower centerline from right (looking downwind) to left side of the dataset. (Ignored when Randomize = true.)\n');
    fprintf(FInp,' 0.5                CTLz            - Fractional location of hub height from the bottom of the dataset. (Ignored when Randomize = true.)\n');
    fprintf(FInp,'30.0                CTStartTime     - Minimum start time for coherent structures in RootName.cts [seconds]\n');
    fprintf(FInp,'    \n');
    fprintf(FInp,'==================================================\n');
    fprintf(FInp,'NOTE: Do not add or remove any lines in this file!\n');
    fprintf(FInp,'==================================================');
    
    fclose(FInp);
    
    
end

% run TurbSim
[status, result] = dos('TurbSim.exe TurbA_XTRM.inp &', '-echo');




%% change dir
cd(LocalDir);

