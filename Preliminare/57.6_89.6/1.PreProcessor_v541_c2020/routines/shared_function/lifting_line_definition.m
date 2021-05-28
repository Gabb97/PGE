function lifting_line_definition ( fpc , lifting_name , lifting_curve_name , lifting_triad_name , lifting_prop_name ,...
                                   airstation_def , airstation_number , airloads_scheme , body_list , unsteady_flag , tiploss_flag) ;
                               
                               
fprintf(fpc,'  LiftingLine :\n');
fprintf(fpc,'    Name : %2s ;\n', deblank(lifting_name) );
fprintf(fpc,'    Curve : %2s ;\n' , deblank(lifting_curve_name) );
fprintf(fpc,'    Triad : %2s ;\n' , deblank(lifting_triad_name) );
fprintf(fpc,'    LiftingLineProperty : %2s ;\n' , deblank(lifting_prop_name) );
fprintf(fpc,'    Airstations : %2s ;\n' , deblank(airstation_def) );
fprintf(fpc,'    NumberOfAirstations : %2g ;\n' , airstation_number );
fprintf(fpc,'    AirloadsScheme : %2s ;\n' , deblank(airloads_scheme) );
%fprintf(fpc,'    MeasuredAirload : measured airloads name ;\n');
fprintf(fpc,'    BodyList : %2s ;\n' , body_list );
if tiploss_flag
    fprintf(fpc,'    TipLoss : YES ;\n' , body_list );  % ALE. added 25.feb.2005
    fprintf(fpc,'    HubLoss : YES ;\n' , body_list );  % ALE. added 12.apr.2016
end
if unsteady_flag == 'y',
%    fprintf(fpc,'    UnsteadyCorrectionFlag : yes ; \n' );
end
fprintf(fpc,'   ;\n');