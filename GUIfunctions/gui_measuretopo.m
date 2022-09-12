function varargout = gui_measuretopo(varargin)
% GUI_MEASURETOPO MATLAB code for gui_measuretopo.fig
%      GUI_MEASURETOPO, by itself, creates a new GUI_MEASURETOPO or raises the existing
%      singleton*.
%
%      H = GUI_MEASURETOPO returns the handle to a new GUI_MEASURETOPO or the handle to
%      the existing singleton*.
%
%      GUI_MEASURETOPO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_MEASURETOPO.M with the given input arguments.
%
%      GUI_MEASURETOPO('Property','Value',...) creates a new GUI_MEASURETOPO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_measuretopo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_measuretopo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_measuretopo

% Last Modified by GUIDE v2.5 09-Dec-2015 16:29:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_measuretopo_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_measuretopo_OutputFcn, ...
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



function gui_measuretopo_OpeningFcn(hObject, eventdata, handles, varargin)
%% --- Executes just before gui_measuretopo is made visible.
handles.output = hObject;
handles.BNCT = evalin('base','BNCT');
raw = handles.BNCT.raw;%evalin('base','raw');
handles.phenotype = handles.BNCT.config.phenotypelistraw;%evalin('base','phenotypelistraw');
handles.freqlist = handles.BNCT.config.freqlabellistraw;%evalin('base','freqlabellistraw');
handles.tasklist = handles.BNCT.config.tasklist;%evalin('base','tasklist');
handles.timelist = handles.BNCT.config.batch_timerange;%evalin('base','batch_timerange');
handles.subjectids = handles.BNCT.SubjectIDs;%evalin('base','SubjectIDs');
handles.phenotypeval = 1;
handles.freqlistval = 1;
handles.tasklistval = 1;
handles.timelistval = 1;
handles.subjectidsval = 1;
handles.sensitivityval = 1;
handles.bkgdconnectionsval = 0;
handles.viewconnectionsval = 0;
set(handles.sensitivity,'val',1);
handles.moduleval = [];
handles.allmeasures = handles.BNCT.allmeasures;%evalin('base','allmeasures');
handles.chanord = handles.BNCT.chanord;%evalin('base','chanord');
%EEG = pop_loadset(strcat(raw{1,1},'\',raw{1,2}));
handles.EEG = handles.BNCT.EEG;
%handles.EEG = EEG;

% Update handles structure
axes(handles.axes1)
[x_elec,y_elec] = topoplot2([],handles.EEG.chanlocs,'electrodes','ptslabels');z_elec = ones(size(x_elec))*2.1;
handles.x_elec = x_elec;
handles.y_elec = y_elec;
handles.z_elec = z_elec;
set(handles.group,'string',handles.phenotype);
set(handles.time,'string',handles.timelist);
set(handles.frequency,'string',handles.freqlist);
set(handles.task,'string',handles.tasklist);
set(handles.subjectid,'string',handles.subjectids.(handles.phenotype{1}).(handles.tasklist{1}));
guidata(hObject, handles);

% UIWAIT makes gui_measuretopo wait for user response (see UIRESUME)
% uiwait(handles.gui_measuretopo);



function varargout = gui_measuretopo_OutputFcn(hObject, eventdata, handles) 
%% --- Outputs from this function are returned to the command line.
varargout{1} = handles.output;

function updateGraph(hObject, eventdata, handles)
pheno = handles.phenotypeval;
task = handles.tasklistval;
time = handles.timelistval;
sub = handles.subjectidsval;
freq = handles.freqlistval;
measure = handles.measureval;
chanord = handles.chanord;
y_elec = handles.y_elec;
x_elec = handles.x_elec;
z_elec = handles.z_elec;
EEG=handles.EEG;
axes(handles.axes1);
cla;
[x_elec,y_elec] = topoplot2([],EEG.chanlocs,'electrodes','numbers');
switch chanord.method
    case 'new'
        y_elec = chanord.new.locs(:,1);
        x_elec = chanord.new.locs(:,2);
end

hold on
%%                              Modularity
if measure == 2
    moduleval = handles.moduleval;
    modulelistold = get(handles.modulelist,'string');
    allconnections = 0;
    if length(moduleval) == length(modulelistold)
        allconnections = 1;
    end
    set(findobj('Tag','uipanel3'),'visible','on')
    commstructurelouvain = handles.allmeasures.(handles.phenotype{pheno}).(handles.tasklist{task}){1,sub}(freq,time).commstructurelouvain;
    numchans = length(commstructurelouvain);
    numofmodules = max(commstructurelouvain);
    for n = 1:numofmodules
        modulelist{n} = horzcat('Module ',num2str(n));
    end
    set(handles.modulelist,'string',modulelist);
    %% Handle switching between parameters w/ diff # of modules
    if max(moduleval) > length(modulelist)
        moduleval = moduleval(moduleval<length(modulelist));
        set(handles.modulelist,'val',moduleval);
        handles.moduleval = moduleval;
    end
    if allconnections == 1
        moduleval = [1:length(modulelist)];
        set(handles.modulelist,'val',moduleval);
        handles.moduleval = moduleval;
    end
    colorVec = lines(numofmodules);
    colorVec = colorcube;
        
    %% Plot module dots, non-selected module are transparent
    for a = 1:length(commstructurelouvain)
        if any(find(moduleval==commstructurelouvain(a))) || any(find(moduleval==commstructurelouvain(a)))
            plot(y_elec(a),x_elec(a),'MarkerEdgeColor',colorVec(round(63*(commstructurelouvain(a)/numofmodules)),:),'MarkerFaceColor',colorVec(round(63*(commstructurelouvain(a)/numofmodules)),:),'Marker','o','MarkerSize',((1/log10(numchans))^2)*50)
        else
            plot(y_elec(a),x_elec(a),'MarkerEdgeColor',colorVec(round(63*(commstructurelouvain(a)/numofmodules)),:),'Marker','o','MarkerSize',((1/log10(numchans))^2)*50)           
        end
    end
    %% Plot legend colors
    for b = 1:numofmodules
        %plot(-.5,.49-((b-1)*.037),'MarkerEdgeColor',colorVec(b,:),'MarkerFaceColor',colorVec(b,:),'Marker','o','MarkerSize',10)
        plot(-.5,.49-((b-1)*.037),'MarkerEdgeColor',colorVec(round(63*(b/numofmodules)),:),'MarkerFaceColor',colorVec(round(63*(b/numofmodules)),:),'Marker','o','MarkerSize',10)
    end
    %%                      DRAW COHERENCE CONNECTIONS
    if ~isempty(moduleval) && handles.viewconnectionsval == 1
        %FIND INDECES OF SELECTED MODULES (MODULEVAL), THEN CHECK WHICH NODES THESE
        %ARE, THEN PLOT ONLY THOSE CONNECTIONS IF I OR J = THAT
        cohmatrix_avg = handles.allmeasures.(handles.phenotype{pheno}).(handles.tasklist{task}){1,sub}(freq,time).matrix;
        n = length(handles.allmeasures.(handles.phenotype{pheno}).(handles.tasklist{task}){1,sub}(freq,time).nonthreshmatrix);
        
        for i = 1:1:n
            for j = i+1:1:n
                if cohmatrix_avg(i,j) ~= 0
                    %Check if connection is with associated module
                    if any(find(moduleval==commstructurelouvain(i))) || any(find(moduleval==commstructurelouvain(j)))
                        line([y_elec(i) y_elec(j)],[x_elec(i) x_elec(j)],[z_elec(i) z_elec(j)],'Color',[0 0 0],'Marker','.','LineStyle','-','LineWidth',3*(handles.sensitivityval+0.01))
                    else
                        if handles.bkgdconnectionsval == 1
                            line([y_elec(i) y_elec(j)],[x_elec(i) x_elec(j)],[z_elec(i) z_elec(j)],'Color',[.6 .6 .6],'Marker','.','LineStyle','-','LineWidth',.1)
                    
                        end
                    end
                    
                end
                
            end
        end
    end
    
else
    set(findobj('Tag','uipanel3'),'visible','off')
end
guidata(hObject,handles);




function measure_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in measure.
handles.measureval = get(hObject,'val');
guidata(hObject,handles);
updateGraph(hObject, eventdata, handles)



function measure_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function group_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in group.
handles.phenotypeval = get(hObject,'val');
guidata(hObject, handles);
updateGraph(hObject, eventdata, handles)


function group_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function task_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in task.
handles.tasklistval = get(hObject,'val');
guidata(hObject, handles);
updateGraph(hObject, eventdata, handles)


function task_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in time.
handles.timelistval = get(hObject,'val');
guidata(hObject, handles);
updateGraph(hObject, eventdata, handles)


function time_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frequency_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in frequency.
handles.freqlistval = get(hObject,'val');
guidata(hObject, handles);
updateGraph(hObject, eventdata, handles)


function frequency_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function subjectid_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in subjectid.
handles.subjectidsval = get(hObject,'val');
guidata(hObject, handles);
updateGraph(hObject, eventdata, handles)


function subjectid_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function modulelist_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in modulelist.
oldval = handles.moduleval;
newval = get(hObject,'val');
if isequal(oldval,newval)%oldval == newval
    set(handles.modulelist,'val',[]);
    handles.moduleval = get(hObject,'val');
else
    handles.moduleval = newval;
end

guidata(hObject, handles);
updateGraph(hObject, eventdata, handles)


function modulelist_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function viewconnections_Callback(hObject, eventdata, handles)
%% --- Executes on button press in viewconnections.
handles.viewconnectionsval = get(hObject,'val');
if handles.viewconnectionsval == 1
    set(handles.bkgdconnections,'enable','on');
    set(handles.sensitivity,'enable','on');
else
    set(handles.bkgdconnections,'enable','off');
    set(handles.sensitivity,'enable','off');
end
guidata(hObject, handles);
updateGraph(hObject, eventdata, handles)



function sensitivity_Callback(hObject, eventdata, handles)
%% --- Executes on slider movement.
handles.sensitivityval = get(hObject,'val');
guidata(hObject, handles);
updateGraph(hObject, eventdata, handles)


function sensitivity_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function bkgdconnections_Callback(hObject, eventdata, handles)
%% --- Executes on button press in bkgdconnections.
handles.bkgdconnectionsval = get(hObject,'val');
guidata(hObject, handles);
updateGraph(hObject, eventdata, handles)
