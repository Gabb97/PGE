function [Eigs] = ComputeCampbell(Omega_vector,SaveFlag)

% This routine reads the eigvalues from output parametric files
%
% INPUT:
%
% OUTPUT
% i_tot
%
% Author: A.C.,  June 2017


%% User parameters
FileName = '.\Campbell\Output_pitch0';
Omega_vector = Omega_vector*pi/30;      % rad/sec - Rotor Speed values
SelectedEigs = [2:1:14] ;           % selection of the plotted eigs
symb = '-';

%% Other parameters
NumbParFiles = length(Omega_vector);
NumbEigs     = 30;

%% READ EIGS
Eigs = ReadEigs4Campbell(FileName,NumbParFiles,NumbEigs,SaveFlag);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  CAMPBELL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(777)
hold on; grid on; zoom on;
hp=plot(Omega_vector*30/pi,Eigs(SelectedEigs,:)/2/pi,symb);
set (hp,'LineWidth',2);
hp=plot([Omega_vector(1) Omega_vector(end)]*30/pi,[Omega_vector(1) Omega_vector(end)]/2/pi);
set (hp,'LineWidth',1,'LineStyle','--','Color','Black');
hp=plot([Omega_vector(1) Omega_vector(end)]*30/pi,[Omega_vector(1) Omega_vector(end)]/2/pi*2);
set (hp,'LineWidth',1,'LineStyle','--','Color','Black');
hp=plot([Omega_vector(1) Omega_vector(end)]*30/pi,[Omega_vector(1) Omega_vector(end)]/2/pi*3);
set (hp,'LineWidth',1,'LineStyle','--','Color','Black');
hp=plot([Omega_vector(1) Omega_vector(end)]*30/pi,[Omega_vector(1) Omega_vector(end)]/2/pi*4);
set (hp,'LineWidth',1,'LineStyle',':','Color','Black');
hp=plot([Omega_vector(1) Omega_vector(end)]*30/pi,[Omega_vector(1) Omega_vector(end)]/2/pi*5);
set (hp,'LineWidth',1,'LineStyle',':','Color','Black');
hp=plot([Omega_vector(1) Omega_vector(end)]*30/pi,[Omega_vector(1) Omega_vector(end)]/2/pi*6);
set (hp,'LineWidth',1,'LineStyle',':','Color','Black');
hp=plot([Omega_vector(1) Omega_vector(end)]*30/pi,[Omega_vector(1) Omega_vector(end)]/2/pi*7);
set (hp,'LineWidth',1,'LineStyle','-.','Color','Black');
hp=plot([Omega_vector(1) Omega_vector(end)]*30/pi,[Omega_vector(1) Omega_vector(end)]/2/pi*8);
set (hp,'LineWidth',1,'LineStyle','-.','Color','Black');
hp=plot([Omega_vector(1) Omega_vector(end)]*30/pi,[Omega_vector(1) Omega_vector(end)]/2/pi*9);
set (hp,'LineWidth',1,'LineStyle','-.','Color','Black');
hp=plot([Omega_vector(1) Omega_vector(end)]*30/pi,[Omega_vector(1) Omega_vector(end)]/2/pi*10);
set (hp,'LineWidth',1,'LineStyle','-.','Color','Black');
hp=plot([Omega_vector(1) Omega_vector(end)]*30/pi,[Omega_vector(1) Omega_vector(end)]/2/pi*11);
set (hp,'LineWidth',1,'LineStyle','-.','Color','Black');
hp=plot([Omega_vector(1) Omega_vector(end)]*30/pi,[Omega_vector(1) Omega_vector(end)]/2/pi*12);
set (hp,'LineWidth',1,'LineStyle','-.','Color','Black');
hx=xlabel('\Omega [rpm]'); hy=ylabel('f [Hz]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');

if (SaveFlag)
    print('-depsc2','.\Figures\Campbell.eps');print('-djpeg100','.\Figures\Campbell.jpg');
end
%% Optional text
Or = Omega_vector(end)*30/pi;
for ii=1:12
    x=Or+0.1;
    y=Or/60*ii;
    t=sprintf('%iP',ii);
    text(x,y,t)
end
% return
% 
% tt = {...
%     'Tower FA & SS';
%     'Rotor out-of-plane';
%     'Rotor in-plane';
%     'Rotor out-of-plane';
%     'Tower FA & SS';
%     'Rotor in-plane';
%     }
% 
% x = Omega_vector(1)*30/pi + 0.1;
% 
% text(x,Eigs(2,1)/2/pi+0.1,tt{1})
% text(x,Eigs(4,1)/2/pi+0.1,tt{2})
% text(x,Eigs(7,1)/2/pi+0.1,tt{3})
% text(x,Eigs(9,1)/2/pi+0.1,tt{4})
% text(x,Eigs(12,1)/2/pi+0.1,tt{5})
% text(x,Eigs(14,1)/2/pi+0.1,tt{6})
% 
% print('-depsc2','.\Figures\CampbellWithText.eps');print('-djpeg100','.\Figures\CampbellWithText.jpg');

