function [BladeMass]=CE_ReadBladeMBModel(TargetFolder,FileList, BladeLength)

BladeMass=0;
CurrentLength=0;

%% 1) Scan 'Blade_1.dat'
%  Find coordinates of the points, so that the length of each beam element could be computed.
FileAddress=strcat(TargetFolder,'\',FileList.Blade);
f=fopen(FileAddress);   
    % find number of points and scan local coordinates
    NumberOfPoints=0;
        while ~ feof(f)
            if findstr(strtrim(fgetl(f)), 'Point :') ==1
                NumberOfPoints=NumberOfPoints+1;
                fgetl(f);
                fscanf(f,'%[Coordinates : ]');
               PointRadialPos(NumberOfPoints)=fscanf(f,'%f \n');
            else
            end
        end
    frewind(f); 
    % find number of Beam Elements
    NumberOfBeams=0;
    while ~ feof(f)
        if findstr(strtrim(fgetl(f)), 'Beams :') ==1
            while ~ feof(f)
                if findstr(strtrim(fgetl(f)), 'Beam :') ==1
                    NumberOfBeams=NumberOfBeams+1;
                else
                end
            end
        end
    end
    frewind(f);
    PointRadialPos=reshape(PointRadialPos,2,NumberOfBeams);
    % calculate individual beam length for each beam element.
    for i=1:NumberOfBeams
        BeamLength(i)=PointRadialPos(2,i)-PointRadialPos(1,i);
    end
fclose(f);
%% 2) Scan 'BladeProperties.dat' and acquire mass per unit length
FileAddress=strcat(TargetFolder,'\',FileList.BladeProp);
f=fopen(FileAddress);
    % find BeamProeperty marker
    i=0;
    while ~ feof(f)
            if findstr(strtrim(fgetl(f)), 'BeamProperty :') ==1
                % Initialize "i" cycle
                i=i+1;
                fgetl(f);
                fscanf(f,'%[NumberOfTerms : ]');
                % Read number of terms for the i-th beam element
                i_NumberOfTerms=fscanf(f,'%d '); fgetl(f);
                % Read Eta and Mass p.u.s for the i-th beam element
                j=0;
                while ~ feof(f)
                    ReadString=fgetl(f);
                    if findstr(strtrim(ReadString), 'EtaValue :') ==1
                        % Initialize "j" cycle
                        j=j+1;
                        scanstring=strread(ReadString,'%s');
                        i_EtaValue(j)=str2num(scanstring{3});
                         while ~ feof(f)
                            ReadMassString=fgetl(f);
                            if findstr(strtrim(ReadMassString), 'MassPerUnitSpan :') ==1
                                scanMassString=strread(ReadMassString,'%s');
                                i_MassPerUnitSpan(j)=str2num(scanMassString{3});  
                                break
                            end % if (mass)
                         end    % while (mass)
                    end              
                    if j==i_NumberOfTerms
                            break
                    end     % if
                end         % while (ciclo j)

                % Convert eta to absolute coordinate, update markers and
                % update blade mass
                i_RadialPos=i_EtaValue*BeamLength(i)+CurrentLength;
                CurrentLength=i_RadialPos(length(i_RadialPos));
                BladeMass=BladeMass+trapz(i_RadialPos,i_MassPerUnitSpan); 
                % reset arrays
                i_EtaValue=[];
                i_MassPerUnitSpan=[];
                i_RadialPos=[];
                
            else
            end     % if
            if i==NumberOfBeams
                break
            end     % if
    end             % while (ciclo i)
fclose(f);
    