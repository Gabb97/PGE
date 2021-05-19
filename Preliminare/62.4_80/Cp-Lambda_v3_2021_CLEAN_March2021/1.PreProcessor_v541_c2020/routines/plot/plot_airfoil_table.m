function plot_airfoil_table( reference , blade_airfoil , data_set_mach , airfoil );


% These variable is used only for visualization pourpouse

title=strvcat('AIRFOIL SECTION REFERENCE  1','AIRFOIL SECTION REFERENCE  2','AIRFOIL SECTION REFERENCE  3','AIRFOIL SECTION REFERENCE  4','AIRFOIL SECTION REFERENCE  5', ...
              'AIRFOIL SECTION REFERENCE  6','AIRFOIL SECTION REFERENCE  7','AIRFOIL SECTION REFERENCE  8','AIRFOIL SECTION REFERENCE  9','AIRFOIL SECTION REFERENCE  10',...
              'AIRFOIL SECTION REFERENCE 11','AIRFOIL SECTION REFERENCE 12','AIRFOIL SECTION REFERENCE 13','AIRFOIL SECTION REFERENCE 14','AIRFOIL SECTION REFERENCE  15',...
              'AIRFOIL SECTION REFERENCE 16','AIRFOIL SECTION REFERENCE 17','AIRFOIL SECTION REFERENCE 18','AIRFOIL SECTION REFERENCE 19','AIRFOIL SECTION REFERENCE  20');


for ii = 1 : blade_airfoil(end),    
   
    index_A1 = find(airfoil.name==reference.A1(ii));
    table_A1 = airfoil.data_set{index_A1};
    
    if reference.B1(ii) ~= 0 ,
    
        index_B1 = find(airfoil.name==reference.B1(ii));
        table_B1 = airfoil.data_set{index_B1};
        
    end
    
    
    std_graph( ii     , title(ii,:) , 'CL'   , 'ALFA [DEG]' , table_A1(:,1) , table_A1(:,2) , 'd-' , 2 );
    std_graph( ii*10  , title(ii,:) , 'CD'   , 'ALFA [DEG]' , table_A1(:,1) , table_A1(:,3) , 'd-' , 2 );
    std_graph( ii*100 , title(ii,:) , 'CM_0' , 'ALFA [DEG]' , table_A1(:,1) , table_A1(:,4) , 'd-' , 2 );
    
    
    if reference.B1(ii) ~= 0 ,
        
        std_graph( ii     , title(ii,:) , 'CL'   , 'ALFA [DEG]' , table_B1(:,1) , table_B1(:,2) , 'd-g' , 2 );   
        std_graph( ii*10  , title(ii,:) , 'CD'   , 'ALFA [DEG]' , table_B1(:,1) , table_B1(:,3) , 'd-g' , 2 );        
        std_graph( ii*100 , title(ii,:) , 'CM_0' , 'ALFA [DEG]' , table_B1(:,1) , table_B1(:,4) , 'd-g' , 2 );
        
    end
       
end





for i = 1 : max(size(blade_airfoil)),
    
    if  ( reference.B1(blade_airfoil(i)) ~= 0 ) ,
        
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
            
            
        elseif ((reference.inter_1(blade_airfoil(i)) == 0)  & (reference.inter_2(blade_airfoil(i)) == 0) & (reference.inter_3(blade_airfoil(i)) == 0)),
            
            name_number_a = name_number( reference.A1(blade_airfoil(i)) , airfoil.name );       
            
        end    
        
        alfa_temp =  airfoil.data_set{name_number_a}(:,1);
        
        figure(blade_airfoil(i))
        plot(alfa_temp,data_set_mach{i}(:,1),'r.-');
        figure(blade_airfoil(i)*10)
        plot(alfa_temp,data_set_mach{i}(:,2),'r.-');
        figure(blade_airfoil(i)*100)
        plot(alfa_temp,data_set_mach{i}(:,3),'r.-');       
        
    end
    
end
        
        
while 1 ;    
    graph_choice = menu ('SELECT',...
        'AIRFOIL SECTION REFERENCE 1',...
        'AIRFOIL SECTION REFERENCE 2',...
        'AIRFOIL SECTION REFERENCE 3',...
        'AIRFOIL SECTION REFERENCE 4',...
        'AIRFOIL SECTION REFERENCE 5',...
        'AIRFOIL SECTION REFERENCE 6',...
        'AIRFOIL SECTION REFERENCE 7',...
        'AIRFOIL SECTION REFERENCE 8',...
        'AIRFOIL SECTION REFERENCE 9',...
        'AIRFOIL SECTION REFERENCE 10',...
        ' EXIT ',...
        ' EXIT & CLOSE ALL');
    
    if graph_choice < 11;
        
        submenu(graph_choice);        
        
    elseif graph_choice == 11;
        break;
    else
        for i=1:10;
            close (figure(i),figure(i*10),figure(i*100));
        end
        break;
    end
    
end



%%%%%%%%%%%%%%%%%%%%
%   SUB-FUNCTION   %
%%%%%%%%%%%%%%%%%%%%

function [out] = submenu(choice);
while 1 ;    
    out = menu ('SELECT',...
        'AIRFOIL SECTION CL-ALFA' , ...
        'AIRFOIL SECTION CD-ALFA' , ...
        'AIRFOIL SECTION Cm0-ALFA', ...
        'BACK');
    
    if out < 4;
        
        if out == 1;
            cost=1;
        elseif out == 2;
            cost = 10;
        elseif out == 3;
            cost = 100;
        end
        
        figure(choice*cost);        
        
    elseif out == 4;
        break;
    end
    
end
