function [RefinedAirfoilGeometry]=RefineAirfoilGeometry(GivenAirfGeometry)


DataLen=length(GivenAirfGeometry(:,1));
% Identify upper and lower curves
Separator=0;

for j=1:DataLen
    if GivenAirfGeometry(j,1) ~= 0
        Separator=0;
    else
        Separator=j;
        break
    end
end

% Separate upper and lower curves
UpperGeometry(:,1)=GivenAirfGeometry(1:Separator,1);
UpperGeometry(:,2)=GivenAirfGeometry(1:Separator,2);
LowerGeometry(:,1)=GivenAirfGeometry(Separator+1:DataLen,1);
LowerGeometry(:,2)=GivenAirfGeometry(Separator+1:DataLen,2);

% Define refined x
RefinedX=cosspace(0,1,111); % RefinedX=linspace(0,1,111);

% Re-mesh upper curve
    % flip data
    FlipUpperGeometry(:,1)=flipud(UpperGeometry(:,1));
    FlipUpperGeometry(:,2)=flipud(UpperGeometry(:,2));
    % interpolate upper curve 
    FlipRefinedUpperGeometry(:,1)=RefinedX;
    FlipRefinedUpperGeometry(:,2)=interp1(FlipUpperGeometry(:,1),FlipUpperGeometry(:,2),RefinedX);
    % flip back
    RefinedUpperGeometry(:,1)=flipud(FlipRefinedUpperGeometry(:,1));
    RefinedUpperGeometry(:,2)=flipud(FlipRefinedUpperGeometry(:,2));
    
% Re-mesh lower curve
    % interpolate lower curve 
    RefinedLowerGeometry(:,1)=RefinedX;
    RefinedLowerGeometry(:,2)=interp1(LowerGeometry(:,1),LowerGeometry(:,2),RefinedX);


% Put the two curves together and assign to output
RefinedAirfoilGeometry(:,1)=[RefinedUpperGeometry(:,1);RefinedLowerGeometry(:,1)];
RefinedAirfoilGeometry(:,2)=[RefinedUpperGeometry(:,2);RefinedLowerGeometry(:,2)];



%% Check figure

% figure
% hold on
% grid on
% axis equal
% plot(GivenAirfGeometry(:,1),GivenAirfGeometry(:,2),'Marker','Square')
% plot(RefinedAirfoilGeometry(:,1),RefinedAirfoilGeometry(:,2),'g','Marker','Square')
% % plot(RefinedUpperGeometry(:,1),RefinedUpperGeometry(:,2),'m','Marker','Square')
% % plot(RefinedLowerGeometry(:,1),RefinedLowerGeometry(:,2),'g','Marker','Square')
% pause