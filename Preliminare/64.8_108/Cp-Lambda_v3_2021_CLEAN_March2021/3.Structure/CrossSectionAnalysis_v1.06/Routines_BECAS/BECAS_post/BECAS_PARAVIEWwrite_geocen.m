function [Filename] = BECAS_PARAVIEWwrite_geocen(csprops)

%% Open file
Filename='becas_output_centers.ensi.geo';
fid = fopen(Filename,'w+');

%% Header
fprintf(fid,'BECAS: centers \n');
fprintf(fid,'origin, elastic center, shear center, mass center \n');
fprintf(fid,'node id off \n');
fprintf(fid,'element id off \n');

fprintf(fid,'part \n');
fprintf(fid,'1 \n');
fprintf(fid,'origin \n');
fprintf(fid,'coordinates \n');
fprintf(fid,'1 \n');
fprintf(fid,'0.0 \n');
fprintf(fid,'0.0 \n');
fprintf(fid,'0.0 \n');

fprintf(fid,'part \n');
fprintf(fid,'2 \n');
fprintf(fid,'elastic center \n');
fprintf(fid,'coordinates \n');
fprintf(fid,'1 \n');
fprintf(fid,'%12.8e \n', csprops.ElasticX);
fprintf(fid,'%12.8e \n', csprops.ElasticY);
fprintf(fid,'%12.8e \n', 0.0);

fprintf(fid,'part \n');
fprintf(fid,'3 \n');
fprintf(fid,'shear center \n');
fprintf(fid,'coordinates \n');
fprintf(fid,'1 \n');
fprintf(fid,'%12.8e \n', csprops.ShearX);
fprintf(fid,'%12.8e \n', csprops.ShearY);
fprintf(fid,'%12.8e \n', 0.0);

fprintf(fid,'part \n');
fprintf(fid,'4 \n');
fprintf(fid,'mass center \n');
fprintf(fid,'coordinates \n');
fprintf(fid,'1 \n');
fprintf(fid,'%12.8e \n', csprops.MassX);
fprintf(fid,'%12.8e \n', csprops.MassY);
fprintf(fid,'%12.8e \n', 0.0);

fclose(fid);
end
