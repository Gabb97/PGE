function plot_controller_output(avrswap);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function draws the time histories of each representative
% qunatities stored into the avrswap file of the user choosed 
% simulation.
%
% -Syntax:
%         plot_controller_output(avrswap);
%
% -Input:
%         avrwasp: it is a multicell array as defined in scan_avrswap 
%                  funtion help;
% -Output:
%         No output;
%
% For more details see the std_graph function's help.
%                  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

std_graph( 10001 , 'iSTATUS' , 'iSTAUS' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{1}(2:end) , '-' , 2 );

std_graph( 10002 , 'OPERATIVE STATUS' , 'OPERATIVE STATUS' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{91}(2:end) , '-' , 2 );

std_graph( 10003 , 'BLADE 1 PITCH ANGLE' , 'BLADE PITCH ANGLE [rad]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{4}(2:end) , '-' , 2 );
std_graph( 10004 , 'BLADE 1 PITCH ANGLE' , 'BLADE PITCH ANGLE [deg]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{4}(2:end)*(180/pi) , '-' , 2 );

std_graph( 10005 , 'CURRENT DEMANDED PITCH ANGLE' , 'CURRENT DEMANDED PITHC ANGLE[rad]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{88}(2:end) , '-' , 2 );
std_graph( 10006 , 'CURRENT DEMANDED PITCH ANGLE' , 'CURRENT DEMANDED PITHC ANGLE[deg]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{88}(2:end)*(180/pi) , '-' , 2 );

std_graph( 10007 , 'CURRENT DEMANDED PITCH RATE' , 'CURRENT DEMANDED PITHC RATE[rad/s]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{12}(2:end) , '-' , 2 );
std_graph( 10008 , 'CURRENT DEMANDED PITCH RATE' , 'CURRENT DEMANDED PITHC RATE[deg/s]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{12}(2:end)*(180/pi) , '-' , 2 );

std_graph( 10009 , 'GENERATOR SPEED' , 'GENERATOR SPEEED [rad/s]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{20}(2:end) , '-' , 2 );
std_graph( 10010 , 'GENERATOR SPEED' , 'GENERATOR SPEEED [RPM]'   , 'TIME [s]' , avrswap{2}(2:end) , avrswap{20}(2:end)*(30/pi) , '-' , 2 );

std_graph( 10011 , 'ROTOR SPEED' , 'ROTOR SPEED [rad/s]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{21}(2:end) , '-b' , 2 );
std_graph( 10011 , 'ROTOR SPEED' , 'ROTOR SPEED [rad/s]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{82}(2:end) , '-r' , 2 );
legend('Effective rotor speed','Filtered rotor speed',0);

std_graph( 10012 , 'ROTOR SPEED' , 'ROTOR SPEED [RPM]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{21}(2:end)*(30/pi) , '-b' , 2 );
std_graph( 10012 , 'ROTOR SPEED' , 'ROTOR SPEED [RPM]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{82}(2:end)*(30/pi) , '-r' , 2 );
legend('Effective rotor speed','Filtered rotor speed',0);

std_graph( 10013 , 'YAW ERROR' , 'YAW ERROR [rad]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{24}(2:end) , '-' , 2 );
std_graph( 10014 , 'YAW ERROR' , 'YAW ERROR [deg]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{24}(2:end)*(180/pi) , '-' , 2 );

std_graph( 10015 , 'LONGITUDINAL WIND SPEED AT HUB HEIGHT' , 'SPEED [m/s]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{27}(2:end) , '-' , 2 );
std_graph( 10015 , 'LONGITUDINAL WIND SPEED AT HUB HEIGHT' , 'SPEED [m/s]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{84}(2:end) , '-r' , 2 );
std_graph( 10015 , 'LONGITUDINAL WIND SPEED AT HUB HEIGHT' , 'SPEED [m/s]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{90}(2:end) , '-g' , 2 );
legend('Real','Filtered','Averaged',0);

std_graph( 10016 , 'BLADE 2 PITCH ANGLE' , 'BLADE 2 PITCH ANGLE [rad]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{33}(2:end) , '-' , 2 );
std_graph( 10017 , 'BLADE 2 PITCH ANGLE' , 'BLADE 2 PITCH ANGLE [deg]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{33}(2:end)*(180/pi) , '-' , 2 );

std_graph( 10018 , 'BLADE 3 PITCH ANGLE' , 'BLADE 3 PITCH ANGLE [rad]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{34}(2:end) , '-' , 2 );
std_graph( 10019 , 'BLADE 3 PITCH ANGLE' , 'BLADE 3 PITCH ANGLE [deg]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{34}(2:end)*(180/pi) , '-' , 2 );

std_graph( 10020 , 'GENERATOR STATUS' , 'CONTACTOR 1=ON or 0 =OFF' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{35}(2:end) , '-' , 2 );

std_graph( 10021 , 'BRAKE STATUS' , 'BRAKE 1=ON or 0 =OFF' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{36}(2:end) , '-' , 2 );

std_graph( 10022 , 'TIP SPEED RATIO -TSR-' , 'TSR' , 'TIME [s]' , avrswap{2}(2:end) , [avrswap{21}(2:end)*(62.27/2)]./avrswap{27}(2:end) , '-' , 2 );

std_graph( 10023 , 'GENERATOR TORQUE DEMAND' , 'TORQUE DEMAND[N*m]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{47}(2:end) , '-' , 2 );

std_graph( 10024 , 'YAW RATE DEMAND' , 'YAW RATE DEMAND[rad/s]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{48}(2:end) , '-' , 2 );

std_graph( 10025 , 'ROTOR SPEED ERROR' , 'ROTOR SPEED ERROR[rad/s]' , 'TIME [s]' , avrswap{2}(2:end) , avrswap{83}(2:end) , '-' , 2 );
std_graph( 10026 , 'ROTOR SPEED ERROR' , 'ROTOR SPEED ERROR[RPM]'   , 'TIME [s]' , avrswap{2}(2:end) , avrswap{83}(2:end)*(30/pi) , '-' , 2 );

std_graph( 10027 , 'BLADE MINIMUM PITCH' , 'MIN PITCH[rad]'   , 'TIME [s]' , avrswap{2}(2:end) , avrswap{85}(2:end) , '-' , 2 );
std_graph( 10028 , 'BLADE MINIMUM PITCH' , 'MIN PITCH[deg]'   , 'TIME [s]' , avrswap{2}(2:end) , avrswap{85}(2:end)*(180/pi) , '-' , 2 );

%post_menu_controller;