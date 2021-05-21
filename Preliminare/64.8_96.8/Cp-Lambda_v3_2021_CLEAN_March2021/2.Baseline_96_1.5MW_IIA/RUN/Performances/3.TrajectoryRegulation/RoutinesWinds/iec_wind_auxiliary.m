function IEC_gusts_data=iec_wind_auxiliary(IEC_gusts_data,wind_data,V_NWP,sigma_1,lambda_1,dat_file_name);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For the input and output of this function makes reference to the IEC_wind function.
% Infact, the IEC_wind function has been divided into two functions because
% of the matlab compiler is not able to compile a such long function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extreme coherent gust (ECG)                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if upper(wind_data.ECG(end)) == 'S' || upper(wind_data.ECD(end)) == 'S'
    
    if IECEdition==6140013
        V_cg=15;
        T_ecg=10;
        if upper(wind_data.ECG(end)) == 'S'
            fprintf('\n *** WARNING!! ECG is no longer defined for IEC 61400-1 Ed.3');
        end
    elseif IECEdition==6140012
        V_cg=15;
        T_ecg=10;
    elseif IECEdition==6140022
        V_cg=15;
        T_ecg=10;
    end

    t_ecg=[0:wind_sample_time:T_ecg];
    IEC_gusts_data.time_ECG=[[0:wind_sample_time:(time_before_gust-wind_sample_time)],[time_before_gust:wind_sample_time:(T_ecg+time_before_gust)],[[T_ecg+time_before_gust+wind_sample_time]:wind_sample_time:(T_ecg+time_before_gust+time_after_gust)]];
    
    for ii=1:1:max(size(V_NWP));
        
        for i=1:1:max(size(t_ecg));
            
            V_ECG(ii,i) = V_NWP(ii) + [0.5 * V_cg *(1-cos((pi*t_ecg(i))./T_ecg))];
            
            V_ECG_HUB(i) = V_hub + [0.5 * V_cg *(1-cos((pi*t_ecg(i))./T_ecg))];
            
            medium_V_ECG(i) = [sum(V_ECG(:,i))/z_size];
            
        end
        
    end
    
end

