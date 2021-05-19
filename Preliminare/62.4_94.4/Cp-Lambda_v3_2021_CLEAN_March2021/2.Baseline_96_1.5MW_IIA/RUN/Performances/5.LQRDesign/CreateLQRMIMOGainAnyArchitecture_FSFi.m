%==========================================================================
% LQR Synthesis Tool (Full State Feedback)
%==========================================================================
% This script can be used to generate LQR gains for:
% - FSFB case, with 2 controls and 6 states
% or
% - FSFB case with integral state on omega, that is, 2 controls and 7 states
% For any case, it is possible to specify scheduled gains.
% 
% Directions:
% 
% FSFB case: 
%           - set "OutputFeedbackFlag" to zero
%           - no weight scheduling: set Q_input and R_input as row vectors 
%           - yes   "      "      : # specify windspeeds in WindTable
%                                   # specify Q_input and R_input; each of them can
%                                     be a matrix with the number of rows
%                                     equal to length(WindTable) or a row
%                                     vector (in that case that vector will
%                                     be replicated for all wind speeds)
%
% FSFB case with integral state: 
%           - set "OutputFeedbackFlag" to zero
%           - (the same as for the Ist case, from point two, but besides 
%              Q_input and R_input a third weight matrix Qi_input for the 
%              integral can be specified)
%
% WARNING: the script automatically detects the presence of the integral
% weight. If it is present, then it will be accounted for. To avoid the
% calculations for the integral state, remove (comment out) the definition
% of Qi_input.
%
% INPUT:
% -------------------------------------------------------------------------
% - WT data from WTData excel file
% - Reference conditions for LQR (from the regulation trajectory)
% - Weights for the states (Q) and for the controls (R)
% - Name of the output file (see LQR_filename)
%
% OUTPUT:
% -------------------------------------------------------------------------
% - A file containing the reference state and controls of the selected LQR
%   strategy as well as optimal gains matrix. 
% - WARNING: the output file is created in '.\Output' and should be moved
%   to the '.\..\..\..\Controller' folder and renamed to 'LQRInputFile.txt
%   to be used
%
% DEVELOPMENT HISTORY:
% -------------------------------------------------------------------------
% Author: A.C.,  March 2017
%
%==========================================================================
clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% USER's INPUT %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% FileName Input
ExcelFileName           =   '.\..\0.Main\WTData.xlsx';
SheetName               =   'WTData';
AeroLookUpFileName      =   '.\..\2.CpLambdaCurves\OutputData\OutputReal_MatLookUp.mat' ;
RefConditionsFileName   =   '.\..\3.TrajectoryRegulation\Output\ReferenceCondition4PoliMIController.m' ;
TowerReducedData        =   '.\..\4.TowerReduction\Output\Data' ;

%%% Requested Control Type %%%

OutputFeedbackFlag      =   0 ;    % 1 means OutputFeedback, 0 FullStateFeedback

% Q_input  = [0 0  10  0  0  0];
% R_input  = [1 .1];
% Qi_input = [0.1]; % Remember to comment this out if not using an integral state on omega

%%%% For Weight Scheduling %%%%
WindTable   = [3 5 11 13 15 25];
Q_input     = [0  0  10  0  0  0];
R_input     = [ 1 10;
                1 10;
                1  1;
                1  5;
                1  1;
                10 10];
Qi_input    = [0.01;0.01;0.01;0.01;0.01;0.01];         
%%%% end Weight Scheduling %%%%

%%% Output Filename %%%
LQR_filename = strcat('LQR_MIMO_FSFi_sched_Q',num2str(Q_input(3)),'.000_R1.1_1.5MW.mat');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% end USER's INPUT %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


addpath('Routines')

