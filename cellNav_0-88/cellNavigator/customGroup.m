function varargout = customGroup(varargin)
% CUSTOMGROUP MATLAB code for customGroup.fig
%      CUSTOMGROUP, by itself, creates a new CUSTOMGROUP or raises the existing
%      singleton*.
%
%      H = CUSTOMGROUP returns the handle to a new CUSTOMGROUP or the handle to
%      the existing singleton*.
%
%      CUSTOMGROUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CUSTOMGROUP.M with the given input arguments.
%
%      CUSTOMGROUP('Property','Value',...) creates a new CUSTOMGROUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before customGroup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to customGroup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help customGroup

% Last Modified by GUIDE v2.5 28-Aug-2020 11:25:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @customGroup_OpeningFcn, ...
                   'gui_OutputFcn',  @customGroup_OutputFcn, ...
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


% --- Executes just before customGroup is made visible.
function customGroup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to customGroup (see VARARGIN)

% Choose default command line output for customGroup
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes customGroup wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global glob globCG

globCG.h = handles;
globCG.addG = glob.defaultG;
globCG.subG = glob.defaultG;
globCG.newName = '';

updateCG



% --- Outputs from this function are returned to the command line.
function varargout = customGroup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listboxAddGroups.
function listboxAddGroups_Callback(hObject, eventdata, handles)
% hObject    handle to listboxAddGroups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxAddGroups contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxAddGroups

global glob globCG

val = get(hObject,'Value')+1;

keep = setdiff(1:length(globCG.addG),val);
globCG.addG = globCG.addG(keep);
addNames = {globCG.addG(2:end).name};
set(hObject,'Value',1);
set(hObject,'String',addNames);


% --- Executes during object creation, after setting all properties.
function listboxAddGroups_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxAddGroups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuAddGroups.
function popupmenuAddGroups_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuAddGroups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuAddGroups contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuAddGroups


global glob globCG

val = get(hObject,'Value');

L = length(globCG.addG);
for i = 1:length(val)    
    globCG.addG(L+i) = globCG.g(val(i));
end

addNames = {globCG.addG(2:end).name};
set(globCG.h.listboxAddGroups,'String',addNames);


% --- Executes during object creation, after setting all properties.
function popupmenuAddGroups_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuAddGroups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







% --- Executes on selection change in listboxSubtractGroups.
function listboxSubtractGroups_Callback(hObject, eventdata, handles)
% hObject    handle to listboxSubtractGroups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxSubtractGroups contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxSubtractGroups

global glob globCG

val = get(hObject,'Value')+1;

keep = setdiff(1:length(globCG.subG),val);
globCG.subG = globCG.subG(keep);
subNames = {globCG.subG(2:end).name};
set(hObject,'Value',1);
set(hObject,'String',subNames);


% --- Executes during object creation, after setting all properties.
function listboxSubtractGroups_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxSubtractGroups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuSubtractGroups.
function popupmenuSubtractGroups_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuSubtractGroups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuSubtractGroups contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuSubtractGroups

global glob globCG

val = get(hObject,'Value');

L = length(globCG.subG);
for i = 1:length(val)    
    globCG.subG(L+i) = globCG.g(val(i));
end

subNames = {globCG.subG(2:end).name};
set(globCG.h.listboxSubtractGroups,'String',subNames);

% --- Executes during object creation, after setting all properties.
function popupmenuSubtractGroups_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuSubtractGroups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonCreateGroup.
function pushbuttonCreateGroup_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCreateGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



global glob globCG


newGroup = glob.defaultG;

aIdx = [];
aCid = [];
aCol = [];

for i = 2:length(globCG.addG)
    aIdx = [aIdx globCG.addG(i).idx];
    aCid = [aCid globCG.addG(i).cid];
    aCol = cat(1,aCol,globCG.addG(i).col);
end

sIdx = [globCG.subG.idx];

uIdx = unique(setdiff(aIdx,sIdx));

[a keepIdx] = intersect(aIdx,uIdx);

newGroup.idx = aIdx(keepIdx);
newGroup.cid = aCid(keepIdx);
newGroup.col = aCol(keepIdx,:);
newGroup.show = get(glob.handles.togglebutton_showGroup,'Value');

v = length(glob.g)+1;

newGroup.name = sprintf('g%d - %s',v,globCG.newName);
glob.g(v) = newGroup;

showCellGroup(v)
updateGroups

function showCellGroup(v)

global glob globCG tis


val = tis.cells.cids(glob.g(v).idx);

if glob.g(v).show
    
    try
        for r = 1:length(glob.g(v).patch)
            delete(glob.g(v).patch(r))
        end
    end
    
    for i = 1:length(val)
        fileName = sprintf('%s%d.mat',glob.useFvDir,val(i));
        fv = loadFV(fileName);;
        glob.g(v).patch(i) = renderFVnav(fv,glob.g(v).col(i,:),glob.g(v).alph,val(i));
        pause(.01)
    end
else
    glob.g(v).patch = [];
end


function updateGroups

%newVal = max(min(G,length(groupNames)),1);
global glob globOb
groupNames ={glob.g.name};
if length(groupNames)<1;
    groupNames = {' '};
end
set(glob.handles.renderGroups_popUp,'String',groupNames)
set(glob.handles.renderGroups_popUp,'Value',length(groupNames))
set(glob.handles.popupmenu_synPreGroup,'String',groupNames)
set(glob.handles.popupmenu_synPostGroup,'String',groupNames)
set(glob.handles.popupmenu_synPreGroup,'Value',length(groupNames))
set(glob.handles.popupmenu_synPostGroup,'Value',length(groupNames))

if length(glob.g)
    L = get(glob.handles.renderGroups_popUp,'Value');
    set(glob.handles.subColor_popUp,'Value',glob.g(L).colIdx);
    set(glob.handles.subAlpha_popUp,'Value',glob.g(L).alphIdx);
    set(glob.handles.togglebutton_showGroup,'Value',glob.g(L).show);
end



function updateCG

global glob globCG

globCG.g = glob.g;
gNames = {globCG.g.name};

if length(gNames)>0
    set(globCG.h.popupmenuAddGroups,'String',gNames);
    set(globCG.h.popupmenuSubtractGroups,'String',gNames);
end





% --- Executes on button press in pushbuttonUpdate.
function pushbuttonUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

updateCG



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

global glob globCG
str = get(hObject,'String');

globCG.newName = str;




% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


global glob globCG


globCG.newName = get(hObject,'String');
