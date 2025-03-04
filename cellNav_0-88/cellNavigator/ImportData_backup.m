function varargout = ImportData(varargin)
% IMPORTDATA MATLAB code for ImportData.fig
%      IMPORTDATA, by itself, creates a new IMPORTDATA or raises the existing
%      singleton*.
%
%      H = IMPORTDATA returns the handle to a new IMPORTDATA or the handle to
%      the existing singleton*.
%
%      IMPORTDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMPORTDATA.M with the given input arguments.
%
%      IMPORTDATA('Property','Value',...) creates a new IMPORTDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImportData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImportData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImportData

% Last Modified by GUIDE v2.5 20-Jun-2020 08:15:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImportData_OpeningFcn, ...
                   'gui_OutputFcn',  @ImportData_OutputFcn, ...
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


% --- Executes just before ImportData is made visible.
function ImportData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImportData (see VARARGIN)

% Choose default command line output for ImportData
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImportData wait for user response (see UIRESUME)
% uiwait(handles.figure1);
disp('Opening Input Data window')

% --- Outputs from this function are returned to the command line.
function varargout = ImportData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_Close.
function pushbutton_Close_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.figure1)


% --- Executes on button press in pushbutton_runVastExport.
function pushbutton_runVastExport_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_runVastExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob

set(handles.textOut,'String','Exporting VAST segmentation...')
makeMPNcnv

glob.NA.export.dsRes = str2num(get(handles.edit_dsResolution,'String'));
glob.NA.export.mipLevel = get(handles.edit_mipLevel,'Value')-1;

Y = str2num(get(handles.edit_VASTvoxY,'String'));
X = str2num(get(handles.edit_VASTvoxX,'String'));
Z = str2num(get(handles.edit_VASTvoxZ,'String'));
glob.NA.export.volRes = [Y X Z];

vastLink2MatStructs_SubVol_cnv
if glob.NA.export.segNum
    mergeVast_cnv
    set(handles.textOut,'String','Export Complete')
else
    set(handles.textOut,'String','No segments found. Try Enabling VAST remote API server.')
end


glob.vol.names = getDirs(glob.dir.Volumes);


% --- Executes on button press in pushbutton_MPN.
function pushbutton_MPN_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_MPN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob

