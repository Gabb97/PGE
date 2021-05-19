function [fighandle] = BECAS_PlotMaterialNumber(utils, eta, secID)
%********************************************************
% File: BECAS_PlotMaterialNumbers.m
%   Function to plot material numbers at each element
%
% Syntax:
%   BECAS_PlotMaterialNumbers( utils )
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
%   Version 1.2    09.10.2012   José Pedro Blasques: Edges are now plotted
%   in the same color as the patch. Makes it easier for fine meshes.
%
% (c) DTU Wind Energy
%********************************************************

fighandle = figure;
hold on
colorbar;
colormap;
%Plot elements and color according to material number
iv=0;
vertex_connection=[1 2 3 4];
vertex_list=zeros(4,3);
for i=1:utils.ne_2d
    for ii=1:4
        iv=iv+1;
        for iii=1:2
            vertex_list(ii,iii)=utils.nl_2d(utils.mapel_2d(i,ii+1),iii+1);
            vertex_list(ii,3)=0;
        end
    end
    pa=patch('Vertices',vertex_list,'Faces',vertex_connection, 'facecolor', 'flat',  'edgecolor', 'flat', 'facealpha', 1);
    facecolor=[ utils.emat(i,2)+1 utils.emat(i,2)+1 utils.emat(i,2)+1 utils.emat(i,2)+1]';
    set(pa,'FaceVertexCData',facecolor);
end
%Figure properties
box off
hold off
axis off
axis equal
%Figure title
title('Material number');

% Window title
titletag = ['Section ' num2str(secID) ' - Eta = ' num2str(eta)];
set(gcf,'numbertitle','off','name',titletag)

end