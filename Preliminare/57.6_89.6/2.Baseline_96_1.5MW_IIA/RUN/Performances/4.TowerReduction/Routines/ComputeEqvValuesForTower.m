function [Tower]=ComputeEqvValuesForTower(Parameters)

% AROUND ZERO ZERO AERODYNAMIC FORCE
delta_0 = Parameters.ForeAftDispl(1);
delta   = Parameters.ForeAftDispl(2:end);

delta_rel = delta-delta_0;

K_equivalent = Parameters.ForceVector(2:end) ./(delta - delta_0);

figure
plot(delta_rel,K_equivalent,'o-b');%,[delta_rel(1) delta_rel(end)],[K_equivalent(1) K_equivalent(end)],'-r');
grid;

%% SPRING
% Added by Ale. 22.march.2005
Keqv = polyfit(delta_rel(1:5),K_equivalent(1:5),0);
hold on
plot(delta_rel,Keqv*ones(size(K_equivalent)),'r')
close

%% MASS from 1st eigs
Meqv = Keqv/(Parameters.FirstTowerFAFreq^2);

%% DAMPER from Critical damping 
C_critical = 2*sqrt(Meqv*Keqv);
Ceqv = Parameters.zeta*C_critical;

%% SAVE AND WRITE on FILE
Tower.M = Meqv;
Tower.C = Ceqv;
Tower.K = Keqv;

Tower

fin=fopen('.\Output\TowerParameters.txt','w');
if (fin<0)
    disp('Unable to write TowerParameters.txt file!');
    disp('Check if exist Output dir!');
    return
end

fprintf(fin,'\nTOWER');
fprintf(fin,'\nM           %1.5e',Tower.M);
fprintf(fin,'\nK           %1.5e',Tower.K);
fprintf(fin,'\nC           %1.5e',Tower.C);
fclose(fin);

