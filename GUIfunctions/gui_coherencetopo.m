function varargout = gui_coherencetopo(varargin)
% GUI_COHERENCETOPO MATLAB code for gui_coherencetopo.fig
%      GUI_COHERENCETOPO, by itself, creates a new GUI_COHERENCETOPO or raises the existing
%      singleton*.
%
%      H = GUI_COHERENCETOPO returns the handle to a new GUI_COHERENCETOPO or the handle to
%      the existing singleton*.
%
%      GUI_COHERENCETOPO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_COHERENCETOPO.M with the given input arguments.
%
%      GUI_COHERENCETOPO('Property','Value',...) creates a new GUI_COHERENCETOPO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_coherencetopo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_coherencetopo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_coherencetopo

% Last Modified by GUIDE v2.5 15-Oct-2015 09:08:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_coherencetopo_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_coherencetopo_OutputFcn, ...
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


% --- Executes just before gui_coherencetopo is made visible.
function gui_coherencetopo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_coherencetopo (see VARARGIN)

% Choose default command line output for gui_coherencetopo
handles.output = hObject;
handles.BNCT = evalin('base','BNCT');
% Update handles structure
guidata(hObject, handles);
batch_freqlabel = handles.BNCT.config.freqlabellistraw;%evalin('base','freqlabellistraw');
set(handles.coh_freqrange,'string',batch_freqlabel);
batch_timerange = handles.BNCT.config.batch_timerange;%evalin('base','batch_timerange');
set(handles.coh_timebinlist,'Max',size(batch_timerange,1),'SliderStep',[(1/size(batch_timerange,1))-0.001 (1/size(batch_timerange,1))]);
tasklistraw = handles.BNCT.config.tasklistraw;%evalin('base','tasklistraw');
set(handles.coh_task,'string',tasklistraw);
freqlabellistraw = handles.BNCT.config.freqlabellistraw;%evalin('base','freqlabellistraw');
set(handles.coh_freqrange,'string',freqlabellistraw);
phenotypelistraw = handles.BNCT.config.phenotypelistraw;%evalin('base','phenotypelistraw');
set(handles.coh_cond,'string',phenotypelistraw);
SubjectIDs = handles.BNCT.SubjectIDs;%evalin('base','SubjectIDs');
[tasklist] = gui_tasklist(tasklistraw);
set(handles.coh_subjectnum,'string',SubjectIDs.(phenotypelistraw{1}).(tasklist{1}));

raw = handles.BNCT.raw;%evalin('base','raw');
configfilename = handles.BNCT.configfilename;%evalin('base','configfilename');
analysisfile = strrep(configfilename.file,'.mat','');
chanord = handles.BNCT.chanord;%evalin('base','chanord');
handles.chanord = chanord;
%%%%%%%%%%%%%%%%%%%%%%%%%%NEED TO CHANGE HOW LABELS ARE REFERRED TO

    [num txt raw1] = xlsread('81ch_montage.xlsx');
    all_locs = cell2mat(raw1(:,2:4));
    all_labels = raw1(:,1);
