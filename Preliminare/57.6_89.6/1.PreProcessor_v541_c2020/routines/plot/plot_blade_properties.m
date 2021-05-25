function plot_blade_properties( blade ),

%---------------------------------------------------------
%  This function allow the visualization of the
%  geometrical, inertial and elastic properties
%  of the blade element.
%
%  Syntax:
%         -plot_blade_properties( blade )
%
%  Input:
%        -blade  =  it is a structure which contain 
%                   all the blade details for the 
%                   multibody model ( for more details
%                   see the read_blade function);
%
%----------------------------------------------------------



pt_te = -( blade.chord .* (blade.pitch_axis/ 100));
pt_le = blade.chord + pt_te;

std_graph( 1 , ' BLADE CHORD DISTRIBUTION ' , ' BLADE SPAN [m]' , ' CHORD [m]' , blade.distance_from_root , pt_te , '-rs' , 2 );
pa = plot( [0.0 blade.distance_from_root(end)], [ 0 0 ] , '-k' );
set (pa,'LineWidth',2.0);
le = plot(blade.distance_from_root , pt_le , '-rs' );
set (le,'LineWidth',2.0);
for i=1:max(size(blade.chord)),
    hc = plot([blade.distance_from_root(i) blade.distance_from_root(i)],[pt_te(i) pt_le(i)],'-r');
    set (hc,'LineWidth',2.0);
end
axis equal
axis([-2 blade.distance_from_root(end)+2  min(pt_te)-3 max(pt_le)+3])


std_graph ( 2 , ' BLADE CHORD DISTRIBUTION ' , ' BLADE SPAN [m] '  , ' CHORD [m] ' ,...
           blade.distance_from_root , blade.chord ,...
           '-bs' , 2 );

std_graph ( 3 , ' TWIST DISTRIBUTION ' , ' TWIST [deg] ' , ' BLADE SPAN [m] ' ,...
           blade.distance_from_root , blade.twist ,...
           '-bs' , 2 );      
       
std_graph ( 4 , ' THICKNESS DISTRIBUTION ' , ' THICKNESS [%CHORD] ' , ' BLADE SPAN [m] ' ,...
            blade.distance_from_root , blade.thickness ,...
            '-bs' , 2 );

std_graph ( 5 , ' PITCH AXIS ' , ' PITCH AXIS [%CHORD] ' , ' BLADE SPAN [m] ' ,...
            blade.distance_from_root , blade.pitch_axis ,...
            '-bs' , 2 );

std_graph ( 6 , ' PRE-BEND DISTRIBUTION ' , ' PRE-BEND FROM PITCH AXIS [m] ' , ' BLADE SPAN [m] ' ,...
            blade.distance_from_root , blade.pre_bend ,...
            '-bs' , 2 );

if blade.chord_stiffness < 1E+11;        
    std_graph ( 7 , ' STIFFNESS ABOUT CHORD ' , ' STIFFNESS [N*m] ' , ' BLADE SPAN [m] ' ,...
                blade.distance_from_root , blade.chord_stiffness ,...
               '-bs' , 2 );
end

if blade.bending_stiffness <1E+11;
    std_graph ( 8 , ' STIFFNESS PERPENDICULAR TO CHORD ' , ' STIFFNESS [N*m] ' , ' BLADE SPAN [m] ' ,...
                blade.distance_from_root , blade.bending_stiffness ,...
                '-bs' , 2 );
end

std_graph ( 9 , ' CENTRE OF MASS FROM PITCH AXIS ' , ' CENTRE OF MASS FROM PITCH AXIS [%CHORD] ' , ' BLADE SPAN [m] ' ,...
            blade.distance_from_root , blade.centre_of_mass ,...
            '-bs' , 2 );

        
str1=' MASS / UNIT LENGTH - BLADE TOTAL MASS=';
mass=num2str(blade.total_mass);
str2='[Kg]';
title_temp=strcat(str1,mass,str2);

std_graph ( 10 , title_temp , ' MASS / UNIT LENGTH [Kg/m] ' , ' BLADE SPAN [m] ' ,...
            blade.distance_from_root , blade.mass_unit_length ,...
            '-bs' , 2 );

% These two plots are added 04.feb.05 By Ale        
std_graph ( 11 , ' MOMENT OF INERTIA ' , ' MOMENT OF INERTIA ALONG PITCH AXIS/ UNIT LENGTH [Kg*m] ' , ' BLADE SPAN [m] ' ,...
            blade.distance_from_root , blade.moment_of_inertia ,...
            '-bs' , 2 );

std_graph ( 12 , ' TORSIONAL RIGIDITY ' , ' TORSIONAL RIGIDITY [N*m^2] ' , ' BLADE SPAN [m] ' ,...
            blade.distance_from_root , blade.torsional_rigidity ,...
            '-bs' , 2 );

        
        
while 1 ;    
    graph_choice = menu ('SELECT',...
        ' BLADE CHORD DISTRIBUTION ',...
        ' BLADE CHORD DISTRIBUTION ',...
        ' TWIST DISTRIBUTION ',...
        ' THICKNESS DISTRIBUTION ',...
        ' PITCH AXIS ',...
        ' PRE-BEND DISTRIBUTION ',...
        ' STIFFNESS ABOUT CHORD ',...
        ' STIFFNESS PERPENDICULAR TO CHORD ',...
        ' CENTRE OF MASS FROM PITCH AXIS ',...
        ' MASS / UNIT LENGTH ',...
        ' MOMENT OF INERTIA ',...
        ' TORSIONAL RIGIDITY ',...
        ' EXIT ',...
        ' EXIT & CLOSE ALL');
    
    if graph_choice < 13;
        figure(graph_choice);
    elseif graph_choice == 13;
        break;
    else
        for i=1:12;
            close (figure(i));
        end
        break;
    end
    
end
    