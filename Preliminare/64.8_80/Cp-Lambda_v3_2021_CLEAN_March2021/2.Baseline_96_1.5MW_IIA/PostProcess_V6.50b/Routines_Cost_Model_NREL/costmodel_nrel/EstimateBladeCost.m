function Cost = EstimateBladeCost(Parameters)
%% This function estimates the cost of a single blade, using one of the 4
% following empirical relation, depending on the value of Parametes.CostModel.BladeCostModel.
%%
% NREL 2005 refers to the mass-radius cost estimation given in 
% "Wind Turbine Design Cost and Scaling Model", Authors: L.Fingersh, M.Hand, and A. Laxson.
% NREL 2012 refers to mass-radius relationship used by Dykes et al (Report not published yet).
%
% case 1 - NREL 2005 (Ponzo) - cost includes material cost and labour cost, but these costs are not related to actual blade mass(only actual radius)
% case 2 - NREL 2005 - Like 1, but corrected with actual blade mass
% case 3 - NREL 2012 - Cost is based on blade mass and includes material costs, but not labour costs
% case 4 - Nrel 2012 - Like 3, but corrected with  labour cost estimates from NREL 2005
% case 5 - INNWIND 2012
%% TODO : 
% - Blade cost based on REAL mass of each component; knowing the cost
% of a kg of each component, calculate REAL blade cost from Bill Of Materials and parameters.optimization.initialThickness
% of each component.
% - automatich choice between advanced and fiberglass blade, knowing
% whether there are carbon spar, LE or TE reinforcements Etc.
%%

R         = Parameters.Rotor.RotorDiameter/2;
BCE       = Parameters.CostModel.BCE;
GDPE      = Parameters.CostModel.GDPE;
Mass      = Parameters.Blade.TotalMass;


if Parameters.CostModel.AdvancedBlade == 0
    switch Parameters.CostModel.BladeCostModel
        case 1
            Cost = ((0.4019*R^(3) - 955.24)*BCE + 2.7445*R^(2.5025)*GDPE) / (1 - 0.28);
        case 2
            % Radius Vs Mass function is "Mass = 0.1452*R^(2.9158) " for fiberglass blade
            % Thus Inverse function of Radius vs Mass for fiberglass blade is 
            R = ((2500*Mass)/363)^(5000/14579); 
            Cost = ((0.4019*R^(3) - 955.24)*BCE + 2.7445*R^(2.5025)*GDPE) / (1 - 0.28);
        case 3
            Cost = (8*Mass + 21465)*BCE ;
        case 4
            % Radius Vs Mass function is "Mass = 0.1452*R^(2.9158) " for fiberglass blade
            % Thus Inverse function of Radius vs Mass for fiberglass blade is 
            R = ((2500*Mass)/363)^(5000/14579);
            Cost = ((8*Mass + 21465)*BCE + 2.7445*R^(2.5025)*GDPE) / (1 - 0.28);
            warning('Check labour cost model, probably included in (8*Mass + 21465)*BCE')
        case 5
            % Innwind model
            Cost = (13.084*Mass - 4452.2)*BCE ;
        otherwise 
            error('Parameters.CostModel.BladeCostModel not defined correctly');
   end
    
elseif Parameters.CostModel.AdvancedBlade == 1
    switch Parameters.CostModel.BladeCostModel
        case 1
            Cost = ((0.4019*R^(3) - 21051)*BCE + 2.7445*R^(2.5025)*GDPE) / (1 - 0.28);
            warning('Advanced cost model derived from baseline cost model. Check Wind turbine design cost and scaling model 2006')
        case 2
            
            % Radius Vs Mass function is "Mass = 0.4948*R^(2.53)" for advanced blade
            % Thus Inverse function of Radius vs Mass for advanced blade is
            R = ((2500*Mass)/1237)^(100/253);
            Cost = ((0.4019*R^(3) - 21051)*BCE + 2.7445*R^(2.5025)*GDPE) / (1 - 0.28);
        case 3
            % Value in 2003 $
            Cost = (13*Mass + 5813.9)*Parameters.CostModel.InflationIndex ;
            % Now Cost is expressed in 2002 $
            
            %% CI vuole o no il denominatore ???
            %Cost = (Cost*BCE);
            Cost = (Cost*BCE)/(1 - 0.28);
        case 4
            % Radius Vs Mass function is "Mass = 0.4948*R^(2.53)" for advanced blade
            % Thus Inverse function of Radius vs Mass for advanced blade is
            R = ((2500*Mass)/1237)^(100/253);
            % Value in 2003 $
            Cost = (13*Mass + 5813.9)*Parameters.CostModel.InflationIndex ;
            % Now Cost is expressed in 2002 $
            Cost = Cost*BCE;
            Cost =  (Cost + 2.7445*R^(2.5025)*GDPE) / (1 - 0.28);
            warning('Check labour cost model, probably included in: (13*Mass + 5813.9)*Parameters.CostModel.InflationIndex')
        case 5
            warning('This option is only supported for the Baseline blade model');
        otherwise 
            error('Parameters.CostModel.BladeCostModel not defined correctly');
    end
else 
    error('Parameters.CostModel.AdvancedBlade not defined correctly');
end

end