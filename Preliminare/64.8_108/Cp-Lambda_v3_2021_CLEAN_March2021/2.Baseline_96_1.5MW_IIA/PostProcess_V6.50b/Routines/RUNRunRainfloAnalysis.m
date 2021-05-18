function [RainFlowStruct,FigHandle] = RUNRunRainfloAnalysis(Parameters,iDLC,LegendStr,TitleStr,Symb,ExtraParameters)

%FIGURES Options
FigOption.Symb   = Symb;
FigOption.Title  = TitleStr;
FigOption.Legend = LegendStr;
FigOption.XLabel = 'SN Slope';

% Time
iStart = find(Parameters.MDT{iDLC}.Time >= Parameters.DLC.InitTime(iDLC),1,'first');
iEnd   = find(Parameters.MDT{iDLC}.Time <= Parameters.DLC.EndTime(iDLC),1,'last');
Signal.time = Parameters.MDT{iDLC}.Time(iStart:iEnd);

% Signal
% iTotSensor = 0;
for iSensor = 1:size(Parameters.SensorList,1)
    for iComp = 1:length(Parameters.SensorList{iSensor,2})
        CompNumb = Parameters.SensorList{iSensor,2}(iComp);
%         iTotSensor = iTotSensor + 1;
        mdt_temp = getfield(Parameters.MDT{iDLC},Parameters.SensorList{iSensor,1});
        % other (local) figure options
        FigOption.Number = 100000 + iSensor*100 + CompNumb;
        FigOption.Name   = sprintf('%s -- Equivalent Load',mdt_temp.Extensions{CompNumb});
        FigOption.YLabel = strcat(mdt_temp.Extensions{CompNumb},mdt_temp.Units{CompNumb});
        % Time History
        Signal.history   = mdt_temp.TimeHistories(iStart:iEnd,CompNumb);
        % Extract Range from Envelope
        Envelope = Parameters.Envelope{iSensor};
        Range = Envelope.Matrix(2*(iComp-1)+1:2*(iComp-1)+2,iComp);
        % COMPUTE Rainflow...
        RainFlowStruct(iSensor,iComp)=RunRainFlowAnalysis(Signal.time,Signal.history,ExtraParameters,Range);
        % consider number events in the whole life 
        RainFlowStruct(iSensor,iComp).Ttime        = Parameters.WeibullStruct.N(iDLC)*RainFlowStruct(iSensor,iComp).Ttime;
        RainFlowStruct(iSensor,iComp).Ncycle{1}    = Parameters.WeibullStruct.N(iDLC)*RainFlowStruct(iSensor,iComp).Ncycle{1};
        RainFlowStruct(iSensor,iComp).NrangeCum{1} = Parameters.WeibullStruct.N(iDLC)*RainFlowStruct(iSensor,iComp).NrangeCum{1};
        % % AND PLOT
        % EqvLoad = RainFlowStruct(iSensor,iComp).EqvLoads{1};
        % SNSlope = 1./Par.m;
        % FigHandle = PlotFigureTimeHistory(SNSlope,EqvLoad,FigOption);
        FigHandle = [];
        %
    end
end

