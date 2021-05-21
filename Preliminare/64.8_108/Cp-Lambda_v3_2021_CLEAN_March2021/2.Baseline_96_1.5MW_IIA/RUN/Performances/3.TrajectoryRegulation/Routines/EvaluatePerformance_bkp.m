function [Parameters] = EvaluatePerformance(Parameters,varargin)

disp('*** Initializing......')
if nargin >1
    symb = varargin{1};
else
    symb = '-r';
end

rho     =   Parameters.airProp.rho;

LookUp  =   Parameters.CP_TSR.LookUp;

beta_vector     = LookUp.Pitch;
TSR_vector      = LookUp.TSR';


%% Find Cp Max
disp('*** Refining Cp-TSR mesh......')

% Plot curves
[TSR_mat,Pitch_mat] = meshgrid(LookUp.TSR,LookUp.Pitch);
Cp_mat = LookUp.Cp';

figure(99);  set(gcf, 'Name','Surface', 'NumberTitle','off') % ALEALE
hold on; zoom on;
hp=surf(TSR_mat,Pitch_mat,Cp_mat);

% Generate initial guess by finding discrete maximum
[CpMaxs,iTSR]   =   max(LookUp.Cp);
[CpMax0,iPitch] =   max(CpMaxs);
Pitch0          =   LookUp.Pitch(iPitch);
TSR0            =   LookUp.TSR(iTSR(iPitch));

hp = plot3(TSR0,Pitch0,CpMax0,'x');
set(hp,'LineWidth',2);


MaxIter     =   100;
MaxFunEvals =   1000;
TolFun      =   1.e-6;
TolCon      =   1.e-6;
CpMaxOptimizationOptions = optimset('LargeScale','off','Display','off',...
                                    'MaxIter',MaxIter,'TolFun',TolFun,...
                                    'TolCon',TolCon,'MaxFunEvals',MaxFunEvals);

CpMaxParameters.TSR     =   TSR_mat;
CpMaxParameters.Pitch   =   Pitch_mat;
CpMaxParameters.Cp      =   Cp_mat;

% Refine guess by using smooth interpolation
UB =    [TSR_vector(end) beta_vector(end)];
LB =    [TSR_vector(1) beta_vector(1)];
p0 =    [TSR0,Pitch0];

[p,CpMaxNegative,ExitFlag,OutputInfo,grad,hessian] =  fmincon(@Cp_TSRPitch,p0,[],[],[],[],LB,UB,[],CpMaxOptimizationOptions,CpMaxParameters);

TSR_CpMax   =   p(1);
Pitch_CpMax =   p(2);
CpMax       =   -CpMaxNegative;

%Plot refined solution
hp  =   plot3(TSR_CpMax,Pitch_CpMax,CpMax,'o');
set (hp,'LineWidth',2);
close


%% Evaluate Performances

[maxCp_beta,imaxCp_TSR]         =   max(Parameters.CP_TSR.LookUp.Cp);
[maxCp,imaxCp_beta]             =   max(maxCp_beta);

Parameters.CP_TSR.maxCp         =   CpMax;
Parameters.CP_TSR.maxCpBeta     =   Pitch_CpMax;
Parameters.CP_TSR.maxCpTSR      =   TSR_CpMax;


Parameters.CP_TSR.Winds     = Parameters.minWindSpeed:.1:Parameters.maxWindSpeed;


% Let me compute the maximum speed @ which we have CpMax. If no tip speed 
% constraints apply, this is actually the V_rated. Otherwise, it is the 
% speed @ which the Region "2 and a half" begins.
disp(' ')
disp('*** Checking Max Tip Speed constraint......')

Parameters.CP_TSR.maxWindSpeed_at_maxCp = Parameters.maxVtip/TSR_CpMax;
v_r = (Parameters.maxPower/(0.5*Parameters.airProp.rho*0.25*pi*Parameters.Rotor.RotorDiameter^2*Parameters.CP_TSR.maxCp) )^(1/3);


