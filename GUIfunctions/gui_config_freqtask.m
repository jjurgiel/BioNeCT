function varargout = gui_config_freqtask(varargin)
% GUI_CONFIG_FREQTASK MATLAB code for gui_config_freqtask.fig
%      GUI_CONFIG_FREQTASK, by itself, creates a new GUI_CONFIG_FREQTASK or raises the existing
%      singleton*.
%
%      H = GUI_CONFIG_FREQTASK returns the handle to a new GUI_CONFIG_FREQTASK or the handle to
%      the existing singleton*.
%
%      GUI_CONFIG_FREQTASK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CONFIG_FREQTASK.M with the given input arguments.
%
%      GUI_CONFIG_FREQTASK('Property','Value',...) creates a new GUI_CONFIG_FREQTASK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_config_freqtask_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_config_freqtask_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_config_freqtask

% Last Modified by GUIDE v2.5 08-Feb-2016 13:03:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_config_freqtask_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_config_freqtask_OutputFcn, ...
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


% --- Executes just before gui_config_freqtask is made visible.
function gui_config_freqtask_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_config_freqtask (see VARARGIN)

% Choose default command line output for gui_config_freqtask
handles.output = hObject;
%loadState(handles);
handles.BNCT = evalin('base','BNCT');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_config_freqtask wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_config_freqtask_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in gui_addtask.
function gui_addtask_Callback(hObject, eventdata, handles)
% hObject    handle to gui_addtask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
batch_taskname = get(handles.batch_taskname,'string');
if isempty(batch_taskname)
    msgbox('Warning: Missing Task entry!');
else
tasklistraw = cellstr(get(handles.tasklistraw,'String'));
%if isempty(cell2mat(tasklistraw))
if ~all(size(tasklistraw)) || isempty(tasklistraw{1})
    tasklistraw{1,1} = batch_taskname;
else
numtasks = length(tasklistraw);
tasklistraw{numtasks+1,1} = batch_taskname;
end
set(handles.tasklistraw,'string',tasklistraw);
set(handles.tasklistraw,'value',length(tasklistraw));
set(handles.batch_taskname,'string',[]);
end

% --- Executes on button press in gui_removetask.
function gui_removetask_Callback(hObject, eventdata, handles)
% hObject    handle to gui_removetask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tasklistnum = get(handles.tasklistraw,'Value');
tasklistraw = get(handles.tasklistraw,'String');
tasklistraw(tasklistnum) = [];
set(handles.tasklistraw,'string',tasklistraw);
if tasklistnum > length(tasklistraw)
    tasklistnum = tasklistnum - 1;
end
set(handles.tasklistraw,'value',tasklistnum);

% --- Executes on selection change in tasklistraw.
function tasklistraw_Callback(hObject, eventdata, handles)
% hObject    handle to tasklistraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tasklistraw contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tasklistraw
tasklistnum = get(hObject,'Value');
tasklistraw = cellstr(get(hObject,'String'));
set(handles.batch_taskname,'string',tasklistraw{tasklistnum});

% --- Executes during object creation, after setting all properties.
function tasklistraw_CreateFcn(hObject, eventdata, handles)
% 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function batch_taskname_Callback(hObject, eventdata, handles)
%


% --- Executes during object creation, after setting all properties.
function batch_taskname_CreateFcn(hObject, eventdata, handles)
%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in gui_edittask.
function gui_edittask_Callback(hObject, eventdata, handles)
% hObject    handle to gui_edittask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
batch_taskname = get(handles.batch_taskname,'string');
tasklistraw = cellstr(get(handles.tasklistraw,'string'));
tasklistnum = get(handles.tasklistraw,'Value');
tasklistraw{tasklistnum,1} = batch_taskname;
set(handles.tasklistraw,'string',tasklistraw);

