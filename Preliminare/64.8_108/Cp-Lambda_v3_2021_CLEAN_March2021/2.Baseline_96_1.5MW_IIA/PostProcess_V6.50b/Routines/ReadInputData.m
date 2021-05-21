function Parameters = ReadInputData(FileDLCName,FileSensorName)



%% Read File List
iSheet = 1;

[num, txt] = xlsread(FileDLCName, -1);

Parameters.DLC.Run      = txt;
Parameters.DLC.Safety   = num(:,1);
Parameters.DLC.InitTime = num(:,2);
Parameters.DLC.EndTime  = num(:,3);

%% Read Sensor List
[num, txt] = xlsread(FileSensorName, -1);

Nsensor = length(txt);

List{Nsensor,2} = [];
% remove NaN
for ii=1:Nsensor
    ni = length(num(ii,3:end));
    kk = 0;
    for jj=1:ni
        if ~isnan(num(ii,jj+2))
            kk = kk + 1 ;
            TempLine(1,kk) = num(ii,jj+2);
        end
    end
    List{ii,1} = sprintf(txt{ii});
    List{ii,2} = TempLine;
    clear TempLine 
end

Parameters.SensorList   = List;
