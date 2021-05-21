function [fid,GlobalData] = ReadModelFile(MODEL,AeroFileName)

fid=fopen(MODEL.FullModelFileName);

if (fid<0)
    GlobalData = [];
    fprintf('Unable to open %s file!!!',MODEL.FullModelFileName);
    return;
end

% TURBINE *********************************************
fscanf(fid,'%s',1);
fscanf(fid,'%s',1); Turbine.J = fscanf(fid,'%f',1);
fscanf(fid,'%s',1); Turbine.R = fscanf(fid,'%f',1);
fscanf(fid,'%s',1); Turbine.ZHub = fscanf(fid,'%f',1);
fscanf(fid,'%s',1); ThetaTilt=fscanf(fid,'%f',1)*pi/180;

% GENERATOR *******************************************
fscanf(fid,'%s',1);
fscanf(fid,'%s',1); Generator.J = fscanf(fid,'%f',1);
fscanf(fid,'%s',1); CONTROL.MaxElectricalTorque = fscanf(fid,'%f',1);
fscanf(fid,'%s',1); Generator.tau = fscanf(fid,'%f',1);
fscanf(fid,'%s',1); Generator.GearBoxRatio = fscanf(fid,'%f',1);
Generator.MaxTorque = CONTROL.MaxElectricalTorque;

% TOWER ***********************************************
fscanf(fid,'%s',1);
fscanf(fid,'%s',1); Tower.M = fscanf(fid,'%f',1);
fscanf(fid,'%s',1); Tower.K = fscanf(fid,'%f',1);
fscanf(fid,'%s',1); Tower.C = fscanf(fid,'%f',1);
fscanf(fid,'%s',1); Tower.maxD = fscanf(fid,'%f',1);
fscanf(fid,'%s',1); Tower.maxV = fscanf(fid,'%f',1);

% ACTUATOR *********************************************
fscanf(fid,'%s',1);
fscanf(fid,'%s',1); Actuator.wn = fscanf(fid,'%f',1);
fscanf(fid,'%s',1); Actuator.csi = fscanf(fid,'%f',1);
fscanf(fid,'%s',1); Actuator.maxRate = fscanf(fid,'%f',1);

MODEL.Actuator    = Actuator;
MODEL.Generator   = Generator;
MODEL.Tower       = Tower;
MODEL.Turbine     = Turbine;
MODEL.ThetaTilt   = ThetaTilt;

% AEROFILE  *********************************************
fscanf(fid,'%s',1);
fscanf(fid,'%s',1); aero = fscanf(fid,'%s',1);
% AeroFileName = strcat('.\',MODEL.ModelDirName,'\',aero);
try
    load(AeroFileName);
catch
    GlobalData = [];
    fprintf('Unable to open %s file!!!',AeroFileName);
    return;
end
MODEL.LookUpTable.Aero.PitchTab  = LookUp.Pitch*pi/180 ;
MODEL.LookUpTable.Aero.TSRTab    = LookUp.TSR ;
% ALEALE
% MODEL.LookUpTable.Aero.CPTab = LookUp.Cp_ric;
% MODEL.LookUpTable.Aero.CFTab = LookUp.Cf_ric;
MODEL.LookUpTable.Aero.CPTab = LookUp.Cp;
MODEL.LookUpTable.Aero.CFTab = LookUp.Cf;
% ALEALE end
% inflow coefficients
[MODEL.LookUpTable.Inflow.aTab,MODEL.LookUpTable.Inflow.CPTab] = axial_inflow_factor(AeroFileName);

% MECHANICAL_LOSS *********************************************
fscanf(fid,'%s',1);
fscanf(fid,'%s',1); ML = fscanf(fid,'%s',1);

% MM = load(strcat('.\',MODEL.ModelDirName,'\',ML));
% MODEL.LookUpTable.ML.O = MM(1,:)*pi/30;
% MODEL.LookUpTable.ML.T = MM(2,:);

% CONTROL_PARAMETERS *********************************************
fscanf(fid,'%s',1);
fscanf(fid,'%s',1); CONTROL.sample_time  = fscanf(fid,'%f',1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%   GLOBAL DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GlobalData.MODEL        = MODEL;
GlobalData.CONTROL      = CONTROL;
