function Parameters = ComputeEnvelopeForSpanwise(FLAG,Parameters)

%% Define nondimensional coordinates of sensors
eta_sensors     =   linspace(0,0.9,10);
n_blades        =   3;

%% create set of required sensors
sensors_spanwise =   CreateListOfSensorsForSpanwise(eta_sensors,n_blades);


%% Read or load (if available) MDT
 for iDLC = 1:size(Parameters.DLC.Run,1)
            if (~FLAG.DeleteMatFile)
                try
                    load(strcat(Parameters.DLC.Run{iDLC},'_MDT_new.mat'));
                    Parameters.MDT{iDLC}=MDT;
                    fprintf('\n>>>>>>>>>>>>>> LOADING MAT FILES %s\n',strcat(Parameters.DLC.Run{iDLC},'_MDT_new.mat'));
                catch
                    Parameters = RunMDTReadAnalysis(Parameters,iDLC);
                end
            else
                Parameters = RunMDTReadAnalysis(Parameters,iDLC);
            end
 end
 
%% Create envelope
 
for i_sens = 1:length(sensors_spanwise)
      isensor_name              = sensors_spanwise{i_sens};
      Envelope.(isensor_name)   = ComputeMatrixEnvelopeForSpanwise(Parameters,isensor_name);
end
 

%% Post Process Data
spanwise_loads = CreateOutputForSpanwise(eta_sensors,n_blades,Envelope);
pause(3)

%% Update structural excel with loads
UpdateStructuralInputForSpanwise(spanwise_loads);
 