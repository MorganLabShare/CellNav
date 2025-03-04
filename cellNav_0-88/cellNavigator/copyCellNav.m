function varargout = copyCellNav(varargin)
% COPYCELLNAV MATLAB code for copyCellNav.fig
%      COPYCELLNAV, by itself, creates a new COPYCELLNAV or raises the existing
%      singleton*.
%
%      H = COPYCELLNAV returns the handle to a new COPYCELLNAV or the handle to
%      the existing singleton*.
%
%      COPYCELLNAV('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COPYCELLNAV.M with the given input arguments.
%
%      COPYCELLNAV('Property','Value',...) creates a new COPYCELLNAV or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before copyCellNav_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to copyCellNav_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help copyCellNav

% Last Modified by GUIDE v2.5 24-Jun-2020 21:43:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @copyCellNav_OpeningFcn, ...
                   'gui_OutputFcn',  @copyCellNav_OutputFcn, ...
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


% --- Executes just before copyCellNav is made visible.
function copyCellNav_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to copyCellNav (see VARARGIN)

% Choose default command line output for copyCellNav
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes copyCellNav wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = copyCellNav_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_copyCellNav.
function pushbutton_copyCellNav_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_copyCellNav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global glob

set(handles.textOut,'String','Select Directory in which to copy cellNav')
pause(.01)

TPN = [uigetdir('C:\',...
    'Select destination folder for cellNavPack') '\cellNavPack\'];
if ~exist(TPN,'dir'),mkdir(TPN);end

set(handles.textOut,'String','Copying cellNav')
pause(.01)

copyfile(glob.cellNav.pwd ,[TPN 'cellNav\']);
copyfile(glob.cellNav.pwd ,[TPN 'cellNav\']);
copyfile(glob.dir.Analysis,[TPN 'Analysis\']);
if ~exist([TPN 'Volumes'],'dir'),mkdir([TPN 'Volumes']);end

set(handles.textOut,'String','Copying fvLibraries')
pause(.01)


for i = 1:length(glob.vol.names);
    try
        oldFold = [glob.dir.Volumes glob.vol.names{i} '\Analysis\fvLibrary\'];
        newFold = [TPN 'Volumes\' glob.vol.names{i} '\Analysis\fvLibrary\'];
        copyfile(oldFold,newFold);
    end
end

set(handles.textOut,'String','Copying Segmentation Export Files')
pause(.01)

if get(handles.checkbox_segmentations,'Value')
    for i = 1:length(glob.vol.names);
        try
            oldFold = [glob.dir.Volumes glob.vol.names{i} '\Merge\'];
            newFold = [TPN 'Volumes\' glob.vol.names{i} '\Merge\'];
            copyfile(oldFold,newFold);
        end
    end
end
set(handles.textOut,'String',...
    sprintf('Finished Copying cellNav and data to cellNavPack at %s',TPN))
pause(.01)



% --- Executes on button press in checkbox_segmentations.
function checkbox_segmentations_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_segmentations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_segmentations



function textOut_Callback(hObject, eventdata, handles)
% hObject    handle to textOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textOut as text
%        str2double(get(hObject,'String')) returns contents of textOut as a double


% --- Executes during object creation, after setting all properties.
function textOut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
