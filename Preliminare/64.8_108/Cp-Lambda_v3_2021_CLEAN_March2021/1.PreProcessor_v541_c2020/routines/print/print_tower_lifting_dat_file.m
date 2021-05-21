function print_tower_lifting_dat_file ( tower_cd , n_elements , tower_height , n_entries , tower_diameter , dat_file_name );

%---------------------------------------------------------------
%  This function prints in the lifting_line_tower.dat file 
%  the lifting line multibody model of the tower.
%
%  Syntax:
%     -print_tower_lifting_dat_file ( tower_cd , n_elements )
%
%  Input:
%     -tower_cd     : drag coefficient of the
%                     tower structure;
%     -n_elements   : number of beam elements
%                     which compose the tower;
%     -tower_height : vector which contains
%                     the distance from ground
%                     of each the tower section
%                     defined in the model;
%     -n_entries    : number of section defined
%                     in the model;
%     -tower_diameter : for each section, this 
%                       vector, gives the relative
%                       diameter;
%----------------------------------------------------------------

% Send status #LS
disp('  Writing Tower_lifting_line.dat file.........')

load names\tower_names
%
tll_file_name = dat_file_name(10,:);
%
fpc=fopen( strcat(dat_file_name(end,:),'\MB_model\',tll_file_name) ,'w');



%-----------------------------------------------------------------
%  This routine generates a concatenated string which contains
%  the names of the bodies associated to the lifting line.
for i = 1 :n_elements,

    if (i < n_elements & i > 1),
        
        body_list{i} = strcat(body_list{i-1},tower_name(i,:),',');
        
    elseif i == n_elements,
        
        body_list{i} = strcat (body_list{i-1},tower_name(i,:));
        
    else 
        body_list{i} = strcat(tower_name(i,:),',');
        
    end
    
end
%-------------------------------------------------------------------


%-----------------------------------------------------------------------------------------------------------------------------------
% Lifting line DEFINITION
fprintf(fpc,'LiftingLines :\n');
lifting_line_definition ( fpc , 'lifting_line_tower_1' , 'lifting_line_tower_curve_1' , 'lifting_line_tower_triad_1' , ...
                                'lifting_line_tower_prop_1' , 'EQUALLY_SPACED' , 10 , '2D_AIRFOIL' , body_list{n_elements} , 'y' , 0) ;
fprintf(fpc,'; \n\n\n');                            
%------------------------------------------------------------------------------------------------------------------------------------


%-----------------------------------------------------------------------------------------------------------------------
%Lifting line CURVE
fprintf(fpc,'Curves : \n');                            
curve_definition( fpc , 'lifting_line_tower_curve_1' , 'tower_frame' , pt_tower(1,:) , pt_tower(n_elements+1,:) , ...
                  [0 1] , [ 0 1 0 ] , [ 0 0 1 ] , 'n' );                                          
fprintf(fpc,' ;\n\n\n');               
%----------------------------------------------------------------------------------------------------------------------



%-------------------------------------------------------------------------------------------------------------------------------------------------------
% Lifting line PROPERTIES
% In this case, the function must provides a routine which
% avoid the printing of equal sections in the lifting line
% properties

num = 1;
i=1;

for i = 1 : (n_entries-1),
    
    if (tower_height(i) ~= tower_height(i+1))
        
        eta(num) = (tower_height(i)/tower_height(end));
        
        chord(num) = tower_diameter(i);
        
        num = num + 1 ;       
                
    end

end

eta(num)   = 1;
chord(num) = tower_diameter(end);

% 02.feb.09 this was incorrect 
%lifting_line_properties_definition( fpc , 'y' ,'lifting_line_tower_prop_1' , eta , chord , -chord/4 , [0] , 'tower_airtable' , 'n' );
lifting_line_properties_definition( fpc , 'y' ,'lifting_line_tower_prop_1' , eta , chord , 0*chord , [0] , 'tower_airtable' , 'n' );
%-------------------------------------------------------------------------------------------------------------------------------------------------------

%-----------------------------------------------------------------------------------------------------
% Liting line TRIAD
triad_definition( fpc , 'y' , 'lifting_line_tower_triad_1' , [ 0 1 0 ] , [ 1 0 0 ] , 'tower_frame' );
%------------------------------------------------------------------------------------------------------

%----------------------------------------------------------------------------------------------
% Lifting AIRTABLE 
airtable{1}=[ 0 tower_cd 0 ; 0 tower_cd 0 ; 0 tower_cd 0];
% To avoid warning message in wasp's files .out 
airtable{2}=[ 0 tower_cd 0 ; 0 tower_cd 0 ; 0 tower_cd 0];

airtables_definition ( fpc , 'y' , 'tower_airtable' , [ 0 1 ] , [ -180 0 180 ] , airtable );
%----------------------------------------------------------------------------------------------


fclose(fpc);