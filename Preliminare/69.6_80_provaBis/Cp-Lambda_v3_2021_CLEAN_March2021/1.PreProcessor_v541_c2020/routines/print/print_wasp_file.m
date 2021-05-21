function print_wasp_file( hub , dat_file_name , PathStruct)


fpw = fopen(strcat(dat_file_name(end,:),'\RUN\U\DLCxx\Run_static.was'), 'w' );

%------------------------------------------------------------
%  Simulation control parameters
fprintf(fpw,'ControlParameters:\n'); 
fprintf(fpw,'  File : .\\output\\StaticSimulationOutput;\n'); 
fprintf(fpw,'  ModelInput        : yes; OutputLevel: 1;\n'); 
fprintf(fpw,'  ModelAssembly     : yes; OutputLevel: 1;\n'); 
fprintf(fpw,'  MultibodyAnalysis : yes; OutputLevel: 1;\n'); 
fprintf(fpw,'  PostProcessing    : yes; OutputLevel: 1;\n');
fprintf(fpw,'  Files4View        : yes;\n');
fprintf(fpw,'  #  ParametricAnalysisParameters :\n');
fprintf(fpw,'  #    NumberOfParametricAnalyses : 12 ;\n');
fprintf(fpw,'  #    File : ./input/ParametricWind.txt ;\n');
fprintf(fpw,'  #    ParametricAnalysisFirstNumber : 1 ;\n');
fprintf(fpw,'  #    ParametricAnalysisFileNameList : _3ms, _5ms, _7ms, _9ms, _11ms, _13ms, _15ms, _17ms, _19ms, _21ms, _23ms, _25ms;\n');
fprintf(fpw,'  #  ;\n');
fprintf(fpw,';\n\n\n'); 
%------------------------------------------------------------

%---------------
% Model input 
%---------------
fprintf(fpw,'ModelInput:\n'); 


%----------------------------------
% Fixed frame

% rotor_frame(PathStruct, hub , 'null' ,'y' , fpw);
% 
fprintf(fpw,'\n'); 
%----------------------------------


fprintf(fpw,'IncludeCommand :\n'); 

print_include( fpw , dat_file_name , 's' );

fprintf(fpw,' ;\n'); 
fprintf(fpw,'\n'); 

fprintf(fpw,'TimeFunctions :\n'); 
fprintf(fpw,'  TimeFunction :\n'); 
fprintf(fpw,'    Name : control_rigid_rotation ;\n'); 
fprintf(fpw,'    TimeFunctionType : User_Defined ;\n'); 
fprintf(fpw,'    NumberOfTerms : 4 ;  \n'); 
fprintf(fpw,'    Time :   0 ;   FunctionValue : 0 ;\n'); 
fprintf(fpw,'    Time :   5 ;   FunctionValue : 0 ;\n'); 
fprintf(fpw,'    Time :  15 ;   FunctionValue : 1.9 ;    \n'); 
fprintf(fpw,'    Time : 500 ;   FunctionValue : 1.9 ;    \n'); 
fprintf(fpw,'  ;\n'); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Blade pitch control time functions
fprintf(fpw,'  #TimeFunction :\n'); 
fprintf(fpw,'  #  Name : blade_pitch_control_1 ;\n'); 
fprintf(fpw,'  #  TimeFunctionType : User_Defined ;\n'); 
fprintf(fpw,'  #  NumberOfTerms : 2 ;  \n'); 
fprintf(fpw,'  #  Time :   0 ;   FunctionValue : 0 ;\n'); 
fprintf(fpw,'  #  Time : 100 ;   FunctionValue : 0 ;    \n'); 
fprintf(fpw,'  #;\n'); 
fprintf(fpw,'  #TimeFunction :\n'); 
fprintf(fpw,'  #  Name : blade_pitch_control_2 ;\n'); 
fprintf(fpw,'  #  TimeFunctionType : User_Defined ;\n'); 
fprintf(fpw,'  #  NumberOfTerms : 2 ;  \n'); 
fprintf(fpw,'  #  Time :   0 ;   FunctionValue : 0 ;\n'); 
fprintf(fpw,'  #  Time : 100 ;   FunctionValue : 0 ;    \n'); 
fprintf(fpw,'  #;\n'); 
fprintf(fpw,'  #TimeFunction :\n'); 
fprintf(fpw,'  #  Name : blade_pitch_control_3 ;\n'); 
fprintf(fpw,'  #  TimeFunctionType : User_Defined ;\n'); 
fprintf(fpw,'  #  NumberOfTerms : 2 ;  \n'); 
fprintf(fpw,'  #  Time :   0 ;   FunctionValue : 0 ;\n'); 
fprintf(fpw,'  #  Time : 100 ;   FunctionValue : 0 ;    \n'); 
fprintf(fpw,'  #;\n'); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(fpw,'  #TimeFunction :\n'); 
fprintf(fpw,'  #  Name : yaw_control ;\n'); 
fprintf(fpw,'  #  TimeFunctionType : User_Defined ;\n'); 
fprintf(fpw,'  #  NumberOfTerms : 2 ;  \n'); 
fprintf(fpw,'  #  Time :   0 ;   FunctionValue : 0 ;\n'); 
fprintf(fpw,'  #  Time : 100 ;   FunctionValue : 0 ;    \n'); 
fprintf(fpw,'  #;\n'); 
fprintf(fpw,'  TimeFunction :\n'); 
fprintf(fpw,'    Name : air_raising ;\n'); 
fprintf(fpw,'    TimeFunctionType : User_Defined ;\n'); 
fprintf(fpw,'    NumberOfTerms : 3 ;  \n'); 
fprintf(fpw,'    Time :   0 ;   FunctionValue : 0 ;\n'); 
fprintf(fpw,'    Time :   5 ;   FunctionValue : 1 ;    \n');
fprintf(fpw,'    Time : 500 ;   FunctionValue : 1 ;    \n');
fprintf(fpw,'  ;\n'); 
fprintf(fpw,'  TimeFunction :\n'); 
fprintf(fpw,'    Name : gravity_schedule ;\n'); 
fprintf(fpw,'    TimeFunctionType : User_Defined ;\n'); 
fprintf(fpw,'    NumberOfTerms : 3 ;  \n'); 
fprintf(fpw,'    Time :   0 ;   FunctionValue : 0 ;\n');
fprintf(fpw,'    Time :   5 ;   FunctionValue : 1 ;    \n');
fprintf(fpw,'    Time : 500 ;   FunctionValue : 1 ;    \n');
fprintf(fpw,'  ;\n'); 
fprintf(fpw,';\n'); 


