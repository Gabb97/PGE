function BS_WriteMinMaxStress(RadialPos,Eta,Input,SectionType,SectionID,Results,ElementsMap,File)

% This function allows to write the value of the six-stress components on
% each of the Finite Elements which describe the various structural
% members. The value of the six-stress components are reported for each FE
% while, for each of the 10 (11) structural members, the min and the max
% value for each stress component is also reported.

% Recall the number of independent (standalone) members. An output file
% will be produced for each independent member. In the output file, the
% max/min values of the stress are reported on each layer of the structural
% member. If a NOT standalone member (i.e lower spar cap, Region 3) is linked 
% to another, standalone member (i.e upper spar cap, Region 6) then only one
% output file will be produced (named: Stress_06), but the
% values of the min/max stress are reported after takin into consideration both
% members.




%% Extract the Elements Map, the stress and the strain for the section under investigation
StandFlag               =   Input.Elements.StandFlag;
SectionalElementsID     =   ElementsMap.Elements{SectionID};
SectionalMaterialsID    =   ElementsMap.Materials{SectionID};
SectionalMaterialsList  =   ElementsMap.MaterialsList{SectionID};
Stress                  =   Results.Stress;
Strain                  =   Results.Strain;


% Determine number of Structural Elements
if SectionType=='A'
    NumberOfElements        =   10;
    StandMembersID(1)       =   1;
    NumberOfStandMembers    =   1;
    
    for j=2:length(StandFlag)
        StandFlag(j) =  1;
    end
else
    NumberOfElements        =   length(SectionalElementsID);
    StandMembersID          =   find(StandFlag==0);
    NumberOfStandMembers    =   length(StandMembersID);
end


% Initialize cell of the slave members
SlaveMembers=cell(NumberOfStandMembers,1);
keyboard

% Link non-standalone members to standlaone members
for i=1:NumberOfStandMembers  
    Array=[];
    for j=1:NumberOfElements
    	if StandFlag(j)==StandMembersID(i)
            Array=[Array j];
        end
    end
    SlaveMembers{i}=Array;
end
for i=1:NumberOfStandMembers     
    % Initialize arrays
    LayersIndex=[];
    SlavesIndex=[]; ElementsID=[]; MaterialsID=[];FullElementsID=[];
    FullMaterialsID=[]; j_SlaveElementsID=[]; j_SlaveMaterialsID=[];
    
    MemberIndex=StandMembersID(i);
    MakeFolder=strcat('Output\Elements\Element_',num2str(MemberIndex));
    Check=exist(MakeFolder,'dir');
    if Check==0
        mkdir(MakeFolder);
    end 
    SlavesIndex=SlaveMembers{i};

    % Determine global number of (unique) layers. then, if two or more layers
    % are assigned the same material, they figure only one time.
    Layers=unique(Input.Elements.MatNames{MemberIndex});
    % For each (unique) layer, find the corresponding ID within the full materials list
    MatList=SectionalMaterialsList{1};
    for j=1:length(Layers)
        for k=1:length(MatList)
            if findstr(MatList{k},Layers{j})==1
                LayersIndex(j)=k;
            end
        end
    end
    
    %% Build stress arrays master+slaves
    % master
    ElementsID=SectionalElementsID{MemberIndex};
    MaterialsID=SectionalMaterialsID{MemberIndex};
    [nRows,nCols]=size(ElementsID);
    NumbFE=nRows*nCols;
    FullElementsID=reshape(ElementsID,NumbFE,1);
    FullMaterialsID=reshape(MaterialsID,NumbFE,1);
    % slaves (if present)
    if isempty(SlavesIndex) 
    else        
        for j=1:length(SlavesIndex)
            ElementsID=SectionalElementsID{SlavesIndex(j)};
            MaterialsID=SectionalMaterialsID{SlavesIndex(j)};
            [nRows,nCols]=size(ElementsID);
            NumbFE=nRows*nCols;
            j_SlaveElementsID=reshape(ElementsID,NumbFE,1);
            j_SlaveMaterialsID=reshape(MaterialsID,NumbFE,1);
            FullElementsID=[FullElementsID; j_SlaveElementsID];
            FullMaterialsID=[ FullMaterialsID; j_SlaveMaterialsID];

        end
    end
    
    for j=1:length(Layers)
        % Initialie arrays
        jLayerFullElementID=[];
        jLayerStress=[];
        jLayerMinMaxStress=[];
        
        
              
        
        kLayers=0;
        % Identify all the Finite Elements which are assigned the j-th
        % material
        for k=1:length(FullElementsID)
            if FullMaterialsID(k)==LayersIndex(j);              
                kLayers=kLayers+1;
                jLayerFullElementID(kLayers)=FullElementsID(k);               
            end
        end
