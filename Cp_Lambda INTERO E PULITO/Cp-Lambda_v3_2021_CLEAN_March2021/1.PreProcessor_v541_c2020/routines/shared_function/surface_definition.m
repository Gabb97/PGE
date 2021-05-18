function surface_definition( fpc , surface , surface_name  );


if strcmpi(surface.(surface_name).type,'surface')
    % Type is SURFACE
    numb_coord = surface.(surface_name).numb_points(1)*surface.(surface_name).numb_points(2);


    fprintf(fpc,' Surface : \n'); 
    fprintf(fpc,'    Name : %s ; \n', surface_name);
    fprintf(fpc,'    InReferenceFrame : %s ; \n', surface.(surface_name).frame);
    fprintf(fpc,'    Points : \n');
    fprintf(fpc,'    NumberOfControlPoints : %i , %i ; \n', surface.(surface_name).numb_points(1) , surface.(surface_name).numb_points(2));
    fprintf(fpc,'    DegreeOfCurve : %i , %i ; \n', surface.(surface_name).curve_degree(1) , surface.(surface_name).curve_degree(2));
    fprintf(fpc,'    RationalCurveFlag : YES ; \n');

    for icoord = 1: numb_coord

        i_coordinates = surface.(surface_name).coordinates(icoord,:);
        fprintf(fpc,'    Coordinates: %.5f , %.5f , %.5f , %.5f ; \n', i_coordinates(1),i_coordinates(2),i_coordinates(3) ,i_coordinates(4));

    end

    fprintf(fpc,'   ; \n');
    fprintf(fpc,'  ; \n');
    
else
    % Type is CURVE
     numb_coord = surface.(surface_name).numb_points;


    fprintf(fpc,' Curve : \n'); 
    fprintf(fpc,'    Name : %s ; \n', surface_name);
    fprintf(fpc,'    InReferenceFrame : %s ; \n', surface.(surface_name).frame);
    fprintf(fpc,'    Points : \n');
    fprintf(fpc,'    NumberOfControlPoints : %i ; \n', surface.(surface_name).numb_points);
    fprintf(fpc,'    DegreeOfCurve : %i  ; \n', surface.(surface_name).curve_degree);
    fprintf(fpc,'    RationalCurveFlag : NO ; \n');

    for icoord = 1: numb_coord

        i_coordinates = surface.(surface_name).coordinates(icoord,:);
        fprintf(fpc,'    Coordinates: %.5f , %.5f , %.5f  ; \n', i_coordinates(1),i_coordinates(2),i_coordinates(3) );

    end

    fprintf(fpc,'   ; \n');
    fprintf(fpc,'  ; \n');
    
end