% TURBINE *********************************************
MODEL.Turbine.R = xlsread(ExcelFileName,SheetName,'B2')/2;
MODEL.Turbine.J = xlsread(ExcelFileName,SheetName,'B18');
MODEL.ThetaTilt	= xlsread(ExcelFileName,SheetName,'B3')*pi/180;
% GENERATOR *******************************************
MODEL.Generator.J                 = xlsread(ExcelFileName,SheetName,'B19');
MODEL.Generator.tau               = xlsread(ExcelFileName,SheetName,'B21');
MODEL.Generator.GearBoxRatio      = xlsread(ExcelFileName,SheetName,'B22');
MODEL.Generator.MaxTorque         = xlsread(ExcelFileName,SheetName,'B20');
% TOWER ***********************************************
load(TowerReducedData)
MODEL.Tower.M     = Parameters.Tower.M;
MODEL.Tower.K     = Parameters.Tower.K;
MODEL.Tower.C     = Parameters.Tower.C;
MODEL.Tower.maxD  = xlsread(ExcelFileName,SheetName,'B23');
MODEL.Tower.maxV  = xlsread(ExcelFileName,SheetName,'B24');
% ACTUATOR *********************************************
MODEL.Actuator.wn = xlsread(ExcelFileName,SheetName,'B25');
MODEL.Actuator.csi = xlsread(ExcelFileName,SheetName,'B26');
MODEL.Actuator.maxRate = xlsread(ExcelFileName,SheetName,'B14');
% AEROFILE  *********************************************
MODEL.rho = xlsread(ExcelFileName,SheetName,'B9');
load(AeroLookUpFileName)
MODEL.LookUpTable.Aero.PitchTab  = LookUp.Pitch*pi/180 ;
MODEL.LookUpTable.Aero.TSRTab    = LookUp.TSR ;
MODEL.LookUpTable.Aero.CPTab = LookUp.Cp;
MODEL.LookUpTable.Aero.CFTab = LookUp.Cf;
[MODEL.LookUpTable.Inflow.aTab,MODEL.LookUpTable.Inflow.CPTab] = axial_inflow_factor(AeroLookUpFileName);
% Control  *********************************************
CONTROL.MaxElectricalTorque = xlsread(ExcelFileName,SheetName,'B20');
CONTROL.sample_time         = xlsread(ExcelFileName,SheetName,'B27');
% MECHANICAL_LOSS *********************************************
ML = 'MLLookUp.txt';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%   GLOBAL DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GlobalData.MODEL        = MODEL;
GlobalData.CONTROL      = CONTROL;



% load reference conditions
run(RefConditionsFileName)

% This should not be used in our formulation...
% Can be left as is in any case.
L = [0  0  0  0  0  0];

% Gain Scheduling or Not?
try %Yes
    NElSchedule = length(WindTable);
catch %No
    NElSchedule = 0;
    WindTable = [];
end

% Integral or Not?
try %Yes
    isempty(Qi_input);
    Integral = 1;
catch %No
    Integral = 0;
end

% Check that OF and Integral be not both required (this formulation is not
% implemented)
if ((Integral)&&(OutputFeedbackFlag))
    disp('No "output feedback + integral state" formulation implemented. Check your request.');
    return;
end



% Verifying weight input data
if (size(Q_input,2)~=size(RefCond,2))
    disp('Size of Q and of reference condition array do not match.');
    return;
elseif (size(R_input,2)~=2)
    disp('Size of R does not match the number of controls (2).');
    return;
elseif (Integral==1)
    if (size(Qi_input,2)~=1)
        disp('Size of Qi does not match the number of possible integrals (1).');
    return;
    end
elseif (NElSchedule > 0)
    if (Integral)
        if ((size(Q_input,1)~=NElSchedule)&&(size(R_input,1)~=NElSchedule)&&(size(Qi_input,1)~=NElSchedule))
            disp('Wind table specified but no match found on the size of any of the weight matrices.');
          return;
        end
    else
        if ((size(Q_input,1)~=NElSchedule)&&(size(R_input,1)~=NElSchedule))
            disp('Wind table specified but no match found on the size of any of the weight matrices.');
          return;
        end
    end
end

% Setting the size of all the weight matrices
if (NElSchedule~=0)
    if (size(Q_input,1) == 1)
        Q_input = repmat(Q_input,[NElSchedule,1]);
    elseif (size(Q_input,1) ~= NElSchedule)
        disp('Lines of Q are more than one, but not equal to NElSchedule.');
        return;
    end
    
    if (size(R_input,1) == 1)
        R_input = repmat(R_input,[NElSchedule,1]);
    elseif (size(R_input,1) ~= NElSchedule) 
        disp('Lines of R are more than one, but not equal to NElSchedule.');
        return;
    end
    
    if (Integral)        
        if (size(Qi_input,1) == 1)
            Qi_input = repmat(Qi_input,[NElSchedule,1]);
        elseif (size(Qi_input,1) ~= NElSchedule)
            disp('Lines of Qi are more than one, but not equal to NElSchedule.');
            return;
        end        
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% GO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Correct references for NgearBox
% memo: 3rd eq wrt LSS, 6th eq wrt HSS
RefCond(:,6) = RefCond(:,6)/GlobalData.MODEL.Generator.GearBoxRatio;


