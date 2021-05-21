function IEC_gusts_data = IEC_wind(wind_data,dat_file_name);
%function IEC_gusts_data = iec_wind (WTG_class,WTG_category,V_hub,z_hub,rotor_diameter,EWS_flag,time_before_gust,time_after_gust,time_nwp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IEC WIND GUSTS CALCULATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------------------------------------------------------------------------------------
%  This function evaluates the IEC standard gusts as defined in IEC 61400-1 PART 1-safety requirements.
%  IT IS IMPORTANT TO REMEMBER THAT THIS FUNCTION ALSO PRINT THE OPPORTUNE .DAT FILES FOR EACH IEC GUSTS
%  IN A FORMAT READABLE BY THE MULTIBODY SOFTWARE.
%
%  Sintax:
%      -iec_wind(WTG_class,WTG_category,V_hub,z_hub,rotor_diameter,EWS_flag);
%
%  Input:
%      - WTG_class = number (1:5) which define the wind turbine generator IEC "class" ;
%      - WTG_category = 'A','B', 'C', 'S' character which define the wind turbine generator IEC turbulence"category" ;
%      - IECEdition     flag containing the IEC Edition
%      - V_hub = number which define the hub heigth wind velocity as required in IEC Table 2-design load cases;
%      - z_hub = huib height from ground [m];
%      - rotor_diameter = WTG rotor diameter [m];
%      - EWS_flag = 'Y' or 'N', define if the extreme wind shear model should be computed.
%                   If not expressed required, is strongly suggested to not calculate.
%      -time_before_gust = it is a number which define the time[s] before the gust when the wind speed
%                          is constat to the V_hub value;
%      -time_after_gust  = it is a number which define the time[s] after the gust when the wind speed is
%                          constant to the final value of the gusts.
%      -time_nwp         = it is a number which define the NWP duration time.
%
%
%  Output:
%      REMARK= these values are useful only for the SIMULINK controller design tool!!!!!!
%      - IEC_gusts_data = it is a Matlab data structure whose fields are:
%
%         'time_EOG_1'  = it is a row vector which define time[s] at which istantaneous wind speed
%                         is evaluated during Extreme Operative Gust with 1 year of recourrence period;
%         'Wind_EOG_1'  = it is a row vector which define the istantaneous EOG wind speed[m/s];
%         'time_EOG_50' = it is a row vector which define time[s] at which istantaneous wind speed
%                         is evaluated during Extreme Operative Gust with 50 year of recourrence period;
%         'Wind_EOG_50' = it is a row vector which define the istantaneous EOG wind speed[m/s];
%         'time_ECG'    = it is a row vector which define time[s] at which istantaneous wind speed
%                         is evaluated during Extreme Coherenr Gust;
%         'Wind_ECG'    = it is a row vector which define the istantaneous ECG wind speed[m/s];
%         'time_EDC'    = it is a row vector which define time[s] at which istantaneous wind direction
%                         is evaluated during Extreme Direction Change (equal for 1 year and 50 years
%                         recourrence period);
%         'Wind_direction_EDC_1' = it is a row vector which define the istantaneous EDC wind direction[rad]
%                                  for 1 year recourrence period case;
%         'Wind_direction_EDC_50'= it is a row vector which define the istantaneous EDC wind direction[rad]
%                                  for 50 years recourrence period case;
%         'time_ECD'  = it is a row vector which define time[s] at which istantaneous wind direction
%                       is evaluated during Extreme coherent gust and Direction change;
%         'Wind_direction_ECD' = it is a row vector which define the istantaneous ECD wind direction[rad];
%         'time_EWS_vertical'  = it is a row vector which define time[s] at which istantaneous wind speed
%                                is evaluated during Extreme Wind Shear for transient vertical shear;
%         'Wind_direction_EWS_vertical' = it is a row vector which define the istantaneous vertical EWS wind speed[m/s];
%         'time_EWS_horizontal' = it is a row vector which define time[s] at which istantaneous wind speed
%                                 is evaluated during Extreme Wind Shear for transient horizontal shear;
%         'Wind_direction_EWS_horizontal' = it is a row vector which define the istantaneous horizontal EWS wind speed[m/s];
%
%--------------------------------------------------------------------------------------------------------------



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Users defined data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
grid_size=[wind_data.grid_resolution wind_data.grid_resolution];
d=wind_data.grid_size;
grid_resolution=d/((grid_size(2)-1));
time_step=wind_data.sample_time;

V_hub = wind_data.v_hub;
z_hub = wind_data.hub_height;
time_before_gust = wind_data.t_before ;
time_after_gust = wind_data.t_after;
time_nwp = time_before_gust+time_after_gust;
V = V_hub;
wind_sample_time = time_step;
D = wind_data.rotor_diameter;
z = [(z_hub-d/2):grid_resolution:(z_hub+d/2)];
z_size = length(z);
WTG_category = wind_data.category;
WTG_class = wind_data.class;

IECEdition = wind_data.IECEdition;

if d < D 
  fprintf('\n *** WARNING!! Grid size (%g m) < Turbine diameter (%g m)', d, D);
end
if z_hub < D/2
   fprintf('\n *** WARNING!! Hub height (%g m) < Rotor radius (%g m)', z_hub, D/2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Data from IEC Table 1- Basic parameters for WTGs classes

if IECEdition==6140013
    fprintf('\n *** Computing wind time histories based on IEC61400-1 Ed.3 *** \n');
    % WTG Class    I      II   III   IV (Special)
    V_ref_class = [50    42.5  37.5  35.0 ]; % Table1 
    V_ave_class = 0.2*V_ref_class;           % eq. 9
    % Turb. Cat:    A     B     C     S(pecial)
    I_15_class  = [0.16  0.14  0.12  0.21 ]; % Is I_ref
    alfa=0.2;                                % eq. 10
    
    switch upper(strtrim(WTG_category))
        case 'A';  WTG_cat = 1;
        case 'B';  WTG_cat = 2;
        case 'C';  WTG_cat = 3;
        case 'S'
            fprintf('\n *** WARNING!! WTG_category [%s] Special \n ***           Check carefully source code for V_ref, I_ref \n',WTG_category);
            WTG_cat = 4;
        otherwise
            fprintf('\n *** WARNING!! WTG_category [%s] unknown!! \n ***           Assuming category A\n',WTG_category);
            WTG_cat = 1;
    end
    
    V_ref = V_ref_class(1,WTG_class);
    V_ave = V_ave_class(1,WTG_class);
    I_15  = I_15_class(1,WTG_cat);

elseif IECEdition==6140012
    fprintf('\n *** Computing wind time histories based on IEC61400-1 Ed.2 *** \n');
    V_ref_class = [50 42.5 37.5 30 0 ];     % Table1
    V_ave_class = [10  8.5  7.5  6 0 ];     % Table1
    I_15_class  = [0.18 0.18 0.18 0.18 0;
                   0.16 0.16 0.16 0.16 0];  % Table1
    a_class     = [ 2 2 2 2 0;
                    3 3 3 3 0];             % Table1

    alfa=0.2;                               % eq. 6

    if WTG_category == 'A' | WTG_category == 'a',
        WTG_cat = 1;
    elseif WTG_category == 'B' | WTG_category == 'b',
        WTG_cat = 2;
    else
        fprintf('\n *** WTG_category [%s] unknown!! \n *** Assuming class A\n',WTG_category);
        WTG_cat = 1;
    end

    V_ref = V_ref_class(1,WTG_class);
    V_ave = V_ave_class(1,WTG_class);
    I_15  = I_15_class(WTG_cat,WTG_class);
    a     = a_class(WTG_cat,WTG_class);

elseif IECEdition==6140022
    fprintf('\n *** Computing wind time histories based on IEC61400-2 Ed.2 *** \n');
    V_ref_class = [50 42.5 37.5 30 0 ];     % Table1
    V_ave_class = [10  8.5  7.5  6 0 ];     % Table1
    I_15_class  = [0.18 0.18 0.18 0.18 0];  % Table1
    a_class     = [ 2 2 2 2 0];             % Table1

    alfa=0.2;

    if WTG_category == 'A' | WTG_category == 'a',
        WTG_cat = 1;
    else
        fprintf('\n *** WTG_category is not defined for IEC61400-2!!\n');
        WTG_cat = 1;
    end

    V_ref = V_ref_class(1,WTG_class);
    V_ave = V_ave_class(1,WTG_class);
    I_15  = I_15_class(WTG_cat,WTG_class);
    a     = a_class(WTG_cat,WTG_class);

else

    fprintf('\n *** IEC Edition [%g] not defined!!\n',IECEdition);
    IEC_gusts_data = [];
    return

end

disp(['Class= ',num2str(WTG_class)])
disp(['Categ= ',WTG_category])
disp(['V_ref= ',num2str(V_ref), ' m/s'])
disp(['V_ave= ',num2str(V_ave), ' m/s'])
disp(['I_15= ',num2str(I_15*100),' %'])
disp(['V_hub= ',num2str(V_hub), ' m/s'])

% Function outputs inizializations

IEC_gusts_data = struct ('time_EOG_1',[],...
    'Wind_EOG_1',[],...
    'time_EOG_50',[],...
    'Wind_EOG_50',[],...
    'time_ECG',[],...
    'Wind_ECG',[],...
    'time_EDC',[],...
    'Wind_direction_EDC_1',[],...
    'Wind_direction_EDC_50',[],...
    'time_ECD',[],...
    'Wind_direction_ECD',[],...
    'time_EWS_vertical',[],...
    'Wind_direction_EWS_vertical',[],...
    'time_EWS_horizontal',[],...
    'Wind_direction_EWS_horizontal',[]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REMARK: medium wind speed and hub wind speed are quite similar but not
%         equal, temporary, medium wind speed are used for controller
%         desing tool requirements.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normal wind profile model (NWP)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
V_NWP=V_hub*[(z/z_hub).^alfa];

if upper(wind_data.NWP(end)) == 'S'

    % Following function prints the .dat file for the normal wind profile model
    NWP_grid_generation(z_hub,time_step,d,grid_size,grid_resolution,V_hub,V_NWP,time_nwp,dat_file_name);

    std_graph( 1 , 'Normal Wind Profile Model [NWP]' , 'Height from ground [m]' , 'Wind Speed [m/s]' , V_NWP , z , '-+r' , 2 );
    set(1, 'Name','NWP','NumberTitle','off')

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normal Turbolence Model (NTM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if IECEdition==6140013
    b = 5.6;                                % eq. 11
    sigma_1 = I_15 * (0.75*V_hub+b);
elseif IECEdition==6140012
    sigma_1 = I_15 * (15+a*V_hub) / (a+1);  % eq.7
elseif IECEdition==6140022
    sigma_1 = I_15 * (15+a*V_hub) / (a+1);  % eq.7
end

% %%%%%%%%%S1; % until now not used!!
if IECEdition==6140013
    if z_hub < 60,
        lambda_1 = 0.7 * z_hub;     % eq.5
    else
        lambda_1 = 42;
    end
elseif IECEdition==6140012
    if z_hub < 30,
        lambda_1 = 0.7 * z_hub;     % eq.9
    else
        lambda_1 = 21;
    end
elseif IECEdition==6140022
    if z_hub < 30,
        lambda_1 = 0.7 * z_hub;     % eq.9
    else
        lambda_1 = 21;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extreme Wind Speed Model (EWM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

V_e50 = 1.4 * V_ref * (z/z_hub).^0.11;

if IECEdition==6140013
    V_e1  = 0.80 * V_e50;
elseif IECEdition==6140012
    V_e1  = 0.75 * V_e50;
elseif IECEdition==6140022
    V_e1  = 0.75 * V_e50;
end

std_graph( 2 , 'Extreme Wind Speed Model [EWM]' , 'Height from ground [m]' , 'Wind Speed [m/s]' , V_e50 , z , '-r+' , 2 );
std_graph( 2 , 'Extreme Wind Speed Model [EWM]' , 'Height from ground [m]' , 'Wind Speed [m/s]' , V_e1 , z , '-b+' , 2 );
legend('V_e50','V_e1');
set(2, 'Name','EWM','NumberTitle','off')

V_e1_hub  =  spline(z,V_e1,z_hub);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REMARK: medium wind speed and hub wind speed are quite similar but not
%         equal, temporary, medium wind speed are used for controller
%         desing tool requirements.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extreme Operating Gust (EOG)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if upper(wind_data.EOG1(end)) == 'S'

    if IECEdition==6140013
        V_gust1  = min(1.35*(V_e1_hub-V_hub),3.3*(sigma_1/(1+0.1*(D/lambda_1))) );
    elseif IECEdition==6140012
        V_gust1  = 4.8*(sigma_1/(1+0.1*(D/lambda_1)));
    elseif IECEdition==6140022
        V_gust1  = 4.8*(sigma_1/(1+0.1*(D/lambda_1)));
    end
    T_1 = 10.5;

    % Time vector. Wind in sampled a T=wind_sample_time second
    t_1=[0.0:wind_sample_time:T_1];

    IEC_gusts_data.time_EOG_1= [[0:wind_sample_time:(time_before_gust-wind_sample_time)],(t_1+time_before_gust),[(t_1(end)+time_before_gust+wind_sample_time):wind_sample_time:(t_1(end)+time_before_gust+wind_sample_time)+time_after_gust-wind_sample_time]];
    n_1=max(size(t_1));

    % ONE YEAR RECOURRENCE -----------------------------------
    for ii=1:1:max(size(V_NWP));

        for i=1:1:n_1;

            V_EOG_1year(ii,i)  = V_NWP(ii) - [ 0.37 * V_gust1 * sin(3*pi*t_1(i)/T_1) * (1-cos(2*pi*t_1(i)/T_1)) ];

            V_EOG_1year_HUB(i) = V         - [ 0.37 * V_gust1 * sin(3*pi*t_1(i)/T_1) * (1-cos(2*pi*t_1(i)/T_1)) ];

            medium_V_EOG_1year(i) = [sum(V_EOG_1year(:,i))/z_size];

        end

    end

    % Struct field allocations -------------------------------------
    cont=1;
    IEC_gusts_data.Wind_EOG_1(1:((time_before_gust/wind_sample_time)-1)) = medium_V_EOG_1year(1);
    for i=(time_before_gust/wind_sample_time):1:(T_1/wind_sample_time)+(time_before_gust/wind_sample_time),
        IEC_gusts_data.Wind_EOG_1(i)=medium_V_EOG_1year(cont);
        cont=cont+1;
    end
    IEC_gusts_data.Wind_EOG_1(((t_1(end)+time_before_gust+wind_sample_time)/wind_sample_time:((T_1/wind_sample_time)+(time_before_gust/wind_sample_time)+(time_after_gust/wind_sample_time)+1))) = medium_V_EOG_1year(end);
    %------------------------------------------------------------
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  EOG (1 year recourrence) wind grid generations and prints  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    wind_grid_print(T_1,'EOG_1_year.u',grid_size,grid_resolution,time_step,z_hub,V_hub,d,V_EOG_1year_HUB,V_EOG_1year,time_before_gust,time_after_gust,dat_file_name);
    wind_grid_print(T_1,'EOG_1_year.v',grid_size,grid_resolution,time_step,z_hub,V_hub,d,V_EOG_1year_HUB*0,V_EOG_1year*0,time_before_gust,time_after_gust,dat_file_name);
    wind_grid_print(T_1,'EOG_1_year.w',grid_size,grid_resolution,time_step,z_hub,V_hub,d,V_EOG_1year_HUB*0,V_EOG_1year*0,time_before_gust,time_after_gust,dat_file_name);

    std_graph( 3 , 'Extreme Operating Gust 1 (EOG)' , 'Longitudinal Wind Speed [m/s]' , 'Time [s]' , [0,t_1+time_before_gust,t_1(end)+time_after_gust+time_before_gust] , [V_EOG_1year(end,1),V_EOG_1year(end,:),V_EOG_1year(end,end)] , '-b' , 2 );
    std_graph( 3 , 'Extreme Operating Gust 1 (EOG)' , 'Longitudinal Wind Speed [m/s]' , 'Time [s]' , [0,t_1+time_before_gust,t_1(end)+time_after_gust+time_before_gust] , [V_EOG_1year((fix(end/2)),1),V_EOG_1year((fix(end/2)),:),V_EOG_1year((fix(end/2)),end)] , '-g' , 2 );
    std_graph( 3 , 'Extreme Operating Gust 1 (EOG)' , 'Longitudinal Wind Speed [m/s]' , 'Time [s]' , [0,t_1+time_before_gust,t_1(end)+time_after_gust+time_before_gust] , [V_EOG_1year(1,1),V_EOG_1year(1,:),V_EOG_1year(1,end)] , '-r' , 2 );
    legend('Z TOP','Z MIDDLE','Z LOW');
    set(3, 'Name','EOG1','NumberTitle','off')
    
    disp(['V_gust1 = ',num2str(V_gust1), ' m/s']) 
    disp(['V_gust(MAX,hub) = ',num2str(max(V_EOG_1year_HUB)), ' m/s']) 
    disp(['V_gust(MIN,hub) = ',num2str(min(V_EOG_1year_HUB)), ' m/s']) 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIFTY YEARS RECOURRENCE -----------------------------------
if upper(wind_data.EOG50(end)) == 'S'

    if IECEdition==6140013
        V_gust50  = 0;
        fprintf('\n *** WARNING!! EOG50 is no longer defined for IEC 61400-1 Ed.3');
        fprintf('\n ***           Use only EOG1 (i.e. EOG)\n');
    elseif IECEdition==6140012
        V_gust50  = 6.4*(sigma_1/(1+0.1*(D/lambda_1)));
    elseif IECEdition==6140022
        V_gust50  = 6.4*(sigma_1/(1+0.1*(D/lambda_1)));
    end
    T_50 = 14;

    % Time vector. Wind in sampled a T=wind_sample_time second
    t_50=[0.0:wind_sample_time:T_50];

    IEC_gusts_data.time_EOG_50=[[0:wind_sample_time:(time_before_gust-wind_sample_time)],(t_50+time_before_gust),[(t_50(end)+time_before_gust+wind_sample_time):wind_sample_time:(t_50(end)+time_before_gust+wind_sample_time)+time_after_gust-wind_sample_time]];

    n_50=max(size(t_50));

    for ii=1:1:max(size(V_NWP));

        for i=1:1:n_50;

            V_EOG_50years(ii,i) = V_NWP(ii) - 0.37 * V_gust50 * sin(3*pi*t_50(i)/T_50)*(1-cos(2*pi*t_50(i)/T_50));

            V_EOG_50years_HUB(i) = V - 0.37 * V_gust50 * sin(3*pi*t_50(i)/T_50)*(1-cos(2*pi*t_50(i)/T_50));

            medium_V_EOG_50years(i)=[sum(V_EOG_50years(:,i))/z_size];

        end

    end

    % Struct field allocations
    cont=1;
    IEC_gusts_data.Wind_EOG_50(1:((time_before_gust/wind_sample_time)-1))=medium_V_EOG_50years(1);
    for i=(time_before_gust/wind_sample_time):1:(T_50/wind_sample_time)+(time_before_gust/wind_sample_time),
        IEC_gusts_data.Wind_EOG_50(i)=medium_V_EOG_50years(cont);
        cont=cont+1;
    end
    % CHECK !!!!!!!!!!
    IEC_gusts_data.Wind_EOG_50(((t_50(end)+time_before_gust+wind_sample_time)/wind_sample_time:((T_50/wind_sample_time)+(time_before_gust/wind_sample_time)+(time_after_gust/wind_sample_time)+1))) = medium_V_EOG_50years(end);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  EOG (50 years recourrence) wind grid definition and print %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    wind_grid_print(T_50,'EOG_50_years.u',grid_size,grid_resolution,time_step,z_hub,V_hub,d,V_EOG_50years_HUB,V_EOG_50years,time_before_gust,time_after_gust,dat_file_name);
    wind_grid_print(T_50,'EOG_50_years.v',grid_size,grid_resolution,time_step,z_hub,V_hub,d,V_EOG_50years_HUB*0,V_EOG_50years*0,time_before_gust,time_after_gust,dat_file_name);
    wind_grid_print(T_50,'EOG_50_years.w',grid_size,grid_resolution,time_step,z_hub,V_hub,d,V_EOG_50years_HUB*0,V_EOG_50years*0,time_before_gust,time_after_gust,dat_file_name);

    std_graph( 4 , 'Extreme Operating Gust 50 (EOG)' , 'Longitudinal Wind Speed [m/s]' , 'Time [s]' , [0,t_50+time_before_gust,t_50(end)+time_after_gust+time_before_gust] , [V_EOG_50years(end,1),V_EOG_50years(end,:),V_EOG_50years(end,end)] , '-b' , 2 );
    std_graph( 4 , 'Extreme Operating Gust 50 (EOG)' , 'Longitudinal Wind Speed [m/s]' , 'Time [s]' , [0,t_50+time_before_gust,t_50(end)+time_after_gust+time_before_gust] , [V_EOG_50years((fix(end/2)),1),V_EOG_50years((fix(end/2)),:),V_EOG_50years((fix(end/2)),end)] , '-g' , 2 );
    std_graph( 4 , 'Extreme Operating Gust 50 (EOG)' , 'Longitudinal Wind Speed [m/s]' , 'Time [s]' , [0,t_50+time_before_gust,t_50(end)+time_after_gust+time_before_gust] , [V_EOG_50years(1,1),V_EOG_50years(1,:),V_EOG_50years(1,end)] , '-r' , 2 );
    legend('Z TOP','Z MIDDLE','Z LOW');
    set(4, 'Name','EOG50','NumberTitle','off')

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXTREME DIRECTION CHANGE (EDC)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1 year recourrence period
if upper(wind_data.EDC1(end)) == 'S'
 
    if IECEdition==6140013
        teta_e1  =  4.0 * atan( sigma_1 / ( V_hub * ( 1 + 0.1 *(D/lambda_1) ) ) );
    elseif IECEdition==6140012
        teta_e1  =  4.8 * atan( sigma_1 / ( V_hub * ( 1 + 0.1 *(D/lambda_1) ) ) );
    elseif IECEdition==6140022
        teta_e1  =  4.8 * atan( sigma_1 / ( V_hub * ( 1 + 0.1 *(D/lambda_1) ) ) );
    end
    T_EDC = 6;

    t = time_before_gust;

    cont=1;

    for i = 0:wind_sample_time:(t-wind_sample_time);

        IEC_gusts_data.Wind_direction_EDC_1(cont)  = 0;

        IEC_gusts_data.time_EDC(cont) = i;

        cont = cont + 1;

    end

    for i = t:wind_sample_time:(T_EDC+t);

        IEC_gusts_data.Wind_direction_EDC_1(cont)  = 0.5 * teta_e1 * (1-cos((pi*(i-t))/T_EDC));

        IEC_gusts_data.time_EDC(cont) = i;

        cont = cont + 1;

    end

    final_value_1 = IEC_gusts_data.Wind_direction_EDC_1(end);

    for i = (T_EDC+t+wind_sample_time):wind_sample_time:(T_EDC+t+time_after_gust);

        IEC_gusts_data.Wind_direction_EDC_1(cont)  = final_value_1;

        IEC_gusts_data.time_EDC(cont) = i;

        cont = cont + 1;

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  EDC (1 year recourrence)   %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for z=1:1:grid_size(1),

        EDC1_U_grid(z,:) = V_NWP(z) * cos( IEC_gusts_data.Wind_direction_EDC_1 );
        EDC1_U_hub       = V_hub    * cos( IEC_gusts_data.Wind_direction_EDC_1 );

        EDC1_V_grid(z,:) = V_NWP(z) * sin( IEC_gusts_data.Wind_direction_EDC_1 );
        EDC1_V_hub       = V_hub    * sin( IEC_gusts_data.Wind_direction_EDC_1 );

    end

    %%% ALEALE 07.oct.2008 added two more files for .v and .w
    wind_grid_print(IEC_gusts_data.time_EDC(end),'EDC_1_plus.u',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EDC1_U_hub,EDC1_U_grid,0,0,dat_file_name);
    wind_grid_print(IEC_gusts_data.time_EDC(end),'EDC_1_plus.v',grid_size,grid_resolution,time_step,z_hub,V_hub,d,-EDC1_V_hub,-EDC1_V_grid,0,0,dat_file_name);
    wind_grid_print(IEC_gusts_data.time_EDC(end),'EDC_1_plus.w',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EDC1_V_hub*0,EDC1_V_grid*0,0,0,dat_file_name);
    wind_grid_print(IEC_gusts_data.time_EDC(end),'EDC_1_minus.u',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EDC1_U_hub,EDC1_U_grid,0,0,dat_file_name);
    wind_grid_print(IEC_gusts_data.time_EDC(end),'EDC_1_minus.v',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EDC1_V_hub,EDC1_V_grid,0,0,dat_file_name);
    wind_grid_print(IEC_gusts_data.time_EDC(end),'EDC_1_minus.w',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EDC1_V_hub*0,EDC1_V_grid*0,0,0,dat_file_name);

    std_graph_sub( 5 , [3 1 1] , 'Extreme Direction Change 1 U component(EDC)' , 'Wind Speed [m/s]' , 'Time [s]' , IEC_gusts_data.time_EDC , EDC1_U_grid(end,:) , '-r', 2 );
    std_graph_sub( 5 , [3 1 1] , 'Extreme Direction Change 1 U component(EDC)' , 'Wind Speed [m/s]' , 'Time [s]' , IEC_gusts_data.time_EDC , EDC1_U_grid((fix(end/2)),:) , '-g', 2 );
    std_graph_sub( 5 , [3 1 1] , 'Extreme Direction Change 1 U component(EDC)' , 'Wind Speed [m/s]' , 'Time [s]' , IEC_gusts_data.time_EDC , EDC1_U_grid(1,:) , '-b', 2 );
    legend('Z TOP','Z MIDDLE','Z LOW');

    std_graph_sub( 5 , [3 1 2] , 'Extreme Direction Change 1 V component(EDC)' , 'Wind Speed [m/s]' , 'Time [s]' , IEC_gusts_data.time_EDC , EDC1_V_grid(end,:) , '-r', 2 );
    std_graph_sub( 5 , [3 1 2] , 'Extreme Direction Change 1 V component(EDC)' , 'Wind Speed [m/s]' , 'Time [s]' , IEC_gusts_data.time_EDC , EDC1_V_grid((fix(end/2)),:) , '-g', 2 );
    std_graph_sub( 5 , [3 1 2] , 'Extreme Direction Change 1 V component(EDC)' , 'Wind Speed [m/s]' , 'Time [s]' , IEC_gusts_data.time_EDC , EDC1_V_grid(1,:) , '-b', 2 );
    legend('Z TOP','Z MIDDLE','Z LOW');
    
    std_graph_sub( 5 , [3 1 3] , 'Extreme Direction Change 1 direction(EDC)' , 'Direction [deg]' , 'Time [s]' , IEC_gusts_data.time_EDC , IEC_gusts_data.Wind_direction_EDC_1*180/pi , '-r', 2 );
    
    set(5, 'Name','EDC1','NumberTitle','off')
    disp(['teta_e1 = ',num2str(teta_e1*180/pi), ' deg']) 
end


if upper(wind_data.EDC50(end)) == 'S'
    
    % 50 years recourrence period

    if IECEdition==6140013
        teta_e50  = 0;
        fprintf('\n *** WARNING!! EDC50 is no longer defined for IEC 61400-1 Ed.3');
        fprintf('\n ***           Use only EDC1 (i.e. EDC)\n');
    elseif IECEdition==6140012
        teta_e50  =  6.4 * atan( sigma_1 / ( V_hub * ( 1 + 0.1 *(D/lambda_1) ) ) );
    elseif IECEdition==6140022
        teta_e50  =  6.4 * atan( sigma_1 / ( V_hub * ( 1 + 0.1 *(D/lambda_1) ) ) );
    end

    t = time_before_gust;
    cont = 1;

    for i = 0:wind_sample_time:(t-wind_sample_time);

        IEC_gusts_data.Wind_direction_EDC_50(cont) = 0;

        IEC_gusts_data.time_EDC(cont) = i;

        cont = cont + 1;

    end

    for i = t:wind_sample_time:(6+t);

        IEC_gusts_data.Wind_direction_EDC_50(cont)  = 0.5 * teta_e50 * (1-cos((pi*(i-t))/6));

        IEC_gusts_data.time_EDC(cont) = i;

        cont = cont + 1;

    end


    final_value_50 = IEC_gusts_data.Wind_direction_EDC_50(end);

    for i = (6+t+wind_sample_time):wind_sample_time:(6+t+time_after_gust);

        IEC_gusts_data.Wind_direction_EDC_50(cont)  = final_value_50;

        IEC_gusts_data.time_EDC(cont) = i;

        cont = cont + 1;

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  EDC (50 year recourrence)  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for z=1:1:grid_size(1),

        EDC50_U_grid(z,:) = V_NWP(z) * cos( IEC_gusts_data.Wind_direction_EDC_50 );
        EDC50_U_hub       = V_hub    * cos( IEC_gusts_data.Wind_direction_EDC_50 );

        EDC50_V_grid(z,:) = V_NWP(z) * sin( IEC_gusts_data.Wind_direction_EDC_50 );
        EDC50_V_hub       = V_hub    * sin( IEC_gusts_data.Wind_direction_EDC_50 );

    end

    wind_grid_print(IEC_gusts_data.time_EDC(end),'EDC_50_plus.u',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EDC50_U_hub,EDC50_U_grid,0,0,dat_file_name);
    wind_grid_print(IEC_gusts_data.time_EDC(end),'EDC_50_plus.v',grid_size,grid_resolution,time_step,z_hub,V_hub,d,-EDC50_V_hub,-EDC50_V_grid,0,0,dat_file_name);
    wind_grid_print(IEC_gusts_data.time_EDC(end),'EDC_50_plus.w',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EDC50_V_hub*0,EDC50_V_grid*0,0,0,dat_file_name);
    wind_grid_print(IEC_gusts_data.time_EDC(end),'EDC_50_minus.u',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EDC50_U_hub,EDC50_U_grid,0,0,dat_file_name);
    wind_grid_print(IEC_gusts_data.time_EDC(end),'EDC_50_minus.v',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EDC50_V_hub,EDC50_V_grid,0,0,dat_file_name);
    wind_grid_print(IEC_gusts_data.time_EDC(end),'EDC_50_minus.w',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EDC50_V_hub*0,EDC50_V_grid*0,0,0,dat_file_name);

    std_graph_sub( 6 , [3 1 1] , 'Extreme Direction Change 50 U component(EDC)' , 'Wind Speed [m/s]' , 'Time [s]' , IEC_gusts_data.time_EDC , EDC50_U_grid(end,:) , '-r', 2 );
    std_graph_sub( 6 , [3 1 1] , 'Extreme Direction Change 50 U component(EDC)' , 'Wind Speed [m/s]' , 'Time [s]' , IEC_gusts_data.time_EDC , EDC50_U_grid((fix(end/2)),:) , '-g', 2 );
    std_graph_sub( 6 , [3 1 1] , 'Extreme Direction Change 50 U component(EDC)' , 'Wind Speed [m/s]' , 'Time [s]' , IEC_gusts_data.time_EDC , EDC50_U_grid(1,:) , '-b', 2 );
    legend('Z TOP','Z MIDDLE','Z LOW');

    std_graph_sub( 6 , [3 1 2] , 'Extreme Direction Change 50 V component(EDC)' , 'Wind Speed [m/s]' , 'Time [s]' , IEC_gusts_data.time_EDC , EDC50_V_grid(end,:) , '-r', 2 );
    std_graph_sub( 6 , [3 1 2] , 'Extreme Direction Change 50 V component(EDC)' , 'Wind Speed [m/s]' , 'Time [s]' , IEC_gusts_data.time_EDC , EDC50_V_grid((fix(end/2)),:) , '-g', 2 );
    std_graph_sub( 6 , [3 1 2] , 'Extreme Direction Change 50 V component(EDC)' , 'Wind Speed [m/s]' , 'Time [s]' , IEC_gusts_data.time_EDC , EDC50_V_grid(1,:) , '-b', 2 );
    legend('Z TOP','Z MIDDLE','Z LOW');
    
    std_graph_sub( 6 , [3 1 3] , 'Extreme Direction Change 50 direction(EDC)' , 'Direction [deg]' , 'Time [s]' , IEC_gusts_data.time_EDC , IEC_gusts_data.Wind_direction_EDC_50*180/pi , '-r', 2 );
    
    set(6, 'Name','EDC50','NumberTitle','off') 
    disp(['teta_e50 = ',num2str(teta_e50*180/pi), ' deg']) 
    
end


IEC_gusts_data=iec_wind_auxiliary(IEC_gusts_data,wind_data,V_NWP,sigma_1,lambda_1,dat_file_name);
