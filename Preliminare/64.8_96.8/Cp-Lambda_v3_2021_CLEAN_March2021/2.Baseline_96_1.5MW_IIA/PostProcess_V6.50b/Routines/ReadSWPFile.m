function [Parameters]=ReadSWPFile(Parameters,iDLC)
% Reads & stores the contents of the SWP file (control output)


%% READ FILE SWP
FileNameSwp = strcat(Parameters.DLC.Run{iDLC},'.swp');
fprintf('\n>>>>>>>>>>>>>> READING FILE %s\n',FileNameSwp);
f_sta = fopen(FileNameSwp,'r');
Symb = '-r';

if f_sta<0
    fprintf('\n>>>>>>>>>>>>>> FILE %s NOT FOUND!!\n',FileNameSwp);
    Parameters.SWP{iDLC} = [];
    return
end

MAXSTEP = 1.0e9;
swp_nstep = 0;
while 1
    swp_nstep = swp_nstep + 1;
    [data,count] = fscanf (f_sta,'%i %g %g',[3,1]);
    if (count==0 || swp_nstep>MAXSTEP)
        break;
    end
    SWP.Time(swp_nstep) = data(2);
    MaxNb = data(3);
    
    for j=1:MaxNb
        SWP.array(swp_nstep,j) = fscanf (f_sta,'%g',[1,1]);
    end
end
fclose (f_sta);


Parameters.SWP{iDLC} = SWP;
save(strcat(Parameters.DLC.Run{iDLC},'_SWP.mat'),'SWP');
