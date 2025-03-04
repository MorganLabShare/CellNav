function varargout = customObject(varargin)
% CUSTOMOBJECT MATLAB code for customObject.fig
%      CUSTOMOBJECT, by itself, creates a new CUSTOMOBJECT or raises the existing
%      singleton*.
%
%      H = CUSTOMOBJECT returns the handle to a new CUSTOMOBJECT or the handle to
%      the existing singleton*.
%
%      CUSTOMOBJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CUSTOMOBJECT.M with the given input arguments.
%
%      CUSTOMOBJECT('Property','Value',...) creates a new CUSTOMOBJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before customObject_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to customObject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help customObject

% Last Modified by GUIDE v2.5 25-Aug-2020 17:13:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @customObject_OpeningFcn, ...
                   'gui_OutputFcn',  @customObject_OutputFcn, ...
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


% --- Executes just before customObject is made visible.
function customObject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to customObject (see VARARGIN)

% Choose default command line output for customObject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes customObject wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global glob ob
ob.h = handles;
ob.segStr = 'All';
ob.volStr = glob.vol.names{1};
ob.cidStr = 'All';
ob.filtStr = '';
ob.selIds = [];
ob.selNames = {};


% --- Outputs from this function are returned to the command line.
function varargout = customObject_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu_Volumes.
function popupmenu_Volumes_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Volumes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Volumes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Volumes

global ob glob

strs = get(hObject,'String');
val = get(hObject,'Value');
str = strs{val};

ob.volStr = str;
ob.volID = val-1;