fprintf(fpw,'Gravity:\n');
fprintf(fpw,'  GravityVector : -9.200 , 0 , 0 ; \n');
fprintf(fpw,'  TimeFunction : gravity_schedule ;\n');
fprintf(fpw,' ;\n');


fprintf(fpw,'AirProperties :\n'); 
fprintf(fpw,'  AirDensity : 1.300 ;\n'); 
fprintf(fpw,'  SpeedOfSound : 1.4604e-005 ;\n'); 
fprintf(fpw,'  FarFieldFlowVelocity : 0 , 7 , 0 ;\n'); 
fprintf(fpw,'  SlopeOfLiftCurve : 1 ;\n'); 
fprintf(fpw,'  DragCoefficient : 0.5 ;\n'); 
fprintf(fpw,'  MomentCoefficients : 0 , 0 ;\n'); 
fprintf(fpw,'  TimeFunction : air_raising ;\n'); 
fprintf(fpw,';\n'); 
fprintf(fpw,'AnimationParameters:\n'); 
fprintf(fpw,'  TimeStepSize : 1.0E+00;\n'); 
fprintf(fpw,';\n'); 

fprintf(fpw,';\n'); 

fprintf(fpw,'ModelAssembly:\n'); 
fprintf(fpw,'  ModelAssemblyParameters:\n'); 
fprintf(fpw,'    TypeOfAnalysis: static;\n'); 
fprintf(fpw,'  ;\n'); 
fprintf(fpw,';\n'); 

fprintf(fpw,'MultibodyAnalysis:\n'); 
fprintf(fpw,'  SimulationControlParameters:\n'); 
fprintf(fpw,'    MaximumNumberOfTimeSteps  : 10000;\n'); 
fprintf(fpw,'    TimeRange                 : 0.0,20;\n'); 
fprintf(fpw,'    TimeStepSizeRange         : 1,1;\n'); 
fprintf(fpw,'    ReferenceEnergyValue      : 1e+7;\n'); 
fprintf(fpw,'  ;\n'); 
fprintf(fpw,'  InitialConditions:;\n'); 
fprintf(fpw,'  TimeStepControlParameters:\n'); 
fprintf(fpw,'    TimeStepSize              : 1 ;\n'); 
fprintf(fpw,'    FactorizationFrequency    : 1 ;\n'); 
fprintf(fpw,'    MaximumNumberOfIterations : 30 ;\n'); 
fprintf(fpw,'    ConvergenceTolerance      : 1.0e-6 ;\n'); 
fprintf(fpw,'    ArchivalFrequency         : 1 ;\n'); 
fprintf(fpw,'    MaximumNumberOfTheseSteps : 10000;\n'); 
% fprintf(fpw,'    AverageStiffnessTerm : 1e10 ;\n');
% fprintf(fpw,'    AverageMassTerm : 1e3 ;\n');
fprintf(fpw,'#    NumberOfEigenvalues : 40 ;\n'); 
fprintf(fpw,'#    EigenproblemPrintFlag : 0 ;    \n'); 
fprintf(fpw,'  ;\n'); 
fprintf(fpw,';\n'); 

