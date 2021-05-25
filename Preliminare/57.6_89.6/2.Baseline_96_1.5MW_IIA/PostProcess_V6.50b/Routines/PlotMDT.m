function [FigHandle]=PlotMDT(MDT,SensorList,LegendStr,TitleStr,Symb,ShiftTime)

FigOption.Symb = Symb;
FigOption.Title = TitleStr;
FigOption.Legend = LegendStr;

for iSensor = 1:size(SensorList,1)
    for iComp = 1:length(SensorList{iSensor,2})
        mdt_temp = getfield(MDT,SensorList{iSensor,1});
        CompNumb = SensorList{iSensor,2}(iComp);
        % Fig options
        FigOption.Number = iSensor*100 + CompNumb;
        FigOption.Name   = mdt_temp.Extensions{CompNumb};
        FigOption.XLabel = 'Time [sec]';
        FigOption.YLabel = strcat(mdt_temp.Extensions{CompNumb},mdt_temp.Units{CompNumb});
        % Signal
        X = MDT.Time - ShiftTime;
        Y = mdt_temp.TimeHistories(:,CompNumb);
        % plot
        FigHandle = PlotFigureTimeHistory(X,Y,FigOption);
    end
end
