function ComputeTowerClearance(handles)
% I put this old subroutine directly in the main data flow, so that it is
% easily accessed by the User #LS

% I also add the tip prebend to the computation of the tower clearance

% Retrieve required turbine information
tower       =   read_tower_details(handles.PathStruct);
hub         =   read_hub_details(handles.PathStruct);
blade       =   read_blade(handles.PathStruct);


%% compute clearance

% Tower
Htower = tower.height; % [m]
Dtower = tower.diameter; % [m]

% Rotor
Hhub          = hub.hub_height;                 % [m]
RotorOverhang = hub.overhang;                   % [m]
ThetaTilt     = hub.tilt_from_horizontal_grad;  % [deg]
ThetaPrecone  = hub.cone_angle;                 % [deg]
Diameter      = hub.rotor_diameter;             % [m]
Prebend_Tip   = blade.pre_bend(end);            % [m]

%% compute coordiantes
Towery        =   Htower;
Towerxfront   =   -Dtower/2;
Towerxrear    =   +Dtower/2;

% rotor point
xhub          =   -RotorOverhang;
yhub          =   Hhub;


% %% Computation without prebend (old version)
% % blade up tip (without prebend)
% xbtip_up    =   xhub + 0.5*Diameter*sind(ThetaTilt-ThetaPrecone);
% ybtip_up    =   yhub + 0.5*Diameter*cosd(ThetaTilt-ThetaPrecone);
% 
% % blade up down (without prebend)
% xbtip_dw    =   xhub - 0.5*Diameter*sind(ThetaTilt+ThetaPrecone);
% ybtip_dw    =   yhub - 0.5*Diameter*cosd(ThetaTilt+ThetaPrecone);
% 
% % segments
% Blade1x     = [xhub xbtip_up];
% Blade1y     = [yhub ybtip_up];
% Blade2x     = [xhub xbtip_dw];
% Blade2y     = [yhub ybtip_dw];


%% Computation with prebend (#LS)
% blade 1 (facing towards the sky) tip (without prebend)
x_tip_blade_1    =   xhub + 0.5*Diameter*sind(ThetaTilt-ThetaPrecone) ;
y_tip_blade_1    =   yhub + 0.5*Diameter*cosd(ThetaTilt-ThetaPrecone) ;

% blade 2 (facing towards the ground) tip (without prebend)
x_tip_blade_2    =   xhub - 0.5*Diameter*sind(ThetaTilt+ThetaPrecone) ;
y_tip_blade_2    =   yhub - 0.5*Diameter*cosd(ThetaTilt+ThetaPrecone) ;


% I need to define spanwise points to draw the prebend
n_points    = 25;
x_blade_1   = linspace(xhub, x_tip_blade_1,n_points);
y_blade_1   = linspace(yhub, y_tip_blade_1,n_points);

x_blade_2   = linspace(xhub, x_tip_blade_2,n_points);
y_blade_2   = linspace(yhub, y_tip_blade_2,n_points);

% Now I need to recover the value of the prebend but remembering that
% prebend is only defined between 0 and the blade length, while here I am
% discretizing along the radius
hub_radius            = hub.root_radial_position;
blade.radial_position = blade.distance_from_root + hub_radius;  

r = linspace(0,0.5*Diameter,n_points);

prebend_versus_radius = interp1(blade.radial_position,blade.pre_bend,r,'nearest','extrap');

% Now I can modify the points along the blade to account for prebend:
for i = 1:n_points
    x_blade_1_prebend(i) = x_blade_1(i) - prebend_versus_radius(i)*cosd(ThetaTilt - ThetaPrecone);
    y_blade_1_prebend(i) = y_blade_1(i) + prebend_versus_radius(i)*sind(ThetaTilt - ThetaPrecone);
end
for i = 1:n_points
    x_blade_2_prebend(i) = x_blade_2(i) - prebend_versus_radius(i)*cosd(ThetaTilt + ThetaPrecone);
    y_blade_2_prebend(i) = y_blade_2(i) + prebend_versus_radius(i)*sind(ThetaTilt + ThetaPrecone);
end

% Now I can define tip values for computing the clearance
x_blade_2_prebend_tip = x_blade_2_prebend(end);
y_blade_2_prebend_tip = y_blade_2_prebend(end);

% Compute shaft
Shaftx      = [0 xhub];   
Shafty      = [Htower(end) yhub];


% Plot configuration
figure
grid on; hold on;
plot(Towerxfront,Towery,'-k','LineWidth',2);
plot(Towerxrear,Towery,'-k','LineWidth',2);;
plot(x_blade_1_prebend,y_blade_1_prebend,'-r','LineWidth',2);;
plot(x_blade_2_prebend,y_blade_2_prebend,'-r','LineWidth',2);
hp = plot(Shaftx,Shafty,'-k','LineWidth',2);

axis equal


%% Clearance
% tower radius at blade down tip height
Dt          =   interp1(Htower,Dtower,y_blade_2_prebend_tip)*.5;
Clearance   =   -x_blade_2_prebend_tip-Dt;
MaxTipDefl  =   Clearance*.7;

dispstr = [' --> Computed tower clearance is: ' num2str(Clearance) ' m'];
disp(dispstr)
dispstr = [' --> Maximum blade deflection is: ' num2str(MaxTipDefl) ' m'];
disp(dispstr)

hp = plot([x_blade_2_prebend_tip -Dt],[y_blade_2_prebend_tip y_blade_2_prebend_tip],':k');
set(hp,'LineWidth',1);

