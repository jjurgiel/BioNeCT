function varargout = gui_topfeatures_popup(varargin)
% GUI_TOPFEATURES_POPUP MATLAB code for gui_topfeatures_popup.fig
%      GUI_TOPFEATURES_POPUP, by itself, creates a new GUI_TOPFEATURES_POPUP or raises the existing
%      singleton*.
%
%      H = GUI_TOPFEATURES_POPUP returns the handle to a new GUI_TOPFEATURES_POPUP or the handle to
%      the existing singleton*.
%
%      GUI_TOPFEATURES_POPUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TOPFEATURES_POPUP.M with the given input arguments.
%
%      GUI_TOPFEATURES_POPUP('Property','Value',...) creates a new GUI_TOPFEATURES_POPUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_topfeatures_popup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_topfeatures_popup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_topfeatures_popup

% Last Modified by GUIDE v2.5 05-Oct-2015 15:01:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_topfeatures_popup_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_topfeatures_popup_OutputFcn, ...
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



function gui_topfeatures_popup_OpeningFcn(hObject, eventdata, handles, varargin)
%% --- Executes just before gui_topfeatures_popup is made visible.
handles.BNCT = evalin('base','BNCT');
tasklistraw = handles.BNCT.config.tasklistraw;%evalin('base','tasklistraw');
[tasklist] = gui_tasklist(tasklistraw);
freqrangelistraw = handles.BNCT.config.freqrangelistraw;%evalin('base','freqrangelistraw');
try
    TopFeatures = handles.BNCT.TopFeatures;%evalin('base','TopFeatures');
    selectionmethod = handles.BNCT.selectionmethod;%evalin('base','selectionmethod');
    switch selectionmethod
        case 'Single'
            features = [];
            for task = 1:1:length(tasklist)
                for freq = 1:1:length(freqrangelistraw)
                    features = [features;strcat('>Top Features for: Task-',tasklistraw{task},', Freq Range-',...
                        freqrangelistraw{freq});TopFeatures.Names.(tasklist{task}){1,freq}'];
                end
            end
        case 'Combo'
            features = [strcat('>Top Features for: Tasks-',', Frequency Ranges-'); TopFeatures.Names'];
        case 'Manual'
            FeatureNames = handles.BNCT.FeatureNames;%evalin('base','FeatureNames');
            features = ['>Selected Features:';FeatureNames'];
    end
    topfeatures = ['Selection Method:';selectionmethod;...
        'Selected Features/Top Features:';features];
    set(handles.topfeatures,'string',topfeatures);
catch
    msgbox('Error: Top Features not calculated');
end
% Choose default command line output for gui_topfeatures_popup
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_topfeatures_popup wait for user response (see UIRESUME)
% uiwait(handles.figure1);



function varargout = gui_topfeatures_popup_OutputFcn(hObject, eventdata, handles) 
%% --- Outputs from this function are returned to the command line.
varargout{1} = handles.output;



function topfeatures_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in topfeatures.



function topfeatures_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
