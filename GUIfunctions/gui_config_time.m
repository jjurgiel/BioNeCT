function varargout = gui_config_time(varargin)
%% GUI_CONFIG_TIME MATLAB code for gui_config_time.fig
%      GUI_CONFIG_TIME, by itself, creates a new GUI_CONFIG_TIME or raises the existing
%      singleton*.
%
%      H = GUI_CONFIG_TIME returns the handle to a new GUI_CONFIG_TIME or the handle to
%      the existing singleton*.
%
%      GUI_CONFIG_TIME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CONFIG_TIME.M with the given input arguments.
%
%      GUI_CONFIG_TIME('Property','Value',...) creates a new GUI_CONFIG_TIME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_config_time_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_config_time_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_config_time

% Last Modified by GUIDE v2.5 08-Sep-2015 17:33:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_config_time_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_config_time_OutputFcn, ...
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


% --- Executes just before gui_config_time is made visible.
function gui_config_time_OpeningFcn(hObject, eventdata, handles, varargin)
%% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_config_time (see VARARGIN)

% Choose default command line output for gui_config_time
handles.output = hObject;
loadState(hObject, eventdata, handles);
% Update handles structure
guidata(hObject, handles);
axes(handles.axes1);
try
    imshow('gui_timebinsample.png');
catch
    set(handles.axes1,'visible','off');
end

% UIWAIT makes gui_config_time wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_config_time_OutputFcn(hObject, eventdata, handles)
%% varargout  cell array for returning output args (see VARARGOUT);

% Get default command line output from handles structure
varargout{1} = handles.output;

%function saveState(handles)
%%
%configfile = evalin('base','configfilename');
%{
state.batch_chnlist = get(handles.batch_chnlist, 'string');
state.batch_timebinsize = get(handles.batch_timebinsize, 'string');
state.batch_numtimebins = get(handles.batch_numtimebins, 'string');
state.batch_percentdata = get(handles.batch_percentdata, 'string');
state.batch_timestart = get(handles.batch_timestart, 'string');

save(configfile,'state')
%}
function loadState(hObject, eventdata, handles)
%fileName = evalin('base','configfilename');
%%

try
    BNCT = evalin('base','BNCT');
    handles.BNCT = BNCT;
  %  batch_chnlist = evalin('base','batch_chnlist'); 
    set(handles.batch_chnlist, 'string', BNCT.config.batch_chans);  
  
 %   batch_percentdata = evalin('base','batch_percentdata'); 
    set(handles.batch_percentdata, 'string', BNCT.config.batch_percentdata); 
  
  %  batch_timerange = evalin('base','batch_timerange');  
    set(handles.timerangelistraw, 'string', BNCT.config.batch_timerange);
    
catch
end
guidata(hObject, handles);


function batch_percentdata_Callback(hObject, eventdata, handles)
%%


function batch_percentdata_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function batch_chnlist_Callback(hObject, eventdata, handles)
%%


function batch_chnlist_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function previous_Callback(hObject, eventdata, handles)
%% --- Executes on button press in previous.
close(gui_config_time);
%saveState(handles);
run('gui_configuration');


function next_Callback(hObject, eventdata, handles)
%% --- Executes on button press in next.

batch_percentdata = get(handles.batch_percentdata,'string');
BNCT.config.batch_percentdata = str2num(batch_percentdata);
BNCT.config.batch_chans = get(handles.batch_chnlist,'string');
BNCT.config.batch_timerange = cellstr(get(handles.timerangelistraw,'string'));
BNCT.config.batch_chnlist = str2num(BNCT.config.batch_chans);
%epochsize = get(handles.epochsize,'string');
%if ~isempty(epochsize)
%    epochsize = str2num(epochsize);
%    maxtime = epochsize(2);
%end

%Add warning if one of timebins is over epoch size?
assignin('base','BNCT',BNCT);
%assignin('base','batch_percentdata',batch_percentdata);
%assignin('base','batch_chnlist',batch_chnlist);
%assignin('base','batch_chans',batch_chans);
%assignin('base','batch_timerange',batch_timerange);

close(gui_config_time);
run('gui_config_freqtask');



function loadfile_Callback(hObject, eventdata, handles)
%% --- Executes on button press in loadfile.
[file,path] = uigetfile('*.set','Load Sample EEG File');
if file ~=0
    eegfilename = strcat(path,file);
    EEG = pop_loadset(eegfilename);
    %evalin('base',['pop_loadset(''', eegfilename ''')']);
    %filename = strcat('Study Name: ',file);
    epochsize = mat2str([EEG.xmin EEG.xmax]);
    set(findobj('Tag','filename'),'String',EEG.filename)
    set(findobj('Tag','epochsize'),'string',epochsize);
    set(findobj('Tag','nbchan'),'string',EEG.nbchan);
end



function timerangelistraw_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in timerangelistraw.
timelistnum = get(hObject,'Value');
timerangelistraw = cellstr(get(hObject,'String'));
set(handles.batch_timerange,'string',timerangelistraw{timelistnum});


function timerangelistraw_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function batch_timerange_Callback(hObject, eventdata, handles)
%%


function batch_timerange_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function gui_edittime_Callback(hObject, eventdata, handles)
%% --- Executes on button press in gui_edittime.
batch_timerange = get(handles.batch_timerange,'string');
timerangelistraw = cellstr(get(handles.timerangelistraw,'string'));
timelistnum = get(handles.timerangelistraw,'Value');
timerangelistraw{timelistnum,1} = batch_timerange;
set(handles.timerangelistraw,'string',timerangelistraw);


function gui_removetime_Callback(hObject, eventdata, handles)
%% --- Executes on button press in gui_removetime.
timelistnum = get(handles.timerangelistraw,'Value');
timerangelistraw = get(handles.timerangelistraw,'String');
timerangelistraw(timelistnum) = [];
set(handles.timerangelistraw,'string',timerangelistraw);
if timelistnum > length(timerangelistraw)
    timelistnum = timelistnum - 1;
end
set(handles.timerangelistraw,'value',timelistnum);
set(handles.batch_timerange,'string',[]);


function gui_addtime_Callback(hObject, eventdata, handles)
%% --- Executes on button press in gui_addtime.
batch_timerange = get(handles.batch_timerange,'string');
if isempty(batch_timerange)
    msgbox('Warning: Missing Time entry!');
else
timerangelistraw = cellstr(get(handles.timerangelistraw,'String'));
%numtasks = length(timerangelistraw);
if ~all(size(timerangelistraw)) || isempty(timerangelistraw{1})
    timerangelistraw{1,1} = batch_timerange;
else
numtasks = length(timerangelistraw);
timerangelistraw{numtasks+1,1} = batch_timerange;
end
%timerangelistraw{numtasks+1,1} = batch_timerange;
set(handles.timerangelistraw,'string',timerangelistraw);
set(handles.timerangelistraw,'value',length(timerangelistraw));
set(handles.batch_timerange,'string',[]);
end


% --- Executes on key press with focus on batch_timerange and none of its controls.
function batch_timerange_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to batch_timerange (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
% add this part as an experiment and see what happens!
if strcmp(eventdata.Key,'return')
    gui_addtime_Callback(hObject, eventdata, handles)
    %Not working for some reason, addtime doesn't see batch_timerange
    %unless theres a break in between?
end
