function rotor_frame(PathStruct, hub , dat_file_name , wasp_flag , fpc)

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


R1 =  hub.R1;   % R1 TIENE CONTO DEL TILT ANGLE


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

    fixed_frame_definition ( fpc, 'n' , frame_name{1}(3,:) , hub.frame_origin , hub.e2 , hub.e3 );  %FRAME HUB

    % ALE 28.oct.05 MANCA IL PRECONO!!!
    % OK 02.feb.09:
    % R1_precone = rot(-Theta_cone*inertial Z axis)^InertialFrame ° R1^InertialFrame
    R11_precone = rot_o(-hub.cone_angle*pi/180 * [ 0 ; 0 ; 1 ])*R1;

    % OK 02.feb.09:
    % R2_temp = R11_precone^InertialFrame ° rot(pi/2*local X axis)^LocalFrame
    R2_temp   =  ( R11_precone * rot_o(((-pi/2)-hub.blade_set_angle) * [ 1 ; 0 ; 0 ]) );             % OK 27/04/2004

    % IMBALANCE & FAILURE MODELLING
    z_temp = menu ('IMBALANCE & FAILURE MODELLING ?' , 'YES' , 'NO' );
    if z_temp == 1 ;
        imbalance_failure = read_imbalance_and_failure(PathStruct);
        R2 = ( R2_temp * rot_o((imbalance_failure.set_angle_err(1)) * [ 1 ; 0 ; 0 ]) ); % OK 27/04/2004
    else
        R2 = R2_temp;
    end

    %% 02.feb.09 this was the original one
    % blade_root_origin  =  hub.frame_origin + [(hub.root_radial_position)*cos(hub.tilt_from_horizontal_rad) (hub.root_radial_position)*sin(hub.tilt_from_horizontal_rad) 0 ];
    % now I consider also the cone angle:
    blade_root_origin  =  hub.frame_origin + [(hub.root_radial_position)*cos(hub.tilt_from_horizontal_rad-hub.cone_angle*pi/180) (hub.root_radial_position)*sin(hub.tilt_from_horizontal_rad-hub.cone_angle*pi/180) 0 ];

    if hub.number_of_blades == 2,

        Rc = R1 * rot_o( pi * [ 0 ; 1 ; 0 ] );        % NON VERIFIED 27/04/2004

        fixed_frame_definition ( fpc , 'n' , frame_name{2}(2,:) , blade_root_origin , Rc(:,2) , Rc(:,3) ); % NON VERIFIED 27/04/2004

    elseif hub.number_of_blades == 3,


        % ALE 28.oct.05 MANCA IL PRECONO!!!
        %         R12_precone = rot_o(-hub.cone_angle*pi/180 * [  sin(pi/3) ; 0 ; -cos(pi/3) ])*R1;  % non credo sia corretta questa rotazione quando il tilt è non nullo...
        %         R13_precone = rot_o(-hub.cone_angle*pi/180 * [ -sin(pi/3) ; 0 ; -cos(pi/3) ])*R1;

        if z_temp == 1 ;

            % 02.feb.07 quindi anche questa non è corretta
            %             Rc2_temp_1 = R12_precone * rot_o( ((120*pi)/180) * [ 0 ; 1 ; 0 ] );
            %             Rc3_temp_1 = R13_precone * rot_o(-((120*pi)/180) * [ 0 ; 1 ; 0 ] );
            % OK 02.feb.09 questa è meglio: ruoto cioè attorno l'asse rotore ineriziale [-sin(hub.tilt_from_horizontal_rad) ; cos(hub.tilt_from_horizontal_rad) ; 0 ]:
            %                               di 120deg il tensore della pala 1 già con il precono (sempre inerziale), quindi premoltiplico rot°R11 (composizione rotazioni nello stesso sdr)
            Rc2_temp_1 = rot_o(120*pi/180*[-sin(hub.tilt_from_horizontal_rad) ; cos(hub.tilt_from_horizontal_rad) ; 0 ])*R11_precone ;
            Rc3_temp_1 = rot_o(-120*pi/180*[-sin(hub.tilt_from_horizontal_rad) ; cos(hub.tilt_from_horizontal_rad) ; 0 ])*R11_precone ;
            %

            Rc2_temp_2 = Rc2_temp_1 * rot_o(((-pi/2)-hub.blade_set_angle) * [ 1 ; 0 ; 0 ]);
            Rc3_temp_2 = Rc3_temp_1 * rot_o(((-pi/2)-hub.blade_set_angle) * [ 1 ; 0 ; 0 ]);

            Rc2 = Rc2_temp_2 * rot_o((imbalance_failure.set_angle_err(2)) * [ 1 ; 0 ; 0 ]);
            Rc3 = Rc3_temp_2 * rot_o((imbalance_failure.set_angle_err(3)) * [ 1 ; 0 ; 0 ]);

        else

            % 02.feb.07 quindi anche questa non è corretta
            %             Rc2_temp_1 = R12_precone * rot_o( ((120*pi)/180) * [ 0 ; 1 ; 0 ] ) % OK 27/04/2004
            %             Rc3_temp_1 = R13_precone * rot_o(-((120*pi)/180) * [ 0 ; 1 ; 0 ] ); % OK 27/04/2004
            % OK 02.feb.09:
            Rc2_temp_1 = rot_o(120*pi/180*[-sin(hub.tilt_from_horizontal_rad) ; cos(hub.tilt_from_horizontal_rad) ; 0 ])*R11_precone
            Rc3_temp_1 = rot_o(-120*pi/180*[-sin(hub.tilt_from_horizontal_rad) ; cos(hub.tilt_from_horizontal_rad) ; 0 ])*R11_precone ;

            Rc2_temp_2 = Rc2_temp_1 * rot_o(((-pi/2)-hub.blade_set_angle) * [ 1 ; 0 ; 0 ]);
            Rc3_temp_2 = Rc3_temp_1 * rot_o(((-pi/2)-hub.blade_set_angle) * [ 1 ; 0 ; 0 ]);

            Rc2 = Rc2_temp_2 ;
            Rc3 = Rc3_temp_2 ;

            % OK 02.feb.09 CHECK (questa è la forma più generale e semplice ma non si può attuare quando c'è l'imbalance che è diversa per ogni pala):
            % Rc2 = rot(2/3pi* Y hub vector in inertial frame) ° R2^InertialFrame; Yhub = [-sin(tc) cos(tc) 0]^InetialFrame
            Rc2_check = rot_o(120*pi/180*[-sin(hub.tilt_from_horizontal_rad) ; cos(hub.tilt_from_horizontal_rad) ; 0 ])*R2 ;
            % Rc2 = rot(-2/3pi* Y hub vector in inertial frame) ° R2^InertialFrame
            Rc3_check = rot_o(-120*pi/180*[-sin(hub.tilt_from_horizontal_rad) ; cos(hub.tilt_from_horizontal_rad) ; 0 ])*R2 ;
            %Rc2-Rc2_check ;
            %Rc3-Rc3_check ;

        end

        % 02.feb.09 these were the original ones
        % origin_2 = hub.frame_origin + ( Rc2_temp_1 * [ hub.root_radial_position 0 0 ]' )' ;
        % origin_3 = hub.frame_origin + ( Rc3_temp_1 * [ hub.root_radial_position 0 0 ]' )' ;

        % origin_1 = hub.frame_origin + ( R2 * [ hub.root_radial_position 0 0 ]' )' ;
        % origin_1 - blade_root_origin
        origin_2 = hub.frame_origin + ( Rc2 * [ hub.root_radial_position 0 0 ]' )' ;
        origin_3 = hub.frame_origin + ( Rc3 * [ hub.root_radial_position 0 0 ]' )' ;

    end

    %%% WRITE FIXED FRAMES

    fixed_frame_definition ( fpc , 'n' , frame_name{1}(2,:) , blade_root_origin , R2(:,2) , R2(:,3) ); %BLADE_ROOT_FRAME_1
    fixed_frame_definition ( fpc , 'n' , frame_name{2}(2,:) , origin_2 , Rc2(:,2) , Rc2(:,3) ); %BLADE_ROOT_FRAME_2
    fixed_frame_definition ( fpc , 'n' , frame_name{3}(2,:) , origin_3 , Rc3(:,2) , Rc3(:,3) ); %BLADE_ROOT_FRAME_3
    fixed_frame_definition ( fpc , 'n' , frame_name{1}(1,:) , [ 0 0 0 ] , [ 0 1 0 ] , [ 0 0 1 ] );     %TOWER_FRAME

    % -----------------------------------------
    % Added by ALE. 28.march.2005 - WIND FRAME
    %    fixed_frame_definition ( fpc , 'n' , 'frame_wind_file' , hub.frame_origin , [ 0.0 0.0 1.0 ] , [ cos(hub.tilt_from_horizontal_rad+8*pi/180) -sin(hub.tilt_from_horizontal_rad+8*pi/180) 0.0 ] );     %WIND_FRAME   tilt + 8deg!!!
    fixed_frame_definition ( fpc , 'n' , 'frame_wind_file' , hub.frame_origin , [ 0.0 0.0 1.0 ] , [ cos(8*pi/180) -sin(8*pi/180) 0.0 ] );     %WIND_FRAME   8deg!!!
    % -----------------------------------------
    % Added by ALE. 28.march.2005 - SHAPE FRAME
    fixed_frame_definition ( fpc , 'n' , 'tower_frame_shape' , [0 0 0] , [ 0 1 0 ] , [0 0 1] );
    fixed_frame_definition ( fpc , 'n' , 'frame_shape_nacelle_botton' , [0 0 0] , [ 0 0 -1 ] , [0 1 0] );
    fixed_frame_definition ( fpc , 'n' , 'frame_shape_hub' , [0 0 0] , [ 0 0 1 ] , [0 -1 0] );
    % -----------------------------------------


    fprintf(fpc,' ; \n');


    if  ( wasp_flag == 'n' | wasp_flag == 'N' ),

        fclose(fpc);

    end

end
