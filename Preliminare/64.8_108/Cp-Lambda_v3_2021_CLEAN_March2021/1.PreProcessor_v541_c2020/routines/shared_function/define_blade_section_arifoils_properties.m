function [ data_set_mach ] = define_blade_section_arifoils_properties( airfoil , reference , blade_thickness , blade_airfoil );

%------------------------------------------------------------
%  Output:
%     -The output of this function is an array which
%      cells are matrixs containig the Cl, Cd and Cm
%      of each blade section airfoil (as defined in Bladed 
%      report). First index of cell position is refered to
%      a defined mach number and the second index is refered
%      to the blade section number (starting from blade root).
%  REMARK:
%   This function should be optimazed because of the number
%   of calculations to evaluate data_set may be reduced.
%   It is also necessary to check the function with much 
%   more complex input data.
%   The routine which calculates the aerodynamic centre 
%   position along the chord, is correct only when the same
%   is constant with the variation of the Reinolds number.
%   -MANCA LA ROUTINE PER IL CALCOLO DEL MACH!!!!!!!!!!!!!!
%----------------------------------------------------------


for i = 1 : max(size(blade_thickness)),   
    
    if (reference.inter_1(blade_airfoil(i))) == 1,   %%% Untill now 24/04/2004 only this one is used
        
        name_number_a = name_number( reference.A1(blade_airfoil(i)) , airfoil.name );
        name_number_b = name_number( reference.B1(blade_airfoil(i)) , airfoil.name );                               
        
        data_set_mach{1,i} = airfoil.data_set{name_number_a}(:,2:end) + ...
            ((airfoil.data_set{name_number_b}(:,2:end) - airfoil.data_set{name_number_a}(:,2:end)) / ...
            (airfoil.reference{name_number_b}(1)-airfoil.reference{name_number_a}(1))) * ...
            ( blade_thickness(i) - airfoil.reference{name_number_a}(1) );                                                             
        
        
    %%%%%%% TO BE DEVELOPED YET !! %%%%%%%%
        
    elseif (reference.inter_2(blade_airfoil(i))) == 1,  % NOT USED !!
        
        name_number_a = name_number( reference.A2(blade_airfoil(i)) , airfoil.name );
        name_number_b = name_number( reference.B2(blade_airfoil(i)) , airfoil.name );
        
        data_set_mach{2,i} = airfoil.data_set{name_number_a}(:,2:end) + ...
            ((airfoil.data_set{name_number_b}(:,2:end) - airfoil.data_set{name_number_a}(:,2:end)) / ...
            (airfoil.reference{name_number_b}(1)-airfoil.reference{name_number_a}(1))) * ...
            ( blade_thickness(i) - airfoil.reference{name_number_a}(1) );       
        
        disp('WARNING!!!!!!!!!');
        
        
        
    elseif (reference.inter_3(blade_airfoil(i))) == 1,        % NOT USED !!
        
        name_number_a = name_number( reference.A3(blade_airfoil(i)) , airfoil.name );
        name_number_b = name_number( reference.B3(blade_airfoil(i)) , airfoil.name );
        
        data_set_mach{3,i} = airfoil.data_set{name_number_a}(:,2:end) + ...
            ((airfoil.data_set{name_number_b}(:,2:end) - airfoil.data_set{name_number_a}(:,2:end)) / ...
            (airfoil.reference{name_number_b}(1)-airfoil.reference{name_number_a}(1))) * ...
            ( blade_thickness(i) - airfoil.reference{name_number_a}(1) );       
        
        disp('WARNING!!!!!!!!!');
        
    elseif (reference.inter_4(blade_airfoil(i))) == 1,        % NOT USED !!
        
        name_number_a = name_number( reference.A4(blade_airfoil(i)) , airfoil.name );
        name_number_b = name_number( reference.B4(blade_airfoil(i)) , airfoil.name );
        
        data_set_mach{4,i} = airfoil.data_set{name_number_a}(:,2:end) + ...
            ((airfoil.data_set{name_number_b}(:,2:end) - airfoil.data_set{name_number_a}(:,2:end)) / ...
            (airfoil.reference{name_number_b}(1)-airfoil.reference{name_number_a}(1))) * ...
            ( blade_thickness(i) - airfoil.reference{name_number_a}(1) );       
        
        disp('WARNING!!!!!!!!!');
        
        
        
    elseif ((reference.inter_1(blade_airfoil(i)) == 0)  & (reference.inter_2(blade_airfoil(i)) == 0) & (reference.inter_3(blade_airfoil(i)) == 0) & (reference.inter_4(blade_airfoil(i)) == 0)),
        
        name_number_a = name_number( reference.A1(blade_airfoil(i)) , airfoil.name );       
        
        data_set_mach{1,i} = airfoil.data_set{name_number_a}(:,2:end);
        
        
    end       
    
end