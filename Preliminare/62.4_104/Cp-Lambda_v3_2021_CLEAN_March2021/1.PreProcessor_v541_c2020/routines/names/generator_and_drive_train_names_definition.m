function generator_and_drive_train_names_definition;

%names associated to generator and drive train definition

pt_generator_names = strvcat ('pt_generator',...
                              'pt_generator_link_nacelle' , ...
                              'pt_rvj_mechanical_loss');
                           

                          
generator_components_names = strvcat('rb_generator'                     , ...    %1
                                     'generator_mass'                   , ...    %2
                                     'rvj_generator'                    , ...    %3
                                     'drive_train_shaft_1'              , ...    %4
                                     'drive_train_shaft_2'              , ...    %5
                                     'triad_generator'                  , ...    %6
                                     'triad_rvj_generator'              , ...    %7
                                     'drive_train_linker'               , ...    %8
                                     'rvj_mechanical_loss'              , ...    %9
                                     'rb_drive_train_auxiliary_1'       , ...    %10
                                     'rb_drive_train_auxiliary_1_conn'  , ...    %11
                                     'rb_drive_train_auxiliary_2'       , ...    %12
                                     'rb_drive_train_auxiliary_2_conn' );        %13
               

                                 
generator_names_miscellaneous = strvcat ( 'drive_train_shaft_curve_1' , ...         %1
                                          'drive_train_shaft_properties' , ...      %2
                                          'drive_train_linker_curve' , ...          %3
                                          'drive_train_linker_properties' , ...     %4
                                          'drive_train_shaft_curve_2');             %5
                                          
                                 
                                 
% save names\generator_names pt_generator_names generator_components_names generator_names_miscellaneous

save generator_names pt_generator_names generator_components_names generator_names_miscellaneous