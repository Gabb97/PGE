function Eigs = ReadEigsFromParametricFile(TowerFlag,SaveFlag)

% This routine reads the eigvalues from output parametric files
%
% INPUT:
% TowerFlag     : plot also tower eigs
% SaveFlag      : save plot
%
% OUTPUT
%
% Author: A.C.,  June 2017


%% Iput:
if TowerFlag
    file_name = {...
        '.\Blade\Eigs';...
        '.\Blade\EigsRotating';...
        '.\Tower\Eigs';...
        }
    legend_name = {'Blade Static','Blade Rotating','Tower'};
else
    file_name = {...
        '.\Blade\Eigs';...
        '.\Blade\EigsRotating';...
        }
    legend_name = {'Blade Static','Blade Rotating',};
end

NumbEigs  = 10;
NumbParFiles = length(file_name);


%% READ
symb_list={'-r','-.b','--m',':c','-k','g'};

for ifile=1:NumbParFiles
    
    ifile
    fprintf('\nOPENING [%s] File \n',strcat(file_name{ifile},'.out'));
    f_sta = fopen(strcat(file_name{ifile},'.out'),'r');
    
    % read initial -------------------------------------------
    data = fgetl(f_sta);
    while 1
        [data] = fgetl(f_sta);
        if (data<0)
            disp('END OF FILE');
            disp(strcat(file_name,'_',num2str(ifile),'.out'));
            break;
        elseif strncmp(data,' Computing eigenvectors.',18);
            % read: Eigenvalue [  1] = ( 1.11251e-014,i  1.52656e+000) ---------------
            for i_eig=1:NumbEigs
                aaa1 = fscanf (f_sta,'%s',[1,1]);
                aaa2 = fscanf (f_sta,'%s',[1,1]);
                aaa3 = fscanf (f_sta,'%s',[1,1]);
                aaa4 = fscanf (f_sta,'%s',[1,1]);
                aaa5 = fscanf (f_sta,'%c %c %c ',[3,1]);
                aaa6 = fscanf (f_sta,'%f',[1,1]);
                aaa7 = fscanf (f_sta,'%c %c',[2,1]);
                eee = fscanf (f_sta,'%g',[1,1]);
                Eigs(i_eig,ifile) = eee;
                aaa8 = fscanf (f_sta,'%s ',[1,1]);
                clear aaa* eee
            end
        end
    end
    
    fclose (f_sta);
end



%% PLOT all Eigs
figure('name','All Eigs')
hold on; grid on; zoom on;
hp=bar(Eigs(1:5,:)/2/pi);
set (hp,'LineWidth',2);
hx=xlabel('Eigs Number'); hy=ylabel('Eigs Values [Hz]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
legend(legend_name)
if (SaveFlag)
    print('-djpeg','.\Figures\Bladeigs.jpg')
end

