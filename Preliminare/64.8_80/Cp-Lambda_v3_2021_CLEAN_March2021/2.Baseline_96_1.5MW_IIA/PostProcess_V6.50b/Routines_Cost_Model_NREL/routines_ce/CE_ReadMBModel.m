function [RotorDiameter, BladeLength, HubHeight]=CE_ReadMBModel(TargetFolder,FileList)

% Input: Address of the required MB_Model folder
% Output: A 'paremeter' structure containing all the relevant data.

%% Scan 'Inflow.dat' --> (Rotor radius, Hub radius, Blade length)
FileAddress=strcat(TargetFolder,'\',FileList.Inflow);
f0=fopen(FileAddress);
     while ~ feof(f0)
        string=[];
        TrimmedString=[];
        string=fgetl(f0);
        TrimmedString=strtrim(string);
        k = findstr(TrimmedString, 'Inflows : ');
        if k ==1
            break
        else
        end
     end
    for i=1:5
        fgetl(f0);
    end
    fscanf(f0,'%[InflowLengthFactor :]');
    % Read rotor radius
    RotorRadius=fscanf(f0,'%f');  
    for i=1:5
        fgetl(f0);
    end
    fscanf(f0,'%[HubRadius :]');
    % Read hub radius
    HubRadius=fscanf(f0,'%f');
fclose(f0);
% Define blade length
BladeLength=RotorRadius-HubRadius;
HubRadius=HubRadius;
RotorDiameter=RotorRadius*2;


%% Scan 'Fixed_frames.dat' --> (Hub Heigth)
FileAddress=strcat(TargetFolder,'\',FileList.Frames);
f2=fopen(FileAddress);
    while ~ feof(f2)
        string=[];
        TrimmedString=[];
        string=fgetl(f2);
        TrimmedString=strtrim(string);
        k = findstr(TrimmedString, 'Name : frame_hub ;');
        if k ==1
            break
        else
        end
    end
    fscanf(f2,'%[Origin : ]');
    HubHeight=fscanf(f2,'%f \n');
fclose(f2);
