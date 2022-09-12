function varargout = gui_removesubjects(varargin)
% GUI_REMOVESUBJECTS MATLAB code for gui_removesubjects.fig
%      GUI_REMOVESUBJECTS, by itself, creates a new GUI_REMOVESUBJECTS or raises the existing
%      singleton*.
%
%      H = GUI_REMOVESUBJECTS returns the handle to a new GUI_REMOVESUBJECTS or the handle to
%      the existing singleton*.
%
%      GUI_REMOVESUBJECTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_REMOVESUBJECTS.M with the given input arguments.
%
%      GUI_REMOVESUBJECTS('Property','Value',...) creates a new GUI_REMOVESUBJECTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_removesubjects_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_removesubjects_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_removesubjects

% Last Modified by GUIDE v2.5 24-Dec-2015 01:04:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_removesubjects_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_removesubjects_OutputFcn, ...
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



function gui_removesubjects_OpeningFcn(hObject, eventdata, handles, varargin)
%% --- Executes just before gui_removesubjects is made visible.

% Choose default command line output for gui_removesubjects
handles.output = hObject;
handles.BNCT = evalin('base','BNCT');
try
set(handles.removesubjects,'string',num2str(handles.BNCT.removesubjects));
catch
end
set(handles.uitable1,'Data',handles.BNCT.raw)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_removesubjects wait for user response (see UIRESUME)
% uiwait(handles.figure1);



function varargout = gui_removesubjects_OutputFcn(hObject, eventdata, handles) 
%% --- Outputs from this function are returned to the command line.

% Get default command line output from handles structure
varargout{1} = handles.output;



function cancel_Callback(hObject, eventdata, handles)
%% --- Executes on button press in cancel.
close;


function confirm_Callback(hObject, eventdata, handles)
%% --- Executes on button press in confirm.
subjects = get(handles.removesubjects,'string');
if ~isempty(subjects)
    %do stuff here
    handles.BNCT.removesubjects = str2num(subjects);
else
    handles.BNCT.removesubjects = [];
    msgbox('No subjects/files removed - using all data');
end
assignin('base','BNCT',handles.BNCT);
close;


function removesubjects_Callback(hObject, eventdata, handles)
%%



function removesubjects_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
