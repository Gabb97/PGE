function [ Filename ] = BECAS_PARAVIEWwrite_nnum(utils)

%% Open file
Filename='becas_input.ensi.nnum';
fid = fopen(Filename,'w+');

%% Header
fprintf(fid,'BECAS node numbers \n');
fprintf(fid,'part \n');
fprintf(fid,'1 \n');
fprintf(fid,'coordinates \n');

%% Element list
fprintf(fid,'%12.5e \n',utils.nl_2d(:,1));
fclose(fid);
end
