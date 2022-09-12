function varargout = gui_batchsettings(varargin)
% GUI_BATCHSETTINGS MATLAB code for gui_batchsettings.fig
%      GUI_BATCHSETTINGS, by itself, creates a new GUI_BATCHSETTINGS or raises the existing
%      singleton*.
%
%      H = GUI_BATCHSETTINGS returns the handle to a new GUI_BATCHSETTINGS or the handle to
%      the existing singleton*.
%
%      GUI_BATCHSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_BATCHSETTINGS.M with the given input arguments.
%
%      GUI_BATCHSETTINGS('Property','Value',...) creates a new GUI_BATCHSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_batchsettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_batchsettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_batchsettings

% Last Modified by GUIDE v2.5 08-Feb-2016 13:07:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_batchsettings_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_batchsettings_OutputFcn, ...
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


% --- Executes just before gui_batchsettings is made visible.
function gui_batchsettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_batchsettings (see VARARGIN)

% Choose default command line output for gui_batchsettings
handles.output = hObject;
handles.BNCT = evalin('base','BNCT');
loadState(handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes when user attempts to close batchsettings.
function batchsettings_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to batchsettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

delete(hObject);



function loadState(handles)
try

%batch_chans = evalin('base','batch_chans');
set(handles.batch_chnlist,'string',handles.BNCT.config.batch_chans);%batch_chnlist);

%batch_percentdata = evalin('base','batch_percentdata');
set(handles.batch_percentdata,'string',handles.BNCT.config.batch_percentdata);

%freqrangelistraw = evalin('base','freqrangelistraw');
set(handles.freqrangelistraw,'string',handles.BNCT.config.freqrangelistraw);

%freqlabellistraw = evalin('base','freqlabellistraw');
set(handles.freqlabellistraw,'string',handles.BNCT.config.freqlabellistraw);

%tasklistraw = evalin('base','tasklistraw');
set(handles.tasklistraw,'string',handles.BNCT.config.tasklistraw);

%phenotypelistraw = evalin('base','phenotypelistraw');
set(handles.phenotypelistraw,'string',handles.BNCT.config.phenotypelistraw);

%batch_timerange = evalin('base','batch_timerange');
set(handles.timerangelistraw,'string',handles.BNCT.config.batch_timerange);

set(handles.aff,'string',handles.BNCT.config.condpositive);
catch
end
% --- Outputs from this function are returned to the command line.
function varargout = gui_batchsettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


function batch_savesettings_Callback(hObject, eventdata, handles)
%% --- Executes on button press in batch_savesettings.
handles.BNCT.config.freqrangelistraw = get(handles.freqrangelistraw,'string');
%batch_freqlabel = cellstr(get(handles.freqlabellistraw,'string'));
handles.BNCT.config.freqlabellistraw = cellstr(get(handles.freqlabellistraw,'string'));
handles.BNCT.config.tasklistraw = cellstr(get(handles.tasklistraw,'string'));
handles.BNCT.config.phenotypelistraw = cellstr(get(handles.phenotypelistraw,'string'));
handles.BNCT.config.batch_percentdata = str2num(get(handles.batch_percentdata,'string'));
handles.BNCT.config.batch_chans = get(handles.batch_chnlist,'string');
handles.BNCT.config.batch_chnlist = str2num(get(handles.batch_chnlist,'string'));
handles.BNCT.config.batch_timerange = cellstr(get(handles.timerangelistraw,'string'));
handles.BNCT.config.condpositive = get(handles.aff,'string');
assignin('base','BNCT',handles.BNCT);
%assignin('base','batch_freqrange',batch_freqrange);
%assignin('base','freqrangelistraw',batch_freqrange);
%assignin('base','tasklistraw',tasklistraw);
%assignin('base','freqlabellistraw',freqlabellistraw);
%assignin('base','batch_percentdata',batch_percentdata);
%assignin('base','batch_chnlist',batch_chnlist);
%assignin('base','batch_timerange',batch_timerange);
%assignin('base','batch_freqlabel',batch_freqlabel);
%assignin('base','phenotypelistraw',phenotypelistraw);
%assignin('base','batch_chans',batch_chans);
%assignin('base','runval',1);
%saveState(handles);
close



function batch_cancel_Callback(hObject, eventdata, handles)
%% --- Executes on button press in batch_cancel.
close



