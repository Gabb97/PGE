function [R] = rotation_matrix ( i , nentries , twist_rad, vect )

%---------------------------------------------------------------------
% This function evaluate the rotatin matrix for each station of 
% the i-th blade
% 
%   Syntax:
%           -function [R] = rotation_matrix ( i , nentries , twist_rad );
%
%   Input:
%           -i = number of the sub blade;
%           -nentries = vector which contain the number of entries for 
%                       each sub blade;
%           -twist_rad = matrix which contain the twist angle (rad) for
%                        the section fo each sub blade;
%   
%   Output:
%          -R = rotation matrix. This is an array of matrix which contains 
%                                the e1 , e2 & e3 orientation of each section;     
%
%-----------------------------------------------------------------------

% e1 = [ 1 ; 0 ; 0 ];

for itriad = 1 : nentries(i),   
    
    rot_twist ( : , : , itriad ) = rot_o( twist_rad( itriad , i ) * vect );
    
end

R = rot_twist;
