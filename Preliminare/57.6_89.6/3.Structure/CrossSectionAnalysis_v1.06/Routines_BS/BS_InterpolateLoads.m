function [Loads]=BS_InterpolateLoads( InputLoads, RadialPos)

NumberOfSections=length(RadialPos);

for i=1:NumberOfSections
   Loads.RadialPos(i)=RadialPos(i);
   Loads.Tx(i)=interp1(InputLoads.RadialPos,InputLoads.Tx,RadialPos(i));
   Loads.Ty(i)=interp1(InputLoads.RadialPos,InputLoads.Ty,RadialPos(i));
   Loads.Tz(i)=interp1(InputLoads.RadialPos,InputLoads.Tz,RadialPos(i));
   Loads.Mx(i)=interp1(InputLoads.RadialPos,InputLoads.Mx,RadialPos(i));
   Loads.My(i)=interp1(InputLoads.RadialPos,InputLoads.My,RadialPos(i));
   Loads.Mz(i)=interp1(InputLoads.RadialPos,InputLoads.Mz,RadialPos(i));
end


      



   