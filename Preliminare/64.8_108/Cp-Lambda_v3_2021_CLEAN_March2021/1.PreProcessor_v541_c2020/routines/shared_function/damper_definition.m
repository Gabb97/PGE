function damper_definition (fpc , header , damper_type , damper_name , key_word , range , number_of_terms , chebychev_coeff , user_table );

%-----------------------------------------------
% This function defines the damper model of the
% multibody model.
%-----------------------------------------------

if header == 'y',
    fprintf(fpc,'Dampers :\n');
end

% damper type definitions--------------------------
if ( damper_type == 'l' | damper_type == 'L' ),
    
    fprintf(fpc,'  LinearDamper :\n');
    
else 
    fprintf(fpc,'  TorsionalDamper :\n');
end
%----------------------------------------------------

% damper name------------------------------------------
fprintf(fpc,'   Name : %2s ;\n',deblank(damper_name));
%------------------------------------------------------

if key_word == 'user_defined',
    
    fprintf(fpc,'   TableType : UserDefined;\n');    
    fprintf(fpc,'   NumberOfTerms : %g ;\n',(number_of_terms+1)*2);

    user_table_flip_velox = fliplr(user_table(:,1)');
    user_table_flip_moment = fliplr(user_table(:,2)');
    
    for i = 1 : number_of_terms,
    
        if i == 1,
            
            fprintf(fpc,'   AngularVelocity : %2g ;', -2 * user_table_flip_velox(i) );
            fprintf(fpc,'   Moment :  %2g ; \n' ,     -1 *( user_table(end,end) + ((user_table(end,2)-user_table(end-1,2))/(user_table(end,1)-user_table(end-1,1))) * user_table(end,1)) );
            fprintf(fpc,'   AngularVelocity : %2g ;', -1 * user_table_flip_velox(i) );
            fprintf(fpc,'   Moment :  %2g ; \n' ,     -1 * user_table_flip_moment(i) );
            
        elseif i == number_of_terms,
  
            fprintf(fpc,'   AngularVelocity : %2g ;', -0.0001);
            fprintf(fpc,'   Moment :  %2g ; \n' ,     -user_table(1,2));
            fprintf(fpc,'   AngularVelocity : %2g ;', -1 * user_table_flip_velox(i) );
            fprintf(fpc,'   Moment :  %2g ; \n' ,          user_table_flip_moment(i) );
            
        else
        
            fprintf(fpc,'   AngularVelocity : %2g ;', -1 * user_table_flip_velox(i) );
            fprintf(fpc,'   Moment :  %2g ; \n' ,     -1 * user_table_flip_moment(i) );
        
        end
                                
    end
    
    for i = 1 : number_of_terms,
        
        if user_table(i,1) ~= 0 & i ~= number_of_terms,
            
            fprintf(fpc,'   AngularVelocity : %2g ;',    user_table(i,1));
            fprintf(fpc,'   Moment :  %2g ; \n' ,        user_table(i,2));            
            
        elseif i == number_of_terms,
            
            fprintf(fpc,'   AngularVelocity : %2g ;',    user_table(i,1));
            fprintf(fpc,'   Moment :  %2g ; \n' ,        user_table(i,2));
            fprintf(fpc,'   AngularVelocity : %2g ;', 2* user_table(i,1));
            fprintf(fpc,'   Moment :  %2g ; \n' ,      ( user_table(end,end) + ((user_table(end,2)-user_table(end-1,2))/(user_table(end,1)-user_table(end-1,1))) * user_table(end,1)));            
            
        end
        
    end
    
else
    
    fprintf(fpc,'   Range : %2g , %2g ;\n',range);
    fprintf(fpc,'   NumberOfTerms : %2g ;\n',number_of_terms);
    fprintf(fpc,'   ChebychevCoefficients : TO COMPLETED ;\n');
    
end


fprintf(fpc,'  ;\n');


if header == 'y',
    fprintf(fpc,';\n');
end