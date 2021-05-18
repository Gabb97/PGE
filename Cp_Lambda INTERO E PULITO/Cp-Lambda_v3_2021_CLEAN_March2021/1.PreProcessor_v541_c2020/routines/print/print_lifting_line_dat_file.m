function print_lifting_line_dat_file( blade_index , section_distance_from_root , section_chord , section_twist , section_pitch_axis , section_Ca , section_airfoil , local_Ca , spinner_diameter , blade_root_lenght , n_point_mass , dat_file_name , rotor_diameter, pre_bend_angle);

%------------------------------------------------
%  This function defines and prints the multibody
%  lifting line model for the rotor blades.
%------------------------------------------------

% Send status #LS
dispstr = ['  Writing Blade_Lifting_Line_' num2str(blade_index) '.dat file.........'];
disp(dispstr)

load names\aero_names

ll_file_name = dat_file_name(8,:);
%
ll_file_name_temp = deblank(ll_file_name);
var = max(size(ll_file_name_temp));

if blade_index == 1,
    
    ll_file_name_def = strcat(ll_file_name_temp(1,1:var-4),'_1','.dat');
    fpc=fopen( strcat(dat_file_name(end,:),'\MB_model\',ll_file_name_def) ,'w');
    
elseif blade_index == 2,
    
    ll_file_name_def = strcat(ll_file_name_temp(1,1:var-4),'_2','.dat');
    
    fpc=fopen( strcat(dat_file_name(end,:),'\MB_model\',ll_file_name_def) ,'w');
    
elseif blade_index == 3,
    
    ll_file_name_def = strcat(ll_file_name_temp(1,1:var-4),'_3','.dat');
    
    fpc=fopen( strcat(dat_file_name(end,:),'\MB_model\',ll_file_name_def) ,'w');    
    
end


section_twist_rad = section_twist * (pi/180);

num = max(size(section_distance_from_root));

numb_ident = strvcat('_1','_2','_3');


%------------------------
% POINTS definitions
%------------------------
for i = 1 : num,
    
    if i == 1,
        
        fprintf(fpc,' Points :\n');
        
        pt(i) = 0 ;                
        
        pt_1 = max(0.5*spinner_diameter-blade_root_lenght,0);
        point_definition ( fpc , strcat(pt_lifting_name(2,:),numb_ident(blade_index,:)) , [pt_1 0 0] , strcat('blade_root_frame',numb_ident(blade_index,:)));
        
        
    elseif i == num,
        
        pt(i) = section_distance_from_root(i) - (section_distance_from_root(i) - section_distance_from_root(i-1))/2;
        pt_1 = 0.5*rotor_diameter-blade_root_lenght;
        point_definition ( fpc , strcat(pt_lifting_name(1,:),numb_ident(blade_index,:)) , [pt_1 0 0] , strcat('blade_root_frame',numb_ident(blade_index,:)) );
        
        fprintf(fpc,' ;\n\n\n');
        
    else
        
        pt(i) = section_distance_from_root(i) - ((section_distance_from_root(i) - section_distance_from_root(i-1))/2);         
        
    end
    
end



%--------------------------------
% LIFTING LINE definitions
%--------------------------------
fprintf(fpc,' LiftingLines :\n');

if n_point_mass == 0,
    body_list=strcat('blade_1',numb_ident(blade_index,:));
elseif n_point_mass == 1,
    body_list=strcat('blade_1',numb_ident(blade_index,:),',','blade_2',numb_ident(blade_index,:));
elseif n_point_mass == 2,
    body_list=strcat('blade_1',numb_ident(blade_index,:),',','blade_2',numb_ident(blade_index,:),',','blade_3',numb_ident(blade_index,:));
elseif n_point_mass == 3,
    body_list=strcat('blade_1',numb_ident(blade_index,:),',','blade_2',numb_ident(blade_index,:),',','blade_3',numb_ident(blade_index,:),',','blade_4',numb_ident(blade_index,:));
end

lifting_line_definition ( fpc , strcat(lifting_line_name(1,:),numb_ident(blade_index,:)) , strcat(lifting_curve_name(1,:),numb_ident(blade_index,:)),...
    strcat(lifting_triad_name(1,:),numb_ident(blade_index,:)) , lifting_line_prop_name(1,:) ,...
   'EQUALLY_SPACED' , 100 , '2D_AIRFOIL' , body_list , 'y' , 1) ;
%     'GAUSS_POINTS' , round(0.3*num+1) , '2D_AIRFOIL' , body_list , 'y' , 1) ;

fprintf(fpc,' ; \n\n\n');



%-------------------------------
% CURVE definitions
%-------------------------------
fprintf(fpc,' Curves :\n');                         

for i = 1 : num,
    
    %    R_0 = rot_o(((-pi) - section_twist_rad(i)) * [ 1 ; 0 ; 0 ]);
    R_0 = rot_o(pi * [0;0;1] ) * rot_o( section_twist_rad (i) * [1;0;0] );  
    % ALE: 21.oct.05 with prebend
    % PREBEND ROTATION (y-rotation in the frame hub)
    % R_2 = rot_o( pre_bend_angle (i,2) * [0;1;0] );
    % e2(:,i) = R_2*R_0(:,2);
    % e3(:,i) = R_2*R_0(:,3);
    % ALEALE 12.nov.2009 REMOVED PRE-BENDING FOM LL
    % SINCE IT FOLLOWS THE CURVE OF THE BEAM!!

    e2(:,i) = R_0(:,2);
    e3(:,i) = R_0(:,3);
    
end

eta = fliplr((-[ section_distance_from_root/section_distance_from_root(end)]') + 1);

curve_definition( fpc , strcat(lifting_curve_name(1,:),numb_ident(blade_index,:)) , strcat('blade_root_frame',numb_ident(blade_index,:)), ...
    strcat(pt_lifting_name(1,:),numb_ident(blade_index,:)) , strcat(pt_lifting_name(2,:),numb_ident(blade_index,:)) , eta , fliplr(e2) , fliplr(e3) , 'n' );

fprintf(fpc,' ; \n\n\n');


%-------------------------------------
% Lifting Line PROPERTIES definition
%-------------------------------------

if blade_index == 1 ,
    
    % Send status #LS
    disp('  Writing Blade_Lifting_line_Properties.dat file.........')
    
    flp=fopen( strcat(dat_file_name(end,:),'\MB_model\Blade_Lifting_line_Properties.dat'),'w');
    
    name = lifting_line_prop_name(1,:);
    
    % This routine take into account a model whose topology
    % require that a portion of the blade is inside the spinner.
    if blade_root_lenght < spinner_diameter/2,
        i=1;
        while (pt(i)+blade_root_lenght) <= (spinner_diameter/2),
            airtables_names_temp0(i,:)=strvcat('spinner_airtable');
            i=i+1;  
        end
        airtables_names_temp1=airtable_names(i:end,:);
        airtables_names=strvcat(airtables_names_temp0,airtables_names_temp1);
        
    else
        airtables_names=airtable_names;
    end
    
    quarter_off_set =  (local_Ca - section_pitch_axis').*section_chord'/100;
    
    lifting_line_properties_definition( flp , 'y' , name , eta , flipud(section_chord) , fliplr(quarter_off_set) , fliplr(1-[ pt/pt_1 , 1 ]) , flipud([airtables_names(1:(max(size(pt))),:) ; airtables_names(max(size(pt)),:)]) , 'n' );
    
    fclose(flp);
    
end

%-------------------------------------
% Lifting Line TRAID definition
%-------------------------------------

triad_definition( fpc , 'y' , strcat(lifting_triad_name(1,:),numb_ident(blade_index,:)) , [ 0 1 0 ] , [ -1 0 0 ] , strcat('blade_root_frame',numb_ident(blade_index,:)));

fclose(fpc);
