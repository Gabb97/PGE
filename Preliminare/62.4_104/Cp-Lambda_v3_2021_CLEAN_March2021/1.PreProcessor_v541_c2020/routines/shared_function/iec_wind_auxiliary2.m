function IEC_gusts_data=iec_wind_auxiliary2(IEC_gusts_data,wind_data,V_NWP,sigma_1,lambda_1,dat_file_name);

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXTREME WIND SHEAR (EWS)                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if upper(wind_data.EWS_v(end)) == 'S'
    
    if IECEdition==6140013
        alpha = 0.2;
        beta  = 6.4;
        T_ews = 12;
    elseif IECEdition==6140012
        alpha = 0.2;
        beta  = 6.4;
        T_ews = 12;
    elseif IECEdition==6140022
        alpha = 0.2;
        beta  = 6.4;
        T_ews = 12;
    end
    
    
    % VERTICAL EXTREME WIND SHEAR-------------------------------------------------
    cont = 1;
    z=[(z_hub-d/2):grid_resolution:(z_hub+d/2)];
    
    for i = 0:wind_sample_time:T_ews;
        
        IEC_gusts_data.Wind_direction_EWS_vertical(:,cont) = (V_hub * ( z/z_hub ).^alpha) + ( (z-z_hub) / D ) * ( 2.5 + 0.2 * beta * sigma_1 * (D/lambda_1)^0.25) * ( 1-cos(2*pi*i/T_ews));
        if (IECEdition==6140013 || IECEdition==6140012)
            IEC_gusts_data.Wind_direction_EWS_vertical_minus(:,cont) = (V_hub * ( z/z_hub ).^alpha) - ( (z-z_hub) / D ) * ( 2.5 + 0.2 * beta * sigma_1 * (D/lambda_1)^0.25) * ( 1-cos(2*pi*i/T_ews));
        end
        EWS_HUB_vertical(cont) = (V_hub * ( z_hub/z_hub ).^alpha) + ( (z_hub-z_hub) / D ) * ( 2.5 + 0.2 * beta * sigma_1 * (D/lambda_1)^0.25) * ( 1-cos(2*pi*i/T_ews));
        IEC_gusts_data.time_EWS_vertical(cont) = i;
        
        cont = cont + 1;
        
    end
    
    % Now the VERTICAL EWS will be "plotted"
    std_graph( 9 , 'Exteme VERTICAL Wind Shear [EWS]' , 'Longitudinal Wind Speed [m/s]' , 'Time [s]' , [ 0 , ...
        IEC_gusts_data.time_EWS_vertical+time_before_gust , ...
        IEC_gusts_data.time_EWS_vertical(end)+time_before_gust+time_after_gust] , ...
        [ IEC_gusts_data.Wind_direction_EWS_vertical(end,1) , ...
        IEC_gusts_data.Wind_direction_EWS_vertical(end,:) , ...
        IEC_gusts_data.Wind_direction_EWS_vertical(end,end)] , ...
        '-r' , 2 );
    
    std_graph( 9 , 'Exteme VERTICAL Wind Shear [EWS]' , 'Longitudinal Wind Speed [m/s]' , 'Time [s]' , [ 0 , ...
        IEC_gusts_data.time_EWS_vertical+time_before_gust , ...
        IEC_gusts_data.time_EWS_vertical(end)+time_before_gust+time_after_gust] , ...
        [ IEC_gusts_data.Wind_direction_EWS_vertical((fix(end/2)),1) , ...
        IEC_gusts_data.Wind_direction_EWS_vertical((fix(end/2)),:) , ...
        IEC_gusts_data.Wind_direction_EWS_vertical((fix(end/2)),end)] , ...
        '-g' , 2 );
    
    std_graph( 9 , 'Exteme VERTICAL Wind Shear [EWS]' , 'Longitudinal Wind Speed [m/s]' , 'Time [s]' , [ 0 , ...
        IEC_gusts_data.time_EWS_vertical+time_before_gust , ...
        IEC_gusts_data.time_EWS_vertical(end)+time_before_gust+time_after_gust] , ...
        [ IEC_gusts_data.Wind_direction_EWS_vertical(1,1) , ...
        IEC_gusts_data.Wind_direction_EWS_vertical(1,:) , ...
        IEC_gusts_data.Wind_direction_EWS_vertical(1,end)] , ...
        '-b' , 2 );
    
    legend('Z TOP','Z MIDDLE','Z LOW');
    
    set(9, 'Name','EWS_V','NumberTitle','off')
    disp(['V_EWSV(plus, top) = ',num2str(IEC_gusts_data.Wind_direction_EWS_vertical(end,fix(end/2))), ' m/s'])
    disp(['V_EWSV(plus, bot) = ',num2str(IEC_gusts_data.Wind_direction_EWS_vertical(1,fix(end/2))), ' m/s'])
    if (IECEdition==6140013 || IECEdition==6140012)
        
        disp(['V_EWSV(minus, top) = ',num2str(IEC_gusts_data.Wind_direction_EWS_vertical_minus(end,fix(end/2))), ' m/s'])
        disp(['V_EWSV(minus, bot) = ',num2str(IEC_gusts_data.Wind_direction_EWS_vertical_minus(1,fix(end/2))), ' m/s'])
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %         EWS VERTICAL            %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if IECEdition==6140013
        wind_grid_print(T_ews,'EWS_vertical_plus.u',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_vertical,IEC_gusts_data.Wind_direction_EWS_vertical,time_before_gust,time_after_gust,dat_file_name);
        wind_grid_print(T_ews,'EWS_vertical_plus.v',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_vertical*0,IEC_gusts_data.Wind_direction_EWS_vertical*0,time_before_gust,time_after_gust,dat_file_name);
        wind_grid_print(T_ews,'EWS_vertical_plus.w',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_vertical*0,IEC_gusts_data.Wind_direction_EWS_vertical*0,time_before_gust,time_after_gust,dat_file_name);
        wind_grid_print(T_ews,'EWS_vertical_minus.u',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_vertical,IEC_gusts_data.Wind_direction_EWS_vertical_minus,time_before_gust,time_after_gust,dat_file_name);
        wind_grid_print(T_ews,'EWS_vertical_minus.v',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_vertical*0,IEC_gusts_data.Wind_direction_EWS_vertical_minus*0,time_before_gust,time_after_gust,dat_file_name);
        wind_grid_print(T_ews,'EWS_vertical_minus.w',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_vertical*0,IEC_gusts_data.Wind_direction_EWS_vertical_minus*0,time_before_gust,time_after_gust,dat_file_name);
    else
        wind_grid_print(T_ews,'EWS_vertical.u',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_vertical,IEC_gusts_data.Wind_direction_EWS_vertical,time_before_gust,time_after_gust,dat_file_name);
        wind_grid_print(T_ews,'EWS_vertical.v',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_vertical*0,IEC_gusts_data.Wind_direction_EWS_vertical*0,time_before_gust,time_after_gust,dat_file_name);
        wind_grid_print(T_ews,'EWS_vertical.w',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_vertical*0,IEC_gusts_data.Wind_direction_EWS_vertical*0,time_before_gust,time_after_gust,dat_file_name);
    end
