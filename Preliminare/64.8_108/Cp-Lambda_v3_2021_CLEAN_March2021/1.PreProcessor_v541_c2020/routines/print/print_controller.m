function print_controller(npoint, dat_file_name,PathStruct)

%-------------------------------------------------------------
%  This function prints the .dat file for the multibody code.
%
%  Syntax:
%
%  Input:
%
% ALE. 28.march.2005
%-------------------------------------------------------------


%-------------------------------------------------------------
load names\tower_names

handles.tower = read_tower_details(PathStruct);
handles.generator=read_generator_details(PathStruct);
%-------------------------------------------------------------

%%%%%%%%%%%%% STATIC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rel_path_name = strcat('.\..\..\..\Controller');

% Send status #LS
disp('  Writing ControllerStatic.dat file.........')

fpt=fopen( strcat(dat_file_name(end,:),'\MB_model\ControllerStatic.dat') ,'w');

fprintf(fpt,'\nControllers:');
fprintf(fpt,'\n    Controller:');
fprintf(fpt,'\n        Name            : Controller_4_Wind_Turbine;');
fprintf(fpt,'\n        ControllerType  : WindTurbine;');
fprintf(fpt,'\n        SensorList      : sensor_blade_1_pitch,sensor_blade_2_pitch,sensor_blade_3_pitch,sensor_generator_speed,sensor_rotor_speed,');
fprintf(fpt,'\n                          sensor_yaw_rotation, sensor_azimuth_rotation, sensor_tower_foreaft_velocities, sensor_tower_sideside_velocities;');
fprintf(fpt,'\n        ActuatorList    : pres_pitch_rel_rot_1,pres_pitch_rel_rot_2,pres_pitch_rel_rot_3,generator_actuator,pres_yaw_rotation;');
fprintf(fpt,'\n        SensorListNumber      : 4;');                             
fprintf(fpt,'\n        SensorListIndex       : 37, 60, 53, 54 ;');                             
fprintf(fpt,'\n        SensorListDerivative  :  0,  0,  1,  1 ;');  
fprintf(fpt,'\n        ControllerDescriptionFile : .\\input\\Controller\\ControllerDescriptionStatic_PoliMiController.dat;');
fprintf(fpt,'\n        NumberOfBlades  :  3 ;');
fprintf(fpt,'\n        PitchControlType :  PITCH_POSITION_DEMAND;');
fprintf(fpt,'\n        PitchActuatorList     : pitch_actuator_blade_1,pitch_actuator_blade_2,pitch_actuator_blade_3;');
fprintf(fpt,'\n        ExternalDLLFileName : %s\\PoliWindController_ver4.7.dll;',deblank(rel_path_name));
fprintf(fpt,'\n        CommunicationInterval : 0.02;');
fprintf(fpt,'\n        GearboxRatio : 1.0 ;');
fprintf(fpt,'\n        # Optional Parameters for external dll:');
fprintf(fpt,'\n        ControlParametersNumber :  1 ;  # number of record (MAX 200)');
fprintf(fpt,'\n        ControlParametersIndex:   61 ;  # Record number (start from 1, 0 means none)');
fprintf(fpt,'\n        ControlParameters :        3 ;  # Record values');
fprintf(fpt,'\n        # YAW CONTROL');
fprintf(fpt,'\n        YawTriad : yaw_triad ;');
fprintf(fpt,'\n        ConnectedTo : rigid_body_nacelle ; Where : %s;',pt_tower(handles.tower.nentries,:));
fprintf(fpt,'\n        YawActuator : yaw_actuator;');
fprintf(fpt,'\n');
fprintf(fpt,'\n                # ELECTRICAL LOSSES: choose one of the following models');
fprintf(fpt,'\n                # LUT model (generator shaft power - Power loss):');
fprintf(fpt,'\n                # ElectricalLosses :');
fprintf(fpt,'\n                #    NumberOfTerms : 3 ;');
fprintf(fpt,'\n                #           0          0');
fprintf(fpt,'\n                #     1100000     100000');
fprintf(fpt,'\n                #     5500000     500000');
fprintf(fpt,'\n                # ;');
fprintf(fpt,'\n                # Linear Model (efficiency - No load loss):');
fprintf(fpt,'\n                ElectricalLosses :');
fprintf(fpt,'\n                   NumberOfTerms : 0 ;');
fprintf(fpt,'\n                                  %g   %g',handles.generator.efficiency/100,handles.generator.no_load_power_loss);
fprintf(fpt,'\n                ;');
fprintf(fpt,'\n        ;');
fprintf(fpt,'\n;');
fprintf(fpt,'\n');
fprintf(fpt,'\nTriads :');
fprintf(fpt,'\n    Triad :');
fprintf(fpt,'\n        Name : yaw_triad ;');
fprintf(fpt,'\n        YVector :  0 ,  0 ,  1 ;');
fprintf(fpt,'\n        ZVector :  0 , -1 ,  0 ;');
fprintf(fpt,'\n    ;');
fprintf(fpt,'\n;');
fprintf(fpt,'\n');
fprintf(fpt,'\nActuators:');
fprintf(fpt,'\n    ActuatorForce:');
fprintf(fpt,'\n        Name                    : generator_actuator;');
fprintf(fpt,'\n        ActuatorType            : 1ST_ORDER_ACTUATOR;');
fprintf(fpt,'\n        ActuatorTimeConstant    : 0.01;');
fprintf(fpt,'\n        ActuatorGain            : 1.0;');
fprintf(fpt,'\n        Controller              : Controller_4_Wind_Turbine;');
fprintf(fpt,'\n        Range                   : 0, 1.0E7;');
fprintf(fpt,'\n    ;');
fprintf(fpt,'\n    ActuatorDisplacement:');
fprintf(fpt,'\n        Name                    : pitch_actuator_blade_1;');
fprintf(fpt,'\n        ActuatorType            : 2ND_ORDER_ACTUATOR;');
fprintf(fpt,'\n        ActuatorFrequency       : 5.0;');
fprintf(fpt,'\n        ActuatorDampingFactor   : 0.8;');
fprintf(fpt,'\n        Controller              : Controller_4_Wind_Turbine;');
fprintf(fpt,'\n    ;');
fprintf(fpt,'\n    ActuatorDisplacement:');
fprintf(fpt,'\n        Name                    : pitch_actuator_blade_2;');
fprintf(fpt,'\n        ActuatorType            : 2ND_ORDER_ACTUATOR;');
fprintf(fpt,'\n        ActuatorFrequency       : 5.0;');
fprintf(fpt,'\n        ActuatorDampingFactor   : 0.8;');
fprintf(fpt,'\n        Controller              : Controller_4_Wind_Turbine;');
fprintf(fpt,'\n    ;');
fprintf(fpt,'\n    ActuatorDisplacement:');
fprintf(fpt,'\n        Name                    : pitch_actuator_blade_3;');
fprintf(fpt,'\n        ActuatorType            : 2ND_ORDER_ACTUATOR;');
fprintf(fpt,'\n        ActuatorFrequency       : 5.0;');
fprintf(fpt,'\n        ActuatorDampingFactor   : 0.8;');
fprintf(fpt,'\n        Controller              : Controller_4_Wind_Turbine;');
fprintf(fpt,'\n    ;');
fprintf(fpt,'\n    ActuatorDisplacement:');
fprintf(fpt,'\n        Name                    : yaw_actuator;');
fprintf(fpt,'\n        ActuatorType            : 1ST_ORDER_ACTUATOR;');
fprintf(fpt,'\n        ActuatorTimeConstant    : 0.0;');
fprintf(fpt,'\n        ActuatorGain            : 1.0;');
fprintf(fpt,'\n        Controller              : Controller_4_Wind_Turbine;');
fprintf(fpt,'\n    ;');
fprintf(fpt,'\n;');
fprintf(fpt,'\n');
fprintf(fpt,'\n # CONTROLLER SENSORS....');

