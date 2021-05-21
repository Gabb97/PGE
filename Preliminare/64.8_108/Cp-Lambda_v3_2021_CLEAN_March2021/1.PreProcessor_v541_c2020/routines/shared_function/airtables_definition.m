function airtables_definition ( fpc , header , table_name , mach , alfa , airtable );

%---------------------------------------------
%  Input:
%    -airtable : It is a cell array. Each cell is
%                referred to a defined Mach value
%                and contains a matrix whose colums
%                are, in oreder: Cl , Cd and Cm0 at
%                each incidence angle defined in
%                the vector named alfa.
%
%---------------------------------------------

a=max(size(mach));
b=max(size(alfa));

if header == 'y',
    fprintf(fpc,'Airtables :\n');
end

fprintf(fpc,'    Airtable :\n' );
fprintf(fpc,'      Name: %3s ; \n' , table_name );
fprintf(fpc,'      TableOfLiftCoefficients :\n');
fprintf(fpc,'         NumberOfTerms : %10g , %10g ;\n' , a , b );

for i = 1 : a ,
    
    if i == a ,
        
        fprintf(fpc,'             %10.16g  \n', mach (i));
        
    else
        
        fprintf(fpc,'             %10.16g  ', mach (i));
        
    end
    
end


for i = 1 : b,
    
    fprintf(fpc,'   %10.16g ' , alfa(i));
    
    if a == 1 ,
        
        fprintf(fpc,'   %10.16g ' , airtable(i,1));
        
    else
        
        for ii = 1 : a,
            
            fprintf(fpc,'   %10.16g ' , airtable{ii}(i,1));
            
        end
        
    end
    
    fprintf(fpc,'\n');    
    
end 

fprintf(fpc,'         ;\n');


fprintf(fpc,'      TableOfDragCoefficients : \n');
fprintf(fpc,'         NumberOfTerms : %10g , %10g;\n' , a , b );
for i = 1 : a ,
    
    if i == a ,
        
        fprintf(fpc,'             %10.16g  \n', mach (i));
        
    else
        
        fprintf(fpc,'             %10.16g  ', mach (i));
        
    end
    
end
for i = 1 : b,
    
    fprintf(fpc,'   %10.16g ' , alfa(i));
    
    if a == 1 ,
        
        fprintf(fpc,'   %10.16g ' , airtable(i,2));
        
    else
        
        for ii = 1 : a,
            
            fprintf(fpc,'   %10.16g ' , airtable{ii}(i,2));
            
        end
        
    end
    
    fprintf(fpc,'\n');    
    
end
fprintf(fpc,'         ;\n');


fprintf(fpc,'      TableOfMomeCoefficients : \n');
fprintf(fpc,'         NumberOfTerms : %10g , %10g ;\n' , a , b );
for i = 1 : a ,
    
    if i == a ,
        
        fprintf(fpc,'             %10.16g  \n', mach (i));
        
    else
        
        fprintf(fpc,'             %10.16g  ', mach (i));
        
    end
    
end
for i = 1 : b,
    
    fprintf(fpc,'   %10.16g ' , alfa(i));
    
    if a == 1 ,
        
        fprintf(fpc,'   %10.16g ' , airtable(i,3));
        
    else
        
        for ii = 1 : a,
            
            fprintf(fpc,'   %10.16g ' , airtable{ii}(i,3));
            
        end
        
    end
    
    fprintf(fpc,'\n');    
    
end
fprintf(fpc,'         ;\n');
%% ALEALE include dynamic stall model
fprintf(fpc,'#         DynamicStallCoefficientEta:    0.20, 0.20  ;\n');
fprintf(fpc,'#         DynamicStallCoefficientOmega:  0.25, 0.05  ;\n');
fprintf(fpc,'#         DynamicStallCoefficientE:      0.00, 0.00;\n');

%% ALEALE end
fprintf(fpc,'    ;\n');


if header == 'y',
    fprintf(fpc,'  ;\n');
end
