function varargout = bionect(varargin)
% BIONECT MATLAB code for bionect.fig
%      BIONECT, by itself, creates a new BIONECT or raises the existing
%      singleton*.
%
%      H = BIONECT returns the handle to a new BIONECT or the handle to
%      the existing singleton*.
%
%      BIONECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BIONECT.M with the given input arguments.
%
%      BIONECT('Property','Value',...) creates a new BIONECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bionect_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bionect_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bionect

% Last Modified by GUIDE v2.5 14-Aug-2015 15:03:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bionect_OpeningFcn, ...
                   'gui_OutputFcn',  @bionect_OutputFcn, ...
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


% --- Executes just before bionect is made visible.
function bionect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bionect (see VARARGIN)

% Choose default command line output for bionect
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
axes(handles.axes1);
try
    imshow('gui_intropic2.jpg');
catch
    set(handles.axes1,'visible','off')
end
set(handles.gui_intro_continue,'enable','off');

% UIWAIT makes bionect wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bionect_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in gui_intro_continue.
function gui_intro_continue_Callback(hObject, eventdata, handles)
% hObject    handle to gui_intro_continue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(bionect);
run('gui_configuration');



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in agree.
function agree_Callback(hObject, eventdata, handles)
% hObject    handle to agree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of agree
agree = get(hObject,'Value');
if agree == 1
    set(handles.gui_intro_continue,'enable','on');
elseif agree == 0
    set(handles.gui_intro_continue,'enable','off');
end
