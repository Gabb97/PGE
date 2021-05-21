function [LDD] = LDDAnalysis(Parameters,iSensor,CompNumb,NBin)

%% SET BINS from max/min values
[Signal.SensorVertexValues,Signal.SensorMiddleValues] = SetBins(Parameters,iSensor,CompNumb,NBin);

%% RUN LDD Analysis
for iDLC = 1:size(Parameters.DLC.Run,1)
    try
        iStart = find(Parameters.MDT{iDLC}.Time >= Parameters.DLC.InitTime(iDLC),1,'first');
    catch
        fprintf('\n*** ERROR in DLC %i [%s]!!\n',iDLC,Parameters.DLC.Run{iDLC});
        keyboard
    end
    iEnd   = find(Parameters.MDT{iDLC}.Time <= Parameters.DLC.EndTime(iDLC),1,'last');
    
    Signal.time    = Parameters.MDT{iDLC}.Time(iStart:iEnd);
    
    % Extract Sensor time history
    mdt_temp = getfield(Parameters.MDT{iDLC},Parameters.SensorList{iSensor,1});
    Signal.history = mdt_temp.TimeHistories(iStart:iEnd,CompNumb)*Parameters.DLC.Safety(iDLC);     % DLCs times its safety factor
    
    [TotTime(iDLC,:),TotalSimTime(iDLC)] = LDDAnalysisSubroutine(Signal);
    % Weibull
    TotTimeWeibull(iDLC,:) = TotTime(iDLC,:)*Parameters.WeibullStruct.N(iDLC) ;
end



%% SET OUTPUT
LDD.TotTime         = TotTime;
LDD.TotTimeWeibull  = TotTimeWeibull;
LDD.TotTimeWeibullBin  = sum(TotTimeWeibull);
LDD.TotalSimTime    = TotalSimTime;
LDD.MediumNSignal   = Signal.SensorMiddleValues ;

%% PLOT
figname = sprintf('%s LDD Total',mdt_temp.Extensions{CompNumb});
figure(1000000+iSensor*100+CompNumb); set(gcf, 'Name', figname, 'NumberTitle','off')
% bar(LDD.MediumNSignal,sum(LDD.TotalSimTime))
bar(LDD.MediumNSignal,LDD.TotTimeWeibullBin)
hx=xlabel(sprintf('%s Bin Value',mdt_temp.Extensions{CompNumb})); set (hx,'FontSize',12,'FontWeight','bold');
hy=ylabel('Load Duration Distributions [sec]'); set (hy,'FontSize',12,'FontWeight','bold');
grid

figname = sprintf('%s LDD Partial',mdt_temp.Extensions{CompNumb});
figure(1500000+iSensor*100+CompNumb); set(gcf, 'Name', figname, 'NumberTitle','off')
bar(LDD.MediumNSignal,LDD.TotTime')
hx=xlabel(sprintf('%s Bin Value',mdt_temp.Extensions{CompNumb})); set (hx,'FontSize',12,'FontWeight','bold');
hy=ylabel('Load Duration Distributions [sec]'); set (hy,'FontSize',12,'FontWeight','bold');
grid

figname = sprintf('%s LDD Partial Weibull',mdt_temp.Extensions{CompNumb});
figure(2000000+iSensor*100+CompNumb); set(gcf, 'Name', figname, 'NumberTitle','off')
bar(LDD.MediumNSignal,LDD.TotTimeWeibull')
hx=xlabel(sprintf('%s Bin Value',mdt_temp.Extensions{CompNumb})); set (hx,'FontSize',12,'FontWeight','bold');
hy=ylabel('Load Duration Distributions [sec]'); set (hy,'FontSize',12,'FontWeight','bold');
grid

return

% hx=xlabel(FigOption.XLabel); set (hx,'FontSize',12,'FontWeight','bold');
% hy=ylabel(FigOption.YLabel); set (hy,'FontSize',12,'FontWeight','bold');
% legend(FigOption.Legend, 'Location', 'SouthEast')
% ht=title(FigOption.Title);set (ht,'FontSize',14,'FontWeight','bold');

% figure
% bar(Signal.SensorMiddleValues,TotTime')
% xlabel('MediumNSingal')
% ylabel('TotTime')
% grid
%
% figure
% bar(Signal.SensorMiddleValues,sum(TotTime))
% xlabel('MediumNSingal')
% ylabel('TotTime')
% grid


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [TotTime,TotalSimTime] = LDDAnalysisSubroutine(SignalStruct)

time   = SignalStruct.time ;
signal = SignalStruct.history ;

deltaTime = mean(diff(time));

for ib=1:length(SignalStruct.SensorMiddleValues)
    Nindex{ib} = find( (signal>=SignalStruct.SensorVertexValues(ib)) & (signal<SignalStruct.SensorVertexValues(ib+1)));
    TotTime(ib) = length(time(Nindex{ib}))*deltaTime;
end
TotalSimTime = sum(TotTime);   % simulation time!
%
return