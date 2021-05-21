function varargout = select_element(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @select_element_OpeningFcn, ...
                   'gui_OutputFcn',  @select_element_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before select_element is made visible.
function select_element_OpeningFcn(hObject, eventdata, handles, varargin)

%names_def;
% FullPathWorkDir = varargin{1}.FullPathWorkDir;
%%%ALEALE 14.may.2008
handles.PathStruct = varargin{1}.PathStruct;
read_include_file(varargin{1}.PathStruct);

% Choose default command line output for select_element
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = select_element_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;

%--------------------------------------------------------------------
% --- EXECUTES WHEN PUSH PUSH_BUTTON_BLADE.
%--------------------------------------------------------------------
% In this section will be defined the BLADE element
function push_button_blade_Callback(hObject, eventdata, handles)

blade_guide(handles.PathStruct);

%-----------------------------------------------------------------------------
% --- EXECUTES ON BUTTON PRESS IN PUSH_BUTTON_HUB.
%------------------------------------------------------------------------------
% In  this section will be defined the HUB element
function push_button_hub_Callback(hObject, eventdata, handles)


disp(' ')
disp(' Writing Hub, DT & Generator models.......')

load names\dat_file_names

%disp('------HUB DEFITION----------------');
hub  =  read_hub_details(handles.PathStruct);
print_hub_dat_file( hub , dat_file_name, i );
    
%disp('------GENERATOR DEFINITION--------');
generator = read_generator_details(handles.PathStruct);
print_generator_and_drive_train_simple( generator , dat_file_name );
print_generator_and_drive_train_simple( generator , dat_file_name , 0 );

%disp('------ROTOR FRAME DEFINITION------');
fixed_frames(handles.PathStruct, hub , dat_file_name);
% rotor_frame(handles.PathStruct, hub , dat_file_name , 'n' );

% I create a routine printing standard beam shapes, to avoid possible
% copy/paste errors #LS
print_shape(dat_file_name);

% disp(' Applying standard shapes to blades and tower.........')
% [~, ~] = dos(strcat('copy .\routines\names\Shape.dat  .\',' ',dat_file_name(end,:),'\MB_model\Shape.dat'));

disp(' Done!')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             -TOWER-              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In this section will be defined the TOWER element
function push_button_tower_Callback(hObject, eventdata, handles)

tower_guide(handles.PathStruct);

%-----------------------------------------------------------------------------
% --- Executes on button press in push_button_sensors.
function push_button_to_define_Callback(hObject, eventdata, handles)


disp(' ')
disp(' Writing Sensors.......')

load names\dat_file_names;

%disp('------SENSORS DEFINITION----------');
print_NewSensorsNewBlade( dat_file_name , handles.PathStruct);

disp(' Done!')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          - ROTATION & PUSHBUTTON_ROTATION_WIND -            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in pushbutton_rotation_wind.
function pushbutton_rotation_wind_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_rotation_wind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp(' ')
disp(' Writing Rotation & Wind models.......')

load names\dat_file_names;

print_rigid_rotation(dat_file_name,handles.PathStruct);
print_windgrid(dat_file_name , handles.PathStruct);

disp('Done!')




% --- Executes on button press in pushbutton9. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           - POST PROCESSING -               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbutton9_Callback(hObject, eventdata, handles)
% Locate WTData.xls file
[filename, path, ~] = uigetfile('*.xlsx');


if filename ~= 0
    wtdata_fullpath = [path '\' filename];
else
    return
end
% Update WTData Excel file
UpdateWTDataFile(wtdata_fullpath,handles);



% close select_element;
% 
% PostProcess;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------ALL--------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in push_button_all.
function push_button_all_Callback(hObject, eventdata, handles)

% clc

disp(' ')
disp(' ')
disp(' Starting Full MB model creation.......')
disp(' ')

load names\dat_file_names

% Hub
%-------------------------------------------------------------------------
hub  =  read_hub_details(handles.PathStruct);
print_hub_dat_file( hub , dat_file_name);

% disp('------CPLambda FILE DEFINITION--------');
% print_wasp_file( hub, dat_file_name, handles.PathStruct );

% I create a routine printing standard beam shapes, to avoid possible
% copy/paste errors #LS
print_shape(dat_file_name);

% Rigid rotation
%-------------------------------------------------------------------------
print_rigid_rotation(dat_file_name,handles.PathStruct);


% Generator and drive train
%-------------------------------------------------------------------------
generator = read_generator_details(handles.PathStruct);
print_generator_and_drive_train_simple( generator , dat_file_name );
print_generator_and_drive_train_simple( generator , dat_file_name , 0 );


% Fixed frames
%-------------------------------------------------------------------------
fixed_frames(handles.PathStruct, hub , dat_file_name);
% rotor_frame(handles.PathStruct, hub , dat_file_name , 'n');
spinner_diameter  = hub.spinner_diameter;
blade_root_length = hub.root_radial_position;


% Tower, Nacelle & Controller
%-------------------------------------------------------------------------
% Modified so that the tower GUI is NOT launched #LS 20.03.2020

% Retrieve data
handles.tower = read_tower_details(handles.PathStruct);
handles.tower = tower_definition(handles.tower);

% Start printing
print_boundary_conditions(handles.tower.foundations,dat_file_name);

print_tower_dat_file ( handles.tower , dat_file_name);
print_tower_lifting_dat_file ( handles.tower.cd , handles.tower.npoint , handles.tower.height, handles.tower.nentries , ...
                               handles.tower.diameter , dat_file_name );

nacelle_npoint =   handles.tower.npoint + 1;

[hub] = read_hub_details(handles.PathStruct);

nacelle     =  read_nacelle(nacelle_npoint,handles.PathStruct);
print_nacelle_dat_file(nacelle , hub.tower_height , dat_file_name);

print_controller(nacelle.npoint, dat_file_name , handles.PathStruct);


% Rotor (Elastic, Inertial & Aerodynamic properties)
%-------------------------------------------------------------------------
% Modified so that the tower GUI is NOT launched #LS 20.03.2020

% Retrieve data 
handles = RetrieveDataForBladeGUI(handles,handles.PathStruct);


% Start printing
for i = 1 : handles.n_blade ,
    print_blade_dat_file( handles.point_mass.number , handles.multibody_blade , dat_file_name , i );
end

print_point_mass_dat_file(handles.point_mass , handles.blade.pitch_axis , handles.blade.distance_from_root , handles.blade.chord , dat_file_name , handles.n_blade );


local_Ca = define_local_Ca( handles.blade.thickness , handles.airfoil_reference , handles.blade.airfoil , handles.airfoil.name , handles.airfoil.reference);

PrintAirfoilTableDatFile( handles.airfoil , handles.blade.airfoil , handles.data_set_mach , handles.airfoil_reference , dat_file_name);

for i = 1 :handles.n_blade,
    print_lifting_line_dat_file ( i , handles.blade.distance_from_root , handles.blade.chord , handles.blade.twist , handles.blade.pitch_axis ,...
                                 handles.airfoil.reference , handles.blade.airfoil , local_Ca , handles.spinner_diameter , handles.blade_root_lenght , ...
                                 handles.point_mass.number , dat_file_name , handles.rotor_diameter, handles.blade.pre_bend_angle); 
end

print_inflow_model( max(handles.blade_root_lenght,0.5*handles.spinner_diameter),...
                    0.5*handles.rotor_diameter , dat_file_name , handles.n_blade );

% Sensors
%-------------------------------------------------------------------------
print_NewSensorsNewBlade( dat_file_name , handles.PathStruct);
           

% Wind Grid
%-------------------------------------------------------------------------
print_windgrid(dat_file_name , handles.PathStruct);

disp(' ')
disp('...MB model complete!')


% --- Executes on button press in pushbutton EXIT.
function pushbutton11_Callback(hObject, eventdata, handles)
close select_element;

fclose all;
close all;
clc;




% --- Executes on button press in pushbutton_rotor_inertia.
function pushbutton_rotor_inertia_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_rotor_inertia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rotor_inertia = ComputeRotorInertia(handles);


% --- Executes on button press in pushbutton_tower_clearance.
function pushbutton_tower_clearance_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_tower_clearance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ComputeTowerClearance(handles);
