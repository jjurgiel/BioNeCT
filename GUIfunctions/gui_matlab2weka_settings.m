function varargout = gui_matlab2weka_settings(varargin)
% GUI_MATLAB2WEKA_SETTINGS MATLAB code for gui_matlab2weka_settings.fig
%      GUI_MATLAB2WEKA_SETTINGS, by itself, creates a new GUI_MATLAB2WEKA_SETTINGS or raises the existing
%      singleton*.
%
%      H = GUI_MATLAB2WEKA_SETTINGS returns the handle to a new GUI_MATLAB2WEKA_SETTINGS or the handle to
%      the existing singleton*.
%
%      GUI_MATLAB2WEKA_SETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_MATLAB2WEKA_SETTINGS.M with the given input arguments.
%
%      GUI_MATLAB2WEKA_SETTINGS('Property','Value',...) creates a new GUI_MATLAB2WEKA_SETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_matlab2weka_settings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_matlab2weka_settings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_matlab2weka_settings

% Last Modified by GUIDE v2.5 11-Feb-2016 10:24:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_matlab2weka_settings_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_matlab2weka_settings_OutputFcn, ...
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


% --- Executes just before gui_matlab2weka_settings is made visible.
function gui_matlab2weka_settings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_matlab2weka_settings (see VARARGIN)

% Choose default command line output for gui_matlab2weka_settings
handles.output = hObject;
handles.BNCT = evalin('base','BNCT');
handles.foldersuffix = handles.BNCT.configfilename.path;
handles.filenamesuffix = strrep(handles.BNCT.configfilename.file,'.mat',[]);
handles.filenameappend = date;
handles.fullfilename = horzcat(handles.foldersuffix,handles.filenamesuffix,'_(File specific info)_',handles.filenameappend);
set(findobj('Tag','filename'),'String',handles.fullfilename);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_matlab2weka_settings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_matlab2weka_settings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function which_features_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in which_features.



function which_features_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filenameformat_Callback(hObject, eventdata, handles)
%%
handles.filenameappend = get(hObject,'string');
if isempty(handles.filenameappend)
    handles.filenameappend = date;
end
    
handles.fullfilename = horzcat(handles.foldersuffix,handles.filenamesuffix,'_(File specific info)_',handles.filenameappend);
set(findobj('Tag','filename'),'String',handles.fullfilename);

function filenameformat_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties. 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function export_Callback(hObject, eventdata, handles)
%% --- Executes on button press in export.

which_features = get(handles.which_features,'val');

fileinfo.foldersuffix = handles.BNCT.configfilename.path;
fileinfo.filenamesuffix = strrep(handles.BNCT.configfilename.file,'.mat',[]);
fileinfo.filenameappend = get(handles.filenameformat,'string');
if isempty(fileinfo.filenameappend)
    fileinfo.filenameappend = date;
end

if which_features == 1
    data = handles.BNCT.AllFeatures;
else
    data = handles.BNCT.TopFeatures;
end

switch handles.BNCT.TopFeatures.Method
    case 'Individual'
        h = waitbar(0,'Exporting weka files...');
        iter = 0;
        for task = 1:1:size(handles.BNCT.config.tasklistraw,1)
            for freq = 1:1:size(handles.BNCT.config.freqrangelistraw,1)
                if which_features == 1 %All Features
                    filename=horzcat(fileinfo.foldersuffix,fileinfo.filenamesuffix,'_Indiv_All_Features_',handles.BNCT.config.tasklistraw{task},'_',handles.BNCT.config.freqlabellistraw{freq},'_',fileinfo.filenameappend,'.arff');
                    data = [handles.BNCT.AllFeatures.(handles.BNCT.config.tasklist{task}){1,freq} handles.BNCT.featureclass{task}];
                    featureNames = [handles.BNCT.FeatureNames.(handles.BNCT.config.tasklist{task}){1,freq} 'Group'];                    
                elseif which_features == 2 %Top Features
                    filename=horzcat(fileinfo.foldersuffix,fileinfo.filenamesuffix,'_Indiv_Top_Features_',handles.BNCT.config.tasklistraw{task},'_',handles.BNCT.config.freqlabellistraw{freq},'_',fileinfo.filenameappend,'.arff');
                    data=[];
                    for pheno = 1:1:size(handles.BNCT.config.phenotypelistraw,1)
                        data = [data;handles.BNCT.TopFeatures.(handles.BNCT.config.phenotypelistraw{pheno}).(handles.BNCT.config.tasklist{task}){1,freq}];
                    end
                    data = [data handles.BNCT.featureclass{task}];
                    featureNames = [handles.BNCT.TopFeatures.Names.(handles.BNCT.config.tasklist{task}){1,freq} 'Group'];
                end
                gui_matlab2weka(fileinfo.filenamesuffix,filename,data,featureNames)
                iter = iter+1;
                waitbar(iter/(size(handles.BNCT.config.tasklistraw,1)*size(handles.BNCT.config.freqrangelistraw,1)),h);
            end
        end
        close(h)
        close
        msgbox('Features exported')
    case 'Combined'
        if which_features == 1
            filename=horzcat(fileinfo.foldersuffix,fileinfo.filenamesuffix,'_Combo_All_Features_',fileinfo.filenameappend,'.arff');
            data = [handles.BNCT.AllFeatures handles.BNCT.featureclass];
            featureNames = [handles.BNCT.FeatureNames 'Group'];
        elseif which_features == 2
            data = [];
            filename=horzcat(fileinfo.foldersuffix,fileinfo.filenamesuffix,'_Combo_Top_Features_',fileinfo.filenameappend,'.arff');
            for pheno = 1:1:size(handles.BNCT.config.phenotypelistraw,1)
                data = [data;cell2mat(handles.BNCT.TopFeatures.(handles.BNCT.config.phenotypelistraw{pheno})(:,2:end))];
            end
            data = [data handles.BNCT.featureclass];
            featureNames = [handles.BNCT.TopFeatures.Names 'Group'];
        end
        gui_matlab2weka(fileinfo.filenamesuffix,filename,data,featureNames)
        close
        msgbox(horzcat('Features exported to ',filename));
    case 'Manual'
        
        filename=horzcat(fileinfo.foldersuffix,fileinfo.filenamesuffix,'_Manual_Features_',fileinfo.filenameappend,'.arff');
        data = [cell2mat(handles.BNCT.AllFeatures(:,2:end)) handles.BNCT.featureclass];
        featureNames = [handles.BNCT.FeatureNames(2:end) 'Group'];
        gui_matlab2weka(fileinfo.filenamesuffix,filename,data,featureNames)
        
        close
        msgbox(horzcat('Features exported to ',filename));
end



function cancel_Callback(hObject, eventdata, handles)
%% --- Executes on button press in cancel.
close
