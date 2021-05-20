function [MaterialProperties]=ReadMaterialProp( MaterialFile)

FileAddress=strcat('Materials\',MaterialFile)

fm=fopen(FileAddress);

for i=1:6
    fgetl(fm);
end

for k=1:16
    MaterialProperties(k)=fscanf(fm,'%f \n'); fgetl(fm);
end

fclose(fm);