function print_hub_lifting_line_dat_file ( hub_name , point_hub_name , hub_diameter , hub_extension_drag , spinner_diameter , root_radial_position , dat_file_name )

hub_lifting_dat_file_name = dat_file_name(9,:);

% At this time, follow function do not take into account the number of
% blades and eventual user defined hub lifting liine name.
% In others words, a for cicle from 1 to blades number and a name
% routine should be implemented.

% Send status #LS
disp('  Writing Hub_Lifting_line.dat file.........')

fpc=fopen( strcat(dat_file_name(end,:),'\MB_model\',hub_lifting_dat_file_name) ,'w');


%--------------------------------
% LIFTING LINE definitions
%--------------------------------
fprintf(fpc,' LiftingLines :\n');        

lifting_line_definition ( fpc , 'hub_lifting_line_1' , 'hub_lifting_curve_1' , 'hub_lifting_triad_1' , 'hub_lifting_prop' ,...
                         'EQUALLY_SPACED' , 2 , '2D_AIRFOIL' , strcat(hub_name(3,:),'_1') , 'y' , 0) ;
                     
lifting_line_definition ( fpc , 'hub_lifting_line_2' , 'hub_lifting_curve_2' , 'hub_lifting_triad_2' , 'hub_lifting_prop' ,...
                         'EQUALLY_SPACED' , 2 , '2D_AIRFOIL' , strcat(hub_name(3,:),'_2') , 'y' , 0) ;
                     
lifting_line_definition ( fpc , 'hub_lifting_line_3' , 'hub_lifting_curve_3' , 'hub_lifting_triad_3' , 'hub_lifting_prop' ,...
                         'EQUALLY_SPACED' , 2 , '2D_AIRFOIL' , strcat(hub_name(3,:),'_3') , 'y' , 0) ;                     
                     
fprintf(fpc,' ; \n\n\n');


%-------------------------------
% CURVE definitions
%-------------------------------
fprintf(fpc,' Curves :\n');                         

curve_definition( fpc , 'hub_lifting_curve_1' , 'blade_root_frame_1' , point_hub_name(1,:) , strcat(point_hub_name(3,:),'_1') , [0 1] , [ 0 0 1 ; 0 0 1 ]' ,...
                  [ 0 -1 0 ;  0 -1 0 ]' , 'n' );
              
curve_definition( fpc , 'hub_lifting_curve_2' , 'blade_root_frame_2' , point_hub_name(1,:) , strcat(point_hub_name(3,:),'_2') , [0 1] , [ 0 0 1 ; 0 0 1 ]' ,...
                  [ 0 -1 0 ;  0 -1 0 ]' , 'n' );
              
curve_definition( fpc , 'hub_lifting_curve_3' , 'blade_root_frame_3' , point_hub_name(1,:) , strcat(point_hub_name(3,:),'_3') , [0 1] , [ 0 0 1 ; 0 0 1 ]' ,...
                  [ 0 -1 0 ;  0 -1 0 ]' , 'n' );

fprintf(fpc,' ; \n\n\n');


%-------------------------------------
% Lifting Line PROPERTIES definition
%-------------------------------------

if root_radial_position >= (spinner_diameter/2),
    eta_airtable = [0 ((spinner_diameter/2)/root_radial_position) 1 ];
    airtable = strvcat ('spinner_airtable','hub_airtable','hub_airtable');
else
    eta_airtable=[0];
    airtable=['spinner_airtable'];
end

lifting_line_properties_definition( fpc , 'y' ,'hub_lifting_prop' , [0] , hub_diameter , -hub_diameter/4 , eta_airtable , airtable , 'n' );


%-------------------------------------
% Lifting Line TRAID definition
%-------------------------------------

triad_definition( fpc , 'y' , 'hub_lifting_triad_1' , [ 0 1 0 ] , [ -1 0 0 ] , 'blade_root_frame_1' );

triad_definition( fpc , 'y' , 'hub_lifting_triad_2' , [ 0 1 0 ] , [ -1 0 0 ] , 'blade_root_frame_2' );

triad_definition( fpc , 'y' , 'hub_lifting_triad_3' , [ 0 1 0 ] , [ -1 0 0 ] , 'blade_root_frame_3' );


%-------------------------------------
% HUB airtable defintion
%-------------------------------------

temporary_airtable{1} = [ 0 0 0 ; hub_extension_drag hub_extension_drag hub_extension_drag ; 0 0 0 ]' ;
% In order to avoid warning message in WASP's files .out
temporary_airtable{2} = [ 0 0 0 ; hub_extension_drag hub_extension_drag hub_extension_drag ; 0 0 0 ]' ;

airtables_definition ( fpc , 'y' , 'hub_airtable' , [ 0 1 ] , [-180 0 180] , temporary_airtable );

%------------------------------------
% SPINNER airtable definition
%------------------------------------

temporary_airtable_spinner{1} = [ 0 0 0 ; 0 0 0 ; 0 0 0 ]' ;
% In order to avoid warning message in WASP's files .out
temporary_airtable_spinner{2} = [ 0 0 0 ; 0 0 0 ; 0 0 0 ]' ;

airtables_definition ( fpc , 'y' , 'spinner_airtable' , [ 0 1 ] , [-180 0 180] , temporary_airtable_spinner );

fclose(fpc);
