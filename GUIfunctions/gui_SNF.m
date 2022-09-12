function varargout = gui_SNF(varargin)
% GUI_SNF MATLAB code for gui_SNF.fig
%      GUI_SNF, by itself, creates a new GUI_SNF or raises the existing
%      singleton*.
%
%      H = GUI_SNF returns the handle to a new GUI_SNF or the handle to
%      the existing singleton*.
%
%      GUI_SNF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SNF.M with the given input arguments.
%
%      GUI_SNF('Property','Value',...) creates a new GUI_SNF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_SNF_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_SNF_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_SNF

% Last Modified by GUIDE v2.5 13-Apr-2016 14:52:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_SNF_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_SNF_OutputFcn, ...
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



function gui_SNF_OpeningFcn(hObject, eventdata, handles, varargin)
%% --- Executes just before gui_SNF is made visible.

% Choose default command line output for gui_SNF
handles.output = hObject;
set(handles.fTEAG,'val',1);
set(handles.sTEAG,'val',0);
set(findobj('Tag','text_observations'),'String','Phenotype')
set(findobj('Tag','text_features'),'String','Feature Range/Indices')
set(findobj('Tag','text_channels'),'visible','off')
set(handles.channels,'visible','off');
set(findobj('Tag','text_phenotask'),'visible','off')
set(handles.phenotask_col,'visible','off');
handles.listspreadsheet = [];
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_SNF wait for user response (see UIRESUME)
% uiwait(handles.figure1);



function varargout = gui_SNF_OutputFcn(hObject, eventdata, handles) 
%% --- Outputs from this function are returned to the command line.
varargout{1} = handles.output;



function load_spreadsheet_Callback(hObject, eventdata, handles)
%% --- Executes on button press in load_spreadsheet.
[file, path, filterindex] = uigetfile('*.xls;*.xlsx','Load Spreadsheet');

if file == 0
else 
    [num, txt, handles.raw] = xlsread(strcat(path,file),1);
    set(handles.uitable1,'Data',handles.raw)
    handles.listspreadsheet = [handles.listspreadsheet;{strcat(path,file)}];
    set(handles.spreadsheet_list,'string',handles.listspreadsheet);
    handles.sheetnum = 1;
    [status, sheets, format] = xlsfinfo(strcat(path,file));
    set(handles.sheet_list,'string',sheets);
    set(handles.spreadsheet_list,'val',size(handles.listspreadsheet,1));
    set(handles.sheet_list,'val',1);
end

guidata(hObject, handles);

function filename_Callback(hObject, eventdata, handles)
%%



function filename_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pheno_range_Callback(hObject, eventdata, handles)
%%

function pheno_range_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function task_range_Callback(hObject, eventdata, handles)
%%


function task_range_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function feature_range_Callback(hObject, eventdata, handles)
%%


function feature_range_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function channels_Callback(hObject, eventdata, handles)
%%


function channels_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function dataset_name_Callback(hObject, eventdata, handles)
%%


function dataset_name_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function add_Callback(hObject, eventdata, handles)
%% --- Executes on button press in add.
%[~,idx]=unique(strcat(num2str(cell2mat(handles.raw(2:end,1))),handles.raw(2:end,2)),'rows');
phenos = get(handles.pheno_range,'string');
task = get(handles.task_range,'string');
feature = str2num(get(handles.feature_range,'string'));
channel = str2num(get(handles.channels,'string'));
datasetname = get(handles.dataset_name,'string');
c=1;
if strfind(phenos,',');
    rem = phenos;
    while strfind(rem,',')
        [tok2,rem]=strtok(rem,',');
        pheno{c} = tok2;
        c=c+1;
    end
else
    pheno{c} = phenos;
end
%{
[~,idx]=unique(strcat(num2str(cell2mat(handles.raw(2:end,1)))),'rows');
raw_temp =  handles.raw(idx,:);
id = raw_temp(:,1:2);

for n=size(id,1):-1:1
    if strcmp(id{n,2},pheno)==0
        id(n,:)=[];
    end
end
%}
data=[];
featindex = 0;
if get(handles.sTEAG,'val') == 1 %sTEAG
    for c = 1:length(channel)
        count = 1;
        for i = 1:size(handles.raw,1)
            if handles.raw{i,4} == channel(c) & any(strcmp(handles.raw{i,2},pheno))==1 & strcmp(handles.raw{i,5},task)==1
                newfeatures = [handles.raw{i,feature}];
                for f = 1:length(newfeatures)
                    data(count,featindex+f) = newfeatures(f);
                    id{count,featindex+f} = handles.raw{i,1};
                    class_temp = strcmp(handles.raw{i,2},pheno);
                    class{count} = find(class_temp == 1);
                end
                count = count+1;
            end
        end
        featindex = length(newfeatures);
    end
