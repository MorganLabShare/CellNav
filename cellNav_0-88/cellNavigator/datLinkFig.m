function varargout = datLinkFig(varargin)
% DATLINKFIG MATLAB code for datLinkFig.fig
%      DATLINKFIG, by itself, creates a new DATLINKFIG or raises the existing
%      singleton*.
%
%      H = DATLINKFIG returns the handle to a new DATLINKFIG or the handle to
%      the existing singleton*.
%
%      DATLINKFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATLINKFIG.M with the given input arguments.
%
%      DATLINKFIG('Property','Value',...) creates a new DATLINKFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before datLinkFig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to datLinkFig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help datLinkFig

% Last Modified by GUIDE v2.5 12-May-2021 16:55:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @datLinkFig_OpeningFcn, ...
                   'gui_OutputFcn',  @datLinkFig_OutputFcn, ...
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


% --- Executes just before datLinkFig is made visible.
function datLinkFig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to datLinkFig (see VARARGIN)

% Choose default command line output for datLinkFig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes datLinkFig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = datLinkFig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_dataSheet_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dataSheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dataSheet as text
%        str2double(get(hObject,'String')) returns contents of edit_dataSheet as a double


% --- Executes during object creation, after setting all properties.
function edit_dataSheet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dataSheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_aliasSheet_Callback(hObject, eventdata, handles)
% hObject    handle to edit_aliasSheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_aliasSheet as text
%        str2double(get(hObject,'String')) returns contents of edit_aliasSheet as a double


% --- Executes during object creation, after setting all properties.
function edit_aliasSheet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_aliasSheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_makeDataFile.
function pushbutton_makeDataFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_makeDataFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob

datStr = get(handles.edit_dataSheet, 'String');
[dat.googleLinks.datSheet dat.googleLinks.datGID] ...
    = parseSheetAddress(datStr);

datStr = get(handles.edit_aliasSheet, 'String');
[a  dat.googleLinks.aliasGID]  = parseSheetAddress(datStr);

dat = parseGoogleDat(dat)
save([glob.NA.export.datDir 'dat.mat'],'dat')




function[fileName GID] = parseSheetAddress(datStr)

slash = regexp(datStr,'/');
fileName = datStr(slash(end-1)+1:slash(end)-1);
gidE  = regexp(datStr,'gid=');
GID = datStr(gidE(end)+4:end);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_fileDestination_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fileDestination (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fileDestination as text
%        str2double(get(hObject,'String')) returns contents of edit_fileDestination as a double


% --- Executes during object creation, after setting all properties.
function edit_fileDestination_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fileDestination (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob

set(hObject,'String',glob.NA.MPN)
glob.NA.export.datDir = glob.NA.MPN;


% --- Executes on button press in data2Tis.
function data2Tis_Callback(hObject, eventdata, handles)
% hObject    handle to data2Tis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob tis

'making tis'
tis = makeTis;
save([glob.useFvDir 'tis.mat'],'tis');
