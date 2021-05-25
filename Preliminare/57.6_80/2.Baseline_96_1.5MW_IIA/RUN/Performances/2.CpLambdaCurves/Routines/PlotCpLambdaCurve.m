function [Parameters] = PlotCpLambdaCurve(Parameters,V_inf,file_list,FileName,LineType)

% This routine reads the eigvalues from output parametric files
%
% INPUT:
% FileName: file name
% file_list: file folder
% Parameters:
% WindSpeed: wind speed value used to compute curves [m/s]
% maxPower: rated power [W]
% Efficiency: electrical efficiency [-]
% Diameter: rotor diameter [m]
% NacelleUpTilt: nacelle up-tile [deg]
% Vave: Weibull Vave[m/s]
% k: Weibull k [-]
%
% OUTPUT
%
% Author: A.C.,  March 2017
% Last mod:   February 2019

% input values and local variables
TSR_vector  = Parameters.TSRVector;
beta_vector = Parameters.BetaVector;
rho         = Parameters.rho;

if LineType<2  % ideal
    Line_Width = 2
    Line_Style = '-';
    Line_Style2 = '-.';
else        % real
    Line_Width = 2
    Line_Style = '--';
    Line_Style2 = ':';
end


%% Power Curve Wind Values
Parameters.PowerCurve.WIND     = [Parameters.MinWind:.01:Parameters.MaxWind];


%% data for non-dimensional coefficients and plot
Nb = length(beta_vector);
Nl = length(TSR_vector);
Nfile = Nb*Nl;

cost_T = 0.5 * rho * pi * (Parameters.RotorDiameter^3) * V_inf^2 / 8;
cost_F = 0.5 * rho * pi * (Parameters.RotorDiameter^2) * V_inf^2 / 4;


symb = {'-r','--b','-.m',':c','-r','--r','--b','--m','--c','-.r','-.b','-.m','-.c'};

