function [fighandle] = BECAS_PlotFEmesh( utils , eta, secID)
%********************************************************
% File: BECAS_PlotFEmesh.m
%   Function to plot fiber angles where a vertical line indicates
%   0deg.
%
% Syntax:
%   BECAS_PlotFEmesh( utils )
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
%Plot undeformed shape
BECAS_PlotElements( utils )
%Figure settings
box off
hold off
axis off
axis equal
%Figure title
title('Finite element mesh');

% Window title
titletag = ['Section ' num2str(secID) ' - Eta = ' num2str(eta)];
set(gcf,'numbertitle','off','name',titletag)


end