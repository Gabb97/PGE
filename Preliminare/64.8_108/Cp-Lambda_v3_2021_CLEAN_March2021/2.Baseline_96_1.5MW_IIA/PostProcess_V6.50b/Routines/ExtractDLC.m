function DLC = ExtractDLC(FULL_DLC,FULL_MDT,SensorN,rotate)


DLC.DLCName = FULL_DLC.Run;                %% NEW
DLC.DynamicSimulationNb = length(FULL_DLC.Run);
DLC.SafetyFactor = FULL_DLC.Safety;
DLC.InitialTime = FULL_DLC.InitTime;
DLC.FinalTime = FULL_DLC.EndTime;

if rotate %CHANGE REFERENCE ***********************************************
    
    %% Envelope
    for is=1:SensorN
        % Change lines
        TEMP( 1,:) =  FULL_DLC.Envelope{is}( 3,:);
        TEMP( 2,:) =  FULL_DLC.Envelope{is}( 4,:);
        TEMP( 3,:) =  FULL_DLC.Envelope{is}( 5,:);
        TEMP( 4,:) =  FULL_DLC.Envelope{is}( 6,:);
        TEMP( 5,:) =  FULL_DLC.Envelope{is}( 1,:);
        TEMP( 6,:) =  FULL_DLC.Envelope{is}( 2,:);
        TEMP( 7,:) =  FULL_DLC.Envelope{is}( 9,:);
        TEMP( 8,:) =  FULL_DLC.Envelope{is}(10,:);
        TEMP( 9,:) =  FULL_DLC.Envelope{is}(11,:);
        TEMP(10,:) =  FULL_DLC.Envelope{is}(12,:);
        TEMP(11,:) =  FULL_DLC.Envelope{is}( 7,:);
        TEMP(12,:) =  FULL_DLC.Envelope{is}( 8,:);
        % Change columnd and sign
        TEMP2( :,1) = -TEMP( :,2);
        TEMP2( :,2) =  TEMP( :,3);
        TEMP2( :,3) = -TEMP( :,1);
        TEMP2( :,4) = -TEMP( :,5);
        TEMP2( :,5) =  TEMP( :,6);
        TEMP2( :,6) = -TEMP( :,4);
        % Swith lines to account for min/max switched when a minus occours
        DLC.Envelope{is}( 1,:) = TEMP2( 2,:);
        DLC.Envelope{is}( 2,:) = TEMP2( 1,:);
        DLC.Envelope{is}( 3,:) = TEMP2( 3,:);
        DLC.Envelope{is}( 4,:) = TEMP2( 4,:);
        DLC.Envelope{is}( 5,:) = TEMP2( 6,:);
        DLC.Envelope{is}( 6,:) = TEMP2( 5,:);
        DLC.Envelope{is}( 7,:) = TEMP2( 8,:);
        DLC.Envelope{is}( 8,:) = TEMP2( 7,:);
        DLC.Envelope{is}( 9,:) = TEMP2( 9,:);
        DLC.Envelope{is}(10,:) = TEMP2(10,:);
        DLC.Envelope{is}(11,:) = TEMP2(12,:);
        DLC.Envelope{is}(12,:) = TEMP2(11,:);
        
    end
    
    %% LoadCase
    for is=1:SensorN
        DLC.LoadCase{is}( 1,:) = FULL_DLC.LoadCase{is}( 4,:);
        DLC.LoadCase{is}( 2,:) = FULL_DLC.LoadCase{is}( 3,:);
        DLC.LoadCase{is}( 3,:) = FULL_DLC.LoadCase{is}( 5,:);
        DLC.LoadCase{is}( 4,:) = FULL_DLC.LoadCase{is}( 6,:);
        DLC.LoadCase{is}( 5,:) = FULL_DLC.LoadCase{is}( 2,:);
        DLC.LoadCase{is}( 6,:) = FULL_DLC.LoadCase{is}( 1,:);
        DLC.LoadCase{is}( 7,:) = FULL_DLC.LoadCase{is}(10,:);
        DLC.LoadCase{is}( 8,:) = FULL_DLC.LoadCase{is}( 9,:);
        DLC.LoadCase{is}( 9,:) = FULL_DLC.LoadCase{is}(11,:);
        DLC.LoadCase{is}(10,:) = FULL_DLC.LoadCase{is}(12,:);
        DLC.LoadCase{is}(11,:) = FULL_DLC.LoadCase{is}( 8,:);
        DLC.LoadCase{is}(12,:) = FULL_DLC.LoadCase{is}( 7,:);
    end
    %% TimeHistories
    for idlc=1:length(FULL_DLC.Run)
        DLC.TimeHistories(idlc).Time = FULL_MDT{idlc}.Time;
        DLC.TimeHistories(idlc).RotorSpeed = FULL_MDT{idlc}.RotorSpeed;
        DLC.TimeHistories(idlc).Pitch1 = FULL_MDT{idlc}.Pitch;
        for ib=1:3
            for is=1:SensorN
                DLC.TimeHistories(idlc).Blade(ib).Fx(:,is) = -FULL_MDT{idlc}.Blade{ib}.Fy{is};
                DLC.TimeHistories(idlc).Blade(ib).Fy(:,is) =  FULL_MDT{idlc}.Blade{ib}.Fz{is};
                DLC.TimeHistories(idlc).Blade(ib).Fz(:,is) = -FULL_MDT{idlc}.Blade{ib}.Fx{is};
                DLC.TimeHistories(idlc).Blade(ib).Mx(:,is) = -FULL_MDT{idlc}.Blade{ib}.My{is};
                DLC.TimeHistories(idlc).Blade(ib).My(:,is) =  FULL_MDT{idlc}.Blade{ib}.Mz{is};
                DLC.TimeHistories(idlc).Blade(ib).Mz(:,is) = -FULL_MDT{idlc}.Blade{ib}.Mx{is};
            end
        end
    end
    
else %DO NOT CHANGE REFERENCE *********************************************
    
    try
        DLC.Envelope = FULL_DLC.Envelope;
    DLC.LoadCase = FULL_DLC.LoadCase
    DLC.TimeHistories = FULL_MDT;
    catch
        keyboard
    end
end

%% FailureIndex
% DLC.FailureIndex = FULL_DLC.FailureIndex;

return
