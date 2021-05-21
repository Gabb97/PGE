function  mesh_definition( fpc , header , mesh_name , nelements , elem_order );

%--------------------------------------------------------------------------
%  This function prints in a .dat file the multibody mesh model
% 
%   Syntax:
%           - mesh_definition ( fpc , mesh_name , nelements , elem_order )
%
%   Input:
%           -'y' or 'n' = this flag define if the header is required;
%           - fpc = the .dat file in which the function will write;
%           - mesh_name = a character string which contains the mesh model name;
%           - nelements = number of elements along the curve;
%           - elem_order = order of the elements along the curve;
%
%--------------------------------------------------------------------------

if header == 'y',
    
    fprintf(fpc,' CurveMeshParameters :  \n');

end

fprintf(fpc,'   CurveMeshParameter :\n');
fprintf(fpc,'     Name : %2s ; \n' , deblank(mesh_name) );
fprintf(fpc,'     NumberOfElements : %2g ; \n' , nelements );
fprintf(fpc,'     OrderOfElements :  %2g ; \n' , elem_order );
fprintf(fpc,'    ; \n');

if header == 'y',
    
    fprintf(fpc,' ;\n\n\n'); 
    
end
