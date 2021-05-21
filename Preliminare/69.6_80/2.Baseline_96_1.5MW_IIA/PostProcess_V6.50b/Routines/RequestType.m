function [UNITS,  Forces, Displacements, Displacements0, Displacements1, Velocities, RelativeRotations, RelativeDisplacements, AirstationAeroProperties, AirstationAeroAngles, AirstationLoads, TotalAirloads] = RequestType(Parameters)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [UNITS,  Forces, Displacements, Velocities, RelativeRotations, RelativeDisplacements, AirstationAeroProperties, AirstationAeroAngles]= RequestType
%
% Structures: Forces, Displacements, Velocities, RelativeRotations, RelativeDisplacements, AirstationAeroProperties, AirstationAeroAngles
% 1) First row represents the components
% 2) Second row represents the measurement units
%
%

%% CONVERT2UNITS
if (Parameters.FLAG.TechnicalUnits)
    
    UNITS = [...
              1/1000 1/1000 1/1000     1/1000 1/1000 1/1000 ; ...       % Forces             N    Nm  --> kN  KNm
              1      1      1          180/pi 180/pi 180/pi ; ...       % Displacements      m    rad -->  m  deg
              1      1      1          180/pi 180/pi 180/pi ; ...       % Displacements0     m    rad -->  m  deg
              1      1      1          180/pi 180/pi 180/pi ; ...       % Displacements1     m    rad -->  m  deg
              1      1      1          30/pi  30/pi  30/pi  ; ...       % Velocities         m/s rad/s --> m/s rpm
              180/pi 180/pi 180/pi     180/pi 180/pi 180/pi ; ...       % RelativeRotations   deg --> rad
              1      1      1          1      1      1      ; ...       % RelativeDisplacements   m --> m
              1      1      1          1      1      1      ; ...       % AirstationAeroProperties -   m --> -  m
              180/pi 180/pi 180/pi     180/pi 180/pi 1      ; ...       % AirstationAeroAngles -   deg --> rad
              1/1000 1/1000 1/1000     1/1000 1/1000 1/1000 ; ...       % AirstationLoads        N    Nm  --> kN  KNm
              1/1000 1/1000 1/1000     1/1000 1/1000 1/1000 ; ...       % TotalAirloads        N    Nm  --> kN  KNm
              ];
    
else
    
   UNITS = ones(11,6);
    
end

%% Units
if (Parameters.FLAG.TechnicalUnits)
    
    Forces = {' - Fx',' - Fy',' - Fz',' - Mx',' - My',' - Mz', ' - Fxy',' - Fyz',' - Fzx',' - Mxy',' - Myz',' - Mzx';
        ' [kN]',' [kN]',' [kN]',' [kNm]',' [kNm]',' [kNm]',' [kN]',' [kN]',' [kN]',' [kNm]',' [kNm]',' [kNm]'};
    
    Displacements = {' - Dx',' - Dy',' - Dz',' - Thetax',' - Thetay',' - Thetaz', ' - Dxy',' - Dyz',' - Dxz',' - Thetaxy',' - Thetayz',' - Thetazx';
        ' [m]',' [m]',' [m]',' [deg]',' [deg]',' [deg]',' [m]',' [m]',' [m]',' [deg]',' [deg]',' [deg]'};
    
    Displacements0 = {' - Dx',' - Dy',' - Dz',' - Thetax',' - Thetay',' - Thetaz', ' - Dxy',' - Dyz',' - Dxz',' - Thetaxy',' - Thetayz',' - Thetazx';
        ' [m]',' [m]',' [m]',' [deg]',' [deg]',' [deg]',' [m]',' [m]',' [m]',' [deg]',' [deg]',' [deg]'};

    Displacements1 = {' - Dx',' - Dy',' - Dz',' - Thetax',' - Thetay',' - Thetaz', ' - Dxy',' - Dyz',' - Dxz',' - Thetaxy',' - Thetayz',' - Thetazx';
        ' [m]',' [m]',' [m]',' [deg]',' [deg]',' [deg]',' [m]',' [m]',' [m]',' [deg]',' [deg]',' [deg]'};

    Velocities = {' - Vx',' - Vy',' - Vz',' - Omegax',' - Omegay',' - Omegaz',' - Vxy',' - Vyz',' - Vzx',' - Omegaxy',' - Omegayz',' - Omegazx';
        ' [m/s]',' [m/s]',' [m/s]',' [rpm]',' [rpm]',' [rpm]',' [m/s]',' [m/s]',' [m/s]',' [rpm]',' [rpm]',' [rpm]'};
    
    RelativeRotations = {' - NULL',' - NULL',' - NULL',' - Alphax',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL';
        ' [deg]',' [deg]',' [deg]',' [deg]',' [deg]',' [deg]',' [deg]',' [deg]',' [deg]',' [deg]',' [deg]',' [deg]'};
    
    RelativeDisplacements = {' - Dx',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL';
        ' [m]',' [m]',' [m]',' [m]',' [m]',' [m]',' [m]',' [m]',' [m]',' [m]',' [m]',' [m]'};
    
    AirstationAeroProperties = {' - Axial Inflow',' - C_L',' - C_D',' - C_M',' - Tangential Inflow',' - Chord',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL';
        ' [-]',' [-]',' [-]',' [-]',' [-]',' [m]',' [-]',' [-]',' [-]',' [-]',' [-]',' [-]'};
    
    AirstationAeroAngles = {' - Alpha',' - Alphai',' - Alphae',' - Phi',' - Theta',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL';
        ' [deg]',' [deg]',' [deg]',' [deg]',' [deg]',' [deg]',' [deg]',' [deg]',' [deg]',' [deg]',' [deg]',' [deg]'};
        
    AirstationLoads = {' - Fx',' - Fy',' - Fz',' - Mx',' - My',' - Mz', ' - Fxy',' - Fyz',' - Fzx',' - Mxy',' - Myz',' - Mzx';
        ' [kN]',' [kN]',' [kN]',' [kNm]',' [kNm]',' [kNm]',' [kN]',' [kN]',' [kN]',' [kNm]',' [kNm]',' [kNm]'};

    TotalAirloads = {' - Fx',' - Fy',' - Fz',' - Mx',' - My',' - Mz', ' - Fxy',' - Fyz',' - Fzx',' - Mxy',' - Myz',' - Mzx';
        ' [kN]',' [kN]',' [kN]',' [kNm]',' [kNm]',' [kNm]',' [kN]',' [kN]',' [kN]',' [kNm]',' [kNm]',' [kNm]'};
