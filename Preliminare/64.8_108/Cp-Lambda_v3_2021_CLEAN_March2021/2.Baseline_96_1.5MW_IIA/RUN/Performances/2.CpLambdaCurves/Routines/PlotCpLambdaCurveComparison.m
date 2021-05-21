function [Parameters] = PlotCpLambdaCurveComparison(Parameters,file_list,pitch_sel)

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


%% 
legend_list = {...
    'Ideal Curves' ...
    'Real Curves' ...
    'Extra Curves' ...
    'Extra Curves' ...
    };


Radius      = Parameters.RotorDiameter/2;   % radius at tip [m]
TSR_vector  = Parameters.TSRVector;
beta_vector = Parameters.BetaVector;
V_inf       = [Parameters.WindSpeedI Parameters.WindSpeedR Parameters.WindSpeedR];    % uniform wind speed [m/s] <- add here more values if you want to compare more than 2 curves
rho         = Parameters.rho;

%% Set parameters
symb = {'-','--','-.',':'};

Nb = length(beta_vector);
Nl = length(TSR_vector);
Nfile = Nb*Nl;

%% Loop on smimulations


for i_file=1:1:length(file_list)
    omega   = V_inf(i_file)*TSR_vector/Radius;

    cost_T = 0.5 * rho * pi * (Radius^3) * V_inf(i_file)^2;
    cost_F = 0.5 * rho * pi * (Radius^2) * V_inf(i_file)^2;

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
    % Matlab struct for POT
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


    figure(11999)
    hold on; zoom on; grid on;
    hp=plot(LookUp.TSR,LookUp.Cp,symb{i_file});
    set (hp,'LineWidth',2);
    hx=xlabel('\lambda'); hy=ylabel('C_{P}');
    set (hx,'FontSize',12,'FontWeight','bold');
    set (hy,'FontSize',12,'FontWeight','bold');
    legend(strcat('PitchAngle =',num2str(LookUp.Pitch'),' °'),'Location','northwest');
    axis([-Inf Inf 0 0.5])
    
    figure(119990)
    hold on; zoom on; grid on;
    hp=plot(LookUp.TSR,LookUp.Cp(:,pitch_sel),symb{i_file});
    set (hp,'LineWidth',2);
    hx=xlabel('\lambda'); hy=ylabel('C_{P}');
    set (hx,'FontSize',12,'FontWeight','bold');
    set (hy,'FontSize',12,'FontWeight','bold');
    legend(strcat('PitchAngle =',num2str(LookUp.Pitch(pitch_sel)'),' °'),'Location','northwest');
    axis([6 9 0.3 0.5])


end

