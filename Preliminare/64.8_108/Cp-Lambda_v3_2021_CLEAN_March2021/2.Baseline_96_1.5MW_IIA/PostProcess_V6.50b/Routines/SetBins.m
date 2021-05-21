function [VertexSignalValues,MiddleSignalValues] = SetBins(Parameters,iSensor,CompNumb,NBin)


% Find max/min values of the sensor between all the simulations
for iDLC = 1:size(Parameters.DLC.Run,1)
    try
        iStart = find(Parameters.MDT{iDLC}.Time >= Parameters.DLC.InitTime(iDLC),1,'first');
    catch
        fprintf('\n*** ERROR in DLC %i [%s]!!\n',iDLC,Parameters.DLC.Run{iDLC});
        keyboard
    end
    iEnd   = find(Parameters.MDT{iDLC}.Time <= Parameters.DLC.EndTime(iDLC),1,'last');
    
    Signal.time    = Parameters.MDT{iDLC}.Time(iStart:iEnd);

    % Extract Sensor time history
    mdt_temp = getfield(Parameters.MDT{iDLC},Parameters.SensorList{iSensor,1});
    Signal.history = mdt_temp.TimeHistories(iStart:iEnd,CompNumb);
   
    try
        [maxSignal(iDLC,:), timeMaxSignal(iDLC,:)]  =  max(Signal.history*Parameters.DLC.Safety(iDLC)); % max for every DLCs times its safety factor
    catch
        iDLC
        keyboard
    end
    [minSignal(iDLC,:), timeMinSignal(iDLC,:)]  =  min(Signal.history*Parameters.DLC.Safety(iDLC)); % min for every DLCs times its safety factor

    % Add iStart
    timeMaxSignal(iDLC,:) = timeMaxSignal(iDLC,:) + iStart - 1;
    timeMinSignal(iDLC,:) = timeMinSignal(iDLC,:) + iStart - 1;
end
GlobalMaxSignal = max(maxSignal);
GlobalMinSignal = min(minSignal);

deltaSignal = (GlobalMaxSignal-GlobalMinSignal)/NBin;
VertexSignalValues = [GlobalMinSignal:deltaSignal:GlobalMaxSignal];
MiddleSignalValues = diff(VertexSignalValues) + VertexSignalValues(1:end-1);

% figure
% plot(Signal.time,Signal.history)
% keyboard
return