% Evaluate omega_rated:
omega_r     =   (v_r*Parameters.CP_TSR.maxCpTSR)/(Parameters.Rotor.RotorDiameter/2);
omega_r     =   omega_r*30/pi;
% Evaluate omega_max:
omega_max   =   Parameters.maxVtip/(Parameters.Rotor.RotorDiameter/2);
omega_max   =   omega_max*30/pi;



if  Parameters.CP_TSR.maxWindSpeed_at_maxCp < v_r
    
    
    % Send Status
    disp(' ')
    disp(strcat(9,'--> Max Tip Speed active --> REGION 2.5'));
    disp(' ')
    dispstr = strcat(9,'v_r   =',32,num2str(v_r),32,'m/s',9,9,'omega_r   =',32,num2str(omega_r),32,'RPM');
    disp(dispstr);
    dispstr = strcat(9,'v_2.5 =',32,num2str(Parameters.CP_TSR.maxWindSpeed_at_maxCp),32,'m/s',...
                        9,9,'omega_max =',32,num2str(omega_max),32,'RPM');
    disp(dispstr);
    
else
    
    Parameters.CP_TSR.maxWindSpeed_at_maxCp = v_r;
        
    % Send Status
    disp(' ')
    disp(strcat(9,'--> Max Tip Speed inactive'));
    disp(' ')
    dispstr = strcat(9,'v_r   =',32,num2str(v_r),32,'m/s',9,9,'omega_r =',32,num2str(omega_r),32,'RPM');
    disp(dispstr);
end
    
