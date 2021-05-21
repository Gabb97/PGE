function [usable_height , sensor_height , ii ] = service_routine01( tower_height ,  eta_tower );
%---------------------------------------
%REMARK: In this routine we have not
%considered the presence of point mass
%along the tower structure
%---------------------------------------
ii=1;
for  i = 1 : max(size(tower_height))-1,
    
    if tower_height(i) ~= tower_height(i+1);

        usable_height(ii) = tower_height(i);
        
        ii = ii + 1 ;
        
    end
    
end

usable_height(ii) = tower_height(end);

sensor_height = eta_tower * tower_height(end);
