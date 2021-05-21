function [tower] = read_tower_details(PathStruct)

%----------------------------------------------------------------------
%  This function read the tower geometric , inertial and elastic 
%  properties from bladed output and return the tower structure 
%  as follow:
%
%  Syntax:
%          -function [tower] = read_tower_details
%
%  Output:
%         -tower = it is a structure and its field are:
%                    tower.cd
%                    tower.station_number     
%                    tower.height
%                    tower.diameter
%                    tower.wall_thickness
%                    tower.material
%                    tower.mass_unit_length
%                    tower.bending_stiffness
%                    tower.end_point0
%                    tower.end_point1
%                    tower.density
%                    tower.nentries
%                    tower.npoint
%
%----------------------------------------------------------------------
% I need to know the dimensional tower heigth LS
[hub] = read_hub_details(PathStruct);

% tower_details = read_matrix_from_txt_file('input\tower_and_foundations_details.txt');
tower_details = read_matrix_from_txt_file(strcat(PathStruct.FullPathInputDir,'\tower_and_foundations_details.txt'));

local_a = size(tower_details(2:end,1));

temp = size(tower_details);

%--------------------------------------------------------------------------
%Tower structure allocation and fileds definition
tower = struct ( 'cd'                       ,  tower_details(1,1)  , ...
                 'foundations'              ,  tower_details(1,3:end-1),...
                 'station_number'           ,  tower_details(2:end,1) , ...
                 'nondimensional_height'    ,  tower_details(2:end,2) , ...                         % nondimensional height of tower segments #LS 19.03.2020
                 'height'                   ,  tower_details(2:end,2).*hub.tower_height , ...       % dimensional height of tower segments              
                 'diameter'                 ,  tower_details(2:end,3) , ...
                 'wall_thickness'           ,  tower_details(2:end,4) , ...
                 'material'                 ,  tower_details(2:end,5) , ...
                 'mass_unit_length'         ,  tower_details(2:end,6) , ...
                 'bending_stiffness'        ,  tower_details(2:end,7) , ...
                 'torsional_stiffness'      ,  tower_details(2:end,8) , ...
                 'E_modul'                  ,  tower_details(1,end)   , ...
                 'G_modul'                  ,  [], ...
                 'Jp'                       ,  [] , ...
                 'nondimensional_end_point0'               ,  [tower_details(2,2) 0 0 ] , ...   % I change this to 'nondimensional', but this is not used.. #LS
                 'nondimensional_end_point1'               ,  [tower_details(end,2) 0 0 ] , ... % I change this to 'nondimensional', but this is not used.. #LS
                 'density'                  ,  tower_details(1,2) , ...
                 'nentries'                 ,  local_a(1) , ...
                 'npoint'                   ,  [] , ...
                 'sections_area'            ,  []);
       

             
%--------------------------------------------------------------------------

% Ale. 04.feb.05 the old version was:
%                 'G_modul'             ,  tower_details(1,end)   , ...
% Now:
%                 'E_modul'             ,  tower_details(1,9)   , ...
%                 'G_modul'             ,  [], ...

