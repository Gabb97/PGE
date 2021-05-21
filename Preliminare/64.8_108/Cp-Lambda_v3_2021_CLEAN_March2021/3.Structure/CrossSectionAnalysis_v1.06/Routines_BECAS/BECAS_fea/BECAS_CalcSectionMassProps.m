function [ Mass, xm, ym, Ixx, Iyy, Ixy, Ax, Ay, Axx, Ayy, Axy, Area, MassPerMaterial ] = ...
    BECAS_CalcSectionMassProps( utils )
%********************************************************
% File: BECAS_CalcSectionMassProps.m
%   Function to assemble the 6x6 cross section mass matrix.
%
% Syntax:
%   [ Mass, xm, ym, Ixx, Iyy, Ixy ] = ...
%     BECAS_CalcSectionMassProps( utils )
%
% Input:
%   utils   :  Structure with input data, useful arrays, and
%              constants
%
% Output:
%   Mass    :  Mass per unit length or mass of cross section
%   xm, ym  :  Coordinates of mass center
%   Ixx, Iyy, Ixy :  Cross section moment of inertia
%   Axx, Ayy, Axy :  Cross section moment of inertia
%   Ax, Ay  :  Coordinates of area center
%   Area    :  Area per unit length or mass of cross section
%   MassPerMaterial  :  Mass per unit length per material
%
% Calls:
%
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%   Revision:   José and Robert - added mass per unit length per material
%
% (c) DTU Wind Energy
%********************************************************

%Calculate moments of inertia
%Initialize arrays
Ixx=0;Iyy=0;Ixy=0;
Mass=0;
xm=0;ym=0;
Axx=0;Ayy=0;Axy=0;Area=0;
Ax=0;Ay=0;
MassPerMaterial=zeros(1,max(utils.emat(:,2)));
for e=1:utils.ne_2d
    %Moments of inertia
    if(utils.etype == 1)
        [Ixxe,Iyye,Ixye,Axxe,Ayye,Axye,Areae,Axe,Aye,Masse,MassXe,MassYe]=BECAS_Q4_ElementMassProps(e,utils);
    elseif(utils.etype == 2 || utils.etype == 3)
        [Ixxe,Iyye,Ixye,Axxe,Ayye,Axye,Areae,Axe,Aye,Masse,MassXe,MassYe]=BECAS_Q8_ElementMassProps(e,utils);
    end
    Ixx=Ixx+Ixxe;
    Iyy=Iyy+Iyye;
    Ixy=Ixy+Ixye;
    %Mass center
    xm=xm+MassXe;
    ym=ym+MassYe;
    %Mass
    Mass=Mass+Masse;
    %Area moments of inertia
    Axx=Axx+Axxe;
    Ayy=Ayy+Ayye;
    Axy=Axy+Axye;
    %Total area
    Area=Area+Areae;
    %Area centers
    Ax=Ax+Axe;
    Ay=Ay+Aye;
    %Mass per material type
    MassPerMaterial(utils.emat(e,2))=MassPerMaterial(utils.emat(e,2))+Masse;
end
%Mass center
xm=xm/Mass;
ym=ym/Mass;
%Area center
Ax=Ax/Area;
Ay=Ay/Area;

end

