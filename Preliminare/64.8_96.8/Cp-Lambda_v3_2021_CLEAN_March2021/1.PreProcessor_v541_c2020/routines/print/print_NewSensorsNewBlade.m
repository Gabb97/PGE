function print_NewSensors( dat_file_name , PathStruct)

%------------------------------------------------------
%  This function prints in a .dat file
%  the sensors models in a form suitable for the 
%  multibody code.
%
%  Syntax:
%         -print_sensors( dat_file_name );
%
%  Input:
%         - dat_file_name : is a string which contains
%                           the name of the .dat file;
%
%------------------------------------------------------
%


% ALE. 21.october.05 
% Here we set the new sensors with moving frames.
% Simple matlab file: just write a pre-definite file!

%------------------------------------------------------------------------------------
% Here the function is calling all name strings needed to print the sensors.dat file
load names\tower_names tower_name
load names\blade_names              % ALEALE NEW 28.02.2017
%------------------------------------------------------------------------------------

%------------------------------------------------------------------------------------
% Here the function is reading the details necessary to define the sensors position
tower      =  read_tower_details(PathStruct);
blade      =  read_blade(PathStruct);           % ALEALE NEW 28.02.2017
point_mass =  read_point_mass(blade,PathStruct);       % ALEALE NEW 28.02.2017
%------------------------------------------------------------------------------------

% Send status #LS
disp('  Writing Sensors.dat file.........')

