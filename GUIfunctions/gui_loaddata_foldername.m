function varargout = gui_loaddata_foldername(varargin)
% GUI_LOADDATA_FOLDERNAME MATLAB code for gui_loaddata_foldername.fig
%      GUI_LOADDATA_FOLDERNAME, by itself, creates a new GUI_LOADDATA_FOLDERNAME or raises the existing
%      singleton*.
%
%      H = GUI_LOADDATA_FOLDERNAME returns the handle to a new GUI_LOADDATA_FOLDERNAME or the handle to
%      the existing singleton*.
%
%      GUI_LOADDATA_FOLDERNAME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_LOADDATA_FOLDERNAME.M with the given input arguments.
%
%      GUI_LOADDATA_FOLDERNAME('Property','Value',...) creates a new GUI_LOADDATA_FOLDERNAME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_loaddata_foldername_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_loaddata_foldername_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_loaddata_foldername

% Last Modified by GUIDE v2.5 25-Jan-2016 13:20:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_loaddata_foldername_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_loaddata_foldername_OutputFcn, ...
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


% --- Executes just before gui_loaddata_foldername is made visible.
function gui_loaddata_foldername_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_loaddata_foldername (see VARARGIN)

% Choose default command line output for gui_loaddata_foldername
handles.output = hObject;
handles.BNCT = evalin('base','BNCT');
try
    set(handles.filename,'string',handles.BNCT.datafolder);
    if strmatch(handles.BNCT.datafolder,strrep(handles.BNCT.configfilename.file,'.mat',''))
        set(handles.foldername,'enable','off');
        set(handles.use_old,'value',1);
    else
        set(handles.use_new,'value',1);
    end
catch
    set(handles.foldername,'enable','off');
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_loaddata_foldername wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_loaddata_foldername_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function contin_Callback(hObject, eventdata, handles)
%% --- Executes on button press in contin.
handles.BNCT.datafolder = handles.foldername;
assignin('base','BNCT',handles.BNCT);


function cancel_Callback(hObject, eventdata, handles)
%% --- Executes on button press in cancel.
close;


function use_old_Callback(hObject, eventdata, handles)
%% --- Executes on button press in use_old.
set(handles.foldername,'enable','off');
set(handles.use_new,'value',0);
set(handles.foldername,'string',strrep(handles.BNCT.configfilename.file,'.mat',''));
guidata(hObject, handles);


function use_new_Callback(hObject, eventdata, handles)
%% --- Executes on button press in use_new.
set(handles.foldername,'enable','on');
set(handles.use_old,'value',0);
guidata(hObject, handles);

function foldername_Callback(hObject, eventdata, handles)
%%



function foldername_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
