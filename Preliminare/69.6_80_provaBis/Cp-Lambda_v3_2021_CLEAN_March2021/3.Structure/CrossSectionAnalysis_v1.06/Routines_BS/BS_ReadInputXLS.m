function [Input]=BS_ReadInputXLS(xlsfile)

%% Read settings and settings for modes
try
    read_data = xlsread(xlsfile,'Settings','A1:A17');
    
    Input.NumbSec   =   read_data(1);
    Input.RotorRad  =   read_data(2);
    Input.HubRad    =   read_data(3);
    
    Input.NumbEle   =   read_data(4);
    
    if Input.NumbEle~=12
        warning('Number of sectional elements must be 12. NumbEle set to 12');
        Input.NumbEle=12;
    end

    Input.NumbFE    =   read_data(5);
    if Input.NumbFE<30
        warning('Number of Finite Elements lower than 30 is not reccomendable. NumbFE set to 30.');
        Input.NumbFE=30;
    end


    Input.PlotOption        =   read_data(6);
    Input.Files4PPP         =   read_data(7);
    Input.PcLocationOfMass  =   read_data(8);

    % Compute Blade Length 
    Input.BladeLength       =   Input.RotorRad-Input.HubRad;
    
    % Compute Location of Point Mass
    Input.LocationOfMass    =   Input.BladeLength*Input.PcLocationOfMass;

    % Read 
    Input.Modes.ModesOption         =   read_data(8);
    Input.Modes.NonStrucOption      =   read_data(9);
    Input.Modes.Location            =   read_data(10);
    Input.Modes.RotationalOption    =   read_data(11);
    Input.Modes.Omega               =   read_data(12);
    Input.Modes.Beta                =   read_data(13);
    Input.Modes.AdjFact(1)          =   read_data(14);
    Input.Modes.AdjFact(2)          =   read_data(15);
    Input.Modes.AdjFact(3)          =   read_data(16);
    
    clear read_data
    
catch
    warning('Error while reading Settings from input.')
    keyboard
end

%% Read blade geometry and layout
try
    read_data = xlsread(xlsfile,'Blade_Layout','A2:L999');

    % Assign variables
    Input.Blade.Eta                     =   read_data(:,1);
    Input.Blade.RadialPos               =   read_data(:,2);
    
    Input.Blade.Chord                   =   read_data(:,3);
    Input.Blade.Twist                   =   read_data(:,4);
    Input.Blade.PitchAxis               =   read_data(:,5);
    Input.Blade.LeadingEdge             =   read_data(:,6);
    Input.Blade.TrailingEdge            =   read_data(:,7);
    Input.Blade.FrontSpar               =   read_data(:,8);
    Input.Blade.RearSpar                =   read_data(:,9);
    Input.Blade.LEReinf                 =   read_data(:,10);
    Input.Blade.TEReinf                 =   read_data(:,11);
    Input.Blade.NonStrucMass            =   read_data(:,12);

    
    Input.Blade.RadialPos               =   (Input.Blade.Eta*Input.BladeLength) + Input.HubRad ;
    Input.Blade.DistanceFromRoot        =   Input.Blade.Eta*Input.BladeLength;
    
    Input.Blade.Prebend                 = zeros(length(Input.Blade.RadialPos),1);
    Input.Blade.AirfoilID               = zeros(length(Input.Blade.RadialPos),1);
    
    clear read_data
    
catch
    warning('Error while reading Blade Layout from input.')
    keyboard
end

%% Read Loads
try
    read_data = xlsread(xlsfile,'Loads','A3:G999');

    % assign variables
    Input.Loads.Eta             =   read_data(:,1);
        Input.Loads.RadialPos   = (Input.Loads.Eta.*Input.BladeLength)+Input.HubRad;
        
    Input.Loads.Tx  =   read_data(:,2)*1e3;
    Input.Loads.Ty  =   read_data(:,3)*1e3;
    Input.Loads.Tz  =   read_data(:,4)*1e3;
    Input.Loads.Mx  =   read_data(:,5)*1e3;
    Input.Loads.My  =   read_data(:,6)*1e3;
    Input.Loads.Mz  =   read_data(:,7)*1e3;

    clear read_data
    
catch
    warning('Error while reading Loads from input.')
    keyboard
end    


%% Read Materials 

