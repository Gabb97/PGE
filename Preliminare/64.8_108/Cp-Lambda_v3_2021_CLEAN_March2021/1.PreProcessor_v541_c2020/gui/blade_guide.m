function varargout = blade_guide(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @blade_guide_OpeningFcn, ...
                   'gui_OutputFcn',  @blade_guide_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before blade_guide is made visible.
function blade_guide_OpeningFcn(hObject, eventdata, handles, varargin)

%%%ALEALE 14.may.2008
PathStruct = varargin{1};
handles.PathStruct = PathStruct;

% Choose default command line output for blade_guide
disp(' ')
disp('------ Rotor Definition Panel ------------');
disp(' ')

handles.output            =  hObject;

% I put all the preliminary data-collection stages in a separate function,
% so that I can recall it when the 'Full Model' option is used #LS

handles = RetrieveDataForBladeGUI(handles,PathStruct);


% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = blade_guide_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
%varargout{1} = handles.output;  ATTENZIONE !!!!!! CAPIRE BENE COSA SUCCEDE
%IN QUESTA FASE DELLA FUNZIONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


% --- Executes on button press in VIEW_BLADE_PROP.
function view_blade_prop_Callback(hObject, eventdata, handles )

plot_blade_properties( handles.blade );


% --- Executes on button press in PRINT_BLADE_DAT_FILE.
function print_blade_dat_files_Callback(hObject, eventdata, handles)


disp(' ')
disp(' Writing rotor elastic model.......')

load names\dat_file_names;

for i = 1 : handles.n_blade ,
    print_blade_dat_file( handles.point_mass.number , handles.multibody_blade , dat_file_name , i );
end

print_point_mass_dat_file(handles.point_mass , handles.blade.pitch_axis , handles.blade.distance_from_root , handles.blade.chord , dat_file_name , handles.n_blade );
disp(' Done!')


% --- Executes on button press in PRINT_AERO_DAT_FILE.
function print_aero_dat_files_Callback(hObject, eventdata, handles)


disp(' ')
disp(' Writing rotor aerodynamic model.......')

load names\dat_file_names;

local_Ca = define_local_Ca( handles.blade.thickness , handles.airfoil_reference , handles.blade.airfoil , handles.airfoil.name , handles.airfoil.reference);

PrintAirfoilTableDatFile( handles.airfoil , handles.blade.airfoil , handles.data_set_mach , handles.airfoil_reference , dat_file_name);

for i = 1 :handles.n_blade,
    print_lifting_line_dat_file ( i , handles.blade.distance_from_root , handles.blade.chord , handles.blade.twist , handles.blade.pitch_axis ,...
                                 handles.airfoil.reference , handles.blade.airfoil , local_Ca , handles.spinner_diameter , handles.blade_root_lenght , ...
                                 handles.point_mass.number , dat_file_name , handles.rotor_diameter, handles.blade.pre_bend_angle); 
end

print_inflow_model( max(handles.blade_root_lenght,0.5*handles.spinner_diameter),0.5*handles.rotor_diameter , dat_file_name , handles.n_blade );

disp(' Done!')


% --- Executes on button press in VIEW_AERO_PROP.
function view_aero_prop_Callback(hObject, eventdata, handles)

local_Ca = define_local_Ca( handles.blade.thickness , handles.airfoil_reference , handles.blade.airfoil , handles.airfoil.name , handles.airfoil.reference);

plot_blade_aerodynamic(handles.blade.distance_from_root , handles.blade.chord , handles.blade.pitch_axis , local_Ca);

plot_airfoil_table( handles.airfoil_reference, handles.blade.airfoil, handles.data_set_mach  , handles.airfoil );


% close blade_guide


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% clc
close blade_guide
