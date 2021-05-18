function point_definition ( fpt , point_name , point_coordinates , frame );

%--------------------------------------------------------------------------
%  This function prints in a .dat file the POINT model suitable for the
%  multibody software.
% 
%   Syntax:
%           -point_definition ( fpt , point_name , point_coordinates , frame );
%
%   Input:
%          -fpt = the .dat file in which the function will writes;
%
%          -point_name = a string vector which rows contains 
%                        the points name:
%                        point_name = ['name_01' 
%                                      'name_02' 
%                                      'name_03' ];
%
%          -point_coordinates = is a matrix (nX3) which rows contains the 
%                               points coordinates:
%                               point_coordinates = 
%                               [ x_coord_point_01 , y_coord_point_01 , z_coord_point_01 
%                                 x_coord_point_02 , y_coord_point_02 , z_coord_point_02
%                                 x_coord_point_03 , y_coord_point_03 , z_coord_point_03 
%                                 ...              ,  ...             ,  ...           ];
%
%          -frame = a string vector which rows contains the frame name in which 
%                   the points coordinates are defined;
%                   N.B. = if only one frame name is defined this one will be
%                          used as reference for all points.
%   
%--------------------------------------------------------------------------

num  = size( point_name );
num2 = size( frame );

%fprintf(fpt,'  Points :\n');

for i = 1 : num(1),

    fprintf(fpt,'  Point :\n');
    fprintf(fpt,'    Name : %2s ;\n',deblank(point_name(i,:))); 
    fprintf(fpt,'    Coordinates : %2.8g , %2.8g , %2.8g ; \n',point_coordinates(i,:)); 
    
    if num2(1) == 1,
    
        fprintf(fpt,'    InReferenceFrame : %2s ; \n',deblank(frame)); 
    else
        
        fprintf(fpt,'    InReferenceFrame : %2s ; \n',deblank(frame(i,:)));  
        
    end
    
    fprintf(fpt,'   ;\n');
    
end

%fprintf(fpt,';\n'); 


% fprintf(fpt,'  Point :\n');
% fprintf(fpt,'    Name : %2s ;\n',deblank(point_name)); 
% fprintf(fpt,'    Coordinates : %2.16g , %2.16g , %2.16g ; \n',point_coordinates); 
% fprintf(fpt,'    InReferenceFrame : %2s ; \n',deblank(frame)); 
% fprintf(fpt,'   ;\n'); 