try
    [read_numb,read_data ]= xlsread(xlsfile,'Materials','A1:ZZ1');
    
    % Fill Materials list
    NumberOfMaterials = 0;
    for ij =1:length(read_data)
        if ~isempty(read_data{ij})
            NumberOfMaterials                   = NumberOfMaterials +1;
            MaterialsNames{NumberOfMaterials}   = strtrim(read_data{ij});
        end
    end
    
    clear read_data
    
    % Read Material Properties
    read_data = xlsread(xlsfile,'Materials','A2:ZZ17');  
    
    first_col = -2;
    for ij =1:NumberOfMaterials
        first_col = first_col +3;
        MaterialsProperties{ij} = read_data(:,first_col);
    end
        
    clear read_data        
    
    % Assign properties
    Input.Materials.MatNumb     =   NumberOfMaterials;
    Input.Materials.MatNames    =   MaterialsNames;
    Input.Materials.MatProp     =   MaterialsProperties;

    
catch
     warning('Error while reading Materials from input.')
     keyboard   
end


%% Read airfoils

try
    [read_numb,read_data ] = xlsread(xlsfile,'Airfoils','A2:C999');
    
    % Find n. of airfoils along the blade
    Input.Airfoils.AirfNumb     =   length(read_numb(:,1));
    
    AirfoilsEta         =   read_numb(:,1);
    AirfoilsThick       =   read_numb(:,3);
    AirfoilsNames       =   strtrim(read_data);
    
    % Find n. of UNIQUE airfoils along the blade
    NumberOfUniqueAirfoils = length(unique(AirfoilsNames));
    
    % Scan set of unique airfoils
    range_full=XLS_CreateFullRange;
    
    init_col = 2;
    for ik = 1: NumberOfUniqueAirfoils       
        init_col = init_col + 3;
        
        range_name      = [range_full{init_col} '1'];
        range_geom      = [range_full{init_col} '2:' range_full{init_col+1} '999'];
        
        [~,read_name]   = xlsread(xlsfile,'Airfoils',range_name);
        read_geom       = xlsread(xlsfile,'Airfoils',range_geom);
            
        AirfoilSet.AirfoilName{ik}  = strtrim(read_name);
        AirfoilSet.AirfoilGeom{ik}  = read_geom;
        
        clear read_name read_coord
        
    end
    

    % Find each airfoil within the set of UNIQUE airfoils and read
    % properties
    for ij = 1: Input.Airfoils.AirfNumb  
        
        % Search reference airfoil
        refpos = -999;
        for kk = 1:NumberOfUniqueAirfoils
            if  strcmpi(AirfoilsNames{ij},AirfoilSet.AirfoilName{kk})
                refpos = kk;
                break
            end
        end
        
        % Check if found
        if refpos == -999
            warnstr = ['Airfoil ' AirfoilsNames{ij} ' not found in the set of the given airfoils.'];           
            warning(warnstr)
            keyboard
        else
            % Build output
            Input.Airfoils.AirfPos(ij)      =   (AirfoilsEta(ij)*Input.BladeLength)+Input.HubRad;
            Input.Airfoils.AirfGeom{ij}     =   AirfoilSet.AirfoilGeom{kk};
            Input.Airfoils.AirfThick(ij)    =   AirfoilsThick(ij);            
            
        end
              
    end
    
    
     % Build t/c along the blade
    Input.Blade.Thickness       =   interp1(Input.Airfoils.AirfPos, Input.Airfoils.AirfThick, Input.Blade.RadialPos,'pchip');
    
%     figure()
%     hold on
%     grid on
%     plot(Input.Airfoils.AirfPos,    Input.Airfoils.AirfThick,'om')
%     plot(Input.Blade.RadialPos, Input.Blade.Thickness)
%     keyboard
    

    for j = 1:length(Input.Blade.RadialPos)
        for k = 1:Input.Airfoils.AirfNumb -1
            if Input.Blade.RadialPos(j) >= Input.Airfoils.AirfPos(k) && Input.Blade.RadialPos(j) < Input.Airfoils.AirfPos(k+1)
                Input.Blade.AirfoilID(j)    = k;
                break
            end
        end
    end
    Input.Blade.AirfoilID(end)    = k;      
        
    

catch
     warning('Error while reading Airfoils from input.')
     keyboard   
end



%% Read structural elements layout
try
    [read_numb,read_data ] = xlsread(xlsfile,'Blade_Topology','A2:F13');
    
