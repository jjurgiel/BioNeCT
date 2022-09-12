function varargout = gui_groupfeaturecomparison(varargin)
% GUI_GROUPFEATURECOMPARISON MATLAB code for gui_groupfeaturecomparison.fig
%      GUI_GROUPFEATURECOMPARISON, by itself, creates a new GUI_GROUPFEATURECOMPARISON or raises the existing
%      singleton*.
%
%      H = GUI_GROUPFEATURECOMPARISON returns the handle to a new GUI_GROUPFEATURECOMPARISON or the handle to
%      the existing singleton*.
%
%      GUI_GROUPFEATURECOMPARISON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_GROUPFEATURECOMPARISON.M with the given input arguments.
%
%      GUI_GROUPFEATURECOMPARISON('Property','Value',...) creates a new GUI_GROUPFEATURECOMPARISON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_groupfeaturecomparison_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_groupfeaturecomparison_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_groupfeaturecomparison

% Last Modified by GUIDE v2.5 17-Dec-2015 21:26:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_groupfeaturecomparison_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_groupfeaturecomparison_OutputFcn, ...
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



function gui_groupfeaturecomparison_OpeningFcn(hObject, eventdata, handles, varargin)
%% --- Executes just before gui_groupfeaturecomparison is made visible.

handles.BNCT = evalin('base','BNCT');
%try
handles.allfeatures = handles.BNCT.AllFeatures;%evalin('base','AllFeatures');
handles.featurenames = handles.BNCT.FeatureNames;%evalin('base','FeatureNames');
handles.topfeatures = handles.BNCT.TopFeatures;%evalin('base','TopFeatures');
handles.graphfeatures = handles.BNCT.graph_features;%evalin('base','graph_features');
handles.powerfeatures = handles.BNCT.power_features;%evalin('base','power_features');
handles.phenotypes = handles.BNCT.config.phenotypelistraw;%evalin('base','phenotypelistraw');
handles.tasks = handles.BNCT.config.tasklist;%evalin('base','tasklist');
handles.SubjectIDs = handles.BNCT.SubjectIDs;%evalin('base','SubjectIDs');
handles.freqs = handles.BNCT.config.freqlabellistraw;%evalin('base','freqlabellistraw');
handles.times = handles.BNCT.config.batch_timerange;%evalin('base','batch_timerange');
%dummy vars
handles.freqsel = 1;
handles.tasksel = 1;
handles.freqsel2 = 1;
handles.tasksel2 = 1;
handles.freqsel3 = 1;
handles.tasksel3 = 1;
handles.feature1sel = 1;
handles.feature2sel = 1;
handles.feature3sel = 1;
handles.datatest1 = [];
handles.datatest2 = [];
%catch
%end
%feature1 = ['Feature 1';handles.graphfeatures(:,2)];
%feature2 = ['Feature 2';handles.graphfeatures(:,2)];
%feature3 = ['Feature 3';handles.graphfeatures(:,2)];
%set(handles.feature1,'string',feature1);
%set(handles.feature2,'string',feature2);
%set(handles.feature3,'string',feature3);

task = ['Task';handles.tasks];
time = ['Time';handles.times];
freq = ['Frequency';handles.freqs];
set(handles.timeval,'string',time);
set(handles.taskval,'string',task);
set(handles.freqval,'string',freq);
set(handles.taskval2,'string',task);
set(handles.freqval2,'string',freq);
set(handles.taskval3,'string',task);
set(handles.freqval3,'string',freq);
% Update handles structure
%set(hObject,'WindowButtonMotionFcn',{@dataHover,handles});
set(hObject,'WindowButtonDownFcn',{@dataHover,handles});
handles.output = hObject;
guidata(hObject, handles);

% UIWAIT makes gui_groupfeaturecomparison wait for user response (see UIRESUME)
% uiwait(handles.figure1);



function varargout = gui_groupfeaturecomparison_OutputFcn(hObject, eventdata, handles) 
%% varargout  cell array for returning output args (see VARARGOUT);
% --- Outputs from this function are returned to the command line.

% Get default command line output from handles structure
varargout{1} = handles.output;



function updatePlot(hObject, eventdata, handles)
%%
%Check if all values have been specified
if handles.freqsel~=1 && handles.tasksel~=1 && handles.tasksel2~=1 && handles.freqsel2~=1 && handles.feature1sel~=1 && handles.feature2sel~=1
    for i = 1:size(handles.phenotypes,1)
        numsubjectsintask{i} = size(handles.SubjectIDs.(handles.phenotypes{i}).(handles.tasks{handles.tasksel-1}),1);
    end

axes(handles.axes1);
cla;
%get data
  datatest1 = handles.allfeatures.(handles.tasks{handles.tasksel-1}){1,handles.freqsel-1}(:,handles.feature1sel-1);
  datatest2 = handles.allfeatures.(handles.tasks{handles.tasksel2-1}){1,handles.freqsel2-1}(:,handles.feature2sel-1);
  featurename1 = handles.featurenames.(handles.tasks{handles.tasksel-1}){1,handles.freqsel-1}(handles.feature1sel-1);
  featurename2 = handles.featurenames.(handles.tasks{handles.tasksel2-1}){1,handles.freqsel2-1}(handles.feature2sel-1);
  if handles.feature3sel~=1
      datatest2 = handles.allfeatures.(handles.tasks{handles.tasksel-1}){1,handles.freqsel-1}(:,handles.feature2sel-1);
  end
 handles.datatest1 = datatest1;
 handles.datatest2 = datatest2;
  %plot data
 % for numsubjects = 1:size(numsubjectsintask,2)
    scatter(datatest1(1:numsubjectsintask{1}),datatest2(1:numsubjectsintask{1}),'MarkerEdgeColor','b','MarkerFaceColor','b','Marker','o')
    hold on
    scatter(datatest1(numsubjectsintask{1}+1:end),datatest2(numsubjectsintask{1}+1:end),'MarkerEdgeColor','r','MarkerFaceColor','r','Marker','o')
  xlabel(featurename1);
  ylabel(featurename2); 
    % end  
