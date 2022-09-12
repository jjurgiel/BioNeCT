function varargout = gui_multiplepowers(varargin)
%% GUI_MULTIPLEPOWERS MATLAB code for gui_multiplepowers.fig
%      GUI_MULTIPLEPOWERS, by itself, creates a new GUI_MULTIPLEPOWERS or raises the existing
%      singleton*.
%
%      H = GUI_MULTIPLEPOWERS returns the handle to a new GUI_MULTIPLEPOWERS or the handle to
%      the existing singleton*.
%
%      GUI_MULTIPLEPOWERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_MULTIPLEPOWERS.M with the given input arguments.
%
%      GUI_MULTIPLEPOWERS('Property','Value',...) creates a new GUI_MULTIPLEPOWERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_multiplepowers_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_multiplepowers_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_multiplepowers

% Last Modified by GUIDE v2.5 29-Sep-2015 11:20:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_multiplepowers_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_multiplepowers_OutputFcn, ...
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



function gui_multiplepowers_OpeningFcn(hObject, eventdata, handles, varargin)
%% --- Executes just before gui_multiplepowers is made visible.
% This function has no output args, see OutputFcn
% varargin   command line arguments to gui_multiplepowers (see VARARGIN)

% Choose default command line output for gui_multiplepowers
handles.output = hObject;
handles.BNCT = evalin('base','BNCT');
% Update handles structure

switch handles.BNCT.chanord.method
    case 'orig'
        channellist = handles.BNCT.chanord.orig.labels; 
        for i = 1:1:handles.BNCT.EEG.nbchan
       %  chnlabels{i} = strcat(num2str(batch_chnlist(i)),'-',handles.BNCT.EEG.chanlocs(1,i).labels);
            chnlabels{i} = strcat(num2str(i),'-',handles.BNCT.chanord.orig.labels{i,1});
        end
    case 'new'
        channellist = handles.BNCT.chanord.new.labels;
        for i = 1:1:handles.BNCT.EEG.nbchan
            chnlabels{i} = strcat(num2str(i),'-',handles.BNCT.chanord.new.labels{i,1});
        end
