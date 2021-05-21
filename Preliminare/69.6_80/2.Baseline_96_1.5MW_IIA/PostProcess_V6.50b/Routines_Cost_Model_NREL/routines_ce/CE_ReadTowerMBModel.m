function [TowerHeight, TowerMass]=CE_ReadTowerMBModel(TargetFolder,FileList)

%% Scan 'Tower.dat' --> (Mass per unit length - Tower)           
FileAddress=strcat(TargetFolder,'\',FileList.Tower);
f=fopen(FileAddress);
     NumberOfPoints=0;
     NumberOfBeams=0;
    %% 1) Find number of points for tower mesh 
    % Find 'Points' marker
    while ~ feof(f)
            if findstr(strtrim(fgetl(f)), 'Points :') ==1
                % Find point and scan coordinate
                while ~ feof(f)
                    if findstr(strtrim(fgetl(f)), 'Point :') ==1
                       NumberOfPoints=NumberOfPoints+1;
                        while ~ feof(f)
                                ReadString=fgetl(f);
                                if findstr(strtrim(ReadString), 'Coordinates :') ==1
                                    scanString=strread(ReadString,'%s');
                                    TowerPoints(NumberOfPoints)=str2num(scanString{3})  ;
                                    break
                                end   % if
                                
                        end           % while (coordinates)
                    end               % if
                end                   % while (point)
            end                       % if
    end                               % while (points)
    
    frewind(f);
   %% 2) Find number of beams and their lengths
    NumberOfBeams=NumberOfPoints-1;
    for i=1:NumberOfBeams
        BeamLength(i)=TowerPoints(i+1)-TowerPoints(i);
    end
   %% 3) Find mass per unit span
   TowerMass=0;
   CurrentLength=0;
   i=0;
   % identify 'NumberOfterms' marker
   while~ feof(f)
       if findstr(strtrim(fgetl(f)), 'BeamProperties :') ==1 
           while ~ feof(f)
               if findstr(strtrim(fgetl(f)), 'BeamProperty :') ==1 
                   i=i+1;
                   while ~ feof(f)
                       ReadTermString=fgetl(f);
                       if findstr(strtrim(ReadTermString), 'NumberOfTerms :') ==1                
                           ScanTermString=strread(ReadTermString,'%s');
                           i_NumberOfTerms=str2num(ScanTermString{3});
                           % Initialize j-Cycle
                           j=0;                               
                           % scan eta
                           while ~ feof(f)
                               ReadEtaString=fgetl(f);
                               if findstr(strtrim(ReadEtaString), 'EtaValue :') ==1
                                      j=j+1;
                                      ScanEtaString=strread(ReadEtaString,'%s');
                                      i_Eta(j)=str2num(ScanEtaString{3});
                                      while ~ feof(f)
                                            ReadMassString=fgetl(f);
                                            if findstr(strtrim(ReadMassString), 'MassPerUnitSpan :') ==1
                                                 ScanMassString=strread(ReadMassString,'%s');
                                                 i_MassPerUnitSpan(j)=str2num(ScanMassString{3});
                                                 break
                                             end       % if (mass)                               
                                       end    % while (eta)
                                       if j==i_NumberOfTerms
                                            break
                                       end  
                               end                              
                           end             % while (eta)
                          
                         % convert eta to absolute coordinates
                          i_RadialPos=i_Eta*BeamLength(i)+CurrentLength;
                          CurrentLength=i_RadialPos(length(i_RadialPos));
                         TowerMass=TowerMass+trapz(i_RadialPos,i_MassPerUnitSpan);
                          break
                       else
                       end % if (ciclo i)             
                   end     % while (ciclo i)
                   if i==NumberOfBeams
                            break
                       end     % if
               end         % if (beamproperty)
           end             % while (beamproperty)
       end
   end
    
TowerHeight=CurrentLength;
                    
                    
                    
                    
                    
                    
                    
                    