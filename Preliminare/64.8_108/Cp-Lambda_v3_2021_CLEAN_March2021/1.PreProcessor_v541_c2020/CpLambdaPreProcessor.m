%==========================================================================
% This is version 5.41 of this program, made for the 2020 edition of the
% course on wind turbines design.
%
% Updates
% - 20.03.2020  -   Spanwise properties of blade, tower are now given along
%                   a nondimensional coordinate
%
%               -   The tower height can be specified in the second entry
%                   of the 'hub_details.txt' input file.
%
%               -   All GUIs have been restyled and given a better
%                   organization
%
%               -   Utilities to compute rotor inertia and tower clearance
%                   have been integrated into the main GUI. The computation
%                   of the tower clearance can now account for prebend
%
%               -   A new button in the main GUI allows to diretly update
%                   the WTData excel file
%
%               -   The 'Full Model' option has been re-programmed in order
%                   to actually create all the files in a single operation
%
%               -   The file Shape.dat is no longer copied but printed
%                   like any other *.dat file
% 
%==========================================================================

function varargout = CpLambdaPreProcessor(varargin)

% Go to the commandwindow to check output from the code #LS
commandwindow

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @CpLambdaPreProcessor_OpeningFcn, ...
    'gui_OutputFcn',  @CpLambdaPreProcessor_OutputFcn, ...
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

%-----------------------------------------------------
%-----EXECUTES JUST BEFORE "CpLambdaPreProcessor" IS MADE VISIBLE |
%-----------------------------------------------------
function CpLambdaPreProcessor_OpeningFcn(hObject, eventdata, handles, varargin)

% % % % % %%%% Commentare da qui in caso di compilazione **********************
if ~isdeployed
    clear functions;
    home
    % try
    %
    %      load blade_names;
    %
    % catch
    %
    disp('************** CP-Lambda Pre-Processor version 5.41 ****************');
    home_dir = pwd;
    
    addpath([pwd,'\graphics']);
    addpath([pwd,'\gui']);
    
    addpath([pwd,'\routines\names']);
    addpath([pwd,'\routines\shared_function']);
    addpath([pwd,'\routines\read']);
    addpath([pwd,'\routines\print']);
    addpath([pwd,'\routines\plot']);
    addpath([pwd,'\routines\post_processing']);
    
    %%%%%%addpath(genpath(pwd))
    %  end
end
% % % %% Commentare fino a  qui in caso di compilazione **********************

% warning_gift;

% Choose default command line output for CpLambdaPreProcessor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = CpLambdaPreProcessor_OutputFcn(hObject, eventdata, handles)
%cd figures
a=imread('graphics\DSCN6207.JPG');
image(a);
axis off;

text_course         = sprintf('Cp-Lambda PreProcessing Tool \nVersion 5.41 \nCourse on Wind Turbines Design, A.Y. 2020');
text_institution    = sprintf('Dept. of Aerospace Science and Technology \nPolitecnico di Milano \nMarch 2020');

ht = text(300,450,text_course,'FontSize',18,'FontWeight','Bold','Color','white');
ht = text(300,2000,text_institution,'FontSize',12,'FontWeight','Bold');

% Get default command line output from handles structure
%varargout{1} = handles.output;


% --- Executes on button press in CONTINUE.
function pushbutton1_Callback(hObject, eventdata, handles)
close CpLambdaPreProcessor
set_work_dir;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close CpLambdaPreProcessor