CLQR.RefCond = RefCond;

% SCALE VALUES
Ux        = GlobalData.MODEL.Tower.maxD;
Uxdot     = GlobalData.MODEL.Tower.maxV;
Uomega    = max(max(RefCond(:,3)));
Ubeta     = max(max(RefCond(:,4)));
Ubetadot  = GlobalData.MODEL.Actuator.maxRate;
UTel      = max(max(RefCond(:,6)));
UIntOmega = 1.0; % INTEGRAL of OMEGA

u_scale   = [Ubeta UTel];


if (Integral)
    States_scale = [Ux Uxdot Uomega Ubeta Ubetadot UTel UIntOmega];
else
    States_scale = [Ux Uxdot Uomega Ubeta Ubetadot UTel];
end

CLQR.ScaleCond = [States_scale u_scale];

GlobalData.Ref.RefCond = RefCond;
GlobalData.Ref.Wind = CLQR.Wind;

% scale matrices
Tx = diag(States_scale(1:6));
iTx  = inv(Tx);
Tu = diag(u_scale);
iTu  = inv(Tu);
Ty = diag(States_scale(3:6));
iTy  = inv(Ty);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% COMPUTE LQR GAINS %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for Iw=1:length(CLQR.Wind)

    fprintf('Computing For Wind = %g\n',CLQR.Wind(Iw));
    
    if isempty(WindTable) % No weight-scheduling
        Q_interp(Iw,:) = Q_input;
        R_interp(Iw,:) = R_input;
        if (Integral)
            Qi_interp(Iw,:) = Qi_input;
        end
    else % With weight-scheduling
        Q_interp(Iw,:) = interp1(WindTable,Q_input,CLQR.Wind(Iw));
        R_interp(Iw,:) = interp1(WindTable,R_input,CLQR.Wind(Iw));
        if (Integral)
            Qi_interp(Iw,:) = interp1(WindTable,Qi_input,CLQR.Wind(Iw));
        end
    end
    
    % Before calculations: Q, R, and maybe Qi are defined
    Q = Q_interp(Iw,:);
    R = R_interp(Iw,:);
    if (Integral)
        Qi = Qi_interp(Iw,:);
    end

    wind = CLQR.Wind(Iw);
    Ref_cond = RefCond(Iw,:);

    GlobalData.MODEL.AeroLoss=1;

    % Linearizing the system (no integral in this part)
    [Adim, Bdim, Cdim, D] = Linearization_analitical_MIMO(Ref_cond,GlobalData,wind);

    % scaling
    A = iTx*Adim*Tx;
    B = iTx*Bdim*Tu;
    C = iTy*Cdim*Tx;
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Compute LQR & Integral Feedback gains
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (Integral)
        CI = [0 0 1 0 0 0]; % Selecting Omega out of the states - only this integral is considered
        Qtot = [Q Qi];         % Adding the weight for the new state "integral of Omega"
        
        % Size of the "hat" system
        ny = 1; % Number of integrated states considered
        nu = 2; % Number of controls
        nx = 6; % Number of the original states
        

        Ahat = [A,zeros(nx,ny);CI,zeros(ny,ny)];
        Bhat = [B;zeros(ny,nu)];
        Chat = [CI zeros(ny,ny)];
        Qhat = diag(Qtot);
        Txhat = diag(States_scale(1:7));
        iTxhat  = inv(Txhat);

        [KLQRAdim Shat] = lqr(Ahat,Bhat,Qhat,diag(R)); %FSFB lqr gains for the original + integrated states
        KLQR     = Tu*KLQRAdim*iTxhat;
   else
        Q1 = diag(Q) + A'*diag(L)*A;
        R1 = diag(R) + B'*diag(L)*B;
        N1 = 2*A'*diag(L)*B;
        
        %NOTE: u=-k*x
        KLQRAdim = lqr(A,B,Q1,R1,N1);
        KLQR     = Tu*KLQRAdim*iTx;
                        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Compute Output Feedback gains
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if OutputFeedbackFlag
            NonDimRefCond = RefCond(Iw,:)./States_scale(1:6);
            
            Ob=obsv(A,C) ;
            s=svd(Ob);
            [U,S,V] = svd(Ob);
            unob = length(A)-rank(Ob);
            
            KLQR_aux = KLQRAdim;   % This may be necessary, as in OF case KLQR has a different size
            clear KLQRAdim   
            
            KLQRAdim = ComputeLQRGainOutputFeedback(A,B,C,Q1,R1,KLQR_aux(:,3:end),'temp.txt',NonDimRefCond,N1);
            KLQR     = Tu*KLQRAdim*iTy;
            
        end
    end       

    CLQR.Gain(Iw,:) = [-KLQR(1,:) -KLQR(2,:)];
    
    clear Q R
    clear Qi
