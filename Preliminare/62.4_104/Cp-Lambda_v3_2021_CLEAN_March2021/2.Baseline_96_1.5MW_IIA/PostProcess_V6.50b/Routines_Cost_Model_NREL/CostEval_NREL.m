function CostEval_NREL(in_aep,mb_model_path)

%% CostEval 
%============================================================================
% This function offers a quick tool for the preliminary determination of the
% COE. The procedure is based on the set of routines 'Cost Model' currently
% employed in Cp_Max. The input data required for the cost evaluation are 
% provided as follows: the blade mass is computed directly from the wind turbine
% MB_Model, while the Power rated and the AEP are User-provided.
%============================================================================
% The parameters of interest are stored in a [Parameters] structure. The names
% of the sub-fields are assigned in compliance with the 'Cost Model.m' routine.
%
% The values of the 'economic' variables are assigned to a [Parameters.CostModel]
% structure, again in compliance with the 'Cost Model.m' routine. Their
% values could be modified by User. However the Default values, taken from
% Cp-Max, are provided as a reminder.
%============================================================================
% Release Dates: 
% 
% version 1.3:   28.03.2017
% version 1.2:   19.05.2015
% version 1.1:   11.03.2014
%
%============================================================================
% List of revisions:
%  
% version 1.3:
%               - Script as a function i.o.t. use within the PostProcess.
%
% version 1.2:
%               - Added pie charts with different cost contributions
%               - Added option '5' in blade cost (Innwind model)
%
%============================================================================

%% Settings
% Define working directories and files
ModelFolder             =   mb_model_path;
FileAddress.BladeProp   =   'Blade_properties.dat';
FileAddress.Blade       =   'Blade_1.dat';
FileAddress.Inflow      =   'Inflow.dat';
FileAddress.Frames      =   'Fixed_frames.dat';
FileAddress.Tower       =   'Tower.dat';

% Include CostModel folder and subroutines
% addpath ('.\CostModel')
% addpath ('.\routines')


%% Initialize
disp('====================================================================================')
disp('                     Wind turbine Cost Of Energy estimation')
disp('                                     -*-')
disp('                 Procedure based on the report NREL/TP-500-40566')
disp('                              PoliWind 2017 ')
disp('====================================================================================')
%% Define conversion between $/Euros.
% default value
ConvRate=0.921; % 28.03.2017


%% Require informations from User
% Here the ratedPower and the AEP are required to the User. The power 
% should be provided in kW, while the AEP in MWh/yr. 
PowerRated = [];
while isempty(PowerRated)
    PowerRated = input('Insert Rated Power [MW]: ');
end
% Converted in [W], because the CostModel.m will convert it back..
Parameters.maxPower=PowerRated*1e6;

% AEP is given in [Wh/yr]
if isempty(in_aep)
    AEP     =   input('Insert AEP [GWh/yr]: ');
    AEP     =   AEP*1e9;
else
    AEP     =   in_aep;
    dispstr =   ['AEP is ' num2str(in_aep/1e9) ' [GWh/yr]'];
    disp(dispstr)
end
    
% Choose between Baseline (glass) and Advanced (carbon) design
ioerr = 1;
while ioerr
    blade_design = input('Choose blade design (0 = Baseline/Glass design, 1 = Advanced/Carbon design): ');
    
    switch blade_design
        case 0
            ioerr = 0;
        case 1
            ioerr = 0;
        otherwise
    end
end        


%% Define parameters required by the Cost Model
% Here the 'economic' parameters are defined.
% The Default values are taken from the Cp_Max 'SimulationParameters.m'
% subroutine:
Parameters.CostModel.BCE            =   1;                % [Blade Material Cost escalator]   Default: 1        
Parameters.CostModel.GDPE           =   1;                % [Labor Cost Escalator]            Default: 1     
Parameters.CostModel.EtaAEP         =   0.90;             % [Efficiency for AEP computation]  Default: 0.9
Parameters.CostModel.InflationIndex =   0.98;             % [Inflation Index]                 Default: 0.98
Parameters.CostModel.FCR            =   0.1158;           % [Fixed Change Rate]               Default: 0.1158

%% Define optional parameters
% Blade Cost model
Parameters.CostModel.Offshore       =   0;                  % 1= Offshore,     0 = Onshore
Parameters.CostModel.AdvancedBlade  =   blade_design;       % 1= Carbon fiber, 0 = Glass fiber
Parameters.CostModel.BladeCostModel =   3;                  % 1, 2, 3 , 4, 5 - see estimate bladeCost

% Tower cost model
Parameters.CostModel.TowerCostModel =   3;                  % Leave 3, because the tower mass is computed from MB_Model

% The following 3 parameters must usually have the same value
% since they are strictly related 
Parameters.CostModel.GearBoxCostModel   = 3;    % 1, 2, 3 or 4 - To confront with Original use 3
Parameters.CostModel.GeneratorCostModel = Parameters.CostModel.GearBoxCostModel; 
Parameters.CostModel.MainFrameCostModel = Parameters.CostModel.GearBoxCostModel; 




%% Read MB_Model folder 
% Here several files in the MB_Model folder are scanned, in order to 
% collect all the 'physical' parameters required by the cost model.

try
    % Read Inflow and Fixed Frames
    disp('Reading MB_Model...')
    [Parameters.Rotor.RotorDiameter,Parameters.Blade.Length,Parameters.Rotor.HubHeight]=CE_ReadMBModel(ModelFolder,FileAddress);

    % Read blade properties
    disp('Reading Blade MB_Model...')
    [Parameters.Blade.TotalMass]=CE_ReadBladeMBModel(ModelFolder,FileAddress,Parameters.Blade.Length);

    % Otherwise assign it manually
    % Parameters.Blade.TotalMass = 7460;


    % Read Tower
    if Parameters.CostModel.TowerCostModel == 3
        disp('Reading Tower MB Model...')
        [Parameters.Tower.TowerHeight,Parameters.Tower.TotalMass]=CE_ReadTowerMBModel(ModelFolder,FileAddress);
    end
catch
    warning('Error reading the MB model. Entering debug mode.')
    keyboard
end


%% Call Cost model (NREL)
[coe, Cost]=CostModelNREL(Parameters,AEP);
% If the blade mass is taken from the MB_Model, then the (approximate) tower mass
% computed by the cost model must be overwritten.
if Parameters.CostModel.TowerCostModel ~= 3
    Parameters.Tower.TotalMass=Cost.TowerMass;
end
    

%% Display properties
CE_DisplayOutput(Parameters,AEP,coe,Cost,ConvRate);

%% Deliver pie charts
CE_PieCharts(Parameters,Cost);

