function [coe, CostItem] = CostModelNREL(Parameters,AEP)
%% Wind turbine cost of energy model ,also with offshore costs (only shallow waters)
% Based on NREL Report NREL/TP-500-40566, titled:
% "Wind Turbine Design Cost and Scaling Model"
% Authors: L.Fingersh, M.Hand, and A. Laxson,
% Published in December 2006

%% Revisions
% - Added 4 new blade cost models for blade
% - added 3 models for tower costs (actual tower mass can be used, if Parameters.CostModel.TowerCostModel = 3)
% - Added offshore costs
% - added 4 generator models
% - added 4 gearbox models
% - added 4 mainframe models
% 
% TODO: 
% - better labour cost estimate ( especially for larger blades )
% - blade and tower material cost estimate directy from actual component masses !!
% - better inflation estimate, to obtain nominal COE and maybe real and nominal LCOE instead of COE
%  (COE is computed considering only a year, LCOE is obtained considering the entire lifecycle fo the turbine)

%% Comments
% In order to correctly estimate cost, a raw estimate is made to convert 
% the value of 2002$into 2012$, using index called BCE and GDPE.
% "Inflation Index", instead, converts the from 2003$ to 2002$, since some
% offshore costs are estimated using 2003$.
% AEP_net is scaled with etaAEP because AEP is only an estimation of 
% the AEP obtained from static load.


%% Estimation Formulae  
% 
% AOE = LLC + (OEM + LRC)/AEP_net
%
% COE = (FCR*ICC)/AEP_net + AOE
%
% where:
%
% LLC: Land Lease Cost - costo affitto terreno (o fondale se offshore) [$/kWh]
% OEM: Operations & Manteinance - spese per manutenzione (sarebbe meglio usare O&M) [$/1 yr] 
% LRC: Levelized Replacement Cost - spese per ricambi e refitting [$/1 yr]
% AEP_net: net Annual Energy Production - energia netta prodotta annualmente [kWh/1 yr]
% AOE: Annual Operative Expenses - spese operative annue [$/kWh]
% FCR: Fixed Change Rate - costo percentuale del denaro [1/1 yr]
% ICC: Initial Capital Cost - investimento iniziale in valuta corrente [$]
% COE: Cost Of Energy - costo dell'energia in [$/kWh]
%% Data

%Model data
BladeMass = Parameters.Blade.TotalMass;       %Blade total mass
R         = Parameters.Rotor.RotorDiameter/2; %Blade real radius
rating    = Parameters.maxPower/1000;         %Rated Power - "rating" should be in [kW]
sweptarea = pi*R^2;                           %Rotor area
hubheight = Parameters.Rotor.HubHeight;       %Hub height

%Cost Model Data - from values listed in input file 
%[Parameters] = CostModelInput;

BCE       = Parameters.CostModel.BCE;         %Blade material cost escalator
GDPE      = Parameters.CostModel.GDPE;        %Labor cost escalator
etaAEP    = Parameters.CostModel.EtaAEP;      %Efficiency for AEP computing
InflationIndex = Parameters.CostModel.InflationIndex; %Inflation Correction to transform 2003 $ in 2002 $

AEP       = AEP/1e3;                          %AEP in [kWh/ 1 yr]
FCR       = Parameters.CostModel.FCR;         %Fixed Change Rate
AEPnet    = AEP*etaAEP;                       %Net AEP in [kWh/ 1 yr]

Scale=1e3;
%%

%Blade radius from statistical relationship 
Rm = (BladeMass/0.1452)^(1/2.9158); 

% %Blade - Versione Originale PONZO
% CostBlade = ((0.4019*R^3-955.24)*BCE + 2.7445*R^2.5025*GDPE)/(1-0.28);
% CostBlade = CostBlade*3;

%Blade 
CostBlade = EstimateBladeCost(Parameters);
CostBlade = CostBlade*3; % This Cost Model is suitable only for wind turbine with 3 blades
CostItem.Rotor_Blades=CostBlade/Scale;


%Hub
hubmass = 0.954*(BladeMass)+5680.3;
CostHub = hubmass*4.25;
CostItem.Rotor_Hub=CostHub/Scale;

%Pitchsystem e bearings
CostPitchSystem = 2.28*(0.2106*(2*Rm)^2.6578);
CostItem.Rotor_PitchSys=CostPitchSystem/Scale;

%Spinner, Nose, Cone
nosemass = 18.5*(2*R)-520.5;
CostNose = nosemass*5.57;
CostItem.Rotor_Spinner=CostNose/Scale;

%Rotor Cost
CostRotor = CostBlade + CostHub + CostPitchSystem + CostNose;
CostItem.Rotor=CostRotor/Scale;


%Low Speed Shaft
CostShaft = 0.01*(2*R)^2.887;
CostItem.DriveTrain_Shaft=CostShaft/Scale;

%MainBearing
bearingmass = (2*R*8/600-0.033)*0.0092*(2*R)^2.5;
CostBearing = 2*bearingmass*17.6;
CostItem.DriveTrain_Bearing=CostBearing/Scale;

