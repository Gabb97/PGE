function Eigs = ReadEigs4Campbell(file_name,NumbParFiles,NumbEigs,SaveFlag)

% This routine reads the eigvalues from output parametric files
%
% INPUT:
% file_name     : file name (w/o extension and number)
% NumbParFiles  : number of parametric files
% NumbEigs      : max number of eigs to read
%
% OUTPUT
% Eigs          : matrix of NumbEigs X  NumbParFiles with the eigs
%
% Author: A.C.,  June 2010

%% READ
symb_list={'-r','-.b','--m',':c','-k','g'};

for ifile=1:NumbParFiles
    
    ifile
%     ifile
    f_sta = fopen(strcat(file_name,'_',num2str(ifile),'.out'),'r');
    
    % read initial -------------------------------------------
    data = fgetl(f_sta);
    while 1
        data = fgetl(f_sta);
        if strncmp(data,' Computing eigenvectors.',18);
            break;
        elseif (data<0)
            disp('END OF FILE');
            disp(strcat(file_name,'_',num2str(ifile),'.out'));
            break;
        end
    end
    
    % read: Eigenvalue [  1] = ( 1.11251e-014,i  1.52656e+000) ---------------
    nstep = 0;
    iie = 0;
    skip = 0;
    NumbEigsFin =  NumbEigs;
    for i_eig=1:NumbEigsFin
        iie = iie + 1;
        try
            aaa1 = fscanf (f_sta,'%s',[1,1]);
            aaa2 = fscanf (f_sta,'%s',[1,1]);
            aaa3 = fscanf (f_sta,'%s',[1,1]);
            aaa4 = fscanf (f_sta,'%s',[1,1]);
            aaa5 = fscanf (f_sta,'%c %c %c ',[3,1]);
            aaa6 = fscanf (f_sta,'%f',[1,1]);
            aaa7 = fscanf (f_sta,'%c %c',[2,1]);
            Eigs(iie,ifile) = fscanf (f_sta,'%g',[1,1]);
            aaa8 = fscanf (f_sta,'%s ',[1,1]);
            clear aaa*
        catch % try to remove pure real eigenvalues
            skip = skip + 1;
            NumbEigsFin = NumbEigsFin + 1;
            iie = iie - 1;
            
            disp('skip')
        end
    end
    if skip>0
        Eigs(skip:end,ifile) = Eigs(1:end-skip+1,ifile);
        Eigs(1:skip-1,ifile) = 0.*Eigs(1:skip-1,ifile);
    end
    nstep = nstep-1;
    fclose (f_sta);
end



%% PLOT all Eigs
figure('name','All Eigs')
hold on; grid on; zoom on;
hp=bar(Eigs/2/pi);
set (hp,'LineWidth',2);
hx=xlabel('Eigs Number'); hy=ylabel('Eigs Values [Hz]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
if SaveFlag
    print('-djpeg','.\Figures\AllEigs.jpg')
end