function gui_addtask_Callback(hObject, eventdata, handles)
%% --- Executes on button press in gui_addtask.
batch_taskname = get(handles.batch_taskname,'string');
if isempty(batch_taskname)
    msgbox('Warning: Missing Task entry!');
else
tasklistraw = cellstr(get(handles.tasklistraw,'String'));
numtasks = length(tasklistraw);
tasklistraw{numtasks+1,1} = batch_taskname;
set(handles.tasklistraw,'string',tasklistraw);
set(handles.tasklistraw,'value',length(tasklistraw));
set(handles.batch_taskname,'string',[]);
end



function gui_removetask_Callback(hObject, eventdata, handles)
%% --- Executes on button press in gui_removetask.
tasklistnum = get(handles.tasklistraw,'Value');
tasklistraw = get(handles.tasklistraw,'String');
tasklistraw(tasklistnum) = [];
set(handles.tasklistraw,'string',tasklistraw);
if tasklistnum > length(tasklistraw)
    tasklistnum = tasklistnum - 1;
end
set(handles.tasklistraw,'value',tasklistnum);
set(handles.batch_taskname,'string',[]);



function tasklistraw_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in tasklistraw.
tasklistnum = get(hObject,'Value');
tasklistraw = cellstr(get(hObject,'String'));
set(handles.batch_taskname,'string',tasklistraw{tasklistnum});


function tasklistraw_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function batch_taskname_Callback(hObject, eventdata, handles)
%%

function batch_taskname_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function freqrangelistraw_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in freqrangelistraw.
freqlistnum = get(hObject,'value');
freqrangelistraw = cellstr(get(hObject,'string'));
freqlabellistraw = cellstr(get(handles.freqlabellistraw,'string'));
set(handles.freqlabellistraw,'value',freqlistnum);
set(handles.batch_freqrange,'string',freqrangelistraw{freqlistnum});
set(handles.batch_freqlabel,'string',freqlabellistraw{freqlistnum});


function freqrangelistraw_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function batch_freqrange_Callback(hObject, eventdata, handles)
%%


function batch_freqrange_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in gui_addfreq.
function gui_addfreq_Callback(hObject, eventdata, handles)
% hObject    handle to gui_addfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
batch_freqrange = get(handles.batch_freqrange,'string');
batch_freqlabel = get(handles.batch_freqlabel,'string');
if isempty(batch_freqrange) || isempty(batch_freqlabel)
    msgbox('Warning: Missing frequency entry!');
else
freqrangelistraw = cellstr(get(handles.freqrangelistraw,'string'));
freqlabellistraw = cellstr(get(handles.freqlabellistraw,'string'));
numfreqs = length(freqrangelistraw);
freqrangelistraw{numfreqs+1,1} = batch_freqrange;
freqlabellistraw{numfreqs+1,1} = batch_freqlabel;
set(handles.freqrangelistraw,'string',freqrangelistraw);
set(handles.freqlabellistraw,'string',freqlabellistraw);
set(handles.freqrangelistraw,'value',length(freqrangelistraw));
set(handles.freqlabellistraw,'value',length(freqlabellistraw));
set(handles.batch_freqlabel,'string',[]);
set(handles.batch_freqrange,'string',[]);
end


function gui_removefreq_Callback(hObject, eventdata, handles)
%% --- Executes on button press in gui_removefreq.

freqlistnum = get(handles.freqrangelistraw,'Value');
freqrangelistraw = cellstr(get(handles.freqrangelistraw,'string'));
freqlabellistraw = cellstr(get(handles.freqlabellistraw,'string'));
freqrangelistraw(freqlistnum) = [];
freqlabellistraw(freqlistnum) = [];
set(handles.freqrangelistraw,'string',freqrangelistraw);
set(handles.freqlabellistraw,'string',freqlabellistraw);
if freqlistnum > length(freqrangelistraw)
    freqlistnum = freqlistnum - 1;
end
set(handles.freqrangelistraw,'value',freqlistnum);
set(handles.freqlabellistraw,'value',freqlistnum);
set(handles.batch_freqrange,'string',[]);
set(handles.batch_freqlabel,'string',[]);


function batch_freqlabel_Callback(hObject, eventdata, handles)
%%


