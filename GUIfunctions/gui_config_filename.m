function varargout = gui_config_filename(varargin)
% GUI_CONFIG_FILENAME MATLAB code for gui_config_filename.fig
%      GUI_CONFIG_FILENAME, by itself, creates a new GUI_CONFIG_FILENAME or raises the existing
%      singleton*.
%
%      H = GUI_CONFIG_FILENAME returns the handle to a new GUI_CONFIG_FILENAME or the handle to
%      the existing singleton*.
%
%      GUI_CONFIG_FILENAME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CONFIG_FILENAME.M with the given input arguments.
%
%      GUI_CONFIG_FILENAME('Property','Value',...) creates a new GUI_CONFIG_FILENAME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_config_filename_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_config_filename_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_config_filename

% Last Modified by GUIDE v2.5 08-Jul-2015 12:45:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_config_filename_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_config_filename_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_config_filename is made visible.
function gui_config_filename_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_config_filename (see VARARGIN)

% Choose default command line output for gui_config_filename
handles.output = hObject;
loadState(handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_config_filename wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_config_filename_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function saveState(handles)
configfilename = evalin('base','configfilename');
%state.configfile = get(handles.configfile, 'string');
%save(configfile,'state')

function loadState(handles)
e = evalin('base','who');
if ismember('configfilename',e)
  configfilename = evalin('base','configfilename');
 % load(configfilename)
  set(handles.configfile, 'string', configfilename);
end


function configfile_Callback(hObject, eventdata, handles)
% hObject    handle to configfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of configfile as text
%        str2double(get(hObject,'String')) returns contents of configfile as a double


% --- Executes during object creation, after setting all properties.
function configfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to configfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in previous.
function previous_Callback(hObject, eventdata, handles)
% hObject    handle to previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(gui_config_filename);
run('gui_configuration');

% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
configfilename = get(handles.configfile,'string');
if length(configfilename) == 0 %|| ~strfind(configfilename,'.mat') || length(strrep(configfilename,'.mat',[])) == 0
    msgbox('Invalid File Name');
else
if strfind(configfilename,'.mat');
else
   configfilename = strcat(configfilename,'.mat');
end
if exist(configfilename) == 2
    warnuser = questdlg('Configuration file with same name already exists. Overwrite?', 'Warning','Yes');
switch warnuser
    case 'Yes';
        assignin('base','configfilename',configfilename)
        saveState(handles);
        close(gui_config_filename);
        run('gui_config_time');
    case 'No';
        return
    case 'Cancel';
        return
end
end
assignin('base','configfilename',configfilename)
saveState(handles);
close(gui_config_filename);
run('gui_config_time');
end
