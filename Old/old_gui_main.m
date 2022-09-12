function varargout = old_gui_main(varargin)
% old_gui_main MATLAB code for old_gui_main.fig
%      old_gui_main, by itself, creates a new old_gui_main or raises the existing
%      singleton*.
%
%      H = old_gui_main returns the handle to a new old_gui_main or the handle to
%      the existing singleton*.
%
%      old_gui_main('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in old_gui_main.M with the given input arguments.
%
%      old_gui_main('Property','Value',...) creates a new old_gui_main or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before old_gui_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to old_gui_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help old_gui_main

% Last Modified by GUIDE v2.5 03-Sep-2015 13:52:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @old_gui_main_OpeningFcn, ...
                   'gui_OutputFcn',  @old_gui_main_OutputFcn, ...
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


% --- Executes just before old_gui_main is made visible.
function old_gui_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to old_gui_main (see VARARGIN)

% Choose default command line output for old_gui_main
handles.output = hObject;
loadState(handles);
% Update handles structure
%tasklist = {'dot1';'dot3';'dot5';'dot7'}; %TEMP
%assignin('base','tasklist',tasklist); %TEMP
guidata(hObject, handles);
%eeglab
configfilename = evalin('base','configfilename');
configname = strcat('Configuration Name: ',configfilename.file);
set(findobj('Tag','ConfigName'),'String',configname)


%global alldata;
% UIWAIT makes old_gui_main wait for user response (see UIRESUME)
% uiwait(handles.old_gui_main);


% --- Outputs from this function are returned to the command line.
function varargout = old_gui_main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%
% --- Executes when user attempts to close old_gui_main.
function gui_main_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to old_gui_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
warnuser = questdlg('Save workspace?', 'Warning','Yes');
switch warnuser
    case 'Yes';
        menu_saveanalysis_Callback(hObject, eventdata, handles)
      %  msgbox('Workspace variables saved!');
    case 'No';
    case 'Cancel';
        return
end
warnuser = questdlg('Save configuration?', 'Warning','Yes');
switch warnuser
    case 'Yes';
        saveState(handles)
        delete(hObject);
    case 'No';
        delete(hObject)
    case 'Cancel';
        return
end
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%      LOADING/SAVING CONFIGURATION          %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%Will need to make changes to how settings save for config file since
%%%%%%everything will be in seperate gui's now

%LOAD/SAVE CONFIGURATIONS/SETTINGS
function saveState(handles)
state.batchstr = get(handles.cohbatchfile, 'string');
%state.thrmethod = get(handles.thrmethod, 'value');
%state.thr_highx = get(handles.thrhigh, 'string');
%state.thr_low = get(handles.thrlow, 'string');
state.numsubjects = get(handles.numsubjects, 'string');
state.svmfolds = get(handles.svmfolds, 'string');
state.holdout = get(handles.holdout, 'string');
state.svmdimmethod = get(handles.svmdimmethod, 'value');
state.fishermerit = get(handles.fishermerit, 'value');
state.fishertopfeat = get(handles.fishertopfeat, 'string');
state.svm_tasklist = cellstr(get(handles.svm_tasklist,'string'));
state.svm_freqlist = cellstr(get(handles.svm_freqlist,'string'));
state.phenotypelistraw = evalin('base','phenotypelistraw');
%state.power_chnlist = cellstr(get(handles.power_chnlist,'string'));
%state.power_freqrange = cellstr(get(handles.power_freqrange,'string'));

%state.logfilename = get(handles.logfilename,'string');

configfilename = evalin('base','configfilename');
[file,path] = uiputfile('*.mat','Save As',configfilename.file);
if file ~= 0 
    configfilename.file = file;
    configfilename.path = path;
filename = strcat(path,file);
save(filename,'state');
assignin('base','configfilename',configfilename);
msgbox('Configuration saved!');
end

function loadState(handles)

fileName = evalin('base','configfilename');
if exist(fileName.file)
  load(strcat(fileName.path,'\',fileName.file))
  set(handles.cohbatchfile, 'string', state.batchstr);
 % set(handles.thrmethod, 'value', state.thrmethod);
 % set(handles.thrhigh, 'string', state.thr_highx);
 % set(handles.thrlow, 'string', state.thr_low);
  set(handles.numsubjects, 'string', state.numsubjects);
  set(handles.svmfolds, 'string', state.svmfolds);
  set(handles.holdout, 'string', state.holdout);
  set(handles.svmdimmethod, 'value', state.svmdimmethod);
  set(handles.fishermerit, 'value', state.fishermerit);
  set(handles.fishertopfeat, 'string', state.fishertopfeat); 
  set(handles.svm_tasklist, 'string', state.svm_tasklist);
  set(handles.svm_freqlist,'string',state.svm_freqlist);
  set(handles.fisher_tasklist,'string',state.svm_tasklist);
  set(handles.fisher_freqlist,'string',state.svm_freqlist);
  assignin('base','phenotypelistraw',state.phenotypelistraw);
end

% --- Executes on button press in newanalysis.
%function newanalysis_Callback(hObject, eventdata, handles)
% hObject    handle to newanalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%{
warnuser = questdlg('Save workspace?', 'Warning','Yes');
switch warnuser
    case 'Yes';
        saveworkspace_Callback(hObject, eventdata, handles)
      %  msgbox('Workspace variables saved!');
      %should eventually replace with clear bionect.struc or something
      evalin('base',['clear AllFeatures CalcPowerFeatures FeatureNames ForcedFeatures PowerFeatureNames PowerFeatures Results TopFeatures abs_power graph_features power_features rel_power SubjectIDs alldata allmeasures']);
    case 'No';
      evalin('base',['clear AllFeatures CalcPowerFeatures FeatureNames ForcedFeatures PowerFeatureNames PowerFeatures Results TopFeatures abs_power  graph_features power_features rel_power SubjectIDs alldata allmeasures']);

    case 'Cancel';
        return
end
%}
% --- Executes on button press in saveanalysis.
%function saveanalysis_Callback(hObject, eventdata, handles)
% hObject    handle to saveanalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%{
[file,path] = uiputfile('*.mat','Save As');
if file ~=0
workspacefilename = strcat(path,file);
evalin('base', ['save(''', workspacefilename ''')']);
analysisname = strcat('Study Name: ',file);
set(findobj('Tag','AnalysisName'),'String',analysisname)
msgbox('Study saved!');
end
%}
% --- Executes on button press in loadanalysis.
%function loadanalysis_Callback(hObject, eventdata, handles)
% hObject    handle to loadanalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%{
[file,path] = uigetfile('*.mat','Load Workspace File');
if file ~=0
workspacefilename = strcat(path,file);
evalin('base',['load(''', workspacefilename ''')']);
analysisname = strcat('Analysis Name: ',file);
set(findobj('Tag','AnalysisName'),'String',analysisname)
msgbox('Study loaded!');
end
%}
%load(file);
%load(workspacefilename);
% --- Executes on button press in saveconfig.
%function saveconfig_Callback(hObject, eventdata, handles)
% hObject    handle to saveconfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(findobj('Tag','ConfigName'),'String',configfilename)
%saveState(handles);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%        BATCH COHERENCE PROCESSING          %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in findfile.
%function findfile_Callback(hObject, eventdata, handles)
% hObject    handle to findfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%{
batchfile = get(handles.cohbatchfile,'string');
[filename, pathname, filterindex] = uigetfile;
if filename == 0
    set(handles.cohbatchfile,'string',batchfile)
else 
    set(handles.cohbatchfile,'string',filename);
end
%}
% --- Executes on button press in RunBatchCoh.
%function RunBatchCoh_Callback(hObject, eventdata, handles)
% hObject    handle to RunBatchCoh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%{
batchfile = get(handles.cohbatchfile,'string');
batch_freqrange = evalin('base','batch_freqrange');
batch_percentdata = evalin('base','batch_percentdata');
batch_chnlist = evalin('base','batch_chnlist');
batch_timebinsize = evalin('base','batch_timebinsize');
batch_timestart = evalin('base','batch_timestart');
batch_numtimebins = evalin('base','batch_numtimebins');

warnuser = questdlg('Coherence batch processing may take up to several hours. It may also overwrite existing files. Continue?', 'Warning','Yes');
switch warnuser
    case 'Yes';
    case 'No';
        return
    case 'Cancel';
        return
end

%WILL NEED TO ADD NUMTIMEBINS AS INPUT EVENTUALLY
gui_batch_spec_coh_plot_partial_elec(batchfile,batch_percentdata,batch_chnlist,batch_timebinsize,batch_freqrange,batch_timestart,batch_numtimebins)
msgbox('Batch coherence processing complete!');
%}
% --- Executes on button press in batch_settings.
%function batch_settings_Callback(hObject, eventdata, handles)
% hObject    handle to batch_settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%{
gui_batchsettings
uiwait

%this ping if cancel is hit on first run in batch settings instead of save
freqlabellistraw = evalin('base','freqlabellistraw');
freqrangelistraw = evalin('base','freqrangelistraw');
tasklistraw = evalin('base','tasklistraw');
batch_chnlist = evalin('base','batch_chnlist');
set(handles.svm_freqlist,'string',freqlabellistraw);
set(handles.svm_tasklist,'string',tasklistraw);
%set(handles.power_freqrange,'string',freqrangelistraw);
set(handles.fisher_tasklist,'string',tasklistraw);
set(handles.fisher_freqlist,'string',freqlabellistraw);
%for i = 1:1:27
%     chnlabels{i} = strcat(num2str(batch_chnlist(i)),'-',EEG.chanlocs(1,i).labels);
%end

%set(handles.power_chnlist,'string',num2cell(batch_chnlist'));
%set(handles.power_chnlist,'string',chnlabels);
%}


function cohbatchfile_Callback(hObject, eventdata, handles)
% hObject    handle to cohbatchfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cohbatchfile as text
%        str2double(get(hObject,'String')) returns contents of cohbatchfile as a double


% --- Executes during object creation, after setting all properties.
function cohbatchfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cohbatchfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%{
function measurebatch_Callback(hObject, eventdata, handles)
% hObject    handle to measurebatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of measurebatch as text
%        str2double(get(hObject,'String')) returns contents of measurebatch as a double


% --- Executes during object creation, after setting all properties.
function measurebatch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measurebatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%          LOADING COHERENCE DATA            %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in loaddata.
%function loaddata_Callback(hObject, eventdata, handles)
% hObject    handle to loaddata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%{
batchfile = get(handles.cohbatchfile,'string');
tasklistraw = evalin('base','tasklistraw');
phenotypelistraw = evalin('base','phenotypelistraw');
disp('Loading data...');
[alldata, raw, SubjectIDs, Missing] = gui_loaddata(batchfile,tasklistraw,phenotypelistraw);
prog = strcat('Data loaded for (',num2str(size(raw,1)),') instances!');
disp(prog);
msgbox('Data loaded!');
assignin('base','alldata',alldata);
assignin('base','raw',raw);
assignin('base','SubjectIDs',SubjectIDs);
assignin('base','Missing',Missing);
%handles.alldata = alldata;
%handles.raw = raw;

batch_chnlist = evalin('base','batch_chnlist');
disp('Loading sample data file for channel labels...');
EEG = pop_loadset(strcat(raw{1,1},'\',raw{1,2}));
for i = 1:1:EEG.nbchan
     chnlabels{i} = strcat(num2str(batch_chnlist(i)),'-',EEG.chanlocs(1,i).labels);
end
%set(handles.power_chnlist,'string',chnlabels);
assignin('base','chnlabels',chnlabels);
set(findobj('Tag','Status'),'String','Status: Data Loaded!')
guidata(hObject,handles);
%}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%     GRAPH THEORY MEASURE CALCULATIONS      %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
% --- Executes on selection change in thrmethod.
function thrmethod_Callback(hObject, eventdata, handles)
% hObject    handle to thrmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns thrmethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from thrmethod
thrmethod = get(hObject,'value');
if thrmethod == 1
    set(handles.thrlow,'enable','off');

elseif thrmethod == 2
    set(handles.thrlow,'enable','on');

end

% --- Executes on button press in runall.
function runall_Callback(hObject, eventdata, handles)
% hObject    handle to runall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

thr_highx = str2num(get(handles.thrhigh,'string'));
thr_low = str2num(get(handles.thrlow,'string'));
thr_method = get(handles.thrmethod,'value');
tasklistraw = evalin('base','tasklistraw');
freqlabellistraw = evalin('base','freqlabellistraw');
phenotypelistraw = evalin('base','phenotypelistraw');
numfreqs = length(freqlabellistraw);
%alldata = handles.alldata;
%raw = handles.raw;
alldata = evalin('base','alldata');
raw = evalin('base','raw');
numtimebins = evalin('base','batch_numtimebins');
% tasklist = {'1dot';'3dot';'5dot';'7dot'};
allmeasures = gui_allmeasures(alldata,raw,tasklistraw,numfreqs,numtimebins,thr_method,thr_highx,thr_low,phenotypelistraw);

msgbox('Graph measures complete!');
set(findobj('Tag','Status'),'String','Status: Graph Measures Complete!')
assignin('base','allmeasures',allmeasures);
%handles.allmeasures = allmeasures;
guidata(hObject,handles);
%}
%{
% --- Executes on button press in plotconnmatrix.
function plotconnmatrix_Callback(hObject, eventdata, handles)
% hObject    handle to plotconnmatrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%alldata = handles.alldata;
alldata = evalin('base','alldata');
raw = evalin('base','raw');
%raw = handles.raw;

%why load this here?
EEG = pop_loadset(raw(1,2));
assignin('base','EEG',EEG);

gui_coherencetopo

%}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%            POWER CALCULATIONS              %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
% --- Executes on button press in spectralpower.
function spectralpower_Callback(hObject, eventdata, handles)
% hObject    handle to spectralpower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
raw = evalin('base','raw');

%power_freqrange_list = cellstr(get(handles.power_freqrange,'String'));
%power_freqrange_selection = get(handles.power_freqrange,'Value');
%freqrange = str2num(power_freqrange_list{power_freqrange_selection});
tasklistraw = evalin('base','tasklistraw');
phenotypelistraw = evalin('base','phenotypelistraw');

%channel_list = evalin('base','batch_chnlist');
%channel_sel = get(handles.power_chnlist,'value');
%channels = channel_list(channel_sel); %%%%%%NEED TO TAKE IN CHN_LIST SINCE ADDING CHANNEL LABELS

%CalcPowerFeatures = [freqrange timerange1 timerange2 channels];
%PowerFeatureNames = strcat(power_freqrange_list{power_freqrange_selection}),',',ChannelStr,'Time-',TimeStr);

multiplefreqs = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SHOULD CLEAN THIS UP BY GETTING RID OF MAIN GUI OPTIONS-JUST USE BUTTON
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
runval = 0;
if multiplefreqs == 1
    gui_multiplepowers;
    uiwait;
    CalcPowerFeatures = evalin('base','CalcPowerFeatures');
end
try runval = evalin('base','runval'); %check if gui_multiplepowers set to run
catch
end
if runval == 1
    [abs_power rel_power] = gui_alpha_power_calculation(raw,tasklistraw,CalcPowerFeatures,phenotypelistraw);
    evalin('base',['clear ','runval']);
    msgbox('Power calculatations complete!');
    set(findobj('Tag','Status'),'String','Status: Power calculations complete!')
    assignin('base','abs_power',abs_power);
    assignin('base','rel_power',rel_power);

    guidata(hObject,handles);
else
    evalin('base',['clear ','runval']);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Multiple combined feature sets (ie top 3 from alpha gamma 1dot, top from
%alpha gamma 7dot
%exporting settings of each to a name-able workspace log file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%      FEATURE SET SELECTION/CREATION        %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
% --- Executes on button press in fisherclassify.
function fisherclassify_Callback(hObject, eventdata, handles)
%allmeasures = handles.allmeasures;
allmeasures = evalin('base','allmeasures');
tasklistraw = evalin('base','tasklistraw');
SubjectIDs = evalin('base','SubjectIDs');
numtimebins = evalin('base','batch_numtimebins');
graph_features = evalin('base','graph_features');
power_features = evalin('base','power_features');

numfeat = str2num(get(handles.fishertopfeat,'string'));
freqlabellistraw = evalin('base','freqlabellistraw');
numfreqs = length(freqlabellistraw);
%power_freqrange = get(handles.power_freqrange,'value');
phenotypelistraw = evalin('base','phenotypelistraw');


try x = evalin('base','abs_power');
    abs_power = evalin('base','abs_power');
    rel_power = evalin('base','rel_power');
    CalcPowerFeatures = evalin('base','CalcPowerFeatures');
    PowerFeatureNames = evalin('base','PowerFeatureNames');
catch
    abs_power = [];
    rel_power = [];
    CalcPowerFeatures = [];
    PowerFeatureNames = [];
end

comb_method = get(handles.comb_method,'value');
if comb_method == 1
 %   [AllFeatures AffectedTopFeatures TDTopFeatures TopFeatures FeaturesNames] = gui_fisher(allmeasures,tasklistraw,numtimebins,numfreqs,graph_features,power_features,abs_power,rel_power,alphapowertimerange,numfeat,power_freqrange,phenotypelistraw);
    [AllFeatures TopFeatures FeatureNames featureclass] = gui_fisher(allmeasures,tasklistraw,numtimebins,numfreqs,graph_features,power_features,abs_power,rel_power,numfeat,phenotypelistraw,CalcPowerFeatures,PowerFeatureNames);

    TopFeatures.Method = 'Individual';
    
    msgbox('Top features extracted!');
    set(findobj('Tag','Status'),'String','Status: Top features extracted!')
    assignin('base','TopFeatures',TopFeatures);
    assignin('base','AllFeatures',AllFeatures);
    assignin('base','FeatureNames',FeatureNames);
    assignin('base','featureclass',featureclass);
elseif comb_method == 2

    selectedfreqs = get(handles.fisher_freqlist,'value');
    selectedtasks = get(handles.fisher_tasklist,'value');
    
    for pheno = 1:1:length(phenotypelistraw)
        TopFeaturesTemp.(phenotypelistraw{pheno}) = [];
        TopFeaturesTemp.Names = [];
        Temp.(phenotypelistraw{pheno}) = [];
    end
    [TopFeaturesTemp AllFeatures FeatureNames featureclass] = gui_fisher2(allmeasures,tasklistraw,SubjectIDs,numtimebins,numfreqs,graph_features,power_features,abs_power,rel_power,numfeat,selectedfreqs,selectedtasks,phenotypelistraw,CalcPowerFeatures,PowerFeatureNames);
    
    set(findobj('Tag','Status'),'String','Status: Top features extracted!')
    
    combinesets = get(handles.combinesets,'value');
    %COMBINE FEATURE SETS IF SELECTED
    if combinesets == 1
        try TopFeatures = evalin('base','TopFeatures');
            if strcmp(TopFeatures.Method,'Combined');
                %COMBINE/CREATE FEATURE SET AND FIGURE OUT WHICH TASKS ARE
                %MISSING FOR EACH SUBJECT
                for b = 1:1:length(phenotypelistraw)
                    Temp.(phenotypelistraw{b}) = [SubjectIDs.All.(phenotypelistraw{b})];
                    featsetsize = size(Temp.(phenotypelistraw{b}),2);
                    newmat = cell2mat(TopFeatures.(phenotypelistraw{b})(:,2:end));
                    for n = 1:1:size(TopFeatures.(phenotypelistraw{b}),1)
                        subject = strmatch(TopFeatures.(phenotypelistraw{b})(n,1),Temp.(phenotypelistraw{b})(:,1));
                        if any(subject)
                            Temp.(phenotypelistraw{b})(subject,featsetsize+1:featsetsize+size(newmat,2)) = [num2cell(newmat(n,:))];
                        end
                    end
                    featsetsize = size(Temp.(phenotypelistraw{b}),2);
                    newmat = cell2mat(TopFeaturesTemp.(phenotypelistraw{b})(:,2:end));
                    for n = 1:1:size(TopFeaturesTemp.(phenotypelistraw{b}),1)
                        subject = strmatch(TopFeaturesTemp.(phenotypelistraw{b})(n,1),Temp.(phenotypelistraw{b})(:,1));
                        if any(subject)
                            Temp.(phenotypelistraw{b})(subject,featsetsize+1:featsetsize+size(newmat,2)) = [num2cell(newmat(n,:))];
                        end
                    end
                    %REMOVE SUBJECTS MISSING TASKS
                    Temp.(phenotypelistraw{b}) = Temp.(phenotypelistraw{b})(~any(cellfun('isempty',Temp.(phenotypelistraw{b})),2),:);
                end
                
                for b = 1:1:length(phenotypelistraw)
                    TopFeatures.(phenotypelistraw{b}) = Temp.(phenotypelistraw{b});
                end
                
                TopFeatures.Names = [TopFeatures.Names TopFeaturesTemp.Names];
            else %IF TOPFEATURES ISNT FROM PREVIOUS COMBINED SET
                TopFeatures = TopFeaturesTemp;
                TopFeatures.Names = [TopFeaturesTemp.Names];
            end
        catch %IF TOPFEATURES DOESNT EXIST
            TopFeatures = TopFeaturesTemp;
            TopFeatures.Names = [TopFeaturesTemp.Names];
        end
        
    else %IF COMBINESETS NOT SELECTED, OVERWRITE
        TopFeatures = TopFeaturesTemp;
        TopFeatures.Names = [TopFeaturesTemp.Names];
    end
    TopFeatures.Method = 'Combined';
    assignin('base','TopFeatures',TopFeatures);
    assignin('base','AllFeatures',AllFeatures);
    assignin('base','FeatureNames',FeatureNames);
    assignin('base','featureclass',featureclass);
    msgbox('Top features extracted!');
end
guidata(hObject,handles);

% --- Executes on button press in combinesets.
function combinesets_Callback(hObject, eventdata, handles)

% --- Executes on button press in fisher_choosefeatures.
function fisher_choosefeatures_Callback(hObject, eventdata, handles)

gui_choosefeatures;
uiwait;
try graph_features = evalin('base','graph_features');
    graph_features = evalin('base','graph_features');
power_features = evalin('base','power_features');
power_features(~any(cell2mat(power_features(:,1)),2),:) = [];
features = [graph_features(:,2);power_features(:,2)];
set(handles.fisher_featlist,'string',features);
catch
end


% --- Executes on selection change in comb_method.
function comb_method_Callback(hObject, eventdata, handles)

val = get(hObject,'value');
if val == 1
    set(handles.fisherclassify,'enable','on');
    set(handles.forcefeatureset,'enable','off');
    set(handles.svm_tasklist,'enable','on');
    set(handles.svm_freqlist,'enable','on');
    set(handles.combinesets,'enable','off');
    set(handles.fisher_tasklist,'enable','off');
    set(handles.fisher_freqlist,'enable','off');
    set(handles.fishertopfeat,'enable','on');
    set(handles.fishermerit,'enable','on');
elseif val == 2
    set(handles.fisherclassify,'enable','on');
    set(handles.forcefeatureset,'enable','off');
    set(handles.svm_tasklist,'enable','off');
    set(handles.svm_freqlist,'enable','off');
    set(handles.combinesets,'enable','on');
    set(handles.fisher_tasklist,'enable','on');
    set(handles.fisher_freqlist,'enable','on');
    set(handles.fishertopfeat,'enable','on');
    set(handles.fishermerit,'enable','on');
elseif val == 3
    set(handles.fisherclassify,'enable','off');
    set(handles.forcefeatureset,'enable','on');
    set(handles.svm_tasklist,'enable','off');
    set(handles.svm_freqlist,'enable','off');
    set(handles.combinesets,'enable','off');
    set(handles.fisher_tasklist,'enable','off');
    set(handles.fisher_freqlist,'enable','off');
    set(handles.fishertopfeat,'enable','off');
    set(handles.fishermerit,'enable','off');
end

% --- Executes during object creation, after setting all properties.
function comb_method_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in forcefeatureset.
function forcefeatureset_Callback(hObject, eventdata, handles)

gui_forcefeatureset;
uiwait;
allmeasures = evalin('base','allmeasures');
tasklistraw = evalin('base','tasklistraw');
numtimebins = evalin('base','batch_numtimebins');
numfreqs = evalin('base','freqlabellistraw');
numfreqs = length(numfreqs);
try ForcedFeatures = evalin('base','ForcedFeatures');
ForcedFeatures = evalin('base','ForcedFeatures');
phenotypelistraw = evalin('base','phenotypelistraw');


try x = evalin('base','abs_power');
    PowerFeatures = evalin('base','PowerFeatures');
    PowerFeatureNames = evalin('base','PowerFeatureNames');
    abs_power = evalin('base','abs_power');
    rel_power = evalin('base','rel_power');
catch
    PowerFeatures  = [];
    PowerFeatureNames = [];
    abs_power = [];
    rel_power = [];
end

%numfeat = size(
%power_freqrange = evalin('base','power_freqrange');
runval = evalin('base','runval');
SubjectIDs = evalin('base','SubjectIDs');
if runval == 1;
    [TopFeatures FeatureNames featureclass] = gui_createfeatureset(allmeasures,tasklistraw,SubjectIDs,numtimebins,numfreqs,ForcedFeatures,PowerFeatures,PowerFeatureNames,abs_power,rel_power,phenotypelistraw);
    assignin('base','TopFeatures',TopFeatures);
    assignin('base','FeatureNames',FeatureNames);
    assignin('base','featureclass',featureclass);
    assignin('base','handles',handles);%?????????
    msgbox('Feature set created!');
    evalin('base',['clear ','runval']);
else
    evalin('base',['clear ','runval']);
end
catch
end
%}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%      EXPORTING COMPLETE/TOP FEATURE SETS       %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
% --- Executes on button press in exportallfeatures.
function exportallfeatures_Callback(hObject, eventdata, handles)
% hObject    handle to exportallfeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
allmeasures = evalin('base','allmeasures');
tasklistraw = evalin('base','tasklistraw');
numtimebins = evalin('base','batch_numtimebins');
graph_features = evalin('base','graph_features');
power_features = evalin('base','power_features');

numfeat = str2num(get(handles.fishertopfeat,'string'));
freqlabellistraw = evalin('base','freqlabellistraw');
numfreqs = length(freqlabellistraw);
%power_freqrange = get(handles.power_freqrange,'value');
phenotypelistraw = evalin('base','phenotypelistraw');


try x = evalin('base','abs_power');
    abs_power = evalin('base','abs_power');
    rel_power = evalin('base','rel_power');
    CalcPowerFeatures = evalin('base','CalcPowerFeatures');
    PowerFeatureNames = evalin('base','PowerFeatureNames');
catch
    abs_power = [];
    rel_power = [];
    CalcPowerFeatures = [];%?????????????? CalcPowerFeatures?
    PowerFeatureNames = [];
end

[AllFeatures TopFeatures FeatureNames featureclass] = gui_fisher(allmeasures,tasklistraw,numtimebins,numfreqs,graph_features,power_features,abs_power,rel_power,numfeat,phenotypelistraw,CalcPowerFeatures,PowerFeatureNames);

%ADJUST TAST NAMES IF NECESSARY
tasklist = tasklistraw;
warn = 0;
for j = 1:1:length(tasklist)
    warncount = 0;
    while any(str2num(tasklist{j}(1)))
        tasklist{j} = circshift(tasklist{j},[1 -1]);
        warncount = warncount + 1;
        if warncount > length(tasklist{j})
            h = warndlg('Invalid task name. Task names cannot be entirely numerical.');
            warn = 1;
            break
        end
    end
    if warn == 1
        return
    end
end

SubjectIDs = evalin('base','SubjectIDs');
for task = 1:1:length(tasklist)
    SubjectIDtemp = [];
    for b = 1:1:length(phenotypelistraw)
        SubjectIDtemp = [SubjectIDtemp;SubjectIDs.(phenotypelistraw{b}).(tasklist{task})];
    end
     SubjectID.(tasklist{task}) = SubjectIDtemp;
end
    
count = 1;
h = waitbar(0,'Exporting Feature Set...');
[file,path] = uiputfile('*.xlsx','Save As');
if file ~= 0
for task = 1:1:length(tasklist)
    for freq = 1:1:length(freqlabellistraw)
        %WRITE FEATURE LABELS
        xlswrite(strcat(path,file),FeatureNames.(tasklist{task}){freq},strcat(tasklistraw{task},',',freqlabellistraw{freq}),'C1')
        %WRITE DATA
        xlswrite(strcat(path,file),AllFeatures.(tasklist{task}){freq},strcat(tasklistraw{task},',',freqlabellistraw{freq}),'C2');
        %WRITE SUBJECT CLASS LABELS
        classlist = [];
        for subjects = 1:1:length(featureclass{task})
            classlist{subjects} = phenotypelistraw{featureclass{task}(subjects)};
        end
        xlswrite(strcat(path,file),classlist',strcat(tasklistraw{task},',',freqlabellistraw{freq}),'B2');
        xlswrite(strcat(path,file),SubjectID.(tasklist{task}),strcat(tasklistraw{task},',',freqlabellistraw{freq}),'A2');
        count = count+1;
        waitbar(count/(length(tasklist)*length(freqlabellistraw)),h);
    end
end
end
close(h)
%}

%{
% --- Executes on button press in exporttopfeatures.
function exporttopfeatures_Callback(hObject, eventdata, handles)
% hObject    handle to exporttopfeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TopFeatures = evalin('base','TopFeatures');
tasklistraw = evalin('base','tasklistraw');
phenotypelistraw = evalin('base','phenotypelistraw');
freqlabellistraw = evalin('base','freqlabellistraw');
featureclass = evalin('base','featureclass');
tasklist = tasklistraw;
warn = 0;
for j = 1:1:length(tasklist)
    warncount = 0;
    while any(str2num(tasklist{j}(1)))
        tasklist{j} = circshift(tasklist{j},[1 -1]);
        warncount = warncount + 1;
        if warncount > length(tasklist{j})
            h = warndlg('Invalid task name. Task names cannot be entirely numerical.');
            warn = 1;
            break
        end
    end
    if warn == 1
        return
    end
end

SubjectIDs = evalin('base','SubjectIDs');
for task = 1:1:length(tasklist)
    SubjectIDtemp = [];
    for b = 1:1:length(phenotypelistraw)
        SubjectIDtemp = [SubjectIDtemp;SubjectIDs.(phenotypelistraw{b}).(tasklist{task})];
    end
     SubjectID.(tasklist{task}) = SubjectIDtemp;
end

[file,path] = uiputfile('*.xlsx','Save As');
if file ~=0
try x = fieldnames(TopFeatures.(phenotypelistraw{1}));
    %FOR EXPORTING TASK/FREQ STRUCTURE OF ALL INDIVIDUAL FEATURE SETS
    h = waitbar(0,'Exporting Top Features...');
    count = 1;
    for task = 1:1:length(tasklist)
        for freq = 1:1:length(freqlabellistraw)
            xlswrite(strcat(path,file),TopFeatures.Names.(tasklist{task}){freq},strcat(tasklist{task},',',freqlabellistraw{freq}),'C1')
            features = [];
            for pheno = 1:1:length(phenotypelistraw)
                features = [features;TopFeatures.(phenotypelistraw{pheno}).(tasklist{task}){freq}];
            end
            xlswrite(strcat(path,file),features,strcat(tasklist{task},',',freqlabellistraw{freq}),'C2');
            classlist = [];
            for subjects = 1:1:length(featureclass{task})
                classlist{subjects} = phenotypelistraw{featureclass{task}(subjects)};
            end
            xlswrite(strcat(path,file),classlist',strcat(tasklist{task},',',freqlabellistraw{freq}),'B2');
            xlswrite(strcat(path,file),SubjectID.(tasklist{task}),strcat(tasklistraw{task},',',freqlabellistraw{freq}),'A2');
            count = count+1;
            waitbar(count/(length(tasklist)*length(freqlabellistraw)),h);
        end
    end
    close(h);
catch
    %FOR EXPORTING SINGLE FEATURE SETS (IE ALREADY COMBINED OR MANUALLY
    %CHOSEN
    h = waitbar(0,'Exporting Top Features...');
    count = 1;
    xlswrite(strcat(path,file),TopFeatures.Names,1,'c1')
    features = [];
    for pheno = 1:1:length(phenotypelistraw)
        features = [features;TopFeatures.(phenotypelistraw{pheno})];
    end
    xlswrite(strcat(path,file),features,1,'B2');
    classlist = [];
    for subjects = 1:1:length(featureclass)
        classlist{subjects} = phenotypelistraw{featureclass(subjects)};
    end
    xlswrite(strcat(path,file),classlist',1,'A2');
    %xlswrite(strcat(path,file),SubjectID.(tasklist{task}),1,'A2');
    count = count+1;
    waitbar(count/(length(tasklist)*length(freqlabellistraw)),h);
    close(h);
end
end
    
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%               SVM CLASSIFIER               %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
% --- Executes on button press in svmclassify.
function svmclassify_Callback(hObject, eventdata, handles)
% hObject    handle to svmclassify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tasklist = evalin('base','tasklistraw');
freqlist = evalin('base','freqlabellistraw');
batch_freqlabel = evalin('base','batch_freqlabel');
svm_freqlist = get(handles.svm_freqlist,'value');
svm_tasklist = get(handles.svm_tasklist,'value');

holdout_ratio = str2num(get(handles.holdout,'string'));
svmfolds = str2num(get(handles.svmfolds,'string'));
tst_no = str2num(get(handles.numsubjects,'string'));
svmdimmethod = get(handles.svmdimmethod,'value');

%%                  ADD TO HERE FOR DROP DOWN MENU
if svmdimmethod == 1
    dim_method = 'none';
elseif svmdimmethod == 2
    dim_method = 'PCA';
end
%%           SET UP MATRIX FOR WHICH TASKS/FREQS ARE SELECTED
svm_freq = zeros(1,length(freqlist));
svm_task = zeros(1,length(tasklist));
for m = 1:1:length(svm_freqlist)
    svm_freq(svm_freqlist(m)) = 1; 
end
for n = 1:1:length(svm_tasklist)
    svm_task(svm_tasklist(n)) = 1;
end   
%%              FIND WHICH TASK & FREQ COMBINATIONS ARE SELECTED
svm_combos = zeros(length(freqlist),length(tasklist));
for k = 1:1:length(tasklist)
    for h = 1:1:length(batch_freqlabel)
        svm_combos(h,k) = svm_task(k)*svm_freq(h);
    end
end
[row, col] = find(svm_combos);


freqfields = evalin('base','batch_freqlabel');

%%
warning off
disp('Running SVM classification...');
%%  RUN CLASSIFICATION ON ALL SINGLE COMBINATIONS OF TASK+FREQ SELECTED

comb_method = get(handles.comb_method,'value');
TopFeatures = evalin('base','TopFeatures');
phenotypelistraw = evalin('base','phenotypelistraw');
if comb_method == 1
    taskfields = fieldnames(TopFeatures.(phenotypelistraw{1}));
    for i = 1:1:length(row)
        tmp_svm_fold=0;
        for t=1:tst_no
            %%????????????????????????????????????????????????????????????????????
            %MAYBE JUST PLUG IN TOPFEATURES AND HANDLE INSIDE INCASE > 2 GROUPS
            %?????????????????????????????????????????????????????????????????????
            [a b c d]=gui_svm_classification(TopFeatures.(phenotypelistraw{1}).(taskfields{col(i)}){1,row(i)},TopFeatures.(phenotypelistraw{2}).(taskfields{col(i)}){1,row(i)},svmfolds,dim_method,holdout_ratio,0);
            tmp_svm_fold=b+tmp_svm_fold;
        end
        
        disp(strcat('Task <',taskfields{col(i)}, '> Freq Band <', freqfields{row(i)},'> average classification accuracy % is <' ,num2str(tmp_svm_fold/tst_no),'%> After <' ,num2str(tst_no), '>  times running of the classification code'))
        Results{row(i),col(i)} = num2str(tmp_svm_fold/tst_no);
    end
elseif comb_method == 2
        tmp_svm_fold=0;
        for t=1:tst_no
            [a b c d]=gui_svm_classification(cell2mat(TopFeatures.(phenotypelistraw{1})),cell2mat(TopFeatures.(phenotypelistraw{2})),svmfolds,dim_method,holdout_ratio,0);
            tmp_svm_fold=b+tmp_svm_fold;
        end
        
        disp(strcat('Average classification accuracy % is <' ,num2str(tmp_svm_fold/tst_no),'%> After <' ,num2str(tst_no), '>  times running of the classification code'))
        Results = num2str(tmp_svm_fold/tst_no); 
elseif comb_method == 3
        tmp_svm_fold=0;
        for t=1:tst_no
            [a b c d]=gui_svm_classification(cell2mat(TopFeatures.(phenotypelistraw{1})),cell2mat(TopFeatures.(phenotypelistraw{2})),svmfolds,dim_method,holdout_ratio,0);
            tmp_svm_fold=b+tmp_svm_fold;
        end
        disp(strcat('Average classification accuracy % is <' ,num2str(tmp_svm_fold/tst_no),'%> After <' ,num2str(tst_no), '>  times running of the classification code'))
        Results = num2str(tmp_svm_fold/tst_no); 
end
    
%%
disp('All SVM group classification accuracies have been stored in Results in freq (row) x task (column) format');
assignin('base','Results',Results);
msgbox('SVM group classification complete & logged!');

logdata_Callback(hObject,eventdata,handles)
set(findobj('Tag','Status'),'String','Status: SVM group classification completed & logged!')
%}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%                DATA LOGGING                %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in logdata.
function logdata_Callback(hObject, eventdata, handles)
% hObject    handle to logdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%                          CREATE FILE NAME
%logfilename = get(handles.logfilename,'string');
configfilename = evalin('base','configfilename');
c = clock;
logfilename = strcat(strrep(configfilename.file,'.mat',[]),strcat('Logfile_',date,'_',num2str(c(4)),'_',num2str(c(5)),'_',num2str(round(c(6)))),'.txt');

%%                          BATCH PROCESSING PANEL
batch_freqrange = evalin('base','batch_freqrange');
batch_percentdata = evalin('base','batch_percentdata');
batch_chnlist = evalin('base','batch_chnlist');
batch_timebinsize = evalin('base','batch_timebinsize');
batchfile = get(handles.cohbatchfile,'string');
batch_timestart = evalin('base','batch_timestart');
batch_numtimebins = evalin('base','batch_numtimebins');

batchdata = ['===BATCH COHERENCE SETTINGS===';'Filename:';batchfile;'Frequency Ranges:';...
    batch_freqrange;'Channel List:';mat2str(batch_chnlist);'Percent Data:';...
    mat2str(batch_percentdata);'Time Start (from beginning of epoch):';batch_timestart;...
    'Time Bin Size:';mat2str(batch_timebinsize);'Number of Time Bins:';batch_numtimebins;];

dlmcell(logfilename,batchdata,'\t')

%%                           GRAPH THEORY PANEL
thr_highx = str2num(get(handles.thrhigh,'string'));
thr_low = str2num(get(handles.thrlow,'string'));
thr_method = get(handles.thrmethod,'value');
thr_methods = cellstr(get(handles.thrmethod,'string'));

threshold = {'===THRESHOLDING SETTINGS===';'Upper/Multiplier Threshold:';...
    num2str(thr_highx);'Lower Threshold:';mat2str(thr_low);'Threshold Method:';
    thr_methods(thr_method)};

dlmcell(logfilename,threshold,'\t','-a')

%%                          POWER ANALYSIS
PowerFeatureNames = evalin('base','PowerFeatureNames');

power = ['===POWER ANALYSIS SETTINGS===';'Powers Calculated:';'(Freq Range/Electrodes/Time Range)';PowerFeatureNames];

dlmcell(logfilename,power,'\t','-a');
%%                        FEATURE SELECTION PANEL
numfeat = str2num(get(handles.fishertopfeat,'string'));
comb_methods = cellstr(get(handles.comb_method,'string'));
comb_method = get(handles.comb_method,'value');
phenotypelistraw = evalin('base','phenotypelistraw');
tasklist = evalin('base','tasklistraw');
freqrangelistraw = evalin('base','freqrangelistraw');
TopFeatures = evalin('base','TopFeatures');

%ADJUST TASK NAMES
warn = 0;
for j = 1:1:length(tasklist)
    warncount = 0;
    while any(str2num(tasklist{j}(1)))
        tasklist{j} = circshift(tasklist{j},[1 -1]);
        warncount = warncount + 1;
        if warncount > length(tasklist{j})
            h = warndlg('Invalid task name. Task names cannot be entirely numerical.');
            warn = 1;
            break
        end
    end
    if warn == 1
        return
    end
end

%WRITE TOP FEATURES FOR RESPECTIVE SELECTION METHOD
if comb_method == 1
features = [];
    for task = 1:1:length(tasklist)
        for freq = 1:1:length(freqrangelistraw)
            features = [features;strcat('>Top Features for: Task-',tasklist{task},', Freq Range-',...
            freqrangelistraw{freq});TopFeatures.Names.(tasklist{task}){1,freq}'];
        end
    end
elseif comb_method == 2
    %get svm task and frreq selections
    features = [strcat('>Top Features for: Tasks-',', Frequency Ranges-'); TopFeatures.Names'];
elseif comb_method == 3
    FeatureNames = evalin('base','FeatureNames');
    features = ['>Selected Features:';FeatureNames'];
end

           
featuresel = ['===FEATURE ANALYSIS SETTINGS===';'Selection Method:';comb_methods{comb_method};...
    'Selected Features/Top Features:';features];
dlmcell(logfilename,featuresel,'\t','-a')

%%                          CLASSIFIER SETTINGS
holdout_ratio = str2num(get(handles.holdout,'string'));
svmfolds = str2num(get(handles.svmfolds,'string'));
tst_no = str2num(get(handles.numsubjects,'string'));
svmdimmethod = get(handles.svmdimmethod,'value');
if svmdimmethod == 1
    dim_method = 'none';
elseif svmdimmethod == 2
    dim_method = 'PCA';
end

svm = {'===SVM CLASSIFIER SETTINGS===';'Hold-out Ratio:';num2str(holdout_ratio);...
    'Number of Folds:';num2str(svmfolds);'Dimensionality Reduction Method:';...
    dim_method;'Number of Iterations:';num2str(tst_no)};

dlmcell(logfilename,svm,'\t','-a');

%%                              RESULTS
classacc = {'===SVM Group Classification Accuracies==='};
dlmcell(logfilename,classacc,'\t','-a');

%HARD CODED RESULTS FOR NUM OF FREQUENCIES AND TASKS...
comb_method = get(handles.comb_method,'value');
Results = evalin('base','Results');
if comb_method == 1
    tasklistraw = evalin('base','tasklistraw');
    result_labels1 = tasklistraw';
    batch_freqlabel = evalin('base','batch_freqlabel');
    
    %CONCATENATE RESULTS INTO FREQ X TASK MATRIX
    emptyIndex = cellfun(@isempty,Results);       %# Find indices of empty cells
    Results(emptyIndex) = {0};
    [x y] = size(Results);
    
    %# OF FREQUENCIES
    if x < length(batch_freqlabel)
        Results(x+1:length(batch_freqlabel),:) = {0};
    end
    
    %# OF TASKS
    if y < length(tasklistraw)
        Results(:,y+1:length(tasklistraw)) = {0};
    end
    result_temp = [result_labels1;Results];
    
    result_labels2{1} = [];
    for i = 1:1:length(batch_freqlabel)
        result_labels2{i+1} = batch_freqlabel{i};
    end

    result = [result_labels2' result_temp];

elseif comb_method == 2
    
   result = {Results};
    
elseif comb_method == 3
    
    result = {Results};
    
end

dlmcell(logfilename,result,'\t','-a')
disp('File Saved!');

set(findobj('Tag','Status'),'String','Status: File Saved!')

 %{
function numsubjects_Callback(hObject, eventdata, handles)
% hObject    handle to numsubjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numsubjects as text
%        str2double(get(hObject,'String')) returns contents of numsubjects as a double


% --- Executes during object creation, after setting all properties.
function numsubjects_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numsubjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function svmfolds_Callback(hObject, eventdata, handles)
% hObject    handle to svmfolds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of svmfolds as text
%        str2double(get(hObject,'String')) returns contents of svmfolds as a double


% --- Executes during object creation, after setting all properties.
function svmfolds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to svmfolds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function holdout_Callback(hObject, eventdata, handles)
% hObject    handle to holdout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of holdout as text
%        str2double(get(hObject,'String')) returns contents of holdout as a double


% --- Executes during object creation, after setting all properties.
function holdout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to holdout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in fishermerit.
function fishermerit_Callback(hObject, eventdata, handles)
% hObject    handle to fishermerit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fishermerit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fishermerit


% --- Executes during object creation, after setting all properties.
function fishermerit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fishermerit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipanel6_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold as text
%        str2double(get(hObject,'String')) returns contents of threshold as a double


% --- Executes during object creation, after setting all properties.
function threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dimmethod_Callback(hObject, eventdata, handles)
% hObject    handle to dimmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dimmethod as text
%        str2double(get(hObject,'String')) returns contents of dimmethod as a double


% --- Executes during object creation, after setting all properties.
function dimmethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dimmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function fishertopfeat_Callback(hObject, eventdata, handles)
% hObject    handle to fishertopfeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fishertopfeat as text
%        str2double(get(hObject,'String')) returns contents of fishertopfeat as a double


% --- Executes during object creation, after setting all properties.
function fishertopfeat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fishertopfeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
%function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
%function loaddata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loaddata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on key press with focus on loaddata and none of its controls.
%function loaddata_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to loaddata (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



%function thrhigh_Callback(hObject, eventdata, handles)
% hObject    handle to thrhigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thrhigh as text
%        str2double(get(hObject,'String')) returns contents of thrhigh as a double


% --- Executes during object creation, after setting all properties.
%function thrhigh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thrhigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%    set(hObject,'BackgroundColor','white');
%end



%function thrlow_Callback(hObject, eventdata, handles)
% hObject    handle to thrlow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thrlow as text
%        str2double(get(hObject,'String')) returns contents of thrlow as a double


% --- Executes during object creation, after setting all properties.
%function thrlow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thrlow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%    set(hObject,'BackgroundColor','white');
%end


% --- Executes during object creation, after setting all properties.
%function thrmethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thrmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%    set(hObject,'BackgroundColor','white');
%end


% --- Executes on button press in absalphapower.
%function absalphapower_Callback(hObject, eventdata, handles)
% hObject    handle to absalphapower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of absalphapower


% --- Executes on button press in relalphapower.
%function relalphapower_Callback(hObject, eventdata, handles)
% hObject    handle to relalphapower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of relalphapower


%function logfilename_Callback(hObject, eventdata, handles)
% hObject    handle to logfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of logfilename as text
%        str2double(get(hObject,'String')) returns contents of logfilename as a double


% --- Executes during object creation, after setting all properties.
%function logfilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to logfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%    set(hObject,'BackgroundColor','white');
%end


% --- Executes on selection change in svmdimmethod.
function svmdimmethod_Callback(hObject, eventdata, handles)
% hObject    handle to svmdimmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns svmdimmethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from svmdimmethod


% --- Executes during object creation, after setting all properties.
function svmdimmethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to svmdimmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in svm_tasklist.
function svm_tasklist_Callback(hObject, eventdata, handles)
% hObject    handle to svm_tasklist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns svm_tasklist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from svm_tasklist


% --- Executes during object creation, after setting all properties.
function svm_tasklist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to svm_tasklist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in svm_freqlist.
function svm_freqlist_Callback(hObject, eventdata, handles)
% hObject    handle to svm_freqlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns svm_freqlist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from svm_freqlist


% --- Executes during object creation, after setting all properties.
function svm_freqlist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to svm_freqlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fisher_featlist.
function fisher_featlist_Callback(hObject, eventdata, handles)
% hObject    handle to fisher_featlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fisher_featlist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fisher_featlist


% --- Executes during object creation, after setting all properties.
function fisher_featlist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fisher_featlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in fisher_tasklist.
function fisher_tasklist_Callback(hObject, eventdata, handles)
% hObject    handle to fisher_tasklist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fisher_tasklist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fisher_tasklist


% --- Executes during object creation, after setting all properties.
function fisher_tasklist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fisher_tasklist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fisher_freqlist.
function fisher_freqlist_Callback(hObject, eventdata, handles)
% hObject    handle to fisher_freqlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fisher_freqlist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fisher_freqlist


% --- Executes during object creation, after setting all properties.
function fisher_freqlist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fisher_freqlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%}



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               FILE TAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function menu_File_Callback(hObject, eventdata, handles)
%% --------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%          SAVE FILE          %%%%%%%%%%%%%%%%%%%%%%%
    function menu_new_Callback(hObject, eventdata, handles)
%% --------------------------------------------------------------------


        function menu_new_config_Callback(hObject, eventdata, handles)
%% --------------------------------------------------------------------


        function menu_new_analysis_Callback(hObject, eventdata, handles)
%% --------------------------------------------------------------------
warnuser = questdlg('Save workspace?', 'Warning','Yes');
switch warnuser
    case 'Yes';
        saveworkspace_Callback(hObject, eventdata, handles)
      %  msgbox('Workspace variables saved!');
      %should eventually replace with clear bionect.struc or something
      evalin('base',['clear AllFeatures CalcPowerFeatures FeatureNames ForcedFeatures PowerFeatureNames PowerFeatures Results TopFeatures abs_power graph_features power_features rel_power SubjectIDs alldata allmeasures']);
    case 'No';
      evalin('base',['clear AllFeatures CalcPowerFeatures FeatureNames ForcedFeatures PowerFeatureNames PowerFeatures Results TopFeatures abs_power graph_features power_features rel_power SubjectIDs alldata allmeasures']);

    case 'Cancel';
        return
end


%%%%%%%%%%%%%%%%%%%%%%%         LOAD FILE             %%%%%%%%%%%%%%%%%%%%%
    function menu_load_Callback(hObject, eventdata, handles)
%% -------------------------------------------------------------------- N/A

 
        function menu_load_config_Callback(hObject, eventdata, handles)
%% --------------------------------------------------------------------
[file, path] = uigetfile('*.mat','Load Configuration File');
if file~=0
    
end

        function menu_load_analysis_Callback(hObject, eventdata, handles)
%% -------------------------------------------------------------------- DONE

[file,path] = uigetfile('*.mat','Load Analysis File');
if file ~=0
analysisfile = strcat(path,file);
evalin('base',['load(''', analysisfile ''')']);
analysisname = strcat('Analysis Name: ',file);
set(findobj('Tag','AnalysisName'),'String',analysisname)
assignin('base','analysisfile',file);
assignin('base','analysispath',path);
msgbox('Analysis loaded!');
end

%%%%%%%%%%%%%%%%%%%%%        BATCH FILE               %%%%%%%%%%%%%%%%%%%%%
function menu_batch_Callback(hObject, eventdata, handles)
%% -------------------------------------------------------------------- N/A


    function menu_batch_create_Callback(hObject, eventdata, handles)
%% -------------------------------------------------------------------- DONE
Labels = {'Working Folder' 'EEG Dataset Name' 'To Be Processed' 'Processed' ...
    'Time Range in ms' 'Montage Name' 'Phenotype' 'Subject ID' 'Task'};
Example = {'C:\Documents\BioNeCT\Subject001\data'...
    'Subject001-Resting.set'...
    'yes'...
    []...
    []...
    []...
    'Control'...
    'Subject001'...
    'Resting'};

[file,path] = uiputfile('*.xlsx','Create New Batch File (.xls)');
if file ~= 0 
xlswrite(strcat(path,file),[Labels;Example]);
end
%ADJUST CELL SIZES/HEADERS
ExcelApp=actxserver('excel.application');
ExcelApp.Visible=1;
NewWorkbook=ExcelApp.Workbooks.Open(strcat(path,file));   
NewSheet=NewWorkbook.Sheets.Item(1);
NewRange=NewSheet.Range('A1');
NewRange.ColumnWidth=40;
set(NewRange.Font,'Underline',true,'Bold',true);
NewRange=NewSheet.Range('B1');
NewRange.ColumnWidth=30;
set(NewRange.Font,'Underline',true,'Bold',true);
NewRange=NewSheet.Range('C1');
NewRange.ColumnWidth=15;
set(NewRange.Font,'Underline',true,'Bold',true);
NewRange=NewSheet.Range('D1');
NewRange.ColumnWidth=10;
set(NewRange.Font,'Underline',true,'Bold',true);
NewRange=NewSheet.Range('E1');
NewRange.ColumnWidth=15;
set(NewRange.Font,'Underline',true,'Bold',true);
NewRange=NewSheet.Range('F1');
NewRange.ColumnWidth=15;
set(NewRange.Font,'Underline',true,'Bold',true);
NewRange=NewSheet.Range('G1');
NewRange.ColumnWidth=10;
set(NewRange.Font,'Underline',true,'Bold',true);
NewRange=NewSheet.Range('H1');
NewRange.ColumnWidth=10;
set(NewRange.Font,'Underline',true,'Bold',true);
NewRange=NewSheet.Range('I1');
NewRange.ColumnWidth=12;
set(NewRange.Font,'Underline',true,'Bold',true);

%USE computer COMMAND TO FIND OS
if ispc %adjust for OS ismac, isunix. Need open commands. In future would check OS early in program and set flag
%winopen(strcat(path,file));
end


    function menu_batch_load_Callback(hObject, eventdata, handles)
%% -------------------------------------------------------------------- DONE

[file, path, filterindex] = uigetfile('*.xls;*.xlsx','Load Batch File');

if file == 0
   % file = get(handles.cohbatchfile,'string');
  %  set(handles.cohbatchfile,'string',file);
else 
    set(handles.cohbatchfile,'string',file);
    batchfile.file = file;
    batchfile.path = path;
    assignin('base','batchfile',batchfile);
end

%%%%%%%%%%%%%%%%%%%%%         SAVE CONFIG             %%%%%%%%%%%%%%%%%%%%%
    function menu_saveconfig_Callback(hObject, eventdata, handles)
%% --------------------------------------------------------------------
saveState(handles);

    function menu_saveconfigas_Callback(hObject, eventdata, handles)
%% --------------------------------------------------------------------
[file, path] = uiputfile('*.mat','Save Configuration as');


%%%%%%%%%%%%%%%%%%%%%       SAVE ANALYSIS             %%%%%%%%%%%%%%%%%%%%% 
    function menu_saveanalysis_Callback(hObject, eventdata, handles)
%% -------------------------------------------------------------------- DONE

try
    file = evalin('base','analysisfile');
    path = evalin('base','analysispath');
    analysisfile = strcat(path,file);
    evalin('base', ['save(''', analysisfile ''')']);
    msgbox('Analysis saved!');
catch
[file,path] = uiputfile('*.mat','Save Analysis As');
if file ~=0
analysisfile = strcat(path,file);
evalin('base', ['save(''', analysisfile ''')']);
analysisname = strcat('Analysis Name: ',file);
set(findobj('Tag','AnalysisName'),'String',analysisname)
assignin('base','analysisfile',file);
assignin('base','analysispath',path);
msgbox('Analysis saved!');
end
end

    function menu_saveanalysisas_Callback(hObject, eventdata, handles)
%% -------------------------------------------------------------------- DONE 

[file,path] = uiputfile('*.mat','Save Analysis as');
if file ~=0
analysisfile = strcat(path,file);
evalin('base', ['save(''', analysisfile ''')']);
analysisname = strcat('Analysis Name: ',file);
set(findobj('Tag','AnalysisName'),'String',analysisname)
assignin('base','analysisfile',file);
assignin('base','analysispath',path);
msgbox('Analysis saved!');
end





%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               EDIT TAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function menu_edit_Callback(hObject, eventdata, handles)
%% -------------------------------------------------------------------- N/A 

    function menu_edit_config_Callback(hObject, eventdata, handles)
%% -------------------------------------------------------------------- DONE

gui_batchsettings
uiwait
%{
try 
    runval = evalin('base','runval'); %check if gui_multiplepowers set to run
catch
end
if runval == 1
%this ping if cancel is hit on first run in batch settings instead of save
freqlabellistraw = evalin('base','freqlabellistraw');
%freqrangelistraw = evalin('base','freqrangelistraw');
tasklistraw = evalin('base','tasklistraw');
%batch_chnlist = evalin('base','batch_chnlist');
%set(handles.svm_freqlist,'string',freqlabellistraw); %WILL DO THIS INSTEAD IN THE NEW SVM POPUP
%set(handles.svm_tasklist,'string',tasklistraw);
%set(handles.fisher_tasklist,'string',tasklistraw);
%set(handles.fisher_freqlist,'string',freqlabellistraw);
else
    evalin('base',['clear ','runval']);
end
%}




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               RUN TAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function menu_run_Callback(hObject, eventdata, handles)
%% -------------------------------------------------------------------- N/A
 

    function menu_run_coh_Callback(hObject, eventdata, handles)
%% -------------------------------------------------------------------- DONE

%batchfile = get(handles.cohbatchfile,'string');
batchfile = evalin('base','batchfile');
filename = strcat(batchfile.path,'\',batchfile.file);
batch_freqrange = evalin('base','batch_freqrange');
batch_percentdata = evalin('base','batch_percentdata');
batch_chnlist = evalin('base','batch_chnlist');
batch_timebinsize = evalin('base','batch_timebinsize');
batch_timestart = evalin('base','batch_timestart');
batch_numtimebins = evalin('base','batch_numtimebins');

warnuser = questdlg('Coherence batch processing may take up to several hours. It may also overwrite existing files. Continue?', 'Warning','Yes');
switch warnuser
    case 'Yes';
    case 'No';
        return
    case 'Cancel';
        return
end
for k = 1:1:size(batch_freqrange,1)
    freq_bin(k,1:2) = str2num(batch_freqrange{k})
end

gui_batch_spec_coh_plot_partial_elec(filename,batch_percentdata,batch_chnlist,batch_timebinsize,freq_bin,batch_timestart,batch_numtimebins)
msgbox('Batch coherence processing complete!');

    function menu_run_loadmat_Callback(hObject, eventdata, handles)
%% -------------------------------------------------------------------- DONE

%batchfile = get(handles.cohbatchfile,'string');
batchfile = evalin('base','batchfile');
filename = strcat(batchfile.path,'\',batchfile.file);
tasklistraw = evalin('base','tasklistraw');
phenotypelistraw = evalin('base','phenotypelistraw');

disp('Loading data...');

[alldata, raw, SubjectIDs, Missing] = gui_loaddata(filename,tasklistraw,phenotypelistraw);

prog = strcat('Data loaded for (',num2str(size(raw,1)),') instances!');
disp(prog); msgbox('Data loaded!');

assignin('base','alldata',alldata);
assignin('base','raw',raw);
assignin('base','SubjectIDs',SubjectIDs);
assignin('base','Missing',Missing);


batch_chnlist = evalin('base','batch_chnlist');
disp('Loading sample data file for channel labels...');
EEG = pop_loadset(strcat(raw{1,1},'\',raw{1,2}));
for i = 1:1:EEG.nbchan
     chnlabels{i} = strcat(num2str(batch_chnlist(i)),'-',EEG.chanlocs(1,i).labels);
end
assignin('base','chnlabels',chnlabels);
set(findobj('Tag','Status'),'String','Status: Data Loaded!')
guidata(hObject,handles);

    function menu_run_graph_Callback(hObject, eventdata, handles)
%% --------------------------------------------------------------------

gui_graphanalysis;
uiwait;
try
runval = evalin('base','runval');
catch 
    runval = 0;
end
if runval == 1
    msgbox('Graph measures complete!');
    set(findobj('Tag','Status'),'String','Status: Graph Measures Complete!')
end
evalin('base',['clear ','runval']);

    function menu_run_power_Callback(hObject, eventdata, handles)
%% -------------------------------------------------------------------- DONE

raw = evalin('base','raw');
tasklistraw = evalin('base','tasklistraw');
phenotypelistraw = evalin('base','phenotypelistraw');


gui_multiplepowers;
uiwait;
try
runval = evalin('base','runval');
catch 
    runval = 0;
end
if runval == 1
    CalcPowerFeatures = evalin('base','CalcPowerFeatures');
    [abs_power rel_power] = gui_alpha_power_calculation(raw,tasklistraw,CalcPowerFeatures,phenotypelistraw);
    evalin('base',['clear ','runval']);
    msgbox('Power calculatations complete!');
    set(findobj('Tag','Status'),'String','Status: Power calculations complete!')
    assignin('base','abs_power',abs_power);
    assignin('base','rel_power',rel_power);
 
end
   evalin('base',['clear ','runval']);
    function menu_run_featuresel_Callback(hObject, eventdata, handles)
%% --------------------------------------------------------------------
gui_featureanalysis;
try
runval = evalin('base','runval');
catch 
    runval = 0;
end
if runval == 1
        msgbox('Top features extracted!');
        set(findobj('Tag','Status'),'String','Status: Top features extracted!')
end
evalin('base',['clear ','runval']);


    function menu_run_svm_Callback(hObject, eventdata, handles)
%% --------------------------------------------------------------------
gui_runclassifier;
uiwait;
try
runval = evalin('base','runval');
catch 
    runval = 0;
end
if runval == 1
    disp('All SVM group classification accuracies have been stored in Results in freq (row) x task (column) format');
    msgbox('SVM group classification complete & logged!');
    logdata_Callback(hObject,eventdata,handles)
    set(findobj('Tag','Status'),'String','Status: SVM group classification completed & logged!')
end
evalin('base',['clear ','runval']);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               VIEW TAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function menu_view_Callback(hObject, eventdata, handles)
%% -------------------------------------------------------------------- N/A


    function menu_view_coh_Callback(hObject, eventdata, handles)
%% --------------------------------------------------------------------
raw = evalin('base','raw');

EEG = pop_loadset(strcat(raw(1,1),'\',raw(1,2)));
assignin('base','EEG',EEG);

gui_coherencetopo




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               EXPORT TAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function menu_export_Callback(hObject, eventdata, handles)
%% -------------------------------------------------------------------- N/A

    function menu_export_features_Callback(hObject, eventdata, handles)
%% -------------------------------------------------------------------- N/A

        function menu_export_features_all_Callback(hObject, eventdata, handles)
%% --------------------------------------------------------------------
allmeasures = evalin('base','allmeasures');
tasklistraw = evalin('base','tasklistraw');
numtimebins = evalin('base','batch_numtimebins');
graph_features = evalin('base','graph_features');
power_features = evalin('base','power_features');

numfeat = str2num(get(handles.fishertopfeat,'string'));
freqlabellistraw = evalin('base','freqlabellistraw');
numfreqs = length(freqlabellistraw);
%power_freqrange = get(handles.power_freqrange,'value');
phenotypelistraw = evalin('base','phenotypelistraw');


try x = evalin('base','abs_power');
    abs_power = evalin('base','abs_power');
    rel_power = evalin('base','rel_power');
    CalcPowerFeatures = evalin('base','CalcPowerFeatures');
    PowerFeatureNames = evalin('base','PowerFeatureNames');
catch
    abs_power = [];
    rel_power = [];
    CalcPowerFeatures = [];%?????????????? CalcPowerFeatures?
    PowerFeatureNames = [];
end

[AllFeatures TopFeatures FeatureNames featureclass] = gui_fisher(allmeasures,tasklistraw,numtimebins,numfreqs,graph_features,power_features,abs_power,rel_power,numfeat,phenotypelistraw,CalcPowerFeatures,PowerFeatureNames);

%ADJUST TASK NAMES IF NECESSARY
tasklist = tasklistraw;
warn = 0;
for j = 1:1:length(tasklist)
    warncount = 0;
    while any(str2num(tasklist{j}(1)))
        tasklist{j} = circshift(tasklist{j},[1 -1]);
        warncount = warncount + 1;
        if warncount > length(tasklist{j})
            h = warndlg('Invalid task name. Task names cannot be entirely numerical.');
            warn = 1;
            break
        end
    end
    if warn == 1
        return
    end
end

SubjectIDs = evalin('base','SubjectIDs');
for task = 1:1:length(tasklist)
    SubjectIDtemp = [];
    for b = 1:1:length(phenotypelistraw)
        SubjectIDtemp = [SubjectIDtemp;SubjectIDs.(phenotypelistraw{b}).(tasklist{task})];
    end
     SubjectID.(tasklist{task}) = SubjectIDtemp;
end
    
count = 1;
h = waitbar(0,'Exporting Feature Set...');
[file,path] = uiputfile('*.xlsx','Save As');
if file ~= 0
for task = 1:1:length(tasklist)
    for freq = 1:1:length(freqlabellistraw)
        %WRITE FEATURE LABELS
        xlswrite(strcat(path,file),FeatureNames.(tasklist{task}){freq},strcat(tasklistraw{task},',',freqlabellistraw{freq}),'C1')
        %WRITE DATA
        xlswrite(strcat(path,file),AllFeatures.(tasklist{task}){freq},strcat(tasklistraw{task},',',freqlabellistraw{freq}),'C2');
        %WRITE SUBJECT CLASS LABELS
        classlist = [];
        for subjects = 1:1:length(featureclass{task})
            classlist{subjects} = phenotypelistraw{featureclass{task}(subjects)};
        end
        xlswrite(strcat(path,file),classlist',strcat(tasklistraw{task},',',freqlabellistraw{freq}),'B2');
        xlswrite(strcat(path,file),SubjectID.(tasklist{task}),strcat(tasklistraw{task},',',freqlabellistraw{freq}),'A2');
        count = count+1;
        waitbar(count/(length(tasklist)*length(freqlabellistraw)),h);
    end
end
end
close(h)


        function menu_export_features_top_Callback(hObject, eventdata, handles)
%% --------------------------------------------------------------------
TopFeatures = evalin('base','TopFeatures');
tasklistraw = evalin('base','tasklistraw');
phenotypelistraw = evalin('base','phenotypelistraw');
freqlabellistraw = evalin('base','freqlabellistraw');
featureclass = evalin('base','featureclass');
tasklist = tasklistraw;
warn = 0;
for j = 1:1:length(tasklist)
    warncount = 0;
    while any(str2num(tasklist{j}(1)))
        tasklist{j} = circshift(tasklist{j},[1 -1]);
        warncount = warncount + 1;
        if warncount > length(tasklist{j})
            h = warndlg('Invalid task name. Task names cannot be entirely numerical.');
            warn = 1;
            break
        end
    end
    if warn == 1
        return
    end
end

SubjectIDs = evalin('base','SubjectIDs');
for task = 1:1:length(tasklist)
    SubjectIDtemp = [];
    for b = 1:1:length(phenotypelistraw)
        SubjectIDtemp = [SubjectIDtemp;SubjectIDs.(phenotypelistraw{b}).(tasklist{task})];
    end
     SubjectID.(tasklist{task}) = SubjectIDtemp;
end

[file,path] = uiputfile('*.xlsx','Save As');
if file ~=0
try x = fieldnames(TopFeatures.(phenotypelistraw{1}));
    %FOR EXPORTING TASK/FREQ STRUCTURE OF ALL INDIVIDUAL FEATURE SETS
    h = waitbar(0,'Exporting Top Features...');
    count = 1;
    for task = 1:1:length(tasklist)
        for freq = 1:1:length(freqlabellistraw)
            xlswrite(strcat(path,file),TopFeatures.Names.(tasklist{task}){freq},strcat(tasklist{task},',',freqlabellistraw{freq}),'C1')
            features = [];
            for pheno = 1:1:length(phenotypelistraw)
                features = [features;TopFeatures.(phenotypelistraw{pheno}).(tasklist{task}){freq}];
            end
            xlswrite(strcat(path,file),features,strcat(tasklist{task},',',freqlabellistraw{freq}),'C2');
            classlist = [];
            for subjects = 1:1:length(featureclass{task})
                classlist{subjects} = phenotypelistraw{featureclass{task}(subjects)};
            end
            xlswrite(strcat(path,file),classlist',strcat(tasklist{task},',',freqlabellistraw{freq}),'B2');
            xlswrite(strcat(path,file),SubjectID.(tasklist{task}),strcat(tasklistraw{task},',',freqlabellistraw{freq}),'A2');
            count = count+1;
            waitbar(count/(length(tasklist)*length(freqlabellistraw)),h);
        end
    end
    close(h);
catch
    %FOR EXPORTING SINGLE FEATURE SETS (IE ALREADY COMBINED OR MANUALLY
    %CHOSEN
    h = waitbar(0,'Exporting Top Features...');
    count = 1;
    xlswrite(strcat(path,file),TopFeatures.Names,1,'c1')
    features = [];
    for pheno = 1:1:length(phenotypelistraw)
        features = [features;TopFeatures.(phenotypelistraw{pheno})];
    end
    xlswrite(strcat(path,file),features,1,'B2');
    classlist = [];
    for subjects = 1:1:length(featureclass)
        classlist{subjects} = phenotypelistraw{featureclass(subjects)};
    end
    xlswrite(strcat(path,file),classlist',1,'A2');
    %xlswrite(strcat(path,file),SubjectID.(tasklist{task}),1,'A2');
    count = count+1;
    waitbar(count/(length(tasklist)*length(freqlabellistraw)),h);
    close(h);
end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               HELP TAB

function menu_help_Callback(hObject, eventdata, handles)
%% -------------------------------------------------------------------- N/A


    function menu_help_manual_Callback(hObject, eventdata, handles)
%% --------------------------------------------------------------------



    function menu_help_about_Callback(hObject, eventdata, handles)
%% --------------------------------------------------------------------
