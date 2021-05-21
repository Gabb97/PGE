function triad_definition( fpc , header , triad_name , e2 , e3 , frame_name );

%--------------------------------------------------------------------------
%  This function prints in a .dat file the TRIAD model suitable
%  for the multibody code.
% 
%   Syntax:
%           -triad_definition( fpc , header , triad_name , e2 , e3 , frame_name );
%
%   Input:
%           -fpc           =  the .dat file in which the 
%                             function will writes;
%           -header        =  'y' or 'n', define if the
%                              header is required;
%           -triad_name    =  character string which 
%                             contains the triad's name;
%           -e2 , e3       =  direction cosines of the 
%                             triad at the eta position
%                             (row vectors);
%           -frame_name    =  character string which 
%                             contains the reference frame name;
%--------------------------------------------------------------------------

if header == 'y',
    fprintf(fpc,' Triads : \n');
end
fprintf(fpc,'   Triad :\n');
fprintf(fpc,'     Name : %2s ; \n',deblank(triad_name));
fprintf(fpc,'     YVector : %2.16g , %2.16g , %2.16g ; \n',e2);
fprintf(fpc,'     ZVector : %2.16g , %2.16g , %2.16g ; \n',e3);
fprintf(fpc,'     InReferenceFrame : %2s ; \n',deblank(frame_name));
fprintf(fpc,'   ;\n');

if header == 'y',
    fprintf(fpc,' ; \n\n\n');
end
