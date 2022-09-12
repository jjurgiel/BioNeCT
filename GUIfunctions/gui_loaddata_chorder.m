function varargout = gui_loaddata_chorder(varargin)
% GUI_LOADDATA_CHORDER MATLAB code for gui_loaddata_chorder.fig
%      GUI_LOADDATA_CHORDER, by itself, creates a new GUI_LOADDATA_CHORDER or raises the existing
%      singleton*.
%
%      H = GUI_LOADDATA_CHORDER returns the handle to a new GUI_LOADDATA_CHORDER or the handle to
%      the existing singleton*.
%
%      GUI_LOADDATA_CHORDER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_LOADDATA_CHORDER.M with the given input arguments.
%
%      GUI_LOADDATA_CHORDER('Property','Value',...) creates a new GUI_LOADDATA_CHORDER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_loaddata_chorder_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_loaddata_chorder_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_loaddata_chorder

% Last Modified by GUIDE v2.5 25-Jan-2016 13:32:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_loaddata_chorder_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_loaddata_chorder_OutputFcn, ...
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



function gui_loaddata_chorder_OpeningFcn(hObject, eventdata, handles, varargin)
%% --- Executes just before gui_loaddata_chorder is made visible.
handles.output = hObject;
handles.BNCT = evalin('base','BNCT');
try
    set(handles.filename,'string',handles.BNCT.datafolder);
    if strmatch(handles.BNCT.datafolder,strrep(handles.BNCT.configfilename.file,'.mat',''))
        set(handles.foldername,'enable','off');
        set(handles.use_oldfolder,'value',1);
    else
        set(handles.use_newfolder,'value',1);
    end
catch
    set(handles.foldername,'enable','off');
    set(handles.foldername,'string',strrep(handles.BNCT.configfilename.file,'.mat',''));
    set(handles.use_oldfolder,'value',1);
end
guidata(hObject, handles);

% UIWAIT makes gui_loaddata_chorder wait for user response (see UIRESUME)
% uiwait(handles.figure1);



function varargout = gui_loaddata_chorder_OutputFcn(hObject, eventdata, handles) 
%% --- Outputs from this function are returned to the command line.
varargout{1} = handles.output;



function use_original_Callback(hObject, eventdata, handles)
%% --- Executes on button press in use_original.
%chanord = evalin('base','chanord');
%chanord.method = 'orig';
handles.BNCT.chanord.method = 'orig';
handles.BNCT.datafolder = get(handles.foldername,'string');
%raw = evalin('base','raw');
EEG = pop_loadset(strcat(handles.BNCT.raw{1,1},'\',handles.BNCT.raw{1,2}));
[x_elec,y_elec] = topoplot2([],EEG.chanlocs,'electrodes','ptslabels');
handles.BNCT.chanord.orig.locs = [y_elec;x_elec]';
for numchan = 1:size(EEG.chanlocs,2)
    handles.BNCT.chanord.orig.labels{numchan,1} = EEG.chanlocs(numchan).labels;
end
assignin('base','BNCT',handles.BNCT);
%assignin('base','chanord',chanord);
assignin('base','runval',1);
close;

function use_new_Callback(hObject, eventdata, handles)
% % --- Executes on button press in use_new.
%chanord = evalin('base','chanord');
handles.BNCT.chanord.method = 'new';
handles.BNCT.datafolder = get(handles.foldername,'string');
assignin('base','BNCT',handles.BNCT);
%assignin('base','chanord',chanord);
close;

gui_definechanorder_popup;
uiwait;



function use_oldfolder_Callback(hObject, eventdata, handles)
%% --- Executes on button press in use_oldfolder.
set(handles.foldername,'enable','off');
set(handles.use_newfolder,'value',0);
set(handles.foldername,'string',strrep(handles.BNCT.configfilename.file,'.mat',''));
guidata(hObject, handles);


function use_newfolder_Callback(hObject, eventdata, handles)
%% --- Executes on button press in use_newfolder.
set(handles.foldername,'enable','on');
set(handles.use_oldfolder,'value',0);
guidata(hObject, handles);


function foldername_Callback(hObject, eventdata, handles)
%



function foldername_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
