function CE_PieCharts(Parameters,Cost)

Offshore    =   Parameters.CostModel.Offshore ;
PlotLegend  =   1;
PlotTitle   =   1;
SavePlot    =   0;
PlotLabels  =   1;


%% Pie chart Rotor


PieRotor = [Cost.Rotor_Blades , Cost.Rotor_Hub , Cost.Rotor_PitchSys , Cost.Rotor_Spinner];
figure
labels = {'','','',''};
if PlotLabels
    pie(PieRotor)
else
    pie(PieRotor,labels) 
end

if PlotLegend
    legend('Blades' , 'Hub' , 'PitchSystem' , 'Nose')
end

colormap summer
if PlotTitle,   title('Rotor Cost'),                    end
if SavePlot,    print('-djpeg100','Rotor_Cost.jpg'),    end


%% Pie chart Drive Train, Nacelle


PieDriveTrainNacelle = [Cost.DriveTrain_GearBox, ...
                        Cost.DriveTrain_Shaft, ... 
                        Cost.DriveTrain_Bearing, ...
                        Cost.DriveTrain_Brake, ... 
                        Cost.DriveTrain_Generator, ... 
                        Cost.DriveTrain_Electronics ,...
						Cost.DriveTrain_Yaw,...
                        Cost.DriveTrain_MainFrame,...
                        Cost.DriveTrain_Electrical,...
                        Cost.DriveTrain_Cooling,...
                        Cost.DriveTrain_Nacelle];
                    
figure
labels = {'','','','','','','','','','',''};
if PlotLabels
    pie(PieDriveTrainNacelle)
else
    pie(PieDriveTrainNacelle,labels) 
end

if PlotLegend
                legend( 'GearBox','Shaft' , 'Bearing' , 'Brake' , 'Generator' ,'Electronics' ,...
				'Yaw' , 'MainFrame' , 'Electrical' , 'Cooling' , 'Nacelle');
end

colormap autumn
if PlotTitle,   title('Drive Train & Nacelle Cost'),                end
if SavePlot,    print('-djpeg100','DriveTrain_Nacelle_Cost.jpg'),   end


%% Pie chart Turbine Capital Cost

if Offshore
    labels      =   {'','','','',''}   ;
    PieTCC      =   [Cost.Rotor , Cost.DriveTrain , Cost.Tower, Cost.Control, Cost.Marinization];
    legendstr   =   {'Rotor' , 'DriveTrainNacelle' , 'Tower','Control & Safety','Marinization'};
else
    labels      =   {'','','',''}   ;
    PieTCC      =   [Cost.Rotor , Cost.DriveTrain , Cost.Tower, Cost.Control];
    legendstr   =   {'Rotor' , 'DriveTrainNacelle' , 'Tower','Control & Safety'};
end

figure
if PlotLabels
    pie(PieTCC)
else
    pie(PieTCC,labels)
end


if PlotLegend,  legend(legendstr),                                  end

colormap winter
if PlotTitle,   title('Turbine Capital Cost -  TCC'),               end
if SavePlot,    print('-djpeg100','Turbine_Capital_Cost.jpg'),      end


%% Balance Of Stations

if Offshore
    labels      =   {'','','','','','','',''}   ;
    PieBOS      =   [Cost.Foundation , Cost.Transportation , Cost.Installation , Cost.Interface , Cost.Eng, Cost.PortAndStaging, Cost.Access, Cost.ScourProtection ];
    legendstr   =   {'Foundation' , 'Transportation' ,  'Installation' , 'Interface' , 'Engineering', 'Port And Staging', 'Access', 'Scour Protection'};    
else
    labels      =   {'','','','','',''}   ;    
    PieBOS      =   [Cost.Foundation , Cost.Transportation ,  Cost.CivilWork , Cost.Installation , Cost.Interface , Cost.Eng];
    legendstr   =   {'Foundation' , 'Transportation' ,  'CivilWork' , 'Installation' , 'Interface' , 'Engineering'};
end
figure
if PlotLabels
    pie(PieBOS)
else
    pie(PieBOS,labels)
end