fprintf(fpw,'PostProcessing:;\n'); 

fclose(fpw);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         DYNAMIC                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% fpw = fopen('Multibody\Run_dynamic.was','w');
fpw = fopen(strcat(dat_file_name(end,:),'\RUN\U\DLCxx\Run_dynamic.was'), 'w' );

%------------------------------------------------------------
%  Simulation control parameters
fprintf(fpw,'ControlParameters:\n'); 
fprintf(fpw,'  File : .\\output\\DynamicSimulationOutput;\n'); 
fprintf(fpw,'  ModelInput        : yes; OutputLevel: 1;\n'); 
fprintf(fpw,'  ModelAssembly     : yes; OutputLevel: 1;\n'); 
fprintf(fpw,'  MultibodyAnalysis : yes; OutputLevel: 1;\n'); 
fprintf(fpw,'  PostProcessing    : yes; OutputLevel: 1;\n'); 
fprintf(fpw,'  Files4View        : yes;\n');
fprintf(fpw,'  #  ParametricAnalysisParameters :\n');
fprintf(fpw,'  #    NumberOfParametricAnalyses : 12 ;\n');
fprintf(fpw,'  #    File : ./input/ParametricWind.txt ;\n');
fprintf(fpw,'  #    ParametricAnalysisFirstNumber : 1 ;\n');
fprintf(fpw,'  #    ParametricAnalysisFileNameList : _3ms, _5ms, _7ms, _9ms, _11ms, _13ms, _15ms, _17ms, _19ms, _21ms, _23ms, _25ms;\n');
fprintf(fpw,'  #  ;\n');
fprintf(fpw,';\n\n\n'); 
%------------------------------------------------------------

%---------------
% Model input 
%---------------
fprintf(fpw,'ModelInput:\n'); 


%----------------------------------
% Fixed frame

% rotor_frame(PathStruct, hub , 'null' ,'y' , fpw);

fprintf(fpw,'\n'); 
%----------------------------------


fprintf(fpw,'IncludeCommand :\n'); 

print_include( fpw , dat_file_name , 'd' );

fprintf(fpw,' ;\n'); 
fprintf(fpw,'\n'); 

fprintf(fpw,'#TimeFunctions :\n'); 
fprintf(fpw,'#   TimeFunction :\n'); 
fprintf(fpw,'#     Name : control_rigid_rotation ;\n'); 
fprintf(fpw,'#     TimeFunctionType : User_Defined ;\n'); 
fprintf(fpw,'#     NumberOfTerms : 2 ;  \n'); 
fprintf(fpw,'#     Time :   0 ;   FunctionValue : 0 ;\n'); 
fprintf(fpw,'#     Time :1000 ;   FunctionValue : 0 ;    \n'); 
fprintf(fpw,'#   ;\n'); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Blade pitch control time functions
fprintf(fpw,'#   TimeFunction :\n'); 
fprintf(fpw,'#     Name : blade_pitch_control_1 ;\n'); 
fprintf(fpw,'#     TimeFunctionType : User_Defined ;\n'); 
fprintf(fpw,'#     NumberOfTerms : 2 ;  \n'); 
fprintf(fpw,'#     Time :   0 ;   FunctionValue : 0 ;\n'); 
fprintf(fpw,'#     Time :1000 ;   FunctionValue : 0 ;    \n'); 
fprintf(fpw,'#   ;\n'); 
fprintf(fpw,'#   TimeFunction :\n'); 
fprintf(fpw,'#     Name : blade_pitch_control_2 ;\n'); 
fprintf(fpw,'#     TimeFunctionType : User_Defined ;\n'); 
fprintf(fpw,'#     NumberOfTerms : 2 ;  \n'); 
fprintf(fpw,'#     Time :   0 ;   FunctionValue : 0 ;\n'); 
fprintf(fpw,'#     Time :1000 ;   FunctionValue : 0 ;    \n'); 
fprintf(fpw,'#   ;\n'); 
fprintf(fpw,'#   TimeFunction :\n'); 
fprintf(fpw,'#     Name : blade_pitch_control_3 ;\n'); 
fprintf(fpw,'#     TimeFunctionType : User_Defined ;\n'); 
fprintf(fpw,'#     NumberOfTerms : 2 ;  \n'); 
fprintf(fpw,'#     Time :   0 ;   FunctionValue : 0 ;\n'); 
fprintf(fpw,'#     Time :1000 ;   FunctionValue : 0 ;    \n'); 
fprintf(fpw,'#   ;\n'); 
fprintf(fpw,'#   TimeFunction :\n'); 
fprintf(fpw,'#     Name : yaw_control ;\n'); 
fprintf(fpw,'#     TimeFunctionType : User_Defined ;\n'); 
fprintf(fpw,'#     NumberOfTerms : 2 ;  \n'); 
fprintf(fpw,'#     Time :   0 ;   FunctionValue : 0 ;\n'); 
fprintf(fpw,'#     Time :1000 ;   FunctionValue : 0 ;    \n'); 
fprintf(fpw,'#   ;\n'); 

