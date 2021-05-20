function [InterpolatedAirfoil]=FindInterpolatedAirfoil(Input,r,eta1,eta2,p1,p2)


AirfoilGeom = Input.Airfoils.AirfGeom;

 for j=1:length(AirfoilGeom{1}(:,1))
        for k=1:length(AirfoilGeom{1}(1,:))                      
            InterpolatedAirfoil(j,k) = AirfoilGeom{eta1}(j,k)*p1+AirfoilGeom{eta2}(j,k)*p2;
        end
 end
    
% % Plot 4 debug
% figure(99)
% hold on
% grid on
% axis equal
% 
% plot(AirfoilGeom{eta1}(:,1),AirfoilGeom{eta1}(:,2),'-b','LineWidth',1.5)
% plot(InterpolatedAirfoil(:,1),InterpolatedAirfoil(:,2),'c','LineWidth',1.5)
% plot(AirfoilGeom{eta2}(:,1),AirfoilGeom{eta2}(:,2),':b','LineWidth',1.5)
% 
% legendstr{1} =  strcat('Airf ',32,num2str(eta1),32,'pos =',32,num2str(Input.Airfoils.AirfPos(eta1)));
% legendstr{2} =  strcat('r =',32,num2str(r));
% legendstr{3} =  strcat('Airf ',32,num2str(eta2),32,'pos =',32,num2str(Input.Airfoils.AirfPos(eta2)));
% legend(legendstr)
% keyboard
% close(99)




%% OLD VERSION 2 BE DELETED






% % Compute number of points defining airfoil geometry
% AirfGeomSample=InputAirf.AirfGeom{1};
% AirfGeomLength=length(AirfGeomSample(:,1));
% 
% % interpolate each y-point of the geometry
% for k=1:AirfGeomLength
%     % build x-points array:
%     % x-points are the points where prescribed airfoils are assigned
%     rData=InputAirf.AirfPos;
%     % build y-points array
%     for kk=1:InputAirf.AirfNumb
%         kk_AirfoilGeom=InputAirf.AirfGeom{kk};
%         yData(kk)=kk_AirfoilGeom(k,2);
%     end
%     % the x are the same for each airfoil, because each geometry has been
%     % 'redifend' at the same x. So, they are the same also for interpolated
%     % airfoils.
%     InterpolatedAirfoil(k,1)=AirfGeomSample(k,1);
%     % NB use 'spline' only for validation. In the optimizer, leave
%     % 'interp1'.
%     if InterpMode==1
%         InterpolatedAirfoil(k,2)=interp1(rData,yData,RadialCord);    
%     else
%         InterpolatedAirfoil(k,2)=interp1(rData,yData,RadialCord,'spline');
%     end
% end

%% check figure
% figure
% hold on
% grid on
% axis equal
% for n=1:InputAirf.AirfNumb
%     Airf=InputAirf.AirfGeom{n};
%     plot(Airf(:,1),Airf(:,2));
%     Airf=[];
% end
% plot( InterpolatedAirfoil(:,1), InterpolatedAirfoil(:,2),'m')
% pause
    