ob.segDir = [glob.datDir 'Volumes\' ob.volStr '\Merge\'];
load([ob.segDir 'obI.mat']);
load([glob.datDir 'Volumes\' ob.volStr '\Analysis\tis.mat']);
cidStr = sprintfc('%d',tis.cids);
set(handles.popupmenu_cids,'String',{'All' cidStr{:}});

ob.segStrs = obI.fuse.exportDir;
set(handles.popupmenu_segmentations,'String',{'All' ob.segStrs{:}});



updateObFig


% --- Executes during object creation, after setting all properties.
function popupmenu_Volumes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Volumes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob
set(hObject,'String',{'All' glob.vol.names{:}})

% --- Executes on selection change in popupmenu_segmentations.
function popupmenu_segmentations_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_segmentations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_segmentations contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_segmentations


global glob ob


strs = get(hObject,'String');
val = get(hObject,'Value');
str = strs{val};

ob.segStr = str;
ob.segID = val-1;

updateObFig

% --- Executes during object creation, after setting all properties.
function popupmenu_segmentations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_segmentations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String','All')
set(hObject,'Value',1);

function edit_nameFilter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nameFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nameFilter as text
%        str2double(get(hObject,'String')) returns contents of edit_nameFilter as a double

global glob ob

ob.filtStr = get(hObject,'String');

updateObFig

% --- Executes during object creation, after setting all properties.
function edit_nameFilter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nameFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_filter.
function listbox_filter_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_filter contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_filter


% --- Executes during object creation, after setting all properties.
function listbox_filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_groups.
function popupmenu_groups_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_groups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_groups contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_groups


% --- Executes during object creation, after setting all properties.
function popupmenu_groups_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_groups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_selected.
function listbox_selected_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_selected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_selected contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_selected


% --- Executes during object creation, after setting all properties.
function listbox_selected_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_selected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton_OnOff.
function togglebutton_OnOff_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_OnOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_OnOff


% --- Executes on selection change in popupmenu_color.
function popupmenu_color_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_color


% --- Executes during object creation, after setting all properties.
function popupmenu_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_alpha.
function popupmenu_alpha_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_alpha contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_alpha


% --- Executes during object creation, after setting all properties.
function popupmenu_alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function updateObFig

global glob ob


load([ob.segDir 'obI.mat']);

%% Filter for segmentation

isSeg = zeros(length(obI.nameProps.names),1);
if strcmp(ob.segStr,'All')
    isSeg = isSeg + 1;
else
    segID = 0;
    for i = 1:length(ob.segStrs)
        if strcmp(ob.segStrs{i},ob.segStr)
            segID = i;
            break
        end
    end
    isSeg(obI.fuse.obSource == segID) = 1;
end

%% filter for cids

isCid = zeros(length(obI.nameProps.names),1);
if regexp(ob.cidStr,'All')
    isCid = isCid+1;
else
    targ = find(obI.cell.name==str2num(ob.cidStr));
    obTarg = obI.cell.obIDs{targ};
    isCid(obTarg) = 1;
end

%% Filter for text

isText = zeros(length(obI.nameProps.names),1);
if strcmp(ob.filtStr, '')
    isText = isText + 1;
else
    for i = 1:length(isText)
        hit = regexp(obI.nameProps.names{i},ob.filtStr);
        if ~isempty(hit)
            isText(i) = 1;
        end
    end
end
    
%% Get names
ob.filtNameIds = find(isSeg & isCid & isText);
ob.filtNames = obI.nameProps.names(ob.filtNameIds);
source =  {obI.fuse.exportDir{obI.fuse.obSource(ob.filtNameIds)}};
clear showNams 
ns = 15;
for i = 1:length(ob.filtNameIds)
    clear showNam
    nam = ob.filtNames{i};
    src = source{i};
    
    
    frontMax = min(ns,length(src));
    backStart = ns+3+1;
    backStop = ns+ 3 + length(nam);
    showNam(1:frontMax) = src(1:frontMax);
    showNam(frontMax+1:backStart) = '_';
    showNam(backStart:backStop) = nam;
    showNams{i} = showNam;
end

set(ob.h.listbox_filter,'Value',[])
set(ob.h.listbox_filter,'String',showNams)



% --- Executes on selection change in popupmenu_cids.
function popupmenu_cids_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_cids (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_cids contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_cids

global glob ob

strs = get(hObject,'String');
val = get(hObject,'Value');
str = strs{val};

ob.cidStr = str;
ob.cidID = val-1;

updateObFig



% --- Executes during object creation, after setting all properties.
function popupmenu_cids_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_cids (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_select.
function pushbutton_select_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob ob

val = get(handles.listbox_filter,'Value');
strs = get(handles.listbox_filter,'String');
%str = strs(val);
str = ob.filtNames(val);
newIds = ob.filtNameIds(val);
ob.selIds = cat(1,ob.selIds(:),newIds(:));
ob.selNames = cat(1,ob.selNames(:),str(:));
set(handles.listbox_selected,'String',ob.selNames)


% --- Executes on button press in pushbutton_remove.
function pushbutton_remove_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global glob ob

val = get(ob.h.listbox_selected,'Value');
strs = get(ob.h.listbox_selected,'String');
str = strs(val);
keepIds = setdiff(1:length(strs),val);

ob.selIds = ob.selIds(keepIds);
ob.selNames = ob.selNames(keepIds);
set(ob.h.listbox_selected,'String',ob.selNames)
set(ob.h.listbox_selected,'Value',[])


% --- Executes on button press in pushbutton_group.
function pushbutton_group_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob ob

%%Create temp FV
load([glob.dir.Volumes ob.volStr '\Merge\dsObj.mat'])
load([glob.dir.Volumes ob.volStr '\Merge\obI.mat'])

%%Create group
if isfield(glob,'g')
    L = length(glob.g)+1;
else
    L = 1;
end

glob.g(L) = glob.defaultG;
glob.g(L).idx = ob.selIds;
glob.g(L).cid = ob.selNames;
glob.g(L).col = repmat([rand rand rand],[length(glob.g(L).idx) 1]);
glob.g(L).show = get(glob.handles.togglebutton_showGroup,'Value');

namStr = get(handles.edit_groupName,'String');
if ~isempty(namStr)
    glob.g(L).name = sprintf('cg%d - %s',L,namStr);
else
    glob.g(L).name = sprintf('cg%d - %s',L,ob.selNames{1});
end

drawObj(glob.app,dsObj,obI,ob.selIds,L)

updateGroups



% --- Executes on button press in pushbutton_deleteGroup.
function pushbutton_deleteGroup_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_deleteGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function updateGroups


%newVal = max(min(G,length(groupNames)),1);
global glob
groupNames ={glob.g.name};
if length(groupNames)<1;
    groupNames = {' '};
end
L = length(groupNames);
glob.app.popupmenu_synPreGroup.Items = groupNames;
glob.app.popupmenu_synPreGroup.ItemsData = 1:L;
glob.app.popupmenu_synPreGroup.Value = 1;

glob.app.popupmenu_synPostGroup.Items = groupNames;
glob.app.popupmenu_synPostGroup.ItemsData = 1:L;
glob.app.popupmenu_synPostGroup.Value = 1;

glob.app.renderGroups_popUp.Items = groupNames;
glob.app.renderGroups_popUp.ItemsData = 1:length(groupNames);
glob.app.renderGroups_popUp.Value = L;

if length(glob.g)
    L = glob.app.renderGroups_popUp.Value;
    glob.app.subColor_popUp.Value=glob.g(L).colIdx;
    glob.app.subAlpha_popUp.Value=glob.g(L).alphIdx;
    glob.app.togglebutton_showGroup.Value=glob.g(L).show;
end



function edit_groupName_Callback(hObject, eventdata, handles)
% hObject    handle to edit_groupName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_groupName as text
%        str2double(get(hObject,'String')) returns contents of edit_groupName as a double


% --- Executes during object creation, after setting all properties.
function edit_groupName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_groupName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
