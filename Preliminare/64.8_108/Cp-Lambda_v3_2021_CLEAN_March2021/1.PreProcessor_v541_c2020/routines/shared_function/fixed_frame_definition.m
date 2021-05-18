function fixed_frame_definition ( fpc , header , frame_name , origin , orientation_e2 , orientation_e3 );

%-----------------------------------------------------------------------------
%  This function prints specified fixed frame in a suitable .dat file.
%
%  Syntax:
%
%         -fixed_frame_definition ( fpc , headeer ,frame_name , origin , ...
%                                   orientation_e2 , orintation_e3 );
%
%  Input:
%
%        -fpc             =  file in which the function is printing;
%        -header          =  'y' or 'no', defines if the header is needed;
%        -frame_name      =  character string which defines the frame name;
%        -origin          =  vector which contains the origin coordinates with
%                            respect the inertial frame;
%        -orientation_e2  =  vector which contains the e2 director cosines;
%        -orientation_e3  =  vector which contains the e3 director cosines;
%
%-----------------------------------------------------------------------------

if header == 'y';
    fprintf(fpc,'FixedFrames :\n');
end    

fprintf(fpc,'  FixedFrame :  \n');
fprintf(fpc,'    Name : %2s ; \n' , deblank(frame_name));
fprintf(fpc,'    Origin :  %2.16g , %2.16g , %2.16g ; \n' , origin);
fprintf(fpc,'    YVector : %2.16g, %2.16g , %2.16g ; \n' , orientation_e2);
fprintf(fpc,'    ZVector : %2.16g, %2.16g , %2.16g ; \n' , orientation_e3);
fprintf(fpc,'   ; \n');

if header == 'y';
    fprintf(fpc,' ; \n');
end

