function [GlobalElement,MaterialElement]=BECAS_CalcStrainsElementCenter(theta0,solutions,utils)
%********************************************************
% File: BECAS_CalcStrainsElementCenter
%   Function to calculate the strains at element centers for a given load 
%   (forces and moments) vector.
%
% Syntax:
%   [GlobalElement,MaterialElement]=
%    BECAS_CalcStrainsElementCenter(theta0,solutions,utils)
%
% Input:
%   theta0  :  1x6 Load (forces and moments) vector
%   solutions : Structure containing the warping solutions arrays X, Y, dX
%               and dY returned by BECAS_Constitutive_Ks
%   utils   :  Structure with input data, useful arrays, and
%              constants
%
% Output:
%   GlobalElement : (neX6) array of strains at element center in the global
%                    coordinate system.
%   MaterialElement : (nex6) array of strains at element center in the 
%                      material coordinate system.
%
% Calls:
%
% Date:
%   Version 1.0    21.09.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

%% Initialize arrays
%Element strains
GlobalElement=zeros(utils.ne_2d,6);
MaterialElement=zeros(utils.ne_2d,6);
%Gauss point position
xxs=0;
yys=0;
%Element dof
edof_2d=zeros(utils.mdim_2d,1);

%Pre multiply the warping by the load vector
Xtheta=full(solutions.X*theta0');
dXtheta=full(solutions.dX*theta0');
Ytheta=full(solutions.Y*theta0');

%Looping elements
for e=1:utils.ne_2d
    %% Calculate element matrices for strain calculation at:
    if(utils.etype == 1)
        [ xxb, yyb ] = BECAS_Q4_InterpPos( utils.pr_2d(:,e), xxs, yys );
        %Evaluate Jacobian - 2D
        [ iJ, detJ ] = BECAS_Q4_Jacobian( xxs, yys, utils.pr_2d(:,e) );
        %Evaluate the element matrices
        [ SNe ] = BECAS_Q4_SNe( xxs, yys );
        [ SZe ] = BECAS_Q4_SZe( xxb, yyb );
        [ Be ] = BECAS_Q4_Be( xxs, yys, iJ );
    elseif(utils.etype == 2 || utils.etype == 3)
        %Nodal coordinates of cross section element in cross section
        %coordinate system
        [ xxb, yyb ] = BECAS_Q8_InterpPos( utils.pr_2d(:,e), xxs, yys );
        %Evaluate Jacobian - 2D
        [ iJ, detJ ] = BECAS_Q8_Jacobian( xxs, yys, utils.pr_2d(:,e) );
        %Evaluate the element stiffness matrices
        [ SNe ] = BECAS_Q8_SNe( xxs, yys );
        [ SZe ] = BECAS_Q8_SZe( xxb, yyb );
        [ Be ] = BECAS_Q8_Be( xxs, yys, iJ );        
    end
    
    %% Assemble edof mapping array
    for i=1:utils.nnpe_2d
        for j=1:utils.mdim_2d/utils.nnpe_2d
            edof_2d(utils.mdim_2d/utils.nnpe_2d*(i-1)+j) = utils.mdim_2d /utils.nnpe_2d * (utils.mapel_2d(e,i+1)-1)+j;
        end
    end
    
    %% Strains in global coordinate system
    GlobalElement(e,:) = SZe*Ytheta + ...
        (Be*Xtheta(edof_2d))+ ...
        (SNe*dXtheta(edof_2d)) ;

    %% Build rotation matrices
    %Fiber and fiber plane rotation matrices
    [ f_rot ] = BECAS_FiberRotationMatrix( utils.emat(e,3) );
    [ p_rot ] = BECAS_FiberPlaneRotationMatrix( utils.emat(e,4) );
    
    %% Rotate strains to material coordinate system
    StrainMat_global=[...
        GlobalElement(e,1) GlobalElement(e,3) GlobalElement(e,4);
        GlobalElement(e,3) GlobalElement(e,2) GlobalElement(e,5);
        GlobalElement(e,4) GlobalElement(e,5) GlobalElement(e,6)];
    StrainMat_material=p_rot*StrainMat_global*p_rot';
    StrainMat_material=f_rot*StrainMat_material*f_rot';
    
    %% Strains in material coordinate system
    MaterialElement(e,:)=[...
        StrainMat_material(1,1) StrainMat_material(2,2) StrainMat_material(1,2)...
        StrainMat_material(1,3) StrainMat_material(2,3) StrainMat_material(3,3)]';
    
end

%Reorder to match material coordinate system
edof=[2 6 5 3 4 1];
MaterialElement(:,edof)=MaterialElement;


end
