function [BladeGeom]=BS_InterpolateGeometry( InputBlade, RadialPos,Eta)

NumberOfSections=length(RadialPos);

for i=1:NumberOfSections
    BladeGeom.RadialPos(i)=RadialPos(i);
    BladeGeom.Eta(i)=Eta(i);
    BladeGeom.Chord(i)=interp1(InputBlade.RadialPos,InputBlade.Chord,RadialPos(i));
    BladeGeom.Twist(i)=interp1(InputBlade.RadialPos,InputBlade.Twist,RadialPos(i));
    BladeGeom.LeadingEdge(i)=interp1(InputBlade.RadialPos,InputBlade.LeadingEdge,RadialPos(i));
    BladeGeom.TrailingEdge(i)=interp1(InputBlade.RadialPos,InputBlade.TrailingEdge,RadialPos(i));
    BladeGeom.FrontSpar(i)=interp1(InputBlade.RadialPos,InputBlade.FrontSpar,RadialPos(i));
    BladeGeom.RearSpar(i)=interp1(InputBlade.RadialPos,InputBlade.RearSpar,RadialPos(i));
    BladeGeom.LEReinf(i)=interp1(InputBlade.RadialPos,InputBlade.LEReinf,RadialPos(i));
    BladeGeom.TEReinf(i)=interp1(InputBlade.RadialPos,InputBlade.TEReinf,RadialPos(i));
    BladeGeom.NonStrucMass(i)=interp1(InputBlade.RadialPos,InputBlade.NonStrucMass,RadialPos(i));
end