else
    
    Forces = {' - Fx',' - Fy',' - Fz',' - Mx',' - My',' - Mz', ' - Fxy',' - Fyz',' - Fzx',' - Mxy',' - Myz',' - Mzx';
        ' [N]',' [N]',' [N]',' [Nm]',' [Nm]',' [Nm]',' [N]',' [N]',' [N]',' [Nm]',' [Nm]',' [Nm]'};
    
    Displacements = {' - Dx',' - Dy',' - Dz',' - Thetax',' - Thetay',' - Thetaz', ' - Dxy',' - Dyz',' - Dxz',' - Thetaxy',' - Thetayz',' - Thetazx';
        ' [m]',' [m]',' [m]',' [rad]',' [rad]',' [rad]',' [m]',' [m]',' [m]',' [rad]',' [rad]',' [rad]'};
    
    Displacements0 = {' - Dx',' - Dy',' - Dz',' - Thetax',' - Thetay',' - Thetaz', ' - Dxy',' - Dyz',' - Dxz',' - Thetaxy',' - Thetayz',' - Thetazx';
        ' [m]',' [m]',' [m]',' [rad]',' [rad]',' [rad]',' [m]',' [m]',' [m]',' [rad]',' [rad]',' [rad]'};

    Displacements1 = {' - Dx',' - Dy',' - Dz',' - Thetax',' - Thetay',' - Thetaz', ' - Dxy',' - Dyz',' - Dxz',' - Thetaxy',' - Thetayz',' - Thetazx';
        ' [m]',' [m]',' [m]',' [rad]',' [rad]',' [rad]',' [m]',' [m]',' [m]',' [rad]',' [rad]',' [rad]'};

    Velocities = {' - Vx',' - Vy',' - Vz',' - Omegax',' - Omegay',' - Omegaz',' - Vxy',' - Vyz',' - Vzx',' - Omegaxy',' - Omegayz',' - Omegazx';
        ' [m/s]',' [m/s]',' [m/s]',' [rad/s]',' [rad/s]',' [rad/s]',' [m/s]',' [m/s]',' [m/s]',' [rad/s]',' [rad/s]',' [rad/s]'};
    
    RelativeRotations = {' - NULL',' - NULL',' - NULL',' - Alphax',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL';
        ' [rad]',' [rad]',' [rad]',' [rad]',' [rad]',' [rad]',' [rad]',' [rad]',' [rad]',' [rad]',' [rad]',' [rad]'};
    
    RelativeDisplacements = {' - Dx',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL';
        ' [m]',' [m]',' [m]',' [m]',' [m]',' [m]',' [m]',' [m]',' [m]',' [m]',' [m]',' [m]'};
    
    AirstationAeroProperties = {' - Axial Inflow',' - C_L',' - C_D',' - C_M',' -  Tangential Inflow',' - Chord',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL';
        ' [-]',' [-]',' [-]',' [-]',' [-]',' [m]',' [-]',' [-]',' [-]',' [-]',' [-]',' [-]'};

    AirstationAeroAngles = {' - Alpha',' - Alphai',' - Alphae',' - Phi',' - Theta',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL',' - NULL';
        ' [rad]',' [rad]',' [rad]',' [rad]',' [rad]',' [rad]',' [rad]',' [rad]',' [rad]',' [rad]',' [rad]',' [rad]'};

    TotalAirloads = {' - Fx',' - Fy',' - Fz',' - Mx',' - My',' - Mz', ' - Fxy',' - Fyz',' - Fzx',' - Mxy',' - Myz',' - Mzx';
        ' [N]',' [N]',' [N]',' [Nm]',' [Nm]',' [Nm]',' [N]',' [N]',' [N]',' [Nm]',' [Nm]',' [Nm]'};

    AirstationLoads = {' - Fx',' - Fy',' - Fz',' - Mx',' - My',' - Mz', ' - Fxy',' - Fyz',' - Fzx',' - Mxy',' - Myz',' - Mzx';
        ' [N]',' [N]',' [N]',' [Nm]',' [Nm]',' [Nm]',' [N]',' [N]',' [N]',' [Nm]',' [Nm]',' [Nm]'};
end

