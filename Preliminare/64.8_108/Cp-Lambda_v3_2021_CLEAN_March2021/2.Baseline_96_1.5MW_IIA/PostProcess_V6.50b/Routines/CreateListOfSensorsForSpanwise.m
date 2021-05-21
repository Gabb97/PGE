function sensors = CreateListOfSensorsForSpanwise(eta_sensors,n_blades)

sensors = [];

eta_sensors = eta_sensors.*100;

for ib = 1:n_blades
     
    for ieta = 1:length(eta_sensors)
        sens_name = ['Blade' num2str(ib) '_Loads_eta' num2str(eta_sensors(ieta))];
        
        sensors{end+1} = sens_name;       
        
    end
    
    
end
