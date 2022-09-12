function varargout = gui_defineclusters(varargin)
% GUI_DEFINECLUSTERS MATLAB code for gui_defineclusters.fig
%      GUI_DEFINECLUSTERS, by itself, creates a new GUI_DEFINECLUSTERS or raises the existing
%      singleton*.
%
%      H = GUI_DEFINECLUSTERS returns the handle to a new GUI_DEFINECLUSTERS or the handle to
%      the existing singleton*.
%
%      GUI_DEFINECLUSTERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_DEFINECLUSTERS.M with the given input arguments.
%
%      GUI_DEFINECLUSTERS('Property','Value',...) creates a new GUI_DEFINECLUSTERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_defineclusters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_defineclusters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_defineclusters

% Last Modified by GUIDE v2.5 23-Feb-2016 12:12:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_defineclusters_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_defineclusters_OutputFcn, ...
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


% --- Executes just before gui_defineclusters is made visible.
function gui_defineclusters_OpeningFcn(hObject, eventdata, handles, varargin)
%%
handles.output = hObject;
handles.BNCT = evalin('base','BNCT');
raw = handles.BNCT.raw;
EEG = pop_loadset(strcat(raw{1,1},'\',raw{1,2}));
handles.EEG = EEG;
% Update handles structure
axes(handles.axes1)
[x_elec,y_elec] = topoplot2([],EEG.chanlocs,'electrodes','ptslabels');

%Will have list of channels in each cluster
%Will have to match channels in each cluster with coherence chanord being
%used
try
    set(handles.list_cluster,'string',handles.BNCT.clustering.display);
    handles.clusterdisplay = handles.BNCT.clustering.display;
    handles.clusters = handles.BNCT.clustering.clusters;
    handles.clusternames = handles.BNCT.clustering.clusternames;
catch
end

guidata(hObject, handles);

% UIWAIT makes gui_defineclusters wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function varargout = gui_defineclusters_OutputFcn(hObject, eventdata, handles) 
%%

varargout{1} = handles.output;



function new_cluster_Callback(hObject, eventdata, handles)
%%

function new_cluster_CreateFcn(hObject, eventdata, handles)
%%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function list_cluster_Callback(hObject, eventdata, handles)
%%

function list_cluster_CreateFcn(hObject, eventdata, handles)
%%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function add_cluster_Callback(hObject, eventdata, handles)
%%
cluster = get(handles.new_cluster,'string');
cluster = strtrim(cluster); %remove lead/trail spaces
remain = cluster;
count = 1;
[tok_temp, remain] = strtok(remain,',');
remain = remain(2:end);
while ~isempty(remain)
    [tok{count}, remain] = strtok(remain,' ');
    count = count+1;
end
tok;

try
    handles.clusterdisplay = [handles.clusterdisplay; cluster];
    handles.clusters = [handles.clusters; {tok}];
    handles.clusternames = [handles.clusternames,;tok_temp];
catch
    handles.clusterdisplay = {cluster};
    handles.clusters = {tok};
    handles.clusternames = {tok_temp};
end
set(handles.list_cluster,'string',handles.clusterdisplay);
set(handles.new_cluster,'string',[]);
guidata(hObject, handles);
function remove_cluster_Callback(hObject, eventdata, handles)
%%
val = get(handles.list_cluster,'val');
handles.clusterdisplay(val) = [];
handles.clusters(val) = [];
handles.clusternames = [];
set(handles.list_cluster,'string',handles.clusterdisplay);
if val > size(handles.clusterdisplay,1)
    set(handles.list_cluster,'val',val-1);
    if val-1 == 0
        set(handles.list_cluster,'val',1);
    end
end

guidata(hObject, handles);
function finish_Callback(hObject, eventdata, handles)
%%
handles.BNCT.clustering.display = handles.clusterdisplay;
handles.BNCT.clustering.clusters = handles.clusters;
handles.BNCT.clustering.clusternames = handles.clusternames;
if ~isempty(handles.clusters)
    handles.BNCT.clustering.method = 1;
else 
    handles.BNCT.clustering.method = 0;
end
assignin('base','BNCT',handles.BNCT);
%gui_shortlongconnections(handles.clusters,handles.BNCT);
close