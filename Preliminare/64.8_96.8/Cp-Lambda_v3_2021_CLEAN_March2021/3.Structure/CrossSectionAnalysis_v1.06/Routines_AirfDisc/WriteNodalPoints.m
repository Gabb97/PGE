function WriteNodalPoints(NodesX,NodesY,NodesID,NodesKP,WebNodesID,SectionID)

PivotAirfoilFile=strcat('Airfoil2BECAS\PivotAirfoil_',num2str(SectionID),'.dat');
ff=fopen(PivotAirfoilFile,'w');

for i=1:length(NodesX)
    if (NodesKP(i)==1)
        string1=',';
        fprintf(ff,'%-15.12f %-1s %-15.12f %-1s %-5s \n',NodesX(i),string1, NodesY(i), string1,'KP');
    else
        string1=',';
        fprintf(ff,'%-15.12f  %-1s %-15.12f \n',NodesX(i),string1, NodesY(i));
    end
end
fclose(ff);
