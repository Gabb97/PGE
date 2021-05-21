function [ ElCent ] = BECAS_ElemCenter( utils )
%********************************************************
% File: BECAS_ElemCenter.m
%   Function to determine the centroid of each element in the cross
%   section FE mesh
%
% Syntax:
%   [ ElCent ] = BECAS_ElemCenter( utils )
%
% Input:
%   utils   :  Structure with input data, useful arrays, and
%              constants
% Output:
%   ElCent  :  Array holding the element centroids
%
% Calls:
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

%Calculate centroid of cross section elements
ElCent=zeros(utils.ne_2d,2);
for i=1:utils.ne_2d
    %Element centroid
    ElCent(i,:)=0;
    for ii=1:utils.nnpe_2d
        ElCent(i,1)=ElCent(i,1)+utils.nl_2d(utils.mapel_2d(i,ii+1),2);
        ElCent(i,2)=ElCent(i,2)+utils.nl_2d(utils.mapel_2d(i,ii+1),3);
    end
    ElCent(i,:)=ElCent(i,:)/utils.nnpe_2d;
end
end
