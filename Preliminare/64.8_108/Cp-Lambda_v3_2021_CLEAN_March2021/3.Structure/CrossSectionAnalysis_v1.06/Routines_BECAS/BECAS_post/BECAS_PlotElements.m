function BECAS_PlotElements( utils )
%********************************************************
% File: BECAS_PlotElements.m
%   Function to plot the cross section finite element mesh
%
% Syntax:
%   BECAS_PlotElements( utils )
%
% Input:
%   utils   :  Structure with input data, useful arrays, and
%              constants
%
% Output:
%   Matlab figure
%
% Calls:
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%   Version 1.1    21.08.2012   José and Robert : Plotting all nodes
%   (including the midside)
%
% (c) DTU Wind Energy
%********************************************************

% Element type
if(utils.etype==1)
    vertex_connection=[1 2 3 4];
elseif(utils.etype==2  || utils.etype==3)
    vertex_connection=[1 5 2 6 3 7 4 8];
end

%Start looping elements
iv=0;
vertex_list=zeros(utils.nnpe_2d,3);
for i=1:utils.ne_2d
    for ii=1:utils.nnpe_2d
        iv=iv+1;
        for iii=1:2
            vertex_list(ii,iii)=utils.nl_2d(utils.mapel_2d(i,ii+1),iii+1);
        end
        vertex_list(ii,3)=0;
    end
    patch('Vertices',vertex_list,'Faces',vertex_connection,...
        'FaceColor',[1 1 1],'EdgeColor',[0. 0. 0.],'FaceAlpha', 0);
end

end