function  [multibody_blade] = blade_definition(blade,PathStruct);

%-----------------------------------------------------
%  This function, after having read the .txt file 
%  from the Bladed For Windows report file, 
%  defines the rotor blades and produces the .dat 
%  input files for the multibody code.
%
%  Sintax:
%         -blade_defintion(blade);
%  
%  input:
%         -blade = this is the structure defined by the 
%                  function read_blade  (for more details
%                  see the help of this function);
%
%----------------------------------------------------


% REMARK: in this function the pre-bend must be checked !!!!!!!!


load routines\names\blade_names


%--------------------------------------------------
[point_mass] = read_point_mass(blade,PathStruct);
% NB - 'point_mass' structure composed as follows
%         position
%         chord
%         mass
%         number
%---------------------------------------------------

% Ale. 04.feb.05 
% I suppose that the multibody blades are divided into
% two parts --> this routine works only IF point_mass.number==1 !!!!!
% Furthermore: multibody_blade.xxx{1,ID of the blades part(i.e. 1 or 2) }

% Added by Ale 17.feb.05
temp_t = blade.thickness.*blade.thickness/10000; 

%%%%%%%%%%%%%%%%%%%%%%%%

if point_mass.number==1;
    np = point_mass.number;
    nentries = find_nentries(blade , point_mass , np );    
    for i = 1:2,               
        if i == 1;
            multibody_blade.end_point0(:,:,i)                   =  [ blade.distance_from_root(i) , 0 , 0 ];
            multibody_blade.end_point1(:,:,i)                   =  [ point_mass.position(np) , 0 , 0 ];
            multibody_blade.eta{1,i}                            =  blade.distance_from_root(1:nentries(i)-1) ./ point_mass.position(np);
            multibody_blade.eta{1,i}(nentries(np))              =  1;            
            multibody_blade.twist(:,i)                          =  blade.twist(1:nentries(i)-1);
            multibody_blade.twist(nentries(i),i)                =  interp1(blade.distance_from_root , blade.twist , point_mass.position(i),'linear' );           

            % ALEALE 12.nov.2009
            multibody_blade.pre_bend_angle(:,i)                 =  blade.pre_bend_angle(1:nentries(i)-1);
            multibody_blade.pre_bend_angle(nentries(i),i)       =  interp1(blade.distance_from_root , blade.pre_bend_angle , point_mass.position(i),'linear' );           
            %
            
            multibody_blade.chord(:,i)                          =  blade.chord (1:nentries(i)-1);
            multibody_blade.chord(nentries(i),i)                =  interp1(blade.distance_from_root , blade.chord , point_mass.position(i),'linear' );
            multibody_blade.centre_of_mass{1,i}(:,1)            =  -1*((blade.centre_of_mass(1:nentries(i)-1)) - (blade.pitch_axis(1:nentries(i)-1))) .* blade.chord(1:nentries(i)-1)/100;
            temp_centre_of_mass                                 =  interp1(blade.distance_from_root , blade.centre_of_mass , point_mass.position(i),'linear' );
            temp_pitch_axis                                     =  interp1(blade.distance_from_root , blade.pitch_axis , point_mass.position(i),'linear' );
            % 26.oct.05 ALE prebend is modele with the rotation of the triads