% %GearBox - PONZO
% CostGearBox = 15.26*(rating)^1.249;

%GearBox
[CostGearBox, MassGearBox] = EstimateGearBoxCostAndMass(rating,CostShaft,Parameters);
CostItem.DriveTrain_GearBox=CostGearBox/Scale;

%Brakecoupling
CostBrake = 1.9894*rating-0.1141;
CostItem.DriveTrain_Brake=CostBrake/Scale;

% %Generator - PONZO
% CostGenerator = rating*48.03;

%Generator 
[CostGenerator, MassGenerator] = EstimateGeneratorCostAndMass(rating,CostShaft,Parameters);
CostItem.DriveTrain_Generator=CostGenerator/Scale;

%Electronics
CostElectronics = rating*79;
CostItem.DriveTrain_Electronics=CostElectronics/Scale;

%YawDrive
CostYaw = 2*(0.0339*(2*R)^2.964);
CostItem.DriveTrain_Yaw=CostYaw/Scale;

% %Mainframe - PONZO
% CostMainFrame = 17.92*(2*R)^1.672;

% Mainframe - also contains Platform and railings costs 
[CostMainFrame, MassMainFrame] = EstimateMainFrameCostAndMass(Parameters);
CostItem.DriveTrain_MainFrame=CostMainFrame/Scale;

%ElectricalConnection
CostElectrical = rating*40;
CostItem.DriveTrain_Electrical=CostElectrical/Scale;

%Hydraulic and Cooling
CostCooling = 12*rating;
CostItem.DriveTrain_Cooling=CostCooling/Scale;

%Nacelle Cover
CostNacelle = 11.537*rating+3849.7;
CostItem.DriveTrain_Nacelle=CostNacelle/Scale;

%Cost of DriveTrain and Nacelle
CostDriveTrainNacelle = CostShaft + CostBearing + CostGearBox + CostBrake + CostGenerator + CostElectronics +...
						CostYaw + CostMainFrame + CostElectrical + CostCooling + CostNacelle;
CostItem.DriveTrain=CostDriveTrainNacelle/Scale;
						   
%Control, safety and monitoring
CostControl = 35000;
CostItem.Control=CostControl/Scale;

% %Tower - PONZO
% massTower = 0.3973*sweptarea*hubheight-1414;
% CostTower = massTower*1.5*Parameters.CostModel.BCE;

%Tower
[MassTower, CostTower] = EstimateTowerCost(Parameters);
CostItem.Tower=CostTower/Scale;
CostItem.TowerMass=MassTower;

%Marinization - only for offshore
if   Parameters.CostModel.Offshore == 0
		CostMarinization = 0;
elseif Parameters.CostModel.Offshore == 1
		CostMarinization = 0.135*(CostRotor + CostDriveTrainNacelle + CostControl + CostTower);
else
    error('Parameters.CostModel.Offshore not defined correctly');
end
CostItem.Marinization=CostMarinization/Scale;
%Turbine Capital Cost
TCC = CostRotor + CostDriveTrainNacelle + CostControl + CostTower + CostMarinization;
CostItem.TCC=TCC/Scale;

if Parameters.CostModel.Offshore == 0 %Onshore Turbine
    
    %Foundation - using hollow drilled pier method
    CostFoundation = 303.24*(hubheight*sweptarea)^0.4037;
    CostItem.Foundation=CostFoundation/Scale;

    %Transportation
    CostTransportation = rating*((1.581/1e5)*rating^2-0.0375*rating+54.7);
    CostItem.Transportation=CostTransportation/Scale;

    %Civil Work
    CostCivilWork = rating*(2.17/1e6*rating^2-0.0145*rating+69.54);
    CostItem.CivilWork=CostCivilWork/Scale;

    %Assembly and Installation
    CostInstallation = 1.965*(hubheight*2*R)^1.1736;
    CostItem.Installation=CostInstallation/Scale;

    %Electrical Interface
    CostInterface = rating*(3.49/1e6*rating^2-0.0221*rating+109.7);
    CostItem.Interface=CostInterface/Scale;

    %Engineering and permits
    CostEng = rating*(9.94/1e4*rating+20.31);
    CostItem.Eng=CostEng/Scale;
	
	%Offshore Warranty
    CostOffshoreWarranty = 0;
    CostItem.Offshore=CostOffshoreWarranty/Scale;
    
    %Balance Of Station
    BOS = CostFoundation + CostTransportation +  CostCivilWork + CostInstallation + CostInterface + CostEng;
    CostItem.BOS=BOS/Scale;
    
    %Initial capital cost
    ICC = TCC + BOS;  
    CostItem.ICC=ICC/Scale;
    
    %Levelized Replacement Cost
    CostLRC = 10.7*rating;
    CostItem.LRC=CostLRC/Scale;

    %Operation and maintenance
    CostOEM = 0.007*AEP;
    CostItem.OEM=CostOEM/Scale;

    %Land Lease Cost
    LLC=0.00108;
    CostLLC = LLC*AEP;  %0.00108kWh/year assumed as standard value
    CostItem.LLC=CostLLC/Scale;
