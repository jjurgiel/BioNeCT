function varargout = gui_runclassifier(varargin)
%% GUI_RUNCLASSIFIER MATLAB code for gui_runclassifier.fig
%      GUI_RUNCLASSIFIER, by itself, creates a new GUI_RUNCLASSIFIER or raises the existing
%      singleton*.
%
%      H = GUI_RUNCLASSIFIER returns the handle to a new GUI_RUNCLASSIFIER or the handle to
%      the existing singleton*.
%
%      GUI_RUNCLASSIFIER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_RUNCLASSIFIER.M with the given input arguments.
%
%      GUI_RUNCLASSIFIER('Property','Value',...) creates a new GUI_RUNCLASSIFIER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_runclassifier_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_runclassifier_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_runclassifier

% Last Modified by GUIDE v2.5 08-Sep-2015 16:33:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_runclassifier_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_runclassifier_OutputFcn, ...
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



function gui_runclassifier_OpeningFcn(hObject, eventdata, handles, varargin)
%% --- Executes just before gui_runclassifier is made visible.
%This function has no output args, see OutputFcn.
% varargin   command line arguments to gui_runclassifier (see VARARGIN)

% Choose default command line output for gui_runclassifier
handles.output = hObject;
handles.BNCT = evalin('base','BNCT');
% Update handles structure

tasklistraw = handles.BNCT.config.tasklistraw;%evalin('base','tasklistraw');
tasklist = handles.BNCT.config.tasklist;
freqlabellistraw = handles.BNCT.config.freqlabellistraw;%evalin('base','freqlabellistraw');
phenotypelistraw = handles.BNCT.config.phenotypelistraw;
set(handles.svm_freqlist,'string',freqlabellistraw);
set(handles.svm_tasklist,'string',tasklistraw);
selectionmethod = handles.BNCT.selectionmethod;%evalin('base','selectionmethod');
try
if ~isempty(handles.BNCT.removesubjects)
    for i=1:length(handles.BNCT.removesubjects)
        subnum = handles.BNCT.removesubjects(i);
        phenonum = strmatch(handles.BNCT.raw(subnum,7),phenotypelistraw);
        tasknum = strmatch(handles.BNCT.raw(subnum,9),tasklistraw);
        handles.remove{i,1} = phenonum;
        handles.remove{i,2} = tasknum;
        handles.remove{i,3} = strmatch(handles.BNCT.raw(subnum,8),handles.BNCT.SubjectIDs.(phenotypelistraw{phenonum}).(tasklist{tasknum}));
        %handles.RemoveSubjects{i,1} = handles.BNCT.raw(subnum,7);
        %handles.RemoveSubjects{i,2} = handles.BNCT.raw(subnum,8);
        %handles.RemoveSubjects{i,3} = handles.BNCT.raw(subnum,9);
        
        %May need indices for pheno/task/subID?

        %(strfind(BNCT.config.tasklist,subtask))
        %(strfind(BNCT.SubjectIDs.,subID))
    end
else
    handles.remove = [];
end
catch
    handles.remove = [];
end
switch selectionmethod
    case 'Single'
        set(handles.svm_tasklist,'enable','on');
        set(handles.svm_freqlist,'enable','on');
    case 'Combo'
        set(handles.svm_tasklist,'enable','off');
        set(handles.svm_freqlist,'enable','off');
    case 'Manual'
        set(handles.svm_tasklist,'enable','off');
        set(handles.svm_freqlist,'enable','off');
end
try
    svm = handles.BNCT.svm;%evalin('base','svm');
    set(handles.holdout,'string',num2str(svm.holdout_ratio));
    set(handles.classifier_type,'value',svm.methodnum);
    set(handles.svmdimmethod,'value',svm.dim_methodnum);
    set(handles.svmfolds,'string',num2str(svm.folds));
    set(handles.train_pct,'string',num2str(svm.train_pct));
    set(handles.numsubjects,'string',num2str(svm.tst_no));
    
    switch svm.methodnum
    case 1
        set(handles.holdout,'enable','on');
        set(handles.svmfolds,'enable','off');
        set(handles.train_pct,'enable','off');
    case 2
        set(handles.holdout,'enable','off');
        set(handles.svmfolds,'enable','on');
        set(handles.train_pct,'enable','off');
    case 3
        set(handles.holdout,'enable','off');
        set(handles.svmfolds,'enable','off');
        set(handles.train_pct,'enable','on');
    end
catch
    set(handles.svmfolds,'enable','off');
    set(handles.train_pct,'enable','off');
end
% UIWAIT makes gui_runclassifier wait for user response (see UIRESUME)
% uiwait(handles.figure1);
guidata(hObject, handles);



function varargout = gui_runclassifier_OutputFcn(hObject, eventdata, handles) 
%% --- Outputs from this function are returned to the command line.
% varargout  cell array for returning output args (see VARARGOUT);

% Get default command line output from handles structure
varargout{1} = handles.output;



function numsubjects_Callback(hObject, eventdata, handles)
%%



function numsubjects_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function holdout_Callback(hObject, eventdata, handles)
%%


