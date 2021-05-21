function [RainFlowStruct]=RunRainFlowAnalysis(Time,Sensor,ExtraParameters,Range)

%%%%%%%%%%%%%% RAINFLOW ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% RAINFLOW ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% RAINFLOW ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% RAINFLOW ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ifile = 1;

% ALEALE update 09.Oct.2014. Add to improve DELs computation
FACT = 2;

%%% Sensor
RainFlowStruct.SimTime = Time;
RainFlowStruct.SensorLoad(1,:) = Sensor;

% Extra Parameters
InputFile.RainFlowEqvLoadsSlope = 1./ExtraParameters.m;
InputFile.RainFlowEqvLoadsFreq  = ExtraParameters.EqvFreq;
InputFile.RainFlowNumbBins      = ExtraParameters.RainFlowNumbBins;

if nargin>3 %% ALEALE NEW for Markov! 01.12.210
    InputFile.RainFlowMinRange = min(Range);
    InputFile.RainFlowMaxRange = max(Range);
else
    InputFile.RainFlowMinRange = min(Sensor);
    InputFile.RainFlowMaxRange = max(Sensor);
end

% ALEALE update 09.Oct.2014
if (InputFile.RainFlowMinRange<0)
    InputFile.RainFlowMinRange = InputFile.RainFlowMinRange*FACT;
else
    InputFile.RainFlowMinRange = InputFile.RainFlowMinRange/FACT;
end
if (InputFile.RainFlowMaxRange>0)
    InputFile.RainFlowMaxRange = InputFile.RainFlowMaxRange*FACT;
else
    InputFile.RainFlowMaxRange = InputFile.RainFlowMaxRange/FACT;
end

%%%
RainFlowStruct = RainflowAnalysis(RainFlowStruct,InputFile);

return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [RainFlowStructNew] = RainflowAnalysis(RainFlowStruct,InputFile)

% From RainFlowFindSensors:
%
% RainFlowStruct.SensorLoad(i_mm_sens,:) = Sensor.MdtValues{i_all_sens}(InputFile.RainFlowSensorsListComponent{i_mm_sens},:); 
% RainFlowStruct.SimTime = Sensor.MdtTime; 
% 

% from RAINFLOW
%
% 'Row 1: amplitude' ---> to have the range=Row1*2
% 'Row 2: mean'      ---> ratio R = value_min/value_max
% 'Row 3: number of cycles (cycle or half cycle)'
% % % disp('Row 4: begin time of extracted cycle or half cycle')
% % % disp('Row 5: period of a cycle')   

sigtime = RainFlowStruct.SimTime;

Ttime = sigtime(end)-sigtime(1);

for i_sens=1:size(RainFlowStruct.SensorLoad,1)
    sigvalue = RainFlowStruct.SensorLoad(i_sens,:);

    % estrazione estremi
    sigext = sig2ext(sigvalue, sigtime);

    % counting cycle
    RainFlowStructNew.RainFlowCyclesCountingMatrix{i_sens} = rainflow(sigext,1);

    [RainFlowStructNew.MeanVect{i_sens},...
     RainFlowStructNew.RangeVect{i_sens},...
     RainFlowStructNew.Ncycle{i_sens},...
     RainFlowStructNew.Nrange{i_sens},...
     RainFlowStructNew.NrangeCum{i_sens},...
     RainFlowStructNew.EqvLoads{i_sens}] = PostProcessFatigue(RainFlowStructNew.RainFlowCyclesCountingMatrix{i_sens},InputFile,Ttime);
    
end
RainFlowStructNew.SimTime    = RainFlowStruct.SimTime;
RainFlowStructNew.Ttime      = Ttime;
RainFlowStructNew.SensorLoad = RainFlowStruct.SensorLoad;

return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X_mean,X_range,Ncycle,Nrange,Nrange_cum,Leqtot] = PostProcessFatigue(matrix,InputFile,Ttime)

