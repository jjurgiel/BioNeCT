function varargout = gui_forcefeatureset(varargin)
% GUI_FORCEFEATURESET MATLAB code for gui_forcefeatureset.fig
%      GUI_FORCEFEATURESET, by itself, creates a new GUI_FORCEFEATURESET or raises the existing
%      singleton*.
%
%      H = GUI_FORCEFEATURESET returns the handle to a new GUI_FORCEFEATURESET or the handle to
%      the existing singleton*.
%
%      GUI_FORCEFEATURESET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_FORCEFEATURESET.M with the given input arguments.
%
%      GUI_FORCEFEATURESET('Property','Value',...) creates a new GUI_FORCEFEATURESET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_forcefeatureset_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_forcefeatureset_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_forcefeatureset

% Last Modified by GUIDE v2.5 28-Jul-2015 12:47:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_forcefeatureset_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_forcefeatureset_OutputFcn, ...
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



function gui_forcefeatureset_OpeningFcn(hObject, eventdata, handles, varargin)
%% --- Executes just before gui_forcefeatureset is made visible.
% This function has no output args, see OutputFcn.
% varargin   command line arguments to gui_forcefeatureset (see VARARGIN)

% Choose default command line output for gui_forcefeatureset
handles.output = hObject;
handles.BNCT = evalin('base','BNCT');
% Update handles structure
guidata(hObject, handles);

[graph_features power_features] = gui_featurematrix;
%graph_features(~any(cell2mat(graph_features(:,1)),2),:) = [];
%power_features(~any(cell2mat(power_features(:,1)),2),:) = [];
features = [graph_features(:,2)];%;power_features(:,2)];
set(handles.Measure,'string',features);

tasklistraw = handles.BNCT.config.tasklistraw;%evalin('base','tasklistraw');
set(handles.Task,'string',tasklistraw);
freqlabellistraw = handles.BNCT.config.freqlabellistraw;%evalin('base','freqlabellistraw');
set(handles.Freq,'string',freqlabellistraw);
%timebins = evalin('base','batch_numtimebins');
%timebins = num2cell([1:1:timebins])';
batch_timerange = handles.BNCT.config.batch_timerange;%evalin('base','batch_timerange');
set(handles.Timebin,'string',batch_timerange);

MeasureList = cellstr(get(handles.Measure,'string'));
TaskList = cellstr(get(handles.Task,'string'));
FreqList = cellstr(get(handles.Freq,'string'));
TimeList = cellstr(get(handles.Timebin,'string'));

try %x = evalin('base','ForcedFeatures');
   ForcedFeatures = handles.BNCT.ForcedFeatures;%evalin('base','ForcedFeatures');
   for i = 1:1:size(ForcedFeatures,1)
    Features{i,1} = strcat(MeasureList{ForcedFeatures(i,1)},'|',TaskList{ForcedFeatures(i,2)},'|',FreqList{ForcedFeatures(i,3)},'|Timebin-',TimeList{ForcedFeatures(i,4)});
   end
   set(handles.features,'string',Features);
   ForcedFeaturesTemp = ForcedFeatures;
   assignin('base','ForcedFeaturesTemp',ForcedFeaturesTemp);
catch
   ForcedFeaturesTemp = [0 0 0 0];
   assignin('base','ForcedFeaturesTemp',ForcedFeaturesTemp);
   % set(handles.ForcedFeatures,'string',);
end

%POWER FEATURES
features2 = [power_features(:,2)];
set(handles.PowerMeasure,'string',features2)
set(handles.PowerTask,'string',tasklistraw);

try %y = evalin('base','PowerFeatureNames');
    PowerFeatureNames = handles.BNCT.PowerFeatureNames;%evalin('base','PowerFeatureNames');
    set(handles.PowerFreqTime,'string',PowerFeatureNames);
    set(handles.PowerMeasure,'enable','on');
    set(handles.PowerTask,'enable','on');
    set(handles.PowerFreqTime,'enable','on');
    set(handles.addpower,'enable','on');
    set(handles.removepower,'enable','on');
    set(handles.features2,'enable','on');
    set(handles.powerwarning,'visible','off');