function batch_freqlabel_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function freqlabellistraw_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in freqlabellistraw.
freqlistnum = get(hObject,'value');
freqlabellistraw = cellstr(get(hObject,'string'));
freqrangelistraw = cellstr(get(handles.freqrangelistraw,'string'));
set(handles.freqrangelistraw,'value',freqlistnum);
set(handles.batch_freqlabel,'string',freqlabellistraw{freqlistnum});
set(handles.batch_freqrange,'string',freqrangelistraw{freqlistnum});


function freqlabellistraw_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gui_editfreq_Callback(hObject, eventdata, handles)
%% --- Executes on button press in gui_editfreq.
batch_freqrange = get(handles.batch_freqrange,'string');
batch_freqlabel = get(handles.batch_freqlabel,'string');
freqrangelistraw = cellstr(get(handles.freqrangelistraw,'string'));
freqlabellistraw = cellstr(get(handles.freqlabellistraw,'string'));
freqlistnum = get(handles.freqrangelistraw,'Value');
freqrangelistraw{freqlistnum,1} = batch_freqrange;
freqlabellistraw{freqlistnum,1} = batch_freqlabel;
set(handles.freqrangelistraw,'string',freqrangelistraw);
set(handles.freqlabellistraw,'string',freqlabellistraw);
%set(handles.freqrangelistraw,'value',freqlistnum);
%set(handles.freqlabellistraw,'value',length(freqlabellistraw));


function gui_edittask_Callback(hObject, eventdata, handles)
%% --- Executes on button press in gui_edittask.
batch_taskname = get(handles.batch_taskname,'string');
tasklistraw = cellstr(get(handles.tasklistraw,'string'));
tasklistnum = get(handles.tasklistraw,'Value');
tasklistraw{tasklistnum,1} = batch_taskname;
set(handles.tasklistraw,'string',tasklistraw);
%set(handles.freqrangelistraw,'value',length(freqrangelistraw));
%set(handles.freqlabellistraw,'value',length(freqlabellistraw));



function gui_editpheno_Callback(hObject, eventdata, handles)
%% --- Executes on button press in gui_editpheno.
batch_phenotype = get(handles.batch_phenotype,'string');
phenotypelistraw = cellstr(get(handles.phenotypelistraw,'string'));
phenotypelistnum = get(handles.phenotypelistraw,'Value');
phenotypelistraw{phenotypelistnum,1} = batch_phenotype;
set(handles.phenotypelistraw,'string',phenotypelistraw);


function batch_phenotype_Callback(hObject, eventdata, handles)
%%

function batch_phenotype_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function phenotypelistraw_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in phenotypelistraw.
phenotypelistnum = get(hObject,'Value');
phenotypelistraw = cellstr(get(hObject,'String'));
set(handles.batch_phenotype,'string',phenotypelistraw{phenotypelistnum});


function phenotypelistraw_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gui_removepheno_Callback(hObject, eventdata, handles)
%% --- Executes on button press in gui_removepheno.
phenotypelistnum = get(handles.phenotypelistraw,'Value');
phenotypelistraw = get(handles.phenotypelistraw,'String');
phenotypelistraw(phenotypelistnum) = [];
set(handles.phenotypelistraw,'string',phenotypelistraw);
if phenotypelistnum > length(phenotypelistraw)
    phenotypelistnum = phenotypelistnum - 1;
end
set(handles.phenotypelistraw,'value',phenotypelistnum);
set(handles.batch_phenotype,'string',[]);


function gui_addpheno_Callback(hObject, eventdata, handles)
%% --- Executes on button press in gui_addpheno.
batch_phenotype = get(handles.batch_phenotype,'string');
if isempty(batch_phenotype)
    msgbox('Warning: Missing Task entry!');
else
phenotypelistraw = cellstr(get(handles.phenotypelistraw,'String'));
numphenotypes = length(phenotypelistraw);
phenotypelistraw{numphenotypes+1,1} = batch_phenotype;
set(handles.phenotypelistraw,'string',phenotypelistraw);
set(handles.phenotypelistraw,'value',length(phenotypelistraw));
set(handles.batch_phenotype,'string',[]);
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
    msgbox('Warning: Missing Task entry!');
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



function aff_Callback(hObject, eventdata, handles)
%%


% --- Executes during object creation, after setting all properties.
function aff_CreateFcn(hObject, eventdata, handles)
%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
