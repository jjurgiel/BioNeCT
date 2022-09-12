function varargout = gui_definechanorder_popup(varargin)
% GUI_DEFINECHANORDER_POPUP MATLAB code for gui_definechanorder_popup.fig
%      GUI_DEFINECHANORDER_POPUP, by itself, creates a new GUI_DEFINECHANORDER_POPUP or raises the existing
%      singleton*.
%
%      H = GUI_DEFINECHANORDER_POPUP returns the handle to a new GUI_DEFINECHANORDER_POPUP or the handle to
%      the existing singleton*.
%
%      GUI_DEFINECHANORDER_POPUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_DEFINECHANORDER_POPUP.M with the given input arguments.
%
%      GUI_DEFINECHANORDER_POPUP('Property','Value',...) creates a new GUI_DEFINECHANORDER_POPUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_definechanorder_popup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_definechanorder_popup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_definechanorder_popup

% Last Modified by GUIDE v2.5 23-Nov-2015 16:59:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_definechanorder_popup_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_definechanorder_popup_OutputFcn, ...
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


% --- Executes just before gui_definechanorder_popup is made visible.
function gui_definechanorder_popup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_definechanorder_popup (see VARARGIN)

% Choose default command line output for gui_definechanorder_popup
handles.output = hObject;
handles.BNCT = evalin('base','BNCT');
raw = handles.BNCT.raw;%evalin('base','raw');
EEG = pop_loadset(strcat(raw{1,1},'\',raw{1,2}));
%EEG = pop_loadset('986301-1dotMATCH-Correct1.set');
handles.EEG = EEG;
% Update handles structure
chanord = handles.BNCT.chanord;%evalin('base','chanord');

axes(handles.axes1)
[x_elec,y_elec] = topoplot2([],EEG.chanlocs,'electrodes','ptslabels');
chanord.orig.locs = [y_elec;x_elec]';
handles.x_elec = x_elec;
handles.y_elec = y_elec;
hold on
for numchan = 1:size(EEG.chanlocs,2)
    chanord.orig.labels{numchan,1} = EEG.chanlocs(numchan).labels;
end
handles.origchanord = chanord.orig.labels;
%try
    %chanord = evalin('base','chanord');
if ~isempty(chanord.new.labels)    
    for c = 1:size(x_elec,2)
        if strmatch(EEG.chanlocs(c).labels,chanord.new.labels)
            plot(y_elec(c),x_elec(c),'gd','MarkerSize',10)
        else
            plot(y_elec(c),x_elec(c),'rd','MarkerSize',10)
        end
    end
%    assignin('base','newchanord',chanord);
    set(handles.channelorder,'string',chanord.new.labels);
else
   % chanord = {};
    plot(y_elec,x_elec,'rd','MarkerSize',10)  
end

if size(chanord.new.labels,1) == size(chanord.orig.labels,1)
    set(handles.finish,'enable','on');
else
    set(handles.finish,'enable','off');
end
handles.BNCT.chanord = chanord;
assignin('base','BNCT',handles.BNCT);
%assignin('base','chanord',chanord);
set(hObject,'WindowButtonDownFcn',{@my_MouseClickFcn,handles});
%set(hObject,'WindowButtonUpFcn',{@my_MouseReleaseFcn,hObject});
handles.output = hObject;

guidata(hObject, handles);

function my_MouseClickFcn(hObject,eventdata,handles)%obj,event,hObject)
%[x_elec,y_elec] = topoplot2([],EEG.chanlocs,'electrodes','ptslabels');
x_elec = handles.x_elec;
y_elec = handles.y_elec;
EEG = handles.EEG;
handles.BNCT = evalin('base','BNCT');
chanord = handles.BNCT.chanord;%evalin('base','chanord');
chanord.method = 'new';
%newchanordlocs = evalin('base','newchanordlocs');
%newchanord = handles.newchanord;
pos = get(gca,'CurrentPoint');
y1 = pos(1,1);
x1 = pos(1,2);
%[y1,x1] = ginput(1);

diffx = abs(x_elec - x1);
diffy = abs(y_elec - y1);

diffsum = diffx+diffy;

[minDiff, indexAtMin] = min(diffsum);
if minDiff < 0.03
%Chosen electrode
x_sel = x_elec(indexAtMin);
y_sel = y_elec(indexAtMin);

hold on
%if ch is already in list, remove and mark red, else add & green
if strmatch(EEG.chanlocs(indexAtMin).labels,chanord.new.labels)
    plot(y_elec(indexAtMin),x_elec(indexAtMin),'rd','MarkerSize',10)
    [m,indexLabel]=ismember(EEG.chanlocs(indexAtMin).labels, chanord.new.labels);
    chanord.new.labels(indexLabel) = [];
    chanord.new.locs(indexLabel,:) = [];
else
    plot(y_elec(indexAtMin),x_elec(indexAtMin),'gd','MarkerSize',10)
    chanord.new.labels = [chanord.new.labels;EEG.chanlocs(indexAtMin).labels];
    newlocs_temp(1,1) = y_elec(indexAtMin);
    newlocs_temp(1,2) = x_elec(indexAtMin);
    chanord.new.locs = [chanord.new.locs;newlocs_temp];
end
handles.BNCT.chanord = chanord;
assignin('base','BNCT',handles.BNCT);
%assignin('base','chanord',chanord);
set(handles.channelorder,'string',chanord.new.labels);
%assignin('base','newchanord',newchanord);
%handles=guidata(hObject);
%set(handles.figure1,'WindowButtonMotionFcn',{@my_MouseMoveFcn,hObject});
guidata(hObject,handles)
else
end

if size(chanord.new.labels,1) == size(chanord.orig.labels,1)
    set(handles.finish,'enable','on');
else
    set(handles.finish,'enable','off');
end

% UIWAIT makes gui_definechanorder_popup wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_definechanorder_popup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% Get default command line output from handles structure
varargout{1} = handles.output;



function channelorder_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in channelorder.
% Hints: contents = cellstr(get(hObject,'String')) returns channelorder contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channelorder




function channelorder_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function axes1_ButtonDownFcn(hObject, eventdata, handles)
%% --- Executes on mouse press over axes background.

function remove_Callback(hObject, eventdata, handles)
%% --- Executes on button press in remove.
x_elec = handles.x_elec;
y_elec = handles.y_elec;
channelsel = get(handles.channelorder,'value');
handles.BNCT = evalin('base','BNCT');
chanord = handles.BNCT.chanord;%evalin('base','chanord');
EEG = handles.EEG;
%%%%%HERE TRYING TO RELABEL FROM CHANORD STRUCTURE%%%%%%%%%%
origchanord = handles.origchanord;
channel = chanord.new.labels{channelsel};
%newchanordlocs = evalin('base','newchanordlocs');
[x,indexch] = ismember(channel,chanord.orig.labels);
if indexch~=0
    plot(y_elec(indexch),x_elec(indexch),'rd','MarkerSize',10)   
end
chanord.new.labels(channelsel) = [];
chanord.new.locs(channelsel,:) = [];
%Remove locations
handles.BNCT.chanord = chanord;
assignin('base','BNCT',handles.BNCT);
%assignin('base','chanord',chanord);
set(handles.channelorder,'string',chanord.new.labels);
if channelsel > size(chanord.new.labels,1)
    set(handles.channelorder,'value',channelsel-1)
end
set(handles.finish,'enable','off');

guidata(hObject,handles)
function moveup_Callback(hObject, eventdata, handles)
%% --- Executes on button press in moveup.



function movedown_Callback(hObject, eventdata, handles)
%% --- Executes on button press in movedown.



function finish_Callback(hObject, eventdata, handles)
%% --- Executes on button press in finish.
close;
assignin('base','BNCT',handles.BNCT);
assignin('base','runval',1);


function usesetfile_Callback(hObject, eventdata, handles)
%% --- Executes on button press in usesetfile.
EEG = handles.EEG;
x_elec = handles.x_elec;
y_elec = handles.y_elec;
handles.BNCT = evalin('base','BNCT');
chanord = handles.BNCT.chanord;%evalin('base','chanord');

chanord.new.labels = chanord.orig.labels;
chanord.new.locs = chanord.orig.locs;
chanord.method = 'orig';

plot(y_elec,x_elec,'gd','MarkerSize',10)
set(handles.channelorder,'string',chanord.new.labels);
handles.BNCT.chanord = chanord;
assignin('base','BNCT',handles.BNCT);
%assignin('base','chanord',chanord);
set(handles.finish,'enable','on');
guidata(hObject,handles)


function clear_Callback(hObject, eventdata, handles)
%% --- Executes on button press in clear.
x_elec = handles.x_elec;
y_elec = handles.y_elec;
handles.BNCT = evalin('base','BNCT');
chanord = handles.BNCT.chanord;%evalin('base','chanord');
    chanord.new.labels = {};
    chanord.new.locs = [];
    plot(y_elec,x_elec,'rd','MarkerSize',10)
  handles.BNCT.chanord = chanord;  
    assignin('base','BNCT',handles.BNCT);
  %  assignin('base','chanord',chanord);
  
    set(handles.channelorder,'string',chanord.new.labels);
set(handles.finish,'enable','off');
guidata(hObject,handles)


function cancel_Callback(hObject, eventdata, handles)
% % --- Executes on button press in cancel.
assignin('base','runval',0);
close;

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
%
assignin('base','runval',0);
delete(hObject);
