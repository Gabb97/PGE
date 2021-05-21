% function Parameters = CpLambdaPostProcess()
        
clear all
close all
clc

%%
if ~isdeployed
    addpath('Routines')
    addpath('Routines_Cost_Model_NREL')
    addpath('Routines_Cost_Model_NREL\costmodel_nrel')
    addpath('Routines_Cost_Model_NREL\routines_ce')
end

%% removed common warnigs
s=warning('off','MATLAB:legend:IgnoringExtraEntries');
s=warning('off','MATLAB:tex');

%% PROMPT
prompt1={...
    'Enter the file name with the DLCs list',...
    'Enter the file name with the Sensors list',...
    'Plot Sensors Time Histories? (Yes=1, No=0)',...
    'Plot Control variables Time Hirtories? (Yes=1, No=0)',...
    'Plot Power Curve? (1Yes=1, No=0)',...
    'Compute Span-wise loads?(Yes=1, No=0)',...
    'Compute CoE? (Yes=1, No=0)',...
    'Enter path to the MB Model',...
    'Delete all old mat files? (Yes=1, No=0)',...
    };

def1={...
    'Input_DLCList_WithSF.xlsx',...         % DLC Input file
    'Input_SensorsList.xlsx',...            % Sensors Input file
    '1',...                                 % Plot time histories of sensors
    '1',...                                 % Plot time histories of controls
    '0',...                                 % Plot power curve
    '0'...                                  % Plot spanwise loads
    '0',...                                 % Plot COE
    '.\..\MB_model',...                     % Path of the MB_Model (for COE..)
    '1',...                                 % Delete old mat files
    };

dlgTitle='Cp-Lambda PostProcess';
lineNo=1;
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';

% standard inut
answer1=inputdlg(prompt1,dlgTitle,lineNo,def1,options);

prompt2={...
    'Run FFT Analysis And Plot Results? (Yes=1, No=0)',...
    'Run PSD Analysis And Plot Results? (Yes=1, No=0)',...
    'Run LDD Analysis And Plot Results? (Yes=1, No=0)',...
    'Run Rainflow Analysis And Plot Results? (Yes=1, No=0)',...
    'Enter Excel File Name for Rainflow Analysis',...
    'Run Envelope Analysis And Plot Results? (Yes=1, No=0)',...
    'Enter Excel File Name for Envelope Analysis',...
    'Number of Bin for Ranking Analysis (0=No)',...
    'Enter Excel File Name for Load Ranking',...
    };

def2={...
    '0',...                                 % Run FFT analysis
    '0',...                                 % Run PSD analysis
    '0',...                                 % Run LDD analysis
    '0',...                                 % Run Rainflow analysis (for fatigue..)
    'Rainflow.xlsx',...                     % Output file for Rainflow
    '0',...                                 % Run Envelope analysis
    'Envelope.xlsx',...                     % Output file for Envelope
    '0',...                                 % Run Sorting  
    'DLC_SORT.xlsx',...                     % Output file for Sorting
    };


% standard inut
answer2=inputdlg(prompt2,dlgTitle,lineNo,def2,options);
% if problem with the standard  input uncomment the next line

if (isempty(answer1) || isempty(answer1))
    return
end


