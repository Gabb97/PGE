function [ Qm, Sm ] = BECAS_ElementMaterialConsitutiveMatrix( utils, e )
%********************************************************
% File: BECAS_ElementMaterialConstMatrix.m
%   Function to determine the material constitutive matrix at each
%   element of the cross section FE mesh in the material coordinate system.
%   Using formulas from "Elasticity", Martin H. Sadd
%   NOTE: Output ordered according to indices for matrices in book:
%   11 22 33 23 31 12
%   Needs to be transformed to BECAS ordering
%
% Syntax:
%   [ Qm, Sm ] = BECAS_RotateElementMaterialConstMatrix( utils, e )
%
% Input:
%   utils   :  Structure with input data, useful arrays, and
%              constants
%   e       :  Element number
%
% Output:
%   Qm : Material constitutive stiffness matrix for each element in the 
%        cross section FE mesh
%   Sm : Material constitutive compliance matrix for each element in the 
%        cross section FE mesh
%
% Calls:
%
% Revisions:
%   Version 1.0    14.09.2012   José Pedro Blasques
%   Version 2.0    20.09.2012   José Pedro Blasques and Robert Bitsche:
%   Fixed a very important bug in the definition of the material
%   constitutive matrix, namely, the 2 and 3 directions were interchanged.
%   The bug was identified after some results from Wind Power Company #1
%   and was found by Mathias Stolpe after checking that some of the entries
%   in the diagonal of the E matrix were negative when the Poisson ration
%   was above 0.5. New notation is according to the manual which is
%   according to Abaqus.
%   Version 3.0    24.09.2012  José Pedro Blasques and Robert Bitshce:
%   Completely rewritten the function so forget everything from the past.
%
% (c) DTU Wind Energy
%********************************************************

E1=utils.matprops(utils.emat(e,2),1);
E2=utils.matprops(utils.emat(e,2),2);
E3=utils.matprops(utils.emat(e,2),3);
G12=utils.matprops(utils.emat(e,2),4);
G13=utils.matprops(utils.emat(e,2),5);
G23=utils.matprops(utils.emat(e,2),6);
nu12=utils.matprops(utils.emat(e,2),7);
nu13=utils.matprops(utils.emat(e,2),8);
nu23=utils.matprops(utils.emat(e,2),9);

% Compliance matrix in default coordinates
Sm  =   [ 1/E1     -nu12/E1   -nu13/E1    0      0      0      ;
          -nu12/E1  1/E2      -nu23/E2    0      0      0      ;
          -nu13/E1  -nu23/E2  1/E3        0      0      0      ;
          0        0         0          1/G23  0      0      ;
          0        0         0          0      1/G13  0      ;
          0        0         0          0      0      1/G12  ];

%Material stiffness matrix in material coordinate system
Qm=Sm\eye(6);

% keyboard
%REORDER TO BECAS
edof=[6 1 2 3 5 4];
Qm(edof,edof)=Qm;
Sm(edof,edof)=Sm;

end

