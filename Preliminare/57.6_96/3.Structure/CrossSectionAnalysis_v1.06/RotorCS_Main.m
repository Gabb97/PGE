%% CROSS-SECTIONAL SOLVER
%==========================================================================
% This is version 1.06 of this program, made for the 2020 edition of the
% course on wind turbines design. This version is compatible with Cp_lambda
% Pre-Processor ver. 5.41

% Updates
% - 20.03.2020  -   The file 'Point_masses.txt' is no longer generated, as
%                   part of the output
%
%               -   Output files for Cp-Lambda are now generated on a
%                   nondimensional spanwise coordinate
%
% - 16.05.2018  -   Added 'Point_masses.txt'as part of the output files for
%                   Cp-Lambda   
%
%               -   Output files for Cp-Lambda can now be generated
%                   DIRECTLY in the Pre-Processor input folder.
%              	    
%               -   Added plot option 4 which plots only a single component
%                   of stress and strain.
%
%               -   Figure titles now show section ID and nondimensional
%                   location.
%
% - 15.03.2017  -   Enabled sectional element for LE/TE reinforcements.
%
% - 12.03.2017  -   Output 'Elements' have been re-arranged.
%==========================================================================

clc
close all
clear all
fclose('all');

commandwindow;

tic;

%% Define Python path (4 Windows 10 users)
python_path = 'C:\Python33';            %%% CHECK THIS


%% Include folders

addpath('.\Routines_BS');
addpath('.\Routines_AirfDisc');
addpath('.\Routines_BECAS');
addpath('.\Routines_Modes');


%% prepare directores
BS_PrepareDirs;
CheckPythonPath(python_path);

%% Initialize
disp('===================================================================')
disp('    Rotor Cross-Sectional Analysis');
disp('    Ver.1.06 - 20.03.2020');
disp('    Powered by BECAS and AirfoilDisc');
disp('===================================================================')

%%=========================================================================
%% 1.PRE-PROCESSOR
%%=========================================================================
% At this step, the airfoil files and the element files are scanned. in
% order to prepare sectional layout files for each section of interest.
disp('RUNNING PRE-PROCESSOR')

    %% Read Input Files 
    disp('Reading Input files...')
    
    % Read input from a set of .txt files or from a dedicated .xlsx
    [Input] = BS_ReadInputXLS('.\Input\Baseline_96_1.5MW_IIA_Structure_Data.xlsx');
    
    %% Define sections for structural evaluation and interpolate airfoils
    % Define array of the evaluation sections and eta stations w.r.t. the
    % blade length
    RadialPositions =   linspace(Input.HubRad,Input.RotorRad,Input.NumbSec);
    Eta             =   (RadialPositions-Input.HubRad)/Input.BladeLength;

    % Interpolate 'pivot' airfoils to obtain airfoils at each eval section.
    [InterpolatedAirfoils]=BS_InterpolateAirfoils(Input, RadialPositions);
    % Assign interpolated airfoils to current parameters list
    Parameters.Airfoils=InterpolatedAirfoils;
    % Prepare airfoil geometry file for BECAS.
    disp('Preparing airfoil geometry files... ');
    WriteSectionFileAirfoils(Parameters.Airfoils,RadialPositions)

    %% Interpolate Structural layout at evaluation sections.
    disp('Reading sectional layout... ');
    [SectionLayout]     =   BS_InterpolateStructure( Input.NumbEle,Input.Elements, RadialPositions);
    Parameters.Section  =   SectionLayout;

    %% Interpolate blade geometry at evaluation sections
    disp('Reading blade geometry... ');
    [BladeGeometry]     =   BS_InterpolateGeometry( Input.Blade, RadialPositions,Eta);
    Parameters.Blade    =   BladeGeometry;

    %% Interpolate Loads
    disp('Reading loads... ');
    [Loads]             =   BS_InterpolateLoads( Input.Loads, RadialPositions);
    Parameters.Loads    =   Loads;
    %% Prepare output: write sectional file for each section
    disp('Preparing sectional files... ');
    WriteSectionFile(Parameters);
%%=========================================================================
%% 2.AIRFOIL DISCRETIZATION & BECAS
%%=========================================================================
% Each sectional file, together with the corresponding 'interpolated'
% airfoil file are the input for the mesh generation procedure. this
% procedure is based on AirfoilDisc (if spar caps and webs are present),
% otherwise CylMesh is used (if only a shell is required, like in the
% cylinder section at root).
disp('GENERATING FEM MODELS')    
% Initialize global cells
ElementsMap.Elements=cell(Input.NumbSec,1);
ElementsMap.Materials=cell(Input.NumbSec,1);
        % Generate mesh on each section
        for i=1:Input.NumbSec
            disp(' ')
            fprintf('Generating mesh on Section %d... \n',i);
            SectionData     =   [];
            % (read back sectional layout)
            [SectionData]   =   BS_ReadSection(i);
            SectionData     =   AirfoilDisc(SectionData,Input,i,Parameters,python_path);
            
            % generate elements map
            [ElementsID,MaterialsID,Materials]=BS_ElementsMap(SectionData,i);
            
            % save to global cells
            ElementsMap.Elements{i}         =   ElementsID;
            ElementsMap.Materials{i}        =   MaterialsID;
            ElementsMap.MaterialsList{i}    =   Materials;
            
            % Solve section & write sectional/elements output           
            BS_CallBECAS(RadialPositions(i),Eta(i),SectionData,Parameters,Input,i,ElementsMap);
            
            if Input.PlotOption>0
                keyboard
            end
        end
% Write blade output
[Output]=BS_WriteBladeOutput(Input,RadialPositions,Eta,Input.NumbSec);


%%=========================================================================
%% 3.FREQUENCIES WITH MODES
%%=========================================================================
if Input.Modes.ModesOption==1
    % Write Modes Input file
    BS_WriteModesInputFile(Input,Output);
    % Launch Modes
    BS_CallModes(Input);
end

%% Toc
% time=toc;

disp('===================================================================')        
disp('PROGRAM TERMINATED NORMALLY.');
% fprintf('Total computational time: %.2f [s]. \n',time);
StopTime;
disp('===================================================================')

