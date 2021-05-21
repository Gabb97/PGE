function [MatProperties]=ReadSectonLayup

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
    MatFiles=cell(NumberOfElementLayers,1);
    
    for j=1:NumberOfElementLayers
        MatName=cell2mat(textscan(fmat,'%12c',1)); fgetl(fmat);
        MatFiles{j}=strcat(MatName,'.dat')
        ReadMaterials
        
    end

end

MatProperties=cell2mat(textscan(fmat,'%f %f %f %f %f %f %f %f'));