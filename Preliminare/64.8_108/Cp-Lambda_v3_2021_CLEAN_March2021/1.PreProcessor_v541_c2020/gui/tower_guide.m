function varargout = tower_guide(varargin)

% TOWER_GUIDE M-file for tower_guide.fig
% Edit the above text to modify the response to help tower_guide
% Last Modified by GUIDE v2.5 20-Mar-2020 11:34:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tower_guide_OpeningFcn, ...
                   'gui_OutputFcn',  @tower_guide_OutputFcn, ...
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


% --- Executes just before tower_guide is made visible.
function tower_guide_OpeningFcn(hObject, eventdata, handles, varargin)


%%%ALEALE 14.may.2008
PathStruct = varargin{1};
handles.PathStruct = PathStruct;

% Choose default command line output for tower_guide
handles.output = hObject;

% I read back informations about hub and tower
handles.tower = read_tower_details(PathStruct);
handles.tower = tower_definition(handles.tower);

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = tower_guide_OutputFcn(hObject, eventdata, handles)
% a=imread('figures\LTW77.jpg');
%a=imread('graphics\OceanWindTurbines.jpg');
%image(a);
%axis off;


% Get default command line output from handles structure
varargout{1} = handles.output;

%----------------------------------------------------------
% --- Executes on button press in print_tower.
function print_tower_Callback(hObject, eventdata, handles)

%%%ALEALE 14.may.2008
PathStruct = handles.PathStruct;

disp(' ')
disp(' Writing tower model.......')


load names\dat_file_names;

%disp('------BOUNDARY DEFINITION-----------');
print_boundary_conditions(handles.tower.foundations,dat_file_name);

%disp('------TOWER DEFINITION------------');
print_tower_dat_file ( handles.tower , dat_file_name);
print_tower_lifting_dat_file ( handles.tower.cd , handles.tower.npoint , handles.tower.height, handles.tower.nentries , ...
                               handles.tower.diameter , dat_file_name );

nacelle_npoint =   handles.tower.npoint + 1;

%disp('------NACELLE DEFINITION----------');
% I need to recover the tower height berfore..
[hub] = read_hub_details(PathStruct);


nacelle     =  read_nacelle(nacelle_npoint,PathStruct);
print_nacelle_dat_file(nacelle , hub.tower_height , dat_file_name);

%disp('------CONTROLLER DEFINITION--------');
print_controller(nacelle.npoint, dat_file_name , handles.PathStruct);

disp(' Done!')


% --- Executes on button press in view Tower data.
 function pushbutton3_Callback(hObject, eventdata, handles)

plot_tower_properties(handles.tower);



% --- Executes on button press in all_tower.
function all_tower_Callback(hObject, eventdata, handles)
% In this case the function both plot and print tower properties



% % --- Executes on button press in EXIT.
% function EXIT_Callback(hObject, eventdata, handles)
% 
% close tower_guide;




% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close tower_guide;
