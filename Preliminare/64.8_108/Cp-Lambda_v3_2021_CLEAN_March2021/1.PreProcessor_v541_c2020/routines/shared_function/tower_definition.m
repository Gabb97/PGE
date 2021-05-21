function [tower] = tower_definition(tower);

%-------------------------------------------------------------------
%  This functon adds and defines new fileds to the tower structure.
%
%  Syntax:
%       -tower_definition(tower);
%
%  Input:
%       -tower = is a structure which contains the tower's
%                elastic, inertial and geometrical
%                properties. (For more datails see the
%                read_tower_details function);
%
%  Output:
%       - tower = this function return the tower structure
%                (for more information see the
%                 read_tower_details help), with new fileds:
%                      -torsional_stiffness;
%                      -moments_of_inertia;
%                      -section center of gravity (cg);
%                      -section shear center (sc);
%                      -section centroid (cl);
%                      -total_mass;
%                      -npoint;
%                      -e2 and e3 which are the director
%                       cosine of the local tower section;
%
%----------------------------------------------------------

% Tower's sections area polar moments of inertia
ddd=1.0;

tower.Jp = (pi/32) * [(tower.diameter.^4)-(tower.diameter - [ddd*2*tower.wall_thickness/1000]).^4];

% Tower's sections area
tower.sections_area = (pi/4) * [(tower.diameter.^2)-(tower.diameter - [ddd*2*tower.wall_thickness/1000]).^2];

% Ale. 04.feb.05 :
% From txt file we have read E.
% Now we compute G with the Hp that the Poisson_coeff = 0.3
% (Ok for steel)
Poisson_coeff = 0.3 ;
tower.G_modul = tower.E_modul/(2*(1+Poisson_coeff)) ;
% %%%%%%%%%%

if tower.torsional_stiffness(1) == 0;

    tower.torsional_stiffness(1:end) = tower.bending_stiffness*100  ;

elseif tower.torsional_stiffness(1) == 1;

    tower.torsional_stiffness = tower.Jp.*tower.G_modul;

    % ALEALE 18.november.2009
    BendingStiffness = 0.5*tower.Jp.*tower.E_modul;
    MassLength = tower.sections_area.*tower.density;
    %
end

tower.PolatInertia = tower.Jp*tower.density;

for i=1:tower.nentries,

    %%%%THIS VELUES ARE USED ONLY FOR NUMERICAL PURPOSE
    %%%%tower.moments_of_inertia( i , : ) =[ 0.0001 0.00005 0.00005 ];

    tower.cg( i , : ) = [ 0 0 ];
    tower.sc( i , : ) = [ 0 0 ];
    tower.cl( i , : ) = [ 0 0 ];

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Temporary for 3d model definitions 15/12/2004  : Ale. Perché? Non va bene
%sempre?? NO... solo quando torsional stiff è reale...
%tower.moments_of_inertia = tower.density * [ tower.Jp 0.5*tower.Jp 0.5*tower.Jp];

% Ale 04.feb.05: commented:
%tower.Young_modulus=2.06E+11;       % Ale: questo !?!?!??!
%--------------------------------------------------------------
tower.moments_of_inertia = tower.density * [ tower.Jp 0.5*tower.Jp 0.5*tower.Jp];


[tower.total_mass , tower.npoint ] = calculate_total_mass( tower.height , tower.mass_unit_length , 'n' );

tower.e2= [ 0 ; 1 ; 0 ];
tower.e3= [ 0 ; 0 ; 1 ];
