function plot_aerodynamic_blade( section_pitch_axis , section_chord , section_distance_from_root , pt , pt_1 , local_Ca , rot_sense_flag );

%--------------------------------------------------
%  This function allows the visualization of some
%  of the details concerned the multibody model 
%  of the blade's lifting line.
%---------------------------------------------------


%---------------------------------------------------
% This s define if the blade has a rotational sense
% clockwise (c) or anticlockwise (a).
% REMARK: untill now, we have considered upwind
% rotor only!!!
%---------------------------------------------------
if rot_sense_flag == 'a',
    s=1;
else
    s=-1;
end
%---------------------------------------------------

std_graph( 101 , 'Blade aerodynamics features' , 'Distance from Pitch Axis [m]' , 'Distance from Blade Root [m]' , section_distance_from_root , ...
          zeros(1,max(size(section_distance_from_root))) , ':k' , 2 );
      
axis equal
axis ([0 max(section_distance_from_root)+1  -4 4 ])

pt_leading_edge = section_chord .* (section_pitch_axis/100);
pt_trailing_edge = -1 * ( section_chord - pt_leading_edge); 

pt_ca = pt_leading_edge' - ( (local_Ca/100) .* section_chord' );

hp_ca = plot( section_distance_from_root , s * pt_ca , 'o' );
set (hp_ca,'LineWidth', 2 );
legend('Feathering Axis','Aerodynamic centers');


hp = plot ( section_distance_from_root, s*pt_leading_edge ,'-r',section_distance_from_root, s*pt_trailing_edge ,'-r' );
set (hp,'LineWidth', 3 );

pt_temp = [pt pt_1];


for i = 1 : max(size(section_chord)),
    
    hp_s = plot( [pt_temp(i) pt_temp(i)] , s * [pt_trailing_edge(i)*1.15 pt_leading_edge(i)*1.15] , ':m');
    set (hp_s,'LineWidth', 2 );
    
end