fprintf(fpt,'\n');
fprintf(fpt,'\n');
fprintf(fpt,'\n');

fprintf(fpt,'\nSensors :');
fprintf(fpt,'\n  Sensor :');
fprintf(fpt,'\n   Name             : sensor_rotor_speed ;');
fprintf(fpt,'\n   RigidBody        : rb_hub_centre;');
fprintf(fpt,'\n   Sensing          : Velocities;');
fprintf(fpt,'\n   InReferenceFrame : local ;');
fprintf(fpt,'\n   SensorIsActive   : yes;');
fprintf(fpt,'\n   DegreeOfFreedom  : 5;');
fprintf(fpt,'\n  ;');
fprintf(fpt,'\n  Sensor :');
fprintf(fpt,'\n   Name             : sensor_generator_speed ;');
fprintf(fpt,'\n   RigidBody        : rb_generator;');
fprintf(fpt,'\n   Sensing          : Velocities;');
fprintf(fpt,'\n   InReferenceFrame : local ;');
fprintf(fpt,'\n   SensorIsActive   : yes;');
fprintf(fpt,'\n   DegreeOfFreedom  : 5;');
fprintf(fpt,'\n  ;');
fprintf(fpt,'\n  Sensor :');
fprintf(fpt,'\n   Name             : sensor_blade_1_pitch ;');
fprintf(fpt,'\n   RevoluteJoint    : rvj_pitch_controller_1;');
fprintf(fpt,'\n   Sensing          : RelativeRotations;');
fprintf(fpt,'\n   SensorIsActive   : yes;');
fprintf(fpt,'\n   DegreeOfFreedom  : 4;');
fprintf(fpt,'\n  ;');
fprintf(fpt,'\n  Sensor :');
fprintf(fpt,'\n   Name             : sensor_blade_2_pitch ;');
fprintf(fpt,'\n   RevoluteJoint    : rvj_pitch_controller_2;');
fprintf(fpt,'\n   Sensing          : RelativeRotations;');
fprintf(fpt,'\n   SensorIsActive   : yes;');
fprintf(fpt,'\n   DegreeOfFreedom  : 4;');
fprintf(fpt,'\n  ;');
fprintf(fpt,'\n  Sensor :');
fprintf(fpt,'\n   Name             : sensor_blade_3_pitch ;');
fprintf(fpt,'\n   RevoluteJoint    : rvj_pitch_controller_3;');
fprintf(fpt,'\n   Sensing          : RelativeRotations;');
fprintf(fpt,'\n   SensorIsActive   : yes;');
fprintf(fpt,'\n   DegreeOfFreedom  : 4;');
fprintf(fpt,'\n  ;');
fprintf(fpt,'\n  Sensor :');
fprintf(fpt,'\n   Name             : sensor_yaw_rotation ;');
fprintf(fpt,'\n   RevoluteJoint    : rvj_yaw_control ;');
fprintf(fpt,'\n   Sensing          : RelativeRotations;');
fprintf(fpt,'\n   SensorIsActive   : yes;');
fprintf(fpt,'\n   DegreeOfFreedom  : 4;');
fprintf(fpt,'\n  ;');
fprintf(fpt,'\n  Sensor :');
fprintf(fpt,'\n   Name             : sensor_azimuth_rotation ;');
fprintf(fpt,'\n   RevoluteJoint    : rvj_generator ;');
fprintf(fpt,'\n   Sensing          : RelativeRotations;');
fprintf(fpt,'\n   SensorIsActive   : yes;');
fprintf(fpt,'\n   DegreeOfFreedom  : 4;');
fprintf(fpt,'\n  ;');
fprintf(fpt,'\n   Sensor :');
fprintf(fpt,'\n    Name             : sensor_tower_foreaft_velocities ;');
% ALEALE 13.Feb.2019
% fprintf(fpt,'\n    Beam             : %s ;',tower_name(handles.tower.nentries-1,:));
fprintf(fpt,'\n    Beam             : %s ;',tower_name(npoint-1,:));
%
fprintf(fpt,'\n    Sensing          : Velocities;');
fprintf(fpt,'\n    InReferenceFrame : INERTIAL ;');
fprintf(fpt,'\n    EtaValue         : 1 ;');
fprintf(fpt,'\n    SensorIsActive   : yes;');
fprintf(fpt,'\n    DegreeOfFreedom  : 2;');
fprintf(fpt,'\n   ;');
fprintf(fpt,'\n   Sensor :');
fprintf(fpt,'\n    Name             : sensor_tower_sideside_velocities ;');
% ALEALE 13.Feb.2019
% fprintf(fpt,'\n    Beam             : %s ;',tower_name(handles.tower.nentries-1,:));
fprintf(fpt,'\n    Beam             : %s ;',tower_name(npoint-1,:));
%
fprintf(fpt,'\n    Sensing          : Velocities;');
fprintf(fpt,'\n    InReferenceFrame : INERTIAL ;');
fprintf(fpt,'\n    EtaValue         : 1 ;');
fprintf(fpt,'\n    SensorIsActive   : yes;');
fprintf(fpt,'\n    DegreeOfFreedom  : 3;');
fprintf(fpt,'\n  ;');
fprintf(fpt,'\n;');

