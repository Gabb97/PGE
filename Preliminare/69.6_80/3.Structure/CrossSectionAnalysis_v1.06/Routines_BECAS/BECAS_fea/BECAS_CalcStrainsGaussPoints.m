function [ GlobalGauss, MaterialGauss ] = ...
    BECAS_CalcStrainsGaussPoints(theta0,solutions,utils)
%********************************************************
% File: BECAS_CalcStrainsGaussPoints
%   Function to calculate the strains at Gauss points for a given load 
%   (forces and moments) vector.
%
% Syntax:
%   [ GlobalGauss, MaterialGauss ] = ...
%    BECAS_CalcStrainsGaussPoints(theta0,solutions,utils)
%
% Input:
%   theta0  :  1x6 Load (forces and moments) vector
%   solutions : Structure containing the warping solutions arrays X, Y, dX
%               and dY returned by BECAS_Constitutive_Ks
%   utils   :  Structure with input data, useful arrays, and
%              constants
%
% Output:
%   strain.GlobalGauss : (ne,(6*GaussPoints)) array of strains at Gauss 
%                        points in the global coordinate system.
%   strain.MaterialGauss : (ne,(6*GaussPoints)) array of strains Gauss 
%                          points in the material coordinate system.
%
% Order of Gauss points
% Q4
% -----------
% | 2     4 |
% |         |
% | 1     3 |
% -----------
% Q8
% -----------
% | 3  6  9 |
% | 2  5  8 |
% | 1  4  7 |
% -----------
%
% Calls:
%
% Date:
%   Version 1.0    21.09.2012   José Pedro Blasques
%   Version 1.1    01.10.2012   José Pedro Blasques: corrected a bug
%   related to the way the strains in the local coordinate system were
%   being reordered to match the local coordinate system.
%
% (c) DTU Wind Energy
%********************************************************

%% Initialize variables
%Set number of Gauss points
gpoints=utils.gpoints;
%Nodal strains
GlobalGauss=zeros(utils.ne_2d,6*gpoints^2);
MaterialGauss=zeros(utils.ne_2d,6*gpoints^2);
%Element dof mapping
edof_2d=zeros(utils.mdim_2d,1);

%Pre multiply the warping by the load vector
Xtheta=full(solutions.X*theta0');
dXtheta=full(solutions.dX*theta0');
Ytheta=full(solutions.Y*theta0');

%% Evaluate nodal strains
for e=1:utils.ne_2d
    %% Assemble edof mapping array
    for i=1:utils.nnpe_2d
        for j=1:utils.mdim_2d/utils.nnpe_2d
            edof_2d(utils.mdim_2d/utils.nnpe_2d*(i-1)+j) = utils.mdim_2d /utils.nnpe_2d * (utils.mapel_2d(e,i+1)-1)+j;
        end
    end
    %% Build rotation matrices
    %Fiber and fiber plane rotation matrices
    [ f_rot ] = BECAS_FiberRotationMatrix( utils.emat(e,3) );
    [ p_rot ] = BECAS_FiberPlaneRotationMatrix( utils.emat(e,4) );
    
    %% Loop gauss points
    v=0;
    for i=1:gpoints
        for iv=1:gpoints
            v=v+1;
            xxs=utils.GQ(i,2,gpoints-1);
            yys=utils.GQ(iv,2,gpoints-1);
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
            
            %% Strains in global coordinate system
            GlobalGauss(e,1+(v-1)*6:6+(v-1)*6)=SZe*Ytheta+Be*Xtheta(edof_2d)+SNe*dXtheta(edof_2d);
            
            %% Strains in local coordinate system
            % Rotate strains
            StrainMat=horzcat(...
                [ GlobalGauss(e,1+(v-1)*6); GlobalGauss(e,3+(v-1)*6); GlobalGauss(e,4+(v-1)*6) ],...
                [ GlobalGauss(e,3+(v-1)*6); GlobalGauss(e,2+(v-1)*6); GlobalGauss(e,5+(v-1)*6) ],...
                [ GlobalGauss(e,4+(v-1)*6); GlobalGauss(e,5+(v-1)*6); GlobalGauss(e,6+(v-1)*6) ]);
            StrainMat=p_rot*StrainMat*p_rot';
            StrainMat=f_rot*StrainMat*f_rot';
            %Strains in local coordinate system
            MaterialGauss(e,1+(v-1)*6:6+(v-1)*6)=...
                [ StrainMat(1,1) StrainMat(2,2) StrainMat(1,2)...
                  StrainMat(1,3) StrainMat(2,3) StrainMat(3,3)]';
              
        end
    end
end

%Reorder to match material coordinate system
edof=[2 6 5 3 4 1];
gmmap=[];
for i=1:gpoints^2
   gmmap=[gmmap edof+(i-1)*6]; 
end
MaterialGauss(:,gmmap)=MaterialGauss;

end
