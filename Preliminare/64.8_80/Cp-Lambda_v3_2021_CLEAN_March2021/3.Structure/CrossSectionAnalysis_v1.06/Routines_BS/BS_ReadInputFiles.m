function [Input]=BS_ReadInputFiles

%% Read settings
InputFileAddress='Input\Settings.inp';
    fSet=fopen(InputFileAddress);
    for i=1:7
        fgetl(fSet);
    end
    % read number of require sections
    Input.NumbSec=fscanf(fSet,'%d');
    fgetl(fSet);
    % read rotor and hub radius
    Input.RotorRad=fscanf(fSet,'%f');
    fgetl(fSet);
    Input.HubRad=fscanf(fSet,'%f');
    fgetl(fSet);
    % read number of elements (10 or 11, so far only 10 is supported)
    Input.NumbEle=fscanf(fSet,'%d');
    fgetl(fSet);
    % Read number of FE to divide the chord length into
    Input.NumbFE=fscanf(fSet,'%d');
    fgetl(fSet);
    if Input.NumbFE<30
        warning('Number of Finite Elements lower than 30 is not reccomendable. NumbFE set to 30.');
        Input.NumbFE=30;
    end
    % Read the Plot Option
    Input.PlotOption=fscanf(fSet,'%d');
    fgetl(fSet);
    % Create files for PPP
    Input.Files4PPP=fscanf(fSet,'%d');
fclose(fSet);   
    
    % Calculate Blade Length (This is the 'flexible length' in the Modes
    % input file)
    Input.BladeLength=Input.RotorRad-Input.HubRad;

%% Read settings for modes
InputFileAddress='Input\Settings_Modes.inp';
    fSetMod=fopen(InputFileAddress);
    for i=1:6
        fgetl(fSetMod);
    end
    % Read 'RunModes' option
    Input.Modes.ModesOption=fscanf(fSetMod,'%d');
    fgetl(fSetMod);
    % Read 'use non-structural mass' option
    Input.Modes.NonStrucOption=fscanf(fSetMod,'%d');
    fgetl(fSetMod);
    % Read the location
    Input.Modes.Location=fscanf(fSetMod,'%d');
    fgetl(fSetMod);
    % Read rotational modes option
    Input.Modes.RotationalOption=fscanf(fSetMod,'%d');
    fgetl(fSetMod);
    % Read RPM and pitch
    Input.Modes.Omega=fscanf(fSetMod,'%f');
    fgetl(fSetMod);
    Input.Modes.Beta=fscanf(fSetMod,'%f');
    fgetl(fSetMod);
    % Read adjust factors
    Input.Modes.AdjFact(1)=fscanf(fSetMod,'%f');
    fgetl(fSetMod);
    Input.Modes.AdjFact(2)=fscanf(fSetMod,'%f');
    fgetl(fSetMod);
    Input.Modes.AdjFact(3)=fscanf(fSetMod,'%f');
    fgetl(fSetMod);
fclose(fSetMod);


%% Read blade geometry and layout
InputFileAddress='Input\BladeLayout.inp';
    fLay=fopen(InputFileAddress);
    for i=1:8
        fgetl(fSet);
    end
    % read blade layout
    ReadBladeLayout=cell2mat(textscan(fLay,'%f %f %f %f %f %f %f %f  %f %f  %f %f'));
 fclose(fLay);
 
    % assign variables
    Input.Blade.Eta                     =   ReadBladeLayout(:,1);
    Input.Blade.RadialPos               =   ReadBladeLayout(:,2);
    
    Input.Blade.Chord                   =   ReadBladeLayout(:,3);
    Input.Blade.Twist                   =   ReadBladeLayout(:,4);
    Input.Blade.PitchAxis               =   ReadBladeLayout(:,5);
    Input.Blade.LeadingEdge             =   ReadBladeLayout(:,6);
    Input.Blade.TrailingEdge            =   ReadBladeLayout(:,7);
    Input.Blade.FrontSpar               =   ReadBladeLayout(:,8);
    Input.Blade.RearSpar                =   ReadBladeLayout(:,9);
    Input.Blade.LEReinf                 =   ReadBladeLayout(:,10);
    Input.Blade.TEReinf                 =   ReadBladeLayout(:,11);
    Input.Blade.NonStrucMass            =   ReadBladeLayout(:,12);

    
    Input.Blade.RadialPos               =   (Input.Blade.Eta*Input.BladeLength) + Input.HubRad ;
    Input.Blade.DistanceFromRoot        =   Input.Blade.Eta*Input.BladeLength;
    
    Input.Blade.Prebend                 = zeros(length(Input.Blade.RadialPos),1);
    Input.Blade.AirfoilID               = zeros(length(Input.Blade.RadialPos),1);
    