% --- Executes on selection change in freqrangelistraw.
function freqrangelistraw_Callback(hObject, eventdata, handles)
%
freqlistnum = get(hObject,'value');
freqrangelistraw = cellstr(get(hObject,'string'));
freqlabellistraw = cellstr(get(handles.freqlabellistraw,'string'));
set(handles.freqlabellistraw,'value',freqlistnum);
set(handles.batch_freqrange,'string',freqrangelistraw{freqlistnum});
set(handles.batch_freqlabel,'string',freqlabellistraw{freqlistnum});

% --- Executes during object creation, after setting all properties.
function freqrangelistraw_CreateFcn(hObject, eventdata, handles)
%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function batch_freqrange_Callback(hObject, eventdata, handles)
%


% --- Executes during object creation, after setting all properties.
function batch_freqrange_CreateFcn(hObject, eventdata, handles)
%
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
if ~all(size(freqlabellistraw)) || isempty(freqlabellistraw{1})
    freqrangelistraw{1,1} = batch_freqrange;
    freqlabellistraw{1,1} = batch_freqlabel;
else
numfreqs = length(freqrangelistraw);
freqrangelistraw{numfreqs+1,1} = batch_freqrange;
freqlabellistraw{numfreqs+1,1} = batch_freqlabel;
end
set(handles.freqrangelistraw,'string',freqrangelistraw);
set(handles.freqlabellistraw,'string',freqlabellistraw);
set(handles.freqrangelistraw,'value',length(freqrangelistraw));
set(handles.freqlabellistraw,'value',length(freqlabellistraw));
set(handles.batch_freqrange,'string',[]);
set(handles.batch_freqlabel,'string',[]);
end

% --- Executes on button press in gui_removefreq.
function gui_removefreq_Callback(hObject, eventdata, handles)
% hObject    handle to gui_removefreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


function batch_freqlabel_Callback(hObject, eventdata, handles)
%


% --- Executes during object creation, after setting all properties.
function batch_freqlabel_CreateFcn(hObject, eventdata, handles)
%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in freqlabellistraw.
function freqlabellistraw_Callback(hObject, eventdata, handles)
%
freqlistnum = get(hObject,'value');
freqlabellistraw = cellstr(get(hObject,'string'));
freqrangelistraw = cellstr(get(handles.freqrangelistraw,'string'));
set(handles.freqrangelistraw,'value',freqlistnum);
set(handles.batch_freqlabel,'string',freqlabellistraw{freqlistnum});
set(handles.batch_freqrange,'string',freqrangelistraw{freqlistnum});

% --- Executes during object creation, after setting all properties.
function freqlabellistraw_CreateFcn(hObject, eventdata, handles)
%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in gui_editfreq.
function gui_editfreq_Callback(hObject, eventdata, handles)
% hObject    handle to gui_editfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
batch_freqrange = get(handles.batch_freqrange,'string');
batch_freqlabel = get(handles.batch_freqlabel,'string');
freqrangelistraw = cellstr(get(handles.freqrangelistraw,'string'));
freqlabellistraw = cellstr(get(handles.freqlabellistraw,'string'));
freqlistnum = get(handles.freqrangelistraw,'Value');
freqrangelistraw{freqlistnum,1} = batch_freqrange;
freqlabellistraw{freqlistnum,1} = batch_freqlabel;
set(handles.freqrangelistraw,'string',freqrangelistraw);
set(handles.freqlabellistraw,'string',freqlabellistraw);

% --- Executes on button press in previous.
function previous_Callback(hObject, eventdata, handles)
% hObject    handle to previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gui_config_freqtask);
%saveState(handles);
run('gui_config_time');


