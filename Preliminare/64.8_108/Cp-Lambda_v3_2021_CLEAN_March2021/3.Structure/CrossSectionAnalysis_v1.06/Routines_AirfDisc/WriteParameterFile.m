function WriteParameterFile(SectionID,NumberFEthickness,WebNodesID,NumberFEwebs,Section,Input)

%% Airfoil file
PivotAirfoilFile=strcat('PivotAirfoil_',num2str(SectionID),'.dat');
ParametersFile=strcat('Airfoil2BECAS\Parameters_',num2str(SectionID),'.dat');
OutputFolder=strcat('..\BECASFiles\BECAS_Section_',num2str(SectionID));

ff=fopen(ParametersFile,'w');

%% Output directory 
string=strcat('outputdir = "',OutputFolder,'"');
fprintf(ff,'\n');
fprintf(ff,'%-s \n',string);

%% Output directory 
string=strcat('airfoilfilename = "',PivotAirfoilFile,'"');
fprintf(ff,'\n');
fprintf(ff,'%-s \n',string);

%% Number of thickness Finite Elements  
string='element_layers =';
fprintf(ff,'\n');
fprintf(ff,'%-s %-d \n',string,NumberFEthickness);

%% Shear Webs Location
fprintf(ff,'\n');

string='shear_webs = [';
fprintf(ff,'%-s ',string);
fprintf(ff,'%-s %-d %-s %-d %-s \n','[', WebNodesID(1,1),',',WebNodesID(2,1),'],');
fprintf(ff,'%-14s %-s %-d %-s %-d %-s \n','','[', WebNodesID(1,2),',',WebNodesID(2,2),']]');


%% Layout Definition

