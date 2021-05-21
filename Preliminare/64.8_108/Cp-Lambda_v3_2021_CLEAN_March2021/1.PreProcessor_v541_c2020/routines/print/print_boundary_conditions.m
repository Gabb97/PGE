function print_boundary_conditions(foundations_data,dat_file_name);

%--------------------------------------------------------------------------------------------
%  This function prints in a .dat file the
%  tower ground bound in a form suitable for the 
%  multibody code.
%
%  Syntax:
%         -print_boundary_conditions(foundations_data);
%
%  Input:
%         -foundations = it is an array which contains 
%                        the informations concern the foundations mass and stiffness:
%                        foundations_data(1)= 0 or 1: if 0 no foundations.
%                        foundations_data(2)= side-side and fore-aft linear stiffness.
%                        foundations_data(3)= total foundation mass.
%                        foundations_data(4)= foundation fore-aft and side-side torsional stiffness.
%                        foundations_data(5)= foundation fore-aft and side-side moment of inertia 
%                        about the centre of mass 
%--------------------------------------------------------------------------------------------

%
% ALE. 10.may.2005 correct ALL the stiffness because they were ALL wrong!!!
%      REM: chebychev coeff ~= stiffness unless |range_min|=range_max=1 !!!!
%
load names\tower_names pt_tower tower_name
load names\hub_names hub_name point_hub_name

% Send status #LS
disp('  Writing Ground_static.dat file.........')

% STATIC BOUNDARY CONDITIONS-----------------------------------<
% fpt=fopen('Multibody\Ground_static.dat','w');
fpt=fopen(strcat(dat_file_name(end,:),'\MB_model\Ground_static.dat') ,'w');

if foundations_data(1)==0;
    
    % NO FOUNDATION MODEL
    boundary_conditions_definition( fpt , 'ground' , tower_name(1,:) , pt_tower(1,:) , [ 1 , 1 , 1 ] , [ 1 , 1 , 1 ] );
    spring_definition( fpt, 'y' , 'torsional' , 'spring_hub_clamp' , [ -1 , 1 ] , [2] , [ 0 , 1e10 ] , 'n' );
    
