function varargout = importSWC(varargin)
% IMPORTSWC MATLAB code for importSWC.fig
%      IMPORTSWC, by itself, creates a new IMPORTSWC or raises the existing
%      singleton*.
%
%      H = IMPORTSWC returns the handle to a new IMPORTSWC or the handle to
%      the existing singleton*.
%
%      IMPORTSWC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMPORTSWC.M with the given input arguments.
%
%      IMPORTSWC('Property','Value',...) creates a new IMPORTSWC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before importSWC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to importSWC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help importSWC

% Last Modified by GUIDE v2.5 27-Oct-2020 15:14:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @importSWC_OpeningFcn, ...
                   'gui_OutputFcn',  @importSWC_OutputFcn, ...
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


% --- Executes just before importSWC is made visible.
function importSWC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to importSWC (see VARARGIN)

% Choose default command line output for importSWC
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes importSWC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = importSWC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_importSWC.
function pushbutton_importSWC_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_importSWC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global glob globSWC tis

try
    SPN = globSWC.SPN;
catch err
    SPN = GetMyDir;
end

globSWC.fvDir = [glob.dir.Volumes globSWC.vol '\Analysis\fvLibrary\'];
if ~exist(globSWC.fvDir,'dir'), mkdir(globSWC.fvDir); end
glob.vol.names = getDirs(glob.dir.Volumes);
set(glob.handles.popupmenu_sourceVolume,'String',{'Main' glob.vol.names{:}});


swc = swc2fv(SPN);
tis.cells = swc.cells;
tis.syn = swc.syn;

%%Temp values
tis.cells.type.typeNames = {};
tis.cids = tis.cells.cids;

save([globSWC.fvDir 'tis.mat'],'tis')
tisDat = [];
save([globSWC.fvDir 'tisDat.mat'],'tisDat')


updateCellNavGlob


function edit_cellType_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cellType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cellType as text
%        str2double(get(hObject,'String')) returns contents of edit_cellType as a double


% --- Executes during object creation, after setting all properties.
function edit_cellType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cellType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_subType_Callback(hObject, eventdata, handles)
% hObject    handle to edit_subType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_subType as text
%        str2double(get(hObject,'String')) returns contents of edit_subType as a double


% --- Executes during object creation, after setting all properties.
function edit_subType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_subType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_cid_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cid as text
%        str2double(get(hObject,'String')) returns contents of edit_cid as a double


% --- Executes during object creation, after setting all properties.
function edit_cid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_parseFileNames.
function pushbutton_parseFileNames_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_parseFileNames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_parseGoogleSheet.
function pushbutton_parseGoogleSheet_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_parseGoogleSheet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_googleLink_Callback(hObject, eventdata, handles)
% hObject    handle to edit_googleLink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_googleLink as text
%        str2double(get(hObject,'String')) returns contents of edit_googleLink as a double


% --- Executes during object creation, after setting all properties.
function edit_googleLink_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_googleLink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_parsedNames_Callback(hObject, eventdata, handles)
% hObject    handle to edit_parsedNames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_parsedNames as text
%        str2double(get(hObject,'String')) returns contents of edit_parsedNames as a double


% --- Executes during object creation, after setting all properties.
function edit_parsedNames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_parsedNames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_importVolume_Callback(hObject, eventdata, handles)
% hObject    handle to edit_importVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_importVolume as text
%        str2double(get(hObject,'String')) returns contents of edit_importVolume as a double

global glob globSWC

str = get(hObject,'String')
globSWC.vol = str;


% --- Executes during object creation, after setting all properties.
function edit_importVolume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_importVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_volume.
function popupmenu_volume_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_volume contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_volume

global glob globSWC

val = get(hObject,'Value');
strs = get(hObject,'String');
str = strs{val};
if ~isempty(str)
    set(handles.edit_importVolume,'String',str);
    globSWC.vol = str;
end



% --- Executes during object creation, after setting all properties.
function popupmenu_volume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob globSWC

if ~isempty(glob.vol.names)
    
    set(hObject,'String',glob.vol.names)
    set(hObject,'Value',1)
end



% --- Executes on button press in pushbutton_getDir.
function pushbutton_getDir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_getDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob globSWC

globSWC.SPN = GetMyDir;
set(handles.edit_sourceDir,'String',globSWC.SPN);

function edit_sourceDir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sourceDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sourceDir as text
%        str2double(get(hObject,'String')) returns contents of edit_sourceDir as a double


% --- Executes during object creation, after setting all properties.
function edit_sourceDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sourceDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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
