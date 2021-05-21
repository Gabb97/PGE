%% INPUT_Fatigue_and_Weibull_Data for Power curvue, LDD and/or Fatigue Loads
%
% Updates:
%           27.03.2020 -    I add a link to the WTData.xlsx info file so that
%                           the parameters of the Weibull distribution are
%                           automatically computed from the WT class #LS
%

% Link to WTData.xlsx #LS
ExcelFileName       =   '.\..\RUN\Performances\0.Main\WTData.xlsx';
SheetName           =   'WTData';

% Send status
disp(' ' )
disp('Building Weibull distribution........')



% Read xls file
try
    Parameters.WindData.WTClass         =   xlsread(ExcelFileName,SheetName,'B30');
catch
    disp(' ')
    dispstr = ['WARNING: Unable to read the file ' ExcelFileName];
    disp(dispstr);
    return
end

Vave_Classes                        =   [10 8.5 7.5];
WT_Classes                          =   {'High Wind' 'Medium Wind' 'Low Wind'};

Vave                                =   Vave_Classes(Parameters.WindData.WTClass);
WTClass                             =   WT_Classes{Parameters.WindData.WTClass};

% Sent status
disp(' ' )
dispstr = ['WT class is:             ' num2str(Parameters.WindData.WTClass ) ' (' WTClass ')'];
disp(dispstr)
dispstr = ['Annual average speed is: '  num2str(Vave) ' m/s'];
disp(dispstr)



% FATIGUE parameters
Parameters.Fatigue.NumberOfYears = 20;
Parameters.Fatigue.m = [3 5 7 10] ;
Parameters.Fatigue.EqvFreq = 1e7/(Parameters.Fatigue.NumberOfYears*365*24*60*60);    %[Hz]  equal to 1e7cycles   ;
Parameters.Fatigue.RainFlowNumbBins = 64;

% WEIBULL parameters
NumberOf10minSimulations                = 1;

Parameters.WeibullStruct.integTime      = 365*24;
% Parameters.WeibullStruct.MeanWindSpeed  = [3:2:25]%    Parameters.PowerCurve.WIND;
Parameters.WeibullStruct.MeanWindSpeed  = Parameters.PowerCurve.WIND; 
Parameters.WeibullStruct.Vave           = Vave;   % as read from the WTData.xlsx file 
Parameters.WeibullStruct.k              = 2;
Parameters.WeibullStruct.C              = Parameters.WeibullStruct.Vave/gamma(1+1/Parameters.WeibullStruct.k);
Parameters.WeibullStruct.pw             = Weibull(Parameters.WeibullStruct.MeanWindSpeed,Parameters.WeibullStruct.C,Parameters.WeibullStruct.k);

Parameters.WeibullStruct.DeltaWind      = 2; %% mean(diff(Parameters.AdditionalDLC.Weibull.MeanWindSpeed))  ALEALE mean(diff(... is ok only for wind [3:2:25]..!
Parameters.WeibullStruct.N0             = Parameters.Fatigue.NumberOfYears*Parameters.WeibullStruct.integTime*6/NumberOf10minSimulations;                        % number of total occourences for each simualtion (600s)
Parameters.WeibullStruct.N              = round(Parameters.WeibullStruct.pw*Parameters.WeibullStruct.N0.*Parameters.WeibullStruct.DeltaWind);   % number of occourences (600s)
fprintf('\n*** Warning: total number of occourences for each mean wind value is set to %g, equal to %g [min] ***\n',Parameters.WeibullStruct.N0,(Parameters.Fatigue.NumberOfYears*Parameters.WeibullStruct.integTime*3600)/Parameters.WeibullStruct.N0/60);



