function [fighandle] = BECAS_PlotCentersAndAxis( utils, sx, sy, mx, my, ex, ey, alpha_ea_ec , eta, secID)
%********************************************************
% File: BECAS_PlotCentersAndAxis.m
%   Function to plot cross section reference center, shear center,
%   mass center, elastic center, and elastic axes based on the
%   results from BECAS.
%
% Syntax:
%   BECAS_PlotCentersAndAxis( utils, sx, sy, mx, my, ex, ey,
%   alpha_ea_ec )
%
% Input:
%   utils   :  Structure with input data, useful arrays, and
%              constants
%   sx, sy  :  Shear center coordinates
%   mx, my  :  Mass center coordinates
%   ex, ey  :  Elastic center coordinates
%   alpha_ea_ec : Orientation of the elastic axes
%
% Output:
%   fighandle : Figure number
%
% Calls:
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%   Version 1.1    21.08.2012   Robert and José : Introduced figure handle
%   and included it as output
%
% (c) DTU Wind Energy
%********************************************************

fighandle = figure;

hold on
%Plot undeformed shape
BECAS_PlotElements( utils )
%Plot reference center
prc = plot(0,0,'sb','MarkerSize',10,'LineWidth',2);
%Plot shear center
psc = plot(sx,sy,'dg','MarkerSize',10,'LineWidth',2);
%Plot mass center
pmc = plot(mx,my,'vr','MarkerSize',10,'LineWidth',2);
%Plot elastic center
pec = plot(ex,ey,'ok','MarkerSize',10,'LineWidth',2);
%Elastic axis
DeltaX = max(utils.nl_2d(:,2)) - min(utils.nl_2d(:,2));
DeltaY = max(utils.nl_2d(:,3)) - min(utils.nl_2d(:,3));
DeltaMean = 0.5*(DeltaX+DeltaY);
P_EC = [ex; ey];
va1 = [cos(alpha_ea_ec); sin(alpha_ea_ec)];
va2 = [-sin(alpha_ea_ec); cos(alpha_ea_ec)];
P1 = P_EC+DeltaMean/2*va1; P2 = P_EC-DeltaMean/2*va1;
P3 = P_EC+DeltaMean/2*va2; P4 = P_EC-DeltaMean/2*va2;
elax1 = plot([P1(1,1) P2(1,1)],[P1(2,1),P2(2,1)],'--k');
elax2 = plot([P3(1,1) P4(1,1)],[P3(2,1),P4(2,1)],'-.k');
%Figure legend
legend([prc pec psc pmc elax1 elax2],'Reference','Elastic','Shear','Mass','Ax. 1','Ax. 2','Location','NorthOutside','Orientation','Horizontal');
legend boxoff;
%Figure settings
box off
hold off
axis equal
axis off
title('Centers and axes');

% Window title
titletag = ['Section ' num2str(secID) ' - Eta = ' num2str(eta)];
set(gcf,'numbertitle','off','name',titletag)

end
