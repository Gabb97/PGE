function i_tot = WriteParametricFiles4Campbell(Parameters,Omega_vector)

% This routine write the parametric files for the Campbell analysis
%
% INPUT:
% Diameter: rotor diameter [m]
% NacelleUpTilt: nacelle up-tile [deg]
% Omega_vector: array with the rotor speed values [rpm]
%
% OUTPUT
% i_tot: number of parametric simulations performed. 
% WARNING: The Cp-Lambda input file MUST be modified according to this value
%
% Author: A.C.,  March 2017


% input values
Rt        = Parameters.RotorDiameter/2;      % radius at tip [m]
tilt      = Parameters.NacelleUptilt;         % wind tilt [deg]


% default values
V_inf     = 1;         % uniform wind speed [m/s]
beta_vector  = 0;      % [deg]
file_i = fopen('./input/Parametric_pitch0.txt','w');


i_tot = 0;
Omega_vector= Omega_vector*pi/30; 
TSR_vector   = Omega_vector*Rt/V_inf;

for i_beta = 1:length(beta_vector)
    for i_TSR = 1:length(TSR_vector)

        i_tot = i_tot + 1;

        fprintf(file_i,'# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
        fprintf(file_i,'\n# parametric nb %i',i_tot);
        fprintf(file_i,'\n# N.B. wind must be %1.5e m/s (Remember the TILT angle)',V_inf);
        fprintf(file_i,'\n# Radius is %g [m]',Rt);
        fprintf(file_i,'\n# TSR = %1.5e ; pitch = %1.5e deg',TSR_vector(i_TSR),beta_vector(i_beta));
        fprintf(file_i,'\n');
        fprintf(file_i,'\nBeginParametricString : 1 ;');
        fprintf(file_i,'\n');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : control_rigid_rotation ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :   0 ;   FunctionValue : 0 ;');
        fprintf(file_i,'\n    Time :  15 ;   FunctionValue : %1.8e ;',TSR_vector(i_TSR)/Rt*V_inf);
        fprintf(file_i,'\n    Time : 500 ;   FunctionValue : %1.8e ;',TSR_vector(i_TSR)/Rt*V_inf);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : blade_pitch_control_1 ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time :   15 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : blade_pitch_control_2 ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time :   15 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n  TimeFunction :');
        fprintf(file_i,'\n    Name : blade_pitch_control_3 ;');
        fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
        fprintf(file_i,'\n    NumberOfTerms : 3 ;');
        fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
        fprintf(file_i,'\n    Time :   15 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',beta_vector(i_beta)*pi/180);
        fprintf(file_i,'\n  ;');
        fprintf(file_i,'\n');
        fprintf(file_i,'\nEndParametricString : 1 ;\n');
        fprintf(file_i,'\n');
        fprintf(file_i,'\n');
        fprintf(file_i,'\nBeginParametricString : 2 ;');
        fprintf(file_i,'\n');
        fprintf(file_i,'\n   FarFieldFlowVelocity : %1.8e , %1.8e , 0 ;',-sin(tilt*pi/180)*V_inf,cos(tilt*pi/180)*V_inf);        fprintf(file_i,'\n');
        fprintf(file_i,'\nEndParametricString : 2 ;\n');
        fprintf(file_i,'\n');
    end

end



fclose(file_i);