%             multibody_blade.centre_of_mass{1,i}(nentries(i),2)    =  blade.pre_bend(nentries(i));
            multibody_blade.centre_of_mass{1,i}(nentries(i),2)  =  0;
            multibody_blade.centre_of_mass{1,i}(nentries(i),1)  =  -1*((temp_centre_of_mass - temp_pitch_axis)  * ( multibody_blade.chord(nentries(i),i) / 100 )) ;
            % Added by Ale. 14.feb.05
            multibody_blade.centroid{1,i}(:,1)                  =  -1*((blade.neutral_axis_for_bending(1:nentries(i)-1)) - (blade.pitch_axis(1:nentries(i)-1))) .* blade.chord(1:nentries(i)-1)/100;
            temp_centroid                                       =  interp1(blade.distance_from_root , blade.neutral_axis_for_bending , point_mass.position(i),'linear' );
            multibody_blade.centroid{1,i}(nentries(i),2)        =  0;                                                                          
            multibody_blade.centroid{1,i}(nentries(i),1)        =  -1*((temp_centroid - temp_pitch_axis)  * ( multibody_blade.chord(nentries(i),i) / 100 )) ; % +...
            %  % Ale added this 11.feb.05:
            % multibody_blade.centroid{1,i}(:,1:2)                =  [blade.centroid(1:nentries(i)-1)zeros(size(blade.centroid(1:nentries(i)-1))) ];
            % multibody_blade.centroid{1,i}(nentries(i),1:2)      =  [interp1(blade.distance_from_root , blade.centroid , point_mass.position(i),'linear' )  zeros(size(point_mass.position(i)))];
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%                                                                 
            multibody_blade.mass_unit_length{1,i}(:,1)             =  blade.mass_unit_length(1:nentries(i)-1);
            multibody_blade.mass_unit_length{1,i}(nentries(i),i)   =  interp1(blade.distance_from_root , blade.mass_unit_length , point_mass.position(i),'linear' );
            multibody_blade.chord_stiffness{1,i}(:,1)              =  blade.chord_stiffness(1:nentries(i)-1);
            multibody_blade.chord_stiffness{1,i}(nentries(i),i)    =  interp1(blade.distance_from_root , blade.chord_stiffness , point_mass.position(i),'linear' );
            multibody_blade.bending_stiffness{1,i}(:,1)            =  blade.bending_stiffness(1:nentries(i)-1);           
            multibody_blade.bending_stiffness{1,i}(nentries(i),1)  =  interp1(blade.distance_from_root , blade.bending_stiffness , point_mass.position(i),'linear' );
            % Original version:
            % multibody_blade.moments_of_inertia{1,i}(nentries(i),:)  = [ 0 0 0];
            % New version by Ale 03.feb.05 :
            %multibody_blade.moments_of_inertia{1,i}(:,1:3)            =  [blade.moment_of_inertia(1:nentries(i)-1)...
            %        blade.moment_of_inertia(1:nentries(i)-1).*(temp_t(1:nentries(i)-1)./(1+temp_t(1:nentries(i)-1))) ...
            %        blade.moment_of_inertia(1:nentries(i)-1).*(1./(1+temp_t(1:nentries(i)-1))) ];           
            % TEST version by ALEALE 12.oct.12 : v0
           % multibody_blade.moments_of_inertia{1,i}(:,1:3)            =  [blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2 ...
           %         zeros(size(blade.moment_of_inertia(1:nentries(i)-1))) ...
           %         zeros(size(blade.moment_of_inertia(1:nentries(i)-1))) ];           
            % TEST version by ALEALE 12.oct.12 : v1
            % multibody_blade.moments_of_inertia{1,i}(:,1:3)            =  [blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2 ...
            %         (blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2).*(temp_t(1:nentries(i)-1)./(1+temp_t(1:nentries(i)-1))) ...
            %         (blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2).*(1./(1+temp_t(1:nentries(i)-1))) ];           
            % TEST version by ALEALE 12.oct.12 : v2
            % multibody_blade.moments_of_inertia{1,i}(:,1:3)            =  [blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2 ...
            %         (blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2).*((temp_t(1:nentries(i)-1).^2)./(1+temp_t(1:nentries(i)-1).^2)) ...
            %         (blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2).*(1./(1+temp_t(1:nentries(i)-1).^2)) ];           
            % TEST version by ALEALE 12.oct.12 : v3
            % multibody_blade.moments_of_inertia{1,i}(:,1:3)            =  [blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2 ...
            %         (blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2).*0 ...
            %         (blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2).*1 ];           
            % TEST version by ALEALE 12.oct.12 : v4
            % multibody_blade.moments_of_inertia{1,i}(:,1:3)            =  [blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2 ...
            %         (blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2).*1 ...
            %         (blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2).*1 ];           
            % TEST version by ALEALE 12.oct.12 : v5
            % multibody_blade.moments_of_inertia{1,i}(:,1:3)            =  [blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2 ...
            %         (blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2).*1 ...
            %         (blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2).*1 ].*0;           
            % TEST version by ALEALE 12.oct.12 : v6
            multibody_blade.moments_of_inertia{1,i}(:,1:3)            =  [blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2 ...
                    (blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2).*0 ...
                    (blade.moment_of_inertia(1:nentries(i)-1)+multibody_blade.mass_unit_length{1,i}(nentries(i),i).* multibody_blade.centre_of_mass{1,i}(nentries(i),1).^2).*0 ];           

            % Modified by Ale 17.feb.05
            % I suppose the moment of inertia as a function of hte thickness..
            %  zeros(size(blade.moment_of_inertia(1:nentries(i)-1))) ...
            %  zeros(size(blade.moment_of_inertia(1:nentries(i)-1))) ];           
            %  0.5*blade.moment_of_inertia(1:nentries(i)-1) ...
            %  0.5*blade.moment_of_inertia(1:nentries(i)-1) ];           
            %multibody_blade.moments_of_inertia{1,i}(nentries(i),1:3)  = [interp1(blade.distance_from_root , blade.moment_of_inertia , point_mass.position(i),'linear' )...
            %        interp1(blade.distance_from_root , blade.moment_of_inertia.*temp_t./(1+temp_t)  , point_mass.position(i),'linear' )...
            %        interp1(blade.distance_from_root , blade.moment_of_inertia.*1./(1+temp_t)  , point_mass.position(i),'linear' )];
            % TEST version by ALEALE 12.oct.12 : v0
            %multibody_blade.moments_of_inertia{1,i}(nentries(i),1:3)  = [interp1(blade.distance_from_root , blade.moment_of_inertia , point_mass.position(i),'linear' )...
            %        0.*interp1(blade.distance_from_root , blade.moment_of_inertia.*temp_t./(1+temp_t)  , point_mass.position(i),'linear' )...
            %        0.*interp1(blade.distance_from_root , blade.moment_of_inertia.*1./(1+temp_t)  , point_mass.position(i),'linear' )];
            % TEST version by ALEALE 12.oct.12 : v1
            % multibody_blade.moments_of_inertia{1,i}(nentries(i),1:3)  = [interp1(blade.distance_from_root , blade.moment_of_inertia , point_mass.position(i),'linear' )...
            %         interp1(blade.distance_from_root , blade.moment_of_inertia.*temp_t./(1+temp_t)  , point_mass.position(i),'linear' )...
            %         interp1(blade.distance_from_root , blade.moment_of_inertia.*1./(1+temp_t)  , point_mass.position(i),'linear' )];
            % TEST version by ALEALE 12.oct.12 : v2
            % multibody_blade.moments_of_inertia{1,i}(nentries(i),1:3)  = [interp1(blade.distance_from_root , blade.moment_of_inertia , point_mass.position(i),'linear' )...
            %         interp1(blade.distance_from_root , blade.moment_of_inertia.*(temp_t.^2)./(1+temp_t.^2)  , point_mass.position(i),'linear' )...
            %         interp1(blade.distance_from_root , blade.moment_of_inertia.*1./(1+temp_t.^2)  , point_mass.position(i),'linear' )];
            % TEST version by ALEALE 12.oct.12 : v3
            % multibody_blade.moments_of_inertia{1,i}(nentries(i),1:3)  = [interp1(blade.distance_from_root , blade.moment_of_inertia , point_mass.position(i),'linear' )...
            %         interp1(blade.distance_from_root , blade.moment_of_inertia.*0 , point_mass.position(i),'linear' )...
            %         interp1(blade.distance_from_root , blade.moment_of_inertia.*1 , point_mass.position(i),'linear' )];
            % TEST version by ALEALE 12.oct.12 : v4
            % multibody_blade.moments_of_inertia{1,i}(nentries(i),1:3)  = [interp1(blade.distance_from_root , blade.moment_of_inertia , point_mass.position(i),'linear' )...
            %         interp1(blade.distance_from_root , blade.moment_of_inertia.*1 , point_mass.position(i),'linear' )...
            %         interp1(blade.distance_from_root , blade.moment_of_inertia.*1 , point_mass.position(i),'linear' )];
            % TEST version by ALEALE 12.oct.12 : v5
            % multibody_blade.moments_of_inertia{1,i}(nentries(i),1:3)  = [interp1(blade.distance_from_root , blade.moment_of_inertia , point_mass.position(i),'linear' )...
            %         interp1(blade.distance_from_root , blade.moment_of_inertia.*1 , point_mass.position(i),'linear' )...
            %         interp1(blade.distance_from_root , blade.moment_of_inertia.*1 , point_mass.position(i),'linear' )].*0;
            % TEST version by ALEALE 12.oct.12 : v6
            multibody_blade.moments_of_inertia{1,i}(nentries(i),1:3)  = [interp1(blade.distance_from_root , blade.moment_of_inertia , point_mass.position(i),'linear' )...
                    interp1(blade.distance_from_root , blade.moment_of_inertia.*0 , point_mass.position(i),'linear' )...
                    interp1(blade.distance_from_root , blade.moment_of_inertia.*0 , point_mass.position(i),'linear' )];
                
            % Modified by Ale 17.feb.05
            % zeros(size(point_mass.position(i)))...
            % zeros(size(point_mass.position(i)))];
            % 0.5*interp1(blade.distance_from_root , blade.moment_of_inertia , point_mass.position(i),'linear' )...
            % 0.5*interp1(blade.distance_from_root , blade.moment_of_inertia , point_mass.position(i),'linear' )];
            % Ale added this 03.feb.05:
            multibody_blade.torsional_rigidity{1,i}(:,1)            =  blade.torsional_rigidity(1:nentries(i)-1);           
            multibody_blade.torsional_rigidity{1,i}(nentries(i),1)  = interp1(blade.distance_from_root , blade.torsional_rigidity , point_mass.position(i),'linear' );
        else
            multibody_blade.end_point0(:,:,i)                        =  [ point_mass.position(np) , 0 , 0 ];
            multibody_blade.end_point1(:,:,i)                        =  [ blade.distance_from_root(end)  , 0 , 0 ];
            multibody_blade.eta{1,i}(1)                              =  0.0;          
            multibody_blade.eta{1,i}(2:nentries(i),1)                =  (blade.distance_from_root(nentries(i-1):end) - point_mass.position(np)) ./ (blade.distance_from_root(end) - point_mass.position(np));
            multibody_blade.twist(1,i)                               =  multibody_blade.twist( end , i-1 );
            multibody_blade.twist(2:nentries(i),i)                   =  blade.twist(nentries(i-1):end);            

            % ALEALE 12.nov.2009
            multibody_blade.pre_bend_angle(1,i)                       =  multibody_blade.pre_bend_angle( end , i-1 );
            multibody_blade.pre_bend_angle(2:nentries(i),i)           =  blade.pre_bend_angle(nentries(i-1):end);            
            %

            multibody_blade.chord(1,i)                               =  multibody_blade.chord ( end , i-1 );
            multibody_blade.chord(2:nentries(i),i)                   =  blade.chord(nentries(i-1):end);                   
            multibody_blade.centre_of_mass{1,i}(1,1)                 =  multibody_blade.centre_of_mass{1,i-1}( end , i-1 );
            % 26.oct.05 ALE prebend is modele with the rotation of the triads
