function rotor_frame(hub , dat_file_name , wasp_flag , fpc );

%-------------------------------------------------------------------
%  This function defines each frames of the rotot (blade & hub )
%  with respect to the inertial reference (placed at the tower base).
%  After this, if necessary, the function prints a
%  suitable .dat file.
%
%  Sintax:
%
%        -[hub] = rotor_frame(hub);
%
%  Input:
%
%        -hub = it is the structure from the function
%               read_hub_details;
%
%------------------------------------------------------------------

% REMARK : ATTENTION ! ONLY THE TREE BLADES MODEL IS CORRECT
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%
load names\blade_names
load names\hub_copy_names


R1 =  hub.R1;   % R1 TIENE CONOT DEL TILT ANGLE


if ( wasp_flag == 'y' | wasp_flag == 'Y' ) ,
    
    z = 1;
    
else
    z = menu('WOULD YOU LIKE TO PRINT THE ROTOR FRAME .DAT FILE?','YES','NO');
end

if z == 1;
    

    if  ( wasp_flag == 'n' | wasp_flag == 'N' ),
        %
        rotor_file_name = dat_file_name(12,:);
        fpc = fopen( strcat(dat_file_name(end,:),'\MB_model\',rotor_file_name) ,'w');
    end
    
    fprintf(fpc,'FixedFrames : \n');
    
    fixed_frame_definition ( fpc, 'n' , frame_name{1}(3,:) , hub.frame_origin , hub.e2 , hub.e3 );%frame_hub
    
    z_temp = menu ('IMBALANCE & FAILURE MODELLING ?' , 'YES' , 'NO' );
    
    if z_temp == 1 ;
        
        imbalance_failure = read_imbalance_and_failure;
        
    end
    
    if z_temp == 1 ;
        
        R2_temp   =  ( R1 * rot_o(((-pi/2)-hub.blade_set_angle) * [ 1 ; 0 ; 0 ]) );     % OK 27/04/2004
        
        R2 = ( R2_temp * rot_o((imbalance_failure.set_angle_err(1)) * [ 1 ; 0 ; 0 ]) ); % OK 27/04/2004
        
        % ALE 28.oct.05 MANCA IL PRECONO!!!
        R2_precone = rot_o(-hub.cone_angle * [ 0 ; 0 ; 1 ])*R2;
        keyboard

        
    else
        
        R2_temp   =    ( R1 * rot_o(((-pi/2)-hub.blade_set_angle) * [ 1 ; 0 ; 0 ]) );    % OK 27/04/2004
        
        R2 = R2_temp;
        
        % ALE 28.oct.05 MANCA IL PRECONO!!!
        R2_precone = rot_o(-hub.cone_angle * [ 0 ; 0 ; 1 ])*R2;
        keyboard
    end   
    
    blade_root_origin  =  hub.frame_origin + [(hub.root_radial_position)*cos(hub.tilt_from_horizontal_rad)...
            (hub.root_radial_position)*sin(hub.tilt_from_horizontal_rad) 0 ];
    
    fixed_frame_definition ( fpc , 'n' , frame_name{1}(2,:) , blade_root_origin , R2(:,2) , R2(:,3) ); %BLADE_ROOT_FRAME_1
    
    fixed_frame_definition ( fpc , 'n' , frame_name{1}(1,:) , [ 0 0 0 ] , [ 0 1 0 ] , [ 0 0 1 ] );     %TOWER_FRAME
    
    % -----------------------------------------
    % Added by ALE. 28.march.2005 - WIND FRAME
%    fixed_frame_definition ( fpc , 'n' , 'frame_wind_file' , hub.frame_origin , [ 0.0 0.0 1.0 ] , [ cos(hub.tilt_from_horizontal_rad+8*pi/180) -sin(hub.tilt_from_horizontal_rad+8*pi/180) 0.0 ] );     %WIND_FRAME   tilt + 8deg!!! 
    fixed_frame_definition ( fpc , 'n' , 'frame_wind_file' , hub.frame_origin , [ 0.0 0.0 1.0 ] , [ cos(8*pi/180) -sin(8*pi/180) 0.0 ] );     %WIND_FRAME   8deg!!! 
    % -----------------------------------------
    
    
    if hub.number_of_blades == 2,
        
        Rc = R1 * rot_o( pi * [ 0 ; 1 ; 0 ] );        % NON VERIFIED 27/04/2004
        
        fixed_frame_definition ( fpc , 'n' , frame_name{2}(2,:) , blade_root_origin , Rc(:,2) , Rc(:,3) ); % NON VERIFIED 27/04/2004
        
    elseif hub.number_of_blades == 3,     
        
        if z_temp == 1 ;
            
            Rc2_temp_1 = R1 * rot_o( ((120*pi)/180) * [ 0 ; 1 ; 0 ] );
            Rc3_temp_1 = R1 * rot_o(-((120*pi)/180) * [ 0 ; 1 ; 0 ] );
            
            Rc2_temp_2 = Rc2_temp_1 * rot_o(((-pi/2)-hub.blade_set_angle) * [ 1 ; 0 ; 0 ]);
            Rc3_temp_2 = Rc3_temp_1 * rot_o(((-pi/2)-hub.blade_set_angle) * [ 1 ; 0 ; 0 ]);
            
            Rc2 = Rc2_temp_2 * rot_o((imbalance_failure.set_angle_err(2)) * [ 1 ; 0 ; 0 ]);
            Rc3 = Rc3_temp_2 * rot_o((imbalance_failure.set_angle_err(3)) * [ 1 ; 0 ; 0 ]);
            
        else
            
            Rc2_temp_1 = R1 * rot_o( ((120*pi)/180) * [ 0 ; 1 ; 0 ] ); % OK 27/04/2004
            Rc3_temp_1 = R1 * rot_o(-((120*pi)/180) * [ 0 ; 1 ; 0 ] ); % OK 27/04/2004
            
            Rc2_temp_2 = Rc2_temp_1 * rot_o(((-pi/2)-hub.blade_set_angle) * [ 1 ; 0 ; 0 ]);
            Rc3_temp_2 = Rc3_temp_1 * rot_o(((-pi/2)-hub.blade_set_angle) * [ 1 ; 0 ; 0 ]);
            
            Rc2 = Rc2_temp_2 ;
            Rc3 = Rc3_temp_2 ;
            
        end        
        
        
        origin_2 = hub.frame_origin + ( Rc2_temp_1 * [ hub.root_radial_position 0 0 ]' )' ;
        origin_3 = hub.frame_origin + ( Rc3_temp_1 * [ hub.root_radial_position 0 0 ]' )' ; 
        
        fixed_frame_definition ( fpc , 'n' , frame_name{2}(2,:) , origin_2 , Rc2(:,2) , Rc2(:,3) ); %BLADE_ROOT_FRAME_2
        
        fixed_frame_definition ( fpc , 'n' , frame_name{3}(2,:) , origin_3 , Rc3(:,2) , Rc3(:,3) ); %BLADE_ROOT_FRAME_3
        
    end
    
    fprintf(fpc,' ; \n');
    
    
    if  ( wasp_flag == 'n' | wasp_flag == 'N' ),
        
        fclose(fpc);
        
    end
    
end