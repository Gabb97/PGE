function [fighandle] = BECAS_PlotFiberPlane( utils )
%********************************************************
% File: BECAS_PlotFiberPlane.m
%   Function to plot fiber planes angles where an horizontal line
%   indicates an horizontal laminate stacking plane
%
% Syntax:
%   BECAS_PlotFiberPlane( utils )
%
% Input:
%   utils   :  Structure with input data, useful arrays, and
%              constants
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
%   Version 1.2    11.09.2012   Robert and José : Plotting fiber plane and
%   normals with different colors. Included a more explanatory legend.
%   
%
% (c) DTU Wind Energy
%********************************************************
fighandle = figure;
%Line length
a_length=0.6*sqrt(max(utils.ElArea));
hold on
%Plot elements
BECAS_PlotElements( utils )
%Plot fiber orientations
for i=1:utils.ne_2d
    rmat=[cosd(utils.emat(i,4))  -sind(utils.emat(i,4)) ;
        sind(utils.emat(i,4))   cosd(utils.emat(i,4)) ];
    %Fiber plane
    v_dir=rmat*[1;0]*a_length;
    h1=plot([utils.ElCent(i,1) utils.ElCent(i,1)+v_dir(1)/2],[utils.ElCent(i,2) utils.ElCent(i,2)+v_dir(2)/2],'r','LineWidth',1.6);
    %Normal or axis of rotation of the fiber angle
    v_dir=rmat*[0;1]*a_length;
    h2=plot([utils.ElCent(i,1) utils.ElCent(i,1)+v_dir(1)/2],[utils.ElCent(i,2) utils.ElCent(i,2)+v_dir(2)/2],'b','LineWidth',1.6);
end
%Figure properties
box off
hold off
axis off
axis equal
%Figure title
title('Fiber plane orientation');
l1=legend([h1,h2],'Fiber plane orientation','Fiber plane normal');
set(l1,'Box','off');
set(l1,'Location','EastOutside');
legend('boxoff')
end
