function [fore_aft_displ]=ReadAndSaveParametricResults(Parameters)

NFile = length(Parameters.ForceVector);

for i_par =1:NFile
    nome_file = strcat('./OutputCpLambda/StaticSimulationOutput_',num2str(i_par),'.mdt');
    f_sta = fopen(nome_file,'r');
    
    if (f_sta<0)
        fprintf('ERROR: unable to open %s file!',nome_file);
        fore_aft_displ = [];
        return
    end
        % read header -------------------------------------------
    dummy = fgetl(f_sta);
    while 1
        dummy = fgetl(f_sta);
        if strcmp(dummy,'****************************');
            break;
        end
    end
    
    % read std mdt --------------------------------------------

    nstep = 0;
    while 1
        nstep = nstep + 1;
        [data,count] = fscanf (f_sta,'%i %g',[2,1]);
        if (count==0)
            break;
        end
        time(nstep) = data(2);
        
        % root
        
        % 1
        aa = fscanf (f_sta,'%g %g %g %g %g %g',[6,1]);
        fore_aft_displ_local(nstep) = aa(2);
    end
    
    nstep = nstep-1;
    fclose (f_sta);
    
    fore_aft_displ(i_par) = fore_aft_displ_local(end);
    
end
