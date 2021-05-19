function matrix = read_matrix_from_txt_file( txt_file_name )

fid = fopen( txt_file_name , 'r' );

if (fid<0)
    fprintf('\n *** ERROR: [%s] file not fountd!\n',txt_file_name);
    matrix = [];
    return
end

cont = 0;

while feof(fid) == 0 ,
    
    line = fgetl(fid);
    
    check_spaced_line = size(deblank(line));
    
    if ( isempty(line) == false & line(1) ~= '%' & check_spaced_line(1) ~= 0 ),
        
        cont = cont + 1 ;
        
        line_num=str2num(line);
      
        temp_data(cont,:) = line_num;        
            
        end
        
    end    

matrix = temp_data;

fclose(fid);