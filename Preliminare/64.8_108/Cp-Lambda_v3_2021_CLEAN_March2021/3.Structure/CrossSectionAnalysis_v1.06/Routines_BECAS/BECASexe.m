% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Template file for building BECAS_Constitutive.exe
%
% (c) DTU Wind Energy
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

%% Options
%Folder name contining input data
options.foldername=fullfile('./');

%% Build arrays for BECAS
[ utils ] = BECAS_Utils( options );

%% Call BECAS module for the evaluation of the cross section stiffness matrix
[constitutive.Ks,solutions] = BECAS_Constitutive_Ks(utils);

%% Call BECAS module for the evaluation of the cross section mass matrix
[constitutive.Ms] = BECAS_Constitutive_Ms(utils);

%% Call BECAS module for the evaluation of the cross section properties
[csprops] = BECAS_CrossSectionProps(constitutive.Ks,utils);

%% Output of results to HAWC2
%Output to HAWC2
RadialPosition=1; %Define radial position
OutputFilename='BECAS2HAWC2.out'; %File name
BECAS_Becas2Hawc2(OutputFilename,RadialPosition,constitutive,csprops,utils)

%% Output results to PARAVIEW
BECAS_PARAVIEW( 'BECAS_PARAVIEW', utils, csprops )

%% Plotting and priting routines

%Check for large models
if(utils.ne_2d>5000)
   fprintf(1,'Note that the following plotting routines may take a \n');
   fprintf(1,'while for large models like the one you are running.\n');
   fprintf(1,'Hence, press any key to continue or Ctrl-c to quit \n');
   pause
end

%Print results
BECAS_PrintResults( constitutive, csprops, utils );

%Generate figures based on input
savefig_flag=1;
BECAS_PlotInput( savefig_flag, utils );

%Generate figures based on output
savefig_flag=1;
BECAS_PlotOutput(savefig_flag, utils, csprops);


