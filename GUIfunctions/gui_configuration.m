function varargout = gui_configuration(varargin)
% GUI_CONFIGURATION MATLAB code for gui_configuration.fig
%      GUI_CONFIGURATION, by itself, creates a new GUI_CONFIGURATION or raises the existing
%      singleton*.
%
%      H = GUI_CONFIGURATION returns the handle to a new GUI_CONFIGURATION or the handle to
%      the existing singleton*.
%
%      GUI_CONFIGURATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CONFIGURATION.M with the given input arguments.
%
%      GUI_CONFIGURATION('Property','Value',...) creates a new GUI_CONFIGURATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_configuration_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_configuration_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_configuration

% Last Modified by GUIDE v2.5 08-Jul-2015 11:51:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_configuration_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_configuration_OutputFcn, ...
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


% --- Executes just before gui_configuration is made visible.
function gui_configuration_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_configuration (see VARARGIN)

% Choose default command line output for gui_configuration
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_configuration wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = gui_configuration_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function loadexisting_Callback(hObject, eventdata, handles)
%% --- Executes on button press in loadexisting.
[filename, pathname, filterindex] = uigetfile('*.mat', 'Choose Configuration File');
if filename == 0
else 
    warning off
    BNCT.configfilename.file = filename;
    BNCT.configfilename.path = pathname;
 %   configfile.filename = filename;
%    assignin('base','configfilename',filename);
    assignin('base','BNCT',BNCT);
    close(gui_configuration);
    run('gui_main');
 %   set(handles.cohbatchfile,'string',filename);
end

% --- Executes on button press in createnew.
function createnew_Callback(hObject, eventdata, handles)
% hObject    handle to createnew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gui_configuration);

%run('gui_config_filename');
run('gui_config_time');
