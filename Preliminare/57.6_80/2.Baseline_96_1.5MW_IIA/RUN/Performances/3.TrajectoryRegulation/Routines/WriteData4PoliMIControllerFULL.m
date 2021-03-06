function [] = WriteData4PoliMIControllerFULL(Parameters,FileName,ControllerFileNameWT,print_flag,AddLQRPoints,symb)



% Parameters.LQR.LQRTrimWinds = [Parameters.minWindSpeed:0.5:Parameters.maxWindSpeed];

% index: Parameters.CP_TSR.Indexes = [i j k];
% omega_rpm_short   =   Parameters.CP_TSR.Omega(1:5:90)*30/pi;
% torque_knm_short  =   Parameters.CP_TSR.Torque(1:5:90)/1000;
omega_rpm_short   =   Parameters.CP_TSR.Omega(1:2:Parameters.CP_TSR.Indexes+2)*30/pi;
torque_knm_short  =   Parameters.CP_TSR.Torque(1:2:Parameters.CP_TSR.Indexes+2)/1000;

[~, ii]    =   unique(omega_rpm_short);

OMEGA_RPM   =   omega_rpm_short(ii);
TORQUE_kNm  =   torque_knm_short(ii);


OMEGA_RPM   =   [0 OMEGA_RPM      1.2*OMEGA_RPM(end)];
TORQUE_kNm  =   [0 TORQUE_kNm     TORQUE_kNm(end)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% PRINT AND SAVE FOR POLIWIND CONTROLLERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
WindVector      =   Parameters.LQR.LQRTrimWinds;
PitchVector     =   spline(Parameters.CP_TSR.Winds,Parameters.CP_TSR.pitch,WindVector);       %% deg
OmegaVector     =   spline(Parameters.CP_TSR.Winds,Parameters.CP_TSR.Omega,WindVector);       %% deg/s
TorqueVector    =   spline(Parameters.CP_TSR.Winds,Parameters.CP_TSR.Torque,WindVector);     %% Nm

%%% Compute minimum pitch
% I've modified this part to avoid some pitch saturation errors occurred 
% last year #LS
minPitch            =   PitchVector;
GoodPitchIndexes    =   find(PitchVector>Parameters.CP_TSR.pitch(Parameters.CP_TSR.Indexes(2)));    % I find all the index in Region 3
index_region3_first =   GoodPitchIndexes(1);
[dummy,ind]         =   max(diff(GoodPitchIndexes));                                                % find the second intersections



% Minimum pitch is computed as a fraction of the optimal % pitch

pitch_coeff         =   0.7;
pitch_delta         =   2;      %[deg]

for iipitch=index_region3_first:length(PitchVector)
    if PitchVector(iipitch)>0
        minPitch(iipitch) = PitchVector(iipitch)*pitch_coeff;
    else
        minPitch(iipitch) = PitchVector(iipitch)/pitch_coeff;
    end
end

% Then (if needed), a uniform delta is added (this is strongly recommended
% for the use with the LQR controller)
minPitch = minPitch - pitch_delta;


% I add a figure here to check if the minimum pitch has been correctly
% defined #LS
figure(199);  set(gcf, 'Name','Scheduled minimum pitch', 'NumberTitle','off')
hold on; grid on;
plot(WindVector,PitchVector,'r','LineWidth',2.0)
plot(WindVector,minPitch,'b','LineWidth',2.0)
lg=legend('Optimal pitch','Minimum pitch','location','NorthWest');
lg.FontSize = 12;
xlabel('Wind Speed [m/s]','FontSize',12)
ylabel('Pitch Angle [deg]','FontSize',12)



%% Figures
figure(100);  set(gcf, 'Name','PitchTorqueOmega VS Wind', 'NumberTitle','off')
if AddLQRPoints
    subplot(3,1,1)
    hp=plot(WindVector,OmegaVector*30/pi,symb);
    set (hp,'LineWidth',2);
    subplot(3,1,2)
    hp=plot(WindVector,PitchVector,symb);
    set (hp,'LineWidth',2);
    hp=plot(WindVector,minPitch,'-d');
    set (hp,'LineWidth',1);
    subplot(3,1,3)
    hp=plot(WindVector,TorqueVector/1000,symb);
    set (hp,'LineWidth',2);
end
%% SAVE and PRINT
if print_flag
    print('-djpeg','.\Output\Figures\PitchTorqueOmega.jpg');
    print('-depsc','.\Output\Figures\PitchTorqueOmega.eps');
    save('.\Output\Figures\PitchTorqueOmega.mat','WindVector','PitchVector','TorqueVector','OmegaVector');
end

%% Figures
figure(110);  set(gcf, 'Name','PitchTorqueOmegaZOOM VS Wind', 'NumberTitle','off')
if AddLQRPoints
    hp=plot(WindVector,PitchVector,symb);
    set (hp,'LineWidth',2);
    % hp=plot(WindVector,minPitch,'-d');
    % set (hp,'LineWidth',1);
end
%% SAVE and PRINT
if print_flag
    print('-djpeg','.\Output\Figures\PitchTorqueOmegaZOOMPitch.jpg');
    print('-depsc','.\Output\Figures\PitchTorqueOmegaZOOMPitch.eps');
end

%% Figure
figure(1000);  set(gcf, 'Name','TorquePower VS Wind', 'NumberTitle','off')
if AddLQRPoints
    subplot(2,1,1)
    hp=plot(WindVector,TorqueVector/1000,symb);
    set (hp,'LineWidth',2);
    subplot(2,1,2)
    hp=plot(WindVector,TorqueVector.*OmegaVector/1000,symb);
    set (hp,'LineWidth',2);
end
%% PRINT
if print_flag
    print('-djpeg','.\Output\Figures\TorquePower.jpg');
    print('-depsc','.\Output\Figures\TorquePower.eps');
end

%% Figure
figure(10000);  set(gcf, 'Name','Power VS Wind', 'NumberTitle','off')
if AddLQRPoints
    hp=plot(WindVector,TorqueVector.*OmegaVector/1000,symb);
    set (hp,'LineWidth',2);
end
%% PRINT
if print_flag
    print('-djpeg','.\Output\Figures\rominalPowerCurve.jpg');
    print('-depsc','.\Output\Figures\rominalPowerCurve.eps');
end


%% Write Reference conditions for LQR 
fid = fopen(FileName,'w');
if fid<0
    fprintf('Unable to open %s file!!',FileName);
    return
end

% Write time
time = fix(clock);
fprintf(fid,'\r');
fprintf(fid,'%% generated by WriteData4PoliMIControllerFULL.m on %s at %s:%s:%s\r',date,num2str(time(4)),num2str(time(5)),num2str(time(6)));
fprintf(fid,'\r');
fprintf(fid,'\r');
fprintf(fid,'\r');

% Write LQR trim states
fprintf(fid,'\rCLQR.Wind = [');
for iw=1:length(WindVector)
    fprintf(fid,'%g   ',WindVector(iw));
end
fprintf(fid,'];');
for iw=1:length(WindVector)
    fprintf(fid,'\rRefCond( %2i,:) = [%1.5e   %1.5e   %1.5e   %1.5e   %1.5e   %1.5e   ];',iw,0,0,OmegaVector(iw),PitchVector(iw)*pi/180,0,TorqueVector(iw));
end

fclose(fid);

%% Write FULL Controller Description files
WriteControllerDescriptionWT
% WriteControllerDescriptionStatic

