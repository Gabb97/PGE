function  [Parameters] = M2ExcelFatigueAnalysis(Parameters)

%  MOD LMS on 07/10/2014, replaced "iComp" with "CompNumb" in write Markov loop

TEMP_SAFETY = 1.00

% Output file name
OutputXls = Parameters.FLAG.OutputXlsRainFlow;

%%%
COL = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',...
    'AA','AB','AC','AD','AE','AF','AG','AH','AI','AJ','AK','AL','AM','AN','AO','AP','AQ','AR','AS','AT','AU','AV','AW','AX','AY','AZ',...
    'BA','BB','BC','BD','BE','BF','BG','BH','BI','BJ','BK','BL','BM','BN','BO','BP','BQ','BR','BS','BT','BU','BV','BW','BX','BY','BZ',...
    'CA','CB','CC','CD','CE','CF','CG','CH','CI','CJ','CK','CL','CM','CN','CO','CP','CQ','CR','CS','CT','CU','CV','CW','CX','CY','CZ',...
    'DA','DB','DC','DD','DE','DF','DG','DH','DI','DJ','DK','DL','DM','DN','DO','DP','DQ','DR','DS','DT','DU','DV','DW','DX','DY','DZ',...
    'EA','EB','EC','ED','EE','EF','EG','EH','EI','EJ','EK','EL','EM','EN','EO','EP','EQ','ER','ES','ET','EU','EV','EW','EX','EY','EZ',...
    'FA','FB','FC','FD','FE','FF','FG','FH','FI','FJ','FK','FL','FM','FN','FO','FP','FQ','FR','FS','FT','FU','FV','FW','FX','FY','FZ',...
    'GA','GB','GC','GD','GE','GF','GG','GH','GI','GJ','GK','GL','GM','GN','GO','GP','GQ','GR','GS','GT','GU','GV','GW','GX','GY','GZ',...
    'HA','HB','HC','HD','HE','HF','HG','HH','HI','HJ','HK','HL','HM','HN','HO','HP','HQ','HR','HS','HT','HU','HV','HW','HX','HY','HZ',...
    'IA','IB','IC','ID','IE','IF','IG','IH','II','IJ','IK','IL','IM','IN','IO','IP','IQ','IR','IS','IT','IU','IV','IW','IX','IY','IZ',...
    'JA','JB','JC','JD','JE','JF','JG','JH','JI','JJ','JK','JL','JM','JN','JO','JP','JQ','JR','JS','JT','JU','JV','JW','JX','JY','JZ',...
    'KA','KB','KC','KD','KE','KF','KG','KH','KI','KJ','KK','KL','KM','KN','KO','KP','KQ','KR','KS','KT','KU','KV','KW','KX','KY','KZ',...
    'LA','LB','LC','LD','LE','LF','LG','LH','LI','LJ','LK','LL','LM','LN','LO','LP','LQ','LR','LS','LT','LU','LV','LW','LX','LY','LZ',...
    'MA','MB','MC','MD','ME','MF','MG','MH','MI','MJ','MK','ML','MM','MN','MO','MP','MQ','MR','MS','MT','MU','MV','MW','MX','MY','MZ',...
    'NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ','NR','NS','NT','NU','NV','NW','NX','NY','NZ',...
    'OA','OB','OC','OD','OE','OF','OG','OH','OI','OJ','OK','OL','OM','ON','OO','OP','OQ','OR','OS','OT','OU','OV','OW','OX','OY','OZ',...
    'PA','PB','PC','PD','PE','PF','PG','PH','PI','PJ','PK','PL','PM','PN','PO','PP','PQ','PR','PS','PT','PU','PV','PW','PX','PY','PZ',...
    'QA','QB','QC','QD','QE','QF','QG','QH','QI','QJ','QK','QL','QM','QN','QO','QP','QQ','QR','QS','QT','QU','QV','QW','QX','QY','QZ',...
    'RA','RB','RC','RD','RE','RF','RG','RH','RI','RJ','RK','RL','RM','RN','RO','RP','RQ','RR','RS','RT','RU','RV','RW','RX','RY','RZ',...
    'SA','SB','SC','SD','SE','SF','SG','SH','SI','SJ','SK','SL','SM','SN','SO','SP','SQ','SR','SS','ST','SU','SV','SW','SX','SY','SZ',...
    'TA','TB','TC','TD','TE','TF','TG','TH','TI','TJ','TK','TL','TM','TN','TO','TP','TQ','TR','TS','TT','TU','TV','TW','TX','TY','TZ',...
    'UA','UB','UC','UD','UE','UF','UG','UH','UI','UJ','UK','UL','UM','UN','UO','UP','UQ','UR','US','UT','UU','UV','UW','UX','UY','UZ',...
    'VA','VB','VC','VD','VE','VF','VG','VH','VI','VJ','VK','VL','VM','VN','VO','VP','VQ','VR','VS','VT','VU','VV','VW','VX','VY','VZ',...
    'WA','WB','WC','WD','WE','WF','WG','WH','WI','WJ','WK','WL','WM','WN','WO','WP','WQ','WR','WS','WT','WU','WV','WW','WX','WY','WZ',...
    'XA','XB','XC','XD','XE','XF','XG','XH','XI','XJ','XK','XL','XM','XN','XO','XP','XQ','XR','XS','XT','XU','XV','XW','XX','XY','XZ',...
    'YA','YB','YC','YD','YE','YF','YG','YH','YI','YJ','YK','YL','YM','YN','YO','YP','YQ','YR','YS','YT','YU','YV','YW','YX','YY','YZ',...
    'ZA','ZB','ZC','ZD','ZE','ZF','ZG','ZH','ZI','ZJ','ZK','ZL','ZM','ZN','ZO','ZP','ZQ','ZR','ZS','ZT','ZU','ZV','ZW','ZX','ZY','ZZ'};





