function [nacelle] = nacelle_definition( nacelle , tower_height );

%-----------------------------------------------------
%  This function reads the .txt file from the Bladed 
%  For Windows report file , defines the nacelle and 
%  produces the  .dat  input files for the multibody 
%  software.
%
%  Sintax:
%        -nacelle_defintion(nacelle);
%  
%  input:
%        -nacelle = this is the structure defined by
%                   the function read_nacelle (for 
%                   more details see the help of this 
%                   function);
%
%----------------------------------------------------

z = menu('WOULD YOU LIKE TO PRINT THE NACELLE.DAT FILE?',...
    'YES',...
    'NO');

if z == 1;    
    
    print_nacelle_dat_file( nacelle , tower_height );
    
end