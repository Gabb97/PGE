%==========================================================================
% MAIN Cp-TSR analysis subroutine
%==========================================================================
%
% This routine automatically manages the computation of the CP-TSR-Pitch 
% analysis. Two families of curves can be generated (IDEAL and REAL)
% depending on the User's requirements
%
% INPUT:
% -------------------------------------------------------------------------
% - WT Data fom Excel file
% - Required TSR and pitch vectors
% - Reference speed values for IDEAL and REAL Cp-TSR curves
%
% OUTPUT:
% -------------------------------------------------------------------------
% - Plot of Ideal and Real Cp-TSR curves
% - Preliminary estimation of the power curve and the AEP
%
% DEVELOPMENT HISTORY:
% -------------------------------------------------------------------------
% Author: A.C.,  March 2017 
% Update: A.C.,  February 2019
% Update: L.S.,  March 2020:
%
%                - I've added a parameters controlling the length of the
%                  ramp in the time function. This parameter is
%                  automatically written in the parametric and in the .was
%                  files.
%==========================================================================


clear all
close all
clc


%% Input Data ************************************************************
% main Excel data
ExcelFileName   = '.\..\0.Main\WTData.xlsx';
SheetName       = 'WTData';

% Cp_Lambda Code
Cp_LambdaCode   = '.\..\..\_exe\Cp-Lambda_ver6.3641PGE2020.exe';

% Data
Parameters.TSRVector  = [2:0.2:9.0];                          
Parameters.BetaVector = [-2:.2:0 1 2 3 4 5 10 15 20 30 45 60];      % [deg]
Parameters.WindSpeedR = 9.5;                                        % [m/s]
Parameters.WindSpeedI = 1.0;                                        % [m/s]
Parameters.SaveFlag   = 1;                                          % 1: save figures

% Length of time function ramps (environmental and control t.functions)
% --> Increase these values for smoother generation of the forces
Parameters.PitchOmegaRampTime = 30;  % [sec] Length of time function ramp for omega and pitch 
Parameters.AirGravityRampTime = 20 ;  % [sec] Length of time function ramp for air and gravity 

%% 
addpath('.\Routines');

%% Read General WD Data **************************************************
Parameters.RotorDiameter            = xlsread(ExcelFileName,SheetName,'B2');
Parameters.NacelleUptilt            = xlsread(ExcelFileName,SheetName,'B3');
Parameters.PowerCurve.Efficiency    = xlsread(ExcelFileName,SheetName,'B6');
Parameters.maxPower                 = xlsread(ExcelFileName,SheetName,'B5')/Parameters.PowerCurve.Efficiency*1.0E6; % [W]
Parameters.rho                      = xlsread(ExcelFileName,SheetName,'B9');
Parameters.MinWind                  = xlsread(ExcelFileName,SheetName,'B7');
Parameters.MaxWind                  = xlsread(ExcelFileName,SheetName,'B8');
Parameters.WeibullStruct.Vave       = xlsread(ExcelFileName,SheetName,'B10');
Parameters.WeibullStruct.k          = xlsread(ExcelFileName,SheetName,'B11');

%% Write parametric files ************************************************
iTot = WriteParametric(Parameters);

%% Update was file with ramp length (new #LS)
UpdateWasFilesWithRamp(Parameters);

%% Run Cp-Lambda analysis ************************************************
disp('*** Run Cp-Lambda analysis for IDEAL curves');
[status1, result1] = dos(strcat(Cp_LambdaCode,' RunCpLambdaCurves.was &'), '-echo');
[status2, result2] = dos(strcat(Cp_LambdaCode,' RunCpLambdaCurves_2nd.was &'), '-echo');

reply = input('Press ENTER to continue with real curves','s');

disp('*** Run Cp-Lambda analysis for REAL curves');
[status3, result3] = dos(strcat(Cp_LambdaCode,' RunCpLambdaCurvesReal.was &'), '-echo');
[status4, result4] = dos(strcat(Cp_LambdaCode,' RunCpLambdaCurvesReal_2nd.was &'), '-echo');

reply = input('Press ENTER to continue with plots (be sure simulations ended)','s');
[status, result]=dos('clear.cmd');

%% Plot Both Curves ***********************************************************
FileList = {'./OutputIdeal/CpLambda_', './OutputReal/CpLambda_'};   % WARNING: first IDEAL!
PitchSelection = [1 3 5];
Parameters=PlotCpLambdaCurveComparison(Parameters,FileList,PitchSelection);

%% Plot REAL Curves ***********************************************************
FileList = {'./OutputReal/CpLambda_'};
FileName =   'OutputReal';
Parameters=PlotCpLambdaCurve(Parameters,Parameters.WindSpeedR,FileList,FileName,2);

%% Plot IDEAL Curves ***********************************************************
FileList = {'./OutputIdeal/CpLambda_'};
FileName =   'OutputIdeal';
Parameters=PlotCpLambdaCurve(Parameters,Parameters.WindSpeedI,FileList,FileName,1);