switch chanord.method
    case 'orig'
        EEG = pop_loadset(strcat(raw(1,1),'\',raw(1,2))); %why use 2nd file previous?
        for i = 1:1:EEG.nbchan
            labels{i,1} = EEG.chanlocs(i).labels;
        end
    case 'new'
        labels = chanord.new.labels;
end

    handles.labels = labels;
    handles.all_locs = all_locs;
    handles.all_labels = all_labels;
    
    guidata(hObject,handles);
% UIWAIT makes gui_coherencetopo wait for user response (see UIRESUME)
% uiwait(handles.figure1);



function varargout = gui_coherencetopo_OutputFcn(hObject, eventdata, handles) 
%% --- Outputs from this function are returned to the command line.
varargout{1} = handles.output;



function figure1_CloseRequestFcn(hObject, eventdata, handles)
%% --- Executes when user attempts to close figure1.

% Hint: delete(hObject) closes the figure
delete(hObject);


function updateGraph(hObject, eventdata, handles)
%%
warning off
alldata = handles.BNCT.alldata;%evalin('base','alldata');
raw = handles.BNCT.raw;%evalin('base','raw');
SubjectIDs = handles.BNCT.SubjectIDs;%evalin('base','SubjectIDs');
tasklistraw = handles.BNCT.config.tasklistraw;%evalin('base','tasklistraw');
phenotypelistraw = handles.BNCT.config.phenotypelistraw;%evalin('base','phenotypelistraw');
[tasklist] = gui_tasklist(tasklistraw);

val = get(handles.coh_timebinlist,'value');
set(handles.coh_timebinlist,'value',round(val));
val = get(handles.coh_timebinlist,'value');
set(handles.coh_time,'string',num2str(val));
batch_timerange = handles.BNCT.config.batch_timerange;%evalin('base','batch_timerange');
timerange = str2num(batch_timerange{val});
timebindescrip = strcat(num2str(timerange(1)),'-',num2str(timerange(2)),' ms');
set(handles.timebindescrip,'string',timebindescrip);

topofreq = get(handles.coh_freqrange,'value');
topocond = get(handles.coh_cond,'value');
topotime = get(handles.coh_timebinlist,'value');
topotask = get(handles.coh_task,'value');
coh_viewoption = get(handles.coh_viewoption,'value');
coh_subjectnum = get(handles.coh_subjectnum,'value');

sensitivity = get(handles.sensitivity, 'value');
set(handles.sensitivityval,'string',num2str(sensitivity));

thr1 = get(handles.slider1,'value');
set(handles.slidervalue1,'string',thr1);
thr2 = get(handles.slider2,'value');
set(handles.slidervalue2,'string',thr2);

if thr1 > thr2
    set(handles.slider2,'value',thr1);
    set(handles.slidervalue2,'string',thr1);
    
    thr1 = get(handles.slider1,'value');
    thr2 = get(handles.slider2,'value');
end

%% Check for using differential plotting or normal
diff_val = get(handles.diff_val,'string');
diff_method = get(handles.diff_method,'value');
if diff_method == 2 %pheno - pheno
    sep = strfind(diff_val,'-');
    pheno1 = str2num(diff_val(1:sep-1));
    pheno2 = str2num(diff_val(sep+1:end));
    [numsubjects, cohmatrix_avg1, cohmat_full, colorVec, list, n] = gui_cohmatrix(alldata,raw,tasklistraw,coh_viewoption,coh_subjectnum,topofreq,pheno1,topotime,topotask,thr1,thr2,phenotypelistraw);
    [numsubjects, cohmatrix_avg2, cohmat_full, colorVec, list, n] = gui_cohmatrix(alldata,raw,tasklistraw,coh_viewoption,coh_subjectnum,topofreq,pheno2,topotime,topotask,thr1,thr2,phenotypelistraw);
     cohmatrix_avg1(cohmatrix_avg1 ~= 0) = 1;
     cohmatrix_avg2(cohmatrix_avg2 ~= 0) = 1;
     cohmatrix_avg = cohmatrix_avg1 - cohmatrix_avg2;
     colorVec = jet(100);
        list = sort(cohmatrix_avg(:),'ascend');
        list = list(list~=0);
elseif diff_method == 3 %task - task
    sep = strfind(diff_val,'-');
    task1 = str2num(diff_val(1:sep-1));
    task2 = str2num(diff_val(sep+1:end));    
    [numsubjects, cohmatrix_avg1, cohmat_full, colorVec, list, n] = gui_cohmatrix(alldata,raw,tasklistraw,coh_viewoption,coh_subjectnum,topofreq,topocond,topotime,task1,thr1,thr2,phenotypelistraw);
    [numsubjects, cohmatrix_avg2, cohmat_full, colorVec, list, n] = gui_cohmatrix(alldata,raw,tasklistraw,coh_viewoption,coh_subjectnum,topofreq,topocond,topotime,task2,thr1,thr2,phenotypelistraw);
     cohmatrix_avg1(cohmatrix_avg1 ~= 0) = 1;
     cohmatrix_avg2(cohmatrix_avg2 ~= 0) = 1;
     cohmatrix_avg = cohmatrix_avg1 - cohmatrix_avg2;
     colorVec = jet(100);
        list = sort(cohmatrix_avg(:),'ascend');
        list = list(list~=0);
else %normal
    [numsubjects, cohmatrix_avg, cohmat_full, colorVec, list, n] = gui_cohmatrix(alldata,raw,tasklistraw,coh_viewoption,coh_subjectnum,topofreq,topocond,topotime,topotask,thr1,thr2,phenotypelistraw);
    if coh_viewoption == 2
        phenotypelistraw = handles.BNCT.config.phenotypelistraw;%evalin('base','phenotypelistraw');
        newIDs = SubjectIDs.(phenotypelistraw{topocond}).(tasklist{topotask});
        if coh_subjectnum > size(newIDs,1)
            set(handles.coh_subjectnum,'value',size(newIDs,1));
        end
        set(handles.coh_subjectnum,'string',newIDs);
    end
end
%%                             DRAW HEADMAP
EEG = handles.BNCT.EEG;%evalin('base','EEG');
axes(handles.axes1);
cla;
[x_elec,y_elec] = topoplot2([],EEG.chanlocs,'electrodes','numbers');z_elec = ones(size(x_elec))*2.1;
hold on;
axes(handles.axes1);
plot3(y_elec,x_elec,z_elec,'.r');
colorbar;
%newchanord = evalin('base','newchanord');
chanord = handles.chanord;
switch chanord.method
    case 'new'
        y_elec = chanord.new.locs(:,1);
        x_elec = chanord.new.locs(:,2);
end
%%                      DRAW COHERENCE CONNECTIONS
for i = 1:1:n
    for j = i+1:1:n
        if cohmatrix_avg(i,j) ~= 0
            colorVecloc = find(list == cohmatrix_avg(i,j));
            if length(colorVecloc) > 1
                colorVecloc = colorVecloc(1);
            end
            %Color lines based on whether difference method selected
            if diff_method == 3 || diff_method == 2
                if cohmatrix_avg(i,j) == -1
                    line([y_elec(i) y_elec(j)],[x_elec(i) x_elec(j)],[z_elec(i) z_elec(j)],'Color',colorVec(1,:),'Marker','.','LineStyle','-','LineWidth',abs(cohmatrix_avg(i,j))*sensitivity*10)               
                elseif cohmatrix_avg(i,j) == 1
                    line([y_elec(i) y_elec(j)],[x_elec(i) x_elec(j)],[z_elec(i) z_elec(j)],'Color',colorVec(100,:),'Marker','.','LineStyle','-','LineWidth',abs(cohmatrix_avg(i,j))*sensitivity*10)               
                end         
            else
                line([y_elec(i) y_elec(j)],[x_elec(i) x_elec(j)],[z_elec(i) z_elec(j)],'Color',colorVec(colorVecloc,:),'Marker','.','LineStyle','-','LineWidth',abs(cohmatrix_avg(i,j))*sensitivity*10)
            end
        end
    end
end


%%                              RASTER PLOT
%newchanord = evalin('base','newchanord');
%figure('Position', [50, 50, 700, 700]);
axes(handles.axes2);
cla;
if diff_method == 1
    colormap('jet')
    colorbar;
    imagesc(cohmatrix_avg,[0 1])
else
    colorbar('delete') %How to color this raster for diff plot?
    imagesc(cohmatrix_avg,[-1 1])
end

set(gca, 'Color', 'w');  
%Set up grid
nx = size(alldata,1);
set(gca,'xtick', linspace(0.5,nx+0.5,nx+1), 'ytick', linspace(0.5,nx+0.5,nx+1),...
    'XTickLabels','','YTickLabels','');
set(gca,'xgrid', 'on', 'ygrid', 'on', 'gridlinestyle', '-', 'xcolor', 'k', 'ycolor', 'k');
switch chanord.method
    case 'new'
        set(gca, 'XTick', linspace(1.5,nx+.5,nx), 'XTickLabel', chanord.new.labels,'XAxisLocation','Top','FontSize',8)
      %  rotateXLabels(gca,90)
        set(gca, 'YTick', linspace(1.5,nx+.5,nx),'YTickLabel', chanord.new.labels)
    case 'orig'
        set(gca, 'XTick', linspace(1.5,nx+.5,nx), 'XTickLabel', chanord.orig.labels,'XAxisLocation','Top','FontSize',8)
        rotateXLabels(gca,90)
        set(gca, 'YTick', linspace(1.5,nx+.5,nx), 'YTickLabel', chanord.orig.labels)
end
%title('post-Ketamine Gamma (30-40Hz)')
axis square
colorbar

%%                              Schemaball
flag_sch = get(handles.flag_schemaball,'value');
if flag_sch == 1
axes(handles.axes3);
cla;

gui_schemaball(handles.BNCT,cohmatrix_avg,chanord);
end
%%                          Brodmann Areas
brodmann_flag = get(handles.flag_brodmann,'value');
if brodmann_flag == 1
    %Left Hemisphere
    viewpoint = 'left';
    axes(handles.axes4);
    cla;
    handles.BNCT = evalin('base','BNCT');
    gui_brodmann(handles.BNCT,handles.labels, handles.all_labels, handles.all_locs, cohmatrix_avg, cohmat_full, colorVec, thr1, thr2, sensitivity, viewpoint)
    
    %Right Hemisphere
    viewpoint = 'right';
    axes(handles.axes5);
    cla;
    gui_brodmann(handles.BNCT,handles.labels, handles.all_labels, handles.all_locs, cohmatrix_avg, cohmat_full, colorVec, thr1, thr2, sensitivity, viewpoint)
   
end




function match_channels_Callback(hObject, eventdata, handles)
%% --- Executes on button press in match_channels.
%    [num txt raw1] = xlsread('81ch_montage.xlsx');
%    all_locs = cell2mat(raw1(:,2:4));
%    all_labels = raw1(:,1);
%    
%    raw = evalin('base','raw');
%EEG = pop_loadset(strcat(raw(2,1),'\',raw(2,2)));
%for i = 1:1:EEG.nbchan
%    labels{i,1} = EEG.chanlocs(i).labels;
%end

gui_brodmann_chmatch(handles.all_labels,handles.labels);


function save_raster_Callback(hObject, eventdata, handles)
%% --- Executes on button press in save_raster.
[filename, pathname, filterindex] = uiputfile( ...
    {...
    '*.jpg', 'JPEG (*.jpg)';
    '*.png', 'PNG (*.png)';...
    '*.fig', 'Figures (*.fig)';...
    '*.*', 'All Files (*.*)'}, ...
    'Save as');
if filename~=0
%saveas(axes2,strcat(pathname,filename));
F = getframe(handles.axes2);
image = frame2im(F);
imwrite(image,strcat(pathname,filename));
end

function save_headmap_Callback(hObject, eventdata, handles)
%% --- Executes on button press in save_headmap.
%[file, name, index] = uiputfile({'*.jpg';'*.png';'*.fig';'*.*'},'Save Headmap as');
[filename, pathname, filterindex] = uiputfile( ...
    {...
    '*.jpg', 'JPEG (*.jpg)';
    '*.png', 'PNG (*.png)';...
    '*.fig', 'Figures (*.fig)';...
    '*.*', 'All Files (*.*)'}, ...
    'Save as');
if filename~=0
    F = getframe(handles.axes1);
image = frame2im(F);
imwrite(image,strcat(pathname,filename));
%saveas(axes1,strcat(pathname,filename));
end



function save_left_Callback(hObject, eventdata, handles)
%% --- Executes on button press in save_left.
[filename, pathname, filterindex] = uiputfile( ...
    {...
    '*.jpg', 'JPEG (*.jpg)';
    '*.png', 'PNG (*.png)';...
    '*.fig', 'Figures (*.fig)';...
    '*.*', 'All Files (*.*)'}, ...
    'Save as');
if filename~=0
    F = getframe(handles.axes4);
    image = frame2im(F);
    imwrite(image,strcat(pathname,filename));
end

function save_right_Callback(hObject, eventdata, handles)
%% --- Executes on button press in save_right.
[filename, pathname, filterindex] = uiputfile( ...
    {...
    '*.jpg', 'JPEG (*.jpg)';
    '*.png', 'PNG (*.png)';...
    '*.fig', 'Figures (*.fig)';...
    '*.*', 'All Files (*.*)'}, ...
    'Save as');
if filename~=0
    F = getframe(handles.axes5);
    image = frame2im(F);
    imwrite(image,strcat(pathname,filename));
end





function slider1_Callback(hObject, eventdata, handles)
%% --- Executes on slider movement.
updateGraph(hObject,eventdata,handles);



function slider1_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function slider2_Callback(hObject, eventdata, handles)
% % --- Executes on slider movement.
updateGraph(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
%
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function slidervalue1_Callback(hObject, eventdata, handles)
%%
updateGraph(hObject,eventdata,handles);


function slidervalue1_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function slidervalue2_Callback(hObject, eventdata, handles)
%%
updateGraph(hObject,eventdata,handles);


function slidervalue2_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function coh_freqrange_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in coh_freqrange.
updateGraph(hObject,eventdata,handles);


function coh_freqrange_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function coh_cond_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in coh_cond.
updateGraph(hObject,eventdata,handles);


function coh_cond_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function coh_task_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in coh_task.
updateGraph(hObject,eventdata,handles);


function coh_task_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function coh_viewoption_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in coh_viewoption.
coh_viewoption = get(hObject,'value');
if coh_viewoption == 1
    set(handles.coh_subjectnum,'enable','off');
elseif coh_viewoption == 2
    set(handles.coh_subjectnum,'enable','on');
end
updateGraph(hObject,eventdata,handles);


function coh_viewoption_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function coh_subjectnum_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in coh_subjectnum.
updateGraph(hObject,eventdata,handles);

function coh_subjectnum_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pushbutton2_Callback(hObject, eventdata, handles)
%% --- Executes on button press in pushbutton2.


function sensitivity_Callback(hObject, eventdata, handles)
%% --- Executes on slider movement.
updateGraph(hObject,eventdata,handles);

function sensitivity_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Min',0.01,'Max',1.01,'Value',0.01);



function coh_timebinlist_Callback(hObject, eventdata, handles)
%% --- Executes on slider movement.
updateGraph(hObject,eventdata,handles);


function coh_timebinlist_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function coh_time_Callback(hObject, eventdata, handles)
%%



function coh_time_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sensitivityval_Callback(hObject, eventdata, handles)
%%



function sensitivityval_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function flag_schemaball_Callback(hObject, eventdata, handles)
%% --- Executes on button press in flag_schemaball.
updateGraph(hObject,eventdata,handles);

function flag_brodmann_Callback(hObject, eventdata, handles)
%% --- Executes on button press in flag_brodmann.
updateGraph(hObject,eventdata,handles);



function diff_method_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in diff_method.
val = get(hObject,'value');
if val == 1
    set(handles.diff_val,'enable','off');
    set(findobj('Tag','diff_text'),'String','N/A')
    set(handles.coh_cond,'enable','on');
    set(handles.coh_task,'enable','on');
elseif val == 2
    set(handles.diff_val,'enable','on');
    set(findobj('Tag','diff_text'),'String','Pheno#(red)-Pheno#(blue)')
    set(handles.coh_cond,'enable','off');
    set(handles.coh_task,'enable','on');
elseif val == 3
    set(handles.diff_val,'enable','on');
    set(findobj('Tag','diff_text'),'String','Task#(red)-Task#(blue)')
    set(handles.coh_cond,'enable','on');
    set(handles.coh_task,'enable','off');   
end


function diff_method_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function diff_val_Callback(hObject, eventdata, handles)
%%
% Hints: get(hObject,'String') returns contents of diff_val as text
%        str2double(get(hObject,'String')) returns contents of diff_val as a double



function diff_val_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
