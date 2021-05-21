function [imbalance_failure]=read_imbalance_and_failure(PathStruct)

%--------------------------------------------
% This function reads the imbalance and 
% failure details. The output returns a 
% MATLAB structure named imbalande_failure 
% and its fields are:

%--------------------------------------------


% imbalance_failure structure pre-allocation
imbalance_failure = struct ('set_angle_err' , [] , 'pitch_angle_err' , [] , 'azimut_angle_err' , [] , 'pitch_fail_angle' , [] ,'pitch_status','');

%%% ALEALE 14.may.2007
% fid=fopen('input\imbalance_and_failure.txt','r');
fid=fopen(strcat(PathStruct.FullPathInputDir,'\imbalance_and_failure.txt'),'r');

i=0;

while feof(fid) == 0 ,
     
    line = fgetl(fid);
    check_spaced_line = size(deblank(line));
    
    if (isempty(line) == false & line(1) ~= '%' & check_spaced_line(1) ~= 0 ),
        
        i = i + 1 ;
        
        switch i
            
            case 1
                
                temp=(str2num(line))*(pi/180);
                
                imbalance_failure.set_angle_err(1)    =  temp(2);
                imbalance_failure.pitch_angle_err(1)  =  temp(3);
                imbalance_failure.azimut_angle_err(1) =  temp(4);
                imbalance_failure.pitch_fail_angle(1) =  temp(5);
                
                
                
            case 2
                
                temp=(str2num(line))*(pi/180);
                
                imbalance_failure.set_angle_err(2)    =  temp(2);
                imbalance_failure.pitch_angle_err(2)  =  temp(3);
                imbalance_failure.azimut_angle_err(2) =  temp(4);
                imbalance_failure.pitch_fail_angle(2) =  temp(5);
                
            case 3
                
                temp=(str2num(line))*(pi/180);
                
                imbalance_failure.set_angle_err(3)    =  temp(2);
                imbalance_failure.pitch_angle_err(3)  =  temp(3);
                imbalance_failure.azimut_angle_err(3) =  temp(4);
                imbalance_failure.pitch_fail_angle(3) =  temp(5);                
                
            case 4
                
                imbalance_failure.pitch_status(1,:) =  strvcat(deblank(line));
                
            case 5

                imbalance_failure.pitch_status(2,:) =  strvcat(deblank(line));                
                
            case 6
                
                imbalance_failure.pitch_status(3,:) =  strvcat(deblank(line));
                
        end
        
    end    
    
end

fclose(fid);