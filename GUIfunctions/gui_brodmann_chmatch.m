function varargout = gui_brodmann_chmatch(varargin)
% GUI_BRODMANN_CHMATCH MATLAB code for gui_brodmann_chmatch.fig
%      GUI_BRODMANN_CHMATCH, by itself, creates a new GUI_BRODMANN_CHMATCH or raises the existing
%      singleton*.
%
%      H = GUI_BRODMANN_CHMATCH returns the handle to a new GUI_BRODMANN_CHMATCH or the handle to
%      the existing singleton*.
%
%      GUI_BRODMANN_CHMATCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_BRODMANN_CHMATCH.M with the given input arguments.
%
%      GUI_BRODMANN_CHMATCH('Property','Value',...) creates a new GUI_BRODMANN_CHMATCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_brodmann_chmatch_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_brodmann_chmatch_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_brodmann_chmatch

% Last Modified by GUIDE v2.5 08-Oct-2015 10:52:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_brodmann_chmatch_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_brodmann_chmatch_OutputFcn, ...
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


% --- Executes just before gui_brodmann_chmatch is made visible.
function gui_brodmann_chmatch_OpeningFcn(hObject, eventdata, handles, all_labels, labels)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_brodmann_chmatch (see VARARGIN)

% Choose default command line output for gui_brodmann_chmatch
handles.output = hObject;
handles.BNCT = evalin('base','BNCT');
try
    match_list = handles.BNCT.matched_channels;%evalin('base','matched_channels');
    for n = 1:1:size(match_list,1)
        all_labels_listbox{n,1} = [match_list{n,1},match_list{n,2},match_list{n,3}];
    end
   
    labels_listbox = handles.BNCT.user_channels;%evalin('base','user_channels');
    
catch
    %Create cell array
    for m = 1:1:size(all_labels,1)
        match_list{m,1} = all_labels{m};
        match_list{m,2} = ' --> ';
        match_list{m,3} = [];
    end
    
    for i = size(labels,1):-1:1
        match = any(strcmp(all_labels,labels{i}));
        if match
            loc = find(strcmp(all_labels,labels{i}));
            match_list{loc,3} = labels{i};
            labels_listbox{i,1} = labels{i};
        else
            labels_listbox{i,1} = strcat(labels{i},'*');
        end
    end
    
    for n = 1:1:size(all_labels)
        all_labels_listbox{n,1} = [match_list{n,1},match_list{n,2},match_list{n,3}];
    end
    
end
set(handles.matched_channels,'string',all_labels_listbox);
set(handles.user_channels,'string',labels_listbox);

handles.all_labels = all_labels;
handles.labels = labels;
handles.match_list = match_list;
handles.labels_listbox = labels_listbox;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_brodmann_chmatch wait for user response (see UIRESUME)
% uiwait(handles.figure1);



function match_channels = gui_brodmann_chmatch_OutputFcn(hObject, eventdata, handles) 
%% --- Outputs from this function are returned to the command line.
%varargout{1} = handles.output;
match_channels = handles.matched_channels;



function matched_channels_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in matched_channels.



function matched_channels_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function user_channels_Callback(hObject, eventdata, handles)
%% --- Executes on selection change in user_channels.



function user_channels_CreateFcn(hObject, eventdata, handles)
%% --- Executes during object creation, after setting all properties.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function confirm_Callback(hObject, eventdata, handles)
%% --- Executes on button press in confirm.
%Check if all channels matched before finishing
lflag = 0;
for i = 1:1:size(handles.labels_listbox,1)
    if any(strfind(handles.labels_listbox{i},'*'))
        lflag = 1;
        warnuser = questdlg('Some electrodes may not be matched. Continue without matching?', 'Warning','Yes');
        switch warnuser
            case 'Yes'
                handles.BNCT.matched_channels = handles.match_list;
                handles.BNCT.user_channels = handles.labels_listbox;
                assignin('base','BNCT',handles.BNCT);
               % assignin('base','matched_channels',handles.match_list);
               % assignin('base','user_channels',handles.labels_listbox);
                close;
            case 'No'
                return;
            case 'Cancel'
                return;
        end
    
  %  elseif ~any(strfind(handles.labels_listbox{i},'*')) && i == size(handles.labels_listbox,1)
  %       assignin('base','matched_channels',handles.match_list);
   %      close;
    end
     
    if lflag == 1
        break
    end

end

   if lflag == 0
       handles.BNCT.matched_channels = handles.match_list;
       assignin('base','BNCT',handles.BNCT);
    %  assignin('base','matched_channels',handles.match_list);
      close;
   end


function cancel_Callback(hObject, eventdata, handles)
%% --- Executes on button press in cancel.

close;



function match_Callback(hObject, eventdata, handles)
%% --- Executes on button press in match.
ref_elec = get(handles.matched_channels,'value');
user_elec = get(handles.user_channels,'value');

labels = handles.labels;
%Check if electrode already matched somewhere & if so, remove
for m = 1:1:size(handles.match_list,1)
    if strcmp(handles.match_list{m,3},labels(user_elec))
        handles.match_list{m,3} = [];
    end
end
%Store old elec
old_elec = handles.match_list{ref_elec,3};
%Add new elec
handles.match_list{ref_elec,3} = labels{user_elec};
%Update electrode list of whether they are matched
if ~isempty(old_elec)
    if ~strcmp(labels{user_elec},old_elec)
        for i = size(labels,1):-1:1
            match = any(strcmp(labels{i},old_elec));
            if match
                handles.labels_listbox{i,1} = strcat(labels{i},'*');
            end
        end
    end
end

%take * off old label now matched
handles.labels_listbox{user_elec,1} = labels{user_elec,1};
for n = 1:1:size(handles.match_list,1)
    all_labels_listbox{n,1} = [handles.match_list{n,1},...
        handles.match_list{n,2},handles.match_list{n,3}];
end
set(handles.matched_channels,'string',all_labels_listbox);
set(handles.user_channels,'string',handles.labels_listbox);


guidata(hObject,handles);


function unmatch_Callback(hObject, eventdata, handles)
%% --- Executes on button press in unmatch.
ref_elec = get(handles.matched_channels,'value');
%Remove electrode from matched channel box
old_elec = handles.match_list{ref_elec,3};
handles.match_list{ref_elec,3} = [];

%Find electrode in user list and mark as not matched
for i = size(handles.labels,1):-1:1
    match = any(strcmp(handles.labels{i},old_elec));
    if match
        handles.labels_listbox{i,1} = strcat(handles.labels{i},'*');
    end
end

for n = 1:1:size(handles.match_list,1)
    all_labels_listbox{n,1} = [handles.match_list{n,1},...
        handles.match_list{n,2},handles.match_list{n,3}];
end
set(handles.matched_channels,'string',all_labels_listbox);
set(handles.user_channels,'string',handles.labels_listbox);

guidata(hObject,handles);
