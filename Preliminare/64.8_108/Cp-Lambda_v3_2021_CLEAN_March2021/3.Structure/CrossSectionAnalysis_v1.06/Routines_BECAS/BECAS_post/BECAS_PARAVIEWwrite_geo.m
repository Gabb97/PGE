function [Filename] = BECAS_PARAVIEWwrite_geo(utils, csprops)
% The csprops arguments is optional!
% Centers are only written to the file if csprops is given


%% Open file
Filename='becas_results.ensi.geo';
fid = fopen(Filename,'w+');

%% Header
fprintf(fid,'BECAS input and result data \n');
fprintf(fid,'nodes and elements \n');
fprintf(fid,'node id off \n');
fprintf(fid,'element id off \n');
fprintf(fid,'part \n');
fprintf(fid,'1 \n');
fprintf(fid,'Nodes and elements \n');
fprintf(fid,'coordinates \n');

%% Node list
fprintf(fid,'%10d \n',utils.nn_2d);
nl_re=reshape(utils.nl_2d(:,2:end),utils.nn_2d,2);
nl_re(:,3)=0;
fprintf(fid,'%12.5e \n',nl_re(:,1));
fprintf(fid,'%12.5e \n',nl_re(:,2));
fprintf(fid,'%12.5e \n',nl_re(:,3));

%% Element list
if(utils.etype == 1)
    fprintf(fid,'quad4 \n');
elseif(utils.etype == 2)
    fprintf(fid,'quad8 \n');
end
fprintf(fid,'%10d \n',utils.ne_2d);
sk = size(utils.mapel_2d(:,2:end));
fprintf(fid,[repmat('%10d\t',1,sk(2)-1) '%10d\n'],utils.mapel_2d(:,2:end).');

%% Write centers, if csprops was given
if nargin > 1

    fprintf(fid,'part \n');
    fprintf(fid,'2 \n');
    fprintf(fid,'origin \n');
    fprintf(fid,'coordinates \n');
    fprintf(fid,'1 \n');
    fprintf(fid,'0.0 \n');
    fprintf(fid,'0.0 \n');
    fprintf(fid,'0.0 \n');
    
    fprintf(fid,'part \n');
    fprintf(fid,'3 \n');
    fprintf(fid,'elastic center \n');
    fprintf(fid,'coordinates \n');
    fprintf(fid,'1 \n');
    fprintf(fid,'%12.8e \n', csprops.ElasticX);
    fprintf(fid,'%12.8e \n', csprops.ElasticY);
    fprintf(fid,'%12.8e \n', 0.0);
    
    fprintf(fid,'part \n');
    fprintf(fid,'4 \n');
    fprintf(fid,'shear center \n');
    fprintf(fid,'coordinates \n');
    fprintf(fid,'1 \n');
    fprintf(fid,'%12.8e \n', csprops.ShearX);
    fprintf(fid,'%12.8e \n', csprops.ShearY);
    fprintf(fid,'%12.8e \n', 0.0);
    
    fprintf(fid,'part \n');
    fprintf(fid,'5 \n');
    fprintf(fid,'mass center \n');
    fprintf(fid,'coordinates \n');
    fprintf(fid,'1 \n');
    fprintf(fid,'%12.8e \n', csprops.MassX);
    fprintf(fid,'%12.8e \n', csprops.MassY);
    fprintf(fid,'%12.8e \n', 0.0);

end

fclose(fid);
end
