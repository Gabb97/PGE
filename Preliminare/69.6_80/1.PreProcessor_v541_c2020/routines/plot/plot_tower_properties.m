function plot_tower_properties ( tower );

%----------------------------------------------
%  This function plots all the tower inertial,
%  geometrical and elastic properties.
%
%  Syntax:
%       -plot_tower_properties(tower);
%
%  Input:
%       - tower : it is a Matlab structure which
%                 fields define all the details 
%                 about the tower.
%
%  Output:
%      - NONE : within this function no output
%               are required;
%---------------------------------------------

% Added by Ale . 16.feb.05
str1=' MASS / UNIT LENGTH - TOWER TOTAL MASS=';
mass=num2str(tower.total_mass);
str2='[Kg]';
title_temp=strcat(str1,mass,str2);
std_graph( 1 , title_temp , 'TOWER HEIGHT [m]' , 'MASS UNIT LENGTH [Kg/m]' , tower.mass_unit_length , tower.height , '-dg' , 2 );
%
% std_graph( 1 , 'MASS UNIT LENGTH' , 'TOWER HEIGHT [m]' , 'MASS UNIT LENGTH [Kg/m]' , tower.mass_unit_length , tower.height , '-dg' , 2 );

std_graph( 2 , 'BENDING STIFFNESS' , 'TOWER HEIGHT[m]' , 'STIFFNESS [Nm^2]' , tower.bending_stiffness , tower.height , '-dg' , 2 );

std_graph( 3 , 'TORSIONAL STIFFNESS' , 'TOWER HEIGHT[m]' , 'STIFFNESS [Pa*m^4]' , tower.torsional_stiffness , tower.height , '-dg' , 2 );

std_graph( 4 , 'DIAMETER' , 'TOWER HEIGHT [m]' , 'DIAMETER [m]' , tower.diameter , tower.height , '-dg' , 2 );

std_graph( 5 , 'WALL THICKNESS' , 'TOWER HEIGHT [m]' , 'WALL THICKNESS [mm]' , tower.wall_thickness , tower.height , '-dg' , 2 );




while 1 ;    
    graph_choice = menu ('SELECT' ,...
        ' TOWER MASS UNIT LENGTH ' ,...
        ' TOWER BENDING STIFFNESS ' ,...
        ' TOWER TORSIONAL STIFFNESS' , ...
        ' TOWER DIAMETER ' ,...
        ' TOWER WALL THICKNESS ' ,...
        ' EXIT ',...
        ' EXIT & CLOSE ALL');
    
    if graph_choice < 6;
        figure(graph_choice);
    elseif graph_choice == 6;
        break;
    else
        for i=1:5;
            close (figure(i));
        end
        break;
    end
    
end