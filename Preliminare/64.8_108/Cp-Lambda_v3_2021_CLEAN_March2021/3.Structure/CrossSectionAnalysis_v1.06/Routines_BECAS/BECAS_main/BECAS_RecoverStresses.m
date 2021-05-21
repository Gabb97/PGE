function [ stress ] = BECAS_RecoverStresses( strain, utils )
%********************************************************
% File: BECAS_RecoverStresses
%   Function to calculate the stresses at elements and Gauss points for
%   given strain results.
%
% Syntax:
%   [ stress ] = BECAS_RecoverStrains( strain, utils )
%
% Input:
%   strain : Structure with strain values calculated at element centers and
%            Gauss points as given by BECAS_RecoverStrains.
%   utils  : Structure with input data, useful arrays, and constants.
%
% Output:
%   stress.GlobalElement : Stresses at element center in the global
%                          coordinate system.
%   stress.MaterialElement : Stresses at element center in the material
%                            coordinate system.
%   stress.GlobalGauss : Stresses at Gauss points in the global
%                        coordinate system.
%   stress.MaterialGauss : Stresses at Gauss points in the material
%                          coordinate system.
%
% Calls:
%
% Date:
%   Version 1.0    21.09.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

fprintf(1,'> Started evaluating stresses...')
%Stress at element center
% tic
[ stress.GlobalElement, stress.MaterialElement ] = BECAS_CalcStressesElementCenter( strain, utils );
% toc

%Stress at Gauss points
% tic
[ stress.GlobalGauss, stress.MaterialGauss ] = BECAS_CalcStressesGaussPoints( strain, utils );
% toc
fprintf(1,'DONE! \n');


end