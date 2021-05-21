function BECAS_PlotOutput( savefig_flag, utils, props, eta, secID  )

%********************************************************
% File: BECAS_PlotOutput.m
%   Function to plot results from BECAS like shear, mass, and elastic
%   center positions, and orientation of elastic axes.
%
% Syntax:
%   BECAS_PlotOutput( savefig_flag, utils, props)
%
% Input:
%   savefig_flag :  Flag to save figures (1 for saving)
%   utils   :  Structure with all inputdata and other data necessary (see
%              BECAS_utils).
%   props   :  Structure with constitutive matrices (see
%              BECAS_CrossSectionProps)
%
% Output:
%   Saves matlab figures
%
% Calls:
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

fprintf(1,'> Started output figures BECAS_FIG* based on results...');

%Plots all relevant centers and axis
resultplot = BECAS_PlotCentersAndAxis(utils,...
    props.ShearX,props.ShearY,props.MassX,props.MassY,props.ElasticX,props.ElasticY,props.AlphaPrincipleAxis_ElasticCenter,...
    eta, secID);

%Save figures
if( savefig_flag)
    saveas(resultplot,'BECAS_FIG_Cross_section_centers','fig');
end

fprintf(1,'DONE! \n');


end