else
    
    % YES FOUNDATION MODEL
    
    fprintf(fpt,'RigidBodies :\n');    
    
    rigid_body_definition( fpt , 'rb_foundation' , pt_tower(1,:) , tower_name(1,:) , pt_tower(1,:) , 'foundation_side_prj' , 'triad_z' ,...
                           'n' , 'y' , '' , '' , '' , 'foundation_mass' );
    
    fprintf(fpt,';\n\n');
    
    mass_property_definition( 'y' , fpt , 'foundation_mass' , foundations_data(3) , [0 0 0] , [2*foundations_data(5) 0 0 foundations_data(5) 0 foundations_data(5) ] );
    
    if ( foundations_data(4) ~= 0 & foundations_data(2) ~= 0 ),
    
        boundary_conditions_definition( fpt , 'ground' , 'foundation_side_rvj' , pt_tower(1,:) , [ 1 , 1 , 1 ] , [ 1 , 1 , 1 ] );
        
        fprintf(fpt,'RevoluteJoints: \n');
        
        revolute_joint_definition ( fpt , 'n' , 'foundation_side_rvj' , pt_tower(1,:) , 'ground' , pt_tower(1,:) , 'foundation_aft_rvj' , ...
                                   'triad_y' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_1' , 'null' , 'foundation_torsional_spring' );
        
        revolute_joint_definition ( fpt , 'n' , 'foundation_aft_rvj' , pt_tower(1,:) , 'foundation_side_rvj' , pt_tower(1,:) , 'foundation_aft_prj' , ...
                                   'triad_z' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_2' , 'null' , 'foundation_torsional_spring' );                            
        
        fprintf(fpt,' ;\n\n');             
        
        fprintf(fpt,'PrismaticJoints: \n');
        
        prismatic_joint_definition ( fpt , 'n' , 'foundation_side_prj' , pt_tower(1,:) , 'rb_foundation' , pt_tower(1,:) , 'foundation_aft_prj' , ...
                                    'triad_z' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_3' , 'null' , 'foundation_linear_spring' );
        
        prismatic_joint_definition ( fpt , 'n' , 'foundation_aft_prj' , pt_tower(1,:) , 'foundation_side_prj' , pt_tower(1,:) , 'foundation_aft_rvj' , ...
                                   'triad_y' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_4' , 'null' , 'foundation_linear_spring' );                            
        
        fprintf(fpt,' ;\n\n');                     
        
    elseif( foundations_data(4) ~= 0 & foundations_data(2) == 0 ),
    
        boundary_conditions_definition( fpt , 'ground' , 'foundation_side_rvj' , pt_tower(1,:) , [ 1 , 1 , 1 ] , [ 1 , 1 , 1 ] );
        
        fprintf(fpt,'RevoluteJoints: \n');
        
        revolute_joint_definition ( fpt , 'n' , 'foundation_side_rvj' , pt_tower(1,:) , 'ground' , pt_tower(1,:) , 'foundation_aft_rvj' , ...
                                   'triad_y' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_1' , 'null' , 'foundation_torsional_spring' );
        
        revolute_joint_definition ( fpt , 'n' , 'foundation_aft_rvj' , pt_tower(1,:) , 'foundation_side_rvj' , pt_tower(1,:) , 'rb_foundation' , ...
                                   'triad_z' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_2' , 'null' , 'foundation_torsional_spring' );                            
        
        fprintf(fpt,' ;\n\n');        
        
    else
        
        boundary_conditions_definition( fpt , 'ground' , 'foundation_aft_prj' , pt_tower(1,:) , [ 1 , 1 , 1 ] , [ 1 , 1 , 1 ] );
        
        fprintf(fpt,'PrismaticJoints: \n');
        
        prismatic_joint_definition ( fpt , 'n' , 'foundation_side_prj' , pt_tower(1,:) , 'rb_foundation' , pt_tower(1,:) , 'foundation_aft_prj' , ...
                                    'triad_z' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_1' , 'null' , 'foundation_linear_spring' );
        
        prismatic_joint_definition ( fpt , 'n' , 'foundation_aft_prj' , pt_tower(1,:) , 'foundation_side_prj' , pt_tower(1,:) , 'ground' , ...
                                   'triad_y' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_2' , 'null' , 'foundation_linear_spring' );                            
        
        fprintf(fpt,' ;\n\n');                
        
    end
    
    fprintf(fpt,'Triads : \n');
       
    triad_definition( fpt , 'n' , 'triad_y' , [ 0 0 -1 ] , [ 0 1 0 ] , 'INERTIAL' );
    
    triad_definition( fpt , 'n' , 'triad_z' , [ 0 1 0 ]  , [ 0 0 1 ] , 'INERTIAL' );
        
    fprintf(fpt,' ; \n\n\n');    
    
    % Foundation SPRING definitions-----------------------------------------------------------------------------------------------------
    fprintf(fpt,' Springs :\n');
    spring_definition( fpt, 'n' , 'torsional' , 'spring_hub_clamp' , [ -1 , 1 ] , [2] , [ 0 , 1e10 ] , 'n' );
    if ( foundations_data(4) ~= 0 & foundations_data(2) ~= 0 ),
        
        spring_definition( fpt, 'n' , 'torsional' , 'foundation_torsional_spring' , [ -1 , 1 ] , [2] , [ 0 , foundations_data(4) ] , 'n' );
        spring_definition( fpt, 'n' , 'linear' , 'foundation_linear_spring' , [ -1 , 1 ] , [2] , [ 0 , foundations_data(2) ] , 'n' );
        
    elseif ( foundations_data(4) ~= 0 & foundations_data(2) == 0 ),
        
        spring_definition( fpt, 'n' , 'torsional' , 'foundation_torsional_spring' , [ -1 , 1 ] , [2] , [ 0 , foundations_data(4) ] , 'n' );
        
    elseif ( foundations_data(4) == 0 & foundations_data(2) ~= 0 ),    
        
        spring_definition( fpt, 'n' , 'linear' , 'foundation_linear_spring' , [ -1 , 1 ] , [2] , [ 0 , foundations_data(2) ] , 'n' );
        
    end
    
    fprintf(fpt,' ;\n');
    %--------------------------------------------------------------------------------------------------------------------------------
    
end


fclose(fpt);
%--------------------------------------------------------------<


% DYNAMIC BOUNDARY CONDITIONS----------------------------------<
% Send status #LS
disp('  Writing Ground_dynamic.dat file.........')

fpt=fopen(strcat(dat_file_name(end,:),'\MB_model\Ground_dynamic.dat') ,'w');
if foundations_data(1)==0;
    
    % NO FOUNDATION MODEL
    boundary_conditions_definition( fpt , 'ground' , tower_name(1,:) , pt_tower(1,:) , [ 1 , 1 , 1 ] , [ 1 , 1 , 1 ] );
    spring_definition( fpt, 'y' , 'torsional' , 'spring_hub_clamp' , [ -1 , 1 ] , [2] , [ 0 , 0 ] , 'n' );
    
else
    
    % YES FOUNDATION MODEL    
    fprintf(fpt,'RigidBodies :\n');    
    
    rigid_body_definition( fpt , 'rb_foundation' , pt_tower(1,:) , tower_name(1,:) , pt_tower(1,:) , 'foundation_side_prj' , 'triad_z' ,...
                           'n' , 'y' , '' , '' , '' , 'foundation_mass' );
    
    fprintf(fpt,';\n\n');
    
    mass_property_definition( 'y' , fpt , 'foundation_mass' , foundations_data(3) , [0 0 0] , [2*foundations_data(5) 0 0 foundations_data(5) 0 foundations_data(5) ] );
    
    if ( foundations_data(4) ~= 0 & foundations_data(2) ~= 0 ),
    
        boundary_conditions_definition( fpt , 'ground' , 'foundation_side_rvj' , pt_tower(1,:) , [ 1 , 1 , 1 ] , [ 1 , 1 , 1 ] );
        
        fprintf(fpt,'RevoluteJoints: \n');
        
        revolute_joint_definition ( fpt , 'n' , 'foundation_side_rvj' , pt_tower(1,:) , 'ground' , pt_tower(1,:) , 'foundation_aft_rvj' , ...
                                   'triad_y' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_1' , 'null' , 'foundation_torsional_spring' );
        
        revolute_joint_definition ( fpt , 'n' , 'foundation_aft_rvj' , pt_tower(1,:) , 'foundation_side_rvj' , pt_tower(1,:) , 'foundation_aft_prj' , ...
                                   'triad_z' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_2' , 'null' , 'foundation_torsional_spring' );                            
        
        fprintf(fpt,' ;\n\n');             
        
        fprintf(fpt,'PrismaticJoints: \n');
        
        prismatic_joint_definition ( fpt , 'n' , 'foundation_side_prj' , pt_tower(1,:) , 'rb_foundation' , pt_tower(1,:) , 'foundation_aft_prj' , ...
                                    'triad_z' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_3' , 'null' , 'foundation_linear_spring' );
        
        prismatic_joint_definition ( fpt , 'n' , 'foundation_aft_prj' , pt_tower(1,:) , 'foundation_side_prj' , pt_tower(1,:) , 'foundation_aft_rvj' , ...
                                   'triad_y' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_4' , 'null' , 'foundation_linear_spring' );                            
        
        fprintf(fpt,' ;\n\n');                     
        
    elseif( foundations_data(4) ~= 0 & foundations_data(2) == 0 ),
    
        boundary_conditions_definition( fpt , 'ground' , 'foundation_side_rvj' , pt_tower(1,:) , [ 1 , 1 , 1 ] , [ 1 , 1 , 1 ] );
        
        fprintf(fpt,'RevoluteJoints: \n');
        
        revolute_joint_definition ( fpt , 'n' , 'foundation_side_rvj' , pt_tower(1,:) , 'ground' , pt_tower(1,:) , 'foundation_aft_rvj' , ...
                                   'triad_y' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_1' , 'null' , 'foundation_torsional_spring' );
        
        revolute_joint_definition ( fpt , 'n' , 'foundation_aft_rvj' , pt_tower(1,:) , 'foundation_side_rvj' , pt_tower(1,:) , 'rb_foundation' , ...
                                   'triad_z' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_2' , 'null' , 'foundation_torsional_spring' );                            
        
        fprintf(fpt,' ;\n\n');        
        
    else
        
        boundary_conditions_definition( fpt , 'ground' , 'foundation_aft_prj' , pt_tower(1,:) , [ 1 , 1 , 1 ] , [ 1 , 1 , 1 ] );
        
        fprintf(fpt,'PrismaticJoints: \n');
        
        prismatic_joint_definition ( fpt , 'n' , 'foundation_side_prj' , pt_tower(1,:) , 'rb_foundation' , pt_tower(1,:) , 'foundation_aft_prj' , ...
                                    'triad_z' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_1' , 'null' , 'foundation_linear_spring' );
        
        prismatic_joint_definition ( fpt , 'n' , 'foundation_aft_prj' , pt_tower(1,:) , 'foundation_side_prj' , pt_tower(1,:) , 'ground' , ...
                                   'triad_y' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_2' , 'null' , 'foundation_linear_spring' );                            
        
        fprintf(fpt,' ;\n\n');                
        
    end
    
    fprintf(fpt,'Triads : \n');
       
    triad_definition( fpt , 'n' , 'triad_y' , [ 0 0 -1 ] , [ 0 1 0 ] , 'INERTIAL' );
    
    triad_definition( fpt , 'n' , 'triad_z' , [ 0 1 0 ]  , [ 0 0 1 ] , 'INERTIAL' );
        
    fprintf(fpt,' ; \n\n\n');    
    
    % Foundation SPRING definitions-----------------------------------------------------------------------------------------------------
    fprintf(fpt,' Springs :\n');    
    spring_definition( fpt, 'n' , 'torsional' , 'spring_hub_clamp' , [ -1.0e+06 , 1.0e+06 ] , [2] , [ 0 , 0 ] , 'n' );
    if ( foundations_data(4) ~= 0 & foundations_data(2) ~= 0 ),
        
        spring_definition( fpt, 'n' , 'torsional' , 'foundation_torsional_spring' , [ -1 , 1 ] , [2] , [ 0 , foundations_data(4) ] , 'n' );
        spring_definition( fpt, 'n' , 'linear' , 'foundation_linear_spring' , [ -1 , 1 ] , [2] , [ 0 , foundations_data(2) ] , 'n' );
        
    elseif ( foundations_data(4) ~= 0 & foundations_data(2) == 0 ),
        
        spring_definition( fpt, 'n' , 'torsional' , 'foundation_torsional_spring' , [ -1 , 1 ] , [2] , [ 0 , foundations_data(4) ] , 'n' );
        
    elseif ( foundations_data(4) == 0 & foundations_data(2) ~= 0 ),    
        
        spring_definition( fpt, 'n' , 'linear' , 'foundation_linear_spring' , [ -1 , 1 ] , [2] , [ 0 , foundations_data(2) ] , 'n' );
        
    end
    
    fprintf(fpt,' ;\n');
    %--------------------------------------------------------------------------------------------------------------------------------
    
end


fclose(fpt);
%---------------------------------------------------------------<

%% ALEALE 21.Feb.2019 add also Groud static with sof spring for Campbell
% STATIC BOUNDARY CONDITIONS-----------------------------------<
% fpt=fopen('Multibody\Ground_static.dat','w');

% Send status #LS
disp('  Writing Ground_static_4_Campbell.dat file.........')

fpt=fopen(strcat(dat_file_name(end,:),'\MB_model\Ground_static_4_Campbell.dat') ,'w');

if foundations_data(1)==0;
    
    % NO FOUNDATION MODEL
    boundary_conditions_definition( fpt , 'ground' , tower_name(1,:) , pt_tower(1,:) , [ 1 , 1 , 1 ] , [ 1 , 1 , 1 ] );
    spring_definition( fpt, 'y' , 'torsional' , 'spring_hub_clamp' , [ -1 , 1 ] , [2] , [ 0 , 1e05 ] , 'n' );
    
else
    
    % YES FOUNDATION MODEL
    
    fprintf(fpt,'RigidBodies :\n');    
    
    rigid_body_definition( fpt , 'rb_foundation' , pt_tower(1,:) , tower_name(1,:) , pt_tower(1,:) , 'foundation_side_prj' , 'triad_z' ,...
                           'n' , 'y' , '' , '' , '' , 'foundation_mass' );
    
    fprintf(fpt,';\n\n');
    
    mass_property_definition( 'y' , fpt , 'foundation_mass' , foundations_data(3) , [0 0 0] , [2*foundations_data(5) 0 0 foundations_data(5) 0 foundations_data(5) ] );
    
    if ( foundations_data(4) ~= 0 & foundations_data(2) ~= 0 ),
    
        boundary_conditions_definition( fpt , 'ground' , 'foundation_side_rvj' , pt_tower(1,:) , [ 1 , 1 , 1 ] , [ 1 , 1 , 1 ] );
        
        fprintf(fpt,'RevoluteJoints: \n');
        
        revolute_joint_definition ( fpt , 'n' , 'foundation_side_rvj' , pt_tower(1,:) , 'ground' , pt_tower(1,:) , 'foundation_aft_rvj' , ...
                                   'triad_y' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_1' , 'null' , 'foundation_torsional_spring' );
        
        revolute_joint_definition ( fpt , 'n' , 'foundation_aft_rvj' , pt_tower(1,:) , 'foundation_side_rvj' , pt_tower(1,:) , 'foundation_aft_prj' , ...
                                   'triad_z' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_2' , 'null' , 'foundation_torsional_spring' );                            
        
        fprintf(fpt,' ;\n\n');             
        
        fprintf(fpt,'PrismaticJoints: \n');
        
        prismatic_joint_definition ( fpt , 'n' , 'foundation_side_prj' , pt_tower(1,:) , 'rb_foundation' , pt_tower(1,:) , 'foundation_aft_prj' , ...
                                    'triad_z' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_3' , 'null' , 'foundation_linear_spring' );
        
        prismatic_joint_definition ( fpt , 'n' , 'foundation_aft_prj' , pt_tower(1,:) , 'foundation_side_prj' , pt_tower(1,:) , 'foundation_aft_rvj' , ...
                                   'triad_y' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_4' , 'null' , 'foundation_linear_spring' );                            
        
        fprintf(fpt,' ;\n\n');                     
        
    elseif( foundations_data(4) ~= 0 & foundations_data(2) == 0 ),
    
        boundary_conditions_definition( fpt , 'ground' , 'foundation_side_rvj' , pt_tower(1,:) , [ 1 , 1 , 1 ] , [ 1 , 1 , 1 ] );
        
        fprintf(fpt,'RevoluteJoints: \n');
        
        revolute_joint_definition ( fpt , 'n' , 'foundation_side_rvj' , pt_tower(1,:) , 'ground' , pt_tower(1,:) , 'foundation_aft_rvj' , ...
                                   'triad_y' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_1' , 'null' , 'foundation_torsional_spring' );
        
        revolute_joint_definition ( fpt , 'n' , 'foundation_aft_rvj' , pt_tower(1,:) , 'foundation_side_rvj' , pt_tower(1,:) , 'rb_foundation' , ...
                                   'triad_z' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_2' , 'null' , 'foundation_torsional_spring' );                            
        
        fprintf(fpt,' ;\n\n');        
        
    else
        
        boundary_conditions_definition( fpt , 'ground' , 'foundation_aft_prj' , pt_tower(1,:) , [ 1 , 1 , 1 ] , [ 1 , 1 , 1 ] );
        
        fprintf(fpt,'PrismaticJoints: \n');
        
        prismatic_joint_definition ( fpt , 'n' , 'foundation_side_prj' , pt_tower(1,:) , 'rb_foundation' , pt_tower(1,:) , 'foundation_aft_prj' , ...
                                    'triad_z' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_1' , 'null' , 'foundation_linear_spring' );
        
        prismatic_joint_definition ( fpt , 'n' , 'foundation_aft_prj' , pt_tower(1,:) , 'foundation_side_prj' , pt_tower(1,:) , 'ground' , ...
                                   'triad_y' , 'n' , 'y' , 'y' , 'n' , '' , 'sp_rel_2' , 'null' , 'foundation_linear_spring' );                            
        
        fprintf(fpt,' ;\n\n');                
        
    end
    
    fprintf(fpt,'Triads : \n');
       
    triad_definition( fpt , 'n' , 'triad_y' , [ 0 0 -1 ] , [ 0 1 0 ] , 'INERTIAL' );
    
    triad_definition( fpt , 'n' , 'triad_z' , [ 0 1 0 ]  , [ 0 0 1 ] , 'INERTIAL' );
        
    fprintf(fpt,' ; \n\n\n');    
    
    % Foundation SPRING definitions-----------------------------------------------------------------------------------------------------
    fprintf(fpt,' Springs :\n');
    spring_definition( fpt, 'n' , 'torsional' , 'spring_hub_clamp' , [ -1 , 1 ] , [2] , [ 0 , 1e05 ] , 'n' );
    if ( foundations_data(4) ~= 0 & foundations_data(2) ~= 0 ),
        
        spring_definition( fpt, 'n' , 'torsional' , 'foundation_torsional_spring' , [ -1 , 1 ] , [2] , [ 0 , foundations_data(4) ] , 'n' );
        spring_definition( fpt, 'n' , 'linear' , 'foundation_linear_spring' , [ -1 , 1 ] , [2] , [ 0 , foundations_data(2) ] , 'n' );
        
    elseif ( foundations_data(4) ~= 0 & foundations_data(2) == 0 ),
        
        spring_definition( fpt, 'n' , 'torsional' , 'foundation_torsional_spring' , [ -1 , 1 ] , [2] , [ 0 , foundations_data(4) ] , 'n' );
        
    elseif ( foundations_data(4) == 0 & foundations_data(2) ~= 0 ),    
        
        spring_definition( fpt, 'n' , 'linear' , 'foundation_linear_spring' , [ -1 , 1 ] , [2] , [ 0 , foundations_data(2) ] , 'n' );
        
    end
    
    fprintf(fpt,' ;\n');
    %--------------------------------------------------------------------------------------------------------------------------------
    
end


fclose(fpt);