elseif get(handles.fTEAG,'val') == 1 %fTEAG
    count = 1;
    for i = 1:size(handles.raw,1)
        if any(strcmp(handles.raw{i,3},pheno))==1 & strcmp(handles.raw{i,2},task)==1
            newfeatures = [handles.raw{i,feature}];
            for f = 1:length(newfeatures)
                data(count,f) = newfeatures(f);
                id{count,f} = handles.raw{i,1};
                class_temp = strcmp(handles.raw{i,3},pheno);
                class{count} = find(class_temp == 1);
            end
            count = count+1;
        end
    end
    channel = [];
elseif get(handles.othercustom,'val') == 1
    count = 1;
    idphenotask = get(handles.phenotask_col,'string');
    idphenotask = str2num(idphenotask);
    for i = 1:size(handles.raw,1)
        if any(strcmp(handles.raw{i,idphenotask(2)},pheno))==1 %& strcmp(handles.raw{i,idphenotask(3)},task)==1
            newfeatures = [handles.raw{i,feature}];
            for f = 1:length(newfeatures)
                data(count,f) = newfeatures(f);
                id{count,f} = handles.raw{i,idphenotask(1)};
                class_temp = strcmp(handles.raw{i,idphenotask(2)},pheno);
                class{count} = find(class_temp == 1);
            end
            count = count+1;
        end
    end
    channel = [];
    task = [];
end

handles.datasets.(datasetname).data = data;
handles.datasets.(datasetname).phenotype = phenos;
handles.datasets.(datasetname).task = task;
handles.datasets.(datasetname).feature = {handles.raw{1,feature}};
handles.datasets.(datasetname).feature_indices = get(handles.feature_range,'string');
handles.datasets.(datasetname).channels = channel;
handles.datasets.(datasetname).ids = id;
handles.datasets.(datasetname).class = class';
if get(handles.fTEAG,'val') == 1
    handles.datasets.(datasetname).filetype = 'fTEAG';
elseif get(handles.sTEAG,'val') == 1
    handles.datasets.(datasetname).filetype = 'sTEAG';
elseif get(handles.othercustom,'val') == 1
    handles.datasets.(datasetname).filetype = 'othercustom';
end



dataset_list =  get(handles.dataset_list,'string');
if any(cell2mat(strfind(dataset_list,datasetname)))
else
    dataset_list = [dataset_list;{datasetname}];
    set(handles.dataset_list,'string',dataset_list);
end
guidata(hObject, handles);

function remove_Callback(hObject, eventdata, handles)
%% --- Executes on button press in remove.
dataset_list = get(handles.dataset_list,'string');
dataset_val = get(handles.dataset_list,'val');
datasetname = dataset_list{dataset_val};
handles.datasets.(datasetname) = [];

dataset_list(dataset_val) = [];
set(handles.dataset_list,'string',dataset_list);
set(handles.dataset_list,'val',1);
guidata(hObject, handles);


function zscore_Callback(hObject, eventdata, handles)
%% --- Executes on button press in zscore.


function dataset_list_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in dataset_list.
dataset_list = get(handles.dataset_list,'string');
dataset_val = get(handles.dataset_list,'val');
if size(dataset_val,2)==1
set(handles.pheno_range,'string',handles.datasets.(dataset_list{dataset_val}).phenotype);
set(handles.task_range,'string',handles.datasets.(dataset_list{dataset_val}).task);
set(handles.feature_range,'string',handles.datasets.(dataset_list{dataset_val}).feature_indices);
set(handles.channels,'string',num2str(handles.datasets.(dataset_list{dataset_val}).channels));
set(handles.dataset_name,'string',dataset_list{dataset_val});
switch handles.datasets.(dataset_list{dataset_val}).filetype
    case 'fTEAG'
        set(handles.fTEAG,'val',1);
        set(handles.sTEAG,'val',0);
        set(handles.othercustom,'val',0);
    case 'sTEAG'
        set(handles.fTEAG,'val',0);
        set(handles.sTEAG,'val',1); %UPDATE WITH OTHERCUSTOM
        set(handles.othercustom,'val',0);   
    case 'othercustom'
        set(handles.fTEAG,'val',0);
        set(handles.sTEAG,'val',0);
        set(handles.othercustom,'val',1);        
end
end

function dataset_list_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function view_dataset_Callback(hObject, eventdata, handles)
%% --- Executes on button press in view_dataset.
dataset_list = get(handles.dataset_list,'string');
dataset_val = get(handles.dataset_list,'val');
datasetname = dataset_list{dataset_val};
f = figure;
t = uitable(f,'Data',handles.datasets.(datasetname).data,'ColumnWidth',{50});

