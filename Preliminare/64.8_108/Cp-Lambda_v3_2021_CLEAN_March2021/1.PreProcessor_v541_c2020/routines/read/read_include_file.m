function read_include_file(PathStruct);

% fprintf('\n *** Reading [%s] file\n',strcat(PathStruct.FullPathInputDir,'\dat_files_names.txt'));

fid=fopen(strcat(PathStruct.FullPathInputDir,'\dat_files_names.txt'),'r');
   
if (fid<0)
    fprintf('\n *** ERROR: [%s] file not fountd!\n',strcat(PathStruct.FullPathInputDir,'\dat_files_names.txt'));
    return
end

    

i=0;

while feof(fid) == 0 ,
     
    line_temp = fgetl(fid);
    check_spaced_line = size(line_temp);
    
    if (isempty(line_temp) == false & line_temp(1) ~= '%' & check_spaced_line(1) ~= 0 ),
        
        i = i + 1 ;
        
        line = strjust(line_temp , 'left');
        
        switch i 
            
            case 1  % blade
                
                dat_file_name=strvcat(line);
                
            case 2  % tower
                
                dat_file_name=strvcat(dat_file_name,line);
                
            case 3  % hub
                
                dat_file_name=strvcat(dat_file_name,line);
                
            case 4  % sensors
                
                dat_file_name=strvcat(dat_file_name,line);
                
            case 5  % airtable
                
                dat_file_name=strvcat(dat_file_name,line);
                
            case 6  % blade point masses
                
                dat_file_name=strvcat(dat_file_name,line);
                
%             case 7  % copy
%                 
%                 dat_file_name=strvcat(dat_file_name,line);
%                 
            case 7  % drive trainn
                
                dat_file_name=strvcat(dat_file_name,line);
                
            case 8  % lifting line blade
                
                dat_file_name=strvcat(dat_file_name,line);                
                
            case 9  % lifting line hub
                
                dat_file_name=strvcat(dat_file_name,line);
                
            case 10  % lifting line tower
                
                dat_file_name=strvcat(dat_file_name,line);
                
            case 11  % nacelle 
                
                dat_file_name=strvcat(dat_file_name,line);
                
            case 12  % rotor frame
                
                dat_file_name=strvcat(dat_file_name,line);
                
            case 13  % rvj pitch control
                
                dat_file_name=strvcat(dat_file_name,line);
                
            case 14  % rvj yaw control
                
                dat_file_name=strvcat(dat_file_name,line);
                
            case 15  % rigid rotation 
                
                dat_file_name=strvcat(dat_file_name,line);                

            case 16  % inflow
         
                dat_file_name=strvcat(dat_file_name,line);                                
        
%             case 17  % relative path name
% 
%                 dat_file_name=strvcat(dat_file_name,line);                                
        
         end    

    end
    
end

fclose(fid);

% Set working dir
dat_file_name=strvcat(dat_file_name,PathStruct.FullPathWorkDir);
% 

save routines\names\dat_file_names dat_file_name
