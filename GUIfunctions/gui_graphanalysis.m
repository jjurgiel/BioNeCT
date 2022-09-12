function varargout = gui_graphanalysis(varargin)
% GUI_GRAPHANALYSIS MATLAB code for gui_graphanalysis.fig
%      GUI_GRAPHANALYSIS, by itself, creates a new GUI_GRAPHANALYSIS or raises the existing
%      singleton*.
%
%      H = GUI_GRAPHANALYSIS returns the handle to a new GUI_GRAPHANALYSIS or the handle to
%      the existing singleton*.
%
%      GUI_GRAPHANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_GRAPHANALYSIS.M with the given input arguments.
%
%      GUI_GRAPHANALYSIS('Property','Value',...) creates a new GUI_GRAPHANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_graphanalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_graphanalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_graphanalysis

% Last Modified by GUIDE v2.5 19-Jan-2016 16:10:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_graphanalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_graphanalysis_OutputFcn, ...
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


% --- Executes just before gui_graphanalysis is made visible.
function gui_graphanalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_graphanalysis (see VARARGIN)

% Choose default command line output for gui_graphanalysis
handles.output = hObject;
handles.BNCT = evalin('base','BNCT');
try
    set(handles.thrmethod,'val',handles.BNCT.threshold.settings.methodval);
    set(handles.thrhigh,'string',num2str(handles.BNCT.threshold.highx));
    set(handles.thrlow,'string',num2str(handles.BNCT.threshold.low));
    set(handles.binarize,'val',handles.BNCT.threshold.settings.binarize_val);
    set(handles.thr_avg,'val',handles.BNCT.threshold.settings.thr_avg_val);
    set(handles.thr_indiv,'val',handles.BNCT.threshold.settings.thr_indiv_val);
    set(handles.zscore_thr,'val',handles.BNCT.threshold.settings.zscore_thr_val);
    set(handles.thr_zscore,'val',handles.BNCT.threshold.settings.thr_zscore_val);
    
    if handles.BNCT.threshold.settings.thr_avg_val+handles.BNCT.threshold.settings.thr_indiv_val == 0
        set(handles.runall,'enable','off');
    end
catch
    set(handles.runall,'enable','off');
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_graphanalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_graphanalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in runall.
function runall_Callback(hObject, eventdata, handles)
% hObject    handle to runall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
thr_highx = str2num(get(handles.thrhigh,'string'));
thr_low = str2num(get(handles.thrlow,'string'));
thr_method = get(handles.thrmethod,'value');
handles.BNCT.threshold.settings.methodval = thr_method;
handles.BNCT.threshold.settings.binarize_val = get(handles.binarize,'value');
handles.BNCT.threshold.settings.zscore_thr_val = get(handles.zscore_thr,'value');
handles.BNCT.threshold.settings.thr_zscore_val = get(handles.thr_zscore,'value');
handles.BNCT.threshold.settings.thr_indiv_val = get(handles.thr_indiv,'value');
handles.BNCT.threshold.settings.thr_avg_val = get(handles.thr_avg,'value');
tasklistraw = handles.BNCT.config.tasklistraw;%evalin('base','tasklistraw');
freqlabellistraw = handles.BNCT.config.freqlabellistraw;%evalin('base','freqlabellistraw');
phenotypelistraw = handles.BNCT.config.phenotypelistraw;%evalin('base','phenotypelistraw');
numfreqs = length(freqlabellistraw);
alldata = handles.BNCT.alldata;%evalin('base','alldata');
raw = handles.BNCT.raw;%evalin('base','raw');
batch_timerange = handles.BNCT.config.batch_timerange;%evalin('base','batch_timerange');
numtimebins = size(batch_timerange,1);
% tasklist = {'1dot';'3dot';'5dot';'7dot'};
assignin('base','BNCT',handles.BNCT);
allmeasures = gui_allmeasures(handles.BNCT,alldata,raw,tasklistraw,numfreqs,numtimebins,thr_method,thr_highx,thr_low,phenotypelistraw);

handles.BNCT.allmeasures = allmeasures;
%assignin('base','allmeasures',allmeasures);
assignin('base','runval',1);
threshold.highx = thr_highx;
threshold.low = thr_low;
methods = cellstr(get(handles.thrmethod,'string'));
threshold.method = methods(thr_method);
%assignin('base','threshold',threshold);
handles.BNCT.threshold = threshold;
assignin('base','BNCT',handles.BNCT);
guidata(hObject, handles);
close


function thrlow_Callback(hObject, eventdata, handles)
%%



function thrlow_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thrmethod_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in thrmethod.
thrmethod = get(hObject,'value');
if thrmethod == 1
    set(handles.thrlow,'enable','off');

elseif thrmethod == 2
    set(handles.thrlow,'enable','on');

elseif thrmethod == 3
    set(handles.thrlow,'enable','off');
elseif thrmethod == 4
    set(handles.thrlow,'enable','on');
end
handles.BNCT.threshold.settings.methodval = thrmethod;
guidata(hObject, handles);



function thrmethod_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thrhigh_Callback(hObject, eventdata, handles)
%%



function thrhigh_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cancel_Callback(hObject, eventdata, handles)
%% --- Executes on button press in cancel.
assignin('base','runval',0);
close



function binarize_Callback(hObject, eventdata, handles)
%% --- Executes on button press in binarize.
handles.BNCT.thr.settings.binarize_val = get(hObject,'val');
if handles.BNCT.thr.settings.binarize_val == 1
    set(handles.zscore_thr,'enable','off');
    set(handles.thr_zscore,'enable','off');
    set(handles.thr_zscore,'val',0);
    set(handles.zscore_thr,'val',0);
    handles.BNCT.threshold.settings.thr_zscore_val = 0;
    handles.BNCT.threshold.settings.zscore_thr_val = 0;
else
    set(handles.zscore_thr,'enable','on');
    set(handles.thr_zscore,'enable','on');    
end
guidata(hObject, handles);


function thr_avg_Callback(hObject, eventdata, handles)
%% --- Executes on button press in thr_avg.
handles.BNCT.threshold.settings.thr_avg_val = get(hObject,'val');
handles.BNCT.threshold.settings.thr_indiv_val = 0;
set(handles.thr_indiv,'val',0);
if handles.BNCT.threshold.settings.thr_avg_val == 1
    set(handles.runall,'enable','on');
else
    set(handles.runall,'enable','off');
end
guidata(hObject, handles);


function thr_indiv_Callback(hObject, eventdata, handles)
%% --- Executes on button press in thr_indiv.
handles.BNCT.threshold.settings.thr_avg_val = 0;
handles.BNCT.threshold.settings.thr_indiv_val = get(hObject,'val');
set(handles.thr_avg,'val',0);
if handles.BNCT.threshold.settings.thr_indiv_val == 1
    set(handles.runall,'enable','on');
else
    set(handles.runall,'enable','off');
end
guidata(hObject, handles);


function zscore_thr_Callback(hObject, eventdata, handles)
%% --- Executes on button press in zscore_thr.
handles.BNCT.threshold.settings.zscore_thr_val = get(hObject,'val');
handles.BNCT.threshold.settings.thr_zscore_val = 0;
set(handles.thr_zscore,'val',0);
guidata(hObject, handles);

function thr_zscore_Callback(hObject, eventdata, handles)
%% --- Executes on button press in thr_zscore.
handles.BNCT.threshold.settings.thr_zscore_val = get(hObject,'val');
handles.BNCT.threshold.settings.zscore_thr_val = 0;
set(handles.zscore_thr,'val',0);
guidata(hObject, handles);