sensor_file_name = dat_file_name(4,:);
%
fpc = fopen( strcat(dat_file_name(end,:),'\MB_model\',sensor_file_name) , 'w' );

fprintf(fpc,'Sensors :\n');
fprintf(fpc,'    # *******************   BLADE 1\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : Blade1RotatingPitchableRootForces ;\n');
fprintf(fpc,'        Beam            : blade_1_1 ;\n');
fprintf(fpc,'        Sensing         : Forces ;\n');
fprintf(fpc,'        InReferenceFrame: FrameBlade1RotatingPitchable ;\n');
fprintf(fpc,'        EtaValue        : 0 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : Blade1RotatingHubFixedRootForces ;\n');
fprintf(fpc,'        Beam            : blade_1_1 ;\n');
fprintf(fpc,'        Sensing         : Forces ;\n');
fprintf(fpc,'        InReferenceFrame: FrameBlade1RotatingHubFixed ;\n');
fprintf(fpc,'        EtaValue        : 0 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : Blade1RotatingPitchableTipDisplacements ;\n');
fprintf(fpc,'        Beam            : blade_2_1 ;\n');
fprintf(fpc,'        Sensing         : Displacements ;\n');
fprintf(fpc,'        InReferenceFrame: FrameBlade1RotatingPitchable ;\n');
fprintf(fpc,'        EtaValue        : 1 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : Blade1RotatingHubFixedTipDisplacements ;\n');
fprintf(fpc,'        Beam            : blade_2_1 ;\n');
fprintf(fpc,'        Sensing         : Displacements ;\n');
fprintf(fpc,'        InReferenceFrame: FrameBlade1RotatingHubFixed ;\n');
fprintf(fpc,'        EtaValue        : 1 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : Blade1RotatingHubFixedRootDisplacements ;\n');
fprintf(fpc,'        Beam            : blade_1_1 ;\n');
fprintf(fpc,'        Sensing         : Displacements ;\n');
fprintf(fpc,'        InReferenceFrame: FrameBlade1RotatingHubFixed ;\n');
fprintf(fpc,'        EtaValue        : 0 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : Blade1RotatingHubFixedRootVelocities ;\n');
fprintf(fpc,'        Beam            : blade_1_1 ;\n');
fprintf(fpc,'        Sensing         : Velocities ;\n');
fprintf(fpc,'        InReferenceFrame: FrameBlade1RotatingHubFixed ;\n');
fprintf(fpc,'        EtaValue        : 0 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'\n');
fprintf(fpc,'    # *******************   BLADE 2\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : Blade2RotatingPitchableRootForces ;\n');
fprintf(fpc,'        Beam            : blade_1_2 ;\n');
fprintf(fpc,'        Sensing         : Forces ;\n');
fprintf(fpc,'        InReferenceFrame: FrameBlade2RotatingPitchable ;\n');
fprintf(fpc,'        EtaValue        : 0 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : Blade2RotatingHubFixedRootForces ;\n');
fprintf(fpc,'        Beam            : blade_1_2 ;\n');
fprintf(fpc,'        Sensing         : Forces ;\n');
fprintf(fpc,'        InReferenceFrame: FrameBlade2RotatingHubFixed ;\n');
fprintf(fpc,'        EtaValue        : 0 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : Blade2RotatingPitchableTipDisplacements ;\n');
fprintf(fpc,'        Beam            : blade_2_2 ;\n');
fprintf(fpc,'        Sensing         : Displacements ;\n');
fprintf(fpc,'        InReferenceFrame: FrameBlade2RotatingPitchable ;\n');
fprintf(fpc,'        EtaValue        : 1 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : Blade2RotatingHubFixedTipDisplacements ;\n');
fprintf(fpc,'        Beam            : blade_2_2 ;\n');
fprintf(fpc,'        Sensing         : Displacements ;\n');
fprintf(fpc,'        InReferenceFrame: FrameBlade2RotatingHubFixed ;\n');
fprintf(fpc,'        EtaValue        : 1 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'\n');
fprintf(fpc,'    # *******************   BLADE 3\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : Blade3RotatingPitchableRootForces ;\n');
fprintf(fpc,'        Beam            : blade_1_3 ;\n');
fprintf(fpc,'        Sensing         : Forces ;\n');
fprintf(fpc,'        InReferenceFrame: FrameBlade3RotatingPitchable ;\n');
fprintf(fpc,'        EtaValue        : 0 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : Blade3RotatingHubFixedRootForces ;\n');
fprintf(fpc,'        Beam            : blade_1_3 ;\n');
fprintf(fpc,'        Sensing         : Forces ;\n');
fprintf(fpc,'        InReferenceFrame: FrameBlade3RotatingHubFixed ;\n');
fprintf(fpc,'        EtaValue        : 0 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : Blade3RotatingPitchableTipDisplacements ;\n');
fprintf(fpc,'        Beam            : blade_2_3 ;\n');
fprintf(fpc,'        Sensing         : Displacements ;\n');
fprintf(fpc,'        InReferenceFrame: FrameBlade3RotatingPitchable ;\n');
fprintf(fpc,'        EtaValue        : 1 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : Blade3RotatingHubFixedTipDisplacements ;\n');
fprintf(fpc,'        Beam            : blade_2_3 ;\n');
fprintf(fpc,'        Sensing         : Displacements ;\n');
fprintf(fpc,'        InReferenceFrame: FrameBlade3RotatingHubFixed ;\n');
fprintf(fpc,'        EtaValue        : 1 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'\n');
fprintf(fpc,'    # *******************   HUB-NACELLE\n');
fprintf(fpc,'\n');
fprintf(fpc,'\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : HubRotatingForces ;\n');
fprintf(fpc,'        Beam            : drive_train_shaft_1 ;\n');
fprintf(fpc,'        Sensing         : Forces ;\n');
fprintf(fpc,'        InReferenceFrame: FrameHubRotating ;\n');
fprintf(fpc,'        EtaValue        : 0.5 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : HubFixedForces ;\n');
fprintf(fpc,'        Beam            : drive_train_shaft_1 ;\n');
fprintf(fpc,'        Sensing         : Forces ;\n');
fprintf(fpc,'        InReferenceFrame: FrameHubFixed ;\n');
fprintf(fpc,'        EtaValue        : 0.5 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : HubVelocities ;\n');
fprintf(fpc,'        RigidBody       : rb_hub_centre ;\n');
fprintf(fpc,'        Sensing         : Velocities ;\n');
fprintf(fpc,'        InReferenceFrame: FrameHubRotorSpeed ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : HubGeneratorFixedForces ;\n');
fprintf(fpc,'        Beam            : drive_train_linker ;\n');
fprintf(fpc,'        Sensing         : Forces ;\n');
fprintf(fpc,'        InReferenceFrame: FrameHubFixed ;\n');
fprintf(fpc,'        EtaValue        : 0.5 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'\n');
fprintf(fpc,'\n');
fprintf(fpc,'    # *******************   TOWER\n');
fprintf(fpc,'\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : TowerTopLocalForces ;\n');
fprintf(fpc,'        Beam            : %s ;\n',tower_name(tower.nentries-1,:)); %% ALEALE modified 02.feb.09
fprintf(fpc,'        Sensing         : Forces ;\n');
fprintf(fpc,'        InReferenceFrame: FrameTowerLocal ;\n');
fprintf(fpc,'        EtaValue        : 1 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : TowerTopDisplacements ;\n');
fprintf(fpc,'        Beam            : %s ;\n',tower_name(tower.nentries-1,:)); %% ALEALE modified 02.feb.09
fprintf(fpc,'        Sensing         : Displacements ;\n');
fprintf(fpc,'        InReferenceFrame: INERTIAL ;\n');
fprintf(fpc,'        EtaValue        : 1 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');  %% ALEALE added 02.feb.09
fprintf(fpc,'        Name            : TowerTopVelocities ;\n');
fprintf(fpc,'        Beam            : %s ;\n',tower_name(tower.nentries-1,:)); %% ALEALE modified 02.feb.09
fprintf(fpc,'        Sensing         : Velocities ;\n');
fprintf(fpc,'        InReferenceFrame: INERTIAL ;\n');
fprintf(fpc,'        EtaValue        : 1 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : TowerRootLocalForces ;\n');
fprintf(fpc,'        Beam            : tower_0 ;\n');
fprintf(fpc,'        Sensing         : Forces ;\n');
fprintf(fpc,'        InReferenceFrame: FrameTowerLocal ;\n');
fprintf(fpc,'        EtaValue        : 0 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name            : TowerRootDisplacements ;\n');
fprintf(fpc,'        Beam            : tower_0 ;\n');
fprintf(fpc,'        Sensing         : Displacements ;\n');
fprintf(fpc,'        InReferenceFrame: INERTIAL ;\n');
fprintf(fpc,'        EtaValue        : 0 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'\n');
fprintf(fpc,'    # *******************   RELATIVE ROTATIONS\n');
fprintf(fpc,'\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name             : Blade1Pitch ;\n');
fprintf(fpc,'        RevoluteJoint    : rvj_pitch_controller_1;\n');
fprintf(fpc,'        Sensing          : RelativeRotations;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name             : Blade2Pitch ;\n');
fprintf(fpc,'        RevoluteJoint    : rvj_pitch_controller_2;\n');
fprintf(fpc,'        Sensing          : RelativeRotations;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name             : Blade3Pitch ;\n');
fprintf(fpc,'        RevoluteJoint    : rvj_pitch_controller_3;\n');
fprintf(fpc,'        Sensing          : RelativeRotations;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name             : HubRotation ;\n');
fprintf(fpc,'        RevoluteJoint    : rvj_generator;\n');
fprintf(fpc,'        Sensing          : RelativeRotations;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name             : YawRotation ;\n');
fprintf(fpc,'        RevoluteJoint    : rvj_yaw_control ;\n');
fprintf(fpc,'        Sensing          : RelativeRotations;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'\n');
fprintf(fpc,'    Sensor :\n');
fprintf(fpc,'        Name             : GeneratorActuatorTorque ;\n');
fprintf(fpc,'        Beam             : drive_train_linker ;\n');
fprintf(fpc,'        Sensing          : Forces;\n');
fprintf(fpc,'        InReferenceFrame : FrameHubRotating ;\n');
fprintf(fpc,'        EtaValue         : 0 ;\n');
fprintf(fpc,'        # ActuatorForce  : generator_actuator ;\n');
fprintf(fpc,'        # Sensing        : Forces;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'\n');
% fprintf(fpc,'    # *******************   CONTROLLER SENSOR\n');
% fprintf(fpc,'\n');
% fprintf(fpc,'    Sensor :\n');
% fprintf(fpc,'        Name             : sensor_rotor_speed ;\n');
% fprintf(fpc,'        RigidBody        : rb_hub_centre;\n');
% fprintf(fpc,'        Sensing          : Velocities;\n');
% fprintf(fpc,'        InReferenceFrame : local ;\n');
% fprintf(fpc,'        SensorIsActive   : yes;\n');
% fprintf(fpc,'        DegreeOfFreedom  : 5;\n');
% fprintf(fpc,'    ;\n');
% fprintf(fpc,'    Sensor :\n');
% fprintf(fpc,'        Name             : sensor_generator_speed ;\n');
% fprintf(fpc,'        RigidBody        : rb_generator;\n');
% fprintf(fpc,'        Sensing          : Velocities;\n');
% fprintf(fpc,'        InReferenceFrame : local ;\n');
% fprintf(fpc,'        SensorIsActive   : yes;\n');
% fprintf(fpc,'        DegreeOfFreedom  : 5;\n');
% fprintf(fpc,'    ;\n');
% fprintf(fpc,'    Sensor :\n');
% fprintf(fpc,'        Name             : sensor_blade_1_pitch ;\n');
% fprintf(fpc,'        RevoluteJoint    : rvj_pitch_controller_1;\n');
% fprintf(fpc,'        Sensing          : RelativeRotations;\n');
% fprintf(fpc,'        SensorIsActive   : yes;\n');
% fprintf(fpc,'        DegreeOfFreedom  : 4;\n');
% fprintf(fpc,'    ;\n');
% fprintf(fpc,'    Sensor :\n');
% fprintf(fpc,'        Name             : sensor_blade_2_pitch ;\n');
% fprintf(fpc,'        RevoluteJoint    : rvj_pitch_controller_2;\n');
% fprintf(fpc,'        Sensing          : RelativeRotations;\n');
% fprintf(fpc,'        SensorIsActive   : yes;\n');
% fprintf(fpc,'        DegreeOfFreedom  : 4;\n');
% fprintf(fpc,'    ;\n');
% fprintf(fpc,'    Sensor :\n');
% fprintf(fpc,'        Name             : sensor_blade_3_pitch ;\n');
% fprintf(fpc,'        RevoluteJoint    : rvj_pitch_controller_3;\n');
% fprintf(fpc,'        Sensing          : RelativeRotations;\n');
% fprintf(fpc,'        SensorIsActive   : yes;\n');
% fprintf(fpc,'        DegreeOfFreedom  : 4;\n');
% fprintf(fpc,'    ;\n');
% fprintf(fpc,'    Sensor :\n');
% fprintf(fpc,'        Name             : sensor_yaw_rotation ;\n');
% fprintf(fpc,'        RevoluteJoint    : rvj_yaw_control ;\n');
% fprintf(fpc,'        Sensing          : RelativeRotations;\n');
% fprintf(fpc,'        SensorIsActive   : yes;\n');
% fprintf(fpc,'        DegreeOfFreedom  : 4;\n');
% fprintf(fpc,'    ;\n');
fprintf(fpc,';\n');

fclose(fpc);

% Send status #LS
disp('  Writing MovingFrames.dat file.........')

fpc = fopen( strcat(dat_file_name(end,:),'\MB_model\MovingFrames.dat') ,'w');

fprintf(fpc,'# Frames for sensors\n');
fprintf(fpc,'\n');
fprintf(fpc,'MovingFrames:\n');
fprintf(fpc,'\n');
fprintf(fpc,'    # *******************   BLADES\n');
fprintf(fpc,'\n');
fprintf(fpc,'    MovingFrame:\n');
fprintf(fpc,'        Name        : FrameBlade1RotatingPitchable;\n');
fprintf(fpc,'        ConnectedTo : blade_1_1;\n');
fprintf(fpc,'        Where       : pt_blade_root_1_1;\n');
fprintf(fpc,'        Triad       : TriadBlade1RotatingPitchable;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    MovingFrame:\n');
fprintf(fpc,'        Name        : FrameBlade1RotatingHubFixed;\n');
fprintf(fpc,'        ConnectedTo : rb_blade_fixed_root_1;\n');
fprintf(fpc,'        Where       : pt_blade_root_1_1;\n');
fprintf(fpc,'        Triad       : TriadBlade1RotatingHubFixed;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    MovingFrame:\n');
fprintf(fpc,'        Name        : FrameBlade2RotatingPitchable;\n');
fprintf(fpc,'        ConnectedTo : blade_1_2;\n');
fprintf(fpc,'        Where       : pt_blade_root_1_2;\n');
fprintf(fpc,'        Triad       : TriadBlade2RotatingPitchable;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    MovingFrame:\n');
fprintf(fpc,'        Name        : FrameBlade2RotatingHubFixed;\n');
fprintf(fpc,'        ConnectedTo : rb_blade_fixed_root_2;\n');
fprintf(fpc,'        Where       : pt_blade_root_1_2;\n');
fprintf(fpc,'        Triad       : TriadBlade2RotatingHubFixed;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    MovingFrame:\n');
fprintf(fpc,'        Name        : FrameBlade3RotatingPitchable;\n');
fprintf(fpc,'        ConnectedTo : blade_1_3;\n');
fprintf(fpc,'        Where       : pt_blade_root_1_3;\n');
fprintf(fpc,'        Triad       : TriadBlade3RotatingPitchable;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    MovingFrame:\n');
fprintf(fpc,'        Name        : FrameBlade3RotatingHubFixed;\n');
fprintf(fpc,'        ConnectedTo : rb_blade_fixed_root_3;\n');
fprintf(fpc,'        Where       : pt_blade_root_1_3;\n');
fprintf(fpc,'        Triad       : TriadBlade3RotatingHubFixed;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'\n');
fprintf(fpc,'    # *******************   HUB-NACELLE\n');
fprintf(fpc,'\n');
fprintf(fpc,'    MovingFrame:\n');
fprintf(fpc,'        Name        : FrameHubRotating;\n');
fprintf(fpc,'        ConnectedTo : drive_train_shaft_1;\n');
fprintf(fpc,'        Where       : pt_hub_centre;\n');
fprintf(fpc,'        Triad       : TriadFrameHubRotating;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    MovingFrame:\n');
fprintf(fpc,'        Name        : FrameHubFixed;\n');
fprintf(fpc,'        ConnectedTo : drive_train_linker;\n');
fprintf(fpc,'        Where       : pt_generator;\n');
fprintf(fpc,'        Triad       : TriadFrameHubFixed;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    MovingFrame:\n');
fprintf(fpc,'        Name        : FrameHubRotorSpeed;\n');
fprintf(fpc,'        ConnectedTo : drive_train_linker;\n');
fprintf(fpc,'        Where       : pt_generator;\n');
fprintf(fpc,'        Triad       : TriadFrameHubRotorSpeed;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'\n');
fprintf(fpc,'    # *******************   TOWER\n');
fprintf(fpc,'\n');
fprintf(fpc,'    MovingFrame:\n');
fprintf(fpc,'        Name        : FrameTowerLocal;\n');
fprintf(fpc,'        ConnectedTo : tower_0;\n');
fprintf(fpc,'        Where       : pt_tower_0;\n');
fprintf(fpc,'        Triad       : TriadTowerLocal;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'\n');
fprintf(fpc,';\n');
fprintf(fpc,'\n');
fprintf(fpc,'\n');
fprintf(fpc,'Triads:\n');
fprintf(fpc,'\n');
fprintf(fpc,'    # *******************   BLADES\n');
fprintf(fpc,'\n');
fprintf(fpc,'    Triad:\n');
fprintf(fpc,'        Name            : TriadBlade1RotatingPitchable ;\n');
fprintf(fpc,'        YVector         : 0 , -1 , 0 ;\n');
fprintf(fpc,'        ZVector         : 1 ,  0 , 0 ;\n');
fprintf(fpc,'        InReferenceFrame: blade_root_frame_1 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Triad:\n');
fprintf(fpc,'        Name            : TriadBlade1RotatingHubFixed ;\n');
fprintf(fpc,'        YVector         : 0 , -1 , 0 ;\n');
fprintf(fpc,'        ZVector         : 1 ,  0 , 0 ;\n');
fprintf(fpc,'        InReferenceFrame: blade_root_frame_1 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'\n');
fprintf(fpc,'    Triad:\n');
fprintf(fpc,'        Name            : TriadBlade2RotatingPitchable ;\n');
fprintf(fpc,'        YVector         : 0 , -1 , 0 ;\n');
fprintf(fpc,'        ZVector         : 1 ,  0 , 0 ;\n');
fprintf(fpc,'        InReferenceFrame: blade_root_frame_2 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Triad:\n');
fprintf(fpc,'        Name            : TriadBlade2RotatingHubFixed ;\n');
fprintf(fpc,'        YVector         : 0 , -1 , 0 ;\n');
fprintf(fpc,'        ZVector         : 1 ,  0 , 0 ;\n');
fprintf(fpc,'        InReferenceFrame: blade_root_frame_2 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'\n');
fprintf(fpc,'    Triad:\n');
fprintf(fpc,'        Name            : TriadBlade3RotatingPitchable ;\n');
fprintf(fpc,'        YVector         : 0 , -1 , 0 ;\n');
fprintf(fpc,'        ZVector         : 1 ,  0 , 0 ;\n');
fprintf(fpc,'        InReferenceFrame: blade_root_frame_3 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Triad:\n');
fprintf(fpc,'        Name            : TriadBlade3RotatingHubFixed ;\n');
fprintf(fpc,'        YVector         : 0 , -1 , 0 ;\n');
fprintf(fpc,'        ZVector         : 1 ,  0 , 0 ;\n');
fprintf(fpc,'        InReferenceFrame: blade_root_frame_3 ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'\n');
fprintf(fpc,'    # *******************   HUB-NACELLE\n');
fprintf(fpc,'\n');
fprintf(fpc,'    Triad:\n');
fprintf(fpc,'        Name            : TriadFrameHubRotating ;\n');
fprintf(fpc,'        YVector         : 0 ,  0 ,  1 ;\n');
fprintf(fpc,'        ZVector         : -1 ,  0 ,  0 ;\n');
fprintf(fpc,'        InReferenceFrame: frame_hub ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Triad:\n');
fprintf(fpc,'        Name            : TriadFrameHubFixed ;\n');
fprintf(fpc,'        YVector         : 0 ,  0 ,  1 ;\n');
fprintf(fpc,'        ZVector         : -1 ,  0 ,  0 ;\n');
fprintf(fpc,'        InReferenceFrame: frame_hub ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'    Triad:\n');
fprintf(fpc,'        Name            : TriadFrameHubRotorSpeed ;\n');
fprintf(fpc,'        YVector         : 0 ,  0 ,  1 ;\n');
fprintf(fpc,'        ZVector         : 1 ,  0 ,  0 ;\n');
fprintf(fpc,'        InReferenceFrame: frame_hub ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'\n');
fprintf(fpc,'    # *******************   TOWER\n');
fprintf(fpc,'\n');
fprintf(fpc,'    Triad:\n');
fprintf(fpc,'        Name            : TriadTowerLocal ;\n');
fprintf(fpc,'        YVector         : 0 ,  0 ,  1 ;\n');
fprintf(fpc,'        ZVector         : 1 ,  0 ,  0 ;\n');
fprintf(fpc,'        InReferenceFrame: tower_frame ;\n');
fprintf(fpc,'    ;\n');
fprintf(fpc,'\n');
fprintf(fpc,'\n');
fprintf(fpc,';\n');

fclose(fpc);


%-----------------------------------
% BLADE SPANWISE EXTRA SENSORS
%     ALEALE NEW 28.02.2017 
%-----------------------------------
blade_length    =   blade.distance_from_root(end);
beam_1_length   =   point_mass.position;

beam_2_length   =   blade_length-beam_1_length;


% Define required eta along BLADE.
eta         =   linspace(0,0.9,10);
eta_names   =   eta/0.01;

% Convert to radial position along the BLADE.
r   =   eta*blade_length;

% Find relative eta along each beam

beam_1_r = [];
beam_2_r = [];

i_1 = 0;
i_2 = 0;


for ii = 1:length(r)
    if r(ii)    <=      beam_1_length
        i_1             =   i_1 + 1;
        beam_1_r(i_1)   =   r(ii);
    else
        i_2             =   i_2 + 1;
        beam_2_r(i_2)   =   r(ii)-beam_1_length;
    end
end


% Convert to local eta
beam_1_eta = beam_1_r / beam_1_length;
beam_2_eta = beam_2_r / beam_2_length;


n_sens_beam_1 =length(beam_1_eta);
n_sens_beam_2 =length(beam_2_eta);

% Send status #LS
disp('  Writing Sensors_BladeSpanWise.dat file.........')

%
fpc = fopen( strcat(dat_file_name(end,:),'\MB_model\','Sensors_BladeSpanWise.dat') , 'w' );  % at the moment here, not user defined!
fprintf(fpc,'%s \n','Sensors:');

for nb = 1:3
    fprintf(fpc,'%s \n',strcat(' # *******************   BLADE',32,num2str(nb)));
    
    for ns = 1:length(beam_1_eta);
        name_sens   =   strcat('Blade',num2str(nb),'_Loads_eta',num2str(eta_names(ns)));
        name_beam   =   strcat('blade_1_',num2str(nb));
        
        fprintf(fpc,'\t %s \n','Sensor:');
            fprintf(fpc,'\t \t %s \n',strcat('Name            :',32,name_sens,32,';'));
            fprintf(fpc,'\t \t %s \n',strcat('Beam            :',32,name_beam,32,';'));
            fprintf(fpc,'\t \t %s \n','Sensing         : Forces ;');
            fprintf(fpc,'\t \t %s \n','InReferenceFrame: Local ;');
            fprintf(fpc,'\t \t %s \n',strcat('EtaValue        :',32,num2str(beam_1_eta(ns)),32,';'));
        fprintf(fpc,'\t %s \n',';');    
        
    end
    
    
    for ns = 1:length(beam_2_eta);
        name_sens = strcat('Blade',num2str(nb),'_Loads_eta',num2str(eta_names(n_sens_beam_1 + ns)));
        name_beam   =   strcat('blade_2_',num2str(nb));
        
        fprintf(fpc,'\t %s \n','Sensor:');
            fprintf(fpc,'\t \t %s \n',strcat('Name            :',32,name_sens,32,';'));
            fprintf(fpc,'\t \t %s \n',strcat('Beam            :',32,name_beam,32,';'));
            fprintf(fpc,'\t \t %s \n','Sensing         : Forces ;');
            fprintf(fpc,'\t \t %s \n','InReferenceFrame: Local ;');
            fprintf(fpc,'\t \t %s \n',strcat('EtaValue        :',32,num2str(beam_2_eta(ns)),32,';'));
        fprintf(fpc,'\t %s \n',';'); 
        
    end
    
    
end
fprintf(fpc,'%s \n',';'); 

fclose(fpc);



return

















%------------------------------------------------------------------------------------
% Here the function is calling all name strings needed to print the sensors.dat file
load names\sensors_names
load names\tower_names tower_name
load names\blade_names blade_name
load names\hub_names hub_name
load names\generator_names generator_components_names
%------------------------------------------------------------------------------------

%------------------------------------------------------------------------------------
% Here the function is reading the details necessary to define the sensors position
sensors    =  read_sensors('input\sensors.txt');
tower      =  read_tower_details;
point_mass =  read_point_mass;
hub        =  read_hub_details;
blade      =  read_blade_geometry;
%------------------------------------------------------------------------------------
% I also copy the sensor PPP for post processor use!!!
dos_copy = ['copy .\input\sensors.txt ',deblank(dat_file_name(end,:)),'\RUN\U\DLCxx\output\sensors.txt'];
% [status,result] = dos(dos_copy); % ERROR in MEX mode
dos(dos_copy);
%
fpc = fopen( strcat(dat_file_name(end,:),'\RUN\U\DLCxx\input\',sensor_file_name) ,'w');

fprintf(fpc,' Sensors :\n');

%-------------------------
%          BLADE
%--------------------------
%REMARK: with this routine, the software run
%correctly when the blade has only one point mass!!!!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WHEN I WILL DECIDE TO NOT USE THE COPY COMMAND, THISFUNCTION WILL BE
% STILL SUITABLE...................................
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1 : max(size(sensors.eta_blade));
    
    eta_point_mass = point_mass.position / blade.distance_from_root(end);
    
    if sensors.eta_blade(i) <= eta_point_mass;
        
        eta_blade_temp = ( sensors.eta_blade(i) * blade.distance_from_root(end)) / (point_mass.position);
        beam_name = blade_name{1}(1,:);
        
    else
        
        eta_blade_temp = (( sensors.eta_blade(i) * blade.distance_from_root(end)) - point_mass.position ) / (blade.distance_from_root(end) - point_mass.position);
        beam_name = blade_name{1}(2,:);
        
    end
    
    if sensors.blade_studied(1,1:3) == 'all',
        
        if hub.number_of_blades == 2,           

            sensor_definition( fpc , 'n' , blade_1_forces_sensors_names(i,:) , 'Beam  ' , beam_name , 'Forces' , 'LOCAL' , eta_blade_temp , 1 );   
            sensor_definition( fpc , 'n' , blade_1_displacements_sensors_names(i,:) , 'Beam ' , beam_name , 'Displacements' , 'INERTIAL' , eta_blade_temp , 1 );
            
            sensor_definition( fpc , 'n' , blade_2_forces_sensors_names(i,:) , 'Beam  ' , strcat(beam_name(1:end-2),'_2') , 'Forces' , 'LOCAL' , eta_blade_temp , 1 );   
            sensor_definition( fpc , 'n' , blade_2_displacements_sensors_names(i,:) , 'Beam ' , strcat(beam_name(1:end-2),'_1') , 'Displacements' , 'INERTIAL' , eta_blade_temp , 1 );
            
        elseif hub.number_of_blades == 3,

            sensor_definition( fpc , 'n' , blade_1_forces_sensors_names(i,:) , 'Beam  ' , beam_name , 'Forces' , 'LOCAL' , eta_blade_temp , 1 );   
            sensor_definition( fpc , 'n' , blade_1_displacements_sensors_names(i,:) , 'Beam ' , beam_name , 'Displacements' , 'INERTIAL' , eta_blade_temp , 1 );                       
            
            sensor_definition( fpc , 'n' , blade_2_forces_sensors_names(i,:) , 'Beam  ' , strcat(beam_name(1:end-2),'_2') , 'Forces' , 'LOCAL' , eta_blade_temp , 1 );   
            sensor_definition( fpc , 'n' , blade_2_displacements_sensors_names(i,:) , 'Beam ' , strcat(beam_name(1:end-2),'_2') , 'Displacements' , 'INERTIAL' , eta_blade_temp , 1 );
            
            sensor_definition( fpc , 'n' , blade_3_forces_sensors_names(i,:) , 'Beam  ' , strcat(beam_name(1:end-2),'_3') , 'Forces' , 'LOCAL' , eta_blade_temp , 1 );   
            sensor_definition( fpc , 'n' , blade_3_displacements_sensors_names(i,:) , 'Beam ' , strcat(beam_name(1:end-2),'_3') , 'Displacements' , 'INERTIAL' , eta_blade_temp , 1 );
            
        end       
        
    elseif ( sensors.blade_studied(1,1:3) ~='non' & sensors.blade_studied(1,1:3) ~='all' ),

        sensor_definition( fpc , 'n' , blade_1_forces_sensors_names(i,:) , 'Beam  ' , beam_name(1,:) , 'Forces' , 'LOCAL' , eta_blade_temp , 1 );   
        sensor_definition( fpc , 'n' , blade_1_displacements_sensors_names(i,:) , 'Beam ' , beam_name(1,:) , 'Displacements' , 'INERTIAL' , eta_blade_temp , 1 );        
        
    end
            
end

% -------------------------
%         TOWER
% -------------------------

if ( sensors.tower_flag(1,1:2) == 'ye' | sensors.tower_flag(1,1:2) == 'YE' ),
    
    [ usable_height , sensor_height , ii ] = service_routine01( tower.height , sensors.eta_tower );
    
    for i = 1 :max(size(sensors.eta_tower));
        
        if sensors.eta_tower(i) == 0 ,            
            
            sensor_definition( fpc , 'n' , tower_forces_sensors_names(i,:) , 'Beam  ' , tower_name(1,:) , 'Forces' , 'LOCAL' , sensors.eta_tower(i) , 1 );
            
            sensor_definition( fpc , 'n' , tower_displacements_sensors_names(i,:) , 'Beam  ' , tower_name(1,:) , 'Displacements' , 'INERTIAL' , sensors.eta_tower(i) , 1 );
            
        elseif sensors.eta_tower(i) == 1 ;            
            
            sensor_definition( fpc , 'n' , tower_forces_sensors_names(i,:) , 'Beam  ' , tower_name(ii-1,:) , 'Forces' , 'LOCAL' , sensors.eta_tower(i) , 1 );
            
            sensor_definition( fpc , 'n' , tower_displacements_sensors_names(i,:) , 'Beam  ' , tower_name(ii-1,:) , 'Displacements' , 'INERTIAL' , sensors.eta_tower(i) , 1 );
            
        else
            
            num = 1 ;
            
            while 1,
                
                if ( sensor_height(i) >= usable_height(num) & sensor_height(i) <= usable_height(num+1) ),
                    
                    eta_tower_temp = ( sensor_height(i) - usable_height(num) ) / ( usable_height(num+1) - usable_height(num) ) ;
                    
                    beam_name = tower_name(num,:);
                    
                    sensor_definition( fpc , 'n' , tower_forces_sensors_names(i,:) , 'Beam  ' , beam_name , 'Forces' , 'LOCAL' , eta_tower_temp , 1 );
                    
                    sensor_definition( fpc , 'n' , tower_displacements_sensors_names(i,:) , 'Beam  ' , beam_name , 'Displacements' , 'INERTIAL' , eta_tower_temp , 1 );
                    
                    break;
                    
                else
                    
                    num = num + 1 ;
                    
                end
                
            end
            
        end
        
    end
    
end


% --------------------------
%         HUB
% --------------------------

if ( sensors.hub_flag(1,1:2) == 'ye' | sensors.hub_flag(1,1:2) == 'YE' ),
    
    % Forces with respect the Inertial reference
    % sensor_definition( fpc , 'n' , hub_forces_sensors_names(1,:) , 'key_word' , 'element_name' , 'sensor_type' , 'frame_name' , eta_blade_forces(i) , 1 );
    
    % Forces with respect the Rotating reference
    % sensor_definition( fpc , 'n' , hub_forces_sensors_names(2,:) , 'key_word' , 'element_name' , 'sensor_type' , 'frame_name' , eta_blade_forces(i) , 1 );
    
    % Velocities with respect the Inertial reference
    sensor_definition( fpc , 'n' , hub_velocities_sensors_names(1,:) , 'RigidBody' , hub_name(1,:) , 'Velocities' , 'INERTIAL' , 2 , 1 );
    
    % Velocities with respect the Rotating reference
    sensor_definition( fpc , 'n' , hub_velocities_sensors_names(2,:) , 'RigidBody' , hub_name(1,:) , 'Velocities' , 'LOCAL' , 2 , 1 );
    
    % Displacements with respect the Inertial reference
    sensor_definition( fpc , 'n' , hub_displacements_sensors_names , 'RigidBody' , hub_name(1,:) , 'Displacements_0' , 'INERTIAL' , 2 , 1 );
    
end

%-----------------------------------
% DRIVE TRAIN SENSORS DEFINITIONS  |
%-----------------------------------


if ( sensors.drive_train(1,1:2) == 'ye' | sensors.drive_train(1,1:2) == 'YE' ),
    
    sensor_definition( fpc , 'n' , drive_train_forces_sensors_names(1,:) , 'Beam' , generator_components_names(4,:) , 'forces' , 'local' , [0.5] , 1 );
  
    % ALE 30.march.2005
    % this may be used with the old drive train model (with 2 rvjs)
%     sensor_definition( fpc , 'n' , drive_train_forces_sensors_names(2,:) , 'Beam' , generator_components_names(5,:) , 'forces' , 'local' , [0.5] , 1 );
    
    sensor_definition( fpc , 'n' , drive_train_forces_sensors_names(3,:) , 'Beam' , generator_components_names(8,:) , 'forces' , 'local' , [0.5] , 1 );
        
end

fprintf(fpc,';\n');


fclose(fpc);



