function [fighandle] = BECAS_PlotElementResults_Individual(savefig_flag,utils,ElementResults, eta, secID, comp, tag)
%********************************************************
% File: BECAS_PlotInput.m
%   Function to plot results associated with each element, namely, strains
%   and stresses.
%
% Syntax:
%   [fighandle] = BECAS_PlotElementResults(utils,ElementResults)
%
% Input:
%   savefig_flag :  Flag to save figures (1 for saving)
%   utils   :  Structure with all inputdata and other data necessary (see
%              BECAS_utils).
%   ElementResults  :  (ne x 6) Array with strain or stress results.
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
%
% (c) DTU Wind Energy
%********************************************************

fprintf(1,'> Started plotting element results...');

%Initialize arrays
vertex_list=zeros(4,3);
facecolor=zeros(4,1);

% %Set titles
titleC={'xx','yy','xy','xz','yz','zz'};
% 
% %Vertex connection array for patches
vertex_connection=[1 2 3 4];
% 

%% ALTERNATIVE - Plot only the stress/strain component identified by 'comp' stress
    p = comp;


    figure
    hold on
    colormap;
    
    %Define colorbar limits
    caxis([(min(ElementResults(:,p))-0.1*min(ElementResults(:,p))) ...
        (max(ElementResults(:,p))+0.1*abs(max(ElementResults(:,p))))]);
    %Plot patches
    iv=0;
    for i=1:utils.ne_2d
        for ii=1:4
            iv=iv+1;
            for iii=1:2
                vertex_list(ii,iii)=utils.nl_2d(utils.mapel_2d(i,ii+1),iii+1);
                vertex_list(ii,3)=0;
            end
        end
        %Plot patches
        pa=patch('Vertices',vertex_list,...
            'Faces',vertex_connection,...
            'facecolor', 'interp',...
            'edgecolor', 'none',...
            'facealpha', 1);
        facecolor(:) = ElementResults(i,p);
        set(pa,'FaceVertexCData',facecolor);
    end
    %Graphic properties
    title([tag ' - ' titleC{comp}]);
    xlabel('x')
    ylabel('y')
    zlabel('z')
    colorbar;
    box off
    hold off
    axis equal
    axis off
    
    % Window title
    titletag = ['Section ' num2str(secID) ' - Eta = ' num2str(eta)];
    set(gcf,'numbertitle','off','name',titletag)

if (savefig_flag)
    saveas(fighandle, 'BECAS_FIG_ElementResults','fig');
end

fprintf(1,'DONE! \n');

end

