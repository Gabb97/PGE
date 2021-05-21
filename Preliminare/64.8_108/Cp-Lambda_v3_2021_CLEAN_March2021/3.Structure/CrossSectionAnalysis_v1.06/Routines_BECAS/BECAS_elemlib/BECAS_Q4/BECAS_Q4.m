function [ Me, Ee, Ce, Re, Le, Ae ] = BECAS_Q4( enum, Qe, utils )
%********************************************************
% File: BECAS_2DQ4.m
%   Function to evaluate the 2D finite element matrices
%   using the Q4 elements (two-dimensional four node
%   elements)
%
% Syntax:
%   [ Me, Ee, Ce, Re, Le, Ae ] = BECAS_Q4( enum, Qe, utils )
% Input:
%   enum    :  Number of element in 2D FE mesh
%   Qe      :  Material consitutive matrix for element enum
%   utils   :  Structure with input data, useful arrays, and
%              constants
% Output:
%   Ae      :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
%   Re      :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
%   Le      :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
%   Me      :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
%   Ce      :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
%   Ee      :  Sub-matrix of cross section equilibrium equations
%              (see Documentation)
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
%   Version 1.1    06.09.2012   José Pedro Blasques: Moved most of the
%   matrix matrix multiplications outside the loop. Now SN, SZ and B are
%   assembled into larger matrices. The routine is about two times faster
%   this way.
%
% (c) DTU Wind Energy
%********************************************************

%Number of Gauss points
gpoints = 2;

%Initialize variables
gw=zeros(gpoints*gpoints,1);
SNa=zeros(6*gpoints*gpoints,12);
SZa=zeros(6*gpoints*gpoints,6);
Ba=zeros(6*gpoints*gpoints,12);
ng=0;

%Start integration
for n=1:gpoints     %Iterate gauss points along the length
    for nn=1:gpoints     %Iterate Gauss points at cross section elements
        xxs = utils.GQ( n, 2, gpoints-1 );    %X position of Gauss point
        wxx = utils.GQ( n, 1, gpoints-1 );    %Weight from Gauss quadrature
        yys = utils.GQ( nn, 2, gpoints-1 );    %Y position of Gauss point
        wyy = utils.GQ( nn, 1, gpoints-1 );    %Weight from Gauss quadrature
        %Nodal coordinates of cross section element in cross section
        %coordinate system
        [ xxb, yyb ] = BECAS_Q4_InterpPos( utils.pr_2d(:,enum), xxs, yys );
        %Evaluate Jacobian - 2D
        [ iJ, detJ ] = BECAS_Q4_Jacobian( xxs, yys, utils.pr_2d(:,enum) );
        %Evaluate the element matrices
        [ SN ] = BECAS_Q4_SNe( xxs, yys );
        [ SZ ] = BECAS_Q4_SZe( xxb, yyb );
        [ B ] = BECAS_Q4_Be( xxs, yys, iJ );
        % Building matrix of matrices
        ng=ng+1;
        SNa(1+(ng-1)*6:ng*6,:)=SN;
        SZa(1+(ng-1)*6:ng*6,:)=SZ;
        Ba(1+(ng-1)*6:ng*6,:)=B;
        gw(ng)=wxx*wyy*detJ;
    end
end

%Assmeble matrix of constitutive matrices multiplied by the Gauss weights
%and jacobian determinant
Qa=blkdiag(Qe*gw(1),Qe*gw(2),Qe*gw(3),Qe*gw(4));

%Obtain FE matrices
Me=(Qa*SNa)'*SNa;
Ee=Ba'*Qa*Ba;
Ce=Ba'*Qa*SNa;
Re=Ba'*Qa*SZa;
Le=SNa'*Qa*SZa;
Ae=SZa'*Qa*SZa;

end