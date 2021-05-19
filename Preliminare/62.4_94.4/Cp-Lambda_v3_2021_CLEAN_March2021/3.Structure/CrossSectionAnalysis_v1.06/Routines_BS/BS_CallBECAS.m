function BS_CallBECAS(RadialPositions,Eta,SectionData,Parameters,Input,SectionID,ElementsMap)

SectionType = SectionData.Type;

%% Create output folder
FolderAddress=strcat('Output\Sections\Section_',num2str(SectionID));
mkdir(FolderAddress);

%% Launch BECAS
[Results.Stress,Results.Strain]=runBECAS(Parameters,Input, Eta,SectionID);

%% Move output file to correct folder
SourceFile=strcat('BECAS_2D.out');
TargetFile=strcat(FolderAddress,'\Section_',num2str(SectionID),'.out');
movefile(SourceFile,TargetFile);
TargetFile=strcat('BECAS2HAWC2.out');
delete(TargetFile);

%% Write stress/strain output file
FileAddress=strcat('Output\Sections\Section_',num2str(SectionID),'\Stress_',num2str(SectionID),'.out');
BS_WriteStress(SectionID,Results,ElementsMap,FileAddress);
BS_WriteMinMaxStress(RadialPositions,Eta,Input,SectionData,SectionID,Results,ElementsMap,FileAddress);

%% At last section, delete BECAS_Paraview folder if PlotOption is different from 3
if SectionID==Input.NumbSec
    if Input.PlotOption<3
        Check=exist('BECAS_PARAVIEW','dir');
        if Check==0
        else
            rmdir('BECAS_PARAVIEW','s');
        end
    end
end