function run_snf_Callback(hObject, eventdata, handles)
%% --- Executes on button press in run_snf.
dataset_list = get(handles.dataset_list,'string');
dataset_val = get(handles.dataset_list,'val');
zscore = get(handles.zscore,'val');
K = 20;%number of neighbors, usually (10~30)
alpha = 0.5; %hyperparameter, usually (0.3~0.8)
T = 20; %Number of Iterations, usually (10~20)

%If the data are all continuous values, we recommend the users to perform standard normalization before using SNF, though it is optional depending on the data the users want to use. 
%if zscore==1
ref_ids = handles.datasets.(dataset_list{dataset_val(1)}).ids;
label = cell2mat(handles.datasets.(dataset_list{dataset_val(1)}).class);
    for d = 1:size(dataset_val,2)
        data = handles.datasets.(dataset_list{dataset_val(d)}).data;
        data_ids = handles.datasets.(dataset_list{dataset_val(d)}).ids;
        data_mean = mean(data);
        data_std = std(data);
        for i = 1:1:size(data,1) %rows
            for j = 1:1:size(data,2); %cols
                if zscore == 1
                    data_zscore_temp{d}(i,j) = (data(i,j) - data_mean(j))/data_std(j);
                else
                    data_zscore_temp{d}(i,j) = data(i,j);
                end
            end
            %Match/reorganize respective subject data between data matrices
            if ischar(data_ids{i,1})
                index = find(strcmp(data_ids{i,1},ref_ids(:,1)));
            else
                index = find([ref_ids{:,1}] == data_ids{i,1});
            end
            if size(dataset_val,2)>1
                datasize = size(ref_ids(:,1),1) - size(data_ids(:,1),1);
            else
                datasize = 0;
            end
            if isempty(index) || datasize ~= 0
                msgbox(horzcat('Nonmatching IDs used'));
            end
            data_zscore{d}(index,:) = data_zscore_temp{d}(i,:);
            
        end
        
        dist{d} = dist2(data_zscore{d},data_zscore{d}); %correct??? Same as what they used though..
        W_sim{d} = affinityMatrix(dist{d},K,alpha);
        %label = ones(size(data,1),1);
        displayClusters(W_sim{d},label);
    end
%end

%Data1 = [FI_N400_Zscore_ASD];Data2 = [FU_N170_Zscore_ASD];
%Data1 = [FI_N400_Zscore_TD];Data2 = [FU_N170_Zscore_TD];
%Data1 = Standard_Normalization(data1);
%Data2 = Standard_Normalization(data2);

%%%Calculate the pair-wise distance; If the data is continuous, we recommend to use the function "dist2" as follows;
%if the data is discrete, we recommend the users to use chi-square distance
%Dist1 = dist2(Data1,Data1); %Distance between N vectors of M-dimensions (Data1 = NxM matrix)
%Dist2 = dist2(Data2,Data2);

%%%next, construct similarity graphs
%W1 = affinityMatrix(Dist1, K, alpha);
%W2 = affinityMatrix(Dist2, K, alpha);
%asd_label = ones(size(FU_N170_ASD,1),1);
%td_label = ones(size(FU_N170_TD,1),1);
%label = ones(size(data,1),1);%[asd_label];
%%% These similarity graphs have complementary information about clusters.
%displayClusters(W1,label);
%displayClusters(W2,label);

%next, we fuse all the graphs
% then the overall matrix can be computed by similarity network fusion(SNF):
if d > 1
    W = SNF(W_sim, K, T);
else
    W = SNF({W_sim{1},W_sim{1}}, K, T);
end
%%%%With this unified graph W of size n x n, you can do either spectral clustering or Kernel NMF. If you need help with further clustering, please let us know. 
%%for example, spectral clustering
C = get(handles.numclusters,'string');%%%number of clusters
C = str2num(C);
group = SpectralClustering(W,C);%%%the final subtypes information

%%%you can evaluate the goodness of the obtained clustering results by calculate Normalized mutual information (NMI): if NMI is close to 1, it indicates that the obtained clustering is very close to the "true" cluster information; if NMI is close to 0, it indicates the obtained clustering is not similar to the "true" cluster information.

displayClusters(W,group);

SNFNMI = Cal_NMI(group, label)


%%%you can also find the concordance between each individual network and the fused network
ConcordanceMatrix = Concordance_Network_NMI({W,W_sim{:}},C)


%%%Here we provide two ways to estimate the number of clusters. Note that,
%%%these two methods cannot guarantee the accuracy of esstimated number of
%%%clusters, but just to offer two insights about the datasets.

[K1, K2, K12,K22] = Estimate_Number_of_Clusters_given_graph(W, [2:5]);
fprintf('The best number of clusters according to eigengap is %d\n', K1);
fprintf('The best number of clusters according to rotation cost is %d\n', K2);

handles.W = W;
%else
%    handles.W = W_sim;
%end

