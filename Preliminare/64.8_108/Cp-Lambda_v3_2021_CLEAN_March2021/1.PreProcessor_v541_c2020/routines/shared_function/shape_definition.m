function shape_definition( fpc , shape_name , shape_type , numb_terms, eta, parent_obj, scaling, origin  );



fprintf(fpc,' Shape : \n'); 
fprintf(fpc,'    Name : %s ; \n', shape_name);
fprintf(fpc,'    ShapeType : %s ; \n', shape_type);
fprintf(fpc,'    NumberOfTerms : %i ; \n', numb_terms);
fprintf(fpc,'    EtaValue : %.1f ; :  \n', eta);

if strcmpi(shape_type,'surface')
    fprintf(fpc,'    Surface : %s ; \n', parent_obj);
else
    fprintf(fpc,'    Curve : %s ; \n', parent_obj);
end

fprintf(fpc,'    ScalingFactor : %.4f , %.4f, %.4f ; \n', scaling(1), scaling(2), scaling(3));
fprintf(fpc,'    Origin : %.4f , %.4f, %.4f ; \n', origin(1), origin(2), origin(3));
fprintf(fpc,'    ; \n');
fprintf(fpc,'   ; \n');

