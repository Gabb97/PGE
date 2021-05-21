function [ ElArea ] = BECAS_ElemArea( utils )
%********************************************************
% File: BECAS_ElemArea.m
%   Function to determine the area of each element in the cross
%   section FE mesh
%
% Syntax:
%   [ ElArea ] = BECAS_ElemArea( utils )
%
% Input:
%   utils   :  Structure with input data, useful arrays, and
%              constants
% Output:
%   ElArea  :  Array holding the element areas
%
% Calls:
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

ElArea=zeros(utils.ne_2d,1);
if(utils.etype == 1 || utils.etype == 2)
    %Calculate area of cross section elements
    for i=1:utils.ne_2d
        
        %Noda positions
        y1=utils.nl_2d(utils.mapel_2d(i,2),2);
        z1=utils.nl_2d(utils.mapel_2d(i,2),3);
        
        y2=utils.nl_2d(utils.mapel_2d(i,3),2);
        z2=utils.nl_2d(utils.mapel_2d(i,3),3);
        
        y3=utils.nl_2d(utils.mapel_2d(i,4),2);
        z3=utils.nl_2d(utils.mapel_2d(i,4),3);
        
        y4=utils.nl_2d(utils.mapel_2d(i,5),2);
        z4=utils.nl_2d(utils.mapel_2d(i,5),3);
        
        %Length of the sides
        l1=sqrt((y1-y2)^2+(z1-z2)^2);
        l2=sqrt((y2-y3)^2+(z2-z3)^2);
        l3=sqrt((y3-y4)^2+(z3-z4)^2);
        l4=sqrt((y4-y1)^2+(z4-z1)^2);
        
        %Length of the diagonals
        ld1=sqrt((y1-y3)^2+(z1-z3)^2);
        ld2=sqrt((y2-y4)^2+(z2-z4)^2);
        
        ElArea(i)=1/4 * sqrt( 4*ld1^2*ld2^2 - (l2^2+l4^2-l1^2-l3^2)^2 );
    end
elseif(utils.etype == 3)
    for i=1:utils.ne_2d
        
        %Noda positions
        y1=utils.nl_2d(utils.mapel_2d(i,2),2);
        z1=utils.nl_2d(utils.mapel_2d(i,2),3);
        
        y2=utils.nl_2d(utils.mapel_2d(i,3),2);
        z2=utils.nl_2d(utils.mapel_2d(i,3),3);
        
        y3=utils.nl_2d(utils.mapel_2d(i,4),2);
        z3=utils.nl_2d(utils.mapel_2d(i,4),3);
        
        %Length of the sides
        l1=sqrt((y1-y2)^2+(z1-z2)^2);
        l2=sqrt((y2-y3)^2+(z2-z3)^2);
        
        %Element area
        el_thk=0.001;
        ElArea(i)=l1*el_thk+l2*el_thk;
    end
    
end



end
