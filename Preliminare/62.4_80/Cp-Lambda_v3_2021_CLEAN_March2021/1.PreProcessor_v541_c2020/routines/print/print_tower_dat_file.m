function   print_tower_dat_file( tower , dat_file_name , rvj_dat_file_name );

%-----------------------------------------------------------------
%  This function prints the .dat file concerned the tower element
%  in a suitable form for the multibody software.
%
%  Input:
%       -tower = is the structure which contains all the 
%                tower data (for more details see the
%                read_tower and tower_definition functions help);
%
%-----------------------------------------------------------------

load names\tower_names
load names\nacelle_names    
%
tower_dat_file_name = dat_file_name(2,:);
rvj_dat_file_name = dat_file_name(14,:);
%

% Send status #LS
disp('  Writing Tower.dat file.........')

fpt=fopen( strcat(dat_file_name(end,:),'\MB_model\',tower_dat_file_name) ,'w');

%---------------------
% Point definition
%---------------------
fprintf(fpt,' Points :\n'); 

ii = 1;

for i = 1 : tower.nentries,
    
    if ( i~=tower.nentries && tower.height(i) == tower.height(i+1) );
        
    elseif i == tower.nentries,
        
        point_definition ( fpt , pt_tower( ii , : ) , [tower.height(i)  0  0  ] , frame_name(1,:) );    
        
    else
        
        point_definition ( fpt , pt_tower( ii , : ) , [tower.height(i)  0  0  ] , frame_name(1,:) );

        ii = ii + 1;
        
    end
        
end

fprintf(fpt,' ;    \n\n\n');

%---------------------------------
% Beam definition
%---------------------------------

fprintf(fpt,' Beams : \n');
for i = 1 : tower.npoint ,
    
    if i == 1;
        
        if tower.foundations(1)==0;  % No foundation model is required
            
            beam_definition ( fpt , tower_name( i , : ) , pt_tower( i  , : ) , 'ground' ,...
                              pt_tower( i + 1  , : ) , tower_name( i + 1 , : ) , tower_curve_name( i , : ),...
                              tower_properties_name( i , : ) );
                          
        elseif tower.foundations(1)==1;  % Foundation model is required
            
            beam_definition ( fpt , tower_name( i , : ) , pt_tower( i  , : ) , 'rb_foundation' ,...
                              pt_tower( i + 1  , : ) , tower_name( i + 1 , : ) , tower_curve_name( i , : ),...
                              tower_properties_name( i , : ) );  
                          
        end
                                           
    elseif i == tower.npoint,        

        beam_definition ( fpt , tower_name( i , : ) , pt_tower( i , : ) , tower_name( i-1  , : ) ,...
                          pt_tower( i + 1 , : ) , rvj_yaw_control_name(1,:) , tower_curve_name( i , : ),...
                          tower_properties_name( i , : ) );                   
        
    else

        beam_definition ( fpt , tower_name( i , : ) , pt_tower( i , : ) , tower_name( i-1  , : ) ,...
                          pt_tower( i + 1 , : ) , tower_name( i + 1 , : ) , tower_curve_name( i , : ),...
                          tower_properties_name( i , : ) );
        
    end
        
end

fprintf(fpt,'  ;\n\n\n');

%-------------------------------------
% Curve definition
%-------------------------------------
fprintf(fpt,' Curves : \n');

for i = 1 : tower.npoint ,
    
    curve_definition( fpt , tower_curve_name( i , : ) , frame_name( 1 , : ) , pt_tower( i , : ) , pt_tower( i + 1 , : ) , [ 0 1 ] ,...
        tower.e2 , tower.e3 , 'y' , 'mesh_tower' );
    
end

fprintf(fpt,' ;\n\n\n'); 

%-------------------------------------
% Curve mesh definition
%-------------------------------------

mesh_definition( fpt , 'y' ,'mesh_tower' , 1 , 3 );


%--------------------------------
% Beam property definition
%--------------------------------
fprintf(fpt,' BeamProperties : \n');
i = 1 ;
temp = 1 ;


%                             'n',...

while ( i <=  ( tower.nentries - 1 ) ),  %is it correct ?????
    
    beam_properties_definition ( fpt , ...
                                 tower_properties_name( temp , : ) ,...
                                 [ 0 1 ] ,...
                                 [ tower.bending_stiffness( i ) tower.bending_stiffness( i ) ; ...
                                   tower.bending_stiffness( i + 1 )  tower.bending_stiffness( i + 1 ) ] , ...
                                 [tower.torsional_stiffness( i ) tower.torsional_stiffness( i + 1 ) ] , ...
                                 [ tower.mass_unit_length( i )  tower.mass_unit_length( i + 1 ) ],...
                                 [ tower.moments_of_inertia( i , : ) ; tower.moments_of_inertia( i + 1 , : ) ] , ...
                                 'n',...
                                 'n',...
                                 'n',...
                                tower.E_modul*[ tower.sections_area( i ) tower.sections_area( i + 1 ) ], 0.005 );      % Ale 27.aug.08... it was 1000*...

                             
     if ( i ~= (tower.nentries - 1) ),
         if ( tower.height(i+1) == tower.height(i+2) ),
             i = i + 2;
         else
             i = i + 1;
         end
         
         temp = temp + 1 ;
         
     else
         break;         
     end

end

fprintf(fpt,' ;    \n\n\n');    

fclose(fpt);

%----------------------------------
%  RVJ yaw control definition
%----------------------------------

% Send status #LS
disp('  Writing Rvj_yaw_control.dat file.........')

fpc=fopen( strcat(dat_file_name(end,:),'\MB_model\',rvj_dat_file_name) ,'w');

revolute_joint_definition ( fpc , 'y' , rvj_yaw_control_name(1,:) , pt_tower( tower.npoint+1 , : ),...
                            tower_name( tower.npoint , : ) , pt_tower( tower.npoint+1 , : ) , nacelle_rb_name(1,:),...
                            rvj_yaw_control_triad(1,:) , 'n' , 'y' , 'n' , 'n' , '' , yaw_rel_name(1,:) , yaw_body_rel(1,:),...
                            '' , '');

prescribed_displacement_def( fpc , 'y' , yaw_body_rel(1,:) , yaw_rel_name(1,:) , pt_tower( tower.npoint+1 , : ),4 , 'yaw_control' , 'Controller_4_Wind_Turbine' );

triad_definition(fpc , 'y' , rvj_yaw_control_triad(1,:) , [ 0 1 0 ] , [ 1 0 0 ] , 'tower_frame' );


fclose(fpc);

%-------------------------------------------------
%  RVJ yaw control definition with time function
% ALEALE 12.nov.2009
%-------------------------------------------------


% Send status #LS
disp('  Writing Rvj_yaw_control_with_time_function.dat file.........')

filename = deblank(rvj_dat_file_name);
fpc=fopen( strcat(dat_file_name(end,:),'\MB_model\',filename(1:end-4),'_with_time_function',filename(end-3:end)) ,'w');

revolute_joint_definition ( fpc , 'y' , rvj_yaw_control_name(1,:) , pt_tower( tower.npoint+1 , : ),...
                            tower_name( tower.npoint , : ) , pt_tower( tower.npoint+1 , : ) , nacelle_rb_name(1,:),...
                            rvj_yaw_control_triad(1,:) , 'n' , 'y' , 'n' , 'n' , '' , yaw_rel_name(1,:) , yaw_body_rel(1,:),...
                            '' , '');

prescribed_displacement_def( fpc , 'y' , yaw_body_rel(1,:) , yaw_rel_name(1,:) , pt_tower( tower.npoint+1 , : ), 4 , 'yaw_control' );

triad_definition(fpc , 'y' , rvj_yaw_control_triad(1,:) , [ 0 1 0 ] , [ 1 0 0 ] , 'tower_frame' );


fclose(fpc);