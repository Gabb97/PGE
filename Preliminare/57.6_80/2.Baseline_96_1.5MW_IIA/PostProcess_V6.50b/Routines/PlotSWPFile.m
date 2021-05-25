function []=PlotSWPFile(SWP,LegendStr,TitleStr,Symb,ShiftTime)

% Set initial time
PlotTime = SWP.Time - ShiftTime;

figure(555001); set(gcf, 'Name','SWP-ElTorque', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(PlotTime,SWP.array(:,23)/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('Electrical Torque [kNm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr,'Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

figure(555002);  set(gcf, 'Name','SWP-ElPower', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(PlotTime,SWP.array(:,15)/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('Electrical Power [kW]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr,'Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

figure(555003);  set(gcf, 'Name','SWP-Yaw Error', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(PlotTime,SWP.array(:,24)*180/pi,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('Yaw Error [deg]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr,'Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
% 
% figure(2555003);  set(gcf, 'Name','SWP-Yaw Error RAD', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(PlotTime,SWP.array(:,24),Symb);
% set (hp,'LineWidth',2);
% hx=xlabel('Time [s]'); hy=ylabel('Yaw Error [rad]');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr,'Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

figure(555004); set(gcf, 'Name','SWP-iState', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(PlotTime,SWP.array(:,117),Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('iState [-]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr,'Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

% figure(555005); set(gcf, 'Name','SWP-Azimuth', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(PlotTime,SWP.array(:,60)*180/pi,Symb);
% set (hp,'LineWidth',2);
% hx=xlabel('Time [s]'); hy=ylabel('Azimuth [deg]');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr,'Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
% 
% figure(555006); set(gcf, 'Name','SWP-FAAcc', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(PlotTime,SWP.array(:,53),Symb);
% set (hp,'LineWidth',2);
% hx=xlabel('Time [s]'); hy=ylabel('Tower Top FA Acceleration [m/s^2]');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr,'Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
% 
% figure(555007); set(gcf, 'Name','SWP-SSAcc', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(PlotTime,SWP.array(:,54),Symb);
% set (hp,'LineWidth',2);
% hx=xlabel('Time [s]'); hy=ylabel('Tower Top SS Acceleration [m/s^2]');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr,'Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

figure(555008); set(gcf, 'Name','SWP-WIND', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(PlotTime,SWP.array(:,165),'r',PlotTime,SWP.array(:,166),'b',PlotTime,SWP.array(:,167),'m');    % NEW
set (hp,'LineWidth',2);
hp=plot(PlotTime,SWP.array(:,27),'k' );
set (hp,'LineWidth',1,'LineStyle',':');
hx=xlabel('Time [s]'); hy=ylabel('Wind Speed [m/s]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr,'Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');


figure(555009); set(gcf, 'Name','SWP-PitchDemand', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(PlotTime,SWP.array(:,45)*180/pi,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('Pitch Demanded [deg]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr,'Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

% figure(555010); set(gcf, 'Name','SWP-YawRateDemand', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(PlotTime,SWP.array(:,46)*180/pi,Symb);
% set (hp,'LineWidth',2);
% hx=xlabel('Time [s]'); hy=ylabel('Yaw Rate Demanded [deg/s]');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr,'Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

figure(555011); set(gcf, 'Name','SWP-WINDANGLE', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(PlotTime,atan2(SWP.array(:,167),SWP.array(:,166))*180/pi,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('Wind Angle [deg]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr,'Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

% figure(555012); set(gcf, 'Name','SWP-IndividualPitchDemand', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(PlotTime,SWP.array(:,42:44)*180/pi,Symb);
% set (hp,'LineWidth',2);
% hx=xlabel('Time [s]'); hy=ylabel('Individual Pitch Demanded [deg]');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr,'Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

figure(555013);  set(gcf, 'Name','SWP-Demanded Nacelle Yaw Rate', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(PlotTime,SWP.array(:,48)*180/pi,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('Demanded Nacelle Yaw Rate [deg/s]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr,'Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

figure(555015);  set(gcf, 'Name','SWP-Nacelle Angle From North', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(PlotTime,SWP.array(:,37)*180/pi,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('Nacelle Angle From North [deg]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr,'Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

% figure(555016);  set(gcf, 'Name','SWP-Demanded Brake Torque', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(PlotTime,SWP.array(:,107)/1000,Symb);
% set (hp,'LineWidth',2);
% hx=xlabel('Time [s]'); hy=ylabel('Demanded Brake Torque [kNm]');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr,'Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

% figure(555017);  set(gcf, 'Name','SWP-Demanded Nacelle Yaw Torque', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(PlotTime,SWP.array(:,41)/1000,Symb);
% set (hp,'LineWidth',2);
% hx=xlabel('Time [s]'); hy=ylabel('Demanded Nacelle Yaw Torque [kNm]');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr,'Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

figure(555018);  set(gcf, 'Name','SWP-Demanded Generator Torque', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(PlotTime,SWP.array(:,47)/1000,Symb);
set (hp,'LineWidth',2);
hx=xlabel('Time [s]'); hy=ylabel('Demanded Generator Torque [kNm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr,'Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');


% figure(1555013);  set(gcf, 'Name','SWP-Demanded Nacelle Yaw Rate RAD', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(PlotTime,SWP.array(:,48),Symb);
% set (hp,'LineWidth',2);
% hx=xlabel('Time [s]'); hy=ylabel('Demanded Nacelle Yaw Rate [rad/s]');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr,'Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

% figure(1555015);  set(gcf, 'Name','SWP-Nacelle Angle From North RAD', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(PlotTime,-SWP.array(:,37),Symb);
% set (hp,'LineWidth',2);
% hx=xlabel('Time [s]'); hy=ylabel('Nacelle Angle From North [rad]');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr,'Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');


% figure(1555555); set(gcf, 'Name','SWP-ALL', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(PlotTime,SWP.array(:,1:145));
% set (hp,'LineWidth',1);
% hx=xlabel('Time [s]'); hy=ylabel('ALL [-]');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr,'Interpreter','none');
% % axis([0 40 -10 10])
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');


% figure(555556); set(gcf, 'Name','SWP-Brake Status', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(PlotTime,SWP.array(:,36),Symb);
% set (hp,'LineWidth',2);
% hx=xlabel('Time [s]'); hy=ylabel(' Brake Status [-]');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr,'Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

% figure(555557); set(gcf, 'Name','SWP-Brake Torque Demand', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(PlotTime,SWP.array(:,107)/1000,Symb);
% set (hp,'LineWidth',2);
% hx=xlabel('Time [s]'); hy=ylabel('Shaft Brake Torque Demand [kNm]');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr,'Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

% figure(555557); set(gcf, 'Name','SWP-Rotor&GeneratorSpeed', 'NumberTitle','off')
% hold on; grid on; zoom on;
% hp=plot(PlotTime,SWP.array(:,21)*30/pi,Symb);
% set (hp,'LineWidth',2);
% hp=plot(PlotTime,SWP.array(:,20)*30/pi,Symb);
% set (hp,'LineWidth',1);
% hx=xlabel('Time [s]'); hy=ylabel('Rotor (Thick) and Generator (Thin) Speed [rpm]');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr,'Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

figure(555558); set(gcf, 'Name','SWP-Rotor&RotorFilteredSpeed', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(PlotTime,SWP.array(:,21)*30/pi,Symb);
set (hp,'LineWidth',2);
hp=plot(PlotTime,SWP.array(:,203)*30/pi,Symb);
set (hp,'LineWidth',1);
hx=xlabel('Time [s]'); hy=ylabel('Actual (Thick) and Filtered (Thin) Rotor Speed [rpm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr,'Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

figure(555559); set(gcf, 'Name','SWP-HubWind&HubWindFiltered', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(PlotTime,SWP.array(:,27),Symb);
set (hp,'LineWidth',2);
hp=plot(PlotTime,SWP.array(:,202),Symb);
set (hp,'LineWidth',1);
hx=xlabel('Time [s]'); hy=ylabel('Actual (Thick) and Filtered (Thin) Wind Speed [m/s]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(LegendStr,'Interpreter','none');
ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');





% figure(666666661);  set(gcf, 'Name','SWP-Pitch ', 'NumberTitle','off')
% subplot(2,1,1)
% hold on; grid on; zoom on;
% hp=plot(PlotTime,SWP.array(:,45)*180/pi,Symb);
% set (hp,'LineWidth',2);
% hx=xlabel('Time [s]'); hy=ylabel('Collective Pitch Demand [deg]');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr,'Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');
% subplot(2,1,2)
% hold on; grid on; zoom on;
% hp=plot(PlotTime,SWP.array(:,46)*180/pi,Symb);
% set (hp,'LineWidth',2);
% hx=xlabel('Time [s]'); hy=ylabel('Collective Pitch Rate Demanded [deg/s]');
% set (hx,'FontSize',12,'FontWeight','bold');
% set (hy,'FontSize',12,'FontWeight','bold');
% legend(LegendStr,'Interpreter','none');
% ht=title(TitleStr);set (ht,'FontSize',14,'FontWeight','bold');

