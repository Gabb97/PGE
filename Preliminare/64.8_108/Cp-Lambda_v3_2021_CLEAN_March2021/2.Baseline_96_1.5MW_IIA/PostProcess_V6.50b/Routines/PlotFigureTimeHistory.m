function FigHandle = PlotFigureTimeHistory(X,Y,FigOption)


figure(FigOption.Number);  set(gcf, 'Name',FigOption.Name, 'NumberTitle','off'); FigHandle = figure(FigOption.Number);
hold on; grid on; zoom on;
hp=plot(X,Y,FigOption.Symb);
set (hp,'LineWidth',2);
hx=xlabel(FigOption.XLabel); set (hx,'FontSize',12,'FontWeight','bold');
hy=ylabel(FigOption.YLabel); set (hy,'FontSize',12,'FontWeight','bold');
legend(FigOption.Legend, 'Location', 'SouthEast','Interpreter','none');
ht=title(FigOption.Title);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','Blade1RotatingPitchableRootForcesMx');


