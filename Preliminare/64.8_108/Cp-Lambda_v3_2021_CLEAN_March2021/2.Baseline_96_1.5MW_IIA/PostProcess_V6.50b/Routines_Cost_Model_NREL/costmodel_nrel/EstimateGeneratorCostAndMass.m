function [Cost, Mass] = EstimateGearBoxCostAndMass(rating,CostShaft,Parameters)
%% This Function estimates the cost and mass of the generator, using estimates from
% "Wind Turbine Design Cost and Scaling Model", Authors: L.Fingersh, M.Hand, and A. Laxson.
% The cost of the generator is based on machine rating
%%
% case 1 - Three stage drive with high-speed generator
% case 2 - Single-Stage Drive with Medium Speed, permanent-magnet Generator
% case 3 - Multi-Path Drive with permanent-magnet generator
% case 4 - direct drive 

switch Parameters.CostModel.GeneratorCostModel
	case 1
			Mass = 6.47*rating^(0.9223);
			Cost = 65*rating;
	case 2
			Mass = 10.51*rating^(0.9223);
			Cost = 54.73*rating;
	case 3
			Mass = 5.34*rating^(0.9223);
			Cost = 48.03*rating;
	case 4
			Mass = 661.25*CostShaft^(0.606);
			Cost = 219.33*rating;
	otherwise
	error('Parameters.CostModel.GeneratorCostModel not defined correctly');
end