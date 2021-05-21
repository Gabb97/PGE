function spring_definition( fpc, header , type , name , range , num_of_term , coeff , initial_stretch );

if header == 'y',    
    fprintf(fpc,'Springs :\n');
end

if type(1:6) == 'linear',

    fprintf(fpc,'   LinearSpring:\n');
    
elseif type == 'torsional',
    
    fprintf(fpc,'   TorsionalSpring:\n');
    
end

fprintf(fpc,'    Name : %2s ;\n' , name );
fprintf(fpc,'    TableType : Chebychev ;\n');
fprintf(fpc,'    Range : %2g , %2g ;\n' , range );
fprintf(fpc,'    NumberOfTerms : %2g ;\n' , num_of_term );

switch num_of_term,
    
    case 1
        fprintf(fpc,'    ChebychevCoefficients : %2g ;\n',coeff);
    case 2
        fprintf(fpc,'    ChebychevCoefficients : %2g , %2g ;\n',coeff);
    case 3
        fprintf(fpc,'    ChebychevCoefficients : %2s , %2g ,%2g ;\n',coeff);
    case 4
        fprintf(fpc,'    ChebychevCoefficients : %2s , %2g , %2g , %2g ;\n',coeff);
    case 5
        fprintf(fpc,'    ChebychevCoefficients : %2s , %2g , %2g , %2g , %2g ;\n',coeff);
        
end

if initial_stretch(1) ~= 'n',
    fprintf(fpc,'    InitialStretch : %2g ;\n' , initial_stretch );
end

fprintf(fpc,'   ;\n');

if header == 'y',
    fprintf(fpc,' ;\n');
end