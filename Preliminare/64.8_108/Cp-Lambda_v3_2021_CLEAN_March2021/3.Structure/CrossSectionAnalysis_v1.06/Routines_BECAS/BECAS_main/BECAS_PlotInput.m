function BECAS_PlotInput( savefig_flag, utils, eta, secID )
%********************************************************
% File: BECAS_PlotInput.m
%   Function to plot input data like FE mesh, fiber orientations, etc.
%
% Syntax:
%   BECAS_PlotInput( savefig_flag, utils )
%
% Input:
%   savefig_flag :  Flag to save figures (1 for saving)
%   utils   :  Structure with all inputdata and other data necessary (see
%              BECAS_utils).
%
% Output:
%   Saves matlab figures   
%
% Calls:
%
% Revisions:
%   Version 1.0    07.02.2012   JosÃ© Pedro Blasques
%
%   Version 2.0    07.09.2012   José Pedro Blasques: Removed BECAS_utils 
%   and changed the input to receive the utils structure. Changed the ouput
%   to pass the props structure.
%
% (c) DTU Wind Energy
%********************************************************

fprintf(1,'> Started output figures BECAS_FIG* based on input data...');

%Plot FE mesh
  meshplot = BECAS_PlotFEmesh(utils, eta, secID);
% 
% %Plot fiber angle orientation
% faplot = BECAS_PlotFiberAngle(utils);
% 
% %Plot fiber plane angle orientation
% fpplot = BECAS_PlotFiberPlane(utils);
% 
%Plot element numbers
% if(utils.ne_2d<3000)
%     enplot = BECAS_PlotElementNumbers(utils);
% else
%     fprintf(1,'Oh, so many elements! Skipping element number plot so you donÂ´t grow old waiting for it. \n');
% end

%Plot material number/color
mnplot = BECAS_PlotMaterialNumber(utils, eta, secID);

% %Plot 3D fiber orientation
% if(utils.ne_2d<3000)
%     f3dplot = BECAS_PlotFiber3D(utils);
% else
%     fprintf(1,'Oh, so many elements! Skipping 3D fiber angle plot so you don´t grow old waiting for it. \n');
% end
% 
% %Save figures
% if (savefig_flag)
%     saveas(meshplot, 'BECAS_FIG_FE_mesh','fig');
%     saveas(faplot,   'BECAS_FIG_Fiber_orientation','fig');
%     saveas(fpplot,   'BECAS_FIG_Fiber_plane_orientation','fig');
%     saveas(mnplot,   'BECAS_FIG_Material_numbers','fig');
%     if exist('enplot','var')
%         saveas(enplot,'BECAS_FIG_Element_numbers','fig');
%     end
%     if exist('f3dplot','var')
%         saveas(f3dplot,'BECAS_FIG_Fibers_in_3D','fig');
%     end
% end
% 
% fprintf(1,'DONE! \n');
% 
% end