catch
end

PowerList = cellstr(get(handles.PowerMeasure,'string'));
PowerFreqList = cellstr(get(handles.PowerFreqTime,'string'));
PowerTaskList = cellstr(get(handles.PowerTask,'string'));

try %y = evalin('base','PowerFeatures');
    PowerFeatures = handles.BNCT.PowerFeatures;%evalin('base','PowerFeatures');
    for i = 1:1:size(PowerFeatures,1)
        Features2{i,1} = strcat(PowerList{PowerFeatures(i,1)},'|',PowerTaskList{PowerFeatures(i,2)},'|',PowerFreqList{PowerFeatures(i,3)});
    end
    set(handles.features2,'string',Features2)
    PowerFeaturesTemp = PowerFeatures;
    assignin('base','PowerFeaturesTemp',PowerFeaturesTemp);
catch
        PowerFeaturesTemp = [0 0];
    assignin('base','PowerFeaturesTemp',PowerFeaturesTemp);
end

% UIWAIT makes gui_forcefeatureset wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_forcefeatureset_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);


% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in Measure.
function Measure_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Measure_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Task.
function Task_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Task_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Freq.
function Freq_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Freq_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Timebin.
function Timebin_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Timebin_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in features.
function features_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function features_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function add_Callback(hObject, eventdata, handles)
%% --- Executes on button press in add.
MeasureList = cellstr(get(handles.Measure,'string'));
MeasureSel = get(handles.Measure,'value');
TaskList = cellstr(get(handles.Task,'string'));
TaskSel = get(handles.Task,'value');
FreqList = cellstr(get(handles.Freq,'string'));
FreqSel = get(handles.Freq,'value');
TimeList = cellstr(get(handles.Timebin,'string'));
TimeSel = get(handles.Timebin,'value');

MeasureStr = MeasureList(MeasureSel);
TaskStr = TaskList(TaskSel);
FreqStr = FreqList(FreqSel);
TimeStr = TimeList(TimeSel);
newfeature = strcat(MeasureStr,'|',TaskStr,'|',FreqStr,'|Timebin-',TimeStr);
newfeaturevals = [MeasureSel TaskSel FreqSel TimeSel];

features = get(handles.features,'string');
ForcedFeaturesTemp = evalin('base','ForcedFeaturesTemp');

%CONCATENATE ADDED FEATURE WITH PREVIOUS SET
if isempty(features) %&& strcmp(features(1),'Feature')
    features = newfeature;
    ForcedFeaturesTemp = newfeaturevals;
else
   % numfeatures = length(features);
    features = [features;newfeature];
    ForcedFeaturesTemp = [ForcedFeaturesTemp;newfeaturevals];
end
if length(features) == 1
    set(handles.features,'value',1);
end
set(handles.features,'string',features);

[graph_features power_features] = gui_featurematrix;

%e = evalin('base','whos');
%featexist = ismember('ForcedFeatures',[e(:).name]);

%ForcedFeatures = get(handles.ForcedFeatures,'string');

assignin('base','ForcedFeaturesTemp',ForcedFeaturesTemp);


%assignin('base','ForcedFeatures',ForcedFeatures);
%set(handles.ForcedFeatures,'string',ForcedFeatures)


function remove_Callback(hObject, eventdata, handles)
%% --- Executes on button press in remove.

features = get(handles.features,'string');
Sel = get(handles.features,'value');
features(Sel) = [];
set(handles.features,'string',features);
if Sel > length(features)
    Sel = Sel - 1;
    set(handles.features,'value',Sel);
end

%try evalin('base','ForcedFeatures')
%    ForcedFeaturesTemp = evalin('base','ForcedFeaturesTemp');
%catch
%end
ForcedFeaturesTemp = evalin('base','ForcedFeaturesTemp');
if Sel == 0
    Sel = 1;
