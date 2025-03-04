function varargout = customSynGroup(varargin)
% CUSTOMSYNGROUP MATLAB code for customSynGroup.fig
%      CUSTOMSYNGROUP, by itself, creates a new CUSTOMSYNGROUP or raises the existing
%      singleton*.
%
%      H = CUSTOMSYNGROUP returns the handle to a new CUSTOMSYNGROUP or the handle to
%      the existing singleton*.
%
%      CUSTOMSYNGROUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CUSTOMSYNGROUP.M with the given input arguments.
%
%      CUSTOMSYNGROUP('Property','Value',...) creates a new CUSTOMSYNGROUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before customSynGroup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to customSynGroup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help customSynGroup

% Last Modified by GUIDE v2.5 28-Aug-2020 12:06:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @customSynGroup_OpeningFcn, ...
                   'gui_OutputFcn',  @customSynGroup_OutputFcn, ...
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


% --- Executes just before customSynGroup is made visible.
function customSynGroup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to customSynGroup (see VARARGIN)

% Choose default command line output for customSynGroup
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes customSynGroup wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global glob globSG

globSG.h = handles;
globSG.addG = glob.syn.defaultG;
globSG.subG = glob.syn.defaultG;
globSG.newName = '';

updateSG



% --- Outputs from this function are returned to the command line.
function varargout = customSynGroup_OutputFcn(hObject, eventdata, handles) 
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

global glob globSG

val = get(hObject,'Value')+1;

keep = setdiff(1:length(globSG.addG),val);
globSG.addG = globSG.addG(keep);
addNames = {globSG.addG(2:end).name};
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


global glob globSG

val = get(hObject,'Value');

L = length(globSG.addG);
for i = 1:length(val)    
    globSG.addG(L+i) = globSG.g(val(i));
end

addNames = {globSG.addG(2:end).name};
set(globSG.h.listboxAddGroups,'String',addNames);


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

global glob globSG

val = get(hObject,'Value')+1;

keep = setdiff(1:length(globSG.subG),val);
globSG.subG = globSG.subG(keep);
subNames = {globSG.subG(2:end).name};
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

global glob globSG

val = get(hObject,'Value');

L = length(globSG.subG);
for i = 1:length(val)    
    globSG.subG(L+i) = globSG.g(val(i));
end

subNames = {globSG.subG(2:end).name};
set(globSG.h.listboxSubtractGroups,'String',subNames);

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

global glob globSG

newGroup = glob.syn.defaultG;

aPos = [];
for i = 2:length(globSG.addG)
    aPos = cat(1,aPos, globSG.addG(i).pos);
end

sPos = [];
for i = 2:length(globSG.subG)
    sPos = cat(1,sPos, globSG.subG(i).pos);
end

if ~isempty(aPos)
    mult = 10000;
    maxVal = max([aPos(:); sPos(:)])*mult;
    
    aInd = sub2ind([maxVal maxVal maxVal],...
        aPos(:,1)*mult,aPos(:,2)*mult,aPos(:,3)*mult);
    if isempty(sPos)
        sInd = [];
    else
        sInd = sub2ind([maxVal maxVal maxVal],...
            sPos(:,1)*mult,sPos(:,2)*mult,sPos(:,3)*mult);
    end
    nInd = unique(setdiff(aInd,sInd));
    
    [Y X Z] = ind2sub([maxVal maxVal maxVal],nInd);
    nPos = [Y X Z]./mult;
    
    newGroup.pos = nPos;
    
    v = length(glob.syn.g)+1;
    newGroup.name = sprintf('g%d - %s',v,globSG.newName);
    
    glob.syn.g(v) = newGroup;
    
%     groupName = {glob.syn.g(v).name};
%     groupNames = cat(1,get(glob.handles.popupmenu_synGroup,'String'),groupName);
%     set(glob.handles.popupmenu_synGroup,'String',groupNames)
%     set(glob.handles.popupmenu_synGroup,'Value',length(groupNames))
    
    synGroup2Panel(v)
    drawSyn(v)
end


function synGroup2Panel(v)

global glob
val = v;
set(glob.handles.popupmenu_synMarker,'Value',glob.syn.g(val).markerTypeIdx);
set(glob.handles.popupmenu_synMarkerColor,'Value',glob.syn.g(val).colIdx);
set(glob.handles.popupmenu_synMarkerAlpha,'Value',glob.syn.g(val).alphIdx);
set(glob.handles.popupmenu_synPreGroup,'Value',1)
set(glob.handles.popupmenu_synPostGroup,'Value',1)
set(glob.handles.edit_synPreGroup,'String',glob.syn.g(val).preName);
set(glob.handles.edit_synPostGroup,'String',glob.syn.g(val).postName);
set(glob.handles.togglebutton_synVisible,'Value',glob.syn.g(val).show);

gStr = get(glob.handles.popupmenu_synGroup,'String');
gVal = length(gStr)+1;
gStr{gVal} = glob.syn.g(val).name;
set(glob.handles.popupmenu_synGroup,'String',gStr);
set(glob.handles.popupmenu_synGroup,'Value',gVal);

function drawSyn(L)

global glob tis

synfo = glob.syn.g(L);

try 
    delete(synfo.p)
end

pos = glob.syn.g(L).pos;
synText = synfo.name;

set(0,'CurrentFigure',glob.handles.figure1)
set(glob.handles.mainAx, 'NextPlot', 'add')
if ~isempty(pos)
    synfo.p = scatter3(pos(:,1),pos(:,2),pos(:,3),synfo.markerSize,...
        'markerfacecolor',synfo.col,'markerfacealpha',synfo.alph,...
        'marker',synfo.markerType,'markeredgecolor','w');
end
set(synfo.p,'clipping','off')
glob.syn.g(L) =  synfo;
% 
% gStr = get(glob.handles.popupmenu_synGroup,'String');
% gVal = get(glob.handles.popupmenu_synGroup,'Value');
% gStr{gVal} = synfo.name;
% set(glob.handles.popupmenu_synGroup,'String',gStr);

set(glob.handles.textOut,'String',synText );


function updateSG

global glob globSG

globSG.g = glob.syn.g;
gNames = {globSG.g.name};

if length(gNames)>0
    set(globSG.h.popupmenuAddGroups,'String',gNames);
    set(globSG.h.popupmenuSubtractGroups,'String',gNames);
end





% --- Executes on button press in pushbuttonUpdate.
function pushbuttonUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

updateSG



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

global glob globSG
str = get(hObject,'String');

globSG.newName = str;




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


global glob globSG


globSG.newName = get(hObject,'String');
