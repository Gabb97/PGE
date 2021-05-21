function []=CE_DisplayOutput(Parameters,AEP,coe,Cost,ConvRate)

format1='\t %-20s %-10.2f %-10s %-10.2f %-10s \n';
format2='\t %-20s %-10.2f %-10s \n';
format3='\t %-20s %-20s \n';

formatC1='\t %-48s %8.1f %-7s %8.1f %-10s \n';
formatC2='\t \t %-44s %8.1f %-7s %8.1f %-10s \n';
formatC3='\t \t \t %-39s %8.1f %-7s %8.1f %-10s \n';
formatC4='\t %-48s %8.1f %-7s \n';
formatC5='\t %-48s %8.5f %-7s %8.5f %-10s \n';
formatC6='\t %-48s %8.2f %-7s %8.2f %-10s \n';

disp('====================================================================================')
disp('Main properties:')
    if Parameters.CostModel.Offshore==0
        fprintf(format3,'Type: ','On-Shore');
    else
        fprintf(format3,'Type: ','Off-Shore');
    end
    fprintf(format1,'Rated power:',Parameters.maxPower/1e3,'[kW]',Parameters.maxPower/1e6,'[MW]');
    fprintf(format1,'AEP:',AEP/1e6,'[MWh/yr]',AEP/1e9,'[GWh/yr]');
    fprintf(format2,'Rotor radius: ',Parameters.Rotor.RotorDiameter/2,'[m]');
    fprintf(format2,'Hub height: ',Parameters.Rotor.HubHeight,'[m]');
    if Parameters.CostModel.TowerCostModel== 3
        fprintf(format2,'Tower height: ',Parameters.Tower.TowerHeight,'[m]');
    end
    fprintf(format2,'Blade mass: ',Parameters.Blade.TotalMass,'[kg]');
    fprintf(format2,'Tower mass: ',Parameters.Tower.TotalMass,'[kg]');
