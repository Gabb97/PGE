function [MassTower, Cost] = EstimateTowerCost(Parameters)
%% This functions estimates the cost of the tower, using cost estimations from 
% "Wind Turbine Design Cost and Scaling Model", Authors: L.Fingersh, M.Hand, and A. Laxson
%%
%%
%% Revision
% Added a line to use actual tower mass, if given.
% added comment
%%
% Parameters.CostModel.TowerCostModel:
% if 1 baseline tower cost model
% if 2 advanced tower cost model
% if 3 use actual tower mass calculated by CpMax and stored in Parameters.Tower.TotalMass

R         = Parameters.Rotor.RotorDiameter/2;
sweptarea = pi*R^2;
hubheight = Parameters.Rotor.HubHeight;
BCE       = Parameters.CostModel.BCE;

if Parameters.CostModel.TowerCostModel == 1
   MassTower = 0.3973*sweptarea*hubheight - 1414;   
   
elseif  Parameters.CostModel.TowerCostModel == 2
    MassTower = 0.2694*sweptarea*hubheight + 1779;

 elseif  Parameters.CostModel.TowerCostModel == 3
	MassTower = Parameters.Tower.TotalMass;
    
else
    error('Parameters.CostModel.TowerCostModel not defined correctly');
end

% Cost of steel in 2002 $ was 1.50 $/kg, so we multiply by 1.50 
% and scale to actual costs with BCE

Cost = MassTower*1.50*BCE;

end
