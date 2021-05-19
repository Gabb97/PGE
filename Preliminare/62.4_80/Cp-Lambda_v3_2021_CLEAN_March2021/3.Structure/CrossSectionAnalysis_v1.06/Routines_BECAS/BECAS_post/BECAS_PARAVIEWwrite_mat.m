function [ Filename ] = BECAS_PARAVIEWwrite_mat(utils)

%% Open file
Filename='becas_input.ensi.matid';
fid = fopen(Filename,'w+');

%% Header
fprintf(fid,'BECAS material id \n');
fprintf(fid,'part \n');
fprintf(fid,'1 \n');

%% Element list
if(utils.etype == 1)
    fprintf(fid,'quad4 \n');
elseif(utils.etype == 2)
    fprintf(fid,'quad8 \n');
end
fprintf(fid,'%12.5e \n',utils.emat(:,2));

fclose(fid);
end