function holdout_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function svmfolds_Callback(hObject, eventdata, handles)
%%



function svmfolds_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function svmdimmethod_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in svmdimmethod.



function svmdimmethod_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function svmclassify_Callback(hObject, eventdata, handles)
%% --- Executes on button press in svmclassify.
tasklist = handles.BNCT.config.tasklistraw;%evalin('base','tasklistraw');
freqlist = handles.BNCT.config.freqlabellistraw;%evalin('base','freqlabellistraw');
batch_freqlabel = handles.BNCT.config.freqlabellistraw;%evalin('base','freqlabellistraw'); %used to be batch_freqlabel
svm_freqlist = get(handles.svm_freqlist,'value');
svm_tasklist = get(handles.svm_tasklist,'value');

holdout_ratio = str2num(get(handles.holdout,'string'));
svmfolds = str2num(get(handles.svmfolds,'string'));
tst_no = str2num(get(handles.numsubjects,'string'));
svmdimmethod = get(handles.svmdimmethod,'value');
train_pct = get(handles.train_pct,'string');
%handles.BNCT.train_pct = train_pct;
%assignin('base','BNCT',handles.BNCT); %Need train_pct?
%assignin('base','train_pct',train_pct);
train_pct = str2num(train_pct);

classifier_list = cellstr(get(handles.classifier_type,'string'));
classifier_sel = get(handles.classifier_type,'value');
method = classifier_list{classifier_sel};


%%                  ADD TO HERE FOR DROP DOWN MENU
if svmdimmethod == 1
    dim_method = 'none';
elseif svmdimmethod == 2
    dim_method = 'PCA';
end

svm.holdout_ratio = holdout_ratio;
svm.folds = svmfolds;
svm.tst_no = tst_no;
svm.dim_method = dim_method;
svm.dim_methodnum = svmdimmethod;
svm.train_pct = train_pct;
svm.method = method;
svm.methodnum = classifier_sel;
handles.BNCT.svm = svm;
assignin('base','BNCT',handles.BNCT);
%assignin('base','svm',svm);
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
    for h = 1:1:size(batch_freqlabel,1)%length(batch_freqlabel)
        svm_combos(h,k) = svm_task(k)*svm_freq(h);
    end
end
[row, col] = find(svm_combos);


freqfields = handles.BNCT.config.freqlabellistraw;%evalin('base','freqlabellistraw');%batch_freqlabel

%%
warning off
disp('Running SVM classification...');
%%  RUN CLASSIFICATION ON ALL SINGLE COMBINATIONS OF TASK+FREQ SELECTED

%comb_method = get(handles.comb_method,'value');
selectionmethod = handles.BNCT.selectionmethod;%evalin('base','selectionmethod');
TopFeatures = handles.BNCT.TopFeatures;%evalin('base','TopFeatures');
phenotypelistraw = handles.BNCT.config.phenotypelistraw;%evalin('base','phenotypelistraw');

if strcmp(selectionmethod,'Single')%comb_method == 1
    taskfields = fieldnames(TopFeatures.(phenotypelistraw{1}));
    h = waitbar(0,'Running SVM Classification...');
    for i = 1:1:length(row)
        tmp_svm_fold=0; tmp_sens=0; tmp_spec=0;
        for t=1:tst_no
            %%????????????????????????????????????????????????????????????????????
            %MAYBE JUST PLUG IN TOPFEATURES AND HANDLE INSIDE INCASE > 2 GROUPS
            %i.e. topfeatures input along with class labels for each
            %instance
            %?????????????????????????????????????????????????????????????????????
            group1_features = TopFeatures.(phenotypelistraw{1}).(taskfields{col(i)}){1,row(i)};
            group2_features = TopFeatures.(phenotypelistraw{2}).(taskfields{col(i)}){1,row(i)};
            g1 = group1_features;
            g2 = group2_features;
            if ~isempty(handles.remove)
                for h=1:size(handles.remove,1)
                    %If current task loop matches one that needs sub
                    %removed
                    if handles.remove{h,2} == col(i)
                        if handles.remove{h,1} == 1
                            group1_features(handles.remove{h,3},:) = NaN;
                        elseif handles.remove{h,1} == 2
                            group2_features(handles.remove{h,3},:) = NaN;
                        end
                    else
                    end
                end
            end
            
            group1_features = group1_features(~isnan(group1_features(:,1)),:);
            group2_features =  group2_features(~isnan(group2_features(:,1)),:);
            %Could switch group1 and group2 to compensate for true positive
            %condition/etc
    %        [ svm_ratio conMat sens spec]=gui_svm_classification(handles.BNCT,handles.remove,method,TopFeatures.(phenotypelistraw{1}).(taskfields{col(i)}){1,row(i)},TopFeatures.(phenotypelistraw{2}).(taskfields{col(i)}){1,row(i)},svmfolds,dim_method,holdout_ratio,train_pct);
            [ svm_ratio conMat sens spec]=gui_svm_classification(handles.BNCT,handles.remove,method,group1_features,group2_features,svmfolds,dim_method,holdout_ratio,train_pct);

            tmp_svm_fold=svm_ratio+tmp_svm_fold;
            tmp_sens = sens + tmp_sens;
            tmp_spec = spec + tmp_spec;
            if isnan(spec)
                x=1;
            end
         %   svm_acc(t) = svm_ratio;
        end
       % x=tmp_svm_fold/tst_no;
       % y = mean(svm_acc);
        Results{row(i),col(i)} = num2str(tmp_svm_fold/tst_no);
        sensi{row(i),col(i)} = num2str(100*(tmp_sens/tst_no));
        speci{row(i),col(i)} = num2str(100*(tmp_spec/tst_no));
        disp('============================');
        disp(horzcat('Task: ',tasklist{col(i)},', Frequency Band: ',freqfields{row(i)}));
        disp(horzcat('Average classification accuracy after ',num2str(tst_no),' runs: ',num2str(tmp_svm_fold/tst_no),'%'));
        disp(horzcat('Sensitivity: ',sensi{row(i),col(i)},'%'));
        disp(horzcat('Specificity: ',speci{row(i),col(i)},'%'));
        waitbar(i/length(row),h);  
    end
    close(h);
