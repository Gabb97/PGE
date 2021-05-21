function AirfoilDisc(Section)


%% Geometry Data --> to be passed by BECAS

chord=3.5;
LeadingEdgeX=1.25;
UpperSparX=[0.5 -1];
LowerSparX=[0.5 -1];


%% Finite elements Number
% The longitudinal number of FE is imposed, while the number of FE used for
% thickness depends on the number of layer. If less than layers are
% employed on any element, then the number of FE is two, otherwise it is
% equal to the maximum number of layers
NumberFEchord=100;
MinimumNumberFEthickness=2;

%% structural Properties --> to be passed by BECAS
SkinThickness=0.0049 ;
SparThickness=0.027510;
WebThickness=0.0011;

ElementsThickness(1)=SkinThickness;
ElementsThickness(2)=SparThickness;
ElementsThickness(3)=WebThickness;


%% Check if the current shape is an airfoil or a cylinder
[CylFlag,UpperSparX,LowerSparX]=CheckShape(UpperSparX,LowerSparX,chord, LeadingEdgeX);



%% Open Airfoil file, scale and mirror to suit Airf2Becas requirements
FFAirf=fopen('Airfoil1.geom','r');
AirfoilData=cell2mat(textscan(FFAirf,'%f %f'));
fclose(FFAirf);


AirfoilDataX=AirfoilData(:,1);
AirfoilDataY=AirfoilData(:,2);


% Mirror and Scale Data
[AirfoilDataX,AirfoilDataY]=scale(AirfoilDataX,AirfoilDataY,chord,LeadingEdgeX);

% Generate Nodes
[NodesX,NodesY,NodesID,NodesKP,WebNodesID, NumberFEwebs]=Nodes(AirfoilDataX,AirfoilDataY,UpperSparX,LowerSparX,NumberFEchord,SparThickness);

%% Write Input Files for Airfoil2Becas
% Write Airfoil Nodes File
WriteNodalPoints(NodesX,NodesY,NodesID,NodesKP,WebNodesID);

%% Read Materials.in
[MatProperties,NumberFEthickness]=ReadSectionLayup(ElementsThickness,MinimumNumberFEthickness);


% Write Parameters File
WriteParameterFile(NumberFEthickness,WebNodesID,NumberFEwebs,MatProperties,CylFlag);
