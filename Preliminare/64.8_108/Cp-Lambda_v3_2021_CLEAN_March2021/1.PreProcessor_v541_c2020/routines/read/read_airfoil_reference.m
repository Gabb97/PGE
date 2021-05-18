function [airfoil_reference_table] = read_airfoil_reference(PathStruct);

%--------------------------------------------------------------------------
% This function reads the airfoil_reference.txt file from bladed output 
% and returns the airfoil_reference_table structure.
%
%  Syntax:
%
%          -[airfoil_reference_table] = read_airfoil_reference
%
%  Output:
%          This funtion return a structure called:
%    
%          -airfoil_reference_table = structure's fields are:
%                -A1;
%                -A2;
%                -A3;
%                -B1;
%                -B2;
%                -B3;
%                -inter_1, inter_2 and inter_3 = 
%                 this three fields are vectors of ones or zeros.
%                 One mean that is necessary interpolate the Cl, 
%                 Cd and Cm values to take into account the variation 
%                 of the blade's thickness with respect the chord of 
%                 the tabulated airfoil.
%                                               
%
%   Remark:
%         For more details about A1, B1, A2, ecc. see the
%         airfoil_reference.txt file.
%           
%
%--------------------------------------------------------------------------

 
%%%ALEALE 14.may.2008
% airfoil_reference = read_matrix_from_txt_file('input\airfoil_reference.txt');
airfoil_reference = read_matrix_from_txt_file(strcat(PathStruct.FullPathInputDir,'\airfoil_reference.txt'));

airfoil_reference_size = size(airfoil_reference);
dim = airfoil_reference_size(1);


% airfoil_reference_table structure pre-allocation
airfoil_reference_table = struct ('A1' , zeros(1,dim) , ...
                                  'A2' , zeros(1,dim) , ...
                                  'A3' , zeros(1,dim) , ...
                                  'B1' , zeros(1,dim) , ...
                                  'B2' , zeros(1,dim) , ...
                                  'B3' , zeros(1,dim) , ...
                                  'inter_1' , zeros(1,dim) , ...
                                  'inter_2' , zeros(1,dim) , ...
                                  'inter_3' , zeros(1,dim) , ...
                                  'inter_4' , zeros(1,dim) );

                              
%airfoil_reference_table filds definition                              
for i = 1 : airfoil_reference_size(1),
    
    airfoil_reference_table.A1(i) = airfoil_reference ( i , 2 );
    airfoil_reference_table.A2(i) = airfoil_reference ( i , 3 );
    airfoil_reference_table.A3(i) = airfoil_reference ( i , 4 );
    airfoil_reference_table.A4(i) = airfoil_reference ( i , 5 );
    airfoil_reference_table.B1(i) = airfoil_reference ( i , 6 );
    airfoil_reference_table.B2(i) = airfoil_reference ( i , 7 );
    airfoil_reference_table.B3(i) = airfoil_reference ( i , 8 );
    airfoil_reference_table.B4(i) = airfoil_reference ( i , 9 );
    
%     airfoil_reference_table.inter_1(i) = ( airfoil_reference_table.A1(i) ~= airfoil_reference_table.B1(i) & airfoil_reference_table.B1(i) ~= 0);
%     airfoil_reference_table.inter_2(i) = ( airfoil_reference_table.A2(i) ~= airfoil_reference_table.B2(i) & airfoil_reference_table.B2(i) ~= 0);
%     airfoil_reference_table.inter_3(i) = ( airfoil_reference_table.A3(i) ~= airfoil_reference_table.B3(i) & airfoil_reference_table.B3(i) ~= 0);              
%     airfoil_reference_table.inter_4(i) = ( airfoil_reference_table.A4(i) ~= airfoil_reference_table.B4(i) & airfoil_reference_table.B4(i) ~= 0);              
%% ALEALE 12.Feb.2019 to me interp must be done unless Bi==0
    airfoil_reference_table.inter_1(i) = ( airfoil_reference_table.B1(i) ~= 0);
    airfoil_reference_table.inter_2(i) = ( airfoil_reference_table.B2(i) ~= 0);
    airfoil_reference_table.inter_3(i) = ( airfoil_reference_table.B3(i) ~= 0);              
    airfoil_reference_table.inter_4(i) = ( airfoil_reference_table.B4(i) ~= 0);              
        
end