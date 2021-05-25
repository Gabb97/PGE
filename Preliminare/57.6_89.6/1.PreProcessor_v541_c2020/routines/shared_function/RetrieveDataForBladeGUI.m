function handles = RetrieveDataForBladeGUI(handles,PathStruct)

handles.blade             =  read_blade(PathStruct);
handles.point_mass        =  read_point_mass(handles.blade,PathStruct);

% % % Added by Ale 21.oct.05. Compute prebend angle
% % handles.blade.pre_bend_angle(1)=0;
% % for i=2:length(handles.blade.pre_bend)
% %     % ALEALE 12.nov.2009
% % %     handles.blade.pre_bend_angle(i,2) = atan( (handles.blade.pre_bend(i)-handles.blade.pre_bend(i-1)) / (handles.blade.distance_from_root(i)-handles.blade.distance_from_root(i-1) ) ) ;
% %     handles.blade.pre_bend_angle_OLD(i,1) = atan2( (handles.blade.pre_bend(i)-handles.blade.pre_bend(i-1)) , (handles.blade.distance_from_root(i)-handles.blade.distance_from_root(i-1) ) ) ;
% % end

% Added by Ale 16.oct.09. Compute prebend angle NEW with interp!!
% the old version was wrong since it inderestimate the real angle
for i=2:length(handles.blade.pre_bend)
    prebend_middle(i) = atan2( (handles.blade.pre_bend(i)-handles.blade.pre_bend(i-1)) , (handles.blade.distance_from_root(i)-handles.blade.distance_from_root(i-1) ) ) ;
    distance_middle(i) = handles.blade.distance_from_root(i-1)+0.5*(handles.blade.distance_from_root(i)-handles.blade.distance_from_root(i-1));
end
prebend_middle(end+1) = prebend_middle(end);
distance_middle(end+1) = handles.blade.distance_from_root(end);
handles.blade.pre_bend_angle = interp1(distance_middle,prebend_middle,handles.blade.distance_from_root,'pchip');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

handles.multibody_blade   =  blade_definition(handles.blade,PathStruct);
handles.airfoil           =  read_airfoil(PathStruct);
handles.airfoil_reference =  read_airfoil_reference(PathStruct);

% handles.data_set_mach     =  define_blade_section_arifoils_properties( handles.airfoil , handles.airfoil_reference , handles.blade.thickness , ...
%                                                                        handles.blade.airfoil );
% ALE 4.march.2006 NEW VERSION:
handles.data_set_mach     =  DefineBladeSectionArifoilsProperties( handles.airfoil , handles.airfoil_reference , handles.blade.thickness , ...
                                                                       handles.blade.airfoil );
handles.blade.total_mass  = calculate_total_mass( handles.blade.distance_from_root , handles.blade.mass_unit_length , 'y' , handles.point_mass.mass');



hub=read_hub_details(PathStruct);                                         % These statementes are necessary to define the spinner diameter
handles.spinner_diameter=hub.spinner_diameter;                % and the radial position of the blade root which will be used
handles.blade_root_lenght=hub.root_radial_position;           % during the blade lifting line definitions.
handles.rotor_diameter=hub.rotor_diameter;
handles.n_blade = hub.number_of_blades;

