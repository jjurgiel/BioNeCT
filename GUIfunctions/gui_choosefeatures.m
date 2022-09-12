function varargout = gui_choosefeatures(varargin)
% GUI_CHOOSEFEATURES MATLAB code for gui_choosefeatures.fig
%      GUI_CHOOSEFEATURES, by itself, creates a new GUI_CHOOSEFEATURES or raises the existing
%      singleton*.
%
%      H = GUI_CHOOSEFEATURES returns the handle to a new GUI_CHOOSEFEATURES or the handle to
%      the existing singleton*.
%
%      GUI_CHOOSEFEATURES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CHOOSEFEATURES.M with the given input arguments.
%
%      GUI_CHOOSEFEATURES('Property','Value',...) creates a new GUI_CHOOSEFEATURES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_choosefeatures_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_choosefeatures_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_choosefeatures

% Last Modified by GUIDE v2.5 31-May-2016 13:58:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_choosefeatures_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_choosefeatures_OutputFcn, ...
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


% --- Executes just before gui_choosefeatures is made visible.
function gui_choosefeatures_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_choosefeatures (see VARARGIN)

% Choose default command line output for gui_choosefeatures
handles.output = hObject;

handles.BNCT = evalin('base','BNCT');
% Update handles structure
guidata(hObject, handles);
loadState(handles);
% UIWAIT makes gui_choosefeatures wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_choosefeatures_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%{
function saveState(handles)
%
configfilename = evalin('base','configfilename');
fisher_configfile = strcat(strrep(configfilename.file,'.mat',[]),'_fisherfeatures','.mat');
%fisher_configfile = evalin('base','batch_configfile');

state.ap = get(handles.ap, 'value');
state.rp = get(handles.rp, 'value');
state.ge = get(handles.ge, 'value');
state.cc = get(handles.cc, 'value');
state.pl = get(handles.pl, 'value');
state.mc = get(handles.mc, 'value');
state.mod = get(handles.mod, 'value');
state.assort = get(handles.assort, 'value');
state.dens = get(handles.dens, 'value');
state.rad = get(handles.rad, 'value');
state.diam = get(handles.diam, 'value');


save(fisher_configfile,'state');
%}
function loadState(handles)
%try
%
    [all_graph all_power] = gui_featurematrix;
    try
    graph_features = handles.BNCT.graph_features;%evalin('base','graph_features');
    for i = 1:1:size(all_graph,1)
        if any(strcmp(graph_features(:,2),all_graph{i,2}))
            graphval(i) = 1;
        else
            graphval(i) = 0;
        end
    end
    
    set(handles.cc,'value',graphval(1));
    set(handles.ge,'value',graphval(2));
    set(handles.pl,'value',graphval(3));
    set(handles.mod,'value',graphval(4));
    set(handles.mc,'value',graphval(5));
    set(handles.assort,'value',graphval(6));
    set(handles.dens,'value',graphval(7));
    set(handles.rad,'value',graphval(8));
    set(handles.diam,'value',graphval(9));
    set(handles.smallworldness,'value',graphval(10));
    
    power_features = handles.BNCT.power_features;%evalin('base','power_features');
    
    set(handles.rp,'value',power_features{1,1});
    set(handles.ap,'value',power_features{2,1});
    catch
    end
    
%catch
%end
   %}
   %{
configfilename = evalin('base','configfilename');
warning off
fisher_configfile = strcat(strrep(configfilename.file,'.mat',[]),'_fisherfeatures','.mat');
assignin('base','fisher_configfile',fisher_configfile);
fileName = evalin('base','fisher_configfile');

if exist(fileName)
  load(fileName)
  set(handles.ap, 'value', state.ap);
  set(handles.rp, 'value', state.rp);
  set(handles.ge, 'value', state.ge);
  set(handles.cc, 'value', state.cc);
  set(handles.pl, 'value', state.pl);
  set(handles.mc, 'value', state.mc);
  set(handles.mod, 'value', state.mod);
  set(handles.assort, 'value', state.assort);
  set(handles.dens, 'value', state.dens);
  set(handles.rad, 'value', state.rad);
  set(handles.diam, 'value', state.diam);

end
%}
% --- Executes on button press in ap.
function ap_Callback(hObject, eventdata, handles)
% hObject    handle to ap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ap


% --- Executes on button press in ap.
function rp_Callback(hObject, eventdata, handles)
% hObject    handle to ap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ap


% --- Executes on button press in pl.
function pl_Callback(hObject, eventdata, handles)
% hObject    handle to pl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pl


% --- Executes on button press in mc.
function mc_Callback(hObject, eventdata, handles)
% hObject    handle to mc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mc


% --- Executes on button press in mod.
function mod_Callback(hObject, eventdata, handles)
% hObject    handle to mod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mod


% --- Executes on button press in ge.
function ge_Callback(hObject, eventdata, handles)
% hObject    handle to ge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ge


% --- Executes on button press in cc.
function cc_Callback(hObject, eventdata, handles)
% hObject    handle to cc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cc


% --- Executes on button press in confirm.
function confirm_Callback(hObject, eventdata, handles)
% hObject    handle to confirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cc = get(handles.cc,'value');
mod = get(handles.mod,'value');
pl = get(handles.pl,'value');
ge = get(handles.ge,'value');
mc = get(handles.mc,'value');
assort = get(handles.assort,'value');
dens = get(handles.dens,'value');
rad = get(handles.rad,'value');
diam = get(handles.diam,'value');
sw = get(handles.smallworldness,'value');

rp = get(handles.rp,'value');
ap = get(handles.ap,'value');

[graph_features power_features] = gui_featurematrix;
graph_features(:,1) = [{cc};{mod};{pl};{ge};{mc};{assort};{dens};{rad};{diam};{sw}];
power_features(:,1) = [{rp};{ap}];

%graph_features = {cc,'Avg Clustering Coefficient','transitivity';...
 %                   ge,'Global Efficiency','efficglobal';... 
 %                   pl,'Path Length','avgpath';...
 %                   mod,'Modularity','modularitylouvain';...
 %                   mc,'Mean Coherence','meancoherence'};        
graph_features(~any(cell2mat(graph_features(:,1)),2),:) = [];

%power_features = {ap,'Relative Power','rel_power';...
%                    ap,'Absolute Power','abs_power'};
%power_features(~any(cell2mat(power_features(:,1)),2),:) = [];

handles.BNCT.graph_features = graph_features;
handles.BNCT.power_features = power_features;
%assignin('base','graph_features',graph_features);
%assignin('base','power_features',power_features);
assignin('base','BNCT',handles.BNCT);
%saveState(handles);
close
% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close


% --- Executes on button press in assort.
function assort_Callback(hObject, eventdata, handles)
% hObject    handle to assort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of assort


% --- Executes on button press in dens.
function dens_Callback(hObject, eventdata, handles)
% hObject    handle to dens (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dens


% --- Executes on button press in rad.
function rad_Callback(hObject, eventdata, handles)
% hObject    handle to rad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rad


% --- Executes on button press in diam.
function diam_Callback(hObject, eventdata, handles)
% hObject    handle to diam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of diam


% --- Executes on button press in smallworldness.
function smallworldness_Callback(hObject, eventdata, handles)
% hObject    handle to smallworldness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of smallworldness
