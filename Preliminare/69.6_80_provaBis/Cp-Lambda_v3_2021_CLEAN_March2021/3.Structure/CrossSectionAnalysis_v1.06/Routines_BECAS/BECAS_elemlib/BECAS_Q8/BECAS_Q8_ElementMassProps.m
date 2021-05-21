function [ Ixx, Iyy, Ixy, ...
    Axx, Ayy, Axy, ...
    Area, Ax, Ay, ...
    Mass, MassX, MassY ] = BECAS_Q8_ElementMassProps( enum, utils )
%********************************************************
% File: BECAS_Q8_ElementMassProps
%   Function to determine the element mass properties:
%   mass moments of inertia, area moments, center of area, mass and
%   center of mass. Interpolation is according to Q8 element.
%
% Syntax:
%   [ Ixx, Iyy, Ixy, ...
%       Axx, Ayy, Axy, Area, Ax, Ay, ...
%       Mass, MassX, MassY ] = BECAS_Q8_ElementMassProps( enum, utils )
%
% Input:
%   enum    :  Number of element in cross section FE mesh
%   utils   :  Structure with input data, useful arrays, and
%              constants
%
% Output:
%   Ixx, Iyy, Ixy :  Element moment of inertia
%   Axx, Ayy, Axy :  Element moment of inertia
%   Area    :  Element area
%   AreaX, AreaY :  Coordinates of element area center
%   Mass    :  Element mass per unit length
%   MassX, MassY :  Coordinates of element mass center
%
% Calls:
%
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

%Initialize arrays
Ixx=0;Iyy=0;Ixy=0;
Axx=0;Ayy=0;Axy=0;Area=0;
Ax=0;Ay=0;
Mass=0;MassX=0;MassY=0;

%Number of Gauss points
gpoints=utils.gpoints;

%Start integration
for n=1:gpoints     %Iterate gauss points along the length
    for nn=1:gpoints     %Iterate Gauss points at cross section elements
        xxs = utils.GQ( n, 2, gpoints-1 );    %X position of Gauss point
        wxx = utils.GQ( n, 1, gpoints-1 );    %Weight from Gauss quadrature
        yys = utils.GQ( nn, 2, gpoints-1 );    %Y position of Gauss point
        wyy = utils.GQ( nn, 1, gpoints-1 );    %Weight from Gauss quadrature
        %Nodal coordinates of cross section element in cross section
        %coordinate system
        [ xxb, yyb ] = BECAS_Q8_InterpPos( utils.pr_2d( :, enum ), xxs, yys );
        %Evaluate Jacobian - 2D
        [ iJ, detJ ] = BECAS_Q8_Jacobian( xxs, yys, utils.pr_2d( :, enum ) );
        %Sum each contribution and multiply by Gauss weights and determinant of
        %Jacobian
        %Moments of Inertia
        Iyy = Iyy + xxb^2*utils.density(enum)*wxx*wyy*detJ;
        Ixx = Ixx + yyb^2*utils.density(enum)*wxx*wyy*detJ;
        Ixy = Ixy + xxb*yyb*utils.density(enum)*wxx*wyy*detJ;
        %Area moments
        Ayy = Ayy + xxb*wxx*wyy*detJ;
        Axx = Axx + yyb*wxx*wyy*detJ;
        Axy = Axy + xxb*yyb*wxx*wyy*detJ;
        %Total area
        Area = Area + wxx*wyy*detJ;
        %Center of area
        Ay = Ay + yyb*wxx*wyy*detJ;
        Ax = Ax + xxb*wxx*wyy*detJ;
        %Total Mass
        Mass = Mass + utils.density(enum)*wxx*wyy*detJ;
        %Mass center
        MassX = MassX + xxb*utils.density(enum)*wxx*wyy*detJ;
        MassY = MassY + yyb*utils.density(enum)*wxx*wyy*detJ;
        
    end
end

end
