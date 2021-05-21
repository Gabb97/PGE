function WriteSectionFile(Parameters)



% Recover n.o.s.
NumberOfSections=length(Parameters.Blade.RadialPos);
% define target folder
TargetFolder='SectionFiles\Sections\';

for i=1:NumberOfSections
    FileAddress=strcat(TargetFolder,'Section_Layout_',num2str(i),'.inp');
    f=fopen(FileAddress,'w');
    
    % Write Header
    stringH='============================================================';
    stringH2='------------------------------------------------------------';
    string1='AirfoilDisc Input File - Section Layout';
    string2='Section number: ';
    string3='Location: ';
    string4='Eta: ';
    fprintf(f,'%s \n',stringH);
    fprintf(f,'%s \n',string1);
    fprintf(f,'%s \n',stringH);
    fprintf(f,'%s %d  \n',string2, i);
    fprintf(f,'%s %9.4f \n', string3,Parameters.Blade.RadialPos(i));
    fprintf(f,'%s %9.6f \n', string4,Parameters.Blade.Eta(i));
    fprintf(f,'%s \n',stringH);
    
    % Write geometry and coordinates of spar caps
    fprintf(f,'%10.4f \t %s \n',Parameters.Blade.Chord(i),'Chord length [m]');
    fprintf(f,'%10.4f \t %s \n',Parameters.Blade.Twist(i),'Twist [deg]');
    fprintf(f,'%10.4f \t %s \n',Parameters.Blade.LeadingEdge(i),'Leading edge [m]');
    fprintf(f,'%10.4f \t %s \n',Parameters.Blade.TrailingEdge(i),'Trailing edge [m]');
    fprintf(f,'%10.4f \t %s \n',Parameters.Blade.FrontSpar(i),'Front spar [m]');
    fprintf(f,'%10.4f \t %s \n',Parameters.Blade.RearSpar(i),'Rear spar [m]');
    fprintf(f,'%10.4f \t %s \n',Parameters.Blade.LEReinf(i),'LE reinforcement [m]');
    fprintf(f,'%10.4f \t %s \n',Parameters.Blade.TEReinf(i),'TE reinforcement [m]');    
    fprintf(f,'%10.4f \t %s \n',0.0,'Third web (not supported yet) [m]');
    fprintf(f,'%s \n',stringH);
    
    % Write number of elements and absolute/percentage variable
    i_NumberOfElements=length(Parameters.Section.SectionThickness{i});
    fprintf(f,'%d \t %s \n',i_NumberOfElements,'Number of Elements');
    fprintf(f,'%d \t %s \n',1,'Absolute/percentage thickness');
    fprintf(f,'%s \n',stringH);
    
    i_SectionThickness=Parameters.Section.SectionThickness{i};
    i_SectionMaterials=Parameters.Section.Materials{i};
    
    % Write layup of elements
    for j=1:i_NumberOfElements
        j_ElementThickness=[];
        j_ElementMaterials=[];
        j_ElementThickness=i_SectionThickness{j};
        j_ElementMaterials=i_SectionMaterials{j};
        if isempty(j_ElementThickness)==1
%             warning('WARNING: Element: %d is not defined on section: %d',j,i);
            stringE1='ELEMENT N. ';
            fprintf(f,'%s %d \n',stringE1, j);
            fprintf(f,'%s  \n','None');
            if j==i_NumberOfElements
                fprintf(f,'%s \n',stringH);
            else
                fprintf(f,'%s \n',stringH2);
            end
        else
            
            j_NumberOfLayers=length(j_ElementThickness);

            stringE1='ELEMENT N. ';
            fprintf(f,'%s %d \n',stringE1, j);
            j_TotalThickness=sum(j_ElementThickness);
            fprintf(f,'%f \t \t %s \n',j_TotalThickness, 'Element total thickness [m]');
            fprintf(f,'%d \t \t%s \n',j_NumberOfLayers, 'Number of Layers');

            for k=1:j_NumberOfLayers
                k_LayerThickness=[];
                k_LayerMaterialName=[];
                k_LayerMaterialName=j_ElementMaterials{k};
                k_LayerThickness=j_ElementThickness(k);
                fprintf(f,'%s \t %f \n',k_LayerMaterialName,k_LayerThickness);
            end
            if j==i_NumberOfElements
                fprintf(f,'%s \n',stringH);
            else
                fprintf(f,'%s \n',stringH2);
            end
        end
    end
    
    % Write Loads
    fprintf(f,'%20.2f \t %s \n',Parameters.Loads.Tx(i),'Tx [kN]');
    fprintf(f,'%20.2f \t %s \n',Parameters.Loads.Ty(i),'Ty [kN]');
    fprintf(f,'%20.2f \t %s \n',Parameters.Loads.Tz(i),'Tz [kN]');
    fprintf(f,'%20.2f \t %s \n',Parameters.Loads.Mx(i),'Mx [kNm]');
    fprintf(f,'%20.2f \t %s \n',Parameters.Loads.My(i),'My [kNm]');
    fprintf(f,'%20.2f \t %s \n',Parameters.Loads.Mz(i),'Mz [kNm]');
    fclose(f);

end