else
axes(handles.axes1);
cla;
xlabel([]);
ylabel([]);
handles.datatest1 = [];
handles.datatest2 = [];
end
guidata(hObject, handles);

function updatemenus1(hObject, eventdata, handles)
%% 1st data set
set(handles.feature1,'val',1)
handles.feature1sel = 1;
axes(handles.axes1);
cla;
xlabel([]);
ylabel([]);

if (handles.tasksel-1)~=0 && (handles.freqsel-1)~=0
        feature1 = ['Feature 1';handles.featurenames.(handles.tasks{handles.tasksel-1}){1,handles.freqsel-1}'];
        set(handles.feature1,'string',feature1);
else
    set(handles.feature1,'string','Feature 1');
end
guidata(hObject, handles);

function updatemenus2(hObject, eventdata, handles)
%% 2nd data set
set(handles.feature2,'val',1)
handles.feature2sel = 1;
axes(handles.axes1);
cla;
xlabel([]);
ylabel([]);

if (handles.tasksel2-1)~=0 && (handles.freqsel2-1)~=0
        feature2 = ['Feature 2';handles.featurenames.(handles.tasks{handles.tasksel2-1}){1,handles.freqsel2-1}'];
        set(handles.feature2,'string',feature2);
else
    set(handles.feature2,'string','Feature 2');
end
guidata(hObject, handles);

function updatemenus3(hObject, eventdata, handles)
%% 3rd data set
set(handles.feature3,'val',1)
handles.feature3sel = 1;
axes(handles.axes1);
cla;
xlabel([]);
ylabel([]);

if (handles.tasksel3-1)~=0 && (handles.freqsel3-1)~=0
        feature3 = ['Feature 3';handles.featurenames.(handles.tasks{handles.tasksel3-1}){1,handles.freqsel3-1}'];
        set(handles.feature3,'string',feature3);
else
    set(handles.feature3,'string','Feature 3');
end
guidata(hObject, handles);

function dataHover(hObject, eventdata, handles)
%axes(handles.axes1);
data = handles.datatest1;
if ~isempty(handles.datatest1)
 pos = get(gca,'CurrentPoint');
x1 = pos(1,1);
y1 = pos(1,2);
%[y1,x1] = ginput(1);

diffx = abs(handles.datatest1 - x1);
diffy = abs(handles.datatest2 - y1);

diffsum = diffx+diffy;

[minDiff, indexAtMin] = min(diffsum);
if minDiff < 0.03
%Chosen electrode
x_sel = x_elec(indexAtMin);
y_sel = y_elec(indexAtMin);
x=1;
end
end
 %{
diffx = abs(x_elec - x1);
diffy = abs(y_elec - y1);

diffsum = diffx+diffy;

[minDiff, indexAtMin] = min(diffsum);
%if minDiff < 0.03
%Chosen electrode
x_sel = x_elec(indexAtMin);
y_sel = y_elec(indexAtMin);
 x=1;
%}
function feature1_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in feature1.
handles.feature1sel = get(hObject,'val');
guidata(hObject, handles);
updatePlot(hObject, eventdata, handles);


function feature1_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function feature2_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in feature2.
handles.feature2sel = get(hObject,'val');
guidata(hObject, handles);
updatePlot(hObject, eventdata, handles);



function feature2_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function feature3_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in feature3.
handles.feature3sel = get(hObject,'val');
guidata(hObject, handles);
updatePlot(hObject, eventdata, handles);


function feature3_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function taskval_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in taskval.
handles.tasksel = get(hObject,'val');

guidata(hObject, handles);
updatemenus1(hObject, eventdata, handles)
%updatePlot(hObject, eventdata, handles);


function taskval_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function freqval_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in freqval.
handles.freqsel = get(hObject,'val');
guidata(hObject, handles);
updatemenus1(hObject, eventdata, handles)
%updatePlot(hObject, eventdata, handles);


function freqval_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function timeval_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in timeval.
handles.timesel = get(hObject,'val');
guidata(hObject, handles);
updatePlot(hObject, eventdata, handles);


function timeval_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function taskval2_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in taskval2.
handles.tasksel2 = get(hObject,'val');
guidata(hObject, handles);
updatemenus2(hObject, eventdata, handles)

function taskval2_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function freqval2_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in freqval2.
handles.freqsel2 = get(hObject,'val');
guidata(hObject, handles);
updatemenus2(hObject, eventdata, handles)



function freqval2_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function taskval3_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in taskval3.
handles.tasksel3 = get(hObject,'val');
guidata(hObject, handles);
updatemenus3(hObject, eventdata, handles)


function taskval3_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function freqval3_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in freqval3.
handles.freqsel3 = get(hObject,'val');
guidata(hObject, handles);
updatemenus3(hObject, eventdata, handles)



function freqval3_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function choosemethod_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in choosemethod.
handles.method = get(hObject,'val');

guidata(hObject, handles);
updatemenus(hObject,eventdata,handles);


function choosemethod_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
