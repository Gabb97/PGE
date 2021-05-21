function PrintAirfoilTableDatFile( airfoil , blade_airfoil , data_set_mach , reference , dat_file_name );

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
%
%  ALE : 04.march.2006
% modified in order to include Reynolds TLU
%----------------------------------------------------------

% Send status #LS
disp('  Writing Blade_Airtable.dat file.........')

load names\aero_names
%
airtable_file_name = dat_file_name(5,:);
%
fpc=fopen( strcat(dat_file_name(end,:),'\MB_model\',airtable_file_name) , 'w' );


fprintf(fpc,'Airtables :\n');

for i = 1 : max(size(blade_airfoil)),
    
    %     if (reference.inter_1(blade_airfoil(i))) == 1,   %%% Untill now 24/04/2004 only this one is used
    %
    %
    %         name_number_a = name_number( reference.A1(blade_airfoil(i)) , airfoil.name );
    %         name_number_b = name_number( reference.B1(blade_airfoil(i)) , airfoil.name );
    %
    %
    %         %%% TO BE DEVELOPED YET !! %%%
    %
    %     elseif (reference.inter_2(blade_airfoil(i))) == 1,  % NOT USED !!
    %
    %         name_number_a = name_number( reference.A2(blade_airfoil(i)) , airfoil.name );
    %         name_number_b = name_number( reference.B2(blade_airfoil(i)) , airfoil.name );
    %
    %
    %     elseif (reference.inter_3(blade_airfoil(i))) == 1,        % NOT USED !!
    %
    %         name_number_a = name_number( reference.A3(blade_airfoil(i)) , airfoil.name );
    %         name_number_b = name_number( reference.B3(blade_airfoil(i)) , airfoil.name );
    %
    %
    %     elseif ((reference.inter_1(blade_airfoil(i)) == 0)  & (reference.inter_2(blade_airfoil(i)) == 0) & (reference.inter_3(blade_airfoil(i)) == 0)),
    %
    %         name_number_a = name_number( reference.A1(blade_airfoil(i)) , airfoil.name );
    %
    %     end
    %
    % REMARK : it should be better if I will define a routine :
    % if ((max(size(mach)))== 1 & mach(1)==0 ),
    % elseif ((max(size(mach)))==1 & mach(1)== 1 ),
    % elseif ((max(size(mach)))==1 & mach(1)~= 1 & mach(1)~= 0 ),
    % end
    
    % ORA, dato che sono consapevole del fatto che ho tutto definito a mach
    % zero, scrivo la riga di comando che segue ad hoc per questo caso!!!!!!
    
    name_number_a = name_number( reference.A1(blade_airfoil(i)) , airfoil.name );
    
    % Set the number of TLU
    if (reference.inter_4(blade_airfoil(i))) == 1

        numb_TLU = 4;
        data_set_temp{1,1}=data_set_mach{1,i};
        data_set_temp{2,1}=data_set_mach{2,i};
        data_set_temp{3,1}=data_set_mach{3,i};
        data_set_temp{4,1}=data_set_mach{4,i};
        ReynoldsNumb = [airfoil.reference{name_number( reference.A1(blade_airfoil(i)) , airfoil.name )}(2) ...
            airfoil.reference{name_number( reference.A2(blade_airfoil(i)) , airfoil.name )}(2) ...
            airfoil.reference{name_number( reference.A3(blade_airfoil(i)) , airfoil.name )}(2) ...
            airfoil.reference{name_number( reference.A4(blade_airfoil(i)) , airfoil.name )}(2)];
    elseif (reference.inter_3(blade_airfoil(i))) == 1
        keyboard
        numb_TLU = 3;
        data_set_temp{1,1}=data_set_mach{1,i};
        data_set_temp{2,1}=data_set_mach{2,i};
        data_set_temp{3,1}=data_set_mach{3,i};
        ReynoldsNumb = [airfoil.reference{name_number( reference.A1(blade_airfoil(i)) , airfoil.name )}(2) ...
            airfoil.reference{name_number( reference.A2(blade_airfoil(i)) , airfoil.name )}(2) ...
            airfoil.reference{name_number( reference.A3(blade_airfoil(i)) , airfoil.name )}(2)];
    elseif (reference.inter_2(blade_airfoil(i))) == 1
        numb_TLU = 2;
        data_set_temp{1,1}=data_set_mach{1,i};
        data_set_temp{2,1}=data_set_mach{2,i};
        ReynoldsNumb = [airfoil.reference{name_number( reference.A1(blade_airfoil(i)) , airfoil.name )}(2) ...
            airfoil.reference{name_number( reference.A2(blade_airfoil(i)) , airfoil.name )}(2)];
    elseif (reference.inter_2(blade_airfoil(i))) == 1
        numb_TLU = 1;
        data_set_temp{1,1}=data_set_mach{1,i};
        data_set_temp{2,1}=data_set_mach{1,i};
        %         ReynoldsNumb = [airfoil.reference{name_number( reference.A1(blade_airfoil(i)) , airfoil.name )}(2) ...
        %                         airfoil.reference{name_number( reference.A1(blade_airfoil(i)) , airfoil.name )}(2)];
        ReynoldsNumb = [0 1E10];
    else
        numb_TLU = 0;
        data_set_temp{1,1}=data_set_mach{1,i};
        data_set_temp{2,1}=data_set_mach{1,i};
        ReynoldsNumb = [airfoil.reference{name_number( reference.A1(blade_airfoil(i)) , airfoil.name )}(2) ...
            airfoil.reference{name_number( reference.A1(blade_airfoil(i)) , airfoil.name )}(2)];
        ReynoldsNumb = [0 1E10];
    end
    
    
    % % % % % %     if numb_TLU>1
    % % % % % %         for i_mach=1:numb_TLU
    % % % % % %             data_set_temp{i_mach,1}=data_set_mach{i_mach,i};
    % % % % % %             ReynoldsNumb(i_mach) = airfoil.reference{name_number_a}(2);
    % % % % % %         end
    % % % % % %     else
    % % % % % %         data_set_temp{1,1}=data_set_mach{:,i};
    % % % % % %         data_set_temp{2,1}=data_set_mach{:,i};
    % % % % % %         ReynoldsNumb(1) = airfoil.reference{name_number_a}(2);
    % % % % % %         ReynoldsNumb(2) = airfoil.reference{name_number_a}(2);
    % % % % % %     end
    
    %    airtables_definition ( fpc , 'n' , airtable_names(i,:) , [0.0 1.0] , airfoil.data_set{name_number_a}(:,1) , data_set_mach{:,i} );
    %     airtables_definition ( fpc , 'n' , airtable_names(i,:) , [0.0 1.0] , airfoil.data_set{name_number_a}(:,1) , data_set_temp );
    try
        airtables_definition ( fpc , 'n' , airtable_names(i,:) , ReynoldsNumb , airfoil.data_set{name_number_a}(:,1) , data_set_temp );
    catch
        keyboard
    end
    
    
    
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