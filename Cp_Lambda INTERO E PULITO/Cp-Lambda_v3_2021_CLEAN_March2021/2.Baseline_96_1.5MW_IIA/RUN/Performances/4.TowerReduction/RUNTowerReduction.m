%==========================================================================
% Tower reduction subroutine
%==========================================================================
%       This routine drives the computation of the reduced tower
%
% tasks:    1. run CpLambda simulation: RunParametricForTowerFAMovement.was
%           2. read CpLambda output 
%           3. compute the tower M,C,K parameters
%           4. save results.
%
%
% INPUT:
% -------------------------------------------------------------------------
% - A RunParametricForTowerFAMovement.was file in the current directory. 
%   This is a multibody parametric file with different applied forces. 
%   This is quite the same of the static file used to compute the eigs of 
%   the whole system, except:
%              a. ParametricAnalysisParameters :
%                       NumberOfParametricAnalyses : NSim ;
%                       File : ./input/AppliedForce.txt ;
%                  ;
%              b. SensorsForTowerForeAftDispl, instead of the standard sensor.dat
%              c. TimeFunction :
%                       Name : force_schedule ;
%                       TimeFunctionType : User_Defined ;
%                       NumberOfTerms : 3 ;
%                       Time :   0 ;   FunctionValue : 0 ;
%                       Time :  15 ;   FunctionValue : 1 ;
%                       Time : 500 ;   FunctionValue : 1 ;
%                   ;
%              d. GoToParametricString :1;
%
%  - (ForceVector) is the vector with the ForcesApllied to the Tower Tip in
%    [N]. The first value MUST be zero (static deflection)
%
%  - (Code) is the fullpath of the CpLambda code
%
%  - (FirstTowerFAFreq) is the first Fore-Aft tower natural freq [rad/s].
%    It can be easily read from tower eigs or from Campbell diagram.
%
%  - (zeta) is the damping ratio [-]
%
% OUTPUT:
% -------------------------------------------------------------------------
%  - Tower equivalent properties of mass (M), stiffness(K) and damping (C)
%  to be used in the dynamic equations of the LQR
%
% DEVELOPMENT HISTORY:
% -------------------------------------------------------------------------
% Author: A.C.,  March 2017
%
%==========================================================================


close all
clear all
clc

%%%%%%%%%%%%% USER INPUT VALUES end %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% USER INPUT VALUES end %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% USER INPUT VALUES end %%%%%%%%%%%%%%%%%%%%

ForceVector      = [0 -30000 -20000 -10000 10000 20000 30000]*10;     % [N]
Cp_LambdaCode   = '.\..\..\_exe\Cp-Lambda_ver6.3641PGE2020.exe';
FirstTowerFAFreq = 0.3477;    % [rad/s]        %WARNING: this data from Campbell
zeta             = 0.02;      % [-]

%%%%%%%%%%%%% USER INPUT VALUES stop  %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% USER INPUT VALUES stop  %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% USER INPUT VALUES stop  %%%%%%%%%%%%%%%%%%%

%% Set Parameters struct
Parameters.ForceVector      = ForceVector;          clear ForceVector;
Parameters.Code             = Cp_LambdaCode;        clear Code;
Parameters.FirstTowerFAFreq = FirstTowerFAFreq;     clear FirstTowerFAFreq;
Parameters.zeta             = zeta;                 clear zeta;


%% Write AppliedForce.txt file

fin=fopen('.\InputCpLambda\AppliedForce.txt','w');
if (fin<0)
    disp('Problem in writing AppliedForce.txt file!');
    disp('check if exist InputCpLambda dir!');
    return
end

fprintf(fin,'# *** Written by Matlab %s\n\n\n',datestr(now));

for iFile=1:length(Parameters.ForceVector)
    fprintf(fin,'# CASE %i F = %g [N]\n',iFile,Parameters.ForceVector(iFile));
    fprintf(fin,'BeginParametricString : 1 ;\n');
    fprintf(fin,'DeadLoads :\n');
    fprintf(fin,'   DeadLoad :\n');
    fprintf(fin,'       Name : applied_force ;\n');
    fprintf(fin,'       AppliedTo : rb_hub_centre ;\n');
    fprintf(fin,'       Where :     pt_hub_centre ;\n');
    fprintf(fin,'       TimeFunction : force_schedule ;\n');
    fprintf(fin,'       ScalingFactor : 1 ;\n');
    fprintf(fin,'       AppliedForces : 0.0, %g , 0.0 ;\n',Parameters.ForceVector(iFile));
    fprintf(fin,'       AppliedMoments : 0 , 0 , 0 ;\n');
    fprintf(fin,' ;\n');
    fprintf(fin,';\n');
    fprintf(fin,'EndParametricString : 1 ;\n\n\n');
end
fclose(fin);

addpath Routines

%% Run RunParametricForTowerFAMovement.was 
[r,s]=dos([Parameters.Code ' RunParametricForTowerFAMovement.was'])
% clear files
cd OutputCpLambda
[dummy,s]=dos('_Clear.bat');
cd ..


%% Read Output File
Parameters.ForeAftDispl = ReadAndSaveParametricResults(Parameters);



%% Compute Eqv Values
Parameters.Tower = ComputeEqvValuesForTower(Parameters);



%% Save Parameters

save .\Output\Data.mat Parameters 
