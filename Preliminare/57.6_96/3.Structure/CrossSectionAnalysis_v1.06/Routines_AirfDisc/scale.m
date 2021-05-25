function [ScaledAirfoilData]=scale(AirfoilData,chord,LEx,UpperSparX,LowerSparX,UpperReinfX,LowerReinfX)
% This function is very important: it converts a 'typical' airfoil file,
% which is usually expressed between [0,1] in a scaled airfoil, which could
% be directly used within BECAS.
% The function does the following steps:
%           i)      the cureent airfoil geometry is read
%           ii)     the geometry is mirrored arounde the x=0 axis
%           iii)    the airfoil is scaled on the chord length
%           iv)     the airfoil is re-meshed. This way, the exact locations
%                   of the spar caps are correctly defined along the
%                   geometry. Otherwise, the spars will be slightly
%                   misplaced.

%% Read original airfoil coordinates ([0,1], westbound: 0 <------| 1 )
xOrigAirf=AirfoilData(:,1);
yOrigAirf=AirfoilData(:,2);

DataLen=length(xOrigAirf);
DataMidLen=DataLen/2;

%% Separate Airfoil Data
x1=xOrigAirf(1:DataMidLen);
y1=yOrigAirf(1:DataMidLen);

x2=xOrigAirf(DataMidLen+1:DataLen);
y2=yOrigAirf(DataMidLen+1:DataLen);

%% Mirror airfoil ([0,1], Eastbound: 0 |------> 1 )
MirrorX1=1-x1;
MirrorX2=1-x2;

MirrorY1=y1;
MirrorY2=y2;



%% Scale data on chord length ( xTE |------» xLE )
ScaleX1=MirrorX1*chord;
ScaleX2=MirrorX2*chord;

ScaleY1=MirrorY1*chord;
ScaleY2=MirrorY2*chord;


% Re-define reference centre at [0,0]
OffsetX=chord-LEx;

MoveX1=ScaleX1-OffsetX;
MoveX2=ScaleX2-OffsetX;
MoveY1=ScaleY1;
MoveY2=ScaleY2;


%% Re-mesh including real positions of the spar caps and LE/TE reinforcements( xTE |-*--o---o--*-» xLE)

% Upper curve
    % Create segments
    NumbDisc=105;
    RefinedX1_TE_to_TEreinf     =   linspace(MoveX1(1),UpperReinfX(2),NumbDisc);
    RefinedX1_TEreinf_to_Spar   =   linspace(UpperReinfX(2),UpperSparX(2),NumbDisc);
    RefinedX1_Spar              =   linspace(UpperSparX(2),UpperSparX(1),NumbDisc);
    RefinedX1_Spar_to_LEreinf   =   linspace(UpperSparX(1),UpperReinfX(1),NumbDisc);
    RefinedX1_LEreinf_to_LE     =   linspace(UpperReinfX(1),MoveX1(length(MoveX1)),NumbDisc);
    
    % Build and interpolate
    RefinedX1   =   [RefinedX1_TE_to_TEreinf RefinedX1_TEreinf_to_Spar(2:length(RefinedX1_TEreinf_to_Spar)) RefinedX1_Spar(2:length(RefinedX1_Spar)) RefinedX1_Spar_to_LEreinf(2:length(RefinedX1_Spar_to_LEreinf))  RefinedX1_LEreinf_to_LE(2:length(RefinedX1_LEreinf_to_LE)) ];
    RefinedY1   =   interp1(MoveX1,MoveY1,RefinedX1);
    
    
% Lower Curve
    % Create segments
    RefinedX2_LE_to_LEreinf     =   linspace(MoveX2(1),LowerReinfX(1),NumbDisc);
    RefinedX2_LE_to_Spar        =   linspace(LowerReinfX(1),LowerSparX(1),NumbDisc);
    RefinedX2_Spar              =   linspace(LowerSparX(1),LowerSparX(2),NumbDisc);
    RefinedX2_Spar_to_TEreinf   =   linspace(LowerSparX(2),LowerReinfX(2),NumbDisc);
    RefinedX2_TEreinf_to_TE     =   linspace(LowerReinfX(2),MoveX2(length(MoveX2)),NumbDisc);
    
    RefinedX2=[RefinedX2_LE_to_LEreinf RefinedX2_LE_to_Spar(2:length(RefinedX2_LE_to_Spar)) RefinedX2_Spar(2:length(RefinedX2_Spar)) RefinedX2_Spar_to_TEreinf(2:length(RefinedX2_Spar_to_TEreinf)) RefinedX2_TEreinf_to_TE(2:length(RefinedX2_TEreinf_to_TE)) ];
    RefinedY2=interp1(MoveX2,MoveY2,RefinedX2);

% Debug
%     figure
%     hold on
%     grid on
%     plot(MoveX1,MoveY1,'b')
%     plot(MoveX2,MoveY2,'b')
%     plot(RefinedX1,RefinedY1,'c')
%     plot(RefinedX2,RefinedY2,'m')
%     axis equal
%     keyboard

%% Re-build full geomertry and feed output
xNewAirfoil=[RefinedX1';RefinedX2'];
yNewAirfoil=[RefinedY1';RefinedY2'];

ScaledAirfoilData(:,1)=xNewAirfoil;
ScaledAirfoilData(:,2)=yNewAirfoil;