%--------------------------------------------------------------------
% Example Syntax:
%
% layup_of_elset['REGION04'] = [ [0.002, 3, 'TRIAX', 0.0, 'Ply06'], 
%                               [0.020, 3, 'CORE', 0.0, 'Ply07'],
%                               [0.002, 3, 'TRIAX', 0.0, 'Ply08'] ]
%
% The region 4 (skin, check Airf2Becas user's Guide) is composed of three
% different layers, the outer layer is of material 'TRIAX', and has a
% thickness of 0.002. The middle layer is of 'CORE' material with a 0.02
% thickness, the inner layer is od 'TRIAX' material with, again, a
% thickness of 0.002. Th total Skin thickness is then 0.024.
%--------------------------------------------------------------------

quote=char(039); %this allow to type ' character without conflicts.


% initialize
fprintf(ff,'\n');
string='layup_of_elset = {} ';
fprintf(ff,'%-s \n',string);

%% Write elements
PlyID=0;
NumberOfElements=length(Section.MaterialsNames);

% if Section.Type=='Sec' | Section.Type=='Box' 
    for j=1:NumberOfElements
        
        ElementMaterialsNames=Section.MaterialsNames{j};
        ElementThickness=Section.Thickness{j};
        
        if j<10
            string=strcat('layup_of_elset[',quote,'REGION0',num2str(j),quote,'] = ['); fprintf(ff,'%-s ',string);
        else
            string=strcat('layup_of_elset[',quote,'REGION',num2str(j),quote,'] = ['); fprintf(ff,'%-s ',string);  
        end
        
        NumberOfLayers=length(Section.MaterialsNames{j});
        for k=1:NumberOfLayers
            PlyID=PlyID+1;
            if k==1
                fprintf(ff,'%-s %-15.12f %-1s %-1d %-1s','[',ElementThickness(k),',',3,',');
            else
                 fprintf(ff,'\t \t \t \t \t \t \t \t \t \t \t \t \t \t \t %-s %-15.12f %-1s %-1d %-1s','[',ElementThickness(k),',',3,',');
            end
            MatString=ElementMaterialsNames{k};
            PlyString=strcat('ply',num2str(PlyID));
            string=strcat(quote,MatString,quote);  fprintf(ff,'%-s %-s',string,','); 
            fprintf(ff,'%-3.1f %-s',0.0,',');
            string=strcat(quote,PlyString,quote);  fprintf(ff,'%-s %-s ',string,']'); 

            if k<NumberOfLayers
                string=',';  fprintf(ff,'%-s \n',string); 
            else    
                string=']';  fprintf(ff,'%-s \n \n',string); 
            end
        end
    end
% end
% if the section is a cylinder, the properties are read from Element 1 and
% are assigned to all the elements (but not the webs, which must be
% assigned a fictional material)

% if Section.Type=='A'
%     j=1;
%     % Write the first element, the others are equal.
%     ElementMaterialsNames=Section.MaterialsNames{j};
%     ElementThickness=Section.Thickness{j};
%     
%     string=strcat('layup_of_elset[',quote,'REGION01',quote,'] = ['); fprintf(ff,'%-s ',string);
%     NumberOfLayers=length(Section.MaterialsNames{j});
%         for k=1:NumberOfLayers
%             PlyID=PlyID+1;
%             if k==1
%                 fprintf(ff,'%-s %-15.12f %-1s %-1d %-1s','[',ElementThickness(k),',',3,',');
%             else
%                  fprintf(ff,'\t \t \t \t \t \t \t \t \t \t \t \t \t \t \t %-s %-15.12f %-1s %-1d %-1s','[',ElementThickness(k),',',3,',');
%             end
%             MatString=ElementMaterialsNames{k};
%             PlyString=strcat('ply',num2str(PlyID));
%             string=strcat(quote,MatString,quote);  fprintf(ff,'%-s %-s',string,','); 
%             fprintf(ff,'%-3.1f %-s',0.0,',');
%             string=strcat(quote,PlyString,quote);  fprintf(ff,'%-s %-s ',string,']'); 
% 
%             if k<NumberOfLayers
%                 string=',';  fprintf(ff,'%-s \n',string); 
%             else    
%                 string=']';  fprintf(ff,'%-s \n \n',string); 
%             end
%         end
%     % connect element 2-8 to the first
%     for j=2:9
%         string=strcat('layup_of_elset[',quote,'REGION0',num2str(j),quote,'] = '); fprintf(ff,'%-s ',string);
%         string=strcat('layup_of_elset[',quote,'REGION01',quote,'] '); fprintf(ff,'%-s \n \n',string);
%     end
%     % connect element 10 to the first
%     string=strcat('layup_of_elset[',quote,'REGION10',quote,'] = '); fprintf(ff,'%-s ',string);
%     string=strcat('layup_of_elset[',quote,'REGION01',quote,'] '); fprintf(ff,'%-s \n \n',string);
%     
%     % Write fictional web 1 (element 11)
%     j=11;
%     PlyID=PlyID+1;
%     PlyString=strcat('ply',num2str(PlyID));
%     FictionalWebThickness=1e-06;
%     FictionalWebMaterial='FICT_WEBS';
%     string=strcat('layup_of_elset[',quote,'REGION11',quote,'] = ['); 
%     fprintf(ff,'%-s ',string);
%     fprintf(ff,'%-s %-15.12f %-1s %-1d %-1s','[',FictionalWebThickness,',',3,',');
%     string=strcat(quote,FictionalWebMaterial,quote);  fprintf(ff,'%-s %-s',string,','); 
%     fprintf(ff,'%-3.1f %-s',0.0,',');
%     string=strcat(quote,PlyString,quote);  fprintf(ff,'%-s %-s ',string,']'); 
%     string=']';  fprintf(ff,'%-s \n \n',string); 
%     
%     % Write fictional web 2 (element 12)
%     j=12;
%     string=strcat('layup_of_elset[',quote,'REGION',num2str(j),quote,'] = '); fprintf(ff,'%-s ',string);
%     string=strcat('layup_of_elset[',quote,'REGION11',quote,'] '); fprintf(ff,'%-s \n \n',string);
% 
%     
% end


 %% Shear Web FE number

fprintf(ff,'\n');
string='number_of_web_elements = ';fprintf(ff,'%-s ',string);
fprintf(ff,'%-s %-d %-s %-d %-s \n ','[',NumberFEwebs(1),',',NumberFEwebs(2),']' );


%% Reverse material
fprintf(ff,'\n');
string='reverse_normals = False ';fprintf(ff,'%-s \n',string);

%% Materials properties
fprintf(ff,'\n');
string='material_properties = {}';fprintf(ff,'%-s \n',string);


for kk=1:Input.Materials.MatNumb
    
    kk_MatName=Input.Materials.MatNames{kk};
    kk_MatProp=Input.Materials.MatProp{kk};

    fprintf(ff,'\n');
    string=strcat('material_properties[',quote,kk_MatName,quote,'] = {');fprintf(ff,'%-s \n',string);
        string=strcat(quote,'E1',quote,':');    fprintf(ff,'%-s %-8.4e %-s\n',string,  kk_MatProp(1),',');
        string=strcat(quote,'E2',quote,':');    fprintf(ff,'%-s %-8.4e %-s\n',string, kk_MatProp(2),',');
        string=strcat(quote,'E3',quote,':');    fprintf(ff,'%-s %-8.4e %-s\n',string, kk_MatProp(2),',');   
        string=strcat(quote,'nu12',quote,':');    fprintf(ff,'%-s %-8.4f %-s\n',string, kk_MatProp(3),',');
%         string=strcat(quote,'nu13',quote,':');    fprintf(ff,'%-s %-8.4f %-s\n',string, kk_MatProp(3),',');
%         string=strcat(quote,'nu23',quote,':');    fprintf(ff,'%-s %-8.4f %-s\n',string, kk_MatProp(3),',');
        string=strcat(quote,'nu13',quote,':');    fprintf(ff,'%-s %-8.4f %-s\n',string, kk_MatProp(3)*(kk_MatProp(2)/kk_MatProp(1)),',');
        string=strcat(quote,'nu23',quote,':');    fprintf(ff,'%-s %-8.4f %-s\n',string, kk_MatProp(3)*(kk_MatProp(2)/kk_MatProp(1)),',');
        
        string=strcat(quote,'G12',quote,':');    fprintf(ff,'%-s %-8.4e %-s\n',string, kk_MatProp(4),',');  
        string=strcat(quote,'G13',quote,':');    fprintf(ff,'%-s %-8.4e %-s\n',string, kk_MatProp(4),',');  
        string=strcat(quote,'G23',quote,':');    fprintf(ff,'%-s %-8.4e %-s\n',string, kk_MatProp(4),',');  
        string=strcat(quote,'rho',quote,':');    fprintf(ff,'%-s %-8.4e %-s\n',string, kk_MatProp(5),'}');  
end

% If section=='Cyl', add webs fictional material
if Section.Type=='A'
    fprintf(ff,'\n');
    string=strcat('material_properties[',quote,'FICT_WEBS',quote,'] = {');fprintf(ff,'%-s \n',string);
        string=strcat(quote,'E1',quote,':');    fprintf(ff,'%-s %-s %-s\n',string,  '9.73e+09' ,',');
        string=strcat(quote,'E2',quote,':');    fprintf(ff,'%-s %-s %-s\n',string, '9.73e+09',',');
        string=strcat(quote,'E3',quote,':');    fprintf(ff,'%-s %-s %-s\n',string, '9.73e+09',',');   
        string=strcat(quote,'nu12',quote,':');    fprintf(ff,'%-s %-s %-s\n',string, '0.59',',');
        string=strcat(quote,'nu13',quote,':');    fprintf(ff,'%-s %-s %-s\n',string, '0.59',',');
        string=strcat(quote,'nu23',quote,':');    fprintf(ff,'%-s %-s %-s\n',string, '0.59',',');
        string=strcat(quote,'G12',quote,':');    fprintf(ff,'%-s %-s %-s\n',string, '10.9e+09',',');  
        string=strcat(quote,'G13',quote,':');    fprintf(ff,'%-s %-s %-s\n',string, '10.9e+09',',');  
        string=strcat(quote,'G23',quote,':');    fprintf(ff,'%-s %-s %-s\n',string, '10.9e+09',',');  
        string=strcat(quote,'rho',quote,':');    fprintf(ff,'%-s %-s %-s\n',string, '80.0','}');  
end
    
fclose(ff);
% keyboard