disp('====================================================================================')
disp('Preliminary cost evaluation:')
    fprintf('\n');
    fprintf(formatC1, 'Rotor:', Cost.Rotor,'[k$]',Cost.Rotor*ConvRate, '[k€]' );
    fprintf('\n');
        fprintf(formatC2, 'Blades:', Cost.Rotor_Blades,'[k$]',Cost.Rotor_Blades*ConvRate, '[k€]' );
        fprintf(formatC2, 'Hub:', Cost.Rotor_Hub,'[k$]', Cost.Rotor_Hub*ConvRate, '[k€]' );
        fprintf(formatC2, 'Pitch system:', Cost.Rotor_PitchSys,'[k$]', Cost.Rotor_PitchSys*ConvRate, '[k€]' );
        fprintf(formatC2, 'Spinner, nose, cone:', Cost.Rotor_Spinner,'[k$]', Cost.Rotor_Spinner*ConvRate, '[k€]' );
    fprintf('\n');
    fprintf(formatC1, 'Drive train, nacelle:', Cost.DriveTrain,'[k$]',Cost.DriveTrain*ConvRate, '[k€]' );
    fprintf('\n');
        fprintf(formatC2, 'Low speed shaft:',Cost.DriveTrain_Shaft,'[k$]',Cost.DriveTrain_Shaft*ConvRate, '[k€]' );
        fprintf(formatC2, 'Bearings:',Cost.DriveTrain_Bearing,'[k$]',Cost.DriveTrain_Bearing*ConvRate, '[k€]' );
        fprintf(formatC2, 'Gearbox:',Cost.DriveTrain_GearBox,'[k$]',Cost.DriveTrain_GearBox*ConvRate, '[k€]' );
        fprintf(formatC2, 'Brake:',Cost.DriveTrain_Brake,'[k$]',Cost.DriveTrain_Brake*ConvRate, '[k€]' );
        fprintf(formatC2, 'Generator:',Cost.DriveTrain_Generator,'[k$]',Cost.DriveTrain_Generator*ConvRate, '[k€]' );
        fprintf(formatC2, 'Electronics:',Cost.DriveTrain_Electronics,'[k$]',Cost.DriveTrain_Electronics*ConvRate, '[k€]' );
        fprintf(formatC2, 'Yaw drive:',Cost.DriveTrain_Yaw,'[k$]',Cost.DriveTrain_Yaw*ConvRate, '[k€]' );
        fprintf(formatC2, 'Mainframe:',Cost.DriveTrain_MainFrame,'[k$]',Cost.DriveTrain_MainFrame*ConvRate, '[k€]' );
        fprintf(formatC2, 'Electricals:',Cost.DriveTrain_Electrical,'[k$]',Cost.DriveTrain_Electrical*ConvRate, '[k€]' );
        fprintf(formatC2, 'Hydraulics, cooling:',Cost.DriveTrain_Cooling,'[k$]',Cost.DriveTrain_Cooling*ConvRate, '[k€]' );
        fprintf(formatC2, 'Nacelle cover:',Cost.DriveTrain_Nacelle,'[k$]',Cost.DriveTrain_Nacelle*ConvRate, '[k€]' );
    fprintf('\n');
    fprintf(formatC1, 'Control, safety:', Cost.Control,'[k$]',Cost.Control*ConvRate, '[k€]' );
    fprintf(formatC1, 'Tower:', Cost.Tower,'[k$]',Cost.Tower*ConvRate, '[k€]' );
    fprintf(formatC1, 'Marinization:', Cost.Marinization,'[k$]',Cost.Marinization*ConvRate, '[k€]' );
    fprintf('\t \t \t \t \t \t \t \t \t \t \t \t %s \n','------------------------------------') 
    fprintf(formatC1, 'TCC - TURBINE CAPITAL COST:', Cost.TCC,'[k$]',Cost.TCC*ConvRate, '[k€]' );
    fprintf('\t \t \t \t \t \t \t \t \t \t \t \t %s \n','------------------------------------') 
    fprintf('\n');
        fprintf(formatC2, 'Foundations:',Cost.Foundation,'[k$]',Cost.Foundation*ConvRate, '[k€]' );
        fprintf(formatC2, 'Transportation:',Cost.Transportation,'[k$]',Cost.Transportation*ConvRate, '[k€]' );
        if Parameters.CostModel.Offshore==0
        fprintf(formatC2, 'Civil work:',Cost.CivilWork,'[k$]',Cost.CivilWork*ConvRate, '[k€]' );
        end
        fprintf(formatC2, 'Installation:',Cost.Installation,'[k$]',Cost.Installation*ConvRate, '[k€]' );
        fprintf(formatC2, 'Interface:',Cost.Interface,'[k$]',Cost.Interface*ConvRate, '[k€]' );
        fprintf(formatC2, 'Engineering:',Cost.Eng,'[k$]',Cost.Eng*ConvRate, '[k€]' );
        if Parameters.CostModel.Offshore==1
            fprintf(formatC2, 'Port and staging:',Cost.PortAndStaging,'[k$]',Cost.PortAndStaging*ConvRate, '[k€]' );    
            fprintf(formatC2, 'Personal access:',Cost.Access,'[k$]',Cost.Access*ConvRate, '[k€]' );    
            fprintf(formatC2, 'Scour protection:',Cost.ScourProtection,'[k$]',Cost.ScourProtection*ConvRate, '[k€]' );                
        end
    fprintf('\t \t \t \t \t \t \t \t \t \t \t \t %s \n','------------------------------------') 
    fprintf(formatC1, 'BOS - BALANCE OF STATION:', Cost.BOS,'[k$]',Cost.BOS*ConvRate, '[k€]' );
    fprintf('\t \t \t \t \t \t \t \t \t \t \t \t %s \n','------------------------------------') 
    fprintf('\n');  
    if Parameters.CostModel.Offshore==1
        fprintf(formatC1, 'Offshore warranty:',Cost.Offshore,'[k$]',Cost.Offshore*ConvRate, '[k€]' );
        fprintf(formatC1, 'Surety bond:',Cost.Surety,'[k$]',Cost.Surety*ConvRate, '[k€]' );
        fprintf('\n'); 
    end
    
    fprintf(formatC1, 'ICC - INITIAL CAPITAL COST (TCC+BOS):', Cost.ICC,'[k$]',Cost.ICC*ConvRate, '[k€]' );
    fprintf('------------------------------------------------------------------------------------\n') 
        fprintf(formatC2, 'Installed cost per kW:',Cost.IC,'[$]',Cost.IC*ConvRate, '[€]' );   
        fprintf(formatC2, 'Turbine Capital per kW sans BOS & warranty:',Cost.TC,'[$]',Cost.TC*ConvRate, '[€]' );    
    fprintf('------------------------------------------------------------------------------------\n') 
    fprintf(formatC1, 'Levelized Replacement Cost per year:', Cost.LRC,'[k$]',Cost.LRC*ConvRate, '[k€]' );
    fprintf(formatC1, 'O&M per year:', Cost.OEM,'[k$]',Cost.OEM*ConvRate, '[k€]' );
    fprintf(formatC1, 'Land Lease Cost per year:', Cost.LLC,'[k$]',Cost.LLC*ConvRate, '[k€]' );
    fprintf('------------------------------------------------------------------------------------\n') 
    fprintf(formatC4, 'Net Annual energy Production:', Cost.AEPnet/1e3,'[MWh]' );
    fprintf(formatC4, 'Fixed Charge Rate:', Cost.FCR*100,'[%]' );
    fprintf(formatC5, 'Annual Operative Expenses:', Cost.AOE,'[$/kWh]', Cost.AOE*ConvRate,'[€/kWh]');
    fprintf('------------------------------------------------------------------------------------\n') 
    fprintf(formatC5, 'Cost Of Energy [$/kWh]:',coe,'[$/kWh]', coe*ConvRate, '[€/kWh]' );
    fprintf(formatC6, 'Cost Of Energy [$/MWh]:',coe*1e3,'[$/MWh]', coe*1e3*ConvRate, '[€/MWh]' );

disp('====================================================================================')