end
ForcedFeaturesTemp(Sel,:) = [];
assignin('base','ForcedFeaturesTemp',ForcedFeaturesTemp);
%assignin('base','ForcedFeaturesTemp',ForcedFeaturesTemp);



function confirm_Callback(hObject, eventdata, handles)
%% --- Executes on button press in confirm.
ForcedFeaturesTemp = evalin('base','ForcedFeaturesTemp');
handles.BNCT.ForcedFeatures = ForcedFeaturesTemp;
%assignin('base','ForcedFeatures',ForcedFeaturesTemp);
evalin('base',['clear ','ForcedFeaturesTemp']);
PowerFeaturesTemp = evalin('base','PowerFeaturesTemp');
handles.BNCT.PowerFeatures = PowerFeaturesTemp;
%assignin('base','PowerFeatures',PowerFeaturesTemp);
evalin('base',['clear ','PowerFeaturesTemp']);
handles.BNCT.selectionmethod = 'Manual';
assignin('base','BNCT',handles.BNCT);
runval = 1;
assignin('base','runval',runval);
%assignin('base','selectionmethod','Manual');
close;


function cancel_Callback(hObject, eventdata, handles)
%% --- Executes on button press in cancel.
evalin('base',['clear ','ForcedFeaturesTemp']);
evalin('base',['clear ','PowerFeaturesTemp']);
runval = 0;
assignin('base','runval',runval);
close;


% --- Executes on selection change in PowerMeasure.
function PowerMeasure_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function PowerMeasure_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PowerFreqTime.
function PowerFreqTime_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function PowerFreqTime_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function addpower_Callback(hObject, eventdata, handles)
%% --- Executes on button press in addpower.
PowerList = cellstr(get(handles.PowerMeasure,'string'));
PowerSel = get(handles.PowerMeasure,'value');
PowerFreqList = cellstr(get(handles.PowerFreqTime,'string'));
PowerFreqSel = get(handles.PowerFreqTime,'value');
PowerTaskList = get(handles.PowerTask,'string');
PowerTaskSel = get(handles.PowerTask,'value');

PowerStr = PowerList(PowerSel);
PowerFreqStr = PowerFreqList(PowerFreqSel);
PowerTaskStr = PowerTaskList(PowerTaskSel);

%PowerFeatureNames = evalin('base','PowerFeatureNames');
newfeature = strcat(PowerStr,'|',PowerTaskStr,'|',PowerFreqStr);
newfeaturevals = [PowerSel PowerTaskSel PowerFreqSel]; %Takes abs or rel + time/freq

features2 = get(handles.features2,'string');
PowerFeaturesTemp = evalin('base','PowerFeaturesTemp');
if isempty(features2) 
    features2 = newfeature;
    PowerFeaturesTemp = newfeaturevals;
else
    features2 = [features2;newfeature];
    PowerFeaturesTemp = [PowerFeaturesTemp;newfeaturevals];
end
if length(features2) == 1
    set(handles.features2,'value',1);
end
set(handles.features2,'string',features2);
%**********************making PowerFeatureNames appear in chosen list ^
%making PowerFeaturesTemp
[graph_features power_features] = gui_featurematrix;

assignin('base','PowerFeaturesTemp',PowerFeaturesTemp);


function removepower_Callback(hObject, eventdata, handles)
%% --- Executes on button press in removepower.
features2 = get(handles.features2,'string');
Sel = get(handles.features2,'value');
features2(Sel) = [];
set(handles.features2,'string',features2);
if Sel > length(features2)
    Sel = Sel - 1;
    set(handles.features2,'value',Sel);
end

%try evalin('base','ForcedFeatures')
%    ForcedFeaturesTemp = evalin('base','ForcedFeaturesTemp');
%catch
%end
PowerFeaturesTemp = evalin('base','PowerFeaturesTemp');
if Sel == 0
    Sel = 1;
end
PowerFeaturesTemp(Sel,:) = [];
assignin('base','PowerFeaturesTemp',PowerFeaturesTemp);

% --- Executes on selection change in features2.
function features2_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function features2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PowerTask.
function PowerTask_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function PowerTask_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