end

if upper(wind_data.EWS_h(end)) == 'S'
    
    % HORIZONTAL EXTEME WIND SHEAR ---------------------------------------------
    Y = -d/2:grid_resolution:+d/2;      %% ALEALE WARNING HERE wrt the previous ver.!!!
    lateral = max(size(Y));
    cont = 1;
    z=[(z_hub-d/2):grid_resolution:(z_hub+d/2)];
    
    for i = 0:wind_sample_time:T_ews;
        
        for ii = 1:1:lateral;
            
            IEC_gusts_data.Wind_direction_EWS_horizontal(cont,:,ii) = (V_hub * ( z/z_hub ).^alpha) + ( Y(ii) / D ) * ( 2.5 + 0.2 * beta * sigma_1 * (D/lambda_1).^0.25) * ( 1-cos((2*pi*(i))/T_ews));
            if (IECEdition==6140013 || IECEdition==6140012)
                IEC_gusts_data.Wind_direction_EWS_horizontal_minus(cont,:,ii) = (V_hub * ( z/z_hub ).^alpha) - ( Y(ii) / D ) * ( 2.5 + 0.2 * beta * sigma_1 * (D/lambda_1).^0.25) * ( 1-cos((2*pi*(i))/T_ews));
            end
            EWS_HUB_horizontal(cont,ii) = (V_hub * ( z_hub/z_hub ).^alpha) + ( Y(ii) / D ) * ( 2.5 + 0.2 * beta * sigma_1 * (D/lambda_1).^0.25) * ( 1-cos((2*pi*(i))/T_ews));
            
        end
        
        IEC_gusts_data.time_EWS_horizontal(cont) = i;
        
        cont = cont + 1;
        
    end
    
    % Now the HORIZONTAL EWS will be "plotted"
    std_graph_sub( 10 , [3 1 1] , 'Horizontal Extreme Wind Shear at Z top' , 'Wind Speed [m/s]' , 'Time [s]' , [0,IEC_gusts_data.time_EWS_horizontal+time_before_gust,IEC_gusts_data.time_EWS_horizontal(end)+time_before_gust+time_after_gust] , ...
        [IEC_gusts_data.Wind_direction_EWS_horizontal(1,end,1),IEC_gusts_data.Wind_direction_EWS_horizontal(:,end,1)',IEC_gusts_data.Wind_direction_EWS_horizontal(end,end,1)] , '-r', 2 );
    std_graph_sub( 10 , [3 1 1] , 'Horizontal Extreme Wind Shear at Z top' , 'Wind Speed [m/s]' , 'Time [s]' , [0,IEC_gusts_data.time_EWS_horizontal+time_before_gust,IEC_gusts_data.time_EWS_horizontal(end)+time_before_gust+time_after_gust] , ...
        [IEC_gusts_data.Wind_direction_EWS_horizontal(1,end,(fix(end/2))),IEC_gusts_data.Wind_direction_EWS_horizontal(:,end,(fix(end/2)))',IEC_gusts_data.Wind_direction_EWS_horizontal(end,end,(fix(end/2)))] , '-g', 2 );
    std_graph_sub( 10 , [3 1 1] , 'Horizontal Extreme Wind Shear at Z top' , 'Wind Speed [m/s]' , 'Time [s]' , [0,IEC_gusts_data.time_EWS_horizontal+time_before_gust,IEC_gusts_data.time_EWS_horizontal(end)+time_before_gust+time_after_gust] , ...
        [IEC_gusts_data.Wind_direction_EWS_horizontal(1,end,end),IEC_gusts_data.Wind_direction_EWS_horizontal(:,end,end)',IEC_gusts_data.Wind_direction_EWS_horizontal(end,end,end)] , '-b', 2 );
    legend('LEFT','CENTRE','RIGHT');
    
    std_graph_sub( 10 , [3 1 2] , 'Horizontal Extreme Wind Shear at Z middle' , 'Wind Speed [m/s]' , 'Time [s]' , [0,IEC_gusts_data.time_EWS_horizontal+time_before_gust,IEC_gusts_data.time_EWS_horizontal(end)+time_before_gust+time_after_gust] , ...
        [IEC_gusts_data.Wind_direction_EWS_horizontal(1,(fix(end/2)),1),IEC_gusts_data.Wind_direction_EWS_horizontal(:,(fix(end/2)),1)',IEC_gusts_data.Wind_direction_EWS_horizontal(end,(fix(end/2)),1)] , '-r', 2 );
    std_graph_sub( 10 , [3 1 2] , 'Horizontal Extreme Wind Shear at Z middle' , 'Wind Speed [m/s]' , 'Time [s]' , [0,IEC_gusts_data.time_EWS_horizontal+time_before_gust,IEC_gusts_data.time_EWS_horizontal(end)+time_before_gust+time_after_gust] , ...
        [IEC_gusts_data.Wind_direction_EWS_horizontal(1,(fix(end/2)),(fix(end/2))),IEC_gusts_data.Wind_direction_EWS_horizontal(:,(fix(end/2)),(fix(end/2)))',IEC_gusts_data.Wind_direction_EWS_horizontal(end,(fix(end/2)),(fix(end/2)))] , '-g', 2 );
    std_graph_sub( 10 , [3 1 2] , 'Horizontal Extreme Wind Shear at Z middle' , 'Wind Speed [m/s]' , 'Time [s]' , [0,IEC_gusts_data.time_EWS_horizontal+time_before_gust,IEC_gusts_data.time_EWS_horizontal(end)+time_before_gust+time_after_gust] , ...
        [IEC_gusts_data.Wind_direction_EWS_horizontal(1,(fix(end/2)),end),IEC_gusts_data.Wind_direction_EWS_horizontal(:,(fix(end/2)),end)',IEC_gusts_data.Wind_direction_EWS_horizontal(end,(fix(end/2)),end)] , '-b', 2 );
    legend('LEFT','CENTRE','RIGHT');
    
    std_graph_sub( 10 , [3 1 3] , 'Horizontal Extreme Wind Shear at Z low' , 'Wind Speed [m/s]' , 'Time [s]' , [0,IEC_gusts_data.time_EWS_horizontal+time_before_gust,IEC_gusts_data.time_EWS_horizontal(end)+time_before_gust+time_after_gust] , ...
        [IEC_gusts_data.Wind_direction_EWS_horizontal(1,1,1),IEC_gusts_data.Wind_direction_EWS_horizontal(:,1,1)',IEC_gusts_data.Wind_direction_EWS_horizontal(end,1,1)] , '-r', 2 );
    std_graph_sub( 10 , [3 1 3] , 'Horizontal Extreme Wind Shear at Z low' , 'Wind Speed [m/s]' , 'Time [s]' , [0,IEC_gusts_data.time_EWS_horizontal+time_before_gust,IEC_gusts_data.time_EWS_horizontal(end)+time_before_gust+time_after_gust] , ...
        [IEC_gusts_data.Wind_direction_EWS_horizontal(1,1,(fix(end/2))),IEC_gusts_data.Wind_direction_EWS_horizontal(:,1,(fix(end/2)))',IEC_gusts_data.Wind_direction_EWS_horizontal(end,1,(fix(end/2)))] , '-g', 2 );
    std_graph_sub( 10 , [3 1 3] , 'Horizontal Extreme Wind Shear at Z low' , 'Wind Speed [m/s]' , 'Time [s]' , [0,IEC_gusts_data.time_EWS_horizontal+time_before_gust,IEC_gusts_data.time_EWS_horizontal(end)+time_before_gust+time_after_gust] , ...
        [IEC_gusts_data.Wind_direction_EWS_horizontal(1,1,end),IEC_gusts_data.Wind_direction_EWS_horizontal(:,1,end)',IEC_gusts_data.Wind_direction_EWS_horizontal(end,1,end)] , '-b', 2 );
    legend('LEFT','CENTRE','RIGHT');
    set(10, 'Name','EWS_H','NumberTitle','off')
    disp(['V_EWSH(plus, top, left) = ',num2str(IEC_gusts_data.Wind_direction_EWS_horizontal(fix(end/2),end,1)), ' m/s'])
    disp(['V_EWSH(plus, bot, right) = ',num2str(IEC_gusts_data.Wind_direction_EWS_horizontal(fix(end/2),1,end)), ' m/s'])
    if (IECEdition==6140013 || IECEdition==6140012)
        disp(['V_EWSH(minus, top, left) = ',num2str(IEC_gusts_data.Wind_direction_EWS_horizontal_minus(fix(end/2),end,1)), ' m/s'])
        disp(['V_EWSH(minus, bot, right) = ',num2str(IEC_gusts_data.Wind_direction_EWS_horizontal_minus(fix(end/2),1,end)), ' m/s'])
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %         EWS HORIZONTAL          %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if IECEdition==6140013
        wind_grid_print_EWS(T_ews,'EWS_horizontal_plus.u',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_horizontal,IEC_gusts_data.Wind_direction_EWS_horizontal,time_before_gust,time_after_gust,dat_file_name);
        wind_grid_print_EWS(T_ews,'EWS_horizontal_plus.v',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_horizontal*0,IEC_gusts_data.Wind_direction_EWS_horizontal*0,time_before_gust,time_after_gust,dat_file_name);
        wind_grid_print_EWS(T_ews,'EWS_horizontal_plus.w',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_horizontal*0,IEC_gusts_data.Wind_direction_EWS_horizontal*0,time_before_gust,time_after_gust,dat_file_name);
        wind_grid_print_EWS(T_ews,'EWS_horizontal_minus.u',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_horizontal,IEC_gusts_data.Wind_direction_EWS_horizontal_minus,time_before_gust,time_after_gust,dat_file_name);
        wind_grid_print_EWS(T_ews,'EWS_horizontal_minus.v',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_horizontal*0,IEC_gusts_data.Wind_direction_EWS_horizontal_minus*0,time_before_gust,time_after_gust,dat_file_name);
        wind_grid_print_EWS(T_ews,'EWS_horizontal_minus.w',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_horizontal*0,IEC_gusts_data.Wind_direction_EWS_horizontal_minus*0,time_before_gust,time_after_gust,dat_file_name);
    else
        wind_grid_print_EWS(T_ews,'EWS_horizontal.u',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_horizontal,IEC_gusts_data.Wind_direction_EWS_horizontal,time_before_gust,time_after_gust,dat_file_name);
        wind_grid_print_EWS(T_ews,'EWS_horizontal.v',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_horizontal*0,IEC_gusts_data.Wind_direction_EWS_horizontal*0,time_before_gust,time_after_gust,dat_file_name);
        wind_grid_print_EWS(T_ews,'EWS_horizontal.w',grid_size,grid_resolution,time_step,z_hub,V_hub,d,EWS_HUB_horizontal*0,IEC_gusts_data.Wind_direction_EWS_horizontal*0,time_before_gust,time_after_gust,dat_file_name);
    end
end