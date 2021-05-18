function iTot = WriteParametric(Parameters)

% This routine write the the parametric files
%
% INPUT:
% Diameter: rotor diameter [m]
% NacelleUpTilt: nacelle up-tile [deg]
% TSR_vector: array with the TSR values [-]
% beta_vector: array with the pitch values [deg]
% WindSpeed: wind speed value for real curves [m/s]
%
% OUTPUT
% i_tot: numbers of parametric simulations performed. 
% WARNING: The Cp-Lambda input file MUST be modified according to this
% value. The parametric files are supposed divided into two blocks
% More blocks must be created ad hoc!
%
% Author: A.C.,  March 2017


% input values and local variables
Rt          =   Parameters.RotorDiameter/2;      % radius at tip [m]
Nhalf       =   ceil(length(Parameters.BetaVector)/2)+1;
TSRVector   =   Parameters.TSRVector;

RampTime    =   round(Parameters.PitchOmegaRampTime); % Length of the time function ramp #LS

% Send status

disp(' ')
disp('*** Updating parametric input files.......')
disp(' ')


%% FOR REAL CURVE FINE ****************************************************
V_inf     = Parameters.WindSpeedR;  % uniform wind speed [m/s]
tilt      = 0;                      % wind tilt [deg]

% first block ************************
i_tot = 0;
beta_vector = Parameters.BetaVector;
file_i = fopen('./input/Parametric_Real.txt','w');
for i_beta = 1:length(beta_vector)
    for i_TSR = 1:length(TSRVector)

        i_tot = i_tot + 1;

        fprintf(file_i,'# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
        fprintf(file_i,'\n# parametric nb %i',i_tot);
        fprintf(file_i,'\n# N.B. wind must be %1.5e m/s (Remember the TILT angle)',V_inf);
        fprintf(file_i,'\n# Radius is %g [m]',Rt);
        fprintf(file_i,'\n# TSR = %1.5e ; pitch = %1.5e deg',TSRVector(i_TSR),beta_vector(i_beta));
        fprintf(file_i,'\n');
        fprintf(file_i,'\nBeginParametricString : 1 ;');
        fprintf(file_i,'\n');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : control_rigid_rotation ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time : %i   ;   FunctionValue : %1.8e ;',RampTime, TSRVector(i_TSR)/Rt*V_inf);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',TSRVector(i_TSR)/Rt*V_inf);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : blade_pitch_control_1 ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time : %i   ;   FunctionValue : %1.8e ;',RampTime,beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : blade_pitch_control_2 ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time : %i   ;   FunctionValue : %1.8e ;',RampTime,beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : blade_pitch_control_3 ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time : %i   ;   FunctionValue : %1.8e ;',RampTime,beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n');
        fprintf(file_i,'\nEndParametricString : 1 ;\n');
        fprintf(file_i,'\n');
        fprintf(file_i,'\n');
        fprintf(file_i,'\nBeginParametricString : 2 ;');
        fprintf(file_i,'\n');
        fprintf(file_i,'\n   FarFieldFlowVelocity : %1.8e , %1.8e , 0 ;',-sin(tilt*pi/180)*V_inf,cos(tilt*pi/180)*V_inf);
        fprintf(file_i,'\n');
        fprintf(file_i,'\nEndParametricString : 2 ;\n');
        fprintf(file_i,'\n');
    end

end
fclose(file_i);

iTot(2) = i_tot;

% second block ************************
i_tot = 0;
beta_vector = Parameters.BetaVector(Nhalf:end);
file_i = fopen('./input/Parametric_Real_2nd.txt','w');
for i_beta = 1:length(beta_vector)
    for i_TSR = 1:length(TSRVector)

        i_tot = i_tot + 1;

        fprintf(file_i,'# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
        fprintf(file_i,'\n# parametric nb %i',i_tot);
        fprintf(file_i,'\n# N.B. wind must be %1.5e m/s (Remember the TILT angle)',V_inf);
        fprintf(file_i,'\n# Radius is %g [m]',Rt);
        fprintf(file_i,'\n# TSR = %1.5e ; pitch = %1.5e deg',TSRVector(i_TSR),beta_vector(i_beta));
        fprintf(file_i,'\n');
        fprintf(file_i,'\nBeginParametricString : 1 ;');
        fprintf(file_i,'\n');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : control_rigid_rotation ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time : %i   ;   FunctionValue : %1.8e ;',RampTime,TSRVector(i_TSR)/Rt*V_inf);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',TSRVector(i_TSR)/Rt*V_inf);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : blade_pitch_control_1 ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time : %i   ;   FunctionValue : %1.8e ;',RampTime,beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : blade_pitch_control_2 ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time : %i   ;   FunctionValue : %1.8e ;',RampTime,beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : blade_pitch_control_3 ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time : %i   ;   FunctionValue : %1.8e ;',RampTime,beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n');
        fprintf(file_i,'\nEndParametricString : 1 ;\n');
        fprintf(file_i,'\n');
        fprintf(file_i,'\n');
        fprintf(file_i,'\nBeginParametricString : 2 ;');
        fprintf(file_i,'\n');
        fprintf(file_i,'\n   FarFieldFlowVelocity : %1.8e , %1.8e , 0 ;',-sin(tilt*pi/180)*V_inf,cos(tilt*pi/180)*V_inf);
        fprintf(file_i,'\n');
        fprintf(file_i,'\nEndParametricString : 2 ;\n');
        fprintf(file_i,'\n');
    end

