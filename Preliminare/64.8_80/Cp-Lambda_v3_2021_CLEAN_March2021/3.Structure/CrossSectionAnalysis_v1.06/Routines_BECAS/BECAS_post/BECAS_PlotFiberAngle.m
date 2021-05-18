function [fighandle] = BECAS_PlotFiberAngle(utils)
%********************************************************
% File: BECAS_PlotFiberAngle.m
%   Function to plot fiber angles where a vertical line indicates
%   0deg.
%
% Syntax:
%   BECAS_PlotFiberAngle( utils )
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
%
% (c) DTU Wind Energy
%********************************************************

fighandle = figure;
%Line length
a_length=0.6*sqrt(max(utils.ElArea));
hold on
%Plot undeformed shape
BECAS_PlotElements( utils )
%Plot fiber orientations
for i=1:utils.ne_2d
    %Fiber orientation
    v_dir=[cosd(utils.emat(i,3))  -sind(utils.emat(i,3)); sind(utils.emat(i,3))   cosd(utils.emat(i,3))]*[0;1]*a_length;
    plot([utils.ElCent(i,1) utils.ElCent(i,1)+v_dir(1)/2],[utils.ElCent(i,2) utils.ElCent(i,2)+v_dir(2)/2],'r','LineWidth',1.6);
end
%Figure properties
box off
hold off
axis off
axis equal
%Figure title
title('Fiber angle (vertical line for 0 degrees)');

end
