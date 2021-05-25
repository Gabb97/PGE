function [nentries_blade] = find_nentries(blade , point_mass , np )

%---------------------------------------------------------------------
% This function define the number of entries for the i-th blade
% 
%   Syntax:
%           -function [nentries_blade] = find_nentries(blade , point_mass , np )
%
%   Input:
%           -blade;
%           -point;
%           -np = number fo point mass;
%   
%   Output:
%           -netries_blade = is a vector containing the number of entries
%                            for each blade;
%
%-----------------------------------------------------------------------

ii = 1;

while 1;
    
    test(ii) = blade.distance_from_root(ii) - point_mass.position(np);
    
    if test(ii)>=0;
        
        nentries_blade(1) = ii;
        
        if np == 1;            
            nentries_blade(2) = max(size(blade.distance_from_root))-ii + 2 ;                                   
        end
        
        break;        
        
    end
    
    ii = ii + 1;
end
