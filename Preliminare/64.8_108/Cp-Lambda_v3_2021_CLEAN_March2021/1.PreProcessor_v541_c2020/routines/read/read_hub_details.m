function [hub] = read_hub_details(PathStruct)

%--------------------------------------------------
%  This function reads the hub details from a 
%  suitable file which contains the BLADED's data.
%  After this, it returns the hub structure whose
%  filed are:
%
%            -hub_height;
%            -offset_from_tower_centre;
%            -tilt_from_horizontal;
%            -overhang;
%            -spinner_diameter;
%            -root_radial_position;
%            -piece_diameter;
%            -mass;
%            -mass_centre;
%            -J_lss;
%            -frame_origin = is a vector which contain 
%                             the coordinates of the 
%                             frame origin with respect 
%                             the inertial reference.
%
%            -frame_e2     = e2 director cosine;
%
%            -frame_e3     = e3 director cosine;
%
%--------------------------------------------------

% disp(' *** Reading hub_details.txt');


%%%ALEALE 14.may.2008
hub_details = read_matrix_from_txt_file(strcat(PathStruct.FullPathInputDir,'\hub_details.txt'));

R1 = rot_o( [hub_details(3)*(pi/180)] * [ 0 ; 0 ; 1 ] );

%Hub structure pre-allocation and definitions
hub = struct ('hub_height'                , hub_details (1) ,...
              'offset_from_tower_centre'  , 0,...                           % This was the 2nd entry of the list, now I've made it the tower height so I assume the offset is alway zero LS
              'tower_height'              , hub_details(2) ,...             % New entry #LS
              'tilt_from_horizontal_rad'  , hub_details(3)*(pi/180) ,...
              'tilt_from_horizontal_grad' , hub_details(3) ,...             % New entry #LS
              'overhang'                  , hub_details(4) ,...
              'spinner_diameter'          , hub_details(5) ,...
              'root_radial_position'      , hub_details(6) ,...
              'piece_diameter'            , hub_details(7) ,...
              'mass'                      , hub_details(8) ,...
              'mass_centre'               , hub_details(9) ,...
              'J_lss'                     , hub_details(10) ,...
              'cone_angle'                , hub_details(11) ,...
              'blade_set_angle'           , hub_details(12)*(pi/180) ,...
              'rotor_diameter'            , hub_details(13) ,...
              'number_of_blades'          , hub_details(14) ,...
              'extension_drag'            , hub_details(15) ,...
              'e2'                        , R1(:,2) ,...
              'e3'                        , R1(:,3) ,...
              'R1'                        , R1);
          
% Compute hub frame origin from available information #LS
hub.frame_origin =  [hub.hub_height  -hub.overhang    hub.offset_from_tower_centre];
%--------------------------------------------------------------------------