Parameters.CP_TSR.OmegaRated = (v_r*Parameters.CP_TSR.maxCpTSR)/(Parameters.Rotor.RotorDiameter/2)*30/pi;
Parameters.CP_TSR.WindRated = v_r;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Region at max CP (Region 2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(' ')
disp('*** Building regulation trajectories......')
disp(' ')

% Initialize counters
region_2_count      =   0;
region_2_5_count    =   0;
region_3_count      =   0;
    
for i = 1:length(Parameters.CP_TSR.Winds)
   
    % Constant-TSR/Max Cp Region (REGION 2)
    % -------------------------------------
    if Parameters.CP_TSR.Winds(i) <= Parameters.CP_TSR.maxWindSpeed_at_maxCp
        
            region_2_count              =   region_2_count +1;
            
            if region_2_count ==1
                disp(strcat(9,'Building Region 2........'));
            end
                        
            Parameters.CP_TSR.Cpmax(i)  =   CpMax;
            Parameters.CP_TSR.TSR(i)    =   TSR_CpMax;
            Parameters.CP_TSR.pitch(i)  =   Pitch_CpMax;
            Parameters.CP_TSR.Omega(i)  =   Parameters.CP_TSR.TSR(i)*Parameters.CP_TSR.Winds(i)/(Parameters.Rotor.RotorDiameter/2);
            Parameters.CP_TSR.Power(i)  =   .5*rho*Parameters.CP_TSR.Winds(i)^3*(Parameters.Rotor.RotorDiameter/2)^2*pi*Parameters.CP_TSR.Cpmax(i);     
        
    end
    
    % Constant-Speed Region (REGION 2.5)
    % -------------------------------------
    if Parameters.CP_TSR.Winds(i) > Parameters.CP_TSR.maxWindSpeed_at_maxCp && Parameters.CP_TSR.Winds(i) <= v_r
        
        	region_2_5_count              =   region_2_5_count +1;
            
            if region_2_5_count ==1
                disp(strcat(9,'Building Region 2.5........'));
            end
            
            Parameters.CP_TSR.TSR(i)= Parameters.maxVtip/Parameters.CP_TSR.Winds(i);
    
            UB  =   [Parameters.CP_TSR.TSR(i) beta_vector(end)];
            LB  =   [Parameters.CP_TSR.TSR(i) beta_vector(1)];
            p0  =   [Parameters.CP_TSR.TSR(i),Pitch0];

            [p,CpMaxNegative,ExitFlag,OutputInfo,grad,hessian] =  fmincon(@Cp_TSRPitch,p0,[],[],[],[],LB,UB,[],CpMaxOptimizationOptions,CpMaxParameters);

            Parameters.CP_TSR.pitch(i)  =   p(2);
            Parameters.CP_TSR.Cpmax(i)  =   -CpMaxNegative;
            Parameters.CP_TSR.Omega(i)  =   Parameters.CP_TSR.TSR(i)*Parameters.CP_TSR.Winds(i)/(Parameters.Rotor.RotorDiameter/2);    
            Parameters.CP_TSR.Power(i)  =   .5*rho*Parameters.CP_TSR.Winds(i)^3*(Parameters.Rotor.RotorDiameter/2)^2*pi*Parameters.CP_TSR.Cpmax(i);
    end
    
    
    % Constant-Power Region (REGION 3)
    % -------------------------------------
    if  Parameters.CP_TSR.Winds(i) > v_r
            region_3_count  = region_3_count + 1;
            
            if region_3_count ==1
                disp(strcat(9,'Building Region 3........'));
            end
            
            Parameters.CP_TSR.Omega(i)  =   min(omega_max,omega_r)*pi/30;
            Parameters.CP_TSR.TSR(i)    =   (Parameters.CP_TSR.Omega(i)*(Parameters.Rotor.RotorDiameter/2))/Parameters.CP_TSR.Winds(i);
            Parameters.CP_TSR.Cpmax(i)  =   Parameters.maxPower/(.5*rho*(Parameters.Rotor.RotorDiameter/2)^2*pi*(Parameters.CP_TSR.Winds(i))^3);
            Parameters.CP_TSR.Power(i)  =   Parameters.maxPower;

            
            fsolveOptions               =   optimset('Display','off');
            
            Parameters.CP_TSR.pitch(i) = fsolve(@(x) (-interp2(CpMaxParameters.TSR,CpMaxParameters.Pitch,...
                                                        CpMaxParameters.Cp,Parameters.CP_TSR.TSR(i),x,'spline')+Parameters.CP_TSR.Cpmax(i)),20,...
                                                        fsolveOptions);
%             Parameters.CP_TSR.pitch(i) = fsolve(@(x) (-interp2(CpMaxParameters.TSR,CpMaxParameters.Pitch,...
%                                                         CpMaxParameters.Cp,Parameters.CP_TSR.TSR(i),x,'spline')+Parameters.CP_TSR.Cpmax(i)),...
%                                                         Parameters.CP_TSR.pitch(i-1),fsolveOptions);
    end
    
    
end
   
disp(' ')
disp('*** Preparing output......')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Torque computation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ALEALE
Parameters.CP_TSR.Torque = Parameters.CP_TSR.Power./Parameters.CP_TSR.Omega;
%% Save indexes
i   =   region_2_count;
j   =   region_2_count + region_2_5_count;
k   =   region_2_count + region_2_5_count + region_3_count;

Parameters.CP_TSR.Indexes = [i j k];

%% FIGURES
figure(100);  set(gcf, 'Name','PitchTorqueOmega VS Wind', 'NumberTitle','off')
subplot(3,1,1)
hold on; zoom on; grid on;
hp=plot(Parameters.CP_TSR.Winds,Parameters.CP_TSR.Omega*30/pi,symb);
set (hp,'LineWidth',2);
hy=ylabel('\Omega [rpm]');set (hy,'FontSize',12,'FontWeight','bold');
axis([Parameters.minWindSpeed Parameters.maxWindSpeed -Inf Inf]);
subplot(3,1,2)
hold on; zoom on; grid on;
hp=plot(Parameters.CP_TSR.Winds,Parameters.CP_TSR.pitch,symb);
set (hp,'LineWidth',2);
hy=ylabel('\beta [deg]');set (hy,'FontSize',12,'FontWeight','bold');
axis([Parameters.minWindSpeed Parameters.maxWindSpeed -Inf Inf]);
subplot(3,1,3)
hold on; zoom on; grid on;
hp=plot(Parameters.CP_TSR.Winds,Parameters.CP_TSR.Torque/1000,symb);
set (hp,'LineWidth',2);
hy=ylabel('Torque [kNm]');set (hy,'FontSize',12,'FontWeight','bold');
axis([Parameters.minWindSpeed Parameters.maxWindSpeed -Inf Inf]);
hx=xlabel('Wind [m/s]'); set (hx,'FontSize',12,'FontWeight','bold');

%% FIGURES
figure(110);  set(gcf, 'Name','PitchTorqueOmegaZOOM VS Wind', 'NumberTitle','off')
hold on; zoom on; grid on;
hp=plot(Parameters.CP_TSR.Winds,Parameters.CP_TSR.pitch,symb);
set (hp,'LineWidth',2);
hy=ylabel('\beta [deg]');set (hy,'FontSize',12,'FontWeight','bold');
axis([7 15 -5 10]);
hx=xlabel('Wind [m/s]'); set (hx,'FontSize',12,'FontWeight','bold');

%% FIGURES
figure(1000);  set(gcf, 'Name','TorquePower VS Wind', 'NumberTitle','off')
subplot(2,1,1)
hold on; zoom on; grid on;
hp=plot(Parameters.CP_TSR.Winds,Parameters.CP_TSR.Torque/1000,symb);
set (hp,'LineWidth',2);
hy=ylabel('Torque [kNm]');set (hy,'FontSize',12,'FontWeight','bold');
axis([3 25 -Inf Inf]);
subplot(2,1,2)
hold on; zoom on; grid on;
hp=plot(Parameters.CP_TSR.Winds,Parameters.CP_TSR.Omega.*Parameters.CP_TSR.Torque/1000,symb);
set (hp,'LineWidth',2);
hy=ylabel('EPower [kW]');set (hy,'FontSize',12,'FontWeight','bold');
hx=xlabel('Wind [m/s]'); set (hx,'FontSize',12,'FontWeight','bold');
axis([Parameters.minWindSpeed Parameters.maxWindSpeed -Inf Inf]);

%% FIGURES
figure(10000);  set(gcf, 'Name','Power VS Wind', 'NumberTitle','off')
hold on; zoom on; grid on;
hp=plot(Parameters.CP_TSR.Winds,Parameters.CP_TSR.Omega.*Parameters.CP_TSR.Torque/1000,symb);
set (hp,'LineWidth',2);
hy=ylabel('Nominal Power [kW]');set (hy,'FontSize',12,'FontWeight','bold');
hx=xlabel('Wind [m/s]'); set (hx,'FontSize',12,'FontWeight','bold');
axis([Parameters.minWindSpeed Parameters.maxWindSpeed 0 1.1*Parameters.CP_TSR.Omega(end).*Parameters.CP_TSR.Torque(end)/1000]);

%% FIGURES
figure(100001);  set(gcf, 'Name','PowerCoeff VS Wind', 'NumberTitle','off')
hold on; zoom on; grid on;
hp=plot(Parameters.CP_TSR.Winds,Parameters.CP_TSR.Cpmax,symb);
set (hp,'LineWidth',2);
hy=ylabel('Power Coefficient [-]');set (hy,'FontSize',12,'FontWeight','bold');
hx=xlabel('Wind [m/s]'); set (hx,'FontSize',12,'FontWeight','bold');
axis([Parameters.minWindSpeed Parameters.maxWindSpeed 0 0.5]);

figure(101);  set(gcf, 'Name','Cp VS TSR', 'NumberTitle','off')
hold on; zoom on; grid on;
hp=plot(LookUp.TSR,LookUp.Cp);
set (hp,'LineWidth',2);
hx=xlabel('\lambda'); hy=ylabel('C_{P}');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
% legend(num2str(LookUp.Pitch'));
axis([-Inf Inf 0 0.6]);

figure(102);  set(gcf, 'Name','Te VS Omega', 'NumberTitle','off')
hold on; zoom on; grid on;
hp=plot(Parameters.CP_TSR.Omega*30/pi,Parameters.CP_TSR.Torque/1000,symb);
set (hp,'LineWidth',2);
hx=xlabel('\Omega [rpm]'); hy=ylabel('Generator Torque [kNm]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');


