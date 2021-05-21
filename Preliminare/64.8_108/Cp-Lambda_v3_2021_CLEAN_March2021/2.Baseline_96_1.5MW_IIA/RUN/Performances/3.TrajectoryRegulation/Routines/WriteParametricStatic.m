function [i_tot]=WriteParametricStatic(WindValues,OutputFile,OUT_WIND,OUT_RPM,OUT_PITCH)

% This routine writes the parametric files for static analisys
%
% INPUT:
% Wind speed values (check the main Cp-Lambda file!)
% OutputFile: output file name
% Wind, Omega and pitch
%
% OUTPUT
% Static parametric file
%
% Author: A.C.,  March 2017

file_i = fopen(OutputFile,'w');
omega = interp1(OUT_WIND,OUT_RPM,WindValues);
pitch = interp1(OUT_WIND,OUT_PITCH,WindValues);


for i_tot = 1:length(WindValues)

    fprintf(file_i,'# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    fprintf(file_i,'\n# parametric nb %i',i_tot);
    fprintf(file_i,'\n# N.B. wind is %g m/s (Remember the TILT angle)',WindValues(i_tot));
    fprintf(file_i,'\n# omega = %1.5e [rpm]; pitch = %1.5e [deg]',omega(i_tot),pitch(i_tot));
    fprintf(file_i,'\n');
    fprintf(file_i,'\nBeginParametricString : 1 ;');
    fprintf(file_i,'\n');
    fprintf(file_i,'\n  TimeFunction :');
    fprintf(file_i,'\n    Name : control_rigid_rotation ;');
    fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
    fprintf(file_i,'\n    NumberOfTerms : 3 ;');
    fprintf(file_i,'\n    Time :    0 ;   FunctionValue : 0 ;');
    fprintf(file_i,'\n    Time :  1.5 ;   FunctionValue : %1.8e ;',omega(i_tot)*pi/30);
    fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',omega(i_tot)*pi/30);
    fprintf(file_i,'\n  ;');
    fprintf(file_i,'\n  TimeFunction :');
    fprintf(file_i,'\n    Name : blade_pitch_control_1 ;');
    fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
    fprintf(file_i,'\n    NumberOfTerms : 3 ;');
    fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
    fprintf(file_i,'\n    Time :  1.5 ;   FunctionValue : %1.8e ;',pitch(i_tot)*pi/180);
    fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',pitch(i_tot)*pi/180);
    fprintf(file_i,'\n  ;');
    fprintf(file_i,'\n  TimeFunction :');
    fprintf(file_i,'\n    Name : blade_pitch_control_2 ;');
    fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
    fprintf(file_i,'\n    NumberOfTerms : 3 ;');
    fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
    fprintf(file_i,'\n    Time :  1.5 ;   FunctionValue : %1.8e ;',pitch(i_tot)*pi/180);
    fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',pitch(i_tot)*pi/180);
    fprintf(file_i,'\n  ;');
    fprintf(file_i,'\n  TimeFunction :');
    fprintf(file_i,'\n    Name : blade_pitch_control_3 ;');
    fprintf(file_i,'\n    TimeFunctionType : User_Defined ;');
    fprintf(file_i,'\n    NumberOfTerms : 3 ;');
    fprintf(file_i,'\n    Time :    0 ;   FunctionValue : %1.8e ;',0);
    fprintf(file_i,'\n    Time :  1.5 ;   FunctionValue : %1.8e ;',pitch(i_tot)*pi/180);
    fprintf(file_i,'\n    Time : 1000 ;   FunctionValue : %1.8e ;',pitch(i_tot)*pi/180);
    fprintf(file_i,'\n  ;');
    fprintf(file_i,'\n');
    fprintf(file_i,'\nEndParametricString : 1 ;\n');
    fprintf(file_i,'\n');
    fprintf(file_i,'\nBeginParametricString : 2 ;');
    fprintf(file_i,'\n  FarFieldFlowVelocity : 0 , %g , 0 ;',WindValues(i_tot));
    fprintf(file_i,'\nEndParametricString : 2 ;\n');
    fprintf(file_i,'\n');
    fprintf(file_i,'\n');
end



fclose(file_i);
