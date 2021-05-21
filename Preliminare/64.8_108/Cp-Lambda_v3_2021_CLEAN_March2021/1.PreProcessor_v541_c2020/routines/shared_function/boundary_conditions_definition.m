function boundary_conditions_definition( fpc , boundary_condition_name , body_name , point_name , displacement_conditions , rotation_conditions );

%-------------------------------------------------------------------
%  This function print the boundary conditions of the wind-turbine
%  multibody model.
%
%  Syntax:
%     -boundary_conditions_definition( fpc , boundary_condition_name , body_name , ...
%                                      point_name , displacement_conditions , ...
%                                      rotation_conditions );
%
%  Input:
%        -boundary_condition_name : it is a colum vector whose rows
%                                   contains the name of the boundary
%                                   condition. Example:
%                    boundary_condition_name = strvcat( bound_a , ...
%                                                       bound_b , ...
%                                                       bound_c );
%        -body_name = it is a colum vector whose rows contains the
%                     name of the body at which the boundary condition 
%                     is applied;
%
%-----------------------------------------------------------------------



fprintf(fpc,'BoundaryConditions :\n');

conditions_number = size( boundary_condition_name );

for i = 1 : conditions_number(1) ;
    
    fprintf(fpc,'  BoundaryCondition :\n');
    fprintf(fpc,'   Name : %2s ;\n',deblank(boundary_condition_name(i,:)));
    fprintf(fpc,'   AppliedTo : %2s ;\n',deblank(body_name(i,:)));
    fprintf(fpc,'   Where : %2s ;\n',deblank(point_name(i,:)));
    fprintf(fpc,'   DisplacementBoundaryConditions : %2g , %2g , %2g ;\n',displacement_conditions(i,:));
    fprintf(fpc,'   RotationBoundaryConditions : %2g , %2g , %2g ;\n',rotation_conditions(i,:));
    fprintf(fpc,'  ;\n');
    
end

fprintf(fpc,';\n\n\n');