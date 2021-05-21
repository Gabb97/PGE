function [Cost, Mass] = EstimateMainFrameCostAndMass(Parameters)
%% This Function estimates the cost and mass of the mainframe, platform and railings.
%  using estimates from  "Wind Turbine Design Cost and Scaling Model",
%  Authors: L.Fingersh, M.Hand, and A. Laxson.
% The cost and mass of the mainframe is based on the rotor diameter
%%
% case 1 - Three stage drive with high-speed generator
% case 2 - Single-Stage Drive with Medium Speed, permanent-magnet Generator
% case 3 - Multi-Path Drive with permanent-magnet generator
% case 4 - direct drive 

diameter = Parameters.Rotor.RotorDiameter;

switch Parameters.CostModel.MainFrameCostModel
	case 1
			Mass = 2.233*diameter^(1.953);
			Cost = 9.489*diameter^(1.953);
	case 2
			Mass = 1.295*diameter^(1.953);
			Cost = 303.96*diameter^(1.067);
	case 3
			Mass = 1.721*diameter^(1.953);
			Cost = 17.92*diameter^(1.672);
	case 4
			Mass = 1.228*diameter^(1.953);
			Cost = 627.28*diameter^(0.85);
	otherwise
	error('Parameters.CostModel.MainFrameCostModel not defined correctly');
end

% Now add platform and railings
PlatformAndRailingsMass =  0.125*Mass;
PlatformAndRailingsCost =  8.7*Mass;

Mass = Mass + PlatformAndRailingsMass;
Cost = Cost + PlatformAndRailingsCost;

end