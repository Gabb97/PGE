function [SignalPSD,FigHandle] = PlotPSDAnalysis(Parameters,iDLC,LegendStr,TitleStr,Symb,Par)

%FIGURES Options
FigOption.Symb   = Symb;
FigOption.Title  = TitleStr;
FigOption.Legend = LegendStr;
FigOption.XLabel = 'Frequency [Hz]';

% Time
iStart = find(Parameters.MDT{iDLC}.Time >= Parameters.DLC.InitTime(iDLC),1,'first');
iEnd   = find(Parameters.MDT{iDLC}.Time <= Parameters.DLC.EndTime(iDLC),1,'last');
Signal.time = Parameters.MDT{iDLC}.Time(iStart:iEnd);
Par.firstN = 1; % this beacause I have already cut the simulation

% Signal
iTotSensor = 1;
for iSensor = 1:size(Parameters.SensorList,1)
    for iComp = 1:length(Parameters.SensorList{iSensor,2})
        CompNumb = Parameters.SensorList{iSensor,2}(iComp);
        mdt_temp = Parameters.MDT{iDLC}.(Parameters.SensorList{iSensor,1});
        
        % other (local) figure options
        FigOption.Number = 1000000 + iSensor*100 + CompNumb;
        FigOption.Name   = sprintf('%s -- PSD',mdt_temp.Extensions{CompNumb});
        FigOption.YLabel = strcat(mdt_temp.Extensions{CompNumb},[mdt_temp.Units{CompNumb},'^2/Hz']);
        
        % Time History
        Signal.history   = mdt_temp.TimeHistories(iStart:iEnd,CompNumb);
        
        %Compute PSD
        DeltaT = mean(diff(Signal.time));  %sampling time
        SignalPSD(iTotSensor) = calcPSD_mod_v2(Signal.history, 1/DeltaT, Par.NumResolution, Par.WindowSize * 1/DeltaT);
        
        %plot
        FRQ = SignalPSD(iTotSensor).FRQ(1:end);
        PSD = SignalPSD(iTotSensor).PSD(1:end);
        FigHandle = PlotFigureTimeHistoryLogY(FRQ,PSD,FigOption);
        
        iTotSensor = iTotSensor + 1;
    end
end