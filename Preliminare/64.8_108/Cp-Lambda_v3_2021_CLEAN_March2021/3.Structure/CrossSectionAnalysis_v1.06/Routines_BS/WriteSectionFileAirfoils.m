function WriteSectionFileAirfoils(Airfoils,RadialPositions)

TargetFolder='SectionFiles\Airfoils\';

for i=1:length(RadialPositions)
    FileAddress=strcat(TargetFolder,'Airfoil_',num2str(i),'.geom');
    f=fopen(FileAddress,'w');
    % write header
    string1=strcat('Airfoil # ',num2str(i));
    string2=strcat('Section taken at: ', num2str(RadialPositions(i)),'m');
    fprintf(f,'%-20s, %s \n',string1,string2);
    string3='Geometry file obtained by linear interpolation.';
    string4='============================================================';
    fprintf(f,'%s \n',string3);
    fprintf(f,'%s \n',string4);
    % write geometry
    i_AirfoilGeometry=Airfoils{i};
    for j=1:length(i_AirfoilGeometry(:,1))
        fprintf(f,'%10.6f %10.6f \n',i_AirfoilGeometry(j,1),i_AirfoilGeometry(j,2));
    end
    i_AirfoilGeometry=[];
    fclose(f); 
    
end
    


