function [OUTPUT] = ComputeMatrixEnvelope(Parameters,iSensor,RankingFlag)

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
        mdt_temp = getfield(Parameters.MDT{iDLC},Parameters.SensorList{iSensor,1});
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



%% LOAD RANKING
if (RankingFlag>0)
    % sort MAX loads for all componenents
    for iComponent = 1:length(Parameters.SensorList{iSensor,2})
        % find sensor component
        indexComp = Parameters.SensorList{iSensor,2}(iComponent);
        % sort maxs
        [OutputFull.MAX.Matrix(:,iComponent) OutputFull.MAX.Index(:,iComponent)] = sort(maxSignal(:,indexComp),1,'descend');
        % sort dlc names
        OutputFull.MAX.Run{:,iComponent} = Parameters.DLC.Run(OutputFull.MAX.Index(:,iComponent));
        % sort SF
        OutputFull.MAX.Safety(:,iComponent) = Parameters.DLC.Safety(OutputFull.MAX.Index(:,iComponent)) ;
        % sort time
        for iDLC = 1:size(Parameters.DLC.Run,1)
            DLCIndex = OutputFull.MAX.Index(iDLC,iComponent);
            OutputFull.MAX.Time(iDLC,iComponent) = Parameters.MDT{DLCIndex}.Time(timeMaxSignal(DLCIndex,iComponent));
        end
        % save Extensions & Units
        OutputFull.MAX.Extensions{iComponent} = mdt_temp.Extensions{indexComp} ;
        OutputFull.MAX.Units{iComponent} = mdt_temp.Units{indexComp} ;
    end
    
    % sort MIN loads for all componenents
    for iComponent = 1:length(Parameters.SensorList{iSensor,2})
        % find sensor component
        indexComp = Parameters.SensorList{iSensor,2}(iComponent);
        % sort maxs
        [OutputFull.MIN.Matrix(:,iComponent) OutputFull.MIN.Index(:,iComponent)] = sort(minSignal(:,indexComp),1,'ascend');
        % sort dlc names
        OutputFull.MIN.Run{:,iComponent} = Parameters.DLC.Run(OutputFull.MIN.Index(:,iComponent));
        % sort SF
        OutputFull.MIN.Safety(:,iComponent) = Parameters.DLC.Safety(OutputFull.MIN.Index(:,iComponent)) ;
        % sort time
        for iDLC = 1:size(Parameters.DLC.Run,1)
            DLCIndex = OutputFull.MIN.Index(iDLC,iComponent);
            OutputFull.MIN.Time(iDLC,iComponent) = Parameters.MDT{DLCIndex}.Time(timeMaxSignal(DLCIndex,iComponent));
        end
        % save Extensions & Units
        OutputFull.MIN.Extensions{iComponent} = mdt_temp.Extensions{indexComp} ;
        OutputFull.MIN.Units{iComponent} = mdt_temp.Units{indexComp} ;
    end
    
    % sort ABS MAX/MIN loads for all componenents
    for iComponent = 1:length(Parameters.SensorList{iSensor,2})
        % find sensor component
        indexComp = Parameters.SensorList{iSensor,2}(iComponent);
        % sort abs max & abs min
        [OutputFull.ABS.Matrix(:,iComponent) OutputFull.ABS.Index(:,iComponent)] = sort([abs(maxSignal(:,indexComp)) ;  abs(minSignal(:,indexComp))],1,'descend');
        % sort dlc names
        RunDouble = [Parameters.DLC.Run ; Parameters.DLC.Run];
        OutputFull.ABS.Run{:,iComponent} = RunDouble(OutputFull.ABS.Index(:,iComponent));
        % sort SF
        SafetyDouble = [Parameters.DLC.Safety ; Parameters.DLC.Safety];
        OutputFull.ABS.Safety(:,iComponent) = SafetyDouble(OutputFull.ABS.Index(:,iComponent)) ;
        % sort time
        for iDLC = 1:2*size(Parameters.DLC.Run,1)
            DLCIndex = OutputFull.ABS.Index(iDLC,iComponent);
            if (DLCIndex <= size(Parameters.DLC.Run,1))
                OutputFull.ABS.Time(iDLC,iComponent) = Parameters.MDT{DLCIndex}.Time(timeMaxSignal(DLCIndex,iComponent));
            else
                DLCIndex = DLCIndex - size(Parameters.DLC.Run,1);
                OutputFull.ABS.Time(iDLC,iComponent) = Parameters.MDT{DLCIndex}.Time(timeMinSignal(DLCIndex,iComponent));
            end
        end
        % save Extensions & Units
        OutputFull.ABS.Extensions{iComponent} = mdt_temp.Extensions{indexComp} ;
        OutputFull.ABS.Units{iComponent} = mdt_temp.Units{indexComp} ;
    end
    
    OUTPUT = OutputFull;
    %% ASSEMBLING THE ENVELOPE MATRIX
else
    [MaxGlobalSignal,indMaxGlobalSignal] = max(maxSignal);
    [MinGlobalSignal,indMinGlobalSignal] = min(minSignal);
    
    Sequence =  Parameters.SensorList{iSensor,2};

    for ii = 1:length(Sequence)
        indexComp = Sequence(ii);
        
        % MAX
        iLine = 1 + (ii-1)*2;
        
        indexDLC  = indMaxGlobalSignal(indexComp);
        indexTime = timeMaxSignal(indexDLC,indexComp);
        
        mdt_temp = getfield(Parameters.MDT{indexDLC},Parameters.SensorList{iSensor,1});
        OUTPUT.Matrix(iLine,:) = mdt_temp.TimeHistories(indexTime,Sequence)*Parameters.DLC.Safety(indexDLC);
        OUTPUT.LoadCase(iLine,:) = {Parameters.DLC.Run{indexDLC} Parameters.MDT{indexDLC}.Time(indexTime) Parameters.DLC.Safety(indexDLC)};
        
        % MIN
        iLine = iLine + 1;
        indexDLC  = indMinGlobalSignal(indexComp);
        indexTime = timeMinSignal(indexDLC,indexComp);
        
        mdt_temp = getfield(Parameters.MDT{indexDLC},Parameters.SensorList{iSensor,1});
        OUTPUT.Matrix(iLine,:) = mdt_temp.TimeHistories(indexTime,Sequence)*Parameters.DLC.Safety(indexDLC);
        OUTPUT.LoadCase(iLine,:) = {Parameters.DLC.Run{indexDLC} Parameters.MDT{indexDLC}.Time(indexTime) Parameters.DLC.Safety(indexDLC)};
        
        OUTPUT.Extensions{ii} = mdt_temp.Extensions{Sequence(ii)};
        OUTPUT.Units{ii} = mdt_temp.Units{Sequence(ii)};
        
    end
end

return