% %% PROMPT
% prompt={...
%     'Enter the file name with the DLCs list',...
%     'Enter the file name with the Sensors list',...
%     'Plot Sensors Time Histories? (Yes=1, No=0)',...
%     'Plot Control variables Time Hirtories? (Yes=1, No=0)',...
%     'Plot Power Curve? (Yes=1, No=0)',...
%     'Compute Span-wise loads?(Yes=1, No=0)',...
%     'Compute CoE? (Yes=1, No=0)',...
%     'Enter path to the MB Model',...
%     'Run FFT Analysis And Plot Results? (Yes=1, No=0)',...
%     'Run PSD Analysis And Plot Results? (Yes=1, No=0)',...
%     'Run LDD Analysis And Plot Results? (Yes=1, No=0)',...
%     'Run Rainflow Analysis And Plot Results? (Yes=1, No=0)',...
%     'Enter Excel File Name for Rainflow Analysis',...
%     'Run Envelope Analysis And Plot Results? (Yes=1, No=0)',...
%     'Enter Excel File Name for Envelope Analysis',...
%     'Number of Bin for Ranking Analysis (0=No)',...
%     'Enter Excel File Name for Load Ranking',...
%     'Enter Figures Title',...
%     'Technical Units? (Yes=1, No=0)',...
%     'Delete all old mat files? (Yes=1, No=0)',...
%     'ShiftTime [sec]',...
%     };
% 
% def={...
%     'Input_DLCList_WithSF.xlsx',...         % DLC Input file
%     'Input_SensorsList.xlsx',...            % Sensors Input file
%     '0',...                                 % Plot time histories of sensors
%     '0',...                                 % Plot time histories of controls
%     '1',...                                 % Plot power curve
%     '0'...                                  % Plot spanwise loads
%     '0',...                                 % Plot COE
%     '.\..\MB_model',...                     % Path of the MB_Model (for COE..)
%     '0',...                                 % Run FFT analysis
%     '0',...                                 % Run PSD analysis
%     '0',...                                 % Run LDD analysis
%     '0',...                                 % Run Rainflow analysis (for fatigue..)
%     'Rainflow.xlsx',...                     % Output file for Rainflow
%     '0',...                                 % Run Envelope analysis
%     'Envelope.xlsx',...                     % Output file for Envelope
%     '0',...                                 % Run Sorting  
%     'DLC_SORT.xlsx',...                     % Output file for Sorting
%     ' ',...                                 % Enter figures title
%     '1',...                                 % Use technical units
%     '0',...                                 % Delete old mat files
%     '0',...                                 % Shift time
%     };
% 
% dlgTitle='Cp-Lambda PostProcess';
% lineNo=1;
% options.Resize='on';
% options.WindowStyle='normal';
% options.Interpreter='tex';
% 
% % standard inut
% answer=inputdlg(prompt,dlgTitle,lineNo,def,options);
% % if problem with the standard  input uncomment the next line
% % answer=def';
% if isempty(answer)
%     return
% end
% 


%% FLAG
% 1
FLAG.PlotMDT            = str2double(answer1{3});
FLAG.PlotSWP            = str2double(answer1{4});
FLAG.PlotPowerCurve     = str2double(answer1{5});
FLAG.PlotSpanwise       = str2double(answer1{6});  
FLAG.CostAnalysis       = str2double(answer1{7});
FLAG.MBModelPath        = answer1{8};
FLAG.DeleteMatFile      = str2double(answer1{9});
% 2
FLAG.FFTAnalysis        = str2double(answer2{1});
FLAG.PSDAnalysis        = str2double(answer2{2});
FLAG.LDDAnalysis        = str2double(answer2{3});
FLAG.RainFlowAnalysis   = str2double(answer2{4});
FLAG.OutputXlsRainFlow  = answer2{5};
FLAG.EnvelopeAnalysis   = str2double(answer2{6});
FLAG.OutputXls          = answer2{7};
FLAG.RankingAnalysis    = str2double(answer2{8});
FLAG.OutputXlsRanking   = answer2{9};

% 
TitleList               = '';
FLAG.TechnicalUnits     = 1;
FLAG.ShiftTime          = 0;


%% READ LIST OF DLCs and of Sensors
Parameters = ReadInputData(answer1{1},answer1{2});

%% Save FLAGS
Parameters.FLAG = FLAG;
Parameters.FLAG.FigTitle = TitleList;


%% change FLAGS for LDD and/or Fatigue loads
if (FLAG.LDDAnalysis || FLAG.RainFlowAnalysis)
    FLAG.PlotPowerCurve = 1;
end

