function [point_mass] = read_point_mass(blade,PathStruct);

%---------------------------------------------------------------------
% This function reads the point mass table as provided by Bladed output
% 
%   Syntax:
%           -function [point_mass] = read_point_mass;
%
%   Input:
%           -none;
%   
%   Output:
%           -point_mass = is a structure with field:
%                         point_mass.position = disance from blade root
%                                               of the mass;
%                         point_mass.mass   =  total mass ;
%                         point_mass.chord  =  point mass chord offset;
%                         point_mass.number =  number of point mass;
%
%-----------------------------------------------------------------------

%%%ALEALE 14.may.2008
% point_masses = read_matrix_from_txt_file('input\point_masses.txt');
point_masses = read_matrix_from_txt_file(strcat(PathStruct.FullPathInputDir,'\point_masses.txt'));

%Point masses structure fields definition and pre-allocation
point_mass = struct ('position' , point_masses(:,1).*blade.blade_length ,...  % I need to restore dimensional values here. I round at the 2nd decimal digit. #LS 19.03.2020
                     'chord'    , point_masses(:,2) ,...
                     'mass'     , point_masses(:,3) ,...
                     'number'   , max(size(point_masses(:,1))));                

                 
                 