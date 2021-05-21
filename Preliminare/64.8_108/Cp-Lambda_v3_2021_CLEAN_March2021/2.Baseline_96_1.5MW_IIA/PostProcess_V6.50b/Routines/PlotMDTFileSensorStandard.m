function []=PlotMDTFileSensorStandard(MDT,LegendStr,TitleStr,Symb)

%% BLADE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1001);  set(gcf, 'Name','Blade 1 Shear Fx', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.BladeRotatingPitchableRootForces{1}.Fx{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('Blade1RotatingPitchableRootForcesFx @ 0.m [kN]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','Blade1RotatingPitchableRootForcesMx');
% close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1002);  set(gcf, 'Name','Blade 1 Shear Fy', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.BladeRotatingPitchableRootForces{1}.Fy{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('Blade1RotatingPitchableRootForcesFy @ 0.m [kN]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','Blade1RotatingPitchableRootForcesMx');
% close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(10012);  set(gcf, 'Name','Blade 1 Shear Fxy', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.BladeRotatingPitchableRootForces{1}.Fxy{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('Blade1RotatingPitchableRootForcesFxy @ 0.m [kN]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','Blade1RotatingPitchableRootForcesMx');
% close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1003);  set(gcf, 'Name','Blade 1 Axial Fz', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.BladeRotatingPitchableRootForces{1}.Fz{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('Blade1RotatingPitchableRootForcesFz @ 0.m [kN]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','Blade1RotatingPitchableRootForcesMx');
% close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1004);  set(gcf, 'Name','Blade 1 EdgeWise Mx', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.BladeRotatingPitchableRootForces{1}.Mx{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('Blade1RotatingPitchableRootForcesMx @ 0.m [kNm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','Blade1RotatingPitchableRootForcesMx');
% close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1005); set(gcf, 'Name','Blade 1 FlapWise My', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.BladeRotatingPitchableRootForces{1}.My{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('Blade1RotatingPitchableRootForcesMy  @ 0.m [kNm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','Blade1RotatingPitchableRootForcesMy');
% close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(10045); set(gcf, 'Name','Blade 1 Total Mxy', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.BladeRotatingPitchableRootForces{1}.Mxy{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('Blade1RotatingPitchableRootForcesMxy  @ 0.m [kNm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','Blade1RotatingPitchableRootForcesMy');
% close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1006); set(gcf, 'Name','Blade 1 Torsional Mz', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.BladeRotatingPitchableRootForces{1}.Mz{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('Blade1RotatingPitchableRootForcesMz  @ 0.m [kNm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','Blade1RotatingPitchableRootForcesMy');
% close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1501); set(gcf, 'Name','Blade 1 Displacement X-Pitchable', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.BladeRotatingPitchableDisplacements{1}.Disp{end}(:,1),Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('Blade1RotatingPitchableTipDisplacementsX @ tip [m]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','Blade1RotatingPitchableRootForcesMy');
% close


%% HUB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2001); set(gcf, 'Name','HubFixedForcesFx', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.HubFixedForces{1}.Fx{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('HubFixedForcesFx [kN]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','Blade1RotatingPitchableRootForcesMy');
% close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2000); set(gcf, 'Name','HubFixedForcesFy', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.HubFixedForces{1}.Fy{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('HubFixedForcesFy [kN]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','Blade1RotatingPitchableRootForcesMy');
% close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2004); set(gcf, 'Name','HubFixedForcesMx', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.HubFixedForces{1}.Mx{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('HubFixedForcesMx [kNm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','Blade1RotatingPitchableRootForcesMy');
% close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2005); set(gcf, 'Name','HubFixedForcesMy', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.HubFixedForces{1}.My{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('HubFixedForcesMy [kNm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','Blade1RotatingPitchableRootForcesMy');
% close


%% TOWER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3004); set(gcf, 'name','TowerRootLocalForcesMx', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.TowerRootLocalForces{1}.Mx{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('TowerRootLocalForcesMx [kNm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','TowerRootLocalForcesMy');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3005); set(gcf, 'name','TowerRootLocalForcesMy', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.TowerRootLocalForces{1}.My{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('TowerRootLocalForcesMy [kNm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','TowerRootLocalForcesMy');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(30045); set(gcf, 'name','TowerRootLocalForcesMxy', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.TowerRootLocalForces{1}.Mxy{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('TowerRootLocalForcesMxy [kNm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','TowerRootLocalForcesMy');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3011); set(gcf, 'name','TowerTopLocalForcesFx', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.TowerTopLocalForces{1}.Fx{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('TowerTopLocalForcesFx [kN]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','TowerRootLocalForcesMy');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3012); set(gcf, 'name','TowerTopLocalForcesFy', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.TowerTopLocalForces{1}.Fy{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('TowerTopLocalForcesFy [kN]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','TowerRootLocalForcesMy');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3013); set(gcf, 'name','TowerTopLocalForcesMx', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.TowerTopLocalForces{1}.Mx{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('TowerTopLocalForcesMx [kNm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','TowerRootLocalForcesMy');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3014); set(gcf, 'name','TowerTopLocalForcesMy', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.TowerTopLocalForces{1}.My{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('TowerTopLocalForcesMy [kNm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','TowerRootLocalForcesMy');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3015); set(gcf, 'name','TowerTopLocalForcesMz', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.TowerTopLocalForces{1}.Mz{1}/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('TowerTopLocalForcesMz [kNm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','TowerRootLocalForcesMy');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(104); set(gcf, 'name','Blade 1 Pitch', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.Pitch{1}*180/pi,Symb);
set (hp,'LineWidth',1);
hp=plot(MDT.Time,MDT.Pitch{2}*180/pi,Symb);
set (hp,'LineWidth',2);
hp=plot(MDT.Time,MDT.Pitch{3}*180/pi,Symb);
set (hp,'LineWidth',3);
hx=xlabel('Time [s]'); hy=ylabel('\beta [deg]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%print('-djpeg','Pitch');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(103); set(gcf, 'name','Rotor Speed', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(MDT.Time,MDT.RotorSpeed*30/pi,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('\Omega [rpm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
%     axis([-Inf Inf -Inf Inf])
%print('-djpeg','Power');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(109); set(gcf, 'name','Nacelle Orientation', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(MDT.Time,MDT.YawRotation*180/pi,Symb);
% set (hp,'LineWidth',2);
% hx=xlabel('Time [s]'); hy=ylabel('Angle From North [deg]');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
% %     axis([-Inf Inf -Inf Inf])
% % print('-djpeg','Power');
% 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(2001); set(gcf, 'name','TowerTipForeAftDisplacements', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(MDT.Time,MDT.TowerTipForeAftDisplacements,Symb);
% set (hp,'LineWidth',2);
% hp=plot(MDT.Time,MDT.TowerTipSideSideDisplacements,Symb);
% set (hp,'LineWidth',1);
% hx=xlabel('Time [s]'); hy=ylabel('TowerTipForeAftDisplacements [m] - Inertial Frame -');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
% %print('-djpeg','TowerTipForeAftDisplacements');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(2002); set(gcf, 'name','TowerTipSideSideDisplacements', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(MDT.Time,MDT.TowerTipForeAftVelocities,Symb);
% set (hp,'LineWidth',2);
% hp=plot(MDT.Time,MDT.TowerTipSideSideVelocities,Symb);
% set (hp,'LineWidth',1);
% hx=xlabel('Time [s]'); hy=ylabel('TowerTipForeAftVelocities [m/s] - Inertial Frame -');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
% %print('-djpeg','TowerTipSideSideDisplacements');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% time_m = 0.5*(MDT.Time(2:end)+MDT.Time(1:end-1));
% a_FA   = diff(MDT.TowerTipForeAftVelocities)./diff(MDT.Time);
% a_SS   = diff(MDT.TowerTipSideSideVelocities)./diff(MDT.Time);
% 
% figure(2003); set(gcf, 'name','TowerTipAccelerations', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(time_m,a_FA,Symb);
% set (hp,'LineWidth',2);
% hp=plot(time_m,a_SS,Symb);
% set (hp,'LineWidth',1);
% hx=xlabel('Time [s]'); hy=ylabel('TowerTipAccelerations [m/s^2] - Inertial Frame -');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr, 'Location', 'SouthEast','Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
% %print('-djpeg','TowerTipSideSideDisplacements');
