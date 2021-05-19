function print_point_mass_dat_file( point_mass , blade_pitch_axis , blade_distance_from_root , blade_chord , dat_file_name , number_of_blades );

%-------------------------------------------------------------
%  This function prints the .dat file which defines the point 
%  mass along the blade.
%
%  Syntax:
%         -print_point_mass_dat_file(point_mass);
%
%  Input:
%         -point_mass =  is a structure which contains the data 
%                        reads in the Bladed report file;
%---------------------------------------------------------------
% Send status #LS
disp('  Writing Blade_point_masses.dat file.........')

load names\blade_names
%
ptmass_file_name = dat_file_name(6,:);
%

np = point_mass.number;

triad = strvcat('triad_01','triad_02','triad_03');

fpb=fopen( strcat(dat_file_name(end,:),'\MB_model\',ptmass_file_name) ,'w' );

fprintf(fpb,' RigidBodies:\n'); 

for ii = 1 : number_of_blades,
    for i = 1 : np ;
        if (point_mass.mass) % ALEALE 12.nov.2009 No mass properties if the mass is null 
            rigid_body_definition( fpb , point_mass_name{ii}(np,:) , pt_blade_tip_name{ii}(np,:) , blade_name{ii}(np,:) , pt_blade_root_name{ii}(np+1,:) , ...
                               blade_name{ii}(np+1,:) , triad(ii,:) , 'n' , 'y', '' , '' , '' , pt_mass_name(i,:) );
        else
            rigid_body_definition( fpb , point_mass_name{ii}(np,:) , pt_blade_tip_name{ii}(np,:) , blade_name{ii}(np,:) , pt_blade_root_name{ii}(np+1,:) , ...
                               blade_name{ii}(np+1,:) , triad(ii,:) , 'n' , 'n', '' , '' , '' , pt_mass_name(i,:) );
        end            
    end
end

fprintf(fpb,' ;    \n\n\n');    

if (point_mass.mass) % ALEALE 12.nov.2009: No mass properties if the mass is null
    fprintf(fpb,' MassProperties : \n');
    for i = 1 :np,
        i=1;
        while blade_distance_from_root(i) <= point_mass.position;
            i=i+1;
        end

        local_pitch_axis = interp1([blade_distance_from_root(i-1) blade_distance_from_root(i)] , [blade_pitch_axis(i-1) blade_pitch_axis(i)] ,point_mass.position,'linear');
        local_chord = interp1([blade_distance_from_root(i-1) blade_distance_from_root(i)] , [blade_chord(i-1) blade_chord(i)] ,point_mass.position,'linear');
        center_of_mass= [ 0 (local_pitch_axis-point_mass.chord)*local_chord/100 0 ];
        mass_property_definition( 'n' , fpb , pt_mass_name(1,:) , point_mass.mass , center_of_mass , [ 0 0 0 0 0 0 ]);

    end
    fprintf(fpb,' ;    \n\n\n');
end

%----------------------------------------------
% Point mass triad definition
%----------------------------------------------

for ii = 1 : number_of_blades,    

    triad_definition(fpb , 'y' , triad(ii,:) , [ 0 1 0 ] , [ 0 0 1 ] ,  frame_name{ii}(2,:));
    
end


fclose(fpb);