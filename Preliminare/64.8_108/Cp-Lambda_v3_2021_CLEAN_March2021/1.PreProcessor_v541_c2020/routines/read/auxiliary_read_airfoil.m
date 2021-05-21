function airfoil=auxiliary_read_airfoil( airfoil , airfoil_txt , i );

fid = fopen( airfoil_txt , 'r' );

cont_1 = 0;
cont_2 = 1;

while feof(fid) == 0 ,
    
    line = fgetl(fid);
    
    check_spaced_line = size(deblank(line));
    
    if ( isempty(line) == false & line(1) ~= '%' & check_spaced_line(1) ~= 0 ),
        
        cont_1 = cont_1 + 1 ;
        
        if ( cont_1 <=2 ),
            
            switch cont_1,
                
                case 1
                    
                    line_num=str2num(line);
                    airfoil.name(i) = line_num(1);
                    
                case 2
                    
                    line_num=str2num(line);
                    airfoil.reference{i} = line_num;
                    
            end
            
        else            
            
            line_num=str2num(line);
            temp_data_set(cont_2,:) = line_num;
            cont_2 = cont_2 + 1;
            
        end
        
    end
    
end

airfoil.data_set{i} = temp_data_set;

fclose(fid);