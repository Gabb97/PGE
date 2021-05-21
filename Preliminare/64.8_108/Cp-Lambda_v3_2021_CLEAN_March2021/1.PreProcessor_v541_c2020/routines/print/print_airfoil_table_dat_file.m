function print_airfoil_table_dat_file( airfoil , blade_airfoil , data_set_mach , reference , dat_file_name );

%----------------------------------------------------------
%  This function generates .dat files which defines the
%  aerodynamic properties of the multibody airfoils models.
%
%  Syntax:
%     -print_multibody_airfoil( airfoil , reference , blade.thickness , blade.airfoil );
%
%  Input:
%     -For more datails about inputs, see help of 
%      read_airfoil, read_airfoil_reference  and
%      read_blade functions.
%
%
%  REMARK:
%   This function should be optimazed because of the number
%   of calculations to evaluate data_set may be reduced.
%   It is also necessary to check the function with much 
%   more complex input data.
%   The routine which calculates the aerodynamic centre 
%   position along the chord, is correct only when the same
%   is constant with the variation of the reinolds number.
%   -MANCA LA ROUTINE PER IL CALCOLO DEL MACH!!!!!!!!!!!!!!
%----------------------------------------------------------

load names\aero_names
%
airtable_file_name = dat_file_name(5,:);
%
fpc=fopen( strcat(dat_file_name(end,:),'\MB_model\',airtable_file_name) , 'w' );


fprintf(fpc,'Airtables :\n');

for i = 1 : max(size(blade_airfoil)),         
    
    if (reference.inter_1(blade_airfoil(i))) == 1,   %%% Untill now 24/04/2004 only this one is used
        
        
        name_number_a = name_number( reference.A1(blade_airfoil(i)) , airfoil.name );
        name_number_b = name_number( reference.B1(blade_airfoil(i)) , airfoil.name );

        
        %%% TO BE DEVELOPED YET !! %%%
        
    elseif (reference.inter_2(blade_airfoil(i))) == 1,  % NOT USED !!
        
        name_number_a = name_number( reference.A2(blade_airfoil(i)) , airfoil.name );
        name_number_b = name_number( reference.B2(blade_airfoil(i)) , airfoil.name );
        

    elseif (reference.inter_3(blade_airfoil(i))) == 1,        % NOT USED !!
        
        name_number_a = name_number( reference.A3(blade_airfoil(i)) , airfoil.name );
        name_number_b = name_number( reference.B3(blade_airfoil(i)) , airfoil.name );
        

    elseif (reference.inter_4(blade_airfoil(i))) == 1,        % NOT USED !!
                    keyboard

        name_number_a = name_number( reference.A4(blade_airfoil(i)) , airfoil.name );
        name_number_b = name_number( reference.B4(blade_airfoil(i)) , airfoil.name );
        

    elseif ((reference.inter_1(blade_airfoil(i)) == 0)  & (reference.inter_2(blade_airfoil(i)) == 0) & (reference.inter_3(blade_airfoil(i)) == 0) & (reference.inter_4(blade_airfoil(i)) == 0)),
        
        name_number_a = name_number( reference.A1(blade_airfoil(i)) , airfoil.name );       
                       
    end    
    
    % REMARK : it should be better if I will define a routine :
    % if ((max(size(mach)))== 1 & mach(1)==0 ),
    % elseif ((max(size(mach)))==1 & mach(1)== 1 ),
    % elseif ((max(size(mach)))==1 & mach(1)~= 1 & mach(1)~= 0 ),
    % end
    
    % ORA, dato che sono consapevole del fatto che ho tutto definito a mach
    % zero, scrivo la riga di comando che segue ad hoc per questo caso!!!!!!
    
    data_set_temp{1}=data_set_mach{:,i};
    data_set_temp{2}=data_set_mach{:,i};

    %    airtables_definition ( fpc , 'n' , airtable_names(i,:) , [0.0 1.0] , airfoil.data_set{name_number_a}(:,1) , data_set_mach{:,i} ); 
    airtables_definition ( fpc , 'n' , airtable_names(i,:) , [0.0 1.0] , airfoil.data_set{name_number_a}(:,1) , data_set_temp ); 

    
end

fprintf(fpc,';\n\n\n');
fclose(fpc);



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