end

% Completing output structure
CLQR.Q = Q_input;
CLQR.R = R_input;
if (Integral)
    CLQR.Qi_input = Qi_input;
end
CLQR.L = L; %Unuseful, can't be set by the user
if (OutputFeedbackFlag)
    CLQR.RefCond    = CLQR.RefCond(:,3:end);
    CLQR.ScaleCond  = CLQR.ScaleCond(3:end);
end

fprintf('Done. Now saving...\n',CLQR.Wind(Iw));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% saving
save(strcat('.\Output\',LQR_filename),'CLQR','-mat');


%% PLOT GAINS
%  omega beta betadot torque
nstate = 0.5*size(CLQR.Gain,2);
% figure(11101);plot(CLQR.Wind,CLQR.Gain(:,1:nstate))
% figure(11102);plot(CLQR.Wind,CLQR.Gain(:,nstate+1:end))
% figure(11103);plot(CLQR.Wind,CLQR.Gain(:,6))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WRITE ON FILE 4 DISCON %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Full Data

fid = fopen(strcat('.\Output\',LQR_filename(1:end-4),'FullData.txt'),'w');

if (Integral)
    fprintf(fid,'\r*** LQR MIMO Gains Full State Feedback w. Integral State ***');
elseif (OutputFeedbackFlag)
    fprintf(fid,'\r*** LQR MIMO Gains Output Feedback ***');
else
    fprintf(fid,'\r*** LQR MIMO Gains Full State Feedback ***');
end

fprintf(fid,'\r*** Created with CreateLQRMIMOGainAnyArchitecture ***');
fprintf(fid,'\r');
fprintf(fid,'\r %s ',datestr(now));
fprintf(fid,'\r');
fprintf(fid,'\rWeights used are:');
if (NElSchedule>1)
    fprintf(fid,'\r');
    for i=1:length(WindTable)
        fprintf(fid,'\rWindTable Value: %1.2e ',WindTable(i));
        if (Integral)
            fprintf(fid,'\r\r    Q = [%1.2e %1.2e %1.2e %1.2e %1.2e %1.2e | %1.2e] ',Q_input(i,:),Qi_input(i,:));
        else
            fprintf(fid,'\r\r    Q = [%1.2e %1.2e %1.2e %1.2e %1.2e %1.2e] ',Q_input(i,:));
        end
        fprintf(fid,'\r    R = [%1.2e %1.2e] \r',R_input(i,:));
    end
else
    if (Integral)
        fprintf(fid,'\r\r    Q = [%1.2e %1.2e %1.2e %1.2e %1.2e %1.2e | %1.2e] ',Q_input,Qi_input);
    else
        fprintf(fid,'\r\r    Q = [%1.2e %1.2e %1.2e %1.2e %1.2e %1.2e] ',Q_input);
    end
    fprintf(fid,'\r    R = [%1.2e %1.2e] ',R_input);
end

fprintf(fid,'\r\r\r    L = [%1.2e %1.2e %1.2e %1.2e %1.2e %1.2e ] ',L);

fprintf(fid,'\r');
fprintf(fid,'\r');
fprintf(fid,'\r');
fprintf(fid,'\r');
fprintf(fid,'\rLQRNumberOfWinds    %i',length(CLQR.Wind));
fprintf(fid,'\rLQRWindFilter       10');
if (Integral)
    fprintf(fid,'\rLQRNumberOfStates    7');
elseif (OutputFeedbackFlag)
    fprintf(fid,'\rLQRNumberOfStates    4');
else
    fprintf(fid,'\rLQRNumberOfStates    6');
end
fprintf(fid,'\rLQRNumberOfControls  2');
fprintf(fid,'\rLQRWindsTable ');
fprintf(fid,'       %d ',CLQR.Wind);
fprintf(fid,'\rLQRStatesReferences');

if (Integral)
    fprintf(fid,'\r    %+d %+d %+d %+d %+d %+d %+d',[CLQR.RefCond zeros(length(CLQR.Wind),1)]');
elseif (OutputFeedbackFlag)
    fprintf(fid,'\r    %+d %+d %+d %+d',[CLQR.RefCond]');
else
    fprintf(fid,'\r    %+d %+d %+d %+d %+d %+d',[CLQR.RefCond]');
end

fprintf(fid,'\rLQRControlsReferences');
fprintf(fid,'\r     %+d %+d ',CLQR.RefCond(:,[4 6]-2*OutputFeedbackFlag)');
fprintf(fid,'\rLQRScaleValues');

if (Integral)
    fprintf(fid,'\r     %+d %+d %+d %+d %+d %+d %+d %+d %+d',ones(size(CLQR.ScaleCond')));
elseif (OutputFeedbackFlag)
    fprintf(fid,'\r     %+d %+d %+d %+d %+d %+d',ones(size(CLQR.ScaleCond')));
else
    fprintf(fid,'\r     %+d %+d %+d %+d %+d %+d %+d %+d',ones(size(CLQR.ScaleCond')));
end


fprintf(fid,'\rLQRGains');

if (Integral)
    fprintf(fid,'\r     %+d %+d %+d %+d %+d %+d %+d       %+d %+d %+d %+d %+d %+d %+d',CLQR.Gain');
elseif (OutputFeedbackFlag)
    fprintf(fid,'\r     %+d %+d %+d %+d       %+d %+d %+d %+d',CLQR.Gain');
else
    fprintf(fid,'\r     %+d %+d %+d %+d %+d %+d       %+d %+d %+d %+d %+d %+d',CLQR.Gain');
end

fclose(fid);

%  Data for controller

fid = fopen(strcat('.\Output\',LQR_filename(1:end-4),'.txt'),'w');

fprintf(fid,'\r');
fprintf(fid,'\rLQRNumberOfWinds    %i',length(CLQR.Wind));
fprintf(fid,'\rLQRWindFilter       10');
if (Integral)
    fprintf(fid,'\rLQRNumberOfStates    7');
elseif (OutputFeedbackFlag)
    fprintf(fid,'\rLQRNumberOfStates    4');
else
    fprintf(fid,'\rLQRNumberOfStates    6');
end
fprintf(fid,'\rLQRNumberOfControls  2');
fprintf(fid,'\rLQRWindsTable ');
fprintf(fid,'       %d ',CLQR.Wind);
fprintf(fid,'\rLQRStatesReferences');

if (Integral)
    fprintf(fid,'\r    %+d %+d %+d %+d %+d %+d %+d',[CLQR.RefCond zeros(length(CLQR.Wind),1)]');
elseif (OutputFeedbackFlag)
    fprintf(fid,'\r    %+d %+d %+d %+d',[CLQR.RefCond]');
else
    fprintf(fid,'\r    %+d %+d %+d %+d %+d %+d',[CLQR.RefCond]');
end

fprintf(fid,'\rLQRControlsReferences');
fprintf(fid,'\r     %+d %+d ',CLQR.RefCond(:,[4 6]-2*OutputFeedbackFlag)');
fprintf(fid,'\rLQRScaleValues');

if (Integral)
    fprintf(fid,'\r     %+d %+d %+d %+d %+d %+d %+d %+d %+d',ones(size(CLQR.ScaleCond')));
elseif (OutputFeedbackFlag)
    fprintf(fid,'\r     %+d %+d %+d %+d %+d %+d',ones(size(CLQR.ScaleCond')));
else
    fprintf(fid,'\r     %+d %+d %+d %+d %+d %+d %+d %+d',ones(size(CLQR.ScaleCond')));
end


fprintf(fid,'\rLQRGains');

if (Integral)
    fprintf(fid,'\r     %+d %+d %+d %+d %+d %+d %+d       %+d %+d %+d %+d %+d %+d %+d',CLQR.Gain');
elseif (OutputFeedbackFlag)
    fprintf(fid,'\r     %+d %+d %+d %+d       %+d %+d %+d %+d',CLQR.Gain');
else
    fprintf(fid,'\r     %+d %+d %+d %+d %+d %+d       %+d %+d %+d %+d %+d %+d',CLQR.Gain');
end

fclose(fid);




