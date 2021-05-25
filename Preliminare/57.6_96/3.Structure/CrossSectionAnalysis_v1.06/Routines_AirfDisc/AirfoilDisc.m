function Section = AirfoilDisc(Section,Input,SectionID,Parameters,python_path)


%% Airfoil data
% Identify the airfoil geometry file
AirfoilFileAddress=strcat('SectionFiles\Airfoils\Airfoil_',num2str(SectionID),'.geom');

%% 'Cyl' type sections
% If the section type is a cylinder, then no spar caps and no shear webs are 
% present. However, BECAS requires two shear webs to be defined, and then
% two fictional shear webs will be defined. They will be placed at x/c=0.2
% and x/c = 0.8 and they will be assigned a very small thickness and a 
% fictional material.
% if Section.Type=='Cyl'
%     Section.FrontSpar=Section.LeadingEdge+0.3*Section.Chord;
%     Section.RearSpar=Section.TrailingEdge-0.3*Section.Chord;
% end

% then the procedure continues as usual. The fictional material is assigned
% in the "WriteParameterFile" routine. 


%% Finite elements Number
% The longitudinal number of FE is imposed, while the number of FE used for
% thickness depends on the number of layer. If less than 2 layers are
% employed on any element, then the number of FE is two, otherwise it is
% equal to the maximum number of layers
NumberFEchord   =   Input.NumbFE;


%% Check if the current shape is an airfoil or a cylinder

% [CylFlag,UpperSparX,LowerSparX,UpperReinfX,LowerReinfX]=CheckShape(Section, UpperSparX,LowerSparX,UpperReinfX,LowerReinfX,chord, LeadingEdgeX);
[Section]=CheckShape(Parameters,Section,SectionID);

%% Geometry Data 
% Read data of the current section. Mirror for compatibility with BECAS.
chord           =   Section.Chord;
LeadingEdgeX    =   -Section.LeadingEdge;
UpperSparX      =   -[Section.FrontSpar Section.RearSpar];
LowerSparX      =   UpperSparX;
UpperReinfX     =   -[Section.LEReinf Section.TEReinf];
LowerReinfX     =   UpperReinfX;
beta            =   -Parameters.Blade.Twist(SectionID);



%% Open Airfoil file, scale and mirror to suit Airf2Becas requirements
FFAirf=fopen(AirfoilFileAddress);
    fgetl(FFAirf);
    fgetl(FFAirf);
    fgetl(FFAirf);
    AirfoilData=cell2mat(textscan(FFAirf,'%f %f'));
fclose(FFAirf);

% Mirror and Scale Data
[ScaleAirfoilData]=scale(AirfoilData,chord,LeadingEdgeX,UpperSparX,LowerSparX,UpperReinfX,LowerReinfX);
% keyboard
% Generate Nodes
[NodesX,NodesY,NodesID,NodesKP,WebNodesID, NumberFEwebs]=Nodes(ScaleAirfoilData,UpperSparX,LowerSparX,UpperReinfX,LowerReinfX,NumberFEchord,beta);

%% Write Input Files for Airfoil2Becas
% Write Airfoil Nodes File
WriteNodalPoints(NodesX,NodesY,NodesID,NodesKP,WebNodesID,SectionID);

%% Prepare materials.
% (Find number of FE thickness.)
% This number should at least be equal to the maximum number of layers
% [MatProperties,NumberFEthickness]=ReadSectionLayup(ElementsThickness,MinimumNumberFEthickness);

NumbFEthickness=2;
NumberOfElements=length(Section.MaterialsNames);

for i=1:NumberOfElements
    if length(Section.MaterialsNames{i})>NumbFEthickness
        NumbFEthickness=length(Section.MaterialsNames{i});
    end
end

%% Write Parameters File
WriteParameterFile(SectionID,NumbFEthickness,WebNodesID,NumberFEwebs,Section,Input);

% save working folders
PivotAirfoilFileAddress=strcat('PivotAirfoil_',num2str(SectionID),'.dat');
ParametersFileAddress=strcat('Parameters_',num2str(SectionID),'.dat');


%% Call Airfoil2BECAS
% Win XP
% commandline=sprintf('%s','cd Airfoil2BECAS && python airfoil2becas.py ',ParametersFileAddress);
% Win 7
% commandline=sprintf('%s','cd Airfoil2BECAS && airfoil2becas.py ',ParametersFileAddress);
% Win 10
python_exe = [python_path '\python.exe'];
commandline = strcat(' cd .\Airfoil2BECAS &&',32, python_exe, ' .\airfoil2becas.py ',32,ParametersFileAddress );

system(commandline);
    
% Delete current Parameter file and airfoil file (comment for
% de-bugging)
AirfoilTargetFile=strcat('Airfoil2BECAS\PivotAirfoil_',num2str(SectionID),'.dat');
ParametersTargetFile=strcat('Airfoil2BECAS\Parameters_',num2str(SectionID),'.dat');
delete(AirfoilTargetFile);
delete(ParametersTargetFile);


