function Parameters = M2ExcelParameters(Parameters,RankingFlag)

%%

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



%% Envelope ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if RankingFlag>0 %% PRINT RANKING
    OutputXls = Parameters.FLAG.OutputXlsRanking;
    % MAX values
    for iSensor = 1:size(Parameters.SensorList,1)
        RN = Parameters.Ranking{iSensor}.MAX.Matrix;
        SheetName = sprintf('Sheet %g',iSensor);

        iline = 1;
        clear data
        data{1} = sprintf('LOAD RANKING for sensor %s MAX VALUES - SAFETY FACTORS ALREADY APPLIED.',Parameters.SensorList{iSensor,1});
        [status, message] = xlswrite(OutputXls, data, SheetName, strcat('B',num2str(iline+0)) );
        iline = iline + 2;
        
        for iComp = 1:size(Parameters.Ranking{iSensor}.MAX.Safety,2)
            data = {Parameters.Ranking{iSensor}.MAX.Extensions{iComp}};
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{-2+iComp*4},num2str(iline+2)) );
            data = {Parameters.Ranking{iSensor}.MAX.Units{iComp}};
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{-1+iComp*4},num2str(iline+2)) );
            data = {'Safety Factor'};
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{0+iComp*4},num2str(iline+2)) );
            data = Parameters.Ranking{iSensor}.MAX.Run{iComp};
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{-2+iComp*4},num2str(iline+3)) );
            data = RN(:,iComp);
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{-1+iComp*4},num2str(iline+3)) );
            data = Parameters.Ranking{iSensor}.MAX.Safety(:,iComp);
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{0+iComp*4},num2str(iline+3)) );
        end
        
   end
    
    % MIN values
    for iSensor = 1:size(Parameters.SensorList,1)
        RN = Parameters.Ranking{iSensor}.MIN.Matrix;
        SheetName = sprintf('Sheet %g',iSensor+100);

        iline = 1;
        clear data
        data{1} = sprintf('LOAD RANKING for sensor %s MIN VALUES - SAFETY FACTORS ALREADY APPLIED.',Parameters.SensorList{iSensor,1});
        [status, message] = xlswrite(OutputXls, data, SheetName, strcat('B',num2str(iline+0)) );
        iline = iline + 2;
        
        for iComp = 1:size(Parameters.Ranking{iSensor}.MIN.Safety,2)
            data = {Parameters.Ranking{iSensor}.MIN.Extensions{iComp}};
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{-2+iComp*4},num2str(iline+2)) );
            data = {Parameters.Ranking{iSensor}.MIN.Units{iComp}};
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{-1+iComp*4},num2str(iline+2)) );
            data = {'Safety Factor'};
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{0+iComp*4},num2str(iline+2)) );
            data = Parameters.Ranking{iSensor}.MIN.Run{iComp};
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{-2+iComp*4},num2str(iline+3)) );
            data = RN(:,iComp);
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{-1+iComp*4},num2str(iline+3)) );
            data = Parameters.Ranking{iSensor}.MIN.Safety(:,iComp);
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{0+iComp*4},num2str(iline+3)) );
        end
        
   end
    
    % ABS values
    for iSensor = 1:size(Parameters.SensorList,1)
        RN = Parameters.Ranking{iSensor}.ABS.Matrix;
        SheetName = sprintf('Sheet %g',iSensor+200);

        iline = 1;
        clear data
        data{1} = sprintf('LOAD RANKING for sensor %s ABS VALUES - SAFETY FACTORS ALREADY APPLIED.',Parameters.SensorList{iSensor,1});
        [status, message] = xlswrite(OutputXls, data, SheetName, strcat('B',num2str(iline+0)) );
        iline = iline + 2;
        
        for iComp = 1:size(Parameters.Ranking{iSensor}.ABS.Safety,2)
            data = {Parameters.Ranking{iSensor}.ABS.Extensions{iComp}};
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{-2+iComp*4},num2str(iline+2)) );
            data = {Parameters.Ranking{iSensor}.ABS.Units{iComp}};
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{-1+iComp*4},num2str(iline+2)) );
            data = {'Safety Factor'};
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{0+iComp*4},num2str(iline+2)) );
            data = Parameters.Ranking{iSensor}.ABS.Run{iComp};
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{-2+iComp*4},num2str(iline+3)) );
            data = RN(:,iComp);
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{-1+iComp*4},num2str(iline+3)) );
            data = Parameters.Ranking{iSensor}.ABS.Safety(:,iComp);
            [status, message] = xlswrite(OutputXls, data, SheetName, strcat(COL{0+iComp*4},num2str(iline+3)) );
        end
        
    end
    
else %% PRINT ENVELOPE
    OutputXls = Parameters.FLAG.OutputXls;
    for iSensor = 1:size(Parameters.SensorList,1)
        EN = Parameters.Envelope{iSensor}.Matrix;
        SheetName = sprintf('Sheet %g',iSensor);%Parameters.SensorList{iSensor,1};
        
        Extensions  = Parameters.Envelope{iSensor}.Extensions;
        Units = Parameters.Envelope{iSensor}.Units;
        
        
        iline = 1;
        clear data
        data{1} = sprintf('Envelope for sensor %s - SAFETY FACTORS ALREADY APPLIED.',Parameters.SensorList{iSensor,1});
        [status, message] = xlswrite(OutputXls, data, SheetName, strcat('B',num2str(iline+0)) );
        data = [Extensions {' ','DLC', 'Time', 'Safety Factor'} ];
        [status, message] = xlswrite(OutputXls, data, SheetName, strcat('B',num2str(iline+1)) );
        data = [Units {' ', '-', '-', 'sec'}];
        [status, message] = xlswrite(OutputXls, data, SheetName, strcat('B',num2str(iline+2)) );
        data = EN;
        [status, message] = xlswrite(OutputXls, data, SheetName, strcat('B',num2str(iline+3)) );
        data = {'Max', 'Min', 'Max', 'Min', 'Max', 'Min', 'Max', 'Min', 'Max', 'Min', 'Max', 'Min', 'Max', 'Min', 'Max', 'Min', };
        [status, message] = xlswrite(OutputXls, data', SheetName, strcat('A',num2str(iline+3)) );
        data = Parameters.Envelope{iSensor}.LoadCase;
        [status, message] = xlswrite(OutputXls, data, SheetName, strcat('K',num2str(iline+3)) );
        
    end
end