%% SETPLOT FLAG
Parameters.FLAG.SymbList={...
%    ':k','-r','-.b','--m',':c','--k',...
%     '-r','-.b','--m',':c','--k',...
    '-r','-.b','--m',':c',...
    '-.r','-..b','--.m',':.c','--.k',...
    '-or','-.ob','--om',':oc','--ok',...
    '-dr','-.db','--dm',':dc','--dk',...
    '-sr','-.sb','--sm',':sc','--sk',...
    '-hr','-.hb','--hm',':hc','--hk',...
    '-pr','-.pb','--pm',':pc','--pk',...
    '-dr','-.db','--dm',':dc','--dk',...
    '-^r','-.^b','--^m',':^c','--^k',...
    '-<r','-.<b','--<m',':<c','--<k',...
    '->r','-.>b','-->m',':>c','-->k',...
    '-vr','-.vb','--vm',':vc','--vk',...
    '-*r','-.*b','--*m',':*c','--*k',...
    };

%% READ STANDARD DLC (MDT) ************************************************
if FLAG.PlotMDT
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
        PlotMDT(Parameters.MDT{iDLC},Parameters.SensorList,Parameters.DLC.Run,TitleList,Parameters.FLAG.SymbList{iDLC},FLAG.ShiftTime);
    end
end


%% PLOT SWP ***************************************************************
if (FLAG.PlotSWP)
    for iDLC = 1:size(Parameters.DLC.Run,1)
        if (~FLAG.DeleteMatFile)
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
        
        % PLOT 
        PlotSWPFile(Parameters.SWP{iDLC},Parameters.DLC.Run,TitleList,Parameters.FLAG.SymbList{iDLC},FLAG.ShiftTime);
        
    end
end


%% PLOT POWER CURVE ***************************************************************
if (FLAG.PlotPowerCurve)
    for iDLC = 1:size(Parameters.DLC.Run,1)
        if (~FLAG.PlotSWP)
            if (~FLAG.DeleteMatFile)
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
        
        % Compute POWER CURVE
        iStart = find(Parameters.SWP{iDLC}.Time >= Parameters.DLC.InitTime(iDLC),1,'first'); if (isempty(iStart))  iStart=1;  end;
        iEnd   = find(Parameters.SWP{iDLC}.Time <= Parameters.DLC.EndTime(iDLC),1,'last');
        
        Parameters.PowerCurve.OMEGA(iDLC) = mean(Parameters.SWP{iDLC}.array(iStart:iEnd,20));
        Parameters.PowerCurve.POWER(iDLC) = mean(Parameters.SWP{iDLC}.array(iStart:iEnd,15));
        Parameters.PowerCurve.WIND(iDLC)  = mean(Parameters.SWP{iDLC}.array(iStart:iEnd,27));
        Parameters.PowerCurve.OMEGAmin(iDLC) = min(Parameters.SWP{iDLC}.array(iStart:iEnd,20));
        Parameters.PowerCurve.POWERmin(iDLC) = min(Parameters.SWP{iDLC}.array(iStart:iEnd,15));
        Parameters.PowerCurve.OMEGAmax(iDLC) = max(Parameters.SWP{iDLC}.array(iStart:iEnd,20));
        Parameters.PowerCurve.POWERmax(iDLC) = max(Parameters.SWP{iDLC}.array(iStart:iEnd,15));
        Parameters.PowerCurve.OMEGAstd(iDLC) = std(Parameters.SWP{iDLC}.array(iStart:iEnd,20));
        Parameters.PowerCurve.POWERstd(iDLC) = std(Parameters.SWP{iDLC}.array(iStart:iEnd,15));
        
    end
    % Figure
    figure(70001);  set(gcf, 'Name','Power Curve', 'NumberTitle','off')
    hold on; grid on; zoom on;
    hp=plot(Parameters.PowerCurve.WIND,Parameters.PowerCurve.POWER/1.0E3,'-ob');
    set (hp,'LineWidth',2,'MarkerSize',10);
    hx=xlabel('Wind Speed[m/s]');       set (hx,'FontSize',12,'FontWeight','bold');
    hy=ylabel('Electrical Power [kW]'); set (hy,'FontSize',12,'FontWeight','bold');
    ht=title('POWER CURVE');           set (ht,'FontSize',12,'FontWeight','bold');
    axis([-Inf Inf 0 max(Parameters.PowerCurve.POWER/1.0E3)*1.05])
    
    figure(70002);  set(gcf, 'Name','Power Curve Statistic', 'NumberTitle','off')
    hold on; grid on; zoom on;
    hp=plot(Parameters.PowerCurve.WIND,Parameters.PowerCurve.POWER/1.0E3,'-ob');
    set (hp,'LineWidth',2,'MarkerSize',10);
    hp=plot(Parameters.PowerCurve.WIND,Parameters.PowerCurve.POWERmin/1.0E3,'pr');
    set (hp,'LineWidth',2,'MarkerSize',8);
    hp=plot(Parameters.PowerCurve.WIND,Parameters.PowerCurve.POWERmax/1.0E3,'sm');
    set (hp,'LineWidth',2,'MarkerSize',8);
    hp=plot(Parameters.PowerCurve.WIND,Parameters.PowerCurve.POWERstd/1.0E3,'.c');
    set (hp,'LineWidth',2,'MarkerSize',10);
    hx=xlabel('Wind Speed[m/s]');       set (hx,'FontSize',12,'FontWeight','bold');
    hy=ylabel('Electrical Power [kW]'); set (hy,'FontSize',12,'FontWeight','bold');
    ht=title('POWER CURVE');           set (ht,'FontSize',12,'FontWeight','bold');
    axis([-Inf Inf 0 max(Parameters.PowerCurve.POWERmax/1.0E3)*1.05])
    legend('Power','Min','Max','Std')

    
    % Compute AEP
    INPUT_Fatigue_and_Weibull_Data   % load Data
      
    % Send status
    disp(' ' )
    disp('Computing Annual Energy Production........')
    Parameters.WeibullStruct.AEP     = Parameters.WeibullStruct.integTime*trapz(Parameters.WeibullStruct.MeanWindSpeed,Parameters.WeibullStruct.pw.*Parameters.PowerCurve.POWER);
    fprintf('\nAEP = %1.5e [GWh]\n',Parameters.WeibullStruct.AEP/1.0e9);
    