m = 1./InputFile.RainFlowEqvLoadsSlope;

row1=matrix(1,:)*2;     % RANGE
row2=matrix(2,:);       % MEAN VALUE
row3=matrix(3,:);       % Number of cycles for this DLC
% row3=matrix(3,:)*InputFile.RainFlowNumbFreqYear*InputFile.RainFlowNumbYears;

% % % max range
% % max_range = max(row1);
% % 
% % % Check
% % if (InputFile.RainFlowMinRange>max_range)
% %     InputFile.RainFlowMinRange=0;
% %     fprintf(1,'Warning! MinimumRange is too high!');
% %     fprintf(1,'         A zero value is used!');
% % end

% extremes of the range             %% ALEALE NEW for Markov! 01.12.210
max_range = max(abs([InputFile.RainFlowMinRange InputFile.RainFlowMaxRange]));
min_range = 0;

N_range = floor(InputFile.RainFlowNumbBins*2);             % I use more bins here!
% d_range = (max_range-InputFile.RainFlowMinRange)/N_range;
% X_range = [InputFile.RainFlowMinRange:d_range:N_range*d_range];
d_range = (max_range-min_range)/N_range; %% ALEALE NEW for Markov! 01.12.210
X_range = [min_range:d_range:N_range*d_range];

% max and min mean value %% ALEALE NEW for Markov! 01.12.210
% max_mean = max(row2);
% min_mean = min(row2);
max_mean = InputFile.RainFlowMaxRange;
min_mean = InputFile.RainFlowMinRange;

N_mean = InputFile.RainFlowNumbBins;
d_mean = (max_mean-min_mean)/N_mean;
X_mean = [min_mean:d_mean:max_mean];

for i_range = 2:length(X_range)
    
    % find amplitude in between the tabulated amplitude 
    ii_range = find((row1<=X_range(i_range))&(row1>X_range(i_range-1)));
    
    % n of cycle at the amplitude (not depending on the mean value)
    Nrange(i_range)=sum(row3(ii_range));
    
    for i_mean=2:length(X_mean)
        
        kk_mean = find((row2(ii_range)<=X_mean(i_mean))&(row2(ii_range)>X_mean(i_mean-1)));
        
        % number of cycle grouped by tne mean value
        Ncycle(i_range,i_mean) = sum(row3(ii_range(kk_mean)));
        clear kk_mean
        
    end
    clear ii_range
end

for i_m=1:length(m)
    % equivalent load for every mean value
    for i_mean = 2:length(X_mean)
        
        if sum(Ncycle(:,i_mean)) == 0
            Leq(i_m,i_mean)=0;
        else
            Leq(i_m,i_mean)=(sum((X_range.^(m(i_m))).*Ncycle(:,i_mean)'./sum(Ncycle(:,i_mean))))^(1/(m(i_m))); 
        end
        
    end
    
    % equivalent load 
    % Original from HJSutherland
    % Leqtot2(i_m)=(sum((X_range.^(m(i_m))).*Nrange./sum(Nrange)))^(1/(m(i_m)));
    % From Bladed Manual:
    Leqtot(i_m)= ( sum((X_range.^(m(i_m))).*Nrange) ./ (Ttime*InputFile.RainFlowEqvLoadsFreq) )^((1/m(i_m)));
    
end

% Cumulative cycles
for i_range=1:length(X_range)
    Nrange_cum(i_range) = sum(Nrange(i_range:end));
end

% figure;
% plot(X_range(2:end)-d_range/2,Nrange(2:end));grid on;xlabel('range');ylabel('numb');
% 
% figure;
% semilogx(Nrange_cum,X_range-d_range/2);grid on;xlabel('cum cycles');ylabel('range');
% 
% figure;
% surf(X_mean,X_range,Ncycle);xlabel('mean');ylabel('ampl');zlabel('numb cycles')
% 
% figure;
% plot(1./m,Leqtot)%,1./m,Leqtot2,'.-b')
% 

return