elseif strcmp(selectionmethod,'Combo')%comb_method == 2
        tmp_svm_fold=0; tmp_sens=0; tmp_spec=0;
        h = waitbar(0,'Running SVM Classification...');
        for t=1:tst_no
            [ svm_ratio conMat sens spec]=gui_svm_classification(handles.BNCT,handles.remove,method,cell2mat(TopFeatures.(phenotypelistraw{1})(:,2:end)),cell2mat(TopFeatures.(phenotypelistraw{2})(:,2:end)),svmfolds,dim_method,holdout_ratio,train_pct);
            tmp_svm_fold=svm_ratio+tmp_svm_fold;
            tmp_sens = sens + tmp_sens;
            tmp_spec = spec + tmp_spec;
            waitbar(t/tst_no,h);  
        end
        close(h);
        Results = num2str(tmp_svm_fold/tst_no);
        sensi = num2str(tmp_sens/tst_no);
        speci = num2str(tmp_spec/tst_no);
        disp('============================');
        disp(horzcat('Average classification accuracy after ',num2str(tst_no),' runs: ',num2str(tmp_svm_fold/tst_no),'%'));
        disp(horzcat('Sensitivity: ',sensi,'%'));
        disp(horzcat('Specificity: ',speci,'%'));
             
elseif strcmp(selectionmethod,'Manual')%comb_method == 3
        tmp_svm_fold=0; tmp_sens=0; tmp_spec=0;
        h = waitbar(0,'Running SVM Classification...');
        for t=1:tst_no %cell2mat removed from TopFeatures
            [ svm_ratio conMat sens spec]=gui_svm_classification(handles.BNCT,handles.remove,method,cell2mat(TopFeatures.(phenotypelistraw{1})(:,2:end)),cell2mat(TopFeatures.(phenotypelistraw{2})(:,2:end)),svmfolds,dim_method,holdout_ratio,train_pct);
            tmp_svm_fold=svm_ratio+tmp_svm_fold;
            tmp_sens = sens + tmp_sens;
            tmp_spec = spec + tmp_spec;
            waitbar(t/tst_no,h);  
        end
        close(h);
        Results = num2str(tmp_svm_fold/tst_no); 
        sensi = num2str(100*tmp_sens/tst_no);
        speci = num2str(100*tmp_spec/tst_no);
        disp('============================');
        disp(horzcat('Average classification accuracy after ',num2str(tst_no),' runs: ',num2str(tmp_svm_fold/tst_no),'%'));
        disp(horzcat('Sensitivity: ',sensi,'%'));
        disp(horzcat('Specificity: ',speci,'%'));
end
    
%%
handles.BNCT.Results = Results;
handles.BNCT.sensi = sensi;
handles.BNCT.speci = speci;
%assignin('base','Results',Results);
%assignin('base','sensi',sensi);
%assignin('base','speci',speci);
assignin('base','BNCT',handles.BNCT);
assignin('base','runval',1);
close;


function svm_tasklist_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in svm_tasklist.



function svm_tasklist_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function svm_freqlist_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in svm_freqlist.



function svm_freqlist_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
%
assignin('base','runval',0);
close;


% --- Executes on selection change in classifier_type.
function classifier_type_Callback(hObject, eventdata, handles)
val = get(hObject,'value');
switch val
    case 1
        set(handles.holdout,'enable','on');
        set(handles.svmfolds,'enable','off');
        set(handles.train_pct,'enable','off');
    case 2
        set(handles.holdout,'enable','off');
        set(handles.svmfolds,'enable','on');
        set(handles.train_pct,'enable','off');
    case 3
        set(handles.holdout,'enable','off');
        set(handles.svmfolds,'enable','off');
        set(handles.train_pct,'enable','on');
end


% --- Executes during object creation, after setting all properties.
function classifier_type_CreateFcn(hObject, eventdata, handles)
%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function train_pct_Callback(hObject, eventdata, handles)
%



function train_pct_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
