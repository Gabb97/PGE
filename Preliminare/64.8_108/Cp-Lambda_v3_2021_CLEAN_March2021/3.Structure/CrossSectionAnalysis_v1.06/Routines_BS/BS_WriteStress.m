function BS_WriteStress(SectionID,Results,ElementsMap,File)

% This function allows to write the value of the six-stress components on
% each of the Finite Elements which describe the various structural
% members. The value of the six-stress components are reported for each FE
% while, for each of the 10 (11) structural members, the min and the max
% value for each stress component is also reported.


%% Extract the Elements Map for the section under investigation

ElementsID=ElementsMap.Elements{SectionID};
MaterialsID=ElementsMap.Materials{SectionID};
MaterialsList=ElementsMap.MaterialsList{SectionID};
Stress=Results.Stress;
Strain=Results.Strain;

% Determine number of Structural Elements
NumberOfElements=length(ElementsID);

% Iniialize cells
% MaxElementStress=cell(NumberOfElements,1);
% MinElementStress=cell(NumberOfElements,1);


f=fopen(File,'w');
for i=1:NumberOfElements
    % Extract the Elements Map for the structural element under investigation
    Elements=ElementsID{i};
    Materials=MaterialsID{i};
    MaterialsNames=MaterialsList{i};
    % for each StrElem, the Elements Map is in the form: [NumbFE,
    % NumberOfLayers]. here, the matrix is reshaped into a single-colum
    % array.
    [nRow,nCol]=size(Elements);
    i_NumbFE=nRow*nCol;
    i_ResElementID=reshape(Elements,i_NumbFE,1);
    i_ResMaterialsID=reshape(Materials,i_NumbFE,1);
    
    % Write StrElem header:
    string='****************************************************************************************************************************';
    fprintf(f,'%s \n',string);
    string2=strcat('ELEMENT_',num2str(i),':');
    fprintf(f,'%s \n',string2);
    fprintf(f,'%s \n',string);
    
    % Find stress in all the FE
    i_ElementID=[];
    i_Stress=[];
    i_MaterialID=[];
    for j=1:i_NumbFE
            i_ElementID(j)=i_ResElementID(j);
            for k=1:length(Stress(:,1))
                if Stress(k,1)==i_ElementID(j)
                    kPos=k;
                    break
                end
            end
            i_Stress(j,:)=Stress(kPos,2:7);
            i_MaterialID(j)=i_ResMaterialsID(j);
            
    end
    
    % Find maximum local stress on the i-th StrElem
   [maxStress, rowPlace]=max(i_Stress);
   
   MaxMaterial=cell(6,1);
   MaxLabel=cell(6,1);
   for k=1:6
       Row=rowPlace(k);
       MaxStress(k)=maxStress(k);
       MaxElem(k)=i_ElementID(Row);
       MaxMaterial{k}=MaterialsNames{i_MaterialID(Row)};
   end   
   
    
   
   MaxLabel{1}='Sigma_xx';
   MaxLabel{2}='Sigma_yy';   
   MaxLabel{3}='Sigma_xy';   
   MaxLabel{4}='Sigma_xz';   
   MaxLabel{5}='Sigma_yz';   
   MaxLabel{6}='Sigma_zz';
   
   % write maximum stress value for each of the six components
   string='Maximum stress:';
   fprintf(f,'\t %s \n', string);
   fprintf(f,'\n');
   fprintf(f,'\t \t \t \t \t \t \t \t \t %s %s \t \t %s ','Max value [MPa]','Element ID','Material');
   fprintf(f,'\n');
   for k=1:6
        fprintf(f,'\t  %10s %16.4f %10d %20s \n',MaxLabel{k},MaxStress(k)/1e6,MaxElem(k),MaxMaterial{k});
   end
   fprintf(f,'\n');
  
  
   % Find minimum local stress on the i-th StrElem
   [minStress, rowPlace]=min(i_Stress);
   
   MinMaterial=cell(6,1);
  
   for k=1:6
       Row=rowPlace(k);
       MinStress(k)=minStress(k);
       MinElem(k)=i_ElementID(Row);
       MinMaterial{k}=MaterialsNames{i_MaterialID(Row)};
   end   
   % Write minimum stress value for each of the six components
    string='Minimum stress:';
   fprintf(f,'\t %s \n', string);
   fprintf(f,'\n');
   fprintf(f,'\t \t \t \t \t \t \t \t \t %s %s \t \t %s ','Min value [MPa]','Element ID','Material');
   fprintf(f,'\n');
   for k=1:6
        fprintf(f,'\t %10s %16.4f %10d %20s \n',MaxLabel{k},MinStress(k)/1e6,MinElem(k),MinMaterial{k});
   end
   fprintf(f,'\n');
   
   % Write the six components of stress for any Finite Element which describes the StrElem under investigation   
   string='****************************************************************************************************************************';
   fprintf(f,'%s \n',string);
    fprintf(f,'\t %-10s %-15s %-15s %-15s %-15s %-15s %-15s %-15s \n','Element:', 'Material', 'sigma_xx [Mpa]', 'sigma_yy [Mpa]','sigma_xy [Mpa]','sigma_xz [Mpa]','sigma_yz [Mpa]','sigma_zz [Mpa]');   

   for j=1:i_NumbFE
       fprintf(f,'%10d %15s',i_ElementID(j),MaterialsNames{i_MaterialID(j)});
            for k=1:6
                fprintf(f,'%16.4f',i_Stress(j,k)/1e6);
            end
            fprintf(f,'\n');
   end

end
fclose(f);
            
