function [fighandle] = BECAS_PlotElementNumbers( utils )
%********************************************************
% File: BECAS_PlotElementNumbers.m
%   Function to plot element numbers
%
% Syntax:
%   BECAS_PlotElementNumbers( utils )
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
hold on
%Plot elements
BECAS_PlotElements( utils );
%Plot element numbers
for i=1:utils.ne_2d
    text(utils.ElCent(i,1),utils.ElCent(i,2),num2str(utils.emat(i,1)));
end
%Figure properties
box off
hold off
axis off
axis equal
%Figure title
title('Element number');

end