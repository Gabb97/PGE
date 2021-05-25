function [airf_name, airf_t, airf_pos]=BS_ReadAirfoilNameAndPos(Line)

% This function takes a line read from the airfoil input file in the form:
% 'AirfoilName AirfoilPosition'
% and identifies the name, which is returned as a string, and the position,
% which is returned as a number

% 
airf        =   strread(Line,'%s','delimiter',',');

airf_name   =   strtrim(airf{1});
airf_t      =   str2num(airf{2});
airf_pos    =   str2num(airf{3});
