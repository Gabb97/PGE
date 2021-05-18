function sensor_definition( fpc , header , sensor_name , key_word , element_name , sensor_type , frame_name , eta , degree_of_freedom );

%--------------------------------------------------------------------------
%  This function prints in a .dat file the SENSOR model in a for suitable
%  for the multibody code.
% 
%   Syntax:
%       -sensor_definition(  );
%
%   Input:
%       -fpc           =  the .dat file in which the 
%                         function will writes;
%       -header        =  'y' or 'n', define if the
%                         header is required;
%       For more details about the others input data 
%       see the multiboy software user's manual.
% REMARK: if eta value is not required, define in the input
% data eta=2;
%--------------------------------------------------------------------------

if header == 'y',
    fprintf(fpc,' Sensors :\n');
end

fprintf(fpc,'  Sensor :\n');
fprintf(fpc,'   Name : %2s ;\n',deblank(sensor_name));
fprintf(fpc,'   %2s : %2s ;\n',deblank(key_word),deblank(element_name));
fprintf(fpc,'   Sensing : %2s ;\n',deblank(sensor_type));
fprintf(fpc,'   InReferenceFrame : %2s ;\n',deblank(frame_name));


if eta(1) <= 1 ;
   fprintf(fpc,'   EtaValue : %2.16g ;\n',eta);   
end
   
   
fprintf(fpc,'   #DegreeOfFreedom : %2.16g ;\n',degree_of_freedom);
fprintf(fpc,'  ;\n');


if header == 'y',
    fprintf(fpc,' ;\n');
end