%% Write DEL
NM = Parameters.DLC.Run;
im = length(Parameters.Fatigue.m);

% write DEL
for idlc=1:length(NM)
    DEL = Parameters.Rainflow{idlc};
    iline = (idlc-1)*(im+6)+4;
    data = {sprintf('DLC name: %s',NM{idlc}),[],[],[],[],[],[],sprintf('SAFETY FACTOR: %g ALREADY INCLUDED!',Parameters.DLC.Safety(idlc)),[],[],[],sprintf('Mean Wind Speed value %g [m/sec]',Parameters.WeibullStruct.MeanWindSpeed(idlc))};
    [status, message] = xlswrite(OutputXls, data, 'DEL', strcat('A',num2str(iline+0)) );
    data = {'Frequency:',Parameters.Fatigue.EqvFreq,'Hz'};
    [status, message] = xlswrite(OutputXls, data, 'DEL', strcat('A',num2str(iline+1)) );
    for iSensor = 1:size(Parameters.SensorList,1)
        icol = (iSensor-1)*10 + 1;
        data = {'Sensor Name:',[],[],Parameters.SensorList{iSensor,1}};
        [status, message] = xlswrite(OutputXls, data, 'DEL', strcat(COL{icol+1},num2str(iline+2)) );
        data = {'SNInverseSlope m'};
        for iComp = 1:length(Parameters.SensorList{iSensor,2})
            mdt_temp = getfield(Parameters.MDT{idlc},Parameters.SensorList{iSensor,1});
            CompNumb = Parameters.SensorList{iSensor,2}(iComp);
            data = [data strcat(mdt_temp.Extensions{CompNumb},' ', mdt_temp.Units{CompNumb})];
        end
        [status, message] = xlswrite(OutputXls, data, 'DEL', strcat(COL{icol},num2str(iline+3)) );

        data = Parameters.Fatigue.m';
        for iComp = 1:length(Parameters.SensorList{iSensor,2})
            mdt_temp = getfield(Parameters.MDT{idlc},Parameters.SensorList{iSensor,1});
            CompNumb = Parameters.SensorList{iSensor,2}(iComp);
            data = [data TEMP_SAFETY*DEL(iSensor,iComp).EqvLoads{:}'];
        end
        [status, message] = xlswrite(OutputXls, data, 'DEL', strcat(COL{icol},num2str(iline+4)));
    end
end


%% write DELWeibull
DELW = Parameters.Fatigue.DELWeibull;
iline = iline + 15;
idlc = 1;

data = {sprintf('DELs weighted with Weibull: Vave %g [m/s], k %g[-], total occourences for each simulation %i:',Parameters.WeibullStruct.Vave,Parameters.WeibullStruct.k,Parameters.WeibullStruct.N0),[],[],[],[],[],[],sprintf('SAFETY FACTOR: %g ALREADY INCLUDED!',mean(Parameters.DLC.Safety))};
[status, message] = xlswrite(OutputXls, data, 'DEL', strcat('A',num2str(iline+0)) );
data = {'Frequency:',Parameters.Fatigue.EqvFreq,'Hz'};
[status, message] = xlswrite(OutputXls, data, 'DEL', strcat('A',num2str(iline+1)) );


for iSensor = 1:size(Parameters.SensorList,1)
    icol = (iSensor-1)*10 + 1;
    data = {'Sensor Name:',[],[],Parameters.SensorList{iSensor,1}};
    [status, message] = xlswrite(OutputXls, data, 'DEL', strcat(COL{icol+1},num2str(iline+2)) );
    data = {'SNInverseSlope m'};
    for iComp = 1:length(Parameters.SensorList{iSensor,2})
        mdt_temp = getfield(Parameters.MDT{idlc},Parameters.SensorList{iSensor,1});
        CompNumb = Parameters.SensorList{iSensor,2}(iComp);
        data = [data strcat(mdt_temp.Extensions{CompNumb},' ', mdt_temp.Units{CompNumb})];
    end
    [status, message] = xlswrite(OutputXls, data, 'DEL', strcat(COL{icol},num2str(iline+3)) );
    
    data = Parameters.Fatigue.m';
    for iComp = 1:length(Parameters.SensorList{iSensor,2})
        mdt_temp = getfield(Parameters.MDT{idlc},Parameters.SensorList{iSensor,1});
        CompNumb = Parameters.SensorList{iSensor,2}(iComp);
        data = [data TEMP_SAFETY*DELW{iSensor,iComp}'];
    end
    [status, message] = xlswrite(OutputXls, data, 'DEL', strcat(COL{icol},num2str(iline+4)));
end

%% write TOTAL DEL 
DELW = Parameters.Fatigue.TOTDELWeibull;
iline = iline + 15;
idlc = 1;

data = {sprintf('DELs cumulated with Weibull: Vave %g [m/s], k %g[-], total occourences for each simulation %i:',Parameters.WeibullStruct.Vave,Parameters.WeibullStruct.k,Parameters.WeibullStruct.N0),[],[],[],[],[],[],sprintf('SAFETY FACTOR: %g ALREADY INCLUDED!',mean(Parameters.DLC.Safety))};
[status, message] = xlswrite(OutputXls, data, 'DEL', strcat('A',num2str(iline+0)) );
data = {'Frequency:',Parameters.Fatigue.EqvFreq,'Hz'};
[status, message] = xlswrite(OutputXls, data, 'DEL', strcat('A',num2str(iline+1)) );


for iSensor = 1:size(Parameters.SensorList,1)
    icol = (iSensor-1)*10 + 1;
    data = {'Sensor Name:',[],[],Parameters.SensorList{iSensor,1}};
    [status, message] = xlswrite(OutputXls, data, 'DEL', strcat(COL{icol+1},num2str(iline+2)) );
    data = {'SNInverseSlope m'};
    for iComp = 1:length(Parameters.SensorList{iSensor,2})
        mdt_temp = getfield(Parameters.MDT{idlc},Parameters.SensorList{iSensor,1});
        CompNumb = Parameters.SensorList{iSensor,2}(iComp);
        data = [data strcat(mdt_temp.Extensions{CompNumb},' ', mdt_temp.Units{CompNumb})];
    end
    [status, message] = xlswrite(OutputXls, data, 'DEL', strcat(COL{icol},num2str(iline+3)) );
    
    data = Parameters.Fatigue.m';
    for iComp = 1:length(Parameters.SensorList{iSensor,2})
        mdt_temp = getfield(Parameters.MDT{idlc},Parameters.SensorList{iSensor,1});
        CompNumb = Parameters.SensorList{iSensor,2}(iComp);
        data = [data TEMP_SAFETY*DELW{iSensor,iComp}'];
    end
    [status, message] = xlswrite(OutputXls, data, 'DEL', strcat(COL{icol},num2str(iline+4)));
end


disp('***WARNING: MARKOV NOT WRITTEN!!!!!')

%% Write Markov
MARKOV  = Parameters.Fatigue.TOTMarkov;
WEIBULL = Parameters.WeibullStruct;

% Loop on each sensor
for iSensor = 1:size(Parameters.SensorList,1)
    SheetName = sprintf('Markov_%s',Parameters.SensorList{iSensor,1}(8:end))
    iline = 1;
    data = {sprintf('Markov Matrices computed with Weibull: Vave %g [m/s], k %g[-], total occourences %i:',WEIBULL.Vave,WEIBULL.k,WEIBULL.N0),[],[],[],[],[],[],[],[],[],[],[],[],sprintf('SAFETY FACTOR: %g ALREADY INCLUDED!',mean(Parameters.DLC.Safety))};
    [status, message] = xlswrite(OutputXls, data, SheetName, strcat('B',num2str(iline+1)) );
    data = {sprintf('LOAD CASE %s',Parameters.SensorList{iSensor,1})};
    [status, message] = xlswrite(OutputXls, data, SheetName, strcat('B',num2str(iline+3)) );
    iline = iline + 5;
    for iComp = 1:length(Parameters.SensorList{iSensor,2}) % loop on each component of the sensor
        mdt_temp = getfield(Parameters.MDT{idlc},Parameters.SensorList{iSensor,1});
        CompNumb = Parameters.SensorList{iSensor,2}(iComp);
        icol = 1;
        data = {'Sensor Name:',[],[],mdt_temp.Extensions{CompNumb}};   % MOD LMS, it was "iComp"
        [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{icol+2},num2str(iline+2)) );
        iline = iline + 1;
        data = {sprintf('Range %s',mdt_temp.Units{CompNumb})};         % MOD LMS
        [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{icol+1},num2str(iline+3)) );
        [status, message] = xlswrite(OutputXls, MARKOV{iSensor,iComp}.Range, SheetName, strcat(COL{icol+2},num2str(iline+3)) );
        data = {sprintf('Mean %s',mdt_temp.Units{CompNumb})};          % MOD LMS
        [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{icol},num2str(iline+5)) );
        [status, message] = xlswrite(OutputXls, MARKOV{iSensor,iComp}.Mean', SheetName, strcat(COL{icol},num2str(iline+6)) );
        [status, message] = xlswrite(OutputXls, TEMP_SAFETY*MARKOV{iSensor,iComp}.Ncycle', SheetName, strcat(COL{icol+2},num2str(iline+6)));
        iline = iline + length(MARKOV{iSensor,iComp}.Mean) + 9 ;
    end
end