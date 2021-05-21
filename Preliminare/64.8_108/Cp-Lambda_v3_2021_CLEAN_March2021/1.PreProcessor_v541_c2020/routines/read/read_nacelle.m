function [nacelle] = read_nacelle(nacelle_npoint,PathStruct);

%---------------------------------------------------------------
%  This function after having reads the nacelle details
%  from the nacelle_details.txt Bladed software report file,
%  returns the 'nacelle' matlab structure as follow.
%
%  Input : 
%        -nacelle = It is a number necessary to define the 
%                   connection between the nacelle and the tower.
%
%  Output:
%  -'nacelle' structure composed as follows:
%
%             -width   =  nacelle width;
%             -length  =  nacelle length;
%             -height  =  nacelle height;
%             -cd      =  nacelle drag coefficient;
%             -mass    =  nacelle mass;
%             -lateral =  nacelle cg lateral offset;
%             -above   =  nacelle cg above tower top;
%             -front   =  nacelle cg in front of
%                         tower axis;
%             -J_yaw   =  nacelle yaw inertia;
%             
%  Remark: for more details about the previous data
%          see the nacelle_details.txt file.
%
%---------------------------------------------------------------


%%%ALEALE 14.may.2008
% nacelle_details = read_matrix_from_txt_file('input\nacelle_details.txt');
nacelle_details = read_matrix_from_txt_file(strcat(PathStruct.FullPathInputDir,'\nacelle_details.txt'));

%--------------------------------------------------------
%Nacelle structure pre-allocation and fileds definitions
nacelle = struct ( 'width'  , nacelle_details(1) , ...
                   'length' , nacelle_details(2) , ...
                   'height' , nacelle_details(3) , ...
                   'cd'     , nacelle_details(4) , ...
                   'mass'   , nacelle_details(5) , ...
                   'lateral', nacelle_details(6) , ...
                   'above'  , nacelle_details(7) , ...
                   'front'  , nacelle_details(8) , ...
                   'J_yaw'  , nacelle_details(9) , ...
                   'npoint' , [nacelle_npoint]);
%-----------------------------------------------------------