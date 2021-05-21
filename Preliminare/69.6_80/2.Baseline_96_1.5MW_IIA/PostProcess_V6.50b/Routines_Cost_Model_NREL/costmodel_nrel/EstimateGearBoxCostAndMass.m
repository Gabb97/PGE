function [Cost, Mass] = EstimateGearBoxCostAndMass(rating,CostShaft,Parameters)
%% This Function estimates the cost and mass of the gearbox, using estimates from
% "Wind Turbine Design Cost and Scaling Model", Authors: L.Fingersh, M.Hand, and A. Laxson.
% The cost of the gearbox is based on the cost of the shaft and machine rating
%%
% case 1 - Three stage Planetary/ Helical
% case 2 - Single-Stage Drive with Medium Speed Generator
% case 3 - Multi-Path Drive with multiple generators
% case 4 - direct drive --> so no gearbox !

switch Parameters.CostModel.GearBoxCostModel
	case 1
			Mass = 70.94*CostShaft^(0.759);
			Cost = 16.45*rating^(1.249);
	case 2
			Mass = 88.29*CostShaft^(0.774);
			Cost = 74.1*rating^(1.0);
	case 3
			Mass = 139.69*CostShaft^(0.774);
			Cost = 15.26*rating^(1.249);
	case 4
			Mass = 0; Cost = 0;
	otherwise
	error('Parameters.CostModel.GearBoxCostModel not defined correctly');
end