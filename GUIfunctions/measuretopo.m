function varargout = measuretopo(varargin)
% MEASURETOPO MATLAB code for measuretopo.fig
%      MEASURETOPO, by itself, creates a new MEASURETOPO or raises the existing
%      singleton*.
%
%      H = MEASURETOPO returns the handle to a new MEASURETOPO or the handle to
%      the existing singleton*.
%
%      MEASURETOPO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MEASURETOPO.M with the given input arguments.
%
%      MEASURETOPO('Property','Value',...) creates a new MEASURETOPO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before measuretopo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to measuretopo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help measuretopo

% Last Modified by GUIDE v2.5 03-Dec-2015 14:32:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @measuretopo_OpeningFcn, ...
                   'gui_OutputFcn',  @measuretopo_OutputFcn, ...
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



function measuretopo_OpeningFcn(hObject, eventdata, handles, varargin)
%% --- Executes just before measuretopo is made visible.
handles.output = hObject;
EEG = pop_loadset(strcat(raw{1,1},'\',raw{1,2}));
%EEG = pop_loadset('986301-1dotMATCH-Correct1.set');
handles.EEG = EEG;
% Update handles structure

axes(handles.axes1)
[x_elec,y_elec] = topoplot2([],EEG.chanlocs,'electrodes','ptslabels');
guidata(hObject, handles);

% UIWAIT makes measuretopo wait for user response (see UIRESUME)
% uiwait(handles.figure1);



function varargout = measuretopo_OutputFcn(hObject, eventdata, handles) 
%% --- Outputs from this function are returned to the command line.
varargout{1} = handles.output;



function measurelist_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in measurelist.




function measurelist_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