if  upper(wind_data.ECG(end)) == 'S'
    
    % REMARK: following data are useful only for the simulink tool!!!
    cont=1;
    IEC_gusts_data.Wind_ECG(1:1:((time_before_gust/wind_sample_time)))=medium_V_ECG(1);
    for i=((time_before_gust/wind_sample_time))+1:1:((T_ecg+time_before_gust)/wind_sample_time),
        IEC_gusts_data.Wind_ECG(i)=medium_V_ECG(cont);
        cont=cont+1;
    end
    IEC_gusts_data.Wind_ECG(((t_ecg(end)+time_before_gust)/wind_sample_time):1:(((T_ecg+time_after_gust+time_before_gust)/wind_sample_time))+1)=medium_V_ECG(end);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %             ECG             %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    wind_grid_print(T_ecg,'ECG.u',grid_size,grid_resolution,time_step,z_hub,V_hub,d,V_ECG_HUB,V_ECG,time_before_gust,time_after_gust,dat_file_name);
    wind_grid_print(T_ecg,'ECG.v',grid_size,grid_resolution,time_step,z_hub,V_hub,d,V_ECG_HUB*0,V_ECG*0,time_before_gust,time_after_gust,dat_file_name);
    wind_grid_print(T_ecg,'ECG.w',grid_size,grid_resolution,time_step,z_hub,V_hub,d,V_ECG_HUB*0,V_ECG*0,time_before_gust,time_after_gust,dat_file_name);
    
    std_graph( 7 , 'Extreme Coherent Gust (ECG)' , 'Longitudinal Wind Speed [m/s]' , 'Time [s]' , [0,t_ecg+time_before_gust,T_ecg+time_before_gust+time_after_gust] , [V_ECG(end,1),V_ECG(end,:),V_ECG(end,end)] , '-b' , 2 );
    std_graph( 7 , 'Extreme Coherent Gust (ECG)' , 'Longitudinal Wind Speed [m/s]' , 'Time [s]' , [0,t_ecg+time_before_gust,T_ecg+time_before_gust+time_after_gust]  , [V_ECG((fix(end/2)),1),V_ECG((fix(end/2)),:),V_ECG((fix(end/2)),end)] , '-g' , 2 );
    std_graph( 7 , 'Extreme Coherent Gust (ECG)' , 'Longitudinal Wind Speed [m/s]' , 'Time [s]' , [0,t_ecg+time_before_gust,T_ecg+time_before_gust+time_after_gust]  , [V_ECG(1,1),V_ECG(1,:),V_ECG(1,end)] , '-r' , 2 );
    legend('Z TOP','Z MIDDLE','Z LOW');
    
    set(7, 'Name','ECG','NumberTitle','off')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extreme Coherent Gust with direction change (ECD)) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if upper(wind_data.ECD(end)) == 'S'
    
    if IECEdition==6140013
        if V_hub < 4;
            teta_cg = 180*(pi/180);
        else
            teta_cg = (720/V_hub)*(pi/180);
        end
        T_edc=10;
    elseif IECEdition==6140012
        if V_hub < 4;
            teta_cg = 180*(pi/180);
        else
            teta_cg = (720/V_hub)*(pi/180);
        end
        T_edc=10;
    elseif IECEdition==6140022
        if V_hub < 4;
            teta_cg = 180*(pi/180);
        else
            teta_cg = (720/V_hub)*(pi/180);
        end
        T_edc=10;
    end

    
    cont = 1;
    
    
    for i=0:wind_sample_time:T_edc;
        
        IEC_gusts_data.Wind_direction_ECD(cont) = 0.5 * teta_cg * (1-cos((pi*(i)/T_edc)));
        
        IEC_gusts_data.time_ECD(cont) = i;
        
        cont = cont + 1;
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %             ECD             %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    z=1;
    while 1,
        
        U_ECD(z,:) = V_ECG(z,:) .* cos( IEC_gusts_data.Wind_direction_ECD );
        U_ECD_HUB = V_ECG_HUB .* cos( IEC_gusts_data.Wind_direction_ECD );
        
        V_ECD(z,:) = V_ECG(z,:) .* sin( IEC_gusts_data.Wind_direction_ECD );
        V_ECD_HUB = V_ECG_HUB .* sin( IEC_gusts_data.Wind_direction_ECD );
        
        if z == grid_size(2),
            break;
        end
        z=z+1;
    end
    
    wind_grid_print(IEC_gusts_data.time_ECD(end),'ECD_plus.u',grid_size,grid_resolution,time_step,z_hub,V_hub,d,U_ECD_HUB,U_ECD,time_before_gust,time_after_gust,dat_file_name);
    wind_grid_print(IEC_gusts_data.time_ECD(end),'ECD_plus.v',grid_size,grid_resolution,time_step,z_hub,V_hub,d,-V_ECD_HUB,-V_ECD,time_before_gust,time_after_gust,dat_file_name);
    wind_grid_print(IEC_gusts_data.time_ECD(end),'ECD_plus.w',grid_size,grid_resolution,time_step,z_hub,V_hub,d,V_ECD_HUB*0,V_ECD*0,time_before_gust,time_after_gust,dat_file_name);
    wind_grid_print(IEC_gusts_data.time_ECD(end),'ECD_minus.u',grid_size,grid_resolution,time_step,z_hub,V_hub,d,U_ECD_HUB,U_ECD,time_before_gust,time_after_gust,dat_file_name);
    wind_grid_print(IEC_gusts_data.time_ECD(end),'ECD_minus.v',grid_size,grid_resolution,time_step,z_hub,V_hub,d,V_ECD_HUB,V_ECD,time_before_gust,time_after_gust,dat_file_name);
    wind_grid_print(IEC_gusts_data.time_ECD(end),'ECD_minus.w',grid_size,grid_resolution,time_step,z_hub,V_hub,d,V_ECD_HUB*0,V_ECD*0,time_before_gust,time_after_gust,dat_file_name);
    
    std_graph_sub( 8 , [3 1 1] , 'Extreme Coherent Gust with direction change U component(ECD)' , 'Wind Speed [m/s]' , 'Time [s]' , [0,[0+time_before_gust:wind_sample_time:T_edc+time_before_gust],T_edc+time_before_gust+time_after_gust] , [U_ECD(end,1),U_ECD(end,:),U_ECD(end,end)] , '-r', 2 );
    std_graph_sub( 8 , [3 1 1] , 'Extreme Coherent Gust with direction change U component(ECD)' , 'Wind Speed [m/s]' , 'Time [s]' , [0,[0+time_before_gust:wind_sample_time:T_edc+time_before_gust],T_edc+time_before_gust+time_after_gust] , [U_ECD((fix(end/2)),1),U_ECD((fix(end/2)),:),U_ECD((fix(end/2)),end)] , '-g', 2 );
    std_graph_sub( 8 , [3 1 1] , 'Extreme Coherent Gust with direction change U component(ECD)' , 'Wind Speed [m/s]' , 'Time [s]' , [0,[0+time_before_gust:wind_sample_time:T_edc+time_before_gust],T_edc+time_before_gust+time_after_gust] , [U_ECD(1,1),U_ECD(1,:),U_ECD(1,end)] , '-b', 2 );
    legend('Z TOP','Z MIDDLE','Z LOW');
    
    std_graph_sub( 8 , [3 1 2] , 'Extreme Coherent Gust with direction change V component(ECD)' , 'Wind Speed [m/s]' , 'Time [s]' , [0,[0+time_before_gust:wind_sample_time:10+time_before_gust],10+time_before_gust+time_after_gust] , [V_ECD(end,1),V_ECD(end,:),V_ECD(end,end)] , '-r', 2 );
    std_graph_sub( 8 , [3 1 2] , 'Extreme Coherent Gust with direction change V component(ECD)' , 'Wind Speed [m/s]' , 'Time [s]' , [0,[0+time_before_gust:wind_sample_time:10+time_before_gust],10+time_before_gust+time_after_gust] , [V_ECD((fix(end/2)),1),V_ECD((fix(end/2)),:),V_ECD((fix(end/2)),end)] , '-g', 2 );
    std_graph_sub( 8 , [3 1 2] , 'Extreme Coherent Gust with direction change V component(ECD)' , 'Wind Speed [m/s]' , 'Time [s]' , [0,[0+time_before_gust:wind_sample_time:10+time_before_gust],10+time_before_gust+time_after_gust] , [V_ECD(1,1),V_ECD(1,:),V_ECD(1,end)] , '-b', 2 );
    legend('Z TOP','Z MIDDLE','Z LOW');
      
    std_graph_sub( 8 , [3 1 3] , 'Extreme Coherent Gust with direction change direction (ECD)' , 'Direction [deg]' , 'Time [s]' , IEC_gusts_data.time_ECD , IEC_gusts_data.Wind_direction_ECD*180/pi , '-r', 2 );
    
    set(8, 'Name','ECD','NumberTitle','off') 
    disp(['teta_cg = ',num2str(teta_cg*180/pi), ' deg']) 
    
end

iec_wind_auxiliary2(IEC_gusts_data,wind_data,V_NWP,sigma_1,lambda_1,dat_file_name);