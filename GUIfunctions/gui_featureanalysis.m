function varargout = gui_featureanalysis(varargin)
% GUI_FEATUREANALYSIS MATLAB code for gui_featureanalysis.fig
%      GUI_FEATUREANALYSIS, by itself, creates a new GUI_FEATUREANALYSIS or raises the existing
%      singleton*.
%
%      H = GUI_FEATUREANALYSIS returns the handle to a new GUI_FEATUREANALYSIS or the handle to
%      the existing singleton*.
%
%      GUI_FEATUREANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_FEATUREANALYSIS.M with the given input arguments.
%
%      GUI_FEATUREANALYSIS('Property','Value',...) creates a new GUI_FEATUREANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_featureanalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_featureanalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_featureanalysis

% Last Modified by GUIDE v2.5 05-Oct-2015 15:15:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_featureanalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_featureanalysis_OutputFcn, ...
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

% Hints: contents = cellstr(get(hObject,'String')) returns fisher_featlist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fisher_featlist
% Hint: get(hObject,'Value') returns toggle state of combinesets

% --- Executes just before gui_featureanalysis is made visible.
function gui_featureanalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_featureanalysis (see VARARGIN)

% Choose default command line output for gui_featureanalysis
handles.output = hObject;
handles.BNCT = evalin('base','BNCT');
fisher_tasklist = handles.BNCT.config.tasklistraw;%evalin('base','tasklistraw');
fisher_freqlist = handles.BNCT.config.freqlabellistraw;%evalin('base','freqlabellistraw');
set(handles.fisher_tasklist,'string',fisher_tasklist);
set(handles.fisher_freqlist,'string',fisher_freqlist);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_featureanalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_featureanalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);

% Get default command line output from handles structure
varargout{1} = handles.output;

function comb_method_Callback(hObject, eventdata, handles)
%% Feature Combination/Selection Method
val = get(hObject,'value');
if val == 1
    set(handles.fisherclassify,'enable','on');
    set(handles.forcefeatureset,'enable','off');
    set(handles.combinesets,'enable','off');
    set(handles.fisher_tasklist,'enable','off');
    set(handles.fisher_freqlist,'enable','off');
    set(handles.fishertopfeat,'enable','on');
    set(handles.fishermerit,'enable','on');
    set(handles.fisher_choosefeatures,'enable','on');
    descrip = {'Method: Individual Combos';...
        'Obtain top features from single';...
        'frequency and task combination feature set.'};

    set(findobj('Tag','descrip'),'String',descrip)
elseif val == 2
    set(handles.fisherclassify,'enable','on');
    set(handles.forcefeatureset,'enable','off');
    set(handles.combinesets,'enable','on');
    set(handles.fisher_tasklist,'enable','on');
    set(handles.fisher_freqlist,'enable','on');
    set(handles.fishertopfeat,'enable','on');
    set(handles.fishermerit,'enable','on');
    set(handles.fisher_choosefeatures,'enable','on');
    descrip = {'Method: Combine Freqs/Tasks';...
        'Obtain top features from features sets';...
        'from multiple tasks and/or frequencies'};

    set(findobj('Tag','descrip'),'String',descrip)    
elseif val == 3
    set(handles.fisherclassify,'enable','off');
    set(handles.forcefeatureset,'enable','on');
    set(handles.combinesets,'enable','off');
    set(handles.fisher_tasklist,'enable','off');
    set(handles.fisher_freqlist,'enable','off');
    set(handles.fishertopfeat,'enable','off');
    set(handles.fishermerit,'enable','off');
    set(handles.fisher_choosefeatures,'enable','off');
    descrip = {'Method: Create a Feature Set (Manual)';...
        'Create a custom feature set containing';...
        'features from specific time ranges/tasks/freqs.'};

    set(findobj('Tag','descrip'),'String',descrip)    
end


function comb_method_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function combinesets_Callback(hObject, eventdata, handles)
%% Checkbox to combine feature sets



function forcefeatureset_Callback(hObject, eventdata, handles)
%% Manual feature set creation
gui_forcefeatureset;
uiwait;
runval = evalin('base','runval');
handles.BNCT = evalin('base','BNCT');
%Add in runval flag here?
if runval == 1;
allmeasures = handles.BNCT.allmeasures;%evalin('base','allmeasures');
tasklistraw = handles.BNCT.config.tasklistraw;%evalin('base','tasklistraw');
batch_timerange = handles.BNCT.config.batch_timerange;%evalin('base','batch_timerange');
numtimebins = size(batch_timerange,1);
numfreqs = handles.BNCT.config.freqlabellistraw;%evalin('base','freqlabellistraw');
numfreqs = length(numfreqs);

