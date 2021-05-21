%==========================================================================
% MAIN Blade/Tower/Turbine eigenanalysis subroutine
%==========================================================================
%
% This routine manages various analyses for the computation of system
% eigenmodes. Available analysis are: 
% 1) single clamped blade standing or rotating
% 2) tower 
% 3) Campbell diagram of the whole WT
% All analyses are perfomed sequentially by this subroutine.
%
% INPUT:
% -------------------------------------------------------------------------
% - WT Data fom Excel file
%
% OUTPUT:
% -------------------------------------------------------------------------
% - Plot of blade and tower Eigs and Campbell diagram
%
% DEVELOPMENT HISTORY:
% -------------------------------------------------------------------------
% Author: A.C.,  March 2017
% Update: A.C.,  February 2019
% Update: L.S.,  March 2020:
%
%                - I've added a subroutine for the automatic update of the
%                  tilt angle in 'Blade_4_eigs_rotating.dat' file
%
%==========================================================================
clear all
close all
clc


%% Input Data
% main xxcel data
ExcelFileName   = '.\..\0.Main\WTData.xlsx';
SheetName       = 'WTData';
% Cp_Lambda Code
Cp_LambdaCode   = '.\..\..\_exe\Cp-Lambda_ver6.3641PGE2020.exe';
% Data
OmegaVector     = [0:2:18];   % [rpm]
TowerFlag       = 1;            % 1: compute and plot also tower eigs
SaveFlag        = 1;            % 1: save figures

%%
addpath('.\Routines');

%% Read General WD Data
Parameters.RotorDiameter = xlsread(ExcelFileName,SheetName,'B2');
Parameters.NacelleUptilt   = xlsread(ExcelFileName,SheetName,'B3');

commandwindow

% Update the rigid rotation with the tilt angle #LS 30.03.2020
UpdateTiltAngleInRigidRotation(Parameters);

%% Blade Eigs
% run Cp-Lambda analysis
disp('*** Run Cp-Lambda analysis for Blade Static Eigs');
[status1, result1] = dos(strcat(Cp_LambdaCode,' EigsBlade.was'), '-echo');

disp('*** Run Cp-Lambda before analysis for Blade Rotating Eigs');
disp('****** PLEASE CHECK the rotation speed inside the Cp-Lambda main file!')
[status2, result2] = dos(strcat(Cp_LambdaCode,' EigsBladeRotating.was'), '-echo');

if (TowerFlag)
    disp('*** Run Cp-Lambda analysis for Tower Eigs');
    [status3, result3] = dos(strcat(Cp_LambdaCode,' EigsTower.was'), '-echo');
end

% read and plot
Eigs = ReadEigsFromParametricFile(TowerFlag,SaveFlag);

%% Campbell
% write parametric file
ParametricNb = WriteParametricFiles4Campbell(Parameters,OmegaVector);
% run
disp('*** Run Cp-Lambda analysis for Campbell');
disp('****** PLEASE CHECK before the NumberOfParametricAnalyses in the main Cp-Lambda file!')
[status1, result1] = dos(strcat(Cp_LambdaCode,' Campbell.was &'), '-echo');
% plot
reply = input('Press ENTER to continue with plots (be sure simulations ended)','s');
EigsC = ComputeCampbell(OmegaVector,SaveFlag);
