% This script writes the complete Controller Description for
%          PoliWindController_ver4.7.dll
% 
% WARNING: this is ok for "standard" DLC (i.e. NWP, DLC11, ...). Does not include faults, etc.
%
% INPUT:
%
% OUTPUT
%
% Author: A.C.,  March 2017
%     update     February 2018
%     update     February 2019

disp(' ')
disp('*** Writing WTControllerFile.txt.......')
disp(' ')

% open file

fid = fopen(ControllerFileNameWT,'w');
if fid<0
    fprintf('    WARNING: Unable to open %s file!!',ControllerFileNameD);
    return
end


% Rotor speed values
fprintf(fid,'Tf                          0.1');
fprintf(fid,'\rOmRef                       %g',Parameters.CP_TSR.OmegaRated*1);   % here 0 in the static simulations (could also works for DLC6.n)
fprintf(fid,'\rOverSpeedReference          %g',Parameters.CP_TSR.OmegaRated*1.2);
fprintf(fid,'\rGeneratorDisconnectionSpeed 3');
fprintf(fid,'\rTurbineStopSpeed            2');
fprintf(fid,'\r');

% LUT Table
fprintf(fid,'\rNTorqueCurveTable        	%i',length(OMEGA_RPM));
fprintf(fid,'\rTorqueCurveTableSpeeds      ');
for iw=1:length(OMEGA_RPM)
    fprintf(fid,'%g   ',OMEGA_RPM(iw));
end
fprintf(fid,'\rTorqueCurveTableTorques     ');
for iw=1:length(OMEGA_RPM)
    fprintf(fid,'%g   ',TORQUE_kNm(iw));
end


%  pitch values
fprintf(fid,'\r');
fprintf(fid,'\rUAverageTime                10');
fprintf(fid,'\rNUTable        	            %i',length(minPitch));
fprintf(fid,'\rUTableWinds                 ');
for iw=1:length(WindVector)
    fprintf(fid,'%g   ',WindVector(iw));
end
fprintf(fid,'\rUTablePitches               ');
for iw=1:length(WindVector)
    fprintf(fid,'%g   ',minPitch(iw));
end
fprintf(fid,'\rMinPitch                    %g',Parameters.CP_TSR.maxCpBeta);
fprintf(fid,'\rMaxPitch                    %g',Parameters.maxPitch);
fprintf(fid,'\rMaxPitchRate                %g',Parameters.maxPitchRate);
fprintf(fid,'\rNormalShutDownMaxPitchRate  %g',Parameters.maxPitchRateNSD);
fprintf(fid,'\rEmergencyShutDownMaxPitchRate %g',Parameters.maxPitchRateESD);

% % Rotor filter and PID optional values
% fprintf(fid,'\r');
% fprintf(fid,'\rHighSpeedKIFactor           2');
% fprintf(fid,'\rHighSpeedRotorSpeed         1');
% fprintf(fid,'\rPitchDemandTol              0.1');

%Yaw
fprintf(fid,'\r');
fprintf(fid,'\rYawLowWind                  2.5');
fprintf(fid,'\rYawLowError                 10');
fprintf(fid,'\rYawTime                     30');
fprintf(fid,'\rYawRate                     0.25');

% Wind trip
fprintf(fid,'\r');
fprintf(fid,'\rWindLongTermLimit           35');
fprintf(fid,'\rWindLongTermAvPeriod        30');
fprintf(fid,'\rWindShortTermLimit          40');
fprintf(fid,'\rWindShortTermAvPeriod        1');

% Pitch fault
% fprintf(fid,'\r');
% fprintf(fid,'\rPitchTolDeg                 1');
% fprintf(fid,'\rRunawayTimeDelay            0.16');
% fprintf(fid,'\rPitchRunawayTime1           10000');
% fprintf(fid,'\rPitchRunawayRate1           4');

% Start-up
fprintf(fid,'\r');
fprintf(fid,'\rMinimumWindForStartUp       2.5');
fprintf(fid,'\rRotorDiameter               %g',Parameters.Rotor.RotorDiameter);
fprintf(fid,'\rNStartLUT                   %i',length(Parameters.CP_TSR.LookUp.TSR));
fprintf(fid,'\rLambdaStartLUT            ');
for i = Parameters.CP_TSR.LookUp.TSR
    fprintf(fid,'%5.1f  ',i);
end
[V,I]=max(Parameters.CP_TSR.LookUp.Ct');
fprintf(fid,'\rPitchStartLUT              ');
for i = 1:size(I,2)
    fprintf(fid,'%5.1f  ',Parameters.CP_TSR.LookUp.Pitch(I(i)));
end
fprintf(fid,'\rStartPitchRate              %g',Parameters.maxPitchRate);
fprintf(fid,'\rStartSpeed                  4');
fprintf(fid,'\r');

fclose(fid);
