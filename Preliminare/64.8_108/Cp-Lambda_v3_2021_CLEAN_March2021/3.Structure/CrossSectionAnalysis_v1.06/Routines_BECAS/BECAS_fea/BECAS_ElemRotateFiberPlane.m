function [ Qf ] = BECAS_ElemRotateFiberPlane( Qm, c, s )
%********************************************************
% File: BECAS_ElemRotateLayer.m
%   Function to rotate the element material constitutive matrix
%   to account for the fiber plane orientation.
%
% Syntax:
%   [ Qf ] = BECAS_ElemRotateFiberPlane( Qm, c, s )
%
% Input:
%   Qm      :  Material constitutive in the material coordinate
%              system
%   c,s     :  Cosine and sine of the fiber plane angle
%
% Output:
%   Qf      :  Rotated material constitutive matrix
%
% Calls:
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

t1 = (c ^ 2);
t3 = (s ^ 2);
t7 = 2 * Qm(1,3) * c * s;
t8 = Qm(1,1) * t1 + Qm(1,2) * t3 + t7;
t14 = 2 * Qm(3,3) * c * s;
t15 = Qm(3,1) * t1 + Qm(3,2) * t3 + t14;
t16 = s * t15;
t17 = c * t8 + t16;
t19 = c * t15;
t24 = 2 * Qm(2,3) * c * s;
t25 = Qm(2,1) * t1 + Qm(2,2) * t3 + t24;
t27 = t19 + s * t25;
t32 = Qm(1,1) * t3 + Qm(1,2) * t1 - t7;
t36 = Qm(3,1) * t3 + Qm(3,2) * t1 - t14;
t37 = s * t36;
t38 = c * t32 + t37;
t40 = c * t36;
t43 = Qm(2,1) * t3 + Qm(2,2) * t1 - t24;
t45 = t40 + s * t43;
t56 = -0.10e1 * t3 + 0.10e1 * t1;
t58 = -0.10e1 * Qm(1,1) * c * s + 0.10e1 * Qm(1,2) * c * s + Qm(1,3) * t56;
t67 = -0.10e1 * Qm(3,1) * c * s + 0.10e1 * Qm(3,2) * c * s + Qm(3,3) * t56;
t68 = s * t67;
t69 = c * t58 + t68;
t71 = c * t67;
t79 = -0.10e1 * Qm(2,1) * c * s + 0.10e1 * Qm(2,2) * c * s + Qm(2,3) * t56;
t81 = t71 + s * t79;
t88 = 0.10e1 * Qm(1,4) * c + 0.10e1 * Qm(1,5) * s;
t94 = 0.10e1 * Qm(3,4) * c + 0.10e1 * Qm(3,5) * s;
t95 = s * t94;
t96 = c * t88 + t95;
t98 = c * t94;
t103 = 0.10e1 * Qm(2,4) * c + 0.10e1 * Qm(2,5) * s;
t105 = t98 + s * t103;
t112 = -0.10e1 * Qm(1,4) * s + 0.10e1 * Qm(1,5) * c;
t118 = -0.10e1 * Qm(3,4) * s + 0.10e1 * Qm(3,5) * c;
t119 = s * t118;
t120 = c * t112 + t119;
t122 = c * t118;
t127 = -0.10e1 * Qm(2,4) * s + 0.10e1 * Qm(2,5) * c;
t129 = t122 + s * t127;
t133 = s * Qm(3,6);
t134 = c * Qm(1,6) + t133;
t136 = c * Qm(3,6);
t138 = t136 + s * Qm(2,6);
t205 = 2 * Qm(4,3) * c * s;
t206 = Qm(4,1) * t1 + Qm(4,2) * t3 + t205;
t212 = 2 * Qm(5,3) * c * s;
t213 = Qm(5,1) * t1 + Qm(5,2) * t3 + t212;
t218 = Qm(4,1) * t3 + Qm(4,2) * t1 - t205;
t222 = Qm(5,1) * t3 + Qm(5,2) * t1 - t212;
t232 = -0.10e1 * Qm(4,1) * c * s + 0.10e1 * Qm(4,2) * c * s + Qm(4,3) * t56;
t241 = -0.10e1 * Qm(5,1) * c * s + 0.10e1 * Qm(5,2) * c * s + Qm(5,3) * t56;
t248 = 0.10e1 * Qm(4,4) * c + 0.10e1 * Qm(4,5) * s;
t254 = 0.10e1 * Qm(5,4) * c + 0.10e1 * Qm(5,5) * s;
t261 = -0.10e1 * Qm(4,4) * s + 0.10e1 * Qm(4,5) * c;
t267 = -0.10e1 * Qm(5,4) * s + 0.10e1 * Qm(5,5) * c;
t295 = 2 * Qm(6,3) * c * s;
Qf(1,1) = t17 * c + t27 * s;
Qf(1,2) = t38 * c + t45 * s;
Qf(1,3) = (t69 * c + t81 * s);
Qf(1,4) = (t96 * c + t105 * s);
Qf(1,5) = (t120 * c + t129 * s);
Qf(1,6) = t134 * c + t138 * s;
Qf(2,1) = -(-s * t8 + t19) * s + (-t16 + c * t25) * c;
Qf(2,2) = -(-s * t32 + t40) * s + (-t37 + c * t43) * c;
Qf(2,3) = (-(-s * t58 + t71) * s + (-t68 + c * t79) * c);
Qf(2,4) = (-(-s * t88 + t98) * s + (-t95 + c * t103) * c);
Qf(2,5) = (-(-s * t112 + t122) * s + (-t119 + c * t127) * c);
Qf(2,6) = -(-s * Qm(1,6) + t136) * s + (-t133 + c * Qm(2,6)) * c;
Qf(3,1) = -t17 * s + t27 * c;
Qf(3,2) = -t38 * s + t45 * c;
Qf(3,3) = (-t69 * s + t81 * c);
Qf(3,4) = (-t96 * s + t105 * c);
Qf(3,5) = (-t120 * s + t129 * c);
Qf(3,6) = -t134 * s + t138 * c;
Qf(4,1) = c * t206 + s * t213;
Qf(4,2) = c * t218 + s * t222;
Qf(4,3) = (c * t232 + s * t241);
Qf(4,4) = (c * t248 + s * t254);
Qf(4,5) = (c * t261 + s * t267);
Qf(4,6) = c * Qm(4,6) + s * Qm(5,6);
Qf(5,1) = -s * t206 + c * t213;
Qf(5,2) = -s * t218 + c * t222;
Qf(5,3) = (-s * t232 + c * t241);
Qf(5,4) = (-s * t248 + c * t254);
Qf(5,5) = (-s * t261 + c * t267);
Qf(5,6) = -s * Qm(4,6) + c * Qm(5,6);
Qf(6,1) = Qm(6,1) * t1 + Qm(6,2) * t3 + t295;
Qf(6,2) = Qm(6,1) * t3 + Qm(6,2) * t1 - t295;
Qf(6,3) = (-0.10e1 * Qm(6,1) * c * s + 0.10e1 * Qm(6,2) * c * s + Qm(6,3) * t56);
Qf(6,4) = (0.10e1 * Qm(6,4) * c + 0.10e1 * Qm(6,5) * s);
Qf(6,5) = (-0.10e1 * Qm(6,4) * s + 0.10e1 * Qm(6,5) * c);
Qf(6,6) = Qm(6,6);

end
