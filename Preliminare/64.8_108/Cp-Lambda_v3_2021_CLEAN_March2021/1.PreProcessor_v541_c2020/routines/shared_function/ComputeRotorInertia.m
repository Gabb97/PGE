function RotorInertia = ComputeRotorInertia(handles)
% I put this old subroutine directly in the main data flow, so that it is
% easily accessed by the User #LS

% Retrieve required turbine information
blade       =   read_blade(handles.PathStruct);
generator   =   read_generator_details(handles.PathStruct);
hub         =   read_hub_details(handles.PathStruct);


gen_inertia         =   generator.inertia; 
hub_inertia         =   hub.J_lss;
hub_radius          =   hub.root_radial_position;
Radius              =   blade.distance_from_root;
MassDistribution    =   blade.mass_unit_length;
Chord               =   blade.chord;
NBlades             =   hub.number_of_blades;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% delta radius
dr = diff(Radius);                                              % m
% medium ponts
ri = 0.5*(Radius(1:end-1)+Radius(2:end));                       % m
mi = 0.5*(MassDistribution(1:end-1)+MassDistribution(2:end));   % kg/m

% mass
dMb = mi.*ri.^0.*dr;
%static moment kgm
dSb = mi.*ri.^1.*dr;
% Moment of inertia kgm^2
dIb = mi.*ri.^2.*dr;

% figure
% plot(ri,mi,'x',Radius,MassDistribution,'--')
% xlabel('Radius [m]');ylabel('Mass/UnitSpan [Kg/m]')
% grid on
% figure
% plot(ri,dSb,ri,dIb)
% xlabel('Radius [m]');ylabel('Mass Moment')
% legend('First Mass Moment [Kgm]','Second Mass Moment [Kgm^2]')
% grid on


Mb = sum(dMb);
Sb = sum(dSb);
Ib = sum(dIb);
% CG
CG=Sb/Mb;
Ibaxis = Ib + Mb*hub_radius^2;


RotorInertia = Ibaxis*NBlades + hub_inertia + gen_inertia;

dispstr = [' --> Computed rotor inertia is: ' num2str(RotorInertia) ' Kg*m^2'];
disp(dispstr)