glob.datDir = uigetdir(glob.datDir);
glob.datDir = [glob.datDir '\'];
makeMPNcnv
set(handles.edit_exportDirectory,'String',glob.datDir);


updateDirectories(handles)
dirMPN = dir(glob.NA.MPN);
isFold = setdiff(find([dirMPN.isdir]),[1 2]);
names = {dirMPN(isFold).name};
glob.NA.export.exportFolders = names;
set(handles.popupmenu_replaceExisting,'String',names);
set(handles.popupmenu_replaceExisting,'Value',1);




function edit_exportDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to edit_exportDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_exportDirectory as text
%        str2double(get(hObject,'String')) returns contents of edit_exportDirectory as a double


global glob

str = get(hObject,'String');
glob.datDir = str;
glob.dir.Volumes = [glob.datDir 'Volumes\'];
if ~exist(glob.dir.Volumes,'dir')
    mkdir(glob.dir.Volumes);
end
glob.dir.volNames = getDirs(glob.dir.Volumes);
if ~isempty(glob.dir.volNames)
    set(handles.popupmenu_Merge,'String',glob.dir.volNames);
else
    set(handles.popupmenu_Merge,'String',{' '});
end

vol = get(handles.edit_mergeDir,'String');
glob.NA.MPN = [glob.dir.vol  vol '\Merge\'];
makeMPNcnv

dirMPN = dir(glob.NA.MPN);
isFold = setdiff(find([dirMPN.isdir]),[1 2]);
names = {dirMPN(isFold).name};
glob.NA.export.exportFolders = names;
if ~isempty(names)
    set(handles.popupmenu_replaceExisting,'String',names);
else
    set(handles.popupmenu_replaceExisting,'String',{' '});
end
set(handles.popupmenu_replaceExisting,'Value',1);


% --- Executes during object creation, after setting all properties.
function edit_exportDirectory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_exportDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob
set(hObject,'String',glob.datDir);



function edit_exportName_Callback(hObject, eventdata, handles)
% hObject    handle to edit_exportName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_exportName as text
%        str2double(get(hObject,'String')) returns contents of edit_exportName as a double


global glob
str = get(hObject,'String');
glob.NA.export.exportName = str;




% --- Executes during object creation, after setting all properties.
function edit_exportName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_exportName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob

set(hObject,'String',glob.NA.export.exportName)



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


% --- Executes on selection change in popupmenu_replaceExisting.
function popupmenu_replaceExisting_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_replaceExisting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_replaceExisting contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_replaceExisting

strs = get(hObject,'String');
val = get(hObject,'Value');
str = strs{val};
set(handles.edit_exportName,'String',str);
glob.NA.export.exportName = str;




% --- Executes during object creation, after setting all properties.
function popupmenu_replaceExisting_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_replaceExisting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob

dirMPN = dir(glob.NA.MPN);
isFold = setdiff(find([dirMPN.isdir]),[1 2]);
names = {dirMPN(isFold).name};
glob.NA.export.exportFolders = names;

if ~isempty(names)
set(hObject,'String',names);
else
    set(hObject,'String',' ');
end


% --- Executes on button press in pushbutton_makeCellLibrary.
function pushbutton_makeCellLibrary_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_makeCellLibrary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob

set(handles.textOut,'String','Makeing cell library ...')
pause(.01)
makeMPNcnv
makeCellLibrary
set(handles.textOut,'String','Finished cell library.')

glob.vol.names = getDirs(glob.dir.Volumes);
vDir = glob.dir.Volumes;
libNames = {};
for i = 1:length(glob.vol.names);
    if exist([vDir glob.vol.names{i} '\Analysis\fvLibrary'],'dir')
        libNames = cat(1,libNames,glob.vol.names{i});
    end
end

glob.vol.libNames = libNames;

set(handles.popupmenu_availFvLib,'Value',1);
if ~isempty(libNames)
set(handles.popupmenu_availFvLib,'String',libNames);
else
   set(handles.popupmenu_availFvLib,'String',' ');
end



% --- Executes on button press in pushbutton_refreshCellNav.
function pushbutton_refreshCellNav_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_refreshCellNav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob
close(glob.handles.figure1);
runCellNav


% --- Executes on selection change in edit_mipLevel.
function edit_mipLevel_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mipLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns edit_mipLevel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from edit_mipLevel


% --- Executes during object creation, after setting all properties.
function edit_mipLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mipLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_VASTvoxY_Callback(hObject, eventdata, handles)
% hObject    handle to edit_VASTvoxY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_VASTvoxY as text
%        str2double(get(hObject,'String')) returns contents of edit_VASTvoxY as a double


% --- Executes during object creation, after setting all properties.
function edit_VASTvoxY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_VASTvoxY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_VASTvoxX_Callback(hObject, eventdata, handles)
% hObject    handle to edit_VASTvoxX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_VASTvoxX as text
%        str2double(get(hObject,'String')) returns contents of edit_VASTvoxX as a double


% --- Executes during object creation, after setting all properties.
function edit_VASTvoxX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_VASTvoxX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_VASTvoxZ_Callback(hObject, eventdata, handles)
% hObject    handle to edit_VASTvoxZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_VASTvoxZ as text
%        str2double(get(hObject,'String')) returns contents of edit_VASTvoxZ as a double


% --- Executes during object creation, after setting all properties.
function edit_VASTvoxZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_VASTvoxZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dsResolution_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dsResolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dsResolution as text
%        str2double(get(hObject,'String')) returns contents of edit_dsResolution as a double


% --- Executes during object creation, after setting all properties.
function edit_dsResolution_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dsResolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_Merge.
function popupmenu_Merge_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Merge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Merge contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Merge

global glob

strs = get(hObject,'String');
val = get(hObject,'Value');
str = strs{val};
set(handles.edit_mergeDir,'String',str);

glob.NA.export.volName = str;
glob.NA.export.volDir = [glob.dir.Volumes  glob.NA.export.volName '\'];
glob.NA.MPN = [glob.NA.export.volDir  'Merge\'];
makeMPNcnv

glob.NA.export.segNames = getDirs(glob.NA.MPN);
set(handles.popupmenu_replaceExisting,'Value',1)

if isempty(glob.NA.export.segNames)
    set(handles.popupmenu_replaceExisting,'String',{' '})
else
    set(handles.popupmenu_replaceExisting,'String',glob.NA.export.segNames)
end





% --- Executes during object creation, after setting all properties.
function popupmenu_Merge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Merge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob
set(hObject,'Value',1)

if length(glob.vol.names)>0
    set(hObject,'String',glob.dir.volNames)
else
    set(hObject,'String',{' '})
end


function edit_mergeDir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mergeDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mergeDir as text
%        str2double(get(hObject,'String')) returns contents of edit_mergeDir as a double

global glob

str = get(handles.edit_exportDirectory,'String');
glob.datDir = str;
glob.dir.Volumes = [glob.datDir 'Volumes\'];
if ~exist(glob.dir.Volumes,'dir')
    mkdir(glob.dir.Volumes);
end
glob.dir.volNames = getDirs(glob.dir.Volumes);

vol = get(handles.edit_mergeDir,'String');
glob.NA.export.volDir = [glob.dir.Volumes vol '\'];
glob.NA.MPN = [glob.NA.export.volDir  'Merge\'];
makeMPNcnv

glob.NA.export.segNames = getDirs(glob.NA.MPN);
set(handles.popupmenu_replaceExisting,'Value',1)

if isempty(glob.NA.export.segNames)
    set(handles.popupmenu_replaceExisting,'String',{' '})
else
    set(handles.popupmenu_replaceExisting,'String',glob.NA.export.segNames)
end






% --- Executes during object creation, after setting all properties.
function edit_mergeDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mergeDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob


try
    set(hObject,'String',glob.dir.volNames{1})
end
try 
    set(hObject,'String',glob.NA.export.volName);
end

% --- Executes on selection change in popupmenu_availFvLib.
function popupmenu_availFvLib_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_availFvLib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_availFvLib contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_availFvLib


global glob

val = get(hObject,'Value');
strs = get(hObject,'String');
str = strs{val};

%uStr = get(handles.popupmenu_useFvLib,'String');
uStr = glob.NA.export.useLib;

isU = 0;
for i = 1:length(uStr)
    if strcmp(uStr{i},str)
        isU = 1;
    end
end

if ~isU
   uStr{end+1} =str; 
end
glob.NA.export.useLib = uStr;
set(handles.popupmenu_useFvLib,'String',uStr)

% --- Executes during object creation, after setting all properties.
function popupmenu_availFvLib_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_availFvLib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

str  = glob.vol.libNames;
if ~isempty(str)
    set(hObject,'String',str)
end


% --- Executes on selection change in popupmenu_useFvLib.
function popupmenu_useFvLib_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_useFvLib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_useFvLib contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_useFvLib


global glob
val = get(hObject,'Value');
%strs = get(hObject,'String');
strs = glob.NA.export.useLib;
strs = strs(setdiff([1:length(strs)],val));
glob.NA.export.useLib = strs;
set(hObject,'Value',1)
if ~isempty(strs)
    set(hObject,'String',strs)
else
    set(hObject,'String',{' '})
end



% --- Executes during object creation, after setting all properties.
function popupmenu_useFvLib_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_useFvLib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_mergeLibraries.
function pushbutton_mergeLibraries_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_mergeLibraries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function updateDirectories(handles)


global glob

%%Get DataDirectory
str = get(handles.edit_exportDirectory,'String');
glob.datDir = str;
glob.dir.Volumes = [glob.datDir 'Volumes\'];
if ~exist(glob.dir.Volumes,'dir')
    mkdir(glob.dir.Volumes);
end

%%Get volumes
glob.vol.names = getDirs(glob.dir.Volumes);
if get(handles.popupmenu_Merge,'Value')> max(length(glob.vol.names),1)
    set(handles.popupmenu_Merge,'Value',1);
end
if ~isempty(glob.vol.names)
    set(handles.popupmenu_Merge,'String',glob.vol.names);
else
    set(handles.popupmenu_Merge,'String',{' '});
end

%%GEt MPN
vol = get(handles.edit_mergeDir,'String');
glob.NA.MPN = [glob.dir.Volumes  vol '\Merge\'];
makeMPNcnv

%%Get segment names
dirMPN = dir(glob.NA.MPN);
isFold = setdiff(find([dirMPN.isdir]),[1 2]);
names = {dirMPN(isFold).name};
glob.NA.export.segNames = names;

%%Set Segment names
if get(handles.popupmenu_replaceExisting,'Value')> max(length(names),1)
    set(handles.popupmenu_replaceExisting,'Value',1);
end

if ~isempty(names)
    set(handles.popupmenu_replaceExisting,'String',names);
else
    set(handles.popupmenu_replaceExisting,'String',{' '});
end

segStr = get(handles.edit_exportName,'String');
glob.NA.export.exportDir = segStr;


%%Get fvLibraries
vDir = glob.dir.Volumes;
libNames = {};
for i = 1:length(glob.vol.names);
    if exist([vDir glob.vol.names{i} '\Analysis\fvLibrary'],'dir')
        libNames = cat(1,libNames,glob.vol.names{i});
    end
end

glob.vol.libNames = libNames;
glob.NA.export.useLib = libNames;

set(handles.popupmenu_availFvLib,'Value',1);
if ~isempty(libNames)
set(handles.popupmenu_availFvLib,'String',libNames);
else
   set(handles.popupmenu_availFvLib,'String',' ');
end


set(handles.popupmenu_useFvLib,'Value',1);
if ~isempty(libNames)
set(handles.popupmenu_useFvLib,'String',libNames);
else
   set(handles.popupmenu_useFvLib,'String',' ');
end






% --- Executes on button press in pushbutton_refresh.
function pushbutton_refresh_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 updateDirectories(handles)