%Write to Gephi
guidata(hObject, handles);
gephi_val = get(handles.export_to_gephi,'val');
if gephi_val == 1
    [file,path] = uiputfile('*.csv','Export for Gephi');
    if file ~= 0
        file_temp = strrep(file,'.csv',[]);
        NODEFILE = strcat(path,file_temp,'_NODE.csv');
        EDGEFILE = strcat(path,file_temp,'_EDGE.csv');
        gui_gephiconvert(handles.W{1,1},handles.datasets.(dataset_list{dataset_val(1)}).ids,NODEFILE,EDGEFILE);
        msgbox('SNF data exported');
    end
    %
end


function export_to_gephi_Callback(hObject, eventdata, handles)
%% --- Executes on button press in export_to_gephi.


function sTEAG_Callback(hObject, eventdata, handles)
%% --- Executes on button press in sTEAG.
set(handles.sTEAG,'val',1);
set(handles.fTEAG,'val',0);
set(handles.othercustom,'val',0);
set(findobj('Tag','text_observations'),'String','Phenotype')
set(findobj('Tag','text_features'),'String','Feature Range/Indices')
set(findobj('Tag','text_channels'),'visible','on')
set(handles.channels,'visible','on');
set(findobj('Tag','text_phenotask'),'visible','off')
set(handles.phenotask_col,'visible','off');

function fTEAG_Callback(hObject, eventdata, handles)
%% --- Executes on button press in fTEAG.
set(handles.fTEAG,'val',1);
set(handles.sTEAG,'val',0);
set(handles.othercustom,'val',0);
set(findobj('Tag','text_observations'),'String','Phenotype')
set(findobj('Tag','text_features'),'String','Feature Range/Indices')
set(findobj('Tag','text_channels'),'visible','off')
set(handles.channels,'visible','off');
set(findobj('Tag','text_phenotask'),'visible','off')
set(handles.phenotask_col,'visible','off');

function othercustom_Callback(hObject, eventdata, handles)
%% --- Executes on button press in othercustom.
set(handles.fTEAG,'val',0);
set(handles.sTEAG,'val',0);
set(handles.othercustom,'val',1);
set(findobj('Tag','text_observations'),'String','Phenotype')
set(findobj('Tag','text_features'),'String','Feature Range/Indices')
set(findobj('Tag','text_channels'),'visible','off')
set(handles.channels,'visible','off');
set(findobj('Tag','text_phenotask'),'visible','on')
set(handles.phenotask_col,'visible','on');

function spreadsheet_list_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in spreadsheet_list.
files = get(hObject,'string');
fileval = get(hObject,'val');
[num, txt, handles.raw] = xlsread(files{fileval},1);
set(handles.uitable1,'Data',handles.raw)
[status, sheets, format] = xlsfinfo(files{fileval});
set(handles.sheet_list,'string',sheets);
set(handles.sheet_list,'val',1);
guidata(hObject, handles);

function spreadsheet_list_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function phenotask_col_Callback(hObject, eventdata, handles)
%%

guidata(hObject, handles);
function phenotask_col_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%{
function sheet_left_Callback(hObject, eventdata, handles)
%% --- Executes on button press in sheet_left.
fileval = get(handles.spreadsheet_list,'val');
filename = handles.listspreadsheet{fileval};
try
    [num, txt, handles.raw] = xlsread(filename,handles.sheetnum-1);
    handles.sheetnum = handles.sheetnum-1;
    [status, sheets, format] = xlsfinfo(filename);
    set(findobj('Tag','currentsheet'),'String',horzcat('Current Sheet: ',sheets{handles.sheetnum}))
catch
end
set(handles.uitable1,'Data',handles.raw)
guidata(hObject, handles);

function sheet_right_Callback(hObject, eventdata, handles)
%% --- Executes on button press in sheet_right.
fileval = get(handles.spreadsheet_list,'val');
filename = handles.listspreadsheet{fileval};
try
    [num, txt, handles.raw] = xlsread(filename,handles.sheetnum+1);
    handles.sheetnum = handles.sheetnum+1;
    [status, sheets, format] = xlsfinfo(filename);
    set(findobj('Tag','currentsheet'),'String',horzcat('Current Sheet: ',sheets{handles.sheetnum}))
catch
end
set(handles.uitable1,'Data',handles.raw)
guidata(hObject, handles);
%}


function sheet_list_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in sheet_list.
fileval = get(handles.spreadsheet_list,'val');
filename = handles.listspreadsheet{fileval};
sheet_val = get(hObject,'val');
try
    [num, txt, handles.raw] = xlsread(filename,sheet_val);
    set(handles.uitable1,'Data',handles.raw)
catch
end
guidata(hObject, handles);

function sheet_list_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numclusters_Callback(hObject, eventdata, handles)
%%


function numclusters_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
