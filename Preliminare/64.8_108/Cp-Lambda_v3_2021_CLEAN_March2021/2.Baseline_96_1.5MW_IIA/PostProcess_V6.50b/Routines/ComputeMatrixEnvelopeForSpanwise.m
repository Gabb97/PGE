function  [OUTPUT] = ComputeMatrixEnvelopeForSpanwise(Parameters,iSensor)

%% Compute Envelope Matrix
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
    try
        mdt_temp = getfield(Parameters.MDT{iDLC},iSensor);
    catch
        keyboard
    end
    
    
    Signal.history = mdt_temp.TimeHistories(iStart:iEnd,:);
    
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


%% ASSEMBLING THE ENVELOPE MATRIX
    [MaxGlobalSignal,indMaxGlobalSignal] = max(maxSignal);
    [MinGlobalSignal,indMinGlobalSignal] = min(minSignal);
    
    Sequence = [ 1 2 3 4 5 6];

    for ii = 1:length(Sequence)
        indexComp = Sequence(ii);
        
        % MAX
        iLine       = 1 + (ii-1)*2;
        
        indexDLC    = indMaxGlobalSignal(indexComp);
        indexTime   = timeMaxSignal(indexDLC,indexComp);
        
        mdt_temp = getfield(Parameters.MDT{indexDLC},iSensor);
        OUTPUT.Matrix(iLine,:) = mdt_temp.TimeHistories(indexTime,Sequence)*Parameters.DLC.Safety(indexDLC);
        OUTPUT.LoadCase(iLine,:) = {Parameters.DLC.Run{indexDLC} Parameters.MDT{indexDLC}.Time(indexTime) Parameters.DLC.Safety(indexDLC)};
        
        % MIN
        iLine       = iLine + 1;
        indexDLC    = indMinGlobalSignal(indexComp);
        indexTime   = timeMinSignal(indexDLC,indexComp);
        
        mdt_temp = getfield(Parameters.MDT{indexDLC},iSensor);
        OUTPUT.Matrix(iLine,:) = mdt_temp.TimeHistories(indexTime,Sequence)*Parameters.DLC.Safety(indexDLC);
        OUTPUT.LoadCase(iLine,:) = {Parameters.DLC.Run{indexDLC} Parameters.MDT{indexDLC}.Time(indexTime) Parameters.DLC.Safety(indexDLC)};
        

        
        
    end
    
