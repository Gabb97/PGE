function nacelle_names;

%-----------------------------------------------------
% Names associated to the NACELLE definition
%-----------------------------------------------------


pt_nacelle_name = strvcat ('pt_nacelle_top');


nacelle_rb_name = strvcat ('rigid_body_nacelle');


nacelle_associated = strvcat ( 'rigid_body_nacelle_associated_1' , ...
                               'rb_nacelle_to_drive_train' , ...
                               'rigid_nacelle_associated_3');
    

nacelle_mass = strvcat ('nacelle_mass');


nacelle_triad = strvcat('triad_nacelle');


nacelle_aero_names = strvcat ('nacelle_aero_beam'       ,...      %1
                              'nacelle_aero_properties' , ...     %2
                              'nacelle_aero_curve'      , ...     %3
                              'nacelle_aero_mesh'       , ...     %4
                              'lifting_line_nacelle_triad' , ...  %5
                              'lifting_line_nacelle_prop'  , ...  %6
                              'lifting_line_nacelle'       , ...  %7
                              'nacelle_airtable');                %8



%save names\nacelle_names nacelle_rb_name nacelle_associated nacelle_mass nacelle_triad pt_nacelle_name nacelle_aero_names

save nacelle_names nacelle_rb_name nacelle_associated nacelle_mass nacelle_triad pt_nacelle_name nacelle_aero_names