fprintf(fpw,'# ;\n'); 


fprintf(fpw,'Gravity:\n');
fprintf(fpw,'  GravityVector : -9.200 , 0 , 0 ; \n');
fprintf(fpw,' ;\n');

fprintf(fpw,'AirProperties :\n'); 
fprintf(fpw,'  AirDensity : 1.300 ;\n'); 
fprintf(fpw,'  SpeedOfSound : 1.4604e-005 ;\n'); 
fprintf(fpw,'  FarFieldFlowVelocity : 0 , 7 , 0 ;\n'); 
fprintf(fpw,'  SlopeOfLiftCurve : 1 ;\n'); 
fprintf(fpw,'  DragCoefficient : 0.5 ;\n'); 
fprintf(fpw,'  MomentCoefficients : 0 , 0 ;\n'); 
fprintf(fpw,';\n'); 
fprintf(fpw,'AnimationParameters:\n'); 
fprintf(fpw,'  TimeStepSize : 1.0E-01;\n'); 
fprintf(fpw,';\n'); 

fprintf(fpw,';\n'); 

fprintf(fpw,'ModelAssembly:\n'); 
fprintf(fpw,'  ModelAssemblyParameters:\n'); 
fprintf(fpw,'    TypeOfAnalysis: dynamic ;\n'); 
fprintf(fpw,'  ;\n'); 
fprintf(fpw,';\n'); 

fprintf(fpw,'MultibodyAnalysis:\n'); 
fprintf(fpw,'  SimulationControlParameters:\n'); 
fprintf(fpw,'    MaximumNumberOfTimeSteps  : 999999999;\n'); 
fprintf(fpw,'    TimeRange                 : 0.0,10;\n'); 
fprintf(fpw,'    TimeStepSizeRange         : 1e-5,1e-2;\n'); 
fprintf(fpw,'    ReferenceEnergyValue      : 1e+7;\n'); 
fprintf(fpw,'  ;\n'); 
fprintf(fpw,'  InitialConditions:\n');
fprintf(fpw,'    File : .\\output\\StaticSimulationOutput.rcv ;\n');
fprintf(fpw,'    FileTimeStepNumber : 20 ;\n');
fprintf(fpw,'    InitialTimeStepNumber : 1 ;\n');
fprintf(fpw,'    InitialTime : 0.0 ;  \n');
fprintf(fpw,';\n'); 
fprintf(fpw,'  TimeStepControlParameters:\n'); 
fprintf(fpw,'    TimeStepSize              : 2e-2 ;\n'); 
fprintf(fpw,'    FactorizationFrequency    : 1 ;\n'); 
fprintf(fpw,'    MaximumNumberOfIterations : 30 ;\n'); 
fprintf(fpw,'    ConvergenceTolerance      : 1.0e-6 ;\n'); 
fprintf(fpw,'    ArchivalFrequency         : 10 ;\n'); 
fprintf(fpw,'    MaximumNumberOfTheseSteps : 999999999;\n'); 
% fprintf(fpw,'    AverageStiffnessTerm : 1e10 ;\n');
% fprintf(fpw,'    AverageMassTerm : 1e3 ;\n');
fprintf(fpw,'  ;\n'); 
fprintf(fpw,';\n'); 

fprintf(fpw,'PostProcessing:;\n'); 

fclose(fpw);
