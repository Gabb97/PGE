function [fighandle] = BECAS_PlotGaussPointResults(savefig_flag,utils,GaussPointResults)
%********************************************************
% File: BECAS_PlotGaussPointResults
%   Function to plot results associated with each element, namely, strains
%   and stresses.
%
% Syntax:
%   [fighandle] = BECAS_PlotGaussPointResults(utils,GaussPointResults)
%
% Input:
%   savefig_flag :  Flag to save figures (1 for saving)
%   utils   :  Structure with all inputdata and other data necessary (see
%              BECAS_utils).
%   GaussPointResults  :  (ne x ngpoint) Array with strain or stress
%   results at each Gauss point.
%
% Output:
%   fighandle : Figure handle   
%
% Calls:
%
% Revisions:
%   Version 1.0    28.09.2012   José Pedro Blasques
%   Version 1.1    01.10.2012   José Pedro Blasques: Introduced the
%   savefig_flag.
%   Version 1.2    10.10.2012   José Pedro Blasques: Made it work with Q8R
%
% (c) DTU Wind Energy
%********************************************************

fprintf(1,'> Started plotting Gauss point results...');

%Figure handle
fighandle = figure;

%% Initialize arrays
facecolor=zeros(utils.nnpe_2d,1);
vertex_list=zeros(utils.nnpe_2d,3);

%% Titles
titleC={'xx','yy','xy','xz','yz','zz'};

%% Patch connectivity and Gauss point order
%Order of the patch corners with respect to gauss points
if(utils.etype==1)
    %Q4
    gpointsOrder=[1 3 4 2];
    vertex_connection=[1 2 3 4];
    nvpe=4;
elseif(utils.etype==2)
    %Q8
    gpointsOrder=[1 7 9 3 4 8 6 2]; %According to vertex_list
    vertex_connection=[1 5 2 6 3 7 4 8];
    nvpe=8;
elseif(utils.etype==3)
    %Q8R
    gpointsOrder=[1 3 4 2]; %According to vertex_list
    vertex_connection=[1 2 3 4];
    nvpe=4;
end

%% Looping stress components
for p=1:6
    subplot(2,3,p)
    hold on
    colormap;
    %Define color bar limits
    caxis([min(min(GaussPointResults(:,p:6:end))) ...
        max(max(GaussPointResults(:,p:6:end)))]);
    %% Plotting stress/strain components
    for i=1:utils.ne_2d
        for ii=1:nvpe
            for iii=1:2
                vertex_list(ii,iii)=utils.nl_2d(utils.mapel_2d(i,ii+1),iii+1);
                vertex_list(ii,3)=0;
            end
            %Plot face colors depending on the stress magnitude
            facecolor(ii)=GaussPointResults(i,p+(gpointsOrder(ii)-1)*6);
        end
        %Plot patches
        pa=patch('Vertices',vertex_list,...
            'Faces',vertex_connection,...
            'facecolor', 'interp',...
            'edgecolor', 'none',...
            'facealpha', 1);
        set(pa,'FaceVertexCData',facecolor);
    end
    %% Plotting details
    title(titleC{p});
    %Axis labels
    xlabel('x')
    ylabel('y')
    zlabel('z')
    colorbar;
    box off
    hold off
    axis equal
    axis off
end

if (savefig_flag)
    saveas(fighandle, 'BECAS_FIG_GaussPointResults','fig');
end

fprintf(1,'DONE! \n');

end