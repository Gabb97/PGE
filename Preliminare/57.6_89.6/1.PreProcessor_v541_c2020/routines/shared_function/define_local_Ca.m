function [local_Ca] = define_local_Ca ( blade_thickness , reference , blade_airfoil , airfoil_name , airfoil_reference );

%-------------------------------------------------
%  This function calculates the position of the
%  aerodinamic centre with respect the featherig
%  axis for each the blade sections defined in
%  the blade_geometry.txt file.
%
%  Syntax:
%      -[local_Ca] = define_local_Ca ( blade_thickness , reference , ...
%                                      blade_airfoil , airfoil_name , ...
%                                      airfoil_reference );
%
%  Output:
%      -local_Ca =  it is a row vector which
%                   contains the Ca position;
%---------------------------------------------------

for i = 1 : max(size(blade_thickness)),
    
    if (reference.inter_1(blade_airfoil(i))) == 1,
        
        
        name_number_a = name_number( reference.A1(blade_airfoil(i)) , airfoil_name );
        name_number_b = name_number( reference.B1(blade_airfoil(i)) , airfoil_name );
        
        if name_number_a==name_number_b    % ALEALE 12.Feb.2019
            local_Ca(i) = airfoil_reference{name_number_a}(3);
        else
            local_Ca(i) = airfoil_reference{name_number_a}(3)+...
                ((airfoil_reference{name_number_b}(3)-airfoil_reference{name_number_a}(3)) / ...
                (airfoil_reference{name_number_b}(1)-airfoil_reference{name_number_a}(1))) * ...
                (blade_thickness(i) - airfoil_reference{name_number_a}(1));
        end
    end
    
    if ((reference.inter_1(blade_airfoil(i)) == 0)  & (reference.inter_2(blade_airfoil(i)) == 0) & (reference.inter_3(blade_airfoil(i)) == 0) & (reference.inter_4(blade_airfoil(i)) == 0)),
        
        name_number_a = name_number( reference.A1(blade_airfoil(i)) , airfoil_name );
        
        try
            local_Ca(i) = airfoil_reference{name_number_a}(3) ;
        catch
            keyboard
        end
        
    end
    
end

%-----------------------------------------------------------
% This sub-function is used to find the airfoil name.
function [number] = name_number( name , airfoil_name ),
number=1;
while 1,
    if (airfoil_name(number) == name ),
        break;
    else
        number = number + 1;
    end
end
%------------------------------------------------------------