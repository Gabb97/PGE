function BECAS_PARAVIEWwrite_stress(utils, stress)

tensor_indices = {'11' '22' '12' '13' '23' '33'};

for i=1:6
    
    % Open file
    filenames{i}=sprintf('becas_output.ensi.stress%s',tensor_indices{i});
    fid = fopen(filenames{i},'w+');
    
    % Header
    fprintf(fid,'BECAS stress%s \n',tensor_indices{i});
    fprintf(fid,'part \n');
    fprintf(fid,'1 \n');
    
    % Element type
    if(utils.etype == 1)
        fprintf(fid,'quad4 \n');
    elseif(utils.etype == 2)
        fprintf(fid,'quad8 \n');
    end
    
    % Data
    fprintf(fid, '%12.6e \n',stress(:,i));
    
    fclose(fid);

end

end
