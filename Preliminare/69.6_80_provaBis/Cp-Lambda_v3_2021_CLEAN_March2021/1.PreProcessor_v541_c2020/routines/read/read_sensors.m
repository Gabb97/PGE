function  [sensors]=read_sensors(file_name);

%--------------------------------------------
% This function reads the sensors details.
% The output returns a MATLAB structure
% named sensors, its fields are:
%  -eta_blade = the eta position along
%               the blade of each sensors;
%  -eta_tower = the eta position along
%               the tower of each sensors;
%  -blade_studied = is a string which defines
%                   if the sensors should be
%                   copied for each rotor 
%                   blade.
%--------------------------------------------


% Sensors structure (incomplete) pre-allocation
sensors = struct ('eta_blade' , [] , 'eta_tower' , [] , 'blade_studied' , [] , 'hub_flag' , [] , 'tower_flag' , [] );


% fid=fopen('input\sensors.txt','r');
fid=fopen(file_name,'r');

%%%%%%%%%%%%%%%%%%%%%% Check
if (fid<0)
    fprintf(1,'\n$$$ ERROR: file %s not found!',file_name);
    fprintf(1,'\n           Please check the directory name.');
    sensors = [];
    return ;
end
    

i=0;

while feof(fid) == 0 ,
     
    line = fgetl(fid);
    check_spaced_line = size(deblank(line));
    
    if (isempty(line) == false & line(1) ~= '%' & check_spaced_line(1) ~= 0 ),
        
        i = i + 1 ;
        
        switch i
            
            case 1
                sensors.eta_blade = str2num(line);
                
            case 2
                
                sensors.blade_studied = line;
                
            case 3
                
                sensors.hub_flag = line;
                
            case 4
                
                sensors.tower_flag = line;
                
            case 5
                sensors.eta_tower = str2num(line);
                
            case 6
                
                sensors.drive_train = line;
                
        end
        
    end    
    
end

fclose(fid);