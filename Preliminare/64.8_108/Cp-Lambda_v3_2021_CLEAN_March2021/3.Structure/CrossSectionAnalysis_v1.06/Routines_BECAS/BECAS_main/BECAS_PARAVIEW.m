function BECAS_PARAVIEW( dirname, utils, csprops, warping, strain, stress )
%********************************************************
% File: BECAS_PARAVIEW.m
%   Write BECAS input and result data to several files in EnSight Gold 
%   format. These files can be loaded in Paraview in order to
%   visualize:
%       * Mesh
%       * Material Assignment
%       * Material Orientation
%       * Element Numbers
%       * Node Numbers
%       * Elastic Center, Shear Center, Mass Center
%       * Warping Displacements
%       * Stresses and Strains
%   The first argument is the name of the directory to which the
%   EnSight files should be written. If the directory exists, it
%   is deleted!
%
% Syntax:
%   BECAS_PARAVIEW( dirname, utils, csprops, warping, strain, stress )
%
% The first two arguments (dirname and utils) are required,
% the rest is optional! The number of EnSight files produced and the amount
% of data written depends on the number of input arguments provided.
%
% Date:
%   Version 1.0    26.09.2012   Robert Bitsche and José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************
fprintf(1,'> Started output results to PARAVIEW...');

oridir = pwd;

% If paraview output directory exists, delete it and create a new one.
if exist(fullfile(pwd,dirname),'dir') > 1
    rmdir(dirname,'s');
end;
mkdir(dirname);
cd(dirname);

% open the .case-file
case_filename = 'becas_results.case';
fid = fopen(case_filename,'w+');


%% The following is always written:

% Write geometry file (nodes and elements) and centers (if given)
if nargin > 2
    geo_file = BECAS_PARAVIEWwrite_geo(utils, csprops);
else
    geo_file = BECAS_PARAVIEWwrite_geo(utils);
end
% Write material id numbers to a file
matid_file = BECAS_PARAVIEWwrite_mat(utils);
% Write element numbers to a file
enum_file = BECAS_PARAVIEWwrite_enum(utils);
% Write node numbers to a file
nnum_file = BECAS_PARAVIEWwrite_nnum(utils);
% Write material orientation information to 3 individual file
[ori1_file, ori2_file, ori3_file] = BECAS_PARAVIEWwrite_ori(utils);

% Write to the .case file
fprintf(fid,'FORMAT\n');
fprintf(fid,'type: ensight gold\n');
fprintf(fid,'GEOMETRY\n');
fprintf(fid,'model: %s\n', geo_file);
fprintf(fid,'VARIABLE\n');
fprintf(fid,'scalar per element: material_id %s\n', matid_file);
fprintf(fid,'vector per element: material_ori_1 %s\n', ori1_file);
fprintf(fid,'vector per element: material_ori_2 %s\n', ori2_file);
fprintf(fid,'vector per element: material_ori_3 %s\n', ori3_file);
fprintf(fid,'scalar per node: nodenumbers %s\n', nnum_file);
fprintf(fid,'scalar per element: elementnumbers %s\n', enum_file);

%% Write only if centers are given
if nargin>2
    [axis1_file, axis2_file] = BECAS_PARAVIEWwrite_el_axes(utils, csprops);
    % Add to the .case file
    fprintf(fid,'vector per node: elastic_axis_1  %s\n', axis1_file);
    fprintf(fid,'vector per node: elastic_axis_2  %s\n', axis2_file);
end

%% Write only if warping displacements are given
if nargin>3
    warp_file = BECAS_PARAVIEWwrite_warp( warping );
    % Add to the .case file
    fprintf(fid,'vector per node: warping %s\n',warp_file);
end

%% Write only if strains are given
if nargin>4
    if size(strain,2) ~= 6
        fprintf(1,'Error: Function BECAS_PARAVIEW expects one strain tensor per element\n');
        return;
    end
    BECAS_PARAVIEWwrite_strain(utils, strain );
    fprintf(fid,'scalar per element: strain11  becas_output.ensi.strain11\n');
    fprintf(fid,'scalar per element: strain22  becas_output.ensi.strain22\n');
    fprintf(fid,'scalar per element: strain33  becas_output.ensi.strain33\n');
    fprintf(fid,'scalar per element: strain12  becas_output.ensi.strain12\n');
    fprintf(fid,'scalar per element: strain13  becas_output.ensi.strain13\n');
    fprintf(fid,'scalar per element: strain23  becas_output.ensi.strain23\n');
end


%% Write only if stresses are given
if nargin>5
    if size(stress,2) ~= 6
        fprintf(1,'Error: Function BECAS_PARAVIEW expects one stress tensor per element\n');
        return;
    end
    BECAS_PARAVIEWwrite_stress(utils, stress );
    fprintf(fid,'scalar per element: stress11  becas_output.ensi.stress11\n');
    fprintf(fid,'scalar per element: stress22  becas_output.ensi.stress22\n');
    fprintf(fid,'scalar per element: stress33  becas_output.ensi.stress33\n');
    fprintf(fid,'scalar per element: stress12  becas_output.ensi.stress12\n');
    fprintf(fid,'scalar per element: stress13  becas_output.ensi.stress13\n');
    fprintf(fid,'scalar per element: stress23  becas_output.ensi.stress23\n');
end

fclose(fid);
cd(oridir);

fprintf(1,'DONE! \n');

end

