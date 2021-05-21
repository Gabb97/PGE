function [number] = name_number( name , airfoil_name ),

%-----------------------------------------------------------
% This function is used to find the airfoil name.
number=1;
while 1,
    if (airfoil_name(number) == name ),
        break;
    else
        number = number + 1;
    end
end
%------------------------------------------------------------