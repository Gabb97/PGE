function [InterpAirf]=BS_InterpolateAirfoils(Input,radialPos)
% This subroutine takes the geometries of the prescribed airfoils and
% interpolate them in order to obtain the correct sectional shape at the
% required radial positions
%
% Input: a NumberOfAirfoils-length cell containing the geometries of the
%        prescribed airfoils.
% 
% Output: a radialPos-length cell containing the interpolated geometries at
%         each radial position under evaluation.      

%%======================================================================
%% Interpolate each geometry file/refine geometry
%%======================================================================
% Since airfoil geometries should have different points, it is important 
% that they are defined at the same x-points, so that subsequent
% interpolation could be performed.

for i=1:Input.Airfoils.AirfNumb
        [i_RefinedAirfoilGeometry]=RefineAirfoilGeometry(Input.Airfoils.AirfGeom{i});
        Input.Airfoils.AirfGeom{i}=i_RefinedAirfoilGeometry;
        i_RefinedAirfoilGeometry=[];
end

%%======================================================================
%% Interpolate each geometry file/refine geometry
%%======================================================================
% Initialize cell
NumberOfSections    =   length(radialPos);
InterpAirf          =   cell(NumberOfSections,1);

r_airf               =   Input.Airfoils.AirfPos;
t_airf                      =   Input.Airfoils.AirfThick;

% Build t/c along the blade
t = interp1(Input.Blade.RadialPos, Input.Blade.Thickness, radialPos,'pchip');

% figure()
% hold on
% grid on
% plot(Input.Airfoils.AirfPos,Input.Airfoils.AirfThick,'om')
% plot(radialPos,t)
% keyboard


for i=1: NumberOfSections
    r   =   radialPos(i);
    
    hh  =   find(r_airf==r );
    
    if isempty(hh)
        % If no, then identify the 2 closest (bounding) airfoil r(s):
        % Hint: eta2 is closer 2 the tip.
        % Hint: eta1,2 are NOT eta values, but index of the airfoil eta
        %       array.
        eta1    =   find(r_airf<=r,1,'last');
        eta2    =   find(r_airf>r,1,'first');
        if isempty(eta2)
            % we are at eta==1...
            p1=0;
            p2=1;
            eta1=n-1;
            eta2=n;
        else if t_airf(eta2)==t_airf(eta1)
                % the 2 bounding airfoils have the same thickness: guess
                % what thickness this section takes...
                p1=1;
                p2=0;
            else
                % 
                p1=(t_airf(eta2)-t(i))/(t_airf(eta2)-t_airf(eta1));
                p2=(t(i)-t_airf(eta1))/(t_airf(eta2)-t_airf(eta1));
            end
        end
    else
        % If yes, then eta1 & 2 are exactely the same, and both coincide
        % with the current OptiSect.
        p1=0;
        p2=1;
        eta1=hh;
        eta2=hh;
    end
        
        
        
    [i_InterpolatedAirfoil]=FindInterpolatedAirfoil(Input,r,eta1,eta2,p1,p2);
    InterpAirf{i}=i_InterpolatedAirfoil;
    i_InterpolatedAirfoil=[];
end








