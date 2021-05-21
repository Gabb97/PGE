function [Section]=BS_InterpolateStructure(NumberOfElements,InputElements, RadialPos)

% This subroutine interpolates the data of the structural layout in order
% to evaluate the internal geometry at the required span-wise stations.
%
% Input: the structural layout, which includes elements configuration and 
%        the corresponding materials.
% 
% Output: the interpolated structural layout


NumberOfSections=length(RadialPos);
% Initialize output cell
SectionThickness=cell(NumberOfSections,1);
SectionMaterialsNames=cell(NumberOfSections,1);

for i=1:NumberOfSections
    % Initialize sub-cells
    i_SectionThickness          =   cell(NumberOfElements,1);
    i_SectionMaterialsNames     =   cell(NumberOfElements,1);
    
    % Define current section location
    i_RadialPos=RadialPos(i);
    % For each section, each of the n_elements must be scan in order to
    % acquire informations about the section layup:
    for j=1:NumberOfElements
        % if the j-th element is 'standalone', then its properties are read
        % from file. Otherwise, a blank array is assigned to its
        % properties. when this cycle is finished, then the 'master'
        % properties will be assigned.        
        if InputElements.StandFlag(j)==0
            j_LayerThicknessMatrix  =   [];
            j_LayerThickness        =   [];
%             TargetFolder            =   'Input\Elements\';
%             FileAddress=strcat(TargetFolder,'Element_',num2str(j),'.elem');
%             f=fopen(FileAddress);
%             for kk=1:35
%                 fgetl(f);
%             end
            % Read number of material layers for the j-th element
            j_MaterialsNames=InputElements.MatNames{j};
            j_NumberOfLayers=length(j_MaterialsNames);
            % scan material layers (array)
            for k=1:j_NumberOfLayers
                j_LayerThicknessMatrix=cell2mat(InputElements.LayerThickness(j));
                j_LayerThickness(k)=interp1(j_LayerThicknessMatrix(:,1),j_LayerThicknessMatrix(:,k+1),i_RadialPos);
            end
%             fclose(f);
            
            % If some j_LayerThickness is NaN, the element is not defined
            % at this section (for example the spar cap at root).
            % In this case, a zero is assigned to output:

            if isnan(j_LayerThickness(1))==1
                 j_LayerThickness=[];
%                  j_LayerThickness=0;
                 j_MaterialsNames=[];
%                  j_MaterialsNames=0;
            else
            
                % If some layer is zero on this element, then it must discarded
                % otherwise ill-conditioning problems will appear in BECAS. So,
                % new j_LayerThickness and  j_MaterialsNames are defined s.t. 
                % they contain only non-zero elements.
                [dummyrow,NonZeroPos]=find(j_LayerThickness);
                if length(NonZeroPos)==j_NumberOfLayers

                else
                        % Initialize a new cell for names
                        New_j_LayerThickness=[];
                        New_j_MaterialsNames=[];
                        New_j_MaterialsNames=cell(length(NonZeroPos),1);
                        for n=1:length(NonZeroPos)
                            New_j_LayerThickness(n)=j_LayerThickness(NonZeroPos(n));
                            New_j_MaterialsNames{n}=j_MaterialsNames{NonZeroPos(n)};
                        end    
                        % Re-assign to correct output
                        j_LayerThickness=[];
                        j_LayerThickness=New_j_LayerThickness;
                        j_MaterialsNames=[];
                        j_MaterialsNames=New_j_MaterialsNames; 
                 end
            end
            % assign data to the j-th member of the (sectional) cell            
            i_SectionThickness{j}=j_LayerThickness;
            i_SectionMaterialsNames{j}=j_MaterialsNames;
        else
            % assign zero values  to the j-th member of the (sectional) cell
            i_SectionThickness{j}=0;
            i_SectionMaterialsNames{j}=0;        
        end
    end
    % Now that all the informations have been stored, the elements with
    % 'stadlaone flag' not equal to zero will be assigned the properties
    % of the corresponding master
    for j=1:NumberOfElements
         if InputElements.StandFlag(j)==0
             
         else
            i_SectionThickness{j}=i_SectionThickness{InputElements.StandFlag(j)};
            i_SectionMaterialsNames{j}=i_SectionMaterialsNames{InputElements.StandFlag(j)};
         end
    end
    SectionThickness{i}=i_SectionThickness;
    SectionMaterialNames{i}=i_SectionMaterialsNames;

end

% create output
Section.SectionThickness=SectionThickness;
Section.Materials=SectionMaterialNames;

        
