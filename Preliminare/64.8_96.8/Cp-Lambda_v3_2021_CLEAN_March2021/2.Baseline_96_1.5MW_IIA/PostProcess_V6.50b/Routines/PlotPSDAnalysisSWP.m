function [SignalPSD,FigHandle] = PlotPSDAnalysisSWP(Parameters,iDLC,LegendStr,TitleStr,Symb,Par)

%FIGURES Options
FigOption.Symb   = Symb;
FigOption.Title  = TitleStr;
FigOption.Legend = LegendStr;
FigOption.XLabel = 'Frequency [Hz]';

% Time
iStart = find(Parameters.SWP{iDLC}.Time >= Parameters.DLC.InitTime(iDLC),1,'first');
iEnd   = find(Parameters.SWP{iDLC}.Time <= Parameters.DLC.EndTime(iDLC),1,'last');
Signal.time = Parameters.SWP{iDLC}.Time(iStart:iEnd);
Par.firstN = 1; % this beacause I have already cut the simulation

%% Signal ElTorque
iTotSensor = 1;

swp_temp = Parameters.SWP{iDLC}.array(iStart:iEnd,23)/1000;

% other (local) figure options
FigOption.Number = 2000000 + iTotSensor*100;
FigOption.Name   = sprintf('%s -- PSD','SWP-ElTorque');
FigOption.YLabel = strcat('Electrical Torque [kNm]','^2/Hz');

% Time History
Signal.history   = swp_temp;

%Compute PSD
DeltaT = mean(diff(Signal.time));  %sampling time
SignalPSD(iTotSensor) = calcPSD_mod_v2(Signal.history, 1/DeltaT, Par.NumResolution, Par.WindowSize * 1/DeltaT);

%plot
FRQ = SignalPSD(iTotSensor).FRQ(1:end);
PSD = SignalPSD(iTotSensor).PSD(1:end);
FigHandle = PlotFigureTimeHistoryLogY(FRQ,PSD,FigOption);

%% Signal ElTorque
iTotSensor = 2;

swp_temp = Parameters.SWP{iDLC}.array(iStart:iEnd,23)/1000;

% other (local) figure options
FigOption.Number = 2000000 + iTotSensor*100;
FigOption.Name   = sprintf('%s -- PSD','SWP-SS-Acc');
FigOption.YLabel = strcat('Tower Top SS Acceleration [m/s^2]','^2/Hz');

% Time History
Signal.history   = swp_temp;

%Compute PSD
DeltaT = mean(diff(Signal.time));  %sampling time
SignalPSD(iTotSensor) = calcPSD_mod_v2(Signal.history, 1/DeltaT, Par.NumResolution, Par.WindowSize * 1/DeltaT);

%plot
FRQ = SignalPSD(iTotSensor).FRQ(1:end);
PSD = SignalPSD(iTotSensor).PSD(1:end);
FigHandle = PlotFigureTimeHistoryLogY(FRQ,PSD,FigOption);