function BECAS_BECAStoVABS(utils, VABSfilename)
%********************************************************
% File: BECAS_BECAStoVABS.m
%   Generate a VABS input file from BECAS input
%   
% Syntax:
%   BECAS_BECAStoVABS ( utils, VABSfilename )
%
% Revisions:
%   Version 1.0    25.09.2012   Robert Bitsche
%
% (c) DTU Wind Energy
%********************************************************

fid = fopen(VABSfilename,'w+');

nn = size(utils.nl_2d,1);     % number of nodes
ne = size(utils.el_2d,1);     % number of elements
nm = size(utils.matprops,1);  % number of materials

fprintf(fid,'0 0\n');
fprintf(fid,'1 0 0\n');
fprintf(fid,'0 0 0 0\n\n');

fprintf(fid,'%d %d %d\n\n',[nn ne nm]);

nnl=1:nn;
for i=1:nn
    fprintf(fid,'%10d  % 12.8e  % 12.8e\n',[i utils.nl_2d(i,2:end)]);
end

if size(utils.mapel_2d,2)==5
for i=1:ne
    fprintf(fid,'%10d %10d %10d %10d %10d',utils.mapel_2d(i,:));
    fprintf(fid,'%10d %10d %10d %10d %10d\n',[0 0 0 0 0]);  % one more zero
end
else
for i=1:ne
    fprintf(fid,'%10d %10d %10d %10d %10d %10d %10d %10d %10d ',utils.mapel_2d(i,:));
    fprintf(fid,'%10d\n',0);  % one more zero
end
end

for i=1:ne
    fprintf(fid,'%10d %10d % 10g % 10g ',[i utils.emat(utils.mapel4mat(utils.el_2d(i,1)),2:end)]);
    fprintf(fid,'%6d %6d %6d %6d %6d %6d %6d %6d \n',[540 0 0 0 0 0 0 0]);
end

for i=1:nm
    fprintf(fid,'%6d    1\n',i);
    fprintf(fid,'% 14.8g  % 14.8g  % 14.8g\n',utils.matprops(i,1:3));
    fprintf(fid,'% 14.8g  % 14.8g  % 14.8g\n',utils.matprops(i,4:6));
    fprintf(fid,'% 14.8g  % 14.8g  % 14.8g\n',utils.matprops(i,7:9));
    fprintf(fid,'% 14.8g\n',utils.matprops(i,10));
end

fclose('all');