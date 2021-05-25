function varargout = set_work_dir(varargin)
% SET_WORK_DIR M-file for set_work_dir.fig
%      SET_WORK_DIR, by itself, creates a new SET_WORK_DIR or raises the existing
%      singleton*.
%
%      H = SET_WORK_DIR returns the handle to a new SET_WORK_DIR or the handle to
%      the existing singleton*.
%
%      SET_WORK_DIR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SET_WORK_DIR.M with the given input arguments.
%
%      SET_WORK_DIR('Property','Value',...) creates a new SET_WORK_DIR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before set_work_dir_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to set_work_dir_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help set_work_dir

% Last Modified by GUIDE v2.5 20-Mar-2020 09:48:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @set_work_dir_OpeningFcn, ...
                   'gui_OutputFcn',  @set_work_dir_OutputFcn, ...
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


% --- Executes just before set_work_dir is made visible.
function set_work_dir_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to set_work_dir (see VARARGIN)

% Pre-load the directory 'output' (#LS 19.03.2020)
handles.FullPathWorkDir = [ pwd '\output'];
set(handles.edit1,'String',handles.FullPathWorkDir);

% Choose default command line output for set_work_dir
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes set_work_dir wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = set_work_dir_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;


% Set default value
% handles.FullPathWorkDir = '.';%[];

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.FullPathWorkDir = get(hObject,'String');
% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% I check if the required output folder has an 'MB_Model' directory inside,
% otherwise I create it(#LS 19.03.2020)
ex_flag = exist([ handles.FullPathWorkDir '\MB_model']);

if ex_flag > 0
  
else 
    mkdir([handles.FullPathWorkDir '\MB_model']);
    
    % Inform the User that an MB_model folder has been created
    msgstr   = 'The MB_model folder was created in the required output directory.';
    msgtitle = 'Cp-Lambda Pre-Processor v5.41';
    
    h        =  questdlg(msgstr,msgtitle,'OK','OK');

    switch h
      case 'OK'
        % Continue to the subroutine finalization
      otherwise
        % Nothing
    end
end

% Close this dialogue box and go the input definition
close set_work_dir;

% ALEALE 14.may.2008
set_input_dir(handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Browse the required output folder #LS
selpath = uigetdir;

% If the selected path is inside the pwd, then show only the name of the
% folder. If not, show the whole path.
if selpath~=0
%     handles.FullPathWorkDir = strrep(selpath, [pwd '\'],'');
    handles.FullPathWorkDir = selpath;    
    set(handles.edit1,'String',handles.FullPathWorkDir);
    
    % Update handles structure
    guidata(hObject, handles);
end



