function  [Parameters] = PostProcessRainflowData(Parameters)


%% Compute DEL weighted with the Weibull Fe = (sum(Fi^m*N)/N0) ^ (1/m)
% 1) Set to zero
% DELWeibull = zeros(size(Parameters.SensorList,1),length(Parameters.SensorList{iSensor,2}),length(Parameters.Fatigue.m))

for iSensor = 1:size(Parameters.SensorList,1)
    for iComp = 1:length(Parameters.SensorList{iSensor,2})
        for im = 1:length(Parameters.Fatigue.m)
            Parameters.Fatigue.DELWeibull{iSensor,iComp}(im) = 0;
        end
    end
end

% 2) sum Fi^m*N
for idlc=1:length(Parameters.DLC.Run)
    for iSensor = 1:size(Parameters.SensorList,1)
        for iComp = 1:length(Parameters.SensorList{iSensor,2})
            RF = Parameters.Rainflow{idlc}(iSensor,iComp);
            for im = 1:length(Parameters.Fatigue.m)
                Parameters.Fatigue.DELWeibull{iSensor,iComp}(im) = Parameters.Fatigue.DELWeibull{iSensor,iComp}(im) + Parameters.WeibullStruct.N(idlc)*RF.EqvLoads{1}(im)^Parameters.Fatigue.m(im);
            end
        end
    end
end
% 3) divide by No and exp (1/m)
for iSensor = 1:size(Parameters.SensorList,1)
    for iComp = 1:length(Parameters.SensorList{iSensor,2})
        for im = 1:length(Parameters.Fatigue.m)
            Parameters.Fatigue.DELWeibull{iSensor,iComp}(im) = ( Parameters.Fatigue.DELWeibull{iSensor,iComp}(im) /  Parameters.WeibullStruct.N0)^(1/Parameters.Fatigue.m(im));
        end
    end
end


%% Compute GLOBAL MARKOVs
for iSensor = 1:size(Parameters.SensorList,1)
    for iComp = 1:length(Parameters.SensorList{iSensor,2})
        % first of all copy the Markov from the first dlc
        idlc = 1;
        RF = Parameters.Rainflow{idlc}(iSensor,iComp);
        Parameters.Fatigue.TOTMarkov{iSensor,iComp}.NrangeCum = RF.NrangeCum{1};
        Parameters.Fatigue.TOTMarkov{iSensor,iComp}.Ncycle    = RF.Ncycle{1};
        Parameters.Fatigue.TOTMarkov{iSensor,iComp}.Mean      = RF.MeanVect{1};
        Parameters.Fatigue.TOTMarkov{iSensor,iComp}.Range     = RF.RangeVect{1};
        Parameters.Fatigue.TOTMarkov{iSensor,iComp}.TotTime   = RF.Ttime;
        % then sum the other dlcs
        for idlc=2:length(Parameters.DLC.Run)
            RF = Parameters.Rainflow{idlc}(iSensor,iComp);
            Parameters.Fatigue.TOTMarkov{iSensor,iComp}.TotTime   = Parameters.Fatigue.TOTMarkov{iSensor,iComp}.TotTime + RF.Ttime;
            Parameters.Fatigue.TOTMarkov{iSensor,iComp}.NrangeCum = Parameters.Fatigue.TOTMarkov{iSensor,iComp}.NrangeCum + RF.NrangeCum{1};
            Parameters.Fatigue.TOTMarkov{iSensor,iComp}.Ncycle    = Parameters.Fatigue.TOTMarkov{iSensor,iComp}.Ncycle + RF.Ncycle{1};
        end
    end
end

%% Compute cumulative DEL from GLOBAL MARKOVs

m = Parameters.Fatigue.m;
Ttime600 = 600*sum(Parameters.WeibullStruct.N);
Ttime600_0 = 600*sum(Parameters.WeibullStruct.N0);

for iSensor = 1:size(Parameters.SensorList,1)
    for iComp = 1:length(Parameters.SensorList{iSensor,2})
        
        % Extract Global Markov
        X_range = Parameters.Fatigue.TOTMarkov{iSensor,iComp}.Range;    % RANGE
        X_mean  = Parameters.Fatigue.TOTMarkov{iSensor,iComp}.Mean;     % MEAN
        Ncycle  = Parameters.Fatigue.TOTMarkov{iSensor,iComp}.Ncycle;   % n of cycles
        Nrange  = sum(Ncycle');                                         % n of cycle at one amplitude (not depending on the mean value)
        
        Ttime = Parameters.Fatigue.TOTMarkov{iSensor,iComp}.TotTime;
        DELTATTime = (Ttime - Ttime600)/Ttime*100
        DELTATTime = (Ttime - Ttime600_0)/Ttime*100
        for i_m=1:length(m)
            % equivalent load
            % Original from HJSutherland
            % Leqtot2(i_m)=(sum((X_range.^(m(i_m))).*Nrange./sum(Nrange)))^(1/(m(i_m)));
            % From Bladed Manual:
            Parameters.Fatigue.TOTDELWeibull{iSensor,iComp}(i_m)= ( sum((X_range.^(m(i_m))).*Nrange) ./ (Ttime*Parameters.Fatigue.EqvFreq) )^((1/m(i_m)));
            
        end
        
        % Cumulative cycles
        for i_range=1:length(X_range)
            Parameters.Fatigue.TOTMarkov{iSensor,iComp}.Nrange_cum(i_range) = sum(Nrange(i_range:end));
        end
        
    end
end


return


