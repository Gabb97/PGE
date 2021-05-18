function [ strain ] = BECAS_RecoverStrains( theta0, solutions, utils )
%********************************************************
% File: BECAS_RecoverStrains
%   Function to calculate the strains at elements and Gauss points for a
%   given load (forces and moments) vector.
%
% Syntax:
%   [ strain ] = BECAS_RecoverStrains( theta0, solutions, utils )
%
% Input:
%   theta0  :  1x6 Load (forces and moments) vector
%   solutions : Structure containing the warping solutions arrays X, Y, dX
%               and dY returned by BECAS_Constitutive_Ks
%   utils   :  Structure with input data, useful arrays, and
%              constants
%
% Output:
%   strain.GlobalElement : Strains at element center in the global
%                          coordinate system.
%   strain.MaterialElement : Strains at element center in the material
%                            coordinate system.
%   strain.GlobalGauss : Strains at Gauss points in the global
%                        coordinate system.
%   strain.MaterialGauss : Strains at Gauss points in the material
%                            coordinate system.
%
% Calls:
%
% Date:
%   Version 1.0    21.09.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

fprintf(1,'> Started evaluating strains...')
%% Strains at element center
% tic
[strain.GlobalElement,strain.MaterialElement]=BECAS_CalcStrainsElementCenter(theta0,solutions,utils);
% toc

%% Strains at Gauss points
% tic
[ strain.GlobalGauss, strain.MaterialGauss ] = ...
    BECAS_CalcStrainsGaussPoints(theta0,solutions,utils);
% toc
fprintf(1,'DONE! \n');


end


