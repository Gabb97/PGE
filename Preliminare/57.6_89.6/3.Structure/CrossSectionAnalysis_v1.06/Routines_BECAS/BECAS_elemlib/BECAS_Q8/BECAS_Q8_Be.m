function [ B ] = BECAS_Q8_Be( xxs, yys, iJ )
%********************************************************
% File: BECAS_Q8_Be.m
%   Function to evaluate matrix B for element Q8 (see
%   documentation).
%
% Syntax:
%   [ B ]=BECAS_Q8_Be( xxb, yyb, iJ )
%
% Input:
%   xxs, yys :  Isoparametric coordinates
%   iJ       :  Inverse of Jacobian
%
% Output:
%   B        :  B matrix
%
% Calls:
%
% Date:
%   Version 1.0    07.02.2012   José Pedro Blasques
%
% (c) DTU Wind Energy
%********************************************************

B=zeros(6,24);
t1 = yys / 0.4e1;
t2 = yys ^ 2;
t3 = t2 / 0.4e1;
t4 = 0.1e1 - yys;
t6 = xxs * t4 / 0.2e1;
t7 = t1 - t3 + t6;
t9 = xxs / 0.4e1;
t10 = 0.1e1 - xxs;
t12 = t10 * yys / 0.2e1;
t13 = xxs ^ 2;
t14 = t13 / 0.4e1;
t15 = t9 + t12 - t14;
t17 = iJ(1,1) * t7 + iJ(1,2) * t15;
t18 = -t1 + t6 + t3;
t20 = 0.1e1 + xxs;
t22 = t20 * yys / 0.2e1;
t23 = -t9 - t14 + t22;
t25 = iJ(1,1) * t18 + iJ(1,2) * t23;
t26 = 0.1e1 + yys;
t28 = xxs * t26 / 0.2e1;
t29 = t1 + t28 + t3;
t31 = t9 + t14 + t22;
t33 = iJ(1,1) * t29 + iJ(1,2) * t31;
t34 = -t1 + t28 - t3;
t36 = -t9 + t14 + t12;
t38 = iJ(1,1) * t34 + iJ(1,2) * t36;
t39 = iJ(1,1) * xxs;
t41 = -0.1e1 + t13;
t43 = -t39 * t4 + iJ(1,2) * t41 / 0.2e1;
t44 = 0.1e1 - t2;
t48 = iJ(1,1) * t44 / 0.2e1 - iJ(1,2) * t20 * yys;
t51 = -t39 * t26 - iJ(1,2) * t41 / 0.2e1;
t55 = -iJ(1,1) * t44 / 0.2e1 - iJ(1,2) * t10 * yys;
t58 = iJ(2,1) * t7 + iJ(2,2) * t15;
t61 = iJ(2,1) * t18 + iJ(2,2) * t23;
t64 = iJ(2,1) * t29 + iJ(2,2) * t31;
t67 = iJ(2,1) * t34 + iJ(2,2) * t36;
t68 = iJ(2,1) * xxs;
t71 = -t68 * t4 + iJ(2,2) * t41 / 0.2e1;
t75 = iJ(2,1) * t44 / 0.2e1 - iJ(2,2) * t20 * yys;
t78 = -t68 * t26 - iJ(2,2) * t41 / 0.2e1;
t82 = -iJ(2,1) * t44 / 0.2e1 - iJ(2,2) * t10 * yys;
B(1,1) = t17;
B(1,4) = t25;
B(1,7) = t33;
B(1,10) = t38;
B(1,13) = t43;
B(1,16) = t48;
B(1,19) = t51;
B(1,22) = t55;
B(2,2) = t58;
B(2,5) = t61;
B(2,8) = t64;
B(2,11) = t67;
B(2,14) = t71;
B(2,17) = t75;
B(2,20) = t78;
B(2,23) = t82;
B(3,1) = t58;
B(3,2) = t17;
B(3,4) = t61;
B(3,5) = t25;
B(3,7) = t64;
B(3,8) = t33;
B(3,10) = t67;
B(3,11) = t38;
B(3,13) = t71;
B(3,14) = t43;
B(3,16) = t75;
B(3,17) = t48;
B(3,19) = t78;
B(3,20) = t51;
B(3,22) = t82;
B(3,23) = t55;
B(4,3) = t17;
B(4,6) = t25;
B(4,9) = t33;
B(4,12) = t38;
B(4,15) = t43;
B(4,18) = t48;
B(4,21) = t51;
B(4,24) = t55;
B(5,3) = t58;
B(5,6) = t61;
B(5,9) = t64;
B(5,12) = t67;
B(5,15) = t71;
B(5,18) = t75;
B(5,21) = t78;
B(5,24) = t82;


end