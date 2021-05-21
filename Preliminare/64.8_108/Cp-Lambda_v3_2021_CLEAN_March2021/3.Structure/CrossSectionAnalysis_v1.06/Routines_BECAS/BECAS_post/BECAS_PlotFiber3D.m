function [fighandle] = BECAS_PlotFiber3D( utils )
%********************************************************
% File: BECAS_PlotFiber3D.m
%   Function to plot fiber angles in 3D
%
% Syntax:
%   BECAS_PlotFiber3D( utils )
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
% (c) DTU Wind Energy
%********************************************************

fighandle = figure;

hold on
%Line length
a_length=1*sqrt(max(utils.ElArea));
%Plot undeformed shape
iv=0;
for i=1:utils.ne_2d
    for ii=1:4
        iv=iv+1;
        for iii=1:2
            vertex_list(ii,iii)=utils.nl_2d(utils.mapel_2d(i,ii+1),iii+1);
            vertex_list(ii,3)=0;
        end
    end
    vertex_connection=[1 2 3 4];
    patch('Vertices',vertex_list,'Faces',vertex_connection,...
        'FaceColor',[1 1 1],'EdgeColor',[0. 0. 0.],'FaceAlpha', 0);
    rmat1=[cosd(utils.emat(i,4))  -sind(utils.emat(i,4)) 0;
        sind(utils.emat(i,4))   cosd(utils.emat(i,4)) 0;
        0 0 1];
    rmat2=[cosd(utils.emat(i,3))  0 sind(utils.emat(i,3));
        0 1 0;
        -sind(utils.emat(i,3))  0 cosd(utils.emat(i,3))];
    v_dir=rmat1*rmat2*[0;0;1]*a_length;
    h1=plot3([utils.ElCent(i,1) utils.ElCent(i,1)+v_dir(1)/2],[utils.ElCent(i,2) utils.ElCent(i,2)+v_dir(2)/2],[0 v_dir(3)/2],'r','LineWidth',1.6);
    v_dir=rmat1*rmat2*[1;0;0]*a_length;
    h2=plot3([utils.ElCent(i,1) utils.ElCent(i,1)+v_dir(1)/2],[utils.ElCent(i,2) utils.ElCent(i,2)+v_dir(2)/2],[0 v_dir(3)/2],'b','LineWidth',1.6);
    v_dir=rmat1*rmat2*[0;1;0]*a_length;
    h3=plot3([utils.ElCent(i,1) utils.ElCent(i,1)+v_dir(1)/2],[utils.ElCent(i,2) utils.ElCent(i,2)+v_dir(2)/2],[0 v_dir(3)/2],'g','LineWidth',1.6);
end
%Figure properties
box off
hold off
axis off
xlabel('x');
ylabel('y');
zlabel('z');
axis equal
axis vis3d
%Figure title
title('Material orientation')
l1=legend([h1,h2,h3],'1','2','3');
set(l1,'Box','off');
set(l1,'Location','EastOutside');
legend('boxoff')
end