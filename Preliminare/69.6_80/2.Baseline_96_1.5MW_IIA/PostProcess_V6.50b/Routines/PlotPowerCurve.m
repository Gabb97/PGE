clear all
close all
clc

Dir_Name = 'OutputParameters\Simulation_MAIT_WG92_cog_opt6Ac38_run1coarse_Cap630mmFix_websConv_\iteration_3'

ReadSWPFlag = 1;
 
addpath('Routines')

%% READ (or LOAD) SWP FILEs
if ReadSWPFlag
%     load(strcat(Dir_Name,'\ParametersAdditional.mat'));

    %% Set the time histories
    Parameters.DLC.Run = [...
    {'.\..\DLCAdditional\DLC1_1\22_SiP_Output\Output\TurbA_1'};...
    {'.\..\DLCAdditional\DLC1_1\22_SiP_Output\Output\TurbA_2'};...
    {'.\..\DLCAdditional\DLC1_1\22_SiP_Output\Output\TurbA_3'};...
    {'.\..\DLCAdditional\DLC1_1\22_SiP_Output\Output\TurbA_4'};...
    {'.\..\DLCAdditional\DLC1_1\22_SiP_Output\Output\TurbA_5'};...
    {'.\..\DLCAdditional\DLC1_1\22_SiP_Output\Output\TurbA_6'};...
    {'.\..\DLCAdditional\DLC1_1\22_SiP_Output\Output\TurbA_7'};...
    {'.\..\DLCAdditional\DLC1_1\22_SiP_Output\Output\TurbA_8'};...
    {'.\..\DLCAdditional\DLC1_1\22_SiP_Output\Output\TurbA_9'};...
    {'.\..\DLCAdditional\DLC1_1\22_SiP_Output\Output\TurbA_10'};...
    {'.\..\DLCAdditional\DLC1_1\22_SiP_Output\Output\TurbA_11'};...
    {'.\..\DLCAdditional\DLC1_1\22_SiP_Output\Output\TurbA_12'};...
        ];


    %% Read the time histories
    for iDLC = 1:size(Parameters.DLC.Run,1)
        fprintf('Reading DLC [%s] \n',Parameters.DLC.Run{iDLC} );
        [Parameters] = ReadAndPlotSWPFile(Parameters,iDLC);
    end

else
    load(strcat(Dir_Name,'\ParametersAdditionalWithSWP.mat'));
%     load(strcat(Dir_Name,'\ParametersAdditionalWithSWP_run2.mat'));
%     load(strcat(Dir_Name,'\ParametersAdditionalWithSWP_run3.mat'));
end

%% Compute power curve
for iDLC = 1:size(Parameters.DLC.Run,1)
    iStart = 101%Parameters.AdditionalDLC.InitTimeStep(iDLC);
    Parameters.PowerCurve.OMEGA(iDLC) = mean(Parameters.AdditionalSWP{iDLC}.array(iStart:end,20));
    Parameters.PowerCurve.POWER(iDLC) = mean(Parameters.AdditionalSWP{iDLC}.array(iStart:end,15));
    Parameters.PowerCurve.WIND(iDLC)  = mean(Parameters.AdditionalSWP{iDLC}.array(iStart:end,27));
end

figure(70001);  set(gcf, 'Name','Power Curve', 'NumberTitle','off')
hold on; grid on; zoom on;
hp=plot(Parameters.PowerCurve.WIND,Parameters.PowerCurve.POWER/1.0E6,':b');
set (hp,'LineWidth',2);
hx=xlabel('Wind [m/s]'); hy=ylabel('Power [MW]');
set (hx,'FontSize',12,'FontWeight','bold');
set (hy,'FontSize',12,'FontWeight','bold');
axis([2.9 25.1 0 2.001])

return
%% Save new time histories ans restore the old ones
% save(strcat(Dir_Name,'\ParametersAdditionalWithSWP.mat'),'Parameters');
% save(strcat(Dir_Name,'\ParametersAdditionalWithSWP_run2.mat'),'Parameters');
save(strcat(Dir_Name,'\ParametersAdditionalWithSWP_run3.mat'),'Parameters');
