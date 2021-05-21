function Parameters = UserDefinedAnalysisWriteTH(Parameters)

%% In this routine the user may define some analysis
%
% Input:  struct Parameters
%
% Output: struct Parameters
%
%%
COL = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};

ShiftTime = Parameters.FLAG.ShiftTime;


%%%





%% WRITE ON TXT FILES
for iDLC = 1:size(Parameters.DLC.Run,1)
    % WRITE MDT Time Histories
    iTOTSensor = 0;
    % file name
    FileName = Parameters.DLC.Run{iDLC};
    fff=strfind(FileName,'\');
    FileName = strcat(FileName(fff(end)+1:end),sprintf('_%i.txt',iDLC));
    % time
    TIME = Parameters.MDT{iDLC}.Time;%-ShiftTime;
    iStart = find(Parameters.MDT{iDLC}.Time >= Parameters.DLC.InitTime(iDLC),1,'first'); if (isempty(iStart))  iStart=1;  end;
    iEnd   = find(Parameters.MDT{iDLC}.Time <= Parameters.DLC.EndTime(iDLC),1,'last');

    
    MATRIX{iDLC}.Legend = {'Time [sec]'};
    MATRIX{iDLC}.Data   = [TIME(iStart:iEnd)];
    % sensors
    for iSensor = 1:size(Parameters.SensorList,1)
        mdt_temp = getfield(Parameters.MDT{iDLC},Parameters.SensorList{iSensor,1});
        for iComp = 1:length(Parameters.SensorList{iSensor,2})
            CompNumb = Parameters.SensorList{iSensor,2}(iComp);
            YLabel{iComp} = strcat(mdt_temp.Extensions{CompNumb},mdt_temp.Units{CompNumb});
            % Signal
            Y(:,iComp) = mdt_temp.TimeHistories(iStart:iEnd,CompNumb);
            %
            iTOTSensor = iTOTSensor + 1 ;
        end
        % Save on global matrix
        % Write header
        MATRIX{iDLC}.Legend = [MATRIX{iDLC}.Legend  YLabel];
        % Write time histories
        MATRIX{iDLC}.Data   = [MATRIX{iDLC}.Data Y];

        clear YLabel Y
    end
    
    % SAVE SWP
    PlotTime = Parameters.SWP{iDLC}.Time';%-ShiftTime;
%     iStart = find(PlotTime<=0,1,'last');
%     iStart = find(Parameters.SWP{iDLC}.Time >= Parameters.DLC.InitTime(iDLC),1,'first'); if (isempty(iStart))  iStart=1;  end;
%     iEnd   = find(Parameters.SWP{iDLC}.Time <= Parameters.DLC.EndTime(iDLC),1,'last');

    WindAngle = atan2(Parameters.SWP{iDLC}.array(iStart:iEnd,167),Parameters.SWP{iDLC}.array(iStart:iEnd,166))*180/pi;

%     XYLabel = {'Hub Wind Speed [m/s]', 'Wind Angle [deg]', 'Electrical Torque [kNm]','Electrical Power [kW]', 'Electrical Power w/o Losses [kW]', 'iState [-]', 'Pitch Demanded [deg]', 'Pitch Rate Demanded [deg/s]', 'Yaw Error [deg]', 'Azimuth [deg]', 'YawTorqueControl [kNm]'};
%     XY      = [Parameters.SWP{iDLC}.array(iStart:iEnd,27) WindAngle  Parameters.SWP{iDLC}.array(iStart:iEnd,23)/1000 Parameters.SWP{iDLC}.array(iStart:iEnd,15)/1000 Parameters.SWP{iDLC}.array(iStart:iEnd,14)/1000 Parameters.SWP{iDLC}.array(iStart:iEnd,117) Parameters.SWP{iDLC}.array(iStart:iEnd,45)*180/pi Parameters.SWP{iDLC}.array(iStart:iEnd,46)*180/pi Parameters.SWP{iDLC}.array(iStart:iEnd,24)*180/pi Parameters.SWP{iDLC}.array(iStart:iEnd,60)*180/pi   Parameters.SWP{iDLC}.array(iStart:iEnd,41)/1000];
    XYLabel = {'Hub Wind Speed [m/s]',                    'Hub Wind Speed X [m/s]',                    'Hub Wind Speed Y [m/s]',                    'Hub Wind Speed Z [m/s]',                       'Nacelle Rotation [deg]',                           'Electrical Torque [kNm]',                              'Electrical Power [kW]',                            'Electrical Power w/o Losses [kW]',                  'iState [-]',                  'Tower Top FA Acceleration [m/s2]',      'Tower TOp SS Acceleration [m/s2]'   };
    XY      = [Parameters.SWP{iDLC}.array(iStart:iEnd,27) Parameters.SWP{iDLC}.array(iStart:iEnd,165)   Parameters.SWP{iDLC}.array(iStart:iEnd,166)   Parameters.SWP{iDLC}.array(iStart:iEnd,167)    Parameters.SWP{iDLC}.array(iStart:iEnd,37)*180/pi   Parameters.SWP{iDLC}.array(iStart:iEnd,23)/1000    Parameters.SWP{iDLC}.array(iStart:iEnd,15)/1000 Parameters.SWP{iDLC}.array(iStart:iEnd,14)/1000 Parameters.SWP{iDLC}.array(iStart:iEnd,117) Parameters.SWP{iDLC}.array(iStart:iEnd,53)  Parameters.SWP{iDLC}.array(iStart:iEnd,54) ];

    
    % Write header
    MATRIX{iDLC}.Legend = [MATRIX{iDLC}.Legend  XYLabel];
    % Write Time Histories
    MATRIX{iDLC}.Data   = [MATRIX{iDLC}.Data XY];
    
    clear XY XYLabel
    

    % Re-arrange columns
%     FinalIndex = [1   13  2  11 3:9  10 12 14:18]
% %     FinalIndex = [1:length(MATRIX{iDLC}.Legend)]
%     MATRIX_r{iDLC}.Legend = MATRIX{iDLC}.Legend(FinalIndex);
%     MATRIX_r{iDLC}.Data   = MATRIX{iDLC}.Data(:,FinalIndex);
    MATRIX_r{iDLC}.Legend = MATRIX{iDLC}.Legend;
    MATRIX_r{iDLC}.Data   = MATRIX{iDLC}.Data;
    
    
    % WRITE ON FILE
    fout=fopen(FileName,'w');
    % header
    for il = 1:length(MATRIX_r{iDLC}.Legend )
        fprintf(fout,'%s ',cell2mat(MATRIX_r{iDLC}.Legend(il)));
    end
    fprintf(fout,'\n\n');
    % data
    for il = 1:size(MATRIX_r{iDLC}.Data,1 )
        for ir = 1:size(MATRIX_r{iDLC}.Data,2 )
            fprintf(fout,'%+1.5e  ',MATRIX_r{iDLC}.Data(il,ir) );
        end
        fprintf(fout,'\n');
    end
    fclose(fout);
    
end


















%%%
return

%% WRITE MDT Time Histories
for iDLC = 1:size(Parameters.DLC.Run,1)
    FileName = Parameters.DLC.Run{iDLC};
    fff=strfind(FileName,'\');
    FileName = strcat(FileName(fff(end)+1:end),sprintf('_%i.xlsx',iDLC));
    TIME = Parameters.MDT{iDLC}.Time-ShiftTime;
    for iSensor = 1:size(Parameters.SensorList,1)
        SheetName = sprintf('%s',Parameters.SensorList{iSensor});
        mdt_temp = getfield(Parameters.MDT{iDLC},Parameters.SensorList{iSensor,1});
        for iComp = 1:length(Parameters.SensorList{iSensor,2})
            CompNumb = Parameters.SensorList{iSensor,2}(iComp);
            XLabel{1} = 'Time [sec]';
            YLabel{iComp} = strcat(mdt_temp.Extensions{CompNumb},mdt_temp.Units{CompNumb});
            % Signal
            Y(:,iComp) = mdt_temp.TimeHistories(:,CompNumb);
        end
        %% Remove Shift Time
        iStart = find(TIME<=0,1,'last');

        %% Write on file
        % Write header
        xlswrite(FileName,XLabel,SheetName,'A1');
        xlswrite(FileName,YLabel,SheetName,'B1');
        % Write time histories
        xlswrite(FileName,TIME(iStart:end),SheetName,'A2');
        for is=1:length(Parameters.SensorList{iSensor,2})
            xlswrite(FileName,Y(iStart:end,is),SheetName,strcat(COL{is+1},'2'));
        end
        clear YLabel
    end
    % clear variables before next DLC
    clear Y TIME
end


%% WRITE SWP Time Histories

for iDLC = 1:size(Parameters.DLC.Run,1)
    FileName = Parameters.DLC.Run{iDLC};
    fff=strfind(FileName,'\');
    FileName = strcat(FileName(fff(end)+1:end),sprintf('_%i.xlsx',iDLC));
    SheetName = 'ControllerVariables';
    
    %% Remove Shift Time
    PlotTime = Parameters.SWP{iDLC}.Time'-ShiftTime;
    iStart = find(PlotTime<=0,1,'last');

    XYLabel = {'Time [sec]',  'Hub Wind Speed [m/s]', 'Electrical Torque [kNm]','Electrical Power [kW]', 'Electrical Power w/o Losses [kW]', 'iState [-]', 'Pitch Demanded [deg]', 'Pitch Rate Demanded [deg/s]', 'Yaw Error [deg]', 'Azimuth [deg]'};
    XY      = [PlotTime(iStart:end) Parameters.SWP{iDLC}.array(iStart:end,27)  Parameters.SWP{iDLC}.array(iStart:end,23)/1000 Parameters.SWP{iDLC}.array(iStart:end,15)/1000 Parameters.SWP{iDLC}.array(iStart:end,14)/1000 Parameters.SWP{iDLC}.array(iStart:end,117) Parameters.SWP{iDLC}.array(iStart:end,45)*180/pi Parameters.SWP{iDLC}.array(iStart:end,46)*180/pi Parameters.SWP{iDLC}.array(iStart:end,24)*180/pi Parameters.SWP{iDLC}.array(iStart:end,60)*180/pi];
    
    %% Write on file
    % Write header
    xlswrite(FileName,XYLabel,SheetName,'A1');
    % Write Time Histories
    xlswrite(FileName,XY,SheetName,'A2');

    clear XY XYLabel
end

%% WRITE ON TXT FILES
for iDLC = 1:size(Parameters.DLC.Run,1)
    % WRITE MDT Time Histories
    iTOTSensor = 0;
    % file name
    FileName = Parameters.DLC.Run{iDLC};
    fff=strfind(FileName,'\');
    FileName = strcat(FileName(fff(end)+1:end),sprintf('_%i.txt',iDLC));
    % time
    TIME = Parameters.MDT{iDLC}.Time-ShiftTime;
    iStart = find(TIME<=0,1,'last'); if (isempty(iStart))  iStart=1;  end;
    MATRIX{iDLC}.Legend = {'Time [sec]'};
    MATRIX{iDLC}.Data   = [TIME(iStart:end)];
    % sensors
    for iSensor = 1:size(Parameters.SensorList,1)
        mdt_temp = getfield(Parameters.MDT{iDLC},Parameters.SensorList{iSensor,1});
        for iComp = 1:length(Parameters.SensorList{iSensor,2})
            CompNumb = Parameters.SensorList{iSensor,2}(iComp);
            YLabel{iComp} = strcat(mdt_temp.Extensions{CompNumb},mdt_temp.Units{CompNumb});
            % Signal
            Y(:,iComp) = mdt_temp.TimeHistories(iStart:end,CompNumb);
            %
            iTOTSensor = iTOTSensor + 1 ;
        end
        % Save on global matrix
        % Write header
        MATRIX{iDLC}.Legend = [MATRIX{iDLC}.Legend  YLabel];
        % Write time histories
        MATRIX{iDLC}.Data   = [MATRIX{iDLC}.Data Y];

        clear YLabel Y
    end
    
    % SAVE SWP
    PlotTime = Parameters.SWP{iDLC}.Time'-ShiftTime;
    iStart = find(PlotTime<=0,1,'last');

    XYLabel = {'Hub Wind Speed [m/s]', 'Electrical Torque [kNm]','Electrical Power [kW]', 'Electrical Power w/o Losses [kW]', 'iState [-]', 'Pitch Demanded [deg]', 'Pitch Rate Demanded [deg/s]', 'Yaw Error [deg]', 'Azimuth [deg]'};
    XY      = [Parameters.SWP{iDLC}.array(iStart:end,27)  Parameters.SWP{iDLC}.array(iStart:end,23)/1000 Parameters.SWP{iDLC}.array(iStart:end,15)/1000 Parameters.SWP{iDLC}.array(iStart:end,14)/1000 Parameters.SWP{iDLC}.array(iStart:end,117) Parameters.SWP{iDLC}.array(iStart:end,45)*180/pi Parameters.SWP{iDLC}.array(iStart:end,46)*180/pi Parameters.SWP{iDLC}.array(iStart:end,24)*180/pi Parameters.SWP{iDLC}.array(iStart:end,60)*180/pi];

    
    % Write header
    MATRIX{iDLC}.Legend = [MATRIX{iDLC}.Legend  XYLabel];
    % Write Time Histories
    MATRIX{iDLC}.Data   = [MATRIX{iDLC}.Data XY];
    clear XY XYLabel
    
    % Re-arrange columns
    FinalIndex = [1   2 2   21  3:17    18 23   19:22  ]
    FinalIndex = [1:length(MATRIX{iDLC}.Legend)]
    MATRIX_r{iDLC}.Legend = MATRIX{iDLC}.Legend(FinalIndex);
    MATRIX_r{iDLC}.Data   = MATRIX{iDLC}.Data(:,FinalIndex);
    
    
    % WRITE ON FILE
    fout=fopen(FileName,'w');
    % header
    for il = 1:length(MATRIX_r{iDLC}.Legend )
        fprintf(fout,'%s ',cell2mat(MATRIX_r{iDLC}.Legend(il)));
    end
    fprintf(fout,'\n\n');
    % data
    for il = 1:size(MATRIX_r{iDLC}.Data,1 )
        for ir = 1:size(MATRIX_r{iDLC}.Data,2 )
            fprintf(fout,'%1.5e  ',MATRIX_r{iDLC}.Data(il,ir) );
        end
        fprintf(fout,'\n');
    end
    fclose(fout);
    
end



% %% WRITE ON TXT FILES
% for iDLC = 1:size(Parameters.DLC.Run,1)
%     % WRITE MDT Time Histories
%     iTOTSensor = 0;
%     % file name
%     FileName = Parameters.DLC.Run{iDLC};
%     fff=strfind(FileName,'\');
%     FileName = strcat(FileName(fff(end)+1:end),sprintf('_%i.txt',iDLC));
%     % time
%     TIME = Parameters.MDT{iDLC}.Time;
%     iStart = find(TIME >= Parameters.DLC.InitTime(iDLC),1,'first'); if (isempty(iStart))  iStart=1;  end;
%     iEnd   = find(TIME <= Parameters.DLC.EndTime(iDLC),1,'last');
%     TIME = TIME(iStart:iEnd); TIME = TIME - TIME(1);
%     MATRIX{iDLC}.Legend = {'Time [sec]'};
%     MATRIX{iDLC}.Data   = [TIME];
%     % sensors
%     for iSensor = 1:size(Parameters.SensorList,1)
%         mdt_temp = getfield(Parameters.MDT{iDLC},Parameters.SensorList{iSensor,1});
%         for iComp = 1:length(Parameters.SensorList{iSensor,2})
%             CompNumb = Parameters.SensorList{iSensor,2}(iComp);
%             YLabel{iComp} = strcat(mdt_temp.Extensions{CompNumb},mdt_temp.Units{CompNumb});
%             % Signal
%             Y(:,iComp) = mdt_temp.TimeHistories(iStart:iEnd,CompNumb);
%             %
%             iTOTSensor = iTOTSensor + 1 ;
%         end
%         % Save on global matrix
%         % Write header
%         MATRIX{iDLC}.Legend = [MATRIX{iDLC}.Legend  YLabel];
%         % Write time histories
%         MATRIX{iDLC}.Data   = [MATRIX{iDLC}.Data Y];
% 
%         clear YLabel Y
%     end
%     
%     % SAVE SWP
%     XYLabel = {'Hub Wind Speed [m/s]', 'Electrical Torque [kNm]','Electrical Power [kW]', 'Electrical Power w/o Losses [kW]'};
%     XY      = [Parameters.SWP{iDLC}.array(iStart:iEnd,27)  Parameters.SWP{iDLC}.array(iStart:iEnd,23)/1000 Parameters.SWP{iDLC}.array(iStart:iEnd,15)/1000 Parameters.SWP{iDLC}.array(iStart:iEnd,14)/1000];
%     
%     % Write header
%     MATRIX{iDLC}.Legend = [MATRIX{iDLC}.Legend  XYLabel];
%     % Write Time Histories
%     MATRIX{iDLC}.Data   = [MATRIX{iDLC}.Data XY];
%     clear XY XYLabel
%     
%     % Re-arrange columns
%     FinalIndex = [1   2 2   21  3:17    18 23   19:22  ]
%     FinalIndex = [1:length(MATRIX{iDLC}.Legend)]
%     MATRIX_r{iDLC}.Legend = MATRIX{iDLC}.Legend(FinalIndex);
%     MATRIX_r{iDLC}.Data   = MATRIX{iDLC}.Data(:,FinalIndex);
%     
%     
%     % WRITE ON FILE
%     fout=fopen(FileName,'w');
%     % header
%     for il = 1:length(MATRIX_r{iDLC}.Legend )
%         fprintf(fout,'%s ',cell2mat(MATRIX_r{iDLC}.Legend(il)));
%     end
%     fprintf(fout,'\n\n');
%     % data
%     for il = 1:size(MATRIX_r{iDLC}.Data,1 )
%         for ir = 1:size(MATRIX_r{iDLC}.Data,2 )
%             fprintf(fout,'%1.5e  ',MATRIX_r{iDLC}.Data(il,ir) );
%         end
%         fprintf(fout,'\n');
%     end
%     fclose(fout);
%     
% end
% 