fclose(fpt);

%%%%%%%%%%%%% DYNAMIC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Send status #LS
disp('  Writing Controller.dat file.........')

rel_path_name = strcat('.\..\..\..\Controller');

fpt=fopen( strcat(dat_file_name(end,:),'\MB_model\Controller.dat') ,'w');

fprintf(fpt,'\nControllers:');
fprintf(fpt,'\n    Controller:');
fprintf(fpt,'\n        Name            : Controller_4_Wind_Turbine;');
fprintf(fpt,'\n        ControllerType  : WindTurbine;');
fprintf(fpt,'\n        SensorList      : sensor_blade_1_pitch,sensor_blade_2_pitch,sensor_blade_3_pitch,sensor_generator_speed,sensor_rotor_speed,');
fprintf(fpt,'\n                          sensor_yaw_rotation, sensor_azimuth_rotation, sensor_tower_foreaft_velocities, sensor_tower_sideside_velocities;');
fprintf(fpt,'\n        ActuatorList    : pres_pitch_rel_rot_1,pres_pitch_rel_rot_2,pres_pitch_rel_rot_3,generator_actuator,pres_yaw_rotation;');
fprintf(fpt,'\n        SensorListNumber      : 4;');                             
fprintf(fpt,'\n        SensorListIndex       : 37, 60, 53, 54 ;');                             
fprintf(fpt,'\n        SensorListDerivative  :  0,  0,  1,  1 ;');  
fprintf(fpt,'\n        ControllerDescriptionFile : .\\input\\Controller\\ControllerDescriptionDynamic_PoliMiController.dat;');
fprintf(fpt,'\n        NumberOfBlades  :  3 ;');
fprintf(fpt,'\n        PitchControlType :  PITCH_POSITION_DEMAND;');
fprintf(fpt,'\n        PitchActuatorList     : pitch_actuator_blade_1,pitch_actuator_blade_2,pitch_actuator_blade_3;');
fprintf(fpt,'\n        ExternalDLLFileName : %s\\PoliWindController_ver4.7.dll;',deblank(rel_path_name));
fprintf(fpt,'\n        CommunicationInterval : 0.02;');
fprintf(fpt,'\n        GearboxRatio : 1.0 ;');
fprintf(fpt,'\n        # Optional Parameters for external dll:');
fprintf(fpt,'\n        ControlParametersNumber :  1 ;  # number of record (MAX 50)');
fprintf(fpt,'\n        ControlParametersIndex:   61 ;  # Record number (start from 1, 0 means none)');
fprintf(fpt,'\n        ControlParameters :        3 ;  # Record values');
fprintf(fpt,'\n        # YAW CONTROL');
fprintf(fpt,'\n        YawTriad : yaw_triad ;');
fprintf(fpt,'\n        ConnectedTo : rigid_body_nacelle ; Where : %s;',pt_tower(handles.tower.nentries,:));
fprintf(fpt,'\n        YawActuator : yaw_actuator;');
fprintf(fpt,'\n');
fprintf(fpt,'\n                # ELECTRICAL LOSSES: choose one of the following models');
fprintf(fpt,'\n                # LUT model (generator shaft power - Power loss):');
fprintf(fpt,'\n                # ElectricalLosses :');
fprintf(fpt,'\n                #    NumberOfTerms : 3 ;');
fprintf(fpt,'\n                #           0          0');
fprintf(fpt,'\n                #     1100000     100000');
fprintf(fpt,'\n                #     5500000     500000');
fprintf(fpt,'\n                # ;');
fprintf(fpt,'\n                # Linear Model (efficiency - No load loss):');
fprintf(fpt,'\n                ElectricalLosses :');
fprintf(fpt,'\n                   NumberOfTerms : 0 ;');
fprintf(fpt,'\n                                  %g   %g',handles.generator.efficiency/100,handles.generator.no_load_power_loss);
fprintf(fpt,'\n                ;');
fprintf(fpt,'\n        ;');
fprintf(fpt,'\n;');
fprintf(fpt,'\n');
fprintf(fpt,'\nTriads :');
fprintf(fpt,'\n    Triad :');
fprintf(fpt,'\n        Name : yaw_triad ;');
fprintf(fpt,'\n        YVector :  0 ,  0 ,  1 ;');
fprintf(fpt,'\n        ZVector :  0 , -1 ,  0 ;');
fprintf(fpt,'\n    ;');
fprintf(fpt,'\n;');
fprintf(fpt,'\n');
fprintf(fpt,'\nActuators:');
fprintf(fpt,'\n    ActuatorForce:');
fprintf(fpt,'\n        Name                    : generator_actuator;');
fprintf(fpt,'\n        ActuatorType            : 1ST_ORDER_ACTUATOR;');
fprintf(fpt,'\n        ActuatorTimeConstant    : 0.01;');
fprintf(fpt,'\n        ActuatorGain            : 1.0;');
fprintf(fpt,'\n        Controller              : Controller_4_Wind_Turbine;');
fprintf(fpt,'\n        Range                   : 0, 1.0E7;');
fprintf(fpt,'\n    ;');
fprintf(fpt,'\n    ActuatorDisplacement:');
fprintf(fpt,'\n        Name                    : pitch_actuator_blade_1;');
fprintf(fpt,'\n        ActuatorType            : 2ND_ORDER_ACTUATOR;');
fprintf(fpt,'\n        ActuatorFrequency       : 5.0;');
fprintf(fpt,'\n        ActuatorDampingFactor   : 0.8;');
fprintf(fpt,'\n        Controller              : Controller_4_Wind_Turbine;');
fprintf(fpt,'\n    ;');
fprintf(fpt,'\n    ActuatorDisplacement:');
fprintf(fpt,'\n        Name                    : pitch_actuator_blade_2;');
fprintf(fpt,'\n        ActuatorType            : 2ND_ORDER_ACTUATOR;');
fprintf(fpt,'\n        ActuatorFrequency       : 5.0;');
fprintf(fpt,'\n        ActuatorDampingFactor   : 0.8;');
fprintf(fpt,'\n        Controller              : Controller_4_Wind_Turbine;');
fprintf(fpt,'\n    ;');
fprintf(fpt,'\n    ActuatorDisplacement:');
fprintf(fpt,'\n        Name                    : pitch_actuator_blade_3;');
fprintf(fpt,'\n        ActuatorType            : 2ND_ORDER_ACTUATOR;');
fprintf(fpt,'\n        ActuatorFrequency       : 5.0;');
fprintf(fpt,'\n        ActuatorDampingFactor   : 0.8;');
fprintf(fpt,'\n        Controller              : Controller_4_Wind_Turbine;');
fprintf(fpt,'\n    ;');
fprintf(fpt,'\n    ActuatorDisplacement:');
fprintf(fpt,'\n        Name                    : yaw_actuator;');
fprintf(fpt,'\n        ActuatorType            : 1ST_ORDER_ACTUATOR;');
fprintf(fpt,'\n        ActuatorTimeConstant    : 0.0;');
fprintf(fpt,'\n        ActuatorGain            : 1.0;');
fprintf(fpt,'\n        Controller              : Controller_4_Wind_Turbine;');
fprintf(fpt,'\n    ;');
fprintf(fpt,'\n;');
fprintf(fpt,'\n');
fprintf(fpt,'\n # CONTROLLER SENSORS....');

