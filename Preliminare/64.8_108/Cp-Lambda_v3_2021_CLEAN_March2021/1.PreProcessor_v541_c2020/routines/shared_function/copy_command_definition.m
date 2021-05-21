function copy_command_definition ( fpc , header , copy_name , frame_name_from , frame_name_to ,...
                                   ext_name , phase_flag , phase_angle );

%-------------------------------------------------------------------------
%  This function prints the specified COPY command
%  in a suitable .dat file.
%
%  Syntax:
%         -copy_command_definition ( fpc , header , copy_name , ...
%                                    frame_name_from , frame_name_to,...
%                                   ext_name , phase_flag , phase_angle);
%
%  Input:
%        -For more details see the user's giude.
%
%--------------------------------------------------------------------------

if header == 'y',    
    fprintf(fpc,'CopyCommands :\n');
end

fprintf(fpc,'  CopyCommand :  \n');
fprintf(fpc,'    Name : %2s ; \n',deblank(copy_name));
fprintf(fpc,'    FixedFrame : %2s , %2s ;  \n',deblank(frame_name_from),deblank(frame_name_to));
fprintf(fpc,'    Extension : -%1g- , -%1g- ; \n',ext_name);
if phase_flag == 'y',
    fprintf(fpc,'    Phase : %2s ; \n',deblank(phase_angle));
end

fprintf(fpc,'   ; \n');

if header == 'y',    
    fprintf(fpc,' ; \n');
end