%             MatList(LayersIndex(j))
%              jLayerFullElementID
%             pause
        % identify all the stress which act on the j-th material
        if isempty(jLayerFullElementID)
            jLayerStress(k,:)=[0 0 0 0 0 0 0];
            jLayerStrain(k,:)=[0 0 0 0 0 0 0];
        else
            for k=1:length(jLayerFullElementID)
                for w=1:length(Stress(:,1))
                    if Stress(w,1)==jLayerFullElementID(k)
                        jLayerStress(k,:)=Stress(w,:);
                        jLayerStrain(k,:)=Strain(w,:);
                    end
                end
            end
        end
            % identify Max/Min stress value:
            % jLayerMinMaxStress= | Max_Sigma_xx | Min_sigma_xx|
            %                     | Max_Sigma_yy | Min_Sigma_yy|
            %                     | ...          | ...         |
            for k=1:6
                jLayerMinMaxStress(k,1)=max(jLayerStress(:,k+1));
                jLayerMinMaxStress(k,2)=min(jLayerStress(:,k+1));
                jLayerMinMaxStrain(k,1)=max(jLayerStrain(:,k+1));
                jLayerMinMaxStrain(k,2)=min(jLayerStrain(:,k+1));
            end
            % Write Maxstress and MinStress Output Files
            FileMax=strcat('Output\Elements\Element_',num2str(MemberIndex),'\MaxStress_',MatList{LayersIndex(j)},'.out');
            FileMin=strcat('Output\Elements\Element_',num2str(MemberIndex),'\MinStress_',MatList{LayersIndex(j)},'.out');  
            
            formatH='%-10s %-12s %-15s %-15s %-15s %-15s %-15s %-15s \n';
            FCheck=exist(FileMax,'file');
            f=fopen(FileMax,'a');
            if FCheck==0               
                fprintf(f,formatH,'Eta','RadialPos [m]', 'Sigma_xx [MPa]','Sigma_yy [MPa]','Sigma_xy [MPa]','Sigma_xz [MPa]','Sigma_yz [MPa]','Sigma_zz [MPa]');
            end
            fprintf(f,'%-10.5f %-15.4f',Eta,RadialPos);
            for k=1:6
                fprintf(f,'%-16.4f', jLayerMinMaxStress(k,1)/1e6);
            end
            fprintf(f,'\n');
            fclose(f);
            
            GCheck=exist(FileMin,'file');
            g=fopen(FileMin,'a');  
            if  GCheck == 0
                fprintf(g,formatH,'Eta','RadialPos [m]', 'Sigma_xx [MPa]','Sigma_yy [MPa]','Sigma_xy [MPa]','Sigma_xz [MPa]','Sigma_yz [MPa]','Sigma_zz [MPa]');
            end
            fprintf(g,'%-10.5f %-15.4f',Eta,RadialPos);
            for k=1:6
                fprintf(g,'%-16.4f', jLayerMinMaxStress(k,2)/1e6);
            end
            fprintf(g,'\n');          
            fclose(g);
            
            % Write Maxstrain and MinStrain Output Files
            FileMax=strcat('Output\Elements\Element_',num2str(MemberIndex),'\MaxStrain_',MatList{LayersIndex(j)},'.out');
            FileMin=strcat('Output\Elements\Element_',num2str(MemberIndex),'\MinStrain_',MatList{LayersIndex(j)},'.out'); 
            formatH='%-10s %-12s %-15s %-15s %-15s %-15s %-15s %-15s \n';
            FCheck=exist(FileMax,'file');
            f=fopen(FileMax,'a');
            if FCheck==0               
                fprintf(f,formatH,'Eta','RadialPos [m]', 'Epsilon_xx [%]','Epsilon_yy [%]','Epsilon_xy [%]','Epsilon_xz [%]','Epsilon_yz [%]','Epsilon_zz [%]');
            end
            fprintf(f,'%-10.5f %-15.4f',Eta,RadialPos);
            for k=1:6
                fprintf(f,'%-16.6f', jLayerMinMaxStrain(k,1)*100);
            end
            fprintf(f,'\n');
            fclose(f);
            
            GCheck=exist(FileMin,'file');
            g=fopen(FileMin,'a');  
            if  GCheck == 0
                fprintf(g,formatH,'Eta','RadialPos [m]', 'Epsilon_xx [%]','Epsilon_yy [%]','Epsilon_xy [%]','Epsilon_xz [%]','Epsilon_yz [%]','Epsilon_zz [%]');
            end
            fprintf(g,'%-10.5f %-15.4f',Eta,RadialPos);
            for k=1:6
                fprintf(g,'%-16.6f', jLayerMinMaxStrain(k,2)*100);
            end
            fprintf(g,'\n');          
            fclose(g);

    end
   
    
end
    




