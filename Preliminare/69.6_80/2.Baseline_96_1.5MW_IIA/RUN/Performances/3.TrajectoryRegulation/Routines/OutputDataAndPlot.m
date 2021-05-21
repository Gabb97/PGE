%%%%%%%%%%%%%%%%%%%%%% TORQUE VS ROTOR SPEED
% no more here
% index: Parameters.CP_TSR.Indexes = [i j k];
% OMEGA_RPM = Parameters.CP_TSR.Omega(1:Parameters.CP_TSR.Indexes+1)*30/pi;
% TORQUE_kNm = Parameters.CP_TSR.Torque(1:Parameters.CP_TSR.Indexes+1)/1000;
% figure
% plot(OMEGA_RPM,TORQUE_kNm,'--+r',Parameters.CP_TSR.Omega*30/pi,Parameters.CP_TSR.Torque/1000,'-b',OMEGA_RPM2,TORQUE_kNm2,'--xk')


%% %%%%%%%%%%%%%%%%%%%  OUTPUT EXCEL
OUT_WIND  = [3:.1:25]';

OUT_RPM   = interp1(Parameters.CP_TSR.Winds,Parameters.CP_TSR.Omega ,OUT_WIND)*30/pi;
OUT_TORQUE= interp1(Parameters.CP_TSR.Winds,Parameters.CP_TSR.Torque,OUT_WIND)/1000;
OUT_PITCH = interp1(Parameters.CP_TSR.Winds,Parameters.CP_TSR.pitch,OUT_WIND);
OUT_POWER = interp1(Parameters.CP_TSR.Winds,Parameters.CP_TSR.Power,OUT_WIND)/1000;
OUT_POWERl= interp1(Parameters.CP_TSR.Winds,Parameters.CP_TSR.Power,OUT_WIND)/1000*0.9;

OUT_FULL = [OUT_WIND   OUT_RPM OUT_PITCH OUT_TORQUE OUT_POWER OUT_POWERl];

xlswrite('\Output\OutputData',OUT_FULL)

%% Weibull
Parameters.WeibullStruct.integTime      = 365*24;
Parameters.WeibullStruct.MeanWindSpeed  = OUT_WIND;
Parameters.WeibullStruct.Vave           = 8.5;
Parameters.WeibullStruct.k              = 2;
Parameters.WeibullStruct.C              = Parameters.WeibullStruct.Vave/gamma(1+1/Parameters.WeibullStruct.k);
Parameters.WeibullStruct.pw             = Weibull(Parameters.WeibullStruct.MeanWindSpeed,Parameters.WeibullStruct.C,Parameters.WeibullStruct.k);
% AEP
AEP   = Parameters.WeibullStruct.integTime*trapz(Parameters.WeibullStruct.MeanWindSpeed,Parameters.WeibullStruct.pw.*OUT_POWER*1000);
AEPl  = Parameters.WeibullStruct.integTime*trapz(Parameters.WeibullStruct.MeanWindSpeed,Parameters.WeibullStruct.pw.*OUT_POWERl*1000);
fprintf('\nAEP = %1.5e [MWh]\n',AEP/1.0e6);


return
figure(1120);  set(gcf, 'Name','Power VS Omega', 'NumberTitle','off')
hold on; zoom on; grid on;
hp=plot(Parameters.WeibullStruct.MeanWindSpeed,Parameters.WeibullStruct.pw);
set (hp,'LineWidth',2);
hx=xlabel('Wind [m/s]');set (hx,'FontSize',12,'FontWeight','bold');
hy=ylabel('Weibull probability (k=2)'); set (hy,'FontSize',12,'FontWeight','bold');
axis([0 25 0 max(Parameters.WeibullStruct.pw )*1.01])

i_Vave = find(Parameters.WeibullStruct.MeanWindSpeed<=Parameters.WeibullStruct.Vave,1,'last');

a1 = trapz(Parameters.WeibullStruct.MeanWindSpeed(1:i_Vave),Parameters.WeibullStruct.pw(1:i_Vave))
a2 = trapz(Parameters.WeibullStruct.MeanWindSpeed(i_Vave:end),Parameters.WeibullStruct.pw(i_Vave:end))
a1+a2

%% Compute eqv hours
PowerCurve.Vrated = Parameters.CP_TSR.Winds(Parameters.CP_TSR.Indexes(2)); 
PowerCurve.Prated = 0.1;%max(OUT_POWERl)%0.1; % not important here, 0.1 in order to have the power in the same figure of the Weibull

% Compute power curve (ideal, constant TSR)
i_Vrated = find(Parameters.WeibullStruct.MeanWindSpeed<=PowerCurve.Vrated,1,'last');
PowerCurve.PowerII  = PowerCurve.Prated/(PowerCurve.Vrated^3).*Parameters.WeibullStruct.MeanWindSpeed(1:i_Vrated).^3;
PowerCurve.PowerIII = PowerCurve.Prated*Parameters.WeibullStruct.MeanWindSpeed(i_Vrated+1:end)./Parameters.WeibullStruct.MeanWindSpeed(i_Vrated+1:end);

% Plot Power curve
hp=plot(Parameters.WeibullStruct.MeanWindSpeed(1:i_Vrated),PowerCurve.PowerII);
set (hp,'LineWidth',1);
hp=plot(Parameters.WeibullStruct.MeanWindSpeed(i_Vrated+1:end),PowerCurve.PowerIII);
set (hp,'LineWidth',1);
hx=xlabel('Wind [m/s]');set (hx,'FontSize',12,'FontWeight','bold');
hy=ylabel('Weibull probability (k=2)'); set (hy,'FontSize',12,'FontWeight','bold');

% Probability for region II and III
b1 = trapz(Parameters.WeibullStruct.MeanWindSpeed(1:i_Vrated),Parameters.WeibullStruct.pw(1:i_Vrated));
b2 = trapz(Parameters.WeibullStruct.MeanWindSpeed(i_Vrated+1:end),Parameters.WeibullStruct.pw(i_Vrated+1:end));
b1+b2;

% Non-dimendional equivalent hours
% In region II defined as the ratio between the EnergyProduction and the ideal EnergyProduction (ideal means if I had the rated power)
EqvHours_II_nondim  = b1*trapz(Parameters.WeibullStruct.MeanWindSpeed(1:i_Vrated),PowerCurve.PowerII)/(PowerCurve.Prated*(PowerCurve.Vrated-Parameters.WeibullStruct.MeanWindSpeed(1)));
EqvHours_III_nondim = b2;

% Dimensional equivalent hours (non-dimensional times the total hours)
EqvHours_II  = Parameters.WeibullStruct.integTime*EqvHours_II_nondim;
EqvHours_III = Parameters.WeibullStruct.integTime*EqvHours_III_nondim;

EqvHours = floor(EqvHours_II+EqvHours_III)
CapacityFactor = EqvHours/Parameters.WeibullStruct.integTime*100