%     Initialize cells
    Input.Elements.MatNames          =   cell(Input.NumbEle,1);
    Input.Elements.LayerThickness   =   cell(Input.NumbEle,1);
    
    for i=1:Input.NumbEle
        ElementIndependent(i) = read_numb(i,3);
        
        if ElementIndependent(i)
            Input.Elements.StandFlag(i) = 0;
            
            % Scan corresponding data
            
            sheet = ['Element_' num2str(i)];
            
            % Scan number of layers and define search ranges
            nLayers                 =   xlsread(xlsfile,sheet,'B4');
            lastrow_mat_range       =   8+nLayers-1;
            firstrow_thick_range    =   lastrow_mat_range + 5;
            lastcell_thick_range    =   range_full{1+nLayers+1};
            
            mat_range               =   ['B8:B' num2str(lastrow_mat_range)];
            thick_range             =   ['A' num2str(firstrow_thick_range) ':' lastcell_thick_range '999' ];
            
            % Scan relevant data (material names, layer thicknesses)
            [read_val,read_mat ]    =   xlsread(xlsfile,sheet,mat_range);
            
            [read_thick,read_char]  =   xlsread(xlsfile,sheet,thick_range);
            
            % Convert eta to radpos, convert thickness to meters
            read_thick(:,1)         =   (read_thick(:,1).*Input.BladeLength)+Input.HubRad;
            read_thick(:,2:end)     =   read_thick(:,2:end)./1000;
            
            
            Input.Elements.MatNames{i}          =   read_mat;
            Input.Elements.LayerThickness{i}    =   read_thick;
            
            
        else
            % Link to master, assign empty variables
            Input.Elements.StandFlag(i)         =   read_numb(i,4);
            Input.Elements.MatNames{i}          =   zeros(10);
            Input.Elements.LayerThickness{i}   	=   zeros(10);
        end
    end
    


catch
     warning('Error while reading Sectional Elements from input.')
     keyboard   
end
% 
% % Initialize cells
% ElementsStandalone=[];
% ElementsMaterials=cell(Input.NumbEle,1);
% ElementsLayerThickness=cell(Input.NumbEle,1);
% 
% % for each element, open the corresponfing file and scan the properties. If
% % an element is 'standalone' (ElementsStandalone=0), then its properties 
% % are taken. Vice-versa, if an element is related to another, an array of
% % zeros is assiged to the variable ElementsProperties.
% for i=1:Input.NumbEle
%     ElementFileAddress=strcat('Input\Elements\Element_',num2str(i),'.elem');
%     fElem_i=fopen(ElementFileAddress);
%             for k=1:9
%                 fgetl(fElem_i);
%             end
%             i_ElementStandalone=fscanf(fElem_i,'%d \n');
%             if i_ElementStandalone~=0
%                 % assign pointer and (empty) variables
%                 ElementsStandalone(i)=i_ElementStandalone;
%                 ElementsMaterials{i}=zeros(10);
%                 ElementsLayerThickness{i}=zeros(10);
%             else
%                 ElementsStandalone(i)=0;
%                 for k=1:9
%                     fgetl(fElem_i);
%                 end
%                 i_ElementNumberOfLayers=fscanf(fElem_i,'%d \n');
%                 % Initialize sub-cell
%                 i_ElementsMaterials=cell(i_ElementNumberOfLayers,1);
%                 for k=1:5
%                     fgetl(fElem_i);
%                 end
%                 for k=1:i_ElementNumberOfLayers
%                     i_ElementsMaterials{k}=fgetl(fElem_i);
%                 end
%                 for k=1:5
%                     fgetl(fElem_i);
%                 end
%                 % the length of the recorded data depends on the number of
%                 % layers
%                 formatString=' %f %f';
%                 for jj=1:i_ElementNumberOfLayers
%                     formatString=strcat(formatString,' %f');
%                 end
%                 % read thickness of the sub-layers. The order of the
%                 % reading is:
%                 % RadPos | tck Outer layer | ... | tck Inner Layer | Total element thickness
%                
%                 i_ElementsLayerThickness=cell2mat(textscan(fElem_i,formatString));   
%                 % Convert thickness 2 mm
%                 i_ElementsLayerThickness(:,2:end) = i_ElementsLayerThickness(:,2:end)./1000;
%                 % Convert eta 2 radialPos
%                 i_ElementsLayerThickness(:,1) = (i_ElementsLayerThickness(:,1).*Input.BladeLength)+Input.HubRad;
%                 
%             end
%             % close i-th element file
%             fclose(fElem_i);
%             
%             % assign variables  
%             ElementsLayerThickness{i}=i_ElementsLayerThickness;
%             i_ElementsLayerThickness=[];
%             ElementsMaterials{i}=i_ElementsMaterials;
%             i_ElementsMaterials=[];           
% end
% 
%  % assign properties
%     Input.Elements.StandFlag=ElementsStandalone;
%     Input.Elements.LayerThickness=ElementsLayerThickness;
%     Input.Elements.MatNames=ElementsMaterials;
% 
% 
