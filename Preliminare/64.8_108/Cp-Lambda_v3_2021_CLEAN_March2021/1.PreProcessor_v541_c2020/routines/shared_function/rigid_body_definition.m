function  rigid_body_definition( fri , name , point0 , body0 , point1 , body1 , triad ,...
    associated_flag , mass_flag , ass_name , ass_coll , point_coll_name , mass_name );

%------------------------------------------------------------------------------------
%  This function prints the rigid_body model in the multibody form.
%
%  Syntax:
%         -rigid_body_definition( fri , name , point0 , body0 , point1 , body1,...
%                                 triad , associated_flag , mass_flag , ass_name,...
%                                 ass_coll , point_coll_name , mass_name );
%
%  Input:
%        -fri = .dat file in which the function must write;
%         OTHERS = see the multibody software user's manual for more explanations
%                  about the meaning of the function input;
%------------------------------------------------------------------------------------

fprintf(fri,'  RigidBody :\n');
fprintf(fri,'     Name : %2s ; \n',deblank(name));
fprintf(fri,'     ConnectedTo : %2s ; \n',deblank(body0));
fprintf(fri,'     Where : %2s ; \n',deblank(point0));
fprintf(fri,'     ConnectedTo : %2s ; \n',deblank(body1));
fprintf(fri,'     Where : %2s ; \n',deblank(point1) );
fprintf(fri,'     Triad : %2s ; \n',deblank(triad) );

if associated_flag == 'y';
    
    fprintf(fri,'     AssociatedRigidBody : \n');
    
    for i = 1 : min(size(ass_name)),
    
        fprintf(fri,'       RigidBody : \n');
        fprintf(fri,'         Name : %2s ;\n', deblank(ass_name(i,:)));
        fprintf(fri,'         ConnectedTo : %2s ; \n', deblank(ass_coll(i,:)));
        fprintf(fri,'         Where : %2s ; \n',deblank(point_coll_name(i,:)));
        fprintf(fri,'      ; \n');
        
    end
    
    fprintf(fri,'    ; \n');        

end

if mass_flag == 'y';
    fprintf(fri,'     MassProperty : %2s ;\n',deblank(mass_name));
else
%    fprintf(fri,'#    MassProperty :  ;\n');
    %TO BE COMPLETED    
%    fprintf(fri,'#    Curve : curve name ; \n');
%    fprintf(fri,'#    @SURFACE NAME : surface name ; \n');
%    fprintf(fri,'#    @SHAPE : shape name ; \n');
end

fprintf(fri,' ; \n');
