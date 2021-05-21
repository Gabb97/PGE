function [ElementsID, MaterialsID,Materials]=BS_ElementsMap(SectionData,SectionID)

% This function reads the 'temp.inp' file generated from Airfoil2BECAS and
% identifies which Finite Elements are associated to a specific structural
% element (i.e. Spar Cap). This allows to read the BECAS output (stress,
% strain) and to assign each stress to its correct location within the
% section.

fclose('all');
%% Define number of elements and number of layers
NumberOfElements=length(SectionData.MaterialsNames);

% In cylindricl sections (i.e. no webs and spars) the shear webs are
% fictional, as they are introduced only because BECAS needs them to be
% defined. So, therE is no need to map web-elements.
 if SectionData.Type=='A'
     NumberOfElements=10;
 end
NumberOfLayers=0;
for i=1:NumberOfElements
    if length(SectionData.MaterialsNames{i})>NumberOfLayers
        NumberOfLayers=NumberOfLayers+1;
    end
end

% Initialize cell
SurfaceElementsID=cell(NumberOfElements,1);
ElementsID=cell(NumberOfElements,1);


%% Scan temp file
jElem=0;
TempFile=strcat('Airfoil2BECAS\temp.inp');
f=fopen(TempFile);
    % Find number of FE elements
    while ~ feof(f)
        if findstr(fgetl(f),'*ELEMENT, TYPE=S4, ELSET=BECAS_SECTION')==1
            fgetl(f);
            ReadElementsDefinition=textscan(f,'%d %c %f %c %f %c %f %c %f %c');
            NumbFE=max(ReadElementsDefinition{1});
            break
        end
    end
    frewind(f);

    % Find 'ELEMENT SETS' marker
    while ~ feof(f)
        if findstr(fgetl(f),'** ELEMENT SETS')==1
            MarkerString='*ELSET, ELSET=REGION';          
            % Find '*ELSET, ELSET=REGION0X' marker
            while ~ feof(f)
                if findstr(fgetl(f),MarkerString)==1
                    jElem=jElem+1;
                    % Read surface (outer layer) finite elements. The rest of the
                    % finite elements of each element will be derived from
                    % here and from the total number of FE.
                    ReadElements=[];
                    ReadElements=textscan(f,'%d %[,]');
                    SurfaceElementsID{jElem}=ReadElements{1};
                    if jElem==NumberOfElements
                        break
                    end                  
                end
            end           
        end
    end
    frewind(f);
    % read the material order, because Airfoil2BECAS re-arranges the order
    % of the material alphabetically
    
    % Find 'MATERIAL PROPERTIES' marker
    while ~ feof(f)
        if findstr(fgetl(f),'** MATERIAL PROPERTIES')==1
            jMat=0;
            % Find Material name
            while ~ feof(f)
                MatString=fgetl(f);
                if findstr(MatString,'*MATERIAL, NAME=')==1
                    jMat=jMat+1;
                    MaterialsList{jMat}=MatString(17:length(MatString));
                end
            end
        end
    end
fclose(f);

%% Scane EMAT.IN File
EMATFile=strcat('BECASFiles\BECAS_Section_',num2str(SectionID),'\BECAS_SECTION\EMAT.in');
f=fopen(EMATFile);
    ReadEMAT=cell2mat(textscan(f,'%d %d %d %d'));
    EMATList=ReadEMAT(:,1:2);
fclose(f);


    
 %% Build elements cells

 for i=1:NumberOfElements
     i_ElementsID   =   [];
     i_MaterialsID  =   [];
     
     % Complete FE assignment
     i_NumbFE=length(SurfaceElementsID{i});
     i_ElementsID(:,1)=SurfaceElementsID{i};
     FirstElement=i_ElementsID(1,1);
     if NumberOfLayers>1
        for k=2:NumberOfLayers
            LowerMarker=FirstElement+NumbFE*(k-1);
            UpperMarker=LowerMarker+(i_NumbFE-1);
            k_RowElementsID=linspace(double(LowerMarker),double(UpperMarker),i_NumbFE);
            i_ElementsID(:,k)=k_RowElementsID;
        end
     end
     % Assign materials
     for jj=1:length(i_ElementsID(:,1))
         for kk=1:length(i_ElementsID(1,:))
             ScanArray=EMATList(:,1);
             [iRow,jCol] = find(ScanArray == i_ElementsID(jj,kk));
             i_MaterialsID(jj,kk)=EMATList(iRow,2);
         end
     end
     ElementsID{i}=i_ElementsID;
     MaterialsID{i}=i_MaterialsID;
     Materials{i}=MaterialsList;
 end
 

%% Assign output

%  ElementsMap.Elements=ElementsID;
%  ElementsMap.Materials=MaterialsID;
 
%% Prepare map file
TargetFile=strcat('BECASFiles\BECAS_Section_',num2str(SectionID),'\SurfaceElementsMap_',num2str(SectionID),'.dat');
ff=fopen(TargetFile,'w');
    % write materials list
    string='MATERIALS:';
        fprintf(ff,'%s \n',string);
        for i=1:length(MaterialsList)
            format='\t %-5d %-30s \n';
            fprintf(ff,format,i,MaterialsList{i});
        end
        
    for i=1:NumberOfElements
        string=strcat('ELEMENT_',num2str(i),':');
        fprintf(ff,'%s \n',string);
        string='Elements ID:';
        fprintf(ff,'\t %s \n',string);
        
        ElementMatrix=ElementsID{i};
        [NumbRow,NumbCol]=size(ElementMatrix);
        for j=1:NumbRow
            for k=1:NumbCol
                fprintf(ff,'\t \t %d',ElementMatrix(j,k));
                if k== NumbCol
                    fprintf(ff,'\n');
                end
            end
        end
        string='Materials ID:';
        fprintf(ff,'\t %s \n',string);

        MaterialsMatrix=MaterialsID{i};
        for j=1:NumbRow
            for k=1:NumbCol
                fprintf(ff,'\t \t %d',MaterialsMatrix(j,k));
                if k== NumbCol
                    fprintf(ff,'\n');
                end
            end
        end
    end
fclose(ff) ;         


%% Delete temp file
delete(TempFile);
