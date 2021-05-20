BCE = 1.1554;
FCR = 0.1158;
etaAEP = 0.9;


AEPnet = AEP*etaAEP;  %AEP in [kWh/ 1 yr] %7.557488946674606e+006 
%BladeMass [kg]                           %6.977526207676435e+003

Rm = (BladeMass/0.1452)^(1/2.9158);

CostBlade = 3*(8*BladeMass + 21465)*BCE ;

CostHub =  (0.954*(BladeMass)+5680.3)*4.25;

CostPitchSystem = 2.28*(0.2106*(2*Rm)^2.6578);

CostNose =  6.6222e+003;

CostRotor = CostBlade + CostHub + CostPitchSystem + CostNose;

TCC = CostRotor + 1.235946509097057e+006;

BOS = 5.627599411374263e+005;

ICC = TCC + BOS;

CostOEM = 0.007*AEP;
CostLRC = 23540;
CostLLC = 0.00108;

AOE = CostLLC + (CostOEM + CostLRC)/AEPnet ;

%Cost of energy in $/kWh
coe = (FCR * ICC)/AEPnet + AOE;