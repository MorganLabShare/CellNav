function varargout = cellTable(varargin)
% CELLTABLE MATLAB code for cellTable.fig
%      CELLTABLE, by itself, creates a new CELLTABLE or raises the existing
%      singleton*.
%
%      H = CELLTABLE returns the handle to a new CELLTABLE or the handle to
%      the existing singleton*.
%
%      CELLTABLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELLTABLE.M with the given input arguments.
%
%      CELLTABLE('Property','Value',...) creates a new CELLTABLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cellTable_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cellTable_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cellTable

% Last Modified by GUIDE v2.5 03-Jul-2020 19:43:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cellTable_OpeningFcn, ...
                   'gui_OutputFcn',  @cellTable_OutputFcn, ...
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


% --- Executes just before cellTable is made visible.
function cellTable_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cellTable (see VARARGIN)

% Choose default command line output for cellTable
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cellTable wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global globTable glob

globTable.handles = handles;

globTable.cids = glob.pickCID;


updateTable

% --- Outputs from this function are returned to the command line.
function varargout = cellTable_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_cellList_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cellList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cellList as text
%        str2double(get(hObject,'String')) returns contents of edit_cellList as a double

global globTable

str = get(hObject,'String');
val = str2num(str);

if ~isempty(val)
    globTable.cids = val;
else
    'input needs numbers'
    set(hObject,'String','input needs numbers')
    pause(2)
    set(hObject,'String',num2str(globTable.cids))
end


% --- Executes during object creation, after setting all properties.
function edit_cellList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cellList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function updateTable


global glob globTable tis


h = globTable.handles;
set(h.popupmenu_addCellGroup,'String',{glob.g.name});
set(h.edit_cellList,'String',num2str(globTable.cids))

allRes = [];

c = 1;

cellList = globTable.cids;


typeNames = tis.cells.type.typeNames';
typeNames = {'unassigned' typeNames{:}};
tNum = length(typeNames);

clear field
field{1,1} = 'cid' ;
field{2,1} = 'total syn';
field{3,1} = 'total INPUTS';
field(4:3+tNum,1) = typeNames;
L = length(field);
field{L+1,1} = 'total OUTPUTS';
field(L+2:L+1+tNum,1) = typeNames;

for c = 1:length(cellList);
    targ = cellList(c);
    
    
    isPreToTarg = find(tis.syn.post == targ);
    isPostToTarg = find(tis.syn.pre == targ);
    
    %pos = tis.syn.synPosDS(isSyn,[2 1 3]) * glob.em.dsRes(1);
    preClass = tis.syn.preClass(isPreToTarg)+1;
    postClass = tis.syn.postClass(isPostToTarg)+1;
    preSynType = tis.syn.synType(isPreToTarg);
    postSynType = tis.syn.synType(isPostToTarg);
    
    
    
    preHist = hist(preClass,1:length(typeNames));
    postHist = hist(postClass,1:length(typeNames));
    
    res(1,c) = targ;
    res(2,c) =  length(isPreToTarg) + length(isPostToTarg);
    res(3,c) = length(isPreToTarg);
    res(4:3+tNum,c) = preHist';
    res(L+1,c) = length(isPostToTarg);
    res(L+2: L+1 + tNum,c) =postHist';
    
    
end

has = sum(res,2);
has(1:2) = 1;

useField = field(has>0);
useRes = res(has>0,:);
resStr = num2str(useRes,'%d   ');
rs = size(resStr,2);

tab = char(' ');
for i = 1:length(useField);
    tab(i,1:length(useField{i})) = useField{i};
    tab(i,21:20 + rs) = resStr(i,:);
end

globTable.useRes = useRes;
globTable.tabStr = tab;

set(globTable.handles.edit_fields,'String',useField(2:end));

set(globTable.handles.uitable1,'RowName',useField(2:end));
set(globTable.handles.uitable1,'ColumnName',cellList);
set(globTable.handles.uitable1,'Data',useRes(2:end,:));


% --- Executes on button press in pushbutton_updateTable.
function pushbutton_updateTable_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_updateTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

updateTable



function edit_fields_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fields (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fields as text
%        str2double(get(hObject,'String')) returns contents of edit_fields as a double


% --- Executes during object creation, after setting all properties.
function edit_fields_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fields (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_addCellGroup.
function popupmenu_addCellGroup_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_addCellGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_addCellGroup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_addCellGroup

global glob globTable

val = get(hObject,'Value');
globTable.cids = glob.g(val).cid;

updateTable


% --- Executes during object creation, after setting all properties.
function popupmenu_addCellGroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_addCellGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_copyTable.
function pushbutton_copyTable_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_copyTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global globTable
updateTable

clipboard('copy',globTable.useRes)
