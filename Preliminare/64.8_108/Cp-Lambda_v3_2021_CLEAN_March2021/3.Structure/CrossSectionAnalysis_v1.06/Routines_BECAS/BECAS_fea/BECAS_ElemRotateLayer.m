function [ Qp ] = BECAS_ElemRotateLayer( Qm, c, s )
%********************************************************
% File: BECAS_ElemRotateLayer.m
%   Function to rotate the element material constitutive matrix
%   to account for the layer rotation.
%
% Syntax:
%   [ Qp ] = BECAS_ElemRotateLayer( Qm, c, s )
%
% Input:
%   Qm      :  Material constitutive in the material coordinate
%              system
%   c,s     :  Cosine and sine of the of layer orientation
%
% Output:
%   Qp      :  Rotated material constitutive matrix
%
% Calls:
%
% Revisions:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

t1 = (c ^ 2);
t5 = 2 * Qm(1,4) * c * s;
t6 = s ^ 2;
t8 = Qm(1,1) * t1 - t5 + Qm(1,6) * t6;
t13 = 2 * Qm(4,4) * c * s;
t15 = Qm(4,1) * t1 - t13 + Qm(4,6) * t6;
t16 = s * t15;
t17 = c * t8 - t16;
t19 = c * t15;
t23 = 2 * Qm(6,4) * c * s;
t25 = Qm(6,1) * t1 - t23 + Qm(6,6) * t6;
t27 = t19 - s * t25;
t31 = s * Qm(4,2);
t32 = c * Qm(1,2) - t31;
t34 = c * Qm(4,2);
t36 = t34 - s * Qm(6,2);
t43 = 0.10e1 * Qm(1,3) * c - 0.10e1 * Qm(1,5) * s;
t49 = 0.10e1 * Qm(4,3) * c - 0.10e1 * Qm(4,5) * s;
t50 = s * t49;
t51 = c * t43 - t50;
t53 = c * t49;
t58 = 0.10e1 * Qm(6,3) * c - 0.10e1 * Qm(6,5) * s;
t60 = t53 - s * t58;
t68 = -0.10e1 * t6 + 0.10e1 * t1;
t73 = 0.10e1 * Qm(1,1) * c * s + Qm(1,4) * t68 - 0.10e1 * Qm(1,6) * c * s;
t82 = 0.10e1 * Qm(4,1) * c * s + Qm(4,4) * t68 - 0.10e1 * Qm(4,6) * c * s;
t83 = s * t82;
t84 = c * t73 - t83;
t86 = c * t82;
t94 = 0.10e1 * Qm(6,1) * c * s + Qm(6,4) * t68 - 0.10e1 * Qm(6,6) * c * s;
t96 = t86 - s * t94;
t103 = 0.10e1 * Qm(1,3) * s + 0.10e1 * Qm(1,5) * c;
t109 = 0.10e1 * Qm(4,3) * s + 0.10e1 * Qm(4,5) * c;
t110 = s * t109;
t111 = c * t103 - t110;
t113 = c * t109;
t118 = 0.10e1 * Qm(6,3) * s + 0.10e1 * Qm(6,5) * c;
t120 = t113 - s * t118;
t125 = Qm(1,1) * t6 + t5 + Qm(1,6) * t1;
t129 = Qm(4,1) * t6 + t13 + Qm(4,6) * t1;
t130 = s * t129;
t131 = c * t125 - t130;
t133 = c * t129;
t136 = Qm(6,1) * t6 + t23 + Qm(6,6) * t1;
t138 = t133 - s * t136;
t144 = 2 * Qm(2,4) * c * s;
t171 = 2 * Qm(3,4) * c * s;
t173 = Qm(3,1) * t1 - t171 + Qm(3,6) * t6;
t178 = 2 * Qm(5,4) * c * s;
t180 = Qm(5,1) * t1 - t178 + Qm(5,6) * t6;
t190 = 0.10e1 * Qm(3,3) * c - 0.10e1 * Qm(3,5) * s;
t196 = 0.10e1 * Qm(5,3) * c - 0.10e1 * Qm(5,5) * s;
t206 = 0.10e1 * Qm(3,1) * c * s + Qm(3,4) * t68 - 0.10e1 * Qm(3,6) * c * s;
t215 = 0.10e1 * Qm(5,1) * c * s + Qm(5,4) * t68 - 0.10e1 * Qm(5,6) * c * s;
t222 = 0.10e1 * Qm(3,3) * s + 0.10e1 * Qm(3,5) * c;
t228 = 0.10e1 * Qm(5,3) * s + 0.10e1 * Qm(5,5) * c;
t233 = Qm(3,1) * t6 + t171 + Qm(3,6) * t1;
t237 = Qm(5,1) * t6 + t178 + Qm(5,6) * t1;
Qp(1,1) = t17 * c - t27 * s;
Qp(1,2) = t32 * c - t36 * s;
Qp(1,3) = (t51 * c - t60 * s);
Qp(1,4) = (t84 * c - t96 * s);
Qp(1,5) = (t111 * c - t120 * s);
Qp(1,6) = t131 * c - t138 * s;
Qp(2,1) = Qm(2,1) * t1 - t144 + Qm(2,6) * t6;
Qp(2,2) = Qm(2,2);
Qp(2,3) = (0.10e1 * Qm(2,3) * c - 0.10e1 * Qm(2,5) * s);
Qp(2,4) = (0.10e1 * Qm(2,1) * c * s + Qm(2,4) * t68 - 0.10e1 * Qm(2,6) * c * s);
Qp(2,5) = (0.10e1 * Qm(2,3) * s + 0.10e1 * Qm(2,5) * c);
Qp(2,6) = Qm(2,1) * t6 + t144 + Qm(2,6) * t1;
Qp(3,1) = c * t173 - s * t180;
Qp(3,2) = c * Qm(3,2) - s * Qm(5,2);
Qp(3,3) = (c * t190 - s * t196);
Qp(3,4) = (c * t206 - s * t215);
Qp(3,5) = (c * t222 - s * t228);
Qp(3,6) = c * t233 - s * t237;
Qp(4,1) = t17 * s + t27 * c;
Qp(4,2) = t32 * s + t36 * c;
Qp(4,3) = (t51 * s + t60 * c);
Qp(4,4) = (t84 * s + t96 * c);
Qp(4,5) = (t111 * s + t120 * c);
Qp(4,6) = t131 * s + t138 * c;
Qp(5,1) = t173 * s + t180 * c;
Qp(5,2) = Qm(3,2) * s + Qm(5,2) * c;
Qp(5,3) = (t190 * s + t196 * c);
Qp(5,4) = (t206 * s + t215 * c);
Qp(5,5) = (t222 * s + t228 * c);
Qp(5,6) = t233 * s + t237 * c;
Qp(6,1) = (s * t8 + t19) * s + (t16 + c * t25) * c;
Qp(6,2) = (s * Qm(1,2) + t34) * s + (t31 + c * Qm(6,2)) * c;
Qp(6,3) = ((s * t43 + t53) * s + (t50 + c * t58) * c);
Qp(6,4) = ((s * t73 + t86) * s + (t83 + c * t94) * c);
Qp(6,5) = ((s * t103 + t113) * s + (t110 + c * t118) * c);
Qp(6,6) = (s * t125 + t133) * s + (t130 + c * t136) * c;


end
