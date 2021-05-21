function [A, B, C, D] = Linearization_analitical_MIMO(Ref_cond,GlobalData,wind) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 07 December 2006
%
% Compute the model linearization for LQR MIMO
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


x_ref       = Ref_cond(1);
xdot_ref    = Ref_cond(2);
omega_ref   = Ref_cond(3);
beta_ref    = Ref_cond(4);
betadot_ref = Ref_cond(5);
%%%   03.feb.2009 THIS IS NEW FOR REGION II 1/2 !!!!!!!!
Tel_ref     = Ref_cond(6);

V_ref       = wind - xdot_ref;
TSR_ref     = (omega_ref*GlobalData.MODEL.Turbine.R/V_ref);

[Cf,Cf_TSR,Cf_beta] = LookUpDerivative(GlobalData.MODEL.LookUpTable.Aero.CFTab,GlobalData.MODEL.LookUpTable.Aero.TSRTab,GlobalData.MODEL.LookUpTable.Aero.PitchTab,TSR_ref,beta_ref);
[Cp,Cp_TSR,Cp_beta] = LookUpDerivative(GlobalData.MODEL.LookUpTable.Aero.CPTab,GlobalData.MODEL.LookUpTable.Aero.TSRTab,GlobalData.MODEL.LookUpTable.Aero.PitchTab,TSR_ref,beta_ref);    

TSR_omega   = GlobalData.MODEL.Turbine.R/(V_ref);
TSR_xdot    = TSR_ref/V_ref;

Cf_omega = Cf_TSR*TSR_omega;
Cf_xdot  = Cf_TSR*TSR_xdot;

Cp_omega = Cp_TSR*TSR_omega;
Cp_xdot  = Cp_TSR*TSR_xdot;

qMod_ref    = 0.5*GlobalData.MODEL.rho*V_ref^2*pi*GlobalData.MODEL.Turbine.R^2*GlobalData.MODEL.AeroLoss;

Fa_Cf      = qMod_ref*cos(GlobalData.MODEL.ThetaTilt);
Fa_xdot    = -qMod_ref*Cf*(2/V_ref)*cos(GlobalData.MODEL.ThetaTilt) + Fa_Cf*Cf_xdot;
Fa_omega   = Fa_Cf*Cf_omega;
Fa_beta    = Fa_Cf*Cf_beta;

Ta_Cp      = qMod_ref*GlobalData.MODEL.Turbine.R/TSR_ref;
Ta_xdot    = -qMod_ref*Cp*GlobalData.MODEL.Turbine.R*(2/V_ref)/TSR_ref - qMod_ref*GlobalData.MODEL.Turbine.R*Cp/(TSR_ref^2)*TSR_xdot + Ta_Cp*Cp_xdot;
Ta_omega   = -qMod_ref*Cp*GlobalData.MODEL.Turbine.R/(TSR_ref^2)*TSR_omega + Ta_Cp*Cp_omega;
Ta_beta    = Ta_Cp*Cp_beta;


Ml_omega=0;
%%% 07 september 2006:   added Tel_omega
%%% 04Feb09 rimosso perchè MIMO 
%%% Tel_omega = ComputeTel_Omega(Ref_cond,GlobalData,wind);
%%%


kT_ref = GlobalData.MODEL.Tower.K;

Fxdot_x        =  -kT_ref/GlobalData.MODEL.Tower.M;
Fxdot_xdot     = (-GlobalData.MODEL.Tower.C+Fa_xdot)/GlobalData.MODEL.Tower.M;
Fxdot_omega    = Fa_omega/GlobalData.MODEL.Tower.M;
Fxdot_beta     = Fa_beta/GlobalData.MODEL.Tower.M;

Fomegadot_xdot     =  Ta_xdot/(GlobalData.MODEL.Turbine.J + GlobalData.MODEL.Generator.J);
Fomegadot_omega    = (-Ml_omega+Ta_omega)/(GlobalData.MODEL.Turbine.J + GlobalData.MODEL.Generator.J);
Fomegadot_beta     =  Ta_beta/(GlobalData.MODEL.Turbine.J + GlobalData.MODEL.Generator.J);
Fomegadot_Tel      = -GlobalData.MODEL.Generator.GearBoxRatio/(GlobalData.MODEL.Turbine.J + GlobalData.MODEL.Generator.J);

FTeldot_Tel        = -1/GlobalData.MODEL.Generator.tau;

wn=GlobalData.MODEL.Actuator.wn;
csi=GlobalData.MODEL.Actuator.csi;

Ac = [0            1                 0                 0                    0            0              ;
     Fxdot_x      Fxdot_xdot        Fxdot_omega        Fxdot_beta           0            0              ;   
     0            Fomegadot_xdot    Fomegadot_omega    Fomegadot_beta       0            Fomegadot_Tel  ;  
     0            0                 0                  0                    1            0              ;
     0            0                 0                  -wn^2                -2*csi*wn    0              ;
     0            0                 0                   0                   0            FTeldot_Tel   ]; 
 
    
Bc = [0  0  0  0  wn^2              0;
      0  0  0  0   0    -FTeldot_Tel]';



A =Ac;
B=Bc;

% C(1,:) = [0 1 0 0 0 0] ;
% C(2,:) = [0 0 1 0 0 0] ;
% C(3,:) = [0 0 0 1 0 0] ;
% C(4,:) = [0 0 0 0 1 0] ;
% C(5,:) = [0 0 0 0 0 1] ;

C(1,:) = [0 0 1 0 0 0] ;
C(2,:) = [0 0 0 1 0 0] ;
C(3,:) = [0 0 0 0 1 0] ;
C(4,:) = [0 0 0 0 0 1] ;
% 
D = zeros(4,2);
