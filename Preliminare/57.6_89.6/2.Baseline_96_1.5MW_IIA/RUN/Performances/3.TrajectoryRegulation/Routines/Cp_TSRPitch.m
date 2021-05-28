% Spline interpolation of Cp-TSR-Pitch curves
function Cp = Cp_TSRPitch(p,Parameters)

Cp = -interp2(Parameters.TSR,Parameters.Pitch,Parameters.Cp,p(1),p(2),'spline');
% Cp = -interp2(Parameters.TSR,Parameters.Pitch,Parameters.Cp,p(1),p(2),'cubic');