try %ForcedFeatures = evalin('base','ForcedFeatures');
ForcedFeatures = handles.BNCT.ForcedFeatures;%evalin('base','ForcedFeatures');
phenotypelistraw = handles.BNCT.config.phenotypelistraw;%evalin('base','phenotypelistraw');


try %x = evalin('base','abs_power');
    PowerFeatures = handles.BNCT.PowerFeatures;%evalin('base','PowerFeatures');
    PowerFeatureNames = handles.BNCT.PowerFeatureNames;%evalin('base','PowerFeatureNames');
        abs_power = handles.BNCT.abs_power;%evalin('base','abs_power');
    rel_power = handles.BNCT.rel_power;%evalin('base','rel_power');
catch
    PowerFeatures  = [];
    PowerFeatureNames = [];
   abs_power = [];
    rel_power = [];
end


%numfeat = size(
%power_freqrange = evalin('base','power_freqrange');
runval = evalin('base','runval');
SubjectIDs = handles.BNCT.SubjectIDs;%evalin('base','SubjectIDs');
    [TopFeatures FeatureNames featureclass] = gui_createfeatureset(allmeasures,tasklistraw,SubjectIDs,numtimebins,numfreqs,ForcedFeatures,PowerFeatures,PowerFeatureNames,abs_power,rel_power,phenotypelistraw);
    handles.BNCT.TopFeatures = TopFeatures;
    handles.BNCT.AllFeatures = [];
    for pheno = 1:1:size(phenotypelistraw,1)
        handles.BNCT.AllFeatures = [handles.BNCT.AllFeatures;TopFeatures.(phenotypelistraw{pheno})];
    end
    %handles.BNCT.AllFeatures = TopFeatures;
    handles.BNCT.FeatureNames = FeatureNames;
    handles.BNCT.featureclass = featureclass;
    handles.BNCT.TopFeatures.Method = 'Manual';
    assignin('base','BNCT',handles.BNCT);
  %  assignin('base','TopFeatures',TopFeatures);
  %  assignin('base','FeatureNames',FeatureNames);
  %  assignin('base','featureclass',featureclass);
  %  assignin('base','handles',handles);%?????????
  close;
    msgbox('Feature set created!');
    evalin('base',['clear ','runval']);
    
catch
end
else
    evalin('base',['clear ','runval']);
end
%guidata(hObject,handles);


function fisher_choosefeatures_Callback(hObject, eventdata, handles)       
%% Select which types of features to use
gui_choosefeatures;
uiwait;
handles.BNCT = evalin('base','BNCT');
%Use runval flag here?
try %graph_features = evalin('base','graph_features');
    graph_features = handles.BNCT.graph_features;%evalin('base','graph_features');
power_features = handles.BNCT.power_features;%evalin('base','power_features');
power_features(~any(cell2mat(power_features(:,1)),2),:) = [];
features = [graph_features(:,2);power_features(:,2)];
set(handles.fisher_featlist,'string',features);
catch
end
guidata(hObject,handles);


function fisher_featlist_Callback(hObject, eventdata, handles)
%% Listbox of features



function fisher_featlist_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function fishermerit_Callback(hObject, eventdata, handles)
%% Merit selection method (highest, etc)



function fishermerit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fishertopfeat_Callback(hObject, eventdata, handles)
%% Number of features to take



function fishertopfeat_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fisherclassify_Callback(hObject, eventdata, handles)
%% Run fisher score analysis
allmeasures = handles.BNCT.allmeasures;%evalin('base','allmeasures');
tasklistraw = handles.BNCT.config.tasklistraw;%evalin('base','tasklistraw');
SubjectIDs = handles.BNCT.SubjectIDs;%evalin('base','SubjectIDs');
batch_timerange = handles.BNCT.config.batch_timerange;%evalin('base','batch_timerange');
numtimebins = size(batch_timerange,1);
%numtimebins = evalin('base','batch_numtimebins');
try
graph_features = handles.BNCT.graph_features;%evalin('base','graph_features');
power_features = handles.BNCT.power_features;%evalin('base','power_features');
catch
    msgbox('Choose features to use');
end

numfeat = str2num(get(handles.fishertopfeat,'string'));
if isempty(numfeat)
    msgbox('Number of features not specified');
    return
end
freqlabellistraw = handles.BNCT.config.freqlabellistraw;%evalin('base','freqlabellistraw');
numfreqs = length(freqlabellistraw);
%power_freqrange = get(handles.power_freqrange,'value');
phenotypelistraw = handles.BNCT.config.phenotypelistraw;%evalin('base','phenotypelistraw');
freqrangelistraw = handles.BNCT.config.freqrangelistraw;%evalin('base','freqrangelistraw');


try %x = evalin('base','abs_power');
    abs_power = handles.BNCT.abs_power;%evalin('base','abs_power');
    rel_power = handles.BNCT.rel_power;%evalin('base','rel_power');
    CalcPowerFeatures = handles.BNCT.CalcPowerFeatures;%evalin('base','CalcPowerFeatures');
    PowerFeatureNames = handles.BNCT.PowerFeatureNames;%evalin('base','PowerFeatureNames');
catch
    abs_power = [];
    rel_power = [];
    CalcPowerFeatures = [];
    PowerFeatureNames = [];
end

if power_features{1,1} == 1 && isempty(rel_power)
    msgbox('Relative power selected as feature but not yet calculated');
    return
elseif power_features{2,1} == 1 && isempty(abs_power)
    msgbox('Absolute power selected as feature but not yet calculated');
    return
end

comb_method = get(handles.comb_method,'value');
if comb_method == 1
 %   [AllFeatures AffectedTopFeatures TDTopFeatures TopFeatures FeaturesNames] = gui_fisher(allmeasures,tasklistraw,numtimebins,numfreqs,graph_features,power_features,abs_power,rel_power,alphapowertimerange,numfeat,power_freqrange,phenotypelistraw);
    
    [AllFeatures TopFeatures FeatureNames featureclass] = gui_fisher(allmeasures,tasklistraw,numtimebins,numfreqs,graph_features,power_features,abs_power,rel_power,numfeat,phenotypelistraw,CalcPowerFeatures,PowerFeatureNames,freqrangelistraw,batch_timerange);
    
    TopFeatures.Method = 'Individual';
    
 %   msgbox('Top features extracted!');
  %  set(findobj('Tag','Status'),'String','Status: Top features extracted!')
  handles.BNCT.TopFeatures = TopFeatures;
  handles.BNCT.AllFeatures = AllFeatures;
  handles.BNCT.FeatureNames = FeatureNames;
  handles.BNCT.featureclass = featureclass;
  handles.BNCT.selectionmethod = 'Single';
  %  assignin('base','TopFeatures',TopFeatures);
 %   assignin('base','AllFeatures',AllFeatures);
 %   assignin('base','FeatureNames',FeatureNames);
 %   assignin('base','featureclass',featureclass);
  %  assignin('base','selectionmethod','Single');
  assignin('base','BNCT',handles.BNCT);
elseif comb_method == 2
    
    selectedfreqs = get(handles.fisher_freqlist,'value');
    selectedtasks = get(handles.fisher_tasklist,'value');
    
    for pheno = 1:1:length(phenotypelistraw)
        TopFeaturesTemp.(phenotypelistraw{pheno}) = [];
        TopFeaturesTemp.Names = [];
        Temp.(phenotypelistraw{pheno}) = [];
    end
    [TopFeaturesTemp AllFeatures FeatureNames featureclass] = gui_fisher2(allmeasures,tasklistraw,SubjectIDs,numtimebins,numfreqs,graph_features,power_features,abs_power,rel_power,numfeat,selectedfreqs,selectedtasks,phenotypelistraw,CalcPowerFeatures,PowerFeatureNames,freqrangelistraw,batch_timerange);
    
    set(findobj('Tag','Status'),'String','Status: Top features extracted!')
    combinesets = get(handles.combinesets,'value');
    %COMBINE FEATURE SETS IF SELECTED
    if combinesets == 1
        try 
            TopFeatures = handles.BNCT.TopFeatures;%evalin('base','TopFeatures');
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
    handles.BNCT.TopFeatures = TopFeatures;
    handles.BNCT.AllFeatures = AllFeatures;
    handles.BNCT.FeatureNames = FeatureNames;
    handles.BNCT.featureclass = featureclass;
    handles.BNCT.selectionmethod = 'Combo';
  %  assignin('base','TopFeatures',TopFeatures);
  %  assignin('base','AllFeatures',AllFeatures);
  %  assignin('base','FeatureNames',FeatureNames);
   % assignin('base','featureclass',featureclass);
   % assignin('base','selectionmethod','Combo');

end
assignin('base','runval',1);
%assignin('base','numfeat',numfeat);
handles.BNCT.numfeat = numfeat;
assignin('base','BNCT',handles.BNCT);
guidata(hObject,handles);
close;


function fisher_tasklist_Callback(hObject, eventdata, handles)
%% Listbox of tasks



function fisher_tasklist_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fisher_freqlist_Callback(hObject, eventdata, handles)
%% Listbox of freqs



function fisher_freqlist_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cancel_Callback(hObject, eventdata, handles)
%% --- Executes on button press in cancel.
assignin('base','runval',0);
close;



function showresults_Callback(hObject, eventdata, handles)
%% --- Executes on button press in showresults.