%             multibody_blade.centre_of_mass{1,i}(2:nentries(i),2)    =  blade.pre_bend(nentries(i-1):end);
            multibody_blade.centre_of_mass{1,i}(nentries(i),2)       =  0;
            multibody_blade.centre_of_mass{1,i}(2:nentries(i),1)     =  -1* (blade.chord(nentries(i-1):end) .* ((blade.centre_of_mass(nentries(i-1):end)/100)- (blade.pitch_axis(nentries(i-1):end)/100)));
            % Added by Ale 14.feb.05 :
            multibody_blade.centroid{1,i}(1,1)                 =  multibody_blade.centroid{1,i-1}( end , i-1 );
            multibody_blade.centroid{1,i}(nentries(i),2)       =  0;            
            multibody_blade.centroid{1,i}(2:nentries(i),1)     =  -1* (blade.chord(nentries(i-1):end) .*((blade.neutral_axis_for_bending(nentries(i-1):end)/100)- (blade.pitch_axis(nentries(i-1):end)/100)));  %+...
            % Ale added this 11.feb.05:
            % multibody_blade.centroid{1,i}(:,1:2)                =  multibody_blade.centroid{1,i-1}(end,1:2);
            %  multibody_blade.centroid{1,i}(2:nentries(i),1:2)      =  [blade.centroid(nentries(i-1):end)...
            %  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            multibody_blade.mass_unit_length{1,i}(1,1)               =  multibody_blade.mass_unit_length{1,i-1}( end , i-1 );
            multibody_blade.mass_unit_length{1,i}(2:nentries(i),1)   =  blade.mass_unit_length(nentries(i-1):end);
            multibody_blade.chord_stiffness{1,i}(1,1)                =  multibody_blade.chord_stiffness{1,i-1}( end , i-1 );
            multibody_blade.chord_stiffness{1,i}(2:nentries(i),1)    =  blade.chord_stiffness(nentries(i-1):end);
            multibody_blade.bending_stiffness{1,i}(1,1)              =  multibody_blade.bending_stiffness{1,i-1}( end, i-1 );            
            multibody_blade.bending_stiffness{1,i}(2:nentries(i),1)  =  blade.bending_stiffness(nentries(i-1):end);
            % Original version:
            % multibody_blade.moments_of_inertia{1,i}(nentries(i),:)   = [ 0 0 0];
            % New version by Ale 03.feb.05 :
            multibody_blade.moments_of_inertia{1,i}(1,1:3)               =  multibody_blade.moments_of_inertia{1,i-1}( end , 1:3 );
            % Modified by Ale 17.feb.05
            % [multibody_blade.moments_of_inertia{1,i-1}( end , i-1 )...
            % zeros(size(multibody_blade.moments_of_inertia{1,i-1}( end , i-1 ))) ...
            % zeros(size(multibody_blade.moments_of_inertia{1,i-1}( end , i-1 ))) ];
            % 0.5*multibody_blade.moments_of_inertia{1,i-1}( end , i-1 ) ...
            % 0.5*multibody_blade.moments_of_inertia{1,i-1}( end , i-1 ) ];
            %multibody_blade.moments_of_inertia{1,i}(2:nentries(i),1:3)   =  [blade.moment_of_inertia(nentries(i-1):end) ...
            %        blade.moment_of_inertia(nentries(i-1):end).*temp_t(nentries(i-1):end)./(1+temp_t(nentries(i-1):end)) ...
            %        blade.moment_of_inertia(nentries(i-1):end).*1./(1+temp_t(nentries(i-1):end))];
            % TEST version by ALEALE 12.oct.12 : v0
            %multibody_blade.moments_of_inertia{1,i}(2:nentries(i),1:3)   =  [blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2 ...
            %        zeros(size(blade.moment_of_inertia(nentries(i-1):end))) ...
            %        zeros(size(blade.moment_of_inertia(nentries(i-1):end))) ];
            % TEST version by ALEALE 12.oct.12 : v1
            % multibody_blade.moments_of_inertia{1,i}(2:nentries(i),1:3)   =  [blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2 ...
            %         (blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2).*temp_t(nentries(i-1):end)./(1+temp_t(nentries(i-1):end)) ...
            %         (blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2).*1./(1+temp_t(nentries(i-1):end))];
            % TEST version by ALEALE 12.oct.12 : v2
            % multibody_blade.moments_of_inertia{1,i}(2:nentries(i),1:3)   =  [blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2 ...
            %         (blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2).*(temp_t(nentries(i-1):end).^2)./(1+temp_t(nentries(i-1):end).^2) ...
            %         (blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2).*1./(1+temp_t(nentries(i-1):end).^2)];
            % TEST version by ALEALE 12.oct.12 : v3
            % multibody_blade.moments_of_inertia{1,i}(2:nentries(i),1:3)   =  [blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2 ...
            %         (blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2).*0 ...
            %         (blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2).*1];
            % TEST version by ALEALE 12.oct.12 : v4
            % multibody_blade.moments_of_inertia{1,i}(2:nentries(i),1:3)   =  [blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2 ...
            %        (blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2).*1 ...
            %         (blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2).*1];
            % TEST version by ALEALE 12.oct.12 : v5
            % multibody_blade.moments_of_inertia{1,i}(2:nentries(i),1:3)   =  [blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2 ...
            %         (blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2).*1 ...
            %         (blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2).*1].*0;
            % TEST version by ALEALE 12.oct.12 : v6
            multibody_blade.moments_of_inertia{1,i}(2:nentries(i),1:3)   =  [blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2 ...
                    (blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2).*0 ...
                    (blade.moment_of_inertia(nentries(i-1):end) +  multibody_blade.mass_unit_length{1,i}(2:nentries(i),1).*multibody_blade.centre_of_mass{1,i}(2:nentries(i),1).^2).*0];

          % Modified by Ale 17.feb.05
            %  zeros(size(blade.moment_of_inertia(nentries(i-1):end))) zeros(size(blade.moment_of_inertia(nentries(i-1):end)))];
            % 0.5*blade.moment_of_inertia(nentries(i-1):end)...
            % 0.5*blade.moment_of_inertia(nentries(i-1):end)];
            % Ale added this 03.feb.05:
            multibody_blade.torsional_rigidity{1,i}(1,1)               =  multibody_blade.torsional_rigidity{1,i-1}( end , i-1 );
            multibody_blade.torsional_rigidity{1,i}(2:nentries(i),1)   =  blade.torsional_rigidity(nentries(i-1):end);
            % Ale added this 11.feb.05:
            % multibody_blade.centroid{1,i}(:,1:2)                    =  [(blade.chord(1:nentries(i)-1)).*(blade.neutral_axis_for_bending(1:nentries(i)-1)-blade.centre_of_mass(1:nentries(i)-1)) zeros(size(blade.neutral_axis_for_bending(1:nentries(i)-1))) ];           
            % multibody_blade.centroid{1,i}(nentries(i),1:2)          =  [interp1(blade.distance_from_root , (blade.chord_stiffness).*(blade.neutral_axis_for_bending-blade.centre_of_mass) , point_mass.position(i),'linear' )  zeros(size(point_mass.position(i)))];
            % keyboard
            % multibody_blade.centroid{1,i}(1,1:2)                    =  [(blade.chord_stiffness{1,i-1}( end , i-1 )).*(blade.neutral_axis_for_bending{1,i-1}( end , i-1 )-blade.centre_of_mass{1,i-1}( end , i-1 ))  zeros(size(blade.neutral_axis_for_bending{1,i-1}( end , i-1 ))) ];           
            % multibody_blade.centroid{1,i}(2:nentries(i),1:2)        =  [(blade.chord_stiffness(nentries(i-1):end)).*(blade.neutral_axis_for_bending(nentries(i-1):end)-blade.centre_of_mass(nentries(i-1):end) zeros(size(blade.chord(nentries(i-1):end)))];
        end      
        % ALE: 21.oct.05 with prebend
        % TWIST ROTATION (x-rotation in the frame hub)
        twist_rad = multibody_blade.twist * (pi/180);                        
        R = rotation_matrix ( i , nentries , -twist_rad, [1;0;0]);
        % BREBEND ROTATION (y-rotation in the frame hub)
        % ALEALE 12.nov.2009
        % R2 = rotation_matrix ( i , nentries ,  blade.pre_bend_angle, [0;1;0]);
        R2 = rotation_matrix ( i , nentries ,  multibody_blade.pre_bend_angle, [0;1;0]);
        %
        % Composition
        for i_triad=1:nentries(i)
            e2(:,1,i_triad)=R2(:,:,i_triad)*R ( : , 2 , i_triad );
            e3(:,1,i_triad)=R2(:,:,i_triad)*R ( : , 3 , i_triad );
        end
        % OLD ONES:
        %         multibody_blade.e2 { 1 , i } = R ( : , 2 , : );
        %         multibody_blade.e3 { 1 , i } = R ( : , 3 , : );
        % NEW ONES:
        multibody_blade.e2 { 1 , i } = e2;
        multibody_blade.e3 { 1 , i } = e3;       
        clear e2 e3
    end    
else % Added by Ale 04.feb.05
    disp('\n ERROR: There is more than one point mass in the blade...');
end