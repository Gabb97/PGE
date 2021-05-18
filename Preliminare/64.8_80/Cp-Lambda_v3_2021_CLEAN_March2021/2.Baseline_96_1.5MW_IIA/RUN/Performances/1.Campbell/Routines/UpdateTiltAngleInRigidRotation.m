function UpdateTiltAngleInRigidRotation(Parameters)

% This subroutine reads the nacelle uptilt angle from the WTData.xls file
% and updates the unit vector defining the rigid rotation in the blade 
% eigenvalues computation.
disp(' ')
disp('*** Updating tilt angle in the rigid rotation....');
disp(' ')

filename = '.\input\Blade_4_eigs_rotating.dat';

% open file

ff = fopen(filename,'r');

if ff<0
    fprintf('    WARNING: Unable to open %s file!!',filename);
    return
end

% scan file lines and store data
iline = 0;
while ~feof(ff)
    iline = iline +1;
    data{iline} = fgetl(ff);
end

fclose(ff);

% Find rigid rotation information and update 
for il = 1: iline
    if ~isempty(strfind(data{il},'control_rigid_rotation'))
        
        x_tilt       =  -sind(Parameters.NacelleUptilt);
        y_tilt       =  cosd(Parameters.NacelleUptilt);
        z_tilt       =  0.0;
        
        str_to_print = sprintf('     AngularVelocity :  %.6e , %.6e , %.6e ;    # Modified by MATLAB on: %s', x_tilt, y_tilt, z_tilt, datestr(datetime));
 
        data{il+1}   = str_to_print;
    end
end

% Overwrite file
ff = fopen(filename, 'w');
     for il = 1: iline
         fprintf(ff,'%s \n',data{il});
     end
fclose(ff);  


