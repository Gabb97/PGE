function generator=read_generator_details(PathStruct);

% fprintf('*** Reading [%s] file\n',strcat(PathStruct.FullPathInputDir,'\generator_details.txt'));

fid=fopen(strcat(PathStruct.FullPathInputDir,'\generator_details.txt'),'r');
   
if (fid<0)
    fprintf('\n *** ERROR: [%s] file not fountd!\n',strcat(PathStruct.FullPathInputDir,'\generator_details.txt'));
    generator = [];
    return
end


%------------------------------
% service variables definitions
i=0;
r=1;
check=0;
d=1;
%------------------------------

%generator structure definiion and pre-allocation
generator = struct ('type' , ['null'] , ...
                    'mass' , [0] , ...
                    'distance_from_hub_cg' , [0] , ...
                    'inertia' , [0] , ...
                    'no_load_power_loss' , [0] , ...
                    'efficiency' , [0] ,...
                    'mechanical_loss_torque' , [] , ...
                    'torque_behaviour' , [] );


while feof(fid) == 0 ,
    
    line = fgetl(fid);
    check_spaced_line = size(deblank(line));
    
    if ( isempty(line) == false & line(1) ~= '%' & check_spaced_line(1) ~= 0 ),
        
        i = i +1;
        
        if i <=6, % this is the if 2
            switch i
                case 1
                    generator.type=deblank(line);
                    
                case 2
                    generator.mass=str2num(line);
                    
                case 3 
                    generator.distance_from_hub_cg=str2num(line);
                    
                case 4
                    generator.inertia=str2num(line);
                    
                case 5
                    generator.no_load_power_loss=str2num(line);
                    
                case 6
                    generator.efficiency=str2num(line);
                    
            end %end switch                                
            
        elseif i <= 8,
            aa_temp(r,:)=str2num(line);
            r=r+1;
            
        elseif check == 0;
            
            test(1,:)=str2num(line);
            
            if test(1,1) == 0;
                bb_temp(1,:)=test;
                check=1;
                d=d+1;
            else
                aa_temp(r,:)=test;
                r = r + 1;
            end                       
            
        else
            line;
            bb_temp(d,:)=str2num(line);
            d=d+1;
            
        end  %end if 2
        
    end %end if
    
end %end while

aa(:,1)=(aa_temp(:,1)*(2*pi))/60;
aa(:,2)=aa_temp(:,2);

bb(:,1)=(bb_temp(:,1)*(2*pi))/60;
bb(:,2)=bb_temp(:,2);

generator.mechanical_loss_torque=aa;
generator.torque_behaviour=bb;

fclose(fid);