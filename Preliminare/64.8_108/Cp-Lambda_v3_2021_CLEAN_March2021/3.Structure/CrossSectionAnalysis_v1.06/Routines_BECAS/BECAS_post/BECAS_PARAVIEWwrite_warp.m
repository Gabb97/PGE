function [ Filename ] = BECAS_PARAVIEWwrite_warp(res)

%% Open file
Filename='becas_output.ensi.warp';
fid = fopen(Filename,'w+');

%% Header
fprintf(fid,'BECAS: warping displacements \n');
fprintf(fid,'part \n');
fprintf(fid,'1 \n');
fprintf(fid,'coordinates \n');

%% Node list
res_re=reshape(full(res),3,[])';
fprintf(fid,'%12.5e \n',res_re(:,1));
fprintf(fid,'%12.5e \n',res_re(:,2));
fprintf(fid,'%12.5e \n',res_re(:,3));

fclose(fid);
end
