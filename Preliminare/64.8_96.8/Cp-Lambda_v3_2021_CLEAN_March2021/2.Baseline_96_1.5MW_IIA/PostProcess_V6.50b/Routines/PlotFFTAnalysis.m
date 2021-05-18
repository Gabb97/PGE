function [SignalFFT,FigHandle] = PlotFFTAnalysis(Parameters,iDLC,LegendStr,TitleStr,Symb,Par)

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
iTotSensor = 0;
for iSensor = 1:size(Parameters.SensorList,1)
    for iComp = 1:length(Parameters.SensorList{iSensor,2})
        CompNumb = Parameters.SensorList{iSensor,2}(iComp);
        iTotSensor = iTotSensor + 1;
        mdt_temp = getfield(Parameters.MDT{iDLC},Parameters.SensorList{iSensor,1});
        % other (local) figure options
        FigOption.Number = 10000 + iSensor*100 + CompNumb;
        FigOption.Name   = sprintf('%s -- FFT',mdt_temp.Extensions{CompNumb});
        FigOption.YLabel = strcat(mdt_temp.Extensions{CompNumb},mdt_temp.Units{CompNumb});
        % Time History
        Signal.history   = mdt_temp.TimeHistories(iStart:iEnd,CompNumb);
        % COMPUTE FFT ...
        SignalFFT(iTotSensor) = ComputeSignalFFT(Signal,Par);
        % AND PLOT
        NN2 = SignalFFT(iTotSensor).NFFT2;
        FFT = SignalFFT(iTotSensor).FRQ(1:NN2);
        ABS = SignalFFT(iTotSensor).ABS(1:NN2);
        FigHandle = PlotFigureTimeHistoryLogY(FFT,ABS,FigOption);
    end
end