%     CostItem.LLC = 0.00108*AEP/AEP;
    
elseif Parameters.CostModel.Offshore == 1  % Remember: suitable only for shallow waters !
    
    %Support Structure, with Monopile foundation - value in 2003 $
    CostFoundation = 300*rating;
    CostFoundation = CostFoundation*InflationIndex;
    CostItem.Foundation=CostFoundation/Scale;

    %Offshore Transportation
    CostTransportation = 1.581*1e-05 * rating^2 - 0.0375 * rating + 54.7;
    CostTransportation = CostTransportation * rating;
    CostItem.Transportation=CostTransportation/Scale;

    %Port and staging equipment
    CostPortAndStaging = 20 * rating;
    CostItem.PortAndStaging=CostPortAndStaging/Scale;


    %Offshore turbine Installation - value in 2003 $
    CostInstallation = 100 * rating;
    CostInstallation = CostInstallation*InflationIndex;
    CostItem.Installation=CostInstallation/Scale;

    %Offshore Electrical Interface and Connection - value in 2003 $
    CostInterface = 260 * rating;
    CostInterface = CostInterface*InflationIndex;
        CostItem.Interface=CostInterface/Scale;

    %Offshore Permit, Engineering and Site Assessment - value in 2003 $
    CostEng = 37 * rating;
    CostEng = CostEng*InflationIndex;
        CostItem.Eng=CostEng/Scale;

    %Personal Access Equipment - value in 2003 $
    % 60000 $ for each turbine, independent of rating or AEP
    CostPersonalAccess = 60000;
    CostPersonalAccess = CostPersonalAccess*InflationIndex;
        CostItem.Access=CostPersonalAccess/Scale;

    %Scour Protection - value in 2003 $
    CostScourProtection = 55*rating;
    CostScourProtection = CostScourProtection*InflationIndex;
        CostItem.ScourProtection=CostScourProtection/Scale;
    
    %Balance Of Station - without Surety Bond
    BOS = CostFoundation + CostTransportation +  CostPortAndStaging + CostInstallation + CostInterface + CostEng +...
          CostPersonalAccess + CostScourProtection ;
  
    
    %Offshore Warranty
    CostOffshoreWarranty = 0.15*(CostRotor + CostDriveTrainNacelle +CostControl + CostTower);
    CostItem.Offshore=CostOffshoreWarranty/Scale;
  
    %Initial capital cost - without Surety Bond
    ICC = TCC + BOS + CostOffshoreWarranty;  
    
    %SuretyBond
    CostSuretyBond = 0.03*(ICC-CostOffshoreWarranty);
    CostItem.Surety=CostSuretyBond/Scale;
    
    %Balance Of Station with Surety Bond
    BOS = BOS + CostSuretyBond;
    CostItem.BOS=BOS/Scale;
    
    %Initial capital cost with Surety Bond
    ICC = ICC + CostSuretyBond;
    CostItem.ICC=ICC/Scale;
        
    %Offshore Levelized Replacement Cost - value in 2003 $
    CostLRC = 17*rating;
    CostLRC = CostLRC*InflationIndex;
    CostItem.LRC=CostLRC/Scale;

    %Offshore O&M - value in 2003 $
    CostOEM = 0.02*AEP;
    CostOEM = CostOEM*InflationIndex;
    CostItem.OEM=CostOEM/Scale;
    
    %Offshore Bottom (of the ocean) Lease Cost
    % It's the same as onshore turbines 
    LLC=0.00108;
    CostLLC = LLC*AEP;  %0.00108kWh/year assumed as standard value
    CostItem.LLC=CostLLC/Scale;
%     CostItem.LLC = 0.00108*AEP/AEP;

else
    error('Parameters.CostModel.Offshore not defined correctly');
end
 
%Installed Cost x kW
IC = ICC/rating;
CostItem.IC=IC;


%Turbine Capital per kW without BOS and Warranty
TC = TCC/rating;   % - BOS - CostOffshoreWarranty
CostItem.TC=TC;

%Annual Operative Expenses - Corrected
AOE = LLC + (CostOEM + CostLRC)/AEPnet ;
% AOE = CostItem.LLC + (CostOEM + CostLRC)/AEPnet ;
CostItem.AOE=AOE;

CostItem.AEPnet=AEPnet;
CostItem.FCR=FCR;

%Cost of energy in $/kWh
coe = (FCR * ICC)/AEPnet + AOE;

% %COE - Corrected to have value in $/kWh
% coe = coe /(1000*100);


%Capacity Factor - why like this ?
% CF = ICC/AEPnet*100;


%% DEBUG -  to check contributions to the final cost of energy:

% (CostOEM + CostLRC )
% AEPnet
% (CostOEM + CostLRC )/AEPnet
% (FCR*ICC)
% (FCR*ICC)/AEPnet
%
% %Annual operative expenses PONZO
% AOE = CostLRC/(365*24*1000) + (CostOEM + CostLLC)/AEPnet;

end