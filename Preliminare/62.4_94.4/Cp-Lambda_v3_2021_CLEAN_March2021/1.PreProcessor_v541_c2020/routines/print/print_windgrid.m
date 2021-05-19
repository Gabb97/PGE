function print_windgrid(dat_file_name , PathStruct)

%-------------------------------------------------------------
%  This function prints the .dat file for the multibody code.
%
%  Syntax:
%
%  Input:
%
% ALE. 28.march.2005
%-------------------------------------------------------------

% Send status #LS
disp('  Writing WindModelNoGrid.dat file.........')

%-------------------------------------------------------------
load names\tower_names

handles.tower = read_tower_details(PathStruct);
handles.hub = read_hub_details(PathStruct);
%-------------------------------------------------------------

% fpt = fopen('Multibody\WindModelNoGrid.dat', 'w' );
fpt = fopen(strcat(dat_file_name(end,:),'\MB_model\WindModelNoGrid.dat'), 'w' );


fprintf(fpt,'\nWindModels:');
fprintf(fpt,'\n    WindModel:');
fprintf(fpt,'\n        Name                :   WindModelName;');
fprintf(fpt,'\n        ConnectedTo         :   rb_hub_centre;');
fprintf(fpt,'\n        Where               :   pt_hub_centre;');
fprintf(fpt,'\n        TowerAxis           :   1.0,0.0,0.0;');
fprintf(fpt,'\n        TowerRoot           :   0.0,0.0,0.0;');
fprintf(fpt,'\n        # TOWER SHADOW ++++++++++++++++++++++');
fprintf(fpt,'\n        TowerShadow  :  YES;');
fprintf(fpt,'\n            TowerShadowModel    :   Potential;');
fprintf(fpt,'\n            # TowerShadowModel    :   Downwind;');
fprintf(fpt,'\n            # TowerShadowModel    :   Combined;');
fprintf(fpt,'\n            TowerDiameters  :');
fprintf(fpt,'\n                NumberOfTerms   :   %i;',handles.tower.nentries+2);
for i=1:handles.tower.nentries
    fprintf(fpt,'\n                Height  :  %1.5e  ; Diameter :  %1.5e;',handles.tower.height(i),handles.tower.diameter(i));
end
    fprintf(fpt,'\n                Height  :  %1.5e  ; Diameter :  %1.5e;',handles.tower.height(end)+0.01,0);
    fprintf(fpt,'\n                Height  :  %1.5e  ; Diameter :  %1.5e;',handles.tower.height(end)+100,0);
fprintf(fpt,'\n            ;');
fprintf(fpt,'\n            TowerDiameterCorrectionFactor : 1.0;');
fprintf(fpt,'\n            # MaximunVelocityDeficit        : 0.1;');
fprintf(fpt,'\n            # TowerShadowWidth              : 1.0;');
fprintf(fpt,'\n            # ReferencePosition             : 1.0;');
fprintf(fpt,'\n        # WIND SHEAR ++++++++++++++++++++++++');
fprintf(fpt,'\n        WindShearModel  : exponential;');
fprintf(fpt,'\n        ReferenceHeight :  %1.5e;',handles.hub.hub_height);
% fprintf(fpt,'\n        ReferenceHeight :  65.0;');
fprintf(fpt,'\n        WindShearExponent:  0.2;');
fprintf(fpt,'\n        # WindShearModel  : logarithmic;');
fprintf(fpt,'\n        # ReferenceHeight : 60.0;');
fprintf(fpt,'\n        # GroundRoughnessHeight : 0.0755;');
fprintf(fpt,'\n        LiftingLineList     :   lifting_line_1_1,lifting_line_1_2,lifting_line_1_3;');
fprintf(fpt,'\n        # TURBULENCE ++++++++++++++++++++++++');
fprintf(fpt,'\n        # Uncomment next line if needed');
fprintf(fpt,'\n        #WindGrid        : WindGridName;');
fprintf(fpt,'\n    ;');
fprintf(fpt,'\n;');
fprintf(fpt,'\n');
% fprintf(fpt,'\n# GRID++++++++++++++++++++++++');
% fprintf(fpt,'\n# Uncomment next lines if needed');
% fprintf(fpt,'\n');
% fprintf(fpt,'\n#WindGrids:');
% fprintf(fpt,'\n#    WindGrid:');
% fprintf(fpt,'\n#        Name             : WindGridName;');
% fprintf(fpt,'\n#        File             : .\\Model\\EOG_1_year ;');
% fprintf(fpt,'\n#        InReferenceFrame : frame_wind_file;');
% fprintf(fpt,'\n#        MeshSize         : 80.0,80.0;');
% fprintf(fpt,'\n#        NumberOfIntervals: 9,9;     # These are intervals');
% fprintf(fpt,'\n#        NumberOfTimeSteps: 1000;    # This is the number of time step');
% fprintf(fpt,'\n#        # InitialWindGridTime: 0.0;    # Optional - default value is 0.0');
% fprintf(fpt,'\n#    ;');
% fprintf(fpt,'\n#;');
% fprintf(fpt,'\n');

fclose(fpt);