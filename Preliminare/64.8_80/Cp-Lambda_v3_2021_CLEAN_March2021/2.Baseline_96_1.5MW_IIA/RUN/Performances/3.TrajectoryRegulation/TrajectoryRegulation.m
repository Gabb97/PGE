%==========================================================================
% MAIN Trajectory regulation subroutine
%==========================================================================
% This script computes the trajectory regulation of the WT starting from
% the CP-TSR curves and the WT data. It also writes a series of files which
% are required by subsequent analyses and depend on the regulation 
% trajectory. These include parametric files for static analysis, the main
% controller parameters (valid for all DLC), turbulent and gusty winds and
% DLC-specific parametric wind grids.
%
% INPUT:
% -------------------------------------------------------------------------
% - WT Data fom Excel file
% - Cp-TSR look-up table from previous analysis (REAL curves recommended)
%
% OUTPUT:
% -------------------------------------------------------------------------
% - Trajectory regulation of the WT
% - Plots of the scheduled pitch, rotor speed and torque vs. wind speed
% - Information about the existence of Region 2.5 (constrained rotor speed)
% - Theoretical estimation of the power curve and the AEP
% - Main controller settings: .\..\..\..\Controller\WTControllerFile.txt
% - All turbulent and gusty winds ( see .\..\..\..\Winds)
% - All DLC-dependant wind grids (see DLC folders and related input files)
%
% DEVELOPMENT HISTORY:
% -------------------------------------------------------------------------
% Author: A.C.,  March 2017
% Update: A.C.,  March 2018           
% Update: A.C.,  February 2019
% Update: L.S.,  March 2020:
%
%                - I've added a subroutine for the automatic update of the
%                  wind grids in the various DLC subfolders (PID and LQR)
%
%                - The treatment of region 2.5 in EvaluatePerformance has
%                  been modified to account for the updated rated speed
%
%                - Corrected a bug in the scheduling of the minimum pitch   
%
%                - Added the automatic update of the rotor speed in the 
%                  EigsBladeRotating.was file
%                   
%                - Now, if the region 2.5 is present, the OmegaMax is
%                  written in the controller file instead of the OmegaRated
%==========================================================================
close all
clear all
clc
commandwindow

%% Define input file names
AeroLookUpFileName  = '.\..\2.CpLambdaCurves\OutputData\OutputReal_MatLookUp.mat' ;
ExcelFileName       = '.\..\0.Main\WTData.xlsx';
SheetName           = 'WTData';

%% Define output data
% For static simulations:
Parameters.WindValues4StaticAnalysis  = [3:2:25];                     % [m/s]
OutputStaticFile = '.\..\..\DLC_PID\DLC_NWP\Input\Wind\ParametricStatic.txt';

% File for controller (Torque-Speed LookUp and min pitch)
ControllerFileNameWT  = '.\..\..\..\Controller\WTControllerFile.txt';

% File for (rotating) blade eigs
EigsFileName          = '.\..\1.Campbell\EigsBladeRotating.was';

% for LQR (next step)
Parameters.LQR.LQRTrimWinds     =   [3:2:8 8.5:0.5:10.5 11:2:25];     % [m/s]
OutputFileName                  = '.\Output\ReferenceCondition4PoliMIController.m';

% for wind
GustWindMainFolder              = '.\..\..\..\Wind\Gusty_Wind\';
TurbulentWindFolder             = '.\..\..\..\Wind\Turbulent_Wind\NTM_seed1_200sec\';
ExtTurbulentWindFolder          = '.\..\..\..\Wind\Turbulent_Wind\EWM50_seed1\';

DLC_PID_Folder                  = '.\..\..\DLC_PID';
DLC_LQR_Folder                  = '.\..\..\DLC_LQR';

MB_model_Folder                 = '.\..\..\..\MB_model';  



%% END INPUT DATA --------------------------------------------------------------------

%% Read General WD Data **************************************************
Parameters.Rotor.RotorDiameter      = xlsread(ExcelFileName,SheetName,'B2');
Parameters.maxVtip                  = xlsread(ExcelFileName,SheetName,'B4');
Parameters.PowerCurve.Efficiency    = xlsread(ExcelFileName,SheetName,'B6');
Parameters.maxPower                 = xlsread(ExcelFileName,SheetName,'B5')/Parameters.PowerCurve.Efficiency*1.0E6; % [W]
Parameters.airProp.rho              = xlsread(ExcelFileName,SheetName,'B9');
Parameters.minWindSpeed             = xlsread(ExcelFileName,SheetName,'B7');
Parameters.maxWindSpeed             = xlsread(ExcelFileName,SheetName,'B8');

Parameters.maxPitch                 = xlsread(ExcelFileName,SheetName,'B13');
Parameters.maxPitchRate             = xlsread(ExcelFileName,SheetName,'B14');
Parameters.maxPitchRateNSD          = xlsread(ExcelFileName,SheetName,'B15');
Parameters.maxPitchRateESD          = xlsread(ExcelFileName,SheetName,'B16');

[~,Parameters.WindData.WTCategory]  = xlsread(ExcelFileName,SheetName,'B29');
Parameters.WindData.WTClass         = xlsread(ExcelFileName,SheetName,'B30');
Parameters.WindData.HubHeight       = xlsread(ExcelFileName,SheetName,'B31');
Parameters.WindData.WindGridSize    = xlsread(ExcelFileName,SheetName,'B32');
Parameters.WindData.WindGridResol   = xlsread(ExcelFileName,SheetName,'B33');
Parameters.WindData.WindGridSample  = xlsread(ExcelFileName,SheetName,'B34');
Parameters.WindData.TimeBeforeGust  = xlsread(ExcelFileName,SheetName,'B35');

% flag
PrintFlag                       =   1;                                % 1 means print & save
AddLQRPoints                    =   0;                                % 1 means add LQR points on figures

% Symbol used in the figures
if Parameters.maxVtip
    symb = '-r';
else
    symb = '--b';
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% GO %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(AeroLookUpFileName);
Parameters.CP_TSR.LookUp = LookUp;

addpath('.\Routines');
addpath('.\RoutinesWinds');

% Compute Trajectory
[Parameters] = EvaluatePerformance(Parameters,symb);

% Plot curves
PlotStabilityCurves(Parameters,PrintFlag,symb);

% Save data for the controller
WriteData4PoliMIControllerFULL(Parameters,OutputFileName,ControllerFileNameWT,PrintFlag,AddLQRPoints,symb);

% Update EigsBladeRotating.was with the value of rotor speed (new #LS)
UpdateEigsBladeRotating(Parameters,EigsFileName);

% Save all data and compute AEP
OutputDataAndPlot;

% Write parametric file for Cp-Lambda static simulation
iTot = WriteParametricStatic(Parameters.WindValues4StaticAnalysis,OutputStaticFile,OUT_WIND,OUT_RPM,OUT_PITCH);

disp(' ')
disp('*** Regulation trajectory complete!')
disp('    Press F5 to generate winds.')
keyboard

%% Write WIND
% Gusty wind
Parameters = MainIECWind(Parameters,GustWindMainFolder);
% Turb Wind
Parameters = MainTurbWind(Parameters,TurbulentWindFolder,ExtTurbulentWindFolder);

% Wind Grids (PID, LQR) #LS 30.03.2020
WriteWindGrids(Parameters,MB_model_Folder,DLC_PID_Folder);
WriteWindGrids(Parameters,MB_model_Folder,DLC_LQR_Folder);