end

%% Cost of Energy Analysis ***************************************************************
if (FLAG.CostAnalysis)
    
    % Check if AEP is available. If not, the program will ask.
    aep = [];
    try
    	aep = Parameters.WeibullStruct.AEP;
    catch
        
    end
    
    % Run Cost Eval subroutines
    CostEval_NREL(aep,FLAG.MBModelPath);
        
end

%% Plot spanwise sensors ***************************************************************
if (FLAG.PlotSpanwise)
    
    % Compute envelope of spanwise sensors
    ComputeEnvelopeForSpanwise(FLAG,Parameters);
    
    
end


%% FFT ********************************************************************
if FLAG.FFTAnalysis
    fprintf('\n>>>>>>>>>>>>>> COMPUTING FFT\n');
    % FFT Parameters
    Par.MAXSTEP = 2^16;
    Par.NNN     = 1;
    
    for iDLC = 1:size(Parameters.DLC.Run,1)
        Parameters.FFT(:,iDLC) = PlotFFTAnalysis(Parameters,iDLC,Parameters.DLC.Run,TitleList,Parameters.FLAG.SymbList{iDLC},Par);
    end
end

%% PSD ********************************************************************
if FLAG.PSDAnalysis
    fprintf('\n>>>>>>>>>>>>>> COMPUTING PSD\n');
    % PSD Parameters
    Par.NumResolution = 2^14;
    Par.WindowSize    = 60;

    for iDLC = 1:size(Parameters.DLC.Run,1)
        Parameters.PSD{:,iDLC} = PlotPSDAnalysis(Parameters,iDLC,Parameters.DLC.Run,TitleList,Parameters.FLAG.SymbList{iDLC},Par);
        Parameters.PSD_SWP{:,iDLC} = PlotPSDAnalysisSWP(Parameters,iDLC,Parameters.DLC.Run,TitleList,Parameters.FLAG.SymbList{iDLC},Par);
    end

end