fprintf(fpt,'\n');
fprintf(fpt,'\n');
fprintf(fpt,'\n');

fprintf(fpt,'\nSensors :');
fprintf(fpt,'\n  Sensor :');
fprintf(fpt,'\n   Name             : sensor_rotor_speed ;');
fprintf(fpt,'\n   RigidBody        : rb_hub_centre;');
fprintf(fpt,'\n   Sensing          : Velocities;');
fprintf(fpt,'\n   InReferenceFrame : local ;');
fprintf(fpt,'\n   SensorIsActive   : yes;');
fprintf(fpt,'\n   DegreeOfFreedom  : 5;');
fprintf(fpt,'\n  ;');
fprintf(fpt,'\n  Sensor :');
fprintf(fpt,'\n   Name             : sensor_generator_speed ;');
fprintf(fpt,'\n   RigidBody        : rb_generator;');
fprintf(fpt,'\n   Sensing          : Velocities;');
fprintf(fpt,'\n   InReferenceFrame : local ;');
fprintf(fpt,'\n   SensorIsActive   : yes;');
fprintf(fpt,'\n   DegreeOfFreedom  : 5;');
fprintf(fpt,'\n  ;');
fprintf(fpt,'\n  Sensor :');
fprintf(fpt,'\n   Name             : sensor_blade_1_pitch ;');
fprintf(fpt,'\n   RevoluteJoint    : rvj_pitch_controller_1;');
fprintf(fpt,'\n   Sensing          : RelativeRotations;');
fprintf(fpt,'\n   SensorIsActive   : yes;');
fprintf(fpt,'\n   DegreeOfFreedom  : 4;');
fprintf(fpt,'\n  ;');
fprintf(fpt,'\n  Sensor :');
fprintf(fpt,'\n   Name             : sensor_blade_2_pitch ;');
fprintf(fpt,'\n   RevoluteJoint    : rvj_pitch_controller_2;');
fprintf(fpt,'\n   Sensing          : RelativeRotations;');
fprintf(fpt,'\n   SensorIsActive   : yes;');
fprintf(fpt,'\n   DegreeOfFreedom  : 4;');
fprintf(fpt,'\n  ;');
fprintf(fpt,'\n  Sensor :');
fprintf(fpt,'\n   Name             : sensor_blade_3_pitch ;');
fprintf(fpt,'\n   RevoluteJoint    : rvj_pitch_controller_3;');
fprintf(fpt,'\n   Sensing          : RelativeRotations;');
fprintf(fpt,'\n   SensorIsActive   : yes;');
fprintf(fpt,'\n   DegreeOfFreedom  : 4;');
fprintf(fpt,'\n  ;');
fprintf(fpt,'\n  Sensor :');
fprintf(fpt,'\n   Name             : sensor_yaw_rotation ;');
fprintf(fpt,'\n   RevoluteJoint    : rvj_yaw_control ;');
fprintf(fpt,'\n   Sensing          : RelativeRotations;');
fprintf(fpt,'\n   SensorIsActive   : yes;');
fprintf(fpt,'\n   DegreeOfFreedom  : 4;');
fprintf(fpt,'\n  ;');
fprintf(fpt,'\n  Sensor :');
fprintf(fpt,'\n   Name             : sensor_azimuth_rotation ;');
fprintf(fpt,'\n   RevoluteJoint    : rvj_generator ;');
fprintf(fpt,'\n   Sensing          : RelativeRotations;');
fprintf(fpt,'\n   SensorIsActive   : yes;');
fprintf(fpt,'\n   DegreeOfFreedom  : 4;');
fprintf(fpt,'\n  ;');
fprintf(fpt,'\n   Sensor :');
fprintf(fpt,'\n    Name             : sensor_tower_foreaft_velocities ;');
% ALEALE 13.Feb.2019
% fprintf(fpt,'\n    Beam             : %s ;',tower_name(handles.tower.nentries-1,:));
fprintf(fpt,'\n    Beam             : %s ;',tower_name(npoint-1,:));
%
fprintf(fpt,'\n    Sensing          : Velocities;');
fprintf(fpt,'\n    InReferenceFrame : INERTIAL ;');
fprintf(fpt,'\n    EtaValue         : 1 ;');
fprintf(fpt,'\n    SensorIsActive   : yes;');
fprintf(fpt,'\n    DegreeOfFreedom  : 2;');
fprintf(fpt,'\n   ;');
fprintf(fpt,'\n   Sensor :');
fprintf(fpt,'\n    Name             : sensor_tower_sideside_velocities ;');
% ALEALE 13.Feb.2019
% fprintf(fpt,'\n    Beam             : %s ;',tower_name(handles.tower.nentries-1,:));
fprintf(fpt,'\n    Beam             : %s ;',tower_name(npoint-1,:));
%
fprintf(fpt,'\n    Sensing          : Velocities;');
fprintf(fpt,'\n    InReferenceFrame : INERTIAL ;');
fprintf(fpt,'\n    EtaValue         : 1 ;');
fprintf(fpt,'\n    SensorIsActive   : yes;');
fprintf(fpt,'\n    DegreeOfFreedom  : 3;');
fprintf(fpt,'\n  ;');
fprintf(fpt,'\n;');

fclose(fpt);
