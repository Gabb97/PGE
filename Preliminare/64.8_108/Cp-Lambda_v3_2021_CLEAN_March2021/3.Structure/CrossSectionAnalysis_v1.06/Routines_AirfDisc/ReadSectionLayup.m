function [Materials, MaxNumberOfLayers]=ReadSectonLayup(ElementsThickness,MinimumNumberFEthickness)

% Initialize maxNumberOfLayers
MaxNumberOfLayers=MinimumNumberFEthickness;


fmat=fopen('Section_Layup.in');
fgetl(fmat);
fgetl(fmat);
fgetl(fmat);

%% Read number of structural elements and thickness mode
% if ThicknessMode==1, then the thickness of each layer
% is defined as percentage of the total thickness of the 
% structural element. If ThicknessMode==2, then the 
% thickness of each layer is defined by its absolute value
% in meters.
NumberOfStructuralElements= fscanf(fmat,('%d \n'));
fgetl(fmat);
ThicknessMode= fscanf(fmat,('%d \n'));
fgetl(fmat);


%% Read sectional layup and materials
for i=1: NumberOfStructuralElements
    fgetl(fmat);
    fgetl(fmat);
    NumberOfElementLayers=fscanf(fmat,('%d \n '));fgetl(fmat);
    
    % The maximum number of layer must be saved, because it determines
    % the number of FE used for describing height
    if NumberOfElementLayers>MaxNumberOfLayers
        MaxNumberOfLayers=NumberOfElementLayers;
    end
    
    % Initialize cells
    MatFiles=cell(NumberOfElementLayers,1);
    MatProp=cell(NumberOfElementLayers,1);
    MatPlyThickness=cell(NumberOfElementLayers,1);
    MatAbsPlyThickness=cell(NumberOfElementLayers,1);
    
    for j=1:NumberOfElementLayers
        MatName=cell2mat(textscan(fmat,'%12c',1)); 
        PlyThickness=cell2mat(textscan(fmat,'%f',1)); fgetl(fmat);
        
        MatPlyThickness{j}=PlyThickness
        if ThicknessMode==1
            MatAbsPlyThickness{j}=ElementsThickness(i)*(MatPlyThickness{j}/100);
        else
            MatAbsPlyThickness{j}=MatPlyThickness{j};
        end
        MatFiles{j}=strcat(MatName,'.dat');
       [MatProp{j}]=ReadMaterialProp( MatFiles{j});
    end
    
    % The layers of each single elements are stored in a commons structure.
    Materials(i).PlyThickness=MatPlyThickness;
    Materials(i).AbsPlyThickness=MatAbsPlyThickness;
    Materials(i).MatProp=MatProp;
    
    % Discard transitional cells
    MatFiles=[];
    MatProp=[];
    MatPlyThickness=[];
    MatAbsPlyThickness=[];

end