function next_Callback(hObject, eventdata, handles)
%% --- Executes on button press in next.
BNCT = handles.BNCT;
%batch_freqrange = get(handles.freqrangelistraw,'string');
BNCT.config.freqrangelistraw = get(handles.freqrangelistraw,'string');
%batch_freqlabel = cellstr(get(handles.freqlabellistraw,'string'));
BNCT.config.freqlabellistraw = cellstr(get(handles.freqlabellistraw,'string'));
BNCT.config.tasklistraw = cellstr(get(handles.tasklistraw,'string'));
BNCT.config.phenotypelistraw = cellstr(get(handles.phenotypelistraw,'string'));
BNCT.config.condpositive = get(handles.aff,'string');
assignin('base','BNCT',BNCT);
%assignin('base','freqrangelistraw',freqrangelistraw);
%assignin('base','tasklistraw',tasklistraw);
%assignin('base','freqlabellistraw',freqlabellistraw);
%assignin('base','phenotypelistraw',phenotypelistraw);
%assignin('base','batch_freqrange',freqrangelistraw);

%assignin('base','batch_freqlabel',batch_freqlabel);
[file,path] = uiputfile('*.mat','Save Your Analysis Settings');
if file ~= 0
	configfile = strcat(path,file);
    evalin('base', ['save(''', configfile ''')']);
    BNCT.configfilename.file = file;
    BNCT.configfilename.path = path;
    assignin('base','BNCT',BNCT);
    
    evalin('base','BNCT');
    save(configfile,'BNCT');
 %   evalin('base', ['save(''', configfile '','BNCT'')'])
   % assignin('base','configfilename',configfilename);
    close(gui_config_freqtask);
    run('gui_main'); %GUI_ADHD_SDRT
else
    msgbox('Invalid filename');
end


% --- Executes on button press in gui_editpheno.
function gui_editpheno_Callback(hObject, eventdata, handles)
% hObject    handle to gui_editpheno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
batch_phenotype = get(handles.batch_phenotype,'string');
phenotypelistraw = cellstr(get(handles.phenotypelistraw,'string'));
phenotypelistnum = get(handles.phenotypelistraw,'Value');
phenotypelistraw{phenotypelistnum,1} = batch_phenotype;
set(handles.tasklistraw,'string',phenotypelistraw);


function batch_phenotype_Callback(hObject, eventdata, handles)
%


% --- Executes during object creation, after setting all properties.
function batch_phenotype_CreateFcn(hObject, eventdata, handles)
%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in phenotypelistraw.
function phenotypelistraw_Callback(hObject, eventdata, handles)
%
phenotypelistnum = get(hObject,'Value');
phenotypelistraw = cellstr(get(hObject,'String'));
set(handles.batch_phenotype,'string',phenotypelistraw{phenotypelistnum});

% --- Executes during object creation, after setting all properties.
function phenotypelistraw_CreateFcn(hObject, eventdata, handles)
%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in gui_removepheno.
function gui_removepheno_Callback(hObject, eventdata, handles)
%
phenotypelistnum = get(handles.phenotypelistraw,'Value');
phenotypelistraw = get(handles.phenotypelistraw,'String');
phenotypelistraw(phenotypelistnum) = [];
set(handles.phenotypelistraw,'string',phenotypelistraw);
if phenotypelistnum > length(phenotypelistraw)
    phenotypelistnum = phenotypelistnum - 1;
end
set(handles.phenotypelistraw,'value',phenotypelistnum);

% --- Executes on button press in gui_addpheno.
function gui_addpheno_Callback(hObject, eventdata, handles)
%
batch_phenotype = get(handles.batch_phenotype,'string');
if isempty(batch_phenotype)
    msgbox('Warning: Missing Task entry!');
else
phenotypelistraw = cellstr(get(handles.phenotypelistraw,'String'));
if ~all(size(phenotypelistraw)) || isempty(phenotypelistraw{1})
%if isempty(cell2mat(phenotypelistraw))
    phenotypelistraw{1,1} = batch_phenotype;
else
numphenotypes = length(phenotypelistraw);
phenotypelistraw{numphenotypes+1,1} = batch_phenotype;
end
set(handles.phenotypelistraw,'string',phenotypelistraw);
set(handles.phenotypelistraw,'value',length(phenotypelistraw));
set(handles.batch_phenotype,'string',[]);
end



function aff_Callback(hObject, eventdata, handles)
%%



function aff_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
