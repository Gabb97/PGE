function [Parameters] = PreProcessRainflowData(Parameters)

% read/extract MDT
if (~Parameters.FLAG.PlotMDT)
    for iDLC = 1:size(Parameters.DLC.Run,1)
        if (~Parameters.FLAG.DeleteMatFile)
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
end

% read/extract SWP
for iDLC = 1:size(Parameters.DLC.Run,1)
    if (~Parameters.FLAG.PlotSWP && ~Parameters.FLAG.PlotPowerCurve)
        if (~Parameters.FLAG.DeleteMatFile)
            try
                load(strcat(Parameters.DLC.Run{iDLC},'_SWP.mat'))
                Parameters.SWP{iDLC}=SWP;
                fprintf('\n>>>>>>>>>>>>>> LOADING SWP FILES %s\n',strcat(Parameters.DLC.Run{iDLC},'_SWP.mat'));
            catch
                [Parameters] = ReadSWPFile(Parameters,iDLC);
            end
        else
            [Parameters] = ReadSWPFile(Parameters,iDLC);
        end
    end
end

% Extract weibull data
for iDLC = 1:size(Parameters.DLC.Run,1)
    if (~Parameters.FLAG.PlotPowerCurve)
        for iDLC = 1:size(Parameters.DLC.Run,1)
            
            iStart = find(Parameters.SWP{iDLC}.Time >= Parameters.DLC.InitTime(iDLC),1,'first'); if (isempty(iStart))  iStart=1;  end;
            iEnd   = find(Parameters.SWP{iDLC}.Time <= Parameters.DLC.EndTime(iDLC),1,'last');
            
            Parameters.PowerCurve.WIND(iDLC)  = mean(Parameters.SWP{iDLC}.array(iStart:iEnd,27));
            
        end
    end
end

% Extract Envelope matrix for range calculation
if (~Parameters.FLAG.EnvelopeAnalysis)
    for iSensor = 1:size(Parameters.SensorList,1)
        Parameters.Envelope{iSensor} = ComputeMatrixEnvelope(Parameters,iSensor,0);
    end
end