%% Read Loads
InputFileAddress='Input\Loads.inp';
    fLoads=fopen(InputFileAddress);
    for i=1:8
        fgetl(fLoads);
    end
    ReadLoads=cell2mat(textscan(fLoads,'%f %f %f %f %f %f %f'));
fclose(fLoads);    
    % assign variables
    Input.Loads.Eta             =   ReadLoads(:,1);
        Input.Loads.RadialPos   = (Input.Loads.Eta.*Input.BladeLength)+Input.HubRad;
    Input.Loads.Tx=ReadLoads(:,2);
    Input.Loads.Ty=ReadLoads(:,3);
    Input.Loads.Tz=ReadLoads(:,4);
    Input.Loads.Mx=ReadLoads(:,5);
    Input.Loads.My=ReadLoads(:,6);
    Input.Loads.Mz=ReadLoads(:,7);


%% Read Materials 
InputFileAddress='Input\MaterialsList.inp';    
    fMat=fopen(InputFileAddress);
    for i=1:7
        fgetl(fMat);
    end
    % read number of materials
    NumberOfMaterials=fscanf(fMat,'%d');
    fgetl(fMat);
    % Initialize cells where materials data are going to be stored
    MaterialsNames=cell(NumberOfMaterials,1);
    MaterialsProperties=cell(NumberOfMaterials,1);
    
    % for each material, scan the name, open the corresponding .dat file
    % and scan the properties.
    for j=1:NumberOfMaterials
        % scan material name
        j_MaterialName=fgetl(fMat);
        % assign name to cell
        MaterialsNames{j}=strtrim(j_MaterialName);
        
        % open the corresponding material .dat file
        MaterialFileAddress=strcat('Input\Materials\',j_MaterialName,'.dat');
        j_MaterialName=[];
        
        fMat_j=fopen(MaterialFileAddress);
            for k=1:6
                fgetl(fMat_j);
            end
            % scan material properties from material file
            for kk=1:16
                ReadMaterial_j(kk)=fscanf(fMat_j,'%f');
                fgetl(fMat_j);
            end
            fclose(fMat_j);
         % assign properties
         MaterialsProperties{j}=ReadMaterial_j;
         ReadMaterial_j=[];      
    end
    fclose(fMat);    
    % assign properties
    Input.Materials.MatNumb=NumberOfMaterials;
    Input.Materials.MatNames=MaterialsNames;
    Input.Materials.MatProp=MaterialsProperties;

%% Read airfoils
InputFileAddress='Input\AirfoilsList.inp';    
    fArf=fopen(InputFileAddress);
    for i=1:7
        fgetl(fArf);
    end
    % read number of airfoils
    NumberOfAirfoils=fscanf(fArf,'%d');
    fgetl(fArf);
    % Initialize cell where airfoils data are going to be stored
    AirfoilPositions=[];
    AirfoilGeometries=cell(NumberOfAirfoils,1);

    fgetl(fArf);
    fgetl(fArf);
    fgetl(fArf);

    % for eachairfoil, scan the name, open the corresponding .geom file
    % and scan the geometry.
    for j=1:NumberOfAirfoils
        % scan airfoil name and position
        j_AirfoilLine=fgetl(fArf);
        % separate airfoil name and position
        [j_AirfoilName,j_Airfoil_t, j_AirfoilEta]=BS_ReadAirfoilNameAndPos(j_AirfoilLine);        
        % assign variables
        AirfoilEta(j)       =   j_AirfoilEta;
        AirfoilThickness(j) =   j_Airfoil_t;
        
        % open the corresponding airfoil .geom file and scan geometry
        AirfoilFileAddress=strcat('Input\Airfoils\',j_AirfoilName,'.geom');
        fArf_j=fopen(AirfoilFileAddress);
            fgetl(fArf_j);
            ReadAirfoil_j=cell2mat(textscan(fArf_j,'%f %f'));
            fclose(fArf_j);
        
        % assign variables
        AirfoilGeometries{j}=ReadAirfoil_j;
        ReadAirfoil_j=[];
    end
    
    fclose(fArf);
    % assign properties
    Input.Airfoils.AirfNumb     =   NumberOfAirfoils;
    Input.Airfoils.AirfPos      =   (AirfoilEta.*Input.BladeLength)+Input.HubRad;
    
    Input.Airfoils.AirfGeom     =   AirfoilGeometries;
    Input.Airfoils.AirfThick    =   AirfoilThickness;
    
    % Build t/c along the blade
    Input.Blade.Thickness       =   interp1(Input.Airfoils.AirfPos, Input.Airfoils.AirfThick, Input.Blade.RadialPos,'pchip');
    
%     figure()
%     hold on
%     grid on
%     plot(Input.Airfoils.AirfPos,    Input.Airfoils.AirfThick,'om')
%     plot(Input.Blade.RadialPos, Input.Blade.Thickness)
%     keyboard
    

    for j = 1:length(Input.Blade.RadialPos);
        for k = 1:Input.Airfoils.AirfNumb -1
            if Input.Blade.RadialPos(j) >= Input.Airfoils.AirfPos(k) && Input.Blade.RadialPos(j) < Input.Airfoils.AirfPos(k+1)
                Input.Blade.AirfoilID(j)    = k;
                break
            end
        end
    end
    Input.Blade.AirfoilID(end)    = k;      

%% Read structural elements layout
% Initialize cells
ElementsStandalone=[];
ElementsMaterials=cell(Input.NumbEle,1);
ElementsLayerThickness=cell(Input.NumbEle,1);

% for each element, open the corresponfing file and scan the properties. If
% an element is 'standalone' (ElementsStandalone=0), then its properties 
% are taken. Vice-versa, if an element is related to another, an array of
% zeros is assiged to the variable ElementsProperties.
for i=1:Input.NumbEle
    ElementFileAddress=strcat('Input\Elements\Element_',num2str(i),'.elem');
    fElem_i=fopen(ElementFileAddress);
            for k=1:9
                fgetl(fElem_i);
            end
            i_ElementStandalone=fscanf(fElem_i,'%d \n');
            if i_ElementStandalone~=0
                % assign pointer and (empty) variables
                ElementsStandalone(i)=i_ElementStandalone;
                ElementsMaterials{i}=zeros(10);
                ElementsLayerThickness{i}=zeros(10);
            else
                ElementsStandalone(i)=0;
                for k=1:9
                    fgetl(fElem_i);
                end
                i_ElementNumberOfLayers=fscanf(fElem_i,'%d \n');
                % Initialize sub-cell
                i_ElementsMaterials=cell(i_ElementNumberOfLayers,1);
                for k=1:5
                    fgetl(fElem_i);
                end
                for k=1:i_ElementNumberOfLayers
                    i_ElementsMaterials{k}=fgetl(fElem_i);
                end
                for k=1:5
                    fgetl(fElem_i);
                end
                % the length of the recorded data depends on the number of
                % layers
                formatString=' %f %f';
                for jj=1:i_ElementNumberOfLayers
                    formatString=strcat(formatString,' %f');
                end
                % read thickness of the sub-layers. The order of the
                % reading is:
                % RadPos | tck Outer layer | ... | tck Inner Layer | Total element thickness
               
                i_ElementsLayerThickness=cell2mat(textscan(fElem_i,formatString));   
                % Convert thickness 2 mm
                i_ElementsLayerThickness(:,2:end) = i_ElementsLayerThickness(:,2:end)./1000;
                % Convert eta 2 radialPos
                i_ElementsLayerThickness(:,1) = (i_ElementsLayerThickness(:,1).*Input.BladeLength)+Input.HubRad;
                
            end
            % close i-th element file
            fclose(fElem_i);
            
            % assign variables  
            ElementsLayerThickness{i}=i_ElementsLayerThickness;
            i_ElementsLayerThickness=[];
            ElementsMaterials{i}=i_ElementsMaterials;
            i_ElementsMaterials=[];           
end

 % assign properties
    Input.Elements.StandFlag=ElementsStandalone;
    Input.Elements.LayerThickness=ElementsLayerThickness;
    Input.Elements.MatNames=ElementsMaterials;

