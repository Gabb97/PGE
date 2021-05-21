function UpdateEigsBladeRotating(Parameters,EigsFileName)

disp(' ')
disp('*** Updating EigsBladeRotating.was.......')
disp(' ')

% open file

ff = fopen(EigsFileName,'r');

if ff<0
    fprintf('    WARNING: Unable to open %s file!!',EigsFileName);
    return
end

% scan file lines and store data
iline = 0;
while ~feof(ff)
    iline = iline +1;
    data{iline} = fgetl(ff);
end

fclose(ff);

% Find rotor speed information and update 
for il = 1: iline
    if ~isempty(strfind(data{il},'control_rigid_rotation'))
        str_to_print_1 = sprintf('    Time :   3 ;   FunctionValue : %.4f ;   # Modified by the regulation trajectory on: %s', Parameters.CP_TSR.OmegaRated*(pi/30) , datestr(datetime));
        str_to_print_2 = sprintf('    Time :  10 ;   FunctionValue : %.4f ;   # Modified by the regulation trajectory on: %s', Parameters.CP_TSR.OmegaRated*(pi/30) , datestr(datetime));
 
        data{il+4}   = str_to_print_1;
        data{il+5}   = str_to_print_2;
    end
end

% Overwrite file
ff = fopen(EigsFileName, 'w');
     for il = 1: iline
         fprintf(ff,'%s \n',data{il});
     end
fclose(ff);  