end
handles.chnlabels = chnlabels;
handles.channellist = channellist;
%chnlabels = evalin('base','chnlabels');
set(handles.chn,'string',chnlabels);
freqlistraw = handles.BNCT.config.freqrangelistraw;%evalin('base','freqrangelistraw');
set(handles.freq,'string',freqlistraw);
try %x = evalin('base','PowerFeatureNames');
    
    set(handles.powerlist,'string',handles.BNCT.PowerFeatureNames);
    PowerFeaturesTemp = handles.BNCT.CalcPowerFeatures;
   % PowerFeaturesTemp = evalin('base','CalcPowerFeatures');
   % PowerFeaturesTemp = {PowerFeaturesTemp};
    assignin('base','PowerFeaturesTemp',PowerFeaturesTemp);
    CalcPowerFeatures = handles.BNCT.CalcPowerFeatures;
   % CalcPowerFeatures = evalin('base','CalcPowerFeatures');
    set(handles.freq,'value',CalcPowerFeatures{1}(1));
    set(handles.time1,'string',num2str(CalcPowerFeatures{1}(4)));
    set(handles.time2,'string',num2str(CalcPowerFeatures{1}(5)));
    set(handles.chn,'value',CalcPowerFeatures{1}(6:end)');
    x=1;
catch
    PowerFeaturesTemp = [];
    assignin('base','PowerFeaturesTemp',PowerFeaturesTemp);
end
guidata(hObject, handles);


% UIWAIT makes gui_multiplepowers wait for user response (see UIRESUME)
% uiwait(handles.figure1);



function varargout = gui_multiplepowers_OutputFcn(hObject, eventdata, handles) 
%% --- Outputs from this function are returned to the command line.
%varargout  cell array for returning output args (see VARARGOUT);


% Get default command line output from handles structure
varargout{1} = handles.output;



function time2_Callback(hObject, eventdata, handles)
%%



function time2_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time1_Callback(hObject, eventdata, handles)
%%



function time1_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function freq_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in freq.



function freq_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function chn_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in chn.



function chn_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function confirm_Callback(hObject, eventdata, handles)
%% --- Executes on button press in confirm.
PowerFeaturesTemp = evalin('base','PowerFeaturesTemp');
if ~iscell(PowerFeaturesTemp)
    PowerFeaturesTemp = mat2cell(PowerFeaturesTemp);
end
handles.BNCT.CalcPowerFeatures = PowerFeaturesTemp;
handles.BNCT.PowerFeatureNames = cellstr(get(handles.powerlist,'string'));
assignin('base','BNCT',handles.BNCT);
%assignin('base','CalcPowerFeatures',PowerFeaturesTemp);
evalin('base',['clear ','PowerFeaturesTemp']);
%PowerFeatureNames = cellstr(get(handles.powerlist,'string'));
%assignin('base','PowerFeatureNames',PowerFeatureNames);
runval = 1;
assignin('base','runval',runval);

close;


function cancel_Callback(hObject, eventdata, handles)
%% --- Executes on button press in cancel.
assignin('base','runval',0);
close;


function powerlist_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in powerlist.
val = get(hObject,'value');
try
CalcPowerFeatures = evalin('base','PowerFeaturesTemp');
if ~iscell(CalcPowerFeatures)
    CalcPowerFeatures = mat2cell(CalcPowerFeatures);
end

    set(handles.freq,'value',CalcPowerFeatures{val}(1));
    set(handles.time1,'string',num2str(CalcPowerFeatures{val}(4)));
    set(handles.time2,'string',num2str(CalcPowerFeatures{val}(5)));
    set(handles.chn,'value',CalcPowerFeatures{val}(6:end)');
catch
end


function powerlist_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function add_Callback(hObject, eventdata, handles)
%% --- Executes on button press in add.
FreqList = cellstr(get(handles.freq,'string'));
FreqSel = get(handles.freq,'value');
ChnList = cellstr(get(handles.chn,'string'));
ChnSel = get(handles.chn,'value');
Time1 = get(handles.time1,'string');
Time2 = get(handles.time2,'string');

FreqStr = FreqList(FreqSel);
for i = 1:1:length(ChnSel);
   % ChnStr{i} = ChnList(ChnSel(i));
    ChannelStr{i} = handles.channellist{ChnSel(i)};
end

%for j = 1:1:length(ChnStr)
 %   ChannelStr(1,j) = ChnStr{j};
%end
ChannelStr = strcat(ChannelStr,',');
ChannelStr = cell2mat(ChannelStr);
%Channelstr = cellstr(cell2mat(ChnStr{:}));
TimeStr = strcat(Time1,'-',Time2);
newpower = strcat(FreqStr,',',ChannelStr,'Time-',TimeStr);
newpowervals = [FreqSel str2num(cell2mat(FreqStr)) str2double(Time1) str2double(Time2) ChnSel];

powerlist = get(handles.powerlist,'string');
PowerFeaturesTemp = evalin('base','PowerFeaturesTemp');
if isempty(powerlist)
    powerlist = newpower;
    PowerFeaturesTemp = {newpowervals};
else
    powerlist = [powerlist;[newpower]];
    PowerFeaturesTemp{end+1,1} = newpowervals;
end
if length(powerlist) == 1
    set(handles.powerlist,'value',1);
end
set(handles.powerlist,'string',powerlist);

%[graph_features power_features] = gui_featurematrix;

assignin('base','PowerFeaturesTemp',PowerFeaturesTemp);


function remove_Callback(hObject, eventdata, handles)
%% --- Executes on button press in remove.
powerlist = get(handles.powerlist,'string');
Sel = get(handles.powerlist,'value');
powerlist(Sel) = [];
PowerFeaturesTemp = evalin('base','PowerFeaturesTemp');
PowerFeaturesTemp(Sel,:) = [];
set(handles.powerlist,'string',powerlist);
if Sel > length(powerlist)
    Sel = Sel - 1;
    if Sel == 0
    Sel = 1;
    end
    set(handles.powerlist,'value',Sel);
end

assignin('base','PowerFeaturesTemp',PowerFeaturesTemp);



function edit_Callback(hObject, eventdata, handles)
%% --- Executes on button press in edit.
FreqList = cellstr(get(handles.freq,'string'));
FreqSel = get(handles.freq,'value');
ChnList = cellstr(get(handles.chn,'string'));
ChnSel = get(handles.chn,'value');
Time1 = get(handles.time1,'string');
Time2 = get(handles.time2,'string');


FreqStr = FreqList(FreqSel);
for i = 1:1:length(ChnSel);
    ChnStr{i} = ChnList(ChnSel(i));
end

for j = 1:1:length(ChnStr)
    ChannelStr(1,j) = ChnStr{j};
end
ChannelStr = strcat(ChannelStr,',');
ChannelStr = cell2mat(ChannelStr);
%Channelstr = cellstr(cell2mat(ChnStr{:}));
TimeStr = strcat(Time1,'-',Time2);
newpower = strcat(FreqStr,',',ChannelStr,'Time-',TimeStr);
newpowervals = [FreqSel str2num(cell2mat(FreqStr)) str2double(Time1) str2double(Time2) ChnSel];

powerlist = get(handles.powerlist,'string');
powerlist_val = get(handles.powerlist,'value');
PowerFeaturesTemp = evalin('base','PowerFeaturesTemp');
if isempty(powerlist)
    powerlist = newpower;
    PowerFeaturesTemp = {newpowervals};
else
    powerlist(powerlist_val) = [newpower];%[powerlist;[newpower]];
    PowerFeaturesTemp{powerlist_val,1} = newpowervals;
end
if length(powerlist) == 1
    set(handles.powerlist,'value',1);
end
set(handles.powerlist,'string',powerlist);

%[graph_features power_features] = gui_featurematrix;

assignin('base','PowerFeaturesTemp',PowerFeaturesTemp);