if PlotLegend
        legend('Foundation' , 'Transportation' ,  'CivilWork' , 'Installation' , 'Interface' , 'Engineering');
end

colormap cool
if PlotTitle,   title('Balance of station'),                        end
if SavePlot,    print('-djpeg100','Balance_of_Station.jpg'),        end


%% Initial Capital Cost


PieICC=[PieTCC,PieBOS];


if Offshore
     labels         =   {'','','','','','','','','','','','',''}   ;    
     legendstr      =    {'Rotor' , 'DriveTrainNacelle'  , 'Control % Safety', 'Tower', 'Marinization',...
                            'Foundation' , 'Transportation' ,  'Installation' , 'Interface' , 'Engineering', 'Port And Staging', 'Access', 'Scour Protection'};
else
     labels         =   {'','','','','','','','','',''}   ;        
     legendstr      =    {'Rotor' , 'DriveTrainNacelle'  , 'Control % Safety', 'Tower',...
                        'Foundation' , 'Transportation' ,  'CivilWork' , 'Installation' , 'Interface' , 'Engineering'};
end

figure

if PlotLabels
    pie(PieICC)
else
    pie(PieICC,labels)
end

if PlotLegend,      legend(legendstr),                              end
colormap default
if PlotTitle,       title('Initial capital cost'),                  end
if SavePlot,        print('-djpeg100','Initial_Capital_Cost.jpg'),  end


%% AOE 
Cost.AEPnet=Cost.AEPnet/1e3; % back to kW
PieAOE = [Cost.LRC,Cost.OEM,Cost.LLC];

labels         =   {'','',''}   ;        
legendstr      =    {'LRC' , 'O&M','Land lease'}; 

figure
if PlotLabels
    pie(PieAOE)
else
    pie(PieAOE,labels)
end

if PlotLegend,    legend(legendstr),        end
colormap cool
if PlotTitle,       title('AOE'),                        end
if SavePlot,        print('-djpeg100','aoe.jpg'),          end



%% Final CoE


Cost.AEPnet=Cost.AEPnet/1e3; % back to kW
Piecoe = 1000.*[PieICC*Cost.FCR/Cost.AEPnet, Cost.OEM/Cost.AEPnet, Cost.LRC/Cost.AEPnet, Cost.LLC/Cost.AEPnet];

if Offshore
     labels         =   {'','','','','','','','','','','','','','','',''}   ;    
     legendstr      =    {'Rotor' , 'DriveTrainNacelle'  , 'Control % Safety', 'Tower', 'Marinization',...
                            'Foundation' , 'Transportation' ,  'Installation' , 'Interface' , 'Engineering', 'Port And Staging', 'Access', 'Scour Protection','O&M','Levelized replacement','Land lease'};
else
     labels         =   {'','','','','','','','','','','','',''}   ;        
     legendstr      =    {'Rotor' , 'DriveTrainNacelle'  , 'Control % Safety', 'Tower',...
                        'Foundation' , 'Transportation' ,  'CivilWork' , 'Installation' , 'Interface' , 'Engineering','O&M','Levelized replacement','Land lease'};
end



 

figure
if PlotLabels
    pie(Piecoe)
else
    pie(Piecoe,labels)
end

if PlotLegend,    legend(legendstr),        end
colormap bone
if PlotTitle,       title('Cost of Energy'),                        end
if SavePlot,        print('-djpeg100','Coe_detailed.jpg'),          end

%% Final CoE

Cost.AEPnet=Cost.AEPnet/1e3; % back to kW
Piecoed = 1000.*[Cost.ICC*Cost.FCR/Cost.AEPnet, Cost.OEM/Cost.AEPnet, Cost.LRC/Cost.AEPnet, Cost.LLC/Cost.AEPnet];

labels         =   {'','','',''}   ;        
legendstr      =    {'ICC' , 'O&M','Levelized replacement','Land lease'}; 

figure
if PlotLabels
    pie(Piecoed)
else
    pie(Piecoed,labels)
end

if PlotLegend,    legend(legendstr),        end
colormap cool
if PlotTitle,       title('Cost of Energy'),                        end
if SavePlot,        print('-djpeg100','Coe.jpg'),          end


