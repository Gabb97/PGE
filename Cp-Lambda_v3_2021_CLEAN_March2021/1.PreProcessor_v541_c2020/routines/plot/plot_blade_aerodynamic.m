function  plot_blade_aerodynamic ( section_distance_from_root , section_chord , section_pitch_axis , local_Ca );

num = max(size(section_distance_from_root));

for i = 1 : num,
    
    if i == 1,        
        
        pt(i) = 0 ;                
               
    elseif i == num,
        
        pt(i) = section_distance_from_root(i) - (section_distance_from_root(i) - section_distance_from_root(i-1))/2;
        pt_1 = section_distance_from_root(i);       
         
     else
         
         pt(i) = section_distance_from_root(i) - ((section_distance_from_root(i) - section_distance_from_root(i-1))/2);         
         
     end
                           
end


eta = [ section_distance_from_root/section_distance_from_root(end)]' ;

plot_aerodynamic_blade( section_pitch_axis , section_chord , section_distance_from_root , pt , pt_1 , local_Ca , 'c' );

