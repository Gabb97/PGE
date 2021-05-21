function [Filename1, Filename2] = BECAS_PARAVIEWwrite_el_axes(utils, csprops)

%% Compute vectors
% Scale with characteristic model size

maxx = max(utils.nl_2d(:,2)) - min(utils.nl_2d(:,2));
maxy = max(utils.nl_2d(:,3)) - min(utils.nl_2d(:,3));
char_length_model = max(maxx,maxy);

vec1 = [ cos(csprops.AlphaPrincipleAxis_ElasticCenter);
         sin(csprops.AlphaPrincipleAxis_ElasticCenter) ] * char_length_model;
    
vec2 = [ cos(csprops.AlphaPrincipleAxis_ElasticCenter+pi/2);
         sin(csprops.AlphaPrincipleAxis_ElasticCenter+pi/2) ] * char_length_model;
    
%% Write to files

Filename1='becas_output.ensi.el_axis1';
fid = fopen(Filename1,'w+');
     
fprintf(fid,'BECAS: elastic axis 1 \n');
fprintf(fid,'part \n');
fprintf(fid,'3 \n');
fprintf(fid,'coordinates \n');
fprintf(fid,'%14.8e \n', vec1(1));
fprintf(fid,'%14.8e \n', vec1(2));
fprintf(fid,'0.0 \n');

fclose(fid);

Filename2='becas_output.ensi.el_axis2';
fid = fopen(Filename2,'w+');
     
fprintf(fid,'BECAS: elastic axis 2 \n');
fprintf(fid,'part \n');
fprintf(fid,'3 \n');
fprintf(fid,'coordinates \n');
fprintf(fid,'%14.8e \n', vec2(1));
fprintf(fid,'%14.8e \n', vec2(2));
fprintf(fid,'0.0 \n');

fclose(fid);

end