%% LDD Analysis ***********************************************************
if FLAG.LDDAnalysis
    fprintf('\n>>>>>>>>>>>>>> COMPUTING Load Duration Distributions \n');
    NBin = 64;
    if (~FLAG.PlotMDT)
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
        
        for iSensor = 1:size(Parameters.SensorList,1)
            for iComp = 1:length(Parameters.SensorList{iSensor,2})
                CompNumb = Parameters.SensorList{iSensor,2}(iComp);
                [Parameters.LDD{iSensor,iComp}] = LDDAnalysis(Parameters,iSensor,CompNumb,NBin);
            end
        end
    end
        % Write on Excel File
    fprintf('\n *** Write on Excel File is Still Under Construction in this PostProcess Version\n\n');
    Parameters = LDDWrite2ExcelParameters(Parameters);

end


%% COMPUTE ENVELOPE MATRIX ************************************************
if FLAG.EnvelopeAnalysis
    
    if (~FLAG.PlotMDT) % load/read mdt w/o any figures done before
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
    end
    
    
    
    for iSensor = 1:size(Parameters.SensorList,1)
        Parameters.Envelope{iSensor} = ComputeMatrixEnvelope(Parameters,iSensor,0);
    end
%     for iSensor = 1:size(Parameters.SensorList,1)
%         iCompIndex = find(Parameters.SensorList{iSensor,2}>6,2);    % find the resultants
%         Par.iComp = Parameters.SensorList{iSensor,2}(iCompIndex);
%         Parameters.Envelope{iSensor} = ComputeMatrixEnvelope(Parameters,iSensor,Par,0);
% %         [Parameters.Envelope{iSensor}.Matrix, Parameters.Envelope{iSensor}.LoadCase, Parameters.Envelope{iSensor}.Extensions, Parameters.Envelope{iSensor}.Units] = ComputeMatrixEnvelope(Parameters,iSensor,Par,0);
%     end
    
    % Write on Excel File
    fprintf('\n *** Write on Excel File is Still Under Construction in this PostProcess Version\n\n');
    Parameters = M2ExcelParameters(Parameters,0);
end

%% COMPUTE RANKING LOADS ************************************************
if FLAG.RankingAnalysis>0
    
    if (~FLAG.PlotMDT && ~FLAG.EnvelopeAnalysis)
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
    end
   
    for iSensor = 1:size(Parameters.SensorList,1)
        Parameters.Ranking{iSensor} = ComputeMatrixEnvelope(Parameters,iSensor,FLAG.RankingAnalysis);
    end
%     for iSensor = 1:size(Parameters.SensorList,1)
%         iCompIndex = find(Parameters.SensorList{iSensor,2}>6,2);    % find the resultants
%         Par.iComp = Parameters.SensorList{iSensor,2}(iCompIndex);
%         Parameters.Ranking{iSensor} = ComputeMatrixEnvelope(Parameters,iSensor,Par,FLAG.RankingAnalysis);
%     end
% %     for iSensor = 1:size(Parameters.SensorList,1)
% %         for iComp =1:length(Parameters.SensorList{iSensor,2})
% %             figure
% %             bar(Parameters.Ranking{iSensor}.MAX.Matrix(:,iComp));
% %             set(gca,'XTickLabel',Parameters.Ranking{iSensor}.MAX.Run{iComp});
% %         end
% %     end
    
    % Write on Excel File
    fprintf('\n *** Write on Excel File is Still Under Construction in this PostProcess Version\n\n');
    Parameters = M2ExcelParameters(Parameters,FLAG.RankingAnalysis);
end

 %%   RAINFLOW *************************************************************
if FLAG.RainFlowAnalysis
    fprintf('\n>>>>>>>>>>>>>> COMPUTING RAINFLOW\n');
    
    % PreProcess
    Parameters = PreProcessRainflowData(Parameters);
    
    % Rainflow Analysis
    for iDLC = 1:size(Parameters.DLC.Run,1)
        Parameters.Rainflow{iDLC} = RUNRunRainfloAnalysis(Parameters,iDLC,Parameters.DLC.Run,TitleList,Parameters.FLAG.SymbList{iDLC},Parameters.Fatigue);
    end
    
    % PostProcess
    Parameters = PostProcessRainflowData(Parameters);
    
    % Print on Excel file
    Parameters = M2ExcelFatigueAnalysis(Parameters);
    
end

%% USER DEFINED PLOT ******************************************************
return
Parameters = UserDefinedAnalysisWriteTH(Parameters)