legend_list = {...
    'C_P-Lambda' ...
    };

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i_file=1:1:length(file_list)
    i_tot = 0;
    for i_beta = 1:length(beta_vector)
        for i_TSR = 1:length(TSR_vector)
            i_tot = i_tot + 1
            
            file_name = sprintf('%s%i.mdt',file_list{i_file},i_tot);
            f_sta = fopen(file_name,'r');
            
            % read header -------------------------------------------
            dummy = fgetl(f_sta);
            while 1
                dummy = fgetl(f_sta);
                if strcmp(dummy,'****************************');
                    break;
                end
            end
            % read std mdt --------------------------------------------
            nstep = 0;
            while 1
                nstep = nstep + 1;
                [data,count] = fscanf (f_sta,'%i %g',[2,1]);
                if (count==0)
                    break;
                end
                time(nstep) = data(2);
                
                % HubFixedForces
                aa = fscanf (f_sta,'%g %g %g %g %g %g',[6,1]);
                thrust(i_TSR,i_beta) = aa(1); % I %save only the last one!
                torque(i_TSR,i_beta) = aa(4);
                
            end
            
            nstep = nstep-1;
            last_step(i_TSR,i_beta) = nstep;
            fclose (f_sta);
            
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Adimensional Coefficients
    Cf = - 1 * (thrust ./ cost_F);
    Ct = - 1 * (torque ./ cost_T);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Matlab struct
    LookUp.Pitch = beta_vector;
    LookUp.TSR   = TSR_vector';
    LookUp.Cf    = Cf;
    LookUp.Ct    = Ct;
    for i = 1:length(TSR_vector)
        LookUp.Cp(i,:)    = Ct(i,:)*TSR_vector(i);
    end
    
    [maxCp,imaxCp]=max(LookUp.Cp);
    [maxCt,imaxCt]=max(LookUp.Ct);
    maxTorque(i_file,:) = maxCt*cost_T;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% FIGURES
    for ib=1:Nb
        %             figure(800+ib)
        %             hold on; zoom on; grid on;
        %             hp=plot(LookUp.TSR,LookUp.Cp(:,ib),symb{i_file});
        %             set (hp,'LineWidth',2);
        %             hx=xlabel('\lambda'); hy=ylabel('C_{p}'); ht=title(strcat('\beta = ',num2str(beta_vector(ib)),'°'));
        %             set (hx,'FontSize',12,'FontWeight','bold');
        %             set (hy,'FontSize',12,'FontWeight','bold');
        %             set (ht,'FontSize',12,'FontWeight','bold');
        %             legend(legend_list)
        
        %             figure(700+ib)
        %             hold on; zoom on; grid on;
        %             hp=plot(LookUp.TSR,LookUp.Ct(:,ib),symb{i_file});
        %             set (hp,'LineWidth',2);
        %             hx=xlabel('\lambda'); hy=ylabel('C_{torque}'); ht=title(strcat('\beta = ',num2str(beta_vector(ib)),'°'));
        %             set (hx,'FontSize',12,'FontWeight','bold');
        %             set (hy,'FontSize',12,'FontWeight','bold');
        %             set (ht,'FontSize',12,'FontWeight','bold');
        %             legend(legend_list)
        %
        %             figure(ib+100)
        %             hold on; zoom on; grid on;
        %             hp=plot(LookUp.TSR,-torque(:,ib),symb{i_file});
        %             set (hp,'LineWidth',2);
        %             hx=xlabel('\lambda'); hy=ylabel('Torque [Nm]'); ht=title(strcat('\beta = ',num2str(beta_vector(ib)),'°'));
        %             set (hx,'FontSize',12,'FontWeight','bold');
        %             set (hy,'FontSize',12,'FontWeight','bold');
        %             set (ht,'FontSize',12,'FontWeight','bold');
        %             legend(legend_list)
        
    end
    
    
    
    figure(999)
    hold on; zoom on; grid on;
    hp=plot(LookUp.TSR,LookUp.Cp);
    set (hp,'LineWidth',Line_Width,'LineStyle',Line_Style);
    hx=xlabel('\lambda'); hy=ylabel('C_{Power}');
    set (hx,'FontSize',12,'FontWeight','bold');
    set (hy,'FontSize',12,'FontWeight','bold');
    legend(strcat('PitchAngle =',num2str(LookUp.Pitch'),' °'),'Location','northwest');
    axis([-Inf Inf 0 0.5])
    
    figure(888)
    hold on; zoom on; grid on;
    hp=plot(LookUp.TSR,LookUp.Cf);
    set (hp,'LineWidth',Line_Width,'LineStyle',Line_Style);
    hx=xlabel('\lambda'); hy=ylabel('C_{Thust}');
    set (hx,'FontSize',12,'FontWeight','bold');
    set (hy,'FontSize',12,'FontWeight','bold');
    legend(strcat('PitchAngle =',num2str(LookUp.Pitch'),' °'),'Location','northwest');
    axis([-Inf Inf 0 1.0])
    
    figure(777)
    hold on; zoom on; grid on;
    hp=plot(LookUp.TSR,LookUp.Ct);
    set (hp,'LineWidth',Line_Width,'LineStyle',Line_Style);
    hx=xlabel('\lambda'); hy=ylabel('C_{Torque}');
    set (hx,'FontSize',12,'FontWeight','bold');
    set (hy,'FontSize',12,'FontWeight','bold');
    legend(strcat('PitchAngle =',num2str(LookUp.Pitch'),' °'),'Location','northwest');
    axis([-Inf Inf 0 0.1])
    
    
    figure(99999)
    hold on; zoom on; grid on;
    hp=plot(LookUp.TSR,last_step,'-x');
    set (hp,'LineWidth',Line_Width,'LineStyle',Line_Style);
    hx=xlabel('\lambda'); hy=ylabel('Last Step [-]');
    set (hx,'FontSize',12,'FontWeight','bold');
    set (hy,'FontSize',12,'FontWeight','bold');
    legend(num2str(LookUp.Pitch'));
    
end

% return
if (Parameters.SaveFlag)
    save(strcat('.\OutputData\',FileName,'_MatLookUp.mat'),'LookUp')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% POWER CURVE AND LUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Parameters.CP_TSR.LookUp = LookUp;
[maxCp_beta,imaxCp_TSR]     = max(Parameters.CP_TSR.LookUp.Cp);
[maxCp,imaxCp_beta]         = max(maxCp_beta);

% Max Cp (Region II)
Parameters.CP_TSR.maxCp      = maxCp;
Parameters.CP_TSR.maxCpBeta  = Parameters.CP_TSR.LookUp.Pitch(imaxCp_beta);
Parameters.CP_TSR.maxCpTSR   = Parameters.CP_TSR.LookUp.TSR(imaxCp_TSR(imaxCp_beta));
Parameters.CP_TSR.OmegaRated = Parameters.CP_TSR.maxCpTSR*(Parameters.maxPower/(0.5*rho*pi*Parameters.RotorDiameter^5/32*maxCp))^(1/3);

Parameters.CP_TSR.OmegaVector = [Parameters.CP_TSR.OmegaRated*30/pi/15:Parameters.CP_TSR.OmegaRated*30/pi/15:Parameters.CP_TSR.OmegaRated*30/pi]*pi/30;
Parameters.CP_TSR.ElecTorque  = 0.5*pi*Parameters.rho*Parameters.RotorDiameter^5/32*maxCp/Parameters.CP_TSR.maxCpTSR^3*Parameters.CP_TSR.OmegaVector.^2;
Parameters.CP_TSR.MaxElecTorque = Parameters.CP_TSR.ElecTorque(end);
Parameters.CP_TSR.Winds       = Parameters.CP_TSR.OmegaVector/Parameters.CP_TSR.maxCpTSR*Parameters.RotorDiameter/2;
Parameters.CP_TSR.ElecPower   = Parameters.CP_TSR.ElecTorque.*Parameters.CP_TSR.OmegaVector;

% OVERSPEED
% First Constant Torque + Second Const Power
Parameters.CP_TSR.OmegaVector = [Parameters.CP_TSR.OmegaVector     Parameters.CP_TSR.OmegaRated*1.05      Parameters.CP_TSR.OmegaRated*1.10      Parameters.CP_TSR.OmegaRated*1.15      Parameters.CP_TSR.OmegaRated*1.20      Parameters.CP_TSR.OmegaRated*1.25 ];
Parameters.CP_TSR.ElecPower   = [Parameters.CP_TSR.ElecPower   Parameters.CP_TSR.ElecPower(end)*1.05  Parameters.CP_TSR.ElecPower(end)*1.00  Parameters.CP_TSR.ElecPower(end)*1.00  Parameters.CP_TSR.ElecPower(end)*1.00  Parameters.CP_TSR.ElecPower(end)*1.00 ];
Parameters.CP_TSR.ElecTorque  = Parameters.CP_TSR.ElecPower./Parameters.CP_TSR.OmegaVector;
Parameters.CP_TSR.Winds       = [Parameters.CP_TSR.Winds  25];

% Constant Torque
% Parameters.CP_TSR.OmegaVector = [Parameters.CP_TSR.OmegaVector  Parameters.CP_TSR.OmegaRated*1.25 ];
% Parameters.CP_TSR.ElecTorque  = [Parameters.CP_TSR.ElecTorque   Parameters.CP_TSR.ElecTorque(end)];
% Parameters.CP_TSR.ElecPower   = Parameters.CP_TSR.OmegaVector.*Parameters.CP_TSR.ElecTorque;
% Parameters.CP_TSR.Winds       = [Parameters.CP_TSR.Winds        25 ];

% Constant Power
% Parameters.CP_TSR.OmegaVector = [Parameters.CP_TSR.OmegaVector      Parameters.CP_TSR.OmegaRated*1.25 ];
% Parameters.CP_TSR.ElecPower   = [Parameters.CP_TSR.ElecPower    Parameters.CP_TSR.ElecPower(end)*1.25];
% Parameters.CP_TSR.ElecTorque  = Parameters.CP_TSR.ElecPower./Parameters.CP_TSR.OmegaVector;
% Parameters.CP_TSR.Winds       = [Parameters.CP_TSR.Winds  Parameters.CP_TSR.Winds(end)+2  Parameters.CP_TSR.Winds(end)+4  Parameters.CP_TSR.Winds(end)+20 ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1234)
hold on; zoom on; grid on;
hp=plot(Parameters.CP_TSR.OmegaVector*30/pi,Parameters.CP_TSR.ElecTorque/1000,'-k');
set (hp,'LineWidth',Line_Width,'LineStyle',Line_Style);
hx=xlabel('\Omega [rpm]'); hy=ylabel('Generator Torque [kNm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');

figure(12345)
hold on; zoom on; grid on;
hp=plot(Parameters.CP_TSR.OmegaVector*30/pi,Parameters.CP_TSR.ElecPower/1000,'-k');
set (hp,'LineWidth',Line_Width,'LineStyle',Line_Style);
hx=xlabel('\Omega [rpm]'); hy=ylabel('LSS Power [kW]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');


% Summary
% [Parameters.CP_TSR.OmegaVector'*30/pi   Parameters.CP_TSR.ElecTorque'/1000   Parameters.CP_TSR.ElecPower'/1000 Parameters.CP_TSR.Winds' ]
% LUT
% Parameters.CP_TSR.OmegaVector*30/pi
%  Parameters.CP_TSR.ElecTorque/1000

fin=fopen(strcat('.\OutputData\',FileName,'_GeneratorLUT.txt'),'w');
fprintf(fin,' %1.5e  ',[0 Parameters.CP_TSR.OmegaVector*30/pi]);
fprintf(fin,' \r');
fprintf(fin,' %1.5e  ',[0 Parameters.CP_TSR.ElecTorque/1000 ] );
fclose(fin);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fin=fopen(strcat('.\OutputData\',FileName,'_MaxCpPoint.txt'),'w');

fprintf(fin,'        MaxCp = %1.5e  [-]\r',Parameters.CP_TSR.maxCp);
fprintf(fin,' TSR  @ MaxCp = %1.5e  [-]\r',Parameters.CP_TSR.maxCpTSR);
fprintf(fin,'Pitch @ MaxCp = %1.5e [deg]\r',Parameters.CP_TSR.maxCpBeta);
fclose(fin);


%% %%%%%%%%%%%%%%%%% AEP %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Power curve
Parameters.PowerCurve.AeroPOWER = 0.5*Parameters.rho*Parameters.PowerCurve.WIND.^3*maxCp*pi*Parameters.RotorDiameter^2/4;
Parameters.PowerCurve.AeroPOWER = min(Parameters.PowerCurve.AeroPOWER,Parameters.maxPower);
Parameters.PowerCurve.POWER = Parameters.PowerCurve.Efficiency*Parameters.PowerCurve.AeroPOWER;

% Weibull
Parameters.WeibullStruct.integTime      = 365*24;
Parameters.WeibullStruct.MeanV_inf  = Parameters.PowerCurve.WIND;
Parameters.WeibullStruct.C              = Parameters.WeibullStruct.Vave/gamma(1+1/Parameters.WeibullStruct.k);
Parameters.WeibullStruct.pw             = Weibull(Parameters.WeibullStruct.MeanV_inf,Parameters.WeibullStruct.C,Parameters.WeibullStruct.k);

% AEP
Parameters.WeibullStruct.AEP            = Parameters.WeibullStruct.integTime*trapz(Parameters.WeibullStruct.MeanV_inf,Parameters.WeibullStruct.pw.*Parameters.PowerCurve.POWER);
fprintf('\rAEP = %1.5e [MWh]\r',Parameters.WeibullStruct.AEP/1.0e6);
Parameters.WeibullStruct.AeroAEP        = Parameters.WeibullStruct.integTime*trapz(Parameters.WeibullStruct.MeanV_inf,Parameters.WeibullStruct.pw.*Parameters.PowerCurve.AeroPOWER);
fprintf('\rAEP = %1.5e [MWh]\r',Parameters.WeibullStruct.AeroAEP/1.0e6);

% Fig
figure(1234567)
subplot(2,1,1)
hold on; zoom on; grid on;
hp=plot(Parameters.PowerCurve.WIND,Parameters.PowerCurve.AeroPOWER/1e6,'k');
set (hp,'LineWidth',Line_Width,'LineStyle',Line_Style);
hp=plot(Parameters.PowerCurve.WIND,Parameters.PowerCurve.POWER/1e6,'k');
set (hp,'LineWidth',Line_Width,'LineStyle',Line_Style2);
hx=xlabel('Hub Wind Speed [rpm]'); set (hx,'FontSize',12,'FontWeight','bold');
hy=ylabel('Power [MW]'); set (hy,'FontSize',12,'FontWeight','bold');
legend('Aero','Electrical','Location','northwest');
axis([3 25 0 2])
subplot(2,1,2)
hold on; zoom on; grid on;
hp=plot(Parameters.PowerCurve.WIND,Parameters.WeibullStruct.pw,'-k');
set (hp,'LineWidth',Line_Width,'LineStyle',Line_Style);
hy=ylabel(sprintf('Weibull probability (k=%g)',Parameters.WeibullStruct.k)); set (hy,'FontSize',12,'FontWeight','bold');
hx=xlabel('Hub Wind Speed [rpm]');set (hx,'FontSize',12,'FontWeight','bold');
axis([3 25 0 0.2])
%  print('-djpeg100','PowerCurve_Weibull.jpg')

