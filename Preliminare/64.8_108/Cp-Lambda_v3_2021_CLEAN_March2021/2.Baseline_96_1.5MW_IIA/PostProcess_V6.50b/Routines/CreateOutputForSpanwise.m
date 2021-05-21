function spanwise_loads = CreateOutputForSpanwise(eta_sensors,n_blades,Envelope)

eta_sensors = eta_sensors.*100;

%% Create graphic for each blade
for ib = 1:n_blades
    for ieta = 1:length(eta_sensors)
        % Recover sens name
        sens_name = ['Blade' num2str(ib) '_Loads_eta' num2str(eta_sensors(ieta))];
        
        % Recover Envelope
        envelope = Envelope.(sens_name).Matrix;
        
        % Extract max/min
        spanwise_loads_individual{ib}.eta(ieta) = eta_sensors(ieta)/100;
        spanwise_loads_individual{ib}.max(ieta) = envelope(9,5);
        spanwise_loads_individual{ib}.min(ieta) = envelope(10,5);
    end
    % Add load = 0 at tip
    spanwise_loads_individual{ib}.eta(end+1) = 1;
    spanwise_loads_individual{ib}.max(end+1) = 0;
    spanwise_loads_individual{ib}.min(end+1) = 0;
end


%% Create locus of maximums/minimums for all blades
for ieta = 1:length(spanwise_loads_individual{1}.eta)
    spanwise_loads.eta(ieta) = spanwise_loads_individual{1}.eta(ieta);
    
    for ib = 1:n_blades
        all_loads_max(ib) = spanwise_loads_individual{ib}.max(ieta);
        all_loads_min(ib) = spanwise_loads_individual{ib}.min(ieta);
    end
    
    spanwise_loads.max(ieta)    =   max(all_loads_max);
    spanwise_loads.min(ieta)    =   min(all_loads_min);
        
    
end

color_palette = [   0       0       1; 
                    0       0.5     0; 
                    0.2     0.7     1];
legendstr     = [];

%% Plot spanwise maximum/minimum
figure
hold on
grid on
for ib = 1:n_blades 
    plot(spanwise_loads_individual{ib}.eta,spanwise_loads_individual{ib}.max,'Color',color_palette(ib,:),'LineWidth',1.5,'LineStyle','-')
    plot(spanwise_loads_individual{ib}.eta,spanwise_loads_individual{ib}.min,'Color',color_palette(ib,:),'LineWidth',1.5,'LineStyle','--')
    legendstr{end+1} = ['Blade_' num2str(ib) '_MAX'];
    legendstr{end+1} = ['Blade_' num2str(ib) '_Min'];
end

plot(spanwise_loads.eta,spanwise_loads.max,'Color',[0.9 0.3 1],'LineWidth',1.5,'LineStyle','-')
plot(spanwise_loads.eta,spanwise_loads.min,'Color',[0.9 0.3 1],'LineWidth',1.5,'LineStyle','--')

legendstr{end+1} = ['All Blades MAX']; legendstr{end+1} = ['All Blades Min'];

legend(legendstr,'FontSize',12,'Interpreter','None')
xlabel('Nondimensional spanwise location [-]','Fontsize',14)
ylabel('Max/min flapwsie bending [kNm]','Fontsize',14)
title('Spanwise ultimate loads distribution')