end
fclose(file_i);

iTot(1) = i_tot;

%% FOR IDEAL CURVE FINE ****************************************************
V_inf     = Parameters.WindSpeedI;  % uniform wind speed [m/s]
tilt      = Parameters.NacelleUptilt;           % wind tilt [deg]

% first block ************************
i_tot = 0;
beta_vector = Parameters.BetaVector;
file_i = fopen('./input/Parametric_Axial1.txt','w');
for i_beta = 1:length(beta_vector)
    for i_TSR = 1:length(TSRVector)

        i_tot = i_tot + 1;

        fprintf(file_i,'# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
        fprintf(file_i,'\n# parametric nb %i',i_tot);
        fprintf(file_i,'\n# N.B. wind must be %1.5e m/s (Remember the TILT angle)',V_inf);
        fprintf(file_i,'\n# Radius is %g [m]',Rt);
        fprintf(file_i,'\n# TSR = %1.5e ; pitch = %1.5e deg',TSRVector(i_TSR),beta_vector(i_beta));
        fprintf(file_i,'\n');
        fprintf(file_i,'\nBeginParametricString : 1 ;');
        fprintf(file_i,'\n');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : control_rigid_rotation ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time : %i   ;   FunctionValue : %1.8e ;',RampTime, TSRVector(i_TSR)/Rt*V_inf);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',TSRVector(i_TSR)/Rt*V_inf);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : blade_pitch_control_1 ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time : %i   ;   FunctionValue : %1.8e ;',RampTime, beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : blade_pitch_control_2 ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time : %i   ;   FunctionValue : %1.8e ;',RampTime, beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : blade_pitch_control_3 ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time : %i   ;   FunctionValue : %1.8e ;',RampTime,beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n');
        fprintf(file_i,'\nEndParametricString : 1 ;\n');
        fprintf(file_i,'\n');
        fprintf(file_i,'\n');
        fprintf(file_i,'\nBeginParametricString : 2 ;');
        fprintf(file_i,'\n');
        fprintf(file_i,'\n   FarFieldFlowVelocity : %1.8e , %1.8e , 0 ;',-sin(tilt*pi/180)*V_inf,cos(tilt*pi/180)*V_inf);
        fprintf(file_i,'\n');
        fprintf(file_i,'\nEndParametricString : 2 ;\n');
        fprintf(file_i,'\n');
    end

end
fclose(file_i);

% second block ************************
i_tot = 0;
beta_vector = Parameters.BetaVector(Nhalf:end);
file_i = fopen('./input/Parametric_Axial1_2nd.txt','w');
for i_beta = 1:length(beta_vector)
    for i_TSR = 1:length(TSRVector)

        i_tot = i_tot + 1;

        fprintf(file_i,'# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
        fprintf(file_i,'\n# parametric nb %i',i_tot);
        fprintf(file_i,'\n# N.B. wind must be %1.5e m/s (Remember the TILT angle)',V_inf);
        fprintf(file_i,'\n# Radius is %g [m]',Rt);
        fprintf(file_i,'\n# TSR = %1.5e ; pitch = %1.5e deg',TSRVector(i_TSR),beta_vector(i_beta));
        fprintf(file_i,'\n');
        fprintf(file_i,'\nBeginParametricString : 1 ;');
        fprintf(file_i,'\n');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : control_rigid_rotation ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time : %i   ;   FunctionValue : %1.8e ;',RampTime,TSRVector(i_TSR)/Rt*V_inf);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',TSRVector(i_TSR)/Rt*V_inf);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : blade_pitch_control_1 ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time : %i   ;   FunctionValue : %1.8e ;',RampTime,beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : blade_pitch_control_2 ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time : %i   ;   FunctionValue : %1.8e ;',RampTime,beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : blade_pitch_control_3 ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time : %i   ;   FunctionValue : %1.8e ;',RampTime,beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n');
        fprintf(file_i,'\nEndParametricString : 1 ;\n');
        fprintf(file_i,'\n');
        fprintf(file_i,'\n');
        fprintf(file_i,'\nBeginParametricString : 2 ;');
        fprintf(file_i,'\n');
        fprintf(file_i,'\n   FarFieldFlowVelocity : %1.8e , %1.8e , 0 ;',-sin(tilt*pi/180)*V_inf,cos(tilt*pi/180)*V_inf);
        fprintf(file_i,'\n');
        fprintf(file_i,'\nEndParametricString : 2 ;\n');
        fprintf(file_i,'\n');
    end

end



fclose(file_i);
