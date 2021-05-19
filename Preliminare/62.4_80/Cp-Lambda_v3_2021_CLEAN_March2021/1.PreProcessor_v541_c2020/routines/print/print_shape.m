function print_shape(dat_file_name)

% Define default coordinates for surfaces (Hardcoded) #LS;
surface = DefineDefaultPointsForSurfaces;

% Send status #LS
disp('  Writing Shape.dat file.........')



fpc=fopen( strcat(dat_file_name(end,:),'\MB_model\Shape.dat') , 'w');


% Write shapes
%-------------------------------------------------------------------------
fprintf(fpc,'Shapes :  \n'); 

    shape_definition( fpc , 'shape_nacelle_botton' , 'surface' , 1, 0.0, 'nacelle_botton', [2.2 2.5 2.5], [1 4.5 1.3] );
    shape_definition( fpc , 'shape_nacelle_centre' , 'surface' , 1, 0.0, 'nacelle_centre', [2.2 2.5 2.5], [1 3 -0.05] );
    shape_definition( fpc , 'shape_nacelle_initial' , 'surface' , 1, 0.0, 'nacelle_initial', [2.2 2.1 2.5], [0.3 0.15 0.05] );
    shape_definition( fpc , 'shape_hub' , 'surface' , 1, 0.0, 'hub', [2.2 2.1 2.5], [0.5 0.5 0.8] );
    
fprintf(fpc,';  \n'); 
fprintf(fpc,'\n');


% Write surfaces
%-------------------------------------------------------------------------
fprintf(fpc,'Surfaces:  \n'); 
    
    surface_definition( fpc , surface , 'nacelle_botton'  );
    surface_definition( fpc , surface , 'nacelle_centre'  );
    surface_definition( fpc , surface , 'nacelle_initial'  );
    surface_definition( fpc , surface , 'hub'  );
    
fprintf(fpc,';  \n'); 
fprintf(fpc,'\n');


% Write shapes (tower)
%-------------------------------------------------------------------------
fprintf(fpc,'Shapes :  \n'); 

    shape_definition( fpc , 'shape_tower_01' , 'curve' , 1, 0.0, 'circle', [0.0  0.54   0.54], [0  0  0 ] );
    shape_definition( fpc , 'shape_tower_02' , 'curve' , 1, 0.0, 'circle', [0.0  0.432  0.432], [0  0  0 ] );
    shape_definition( fpc , 'shape_tower_03' , 'curve' , 1, 0.0, 'circle', [0.0  0.432  0.432], [0  0  0 ] );
    shape_definition( fpc , 'shape_tower_04' , 'curve' , 1, 0.0, 'circle', [0.0  0.432  0.432], [0  0  0 ] );
    shape_definition( fpc , 'shape_tower_05' , 'curve' , 1, 0.0, 'circle', [0.0  0.415  0.415], [0  0  0 ] );
    shape_definition( fpc , 'shape_tower_06' , 'curve' , 1, 0.0, 'circle', [0.0  0.39809  0.39809], [0  0  0 ] );
    shape_definition( fpc , 'shape_tower_07' , 'curve' , 1, 0.0, 'circle', [0.0  0.38113  0.38113 ], [0  0  0 ] );
    shape_definition( fpc , 'shape_tower_08' , 'curve' , 1, 0.0, 'circle', [0.0  0.36418  0.36418], [0  0  0 ] );
    shape_definition( fpc , 'shape_tower_09' , 'curve' , 1, 0.0, 'circle', [0.0, 0.34722  0.34722], [0  0  0 ] );
    shape_definition( fpc , 'shape_tower_10' , 'curve' , 1, 0.0, 'circle', [0.0  0.33026  0.33026], [0  0  0 ] );
    shape_definition( fpc , 'shape_tower_11' , 'curve' , 1, 0.0, 'circle', [0.0  0.31331  0.31331], [0  0  0 ] );
    shape_definition( fpc , 'shape_tower_12' , 'curve' , 1, 0.0, 'circle', [0.0  0.29635  0.29635], [0  0  0 ] );
    shape_definition( fpc , 'shape_tower_13' , 'curve' , 1, 0.0, 'circle', [0.0  0.27940  0.27940], [0  0  0 ] );
    shape_definition( fpc , 'shape_tower_14' , 'curve' , 1, 0.0, 'circle', [0.0  0.26244  0.26244], [0  0  0 ] );
    shape_definition( fpc , 'shape_tower_15' , 'curve' , 1, 0.0, 'circle', [0.0  0.26244  0.26244], [0  0  0 ] );
    
fprintf(fpc,';  \n'); 
fprintf(fpc,'\n');

% Write surfaces(curves) Tower
%-------------------------------------------------------------------------
fprintf(fpc,'Curves:  \n'); 
    
    surface_definition( fpc , surface , 'circle'  );
    
fprintf(fpc,';  \n'); 
fprintf(fpc,'\n');


% Write shapes (Blades)
%-------------------------------------------------------------------------
fprintf(fpc,'Shapes :  \n'); 

    shape_definition( fpc , 'shape_blade' , 'curve' , 1, 0.0, 'naca', [6  2.5 7], [0 0.5 0 ] );
    
fprintf(fpc,';  \n'); 
fprintf(fpc,'\n');

% Write surfaces(curves) Blades
%-------------------------------------------------------------------------
fprintf(fpc,'Curves:  \n'); 
    
    surface_definition( fpc , surface , 'naca'  );
    
fprintf(fpc,';  \n'); 
fprintf(fpc,'\n');


fclose(fpc);