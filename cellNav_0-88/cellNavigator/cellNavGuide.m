function varargout = cellNavGuide(varargin)
% CELLNAVGUIDE MATLAB code for cellNavGuide.fig
%      CELLNAVGUIDE, by itself, creates a new CELLNAVGUIDE or raises the existing
%      singleton*.
%
%      H = CELLNAVGUIDE returns the handle to a new CELLNAVGUIDE or the handle to
%      the existing singleton*.
%
%      CELLNAVGUIDE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELLNAVGUIDE.M with the given input arguments.
%
%      CELLNAVGUIDE('Property','Value',...) creates a new CELLNAVGUIDE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cellNavGuide_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cellNavGuide_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cellNavGuide

% Last Modified by GUIDE v2.5 31-Mar-2021 16:28:49




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @cellNavGuide_OpeningFcn, ...
    'gui_OutputFcn',  @cellNavGuide_OutputFcn, ...
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

% --- Executes just before cellNavGuide is made visible.
function cellNavGuide_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cellNavGuide (see VARARGIN)

% Choose default command line output for cellNavGuide
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cellNavGuide wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global glob tis
glob.handles = handles;
glob.data.path.Parent = glob.handles.figure1;

z = zoom(gcf);
setAxes3DPanAndZoomStyle(z,glob.handles.mainAx,'limits')



% --- Outputs from this function are returned to the command line.
function varargout = cellNavGuide_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in toggleBorders.
function toggleBorders_Callback(hObject, eventdata, handles)
% hObject    handle to toggleBorders (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleBorders

global glob

val = get(hObject,'Value');
try
    isHand = isvalid(glob.p.pRefINL);
catch err
    isHand = 0;
end

if val
    if isHand
        glob.p.pRefGCL.Visible = 'on';
        glob.p.pRefINL.Visible = 'on';
    else
        load([glob.useFvDir 'ref_gcl nucEdge.mat'])
        glob.p.pRefGCL = renderFVnav(fv,[1 1 0],.5)
        
        load([glob.useFvDir 'ref_inl nucEdge.mat'])
        glob.p.pRefINL = renderFVnav(fv,[1 0 1],.5)
    end
else
    if isHand
        glob.p.pRefGCL.Visible = 'off'
        glob.p.pRefINL.Visible = 'off'
    end
    
end



% --- Executes on button press in toggleScaleBar.
function toggleScaleBar_Callback(hObject, eventdata, handles)
% hObject    handle to toggleScaleBar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleScaleBar
global glob

val = get(hObject,'Value')
try
    isHand = isvalid(glob.p.pRefMicronBar);
catch err
    isHand = 0;
end

if val
    if isHand
        glob.p.pRefMicronBar.Visible = 'on';
        glob.p.pRefMicronPt1.Visible = 'on';
        glob.p.pRefMicronPt2.Visible = 'on';
    else
        load([glob.useFvDir 'ref_10 micron bar.mat'])
        glob.p.pRefMicronBar = renderFVnav(fv,[1 1 1],1)
        
        load([glob.useFvDir 'ref_10 micron point 1.mat'])
        glob.p.pRefMicronPt1 = renderFVnav(fv,[1 1 1],.5)
        
        load([glob.useFvDir 'ref_10 micron point 2.mat'])
        glob.p.pRefMicronPt2 = renderFVnav(fv,[1 1 1],.5)
    end
else
    if isHand
        glob.p.pRefMicronBar.Visible = 'off';
        glob.p.pRefMicronPt1.Visible = 'off';
        glob.p.pRefMicronPt2.Visible = 'off';
    end
end



% --- Executes on button press in toggleBipolars.
function toggleBipolars_Callback(hObject, eventdata, handles)
% hObject    handle to toggleBipolars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleBipolars

global glob tis

val = get(hObject,'Value')

try
    isHand = isvalid(glob.p.pBipolars);
catch err
    isHand = 0;
end

if val
    if isHand
        glob.p.pBipolars.Visible = 'on';
    else
        bipCids = glob.cids(tis.cells.type.typeID == 7);
        vert = [];
        fac = [];
        for i = 1:length(bipCids)
            fileName = sprintf('%s%d.mat',glob.useFvDir,bipCids(i));
            fv = loadFV(fileName);
            fac = cat(1,fac,fv.faces+size(vert,1));
            vert = cat(1,vert,fv.vertices);
        end
        
        fv.vertices = vert;
        fv.faces = fac;
        glob.p.pBipolars = renderFVnav(fv,[0 .8 0],.1)
        
    end
else
    if isHand
        glob.p.pBipolars.Visible = 'off';
    end
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global glob

str = get(hObject,'string');
if iscell(str)
    str = str{1};
end
cid = str2num(str);
idx = find(glob.cids==cid,1);

if isempty(idx)
    set(handles.textOut,'String','cell(cid) not found');
else
    
    
    glob.pickIdx = idx;
    glob.pickCID = cid;
    showPickedCell
end




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

% --- Executes on selection change in popupCellType.
function popupCellType_Callback(hObject, eventdata, handles)
% hObject    handle to popupCellType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupCellType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupCellType

global glob tis


val = get(hObject,'Value');

if val == 1
    glob.listCellidx = 1:length(tis.cids);
    glob.subTypeID = 0;
else
    glob.typeID =glob.typeIDs(val);
    glob.listCellidx = find(tis.cells.type.typeID == glob.typeID);
    glob.subTypeID = 0;
end

set(handles.listCIDs,'Value',1)
set(handles.listCIDs,'String',glob.cellStr(glob.listCellidx))
glob.pickIdx = 1;
glob.pickCID = tis.cids(glob.pickIdx);

if glob.typeID < 1
    subTypeNames = {'all'};
else
    subTypeNames = tis.cells.type.subTypeNames{glob.typeID};
    subTypeNames = cat(2,{'all'},subTypeNames);
end

set(handles.subType_popupMenue,'String',subTypeNames)
set(handles.subType_popupMenue,'Value',1)





% --- Executes during object creation, after setting all properties.
function popupCellType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupCellType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob tis

set(hObject,'String',glob.typeStrings);



% --- Executes on selection change in listCIDs.
function listCIDs_Callback(hObject, eventdata, handles)
% hObject    handle to listCIDs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listCIDs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listCIDs

global glob tis

val = get(hObject,'Value');
glob.pickIdx = glob.listCellidx(val);
glob.pickCID = tis.cids(glob.pickIdx);
showPickedCell





% --- Executes during object creation, after setting all properties.
function listCIDs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listCIDs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


global glob tis
% tis.cells.cids
% tis.cells.label
set(hObject,'String',glob.cellStr(glob.listCellidx) )





% --- Executes during object creation, after setting all properties.
function mainAx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mainAx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate mainAx

global glob

view([0 0])
axis off

set(gca,'color',[0 0 0])
%set(gcf,'color',[0 0 0])
set(gca,'visible','off')



% --- Executes on mouse press over axes background.
function mainAx_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to mainAx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in viewXY.
function viewXY_Callback(hObject, eventdata, handles)
% hObject    handle to viewXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

view([0 270])


% --- Executes on button press in viewXZ.
function viewXZ_Callback(hObject, eventdata, handles)
% hObject    handle to viewXZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


view([0 5 ])

% --- Executes during object creation, after setting all properties.
function viewXZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to viewXZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

a = 3;

% --- Executes on button press in viewYZ.
function viewYZ_Callback(hObject, eventdata, handles)
% hObject    handle to viewYZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

view([92 1])


% --- Executes on button press in prevCell.
function prevCell_Callback(hObject, eventdata, handles)
% hObject    handle to prevCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global glob tis
glob.pickIdx = max(glob.pickIdx - 1, 1);
glob.pickCID = tis.cids(glob.pickIdx);
set(handles.listCIDs,'Value',glob.pickIdx)
showPickedCell

% --- Executes on button press in nextCell.
function nextCell_Callback(hObject, eventdata, handles)
% hObject    handle to nextCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob tis

glob.pickIdx = min(glob.pickIdx + 1, length(glob.listCellidx));
glob.pickCID = tis.cids(glob.pickIdx);
set(handles.listCIDs,'Value',glob.pickIdx)

showPickedCell


function showPickedCell

global glob tis
disp('Showing selected cell')
set(glob.handles.edit1,'String',num2str(glob.pickCID))


pushPostSyn_Callback(glob.handles.pushPostSyn,[],glob.handles);
pushPreSyn_Callback(glob.handles.pushPreSyn,[],glob.handles);
pushPostCells_Callback(glob.handles.pushPostCells,[],glob.handles);
pushPreCell_Callback(glob.handles.pushPreCell,[],glob.handles);

fileName = sprintf('%s%d.mat',glob.useFvDir,glob.pickCID);
fv = loadFV(fileName);;
%     set(handles.mainAx)
%     patch(handles.mainAx,fv);

try
    delete(glob.p.cell)
end
glob.p.cell = renderFVnav(fv,[1 1 1],1,glob.pickCID);
%axis off
pause(.01)

toggleSkeleton_Callback(glob.handles.toggleSkeleton);

toggle_CellData_Callback(glob.handles.toggle_CellData,[],glob.handles) %activate show data for cell
set(glob.handles.textCID ,'Value',1)




% --- Executes on button press in raiseLight.
function raiseLight_Callback(hObject, eventdata, handles)
% hObject    handle to raiseLight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob

a = rand * 360 - 180;
e = rand * 180 - 90;
lightangle(glob.light,a,e);
%
% [a e] = view(glob.handles.mainAx)
% a = mod(a+180 + 180,360)-180
% lightangle(glob.light,a,e);
% [a e] = lightangle(glob.light)

% lightangle(glob.light,-179, -89);
% for i = 1:1000
% [a e] = lightangle(glob.light)
% lightangle(glob.light,mod(a+197,179)-179, mod(e + 92,89)-89);
% pause(.04)
% end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

global glob tis

str = get(hObject,'string');

if isempty(str)
    val = [];
else
    if iscell(str)
        str = str{1};
    end
    val = str2num(str);       
end


glob.pickCIDref = val;



try
    for r = 1:length(glob.p.refCell)
        glob.p.refCell(r).delete
    end
end

for i = 1:length(val)
    
    fileName = sprintf('%s%d.mat',glob.useFvDir,val(i));
    fv = loadFV(fileName);;
    
    glob.p.refCell(i) = renderFVnav(fv,[1 0 0],1,val(i));
    
end




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




% --- Executes on button press in pushPreCell.
function pushPreCell_Callback(hObject, eventdata, handles)
% hObject    handle to pushPreCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global glob tis

val = get(hObject,'Value');

try
    for i = 1:length(glob.p.preCells)
        delete(glob.p.preCells(i));
    end
end


if val
    
    cellCon
    showCells = glob.con.isPre;
    
    colOption = get(handles.listbox_preCol,'Value');
    col = getCol(colOption,length(showCells));
    for i = 1:length(showCells)
        fileName = sprintf('%s%d.mat',glob.useFvDir,showCells(i));
        if exist(fileName,'file')
            fv = loadFV(fileName);;
            glob.p.preCells(i) = renderFVnav(fv,col(i,:),.6)
            glob.p.preCells(i).Tag = num2str(showCells(i));
        end
    end
    
    preText = sprintf('pre to %d = %s',glob.pickCID,num2str(glob.con.isPre'));
    showText(preText);
        
end

function showText(textStr)
global glob
set(glob.handles.textOut,'String',textStr );


% --- Executes on button press in pushPostCells.
function pushPostCells_Callback(hObject, eventdata, handles)
% hObject    handle to pushPostCells (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global glob tis

val = get(hObject,'Value');

try
    for i = 1:length(glob.p.postCells)
        delete(glob.p.postCells(i))
    end
end

if val
    
    cellCon
    showCells = glob.con.isPost;
    
    colOption = get(handles.listbox3,'Value');
    col = getCol(colOption,length(showCells));
    for i = 1:length(showCells)
        fileName = sprintf('%s%d.mat',glob.useFvDir,showCells(i));
        if exist(fileName,'file')
            fv = loadFV(fileName);;
            glob.p.postCells(i) = renderFVnav(fv,col(i,:),.6)
            glob.p.postCells(i).Tag = num2str(showCells(i));
        end
    end

    postText = sprintf('post to %d = %s',glob.pickCID,num2str(glob.con.isPost'));
    showText(postText);
    
    
end


% --- Executes on button press in pushPreSyn.
function pushPreSyn_Callback(hObject, eventdata, handles)
% hObject    handle to pushPreSyn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global glob tis

val = get(hObject,'Value');

try
    delete(glob.p.preSyn1)
end
try
    delete(glob.p.preSyn2)
end
if val
    
    targ = glob.pickCID;
    isSyn = find(tis.syn.post == targ);
    pos = tis.syn.synPosDS(isSyn,[2 1 3]) * glob.em.dsRes(1);
    preClass = tis.syn.preClass(isSyn);
    col = repmat([1 0 0],[length(isSyn) 1]);
    isBip = find(preClass==7);
    hold on
    glob.p.preSyn1 = scatter3(pos(:,1),pos(:,2),pos(:,3),glob.param.markerSize,'markerfacecolor','r',...
        'marker','o','markeredgecolor','w');
    glob.p.preSyn2 = scatter3(pos(isBip,1),pos(isBip,2),pos(isBip,3),glob.param.markerSize,'markerfacecolor','g',...
        'marker','o','markeredgealpha',0);
    set(glob.p.preSyn1,'clipping','off')
    set(glob.p.preSyn2,'clipping','off')
    
    hold off
    
    preSyn = tis.syn.pre(isSyn);
    %postText = sprintf('preSyn to %d = %s',targ,num2str(preSyn'));
    postText = sprintf('all Pre = %d.  Bip post = %d',length(isSyn),length(isBip));
    
    showText(postText);
end


% --- Executes on button press in pushPostSyn.
function pushPostSyn_Callback(hObject, eventdata, handles)
% hObject    handle to pushPostSyn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob tis

val = get(hObject,'Value');

try delete(glob.p.postSyn1)
end
try delete(glob.p.postSyn2)
end
if val
    
    targ = glob.pickCID;
    isSyn = find(tis.syn.pre == targ);
    pos = tis.syn.synPosDS(isSyn,[2 1 3])* glob.em.dsRes(1);
    postClass = tis.syn.postClass(isSyn);
    col = repmat([1 0 0],[length(isSyn) 1]);
    isRGC = find(postClass==1);
    hold on
    glob.p.postSyn1 = scatter3(pos(:,1),pos(:,2),pos(:,3),glob.param.markerSize,'markerfacecolor','m',...
        'marker','o','markeredgecolor','w');
    glob.p.postSyn2 = scatter3(pos(isRGC,1),pos(isRGC,2),pos(isRGC,3),glob.param.markerSize,'markerfacecolor','b',...
        'marker','o','markeredgealpha',0);
    set(glob.p.postSyn1,'clipping','off')
    set(glob.p.postSyn2,'clipping','off')
    
    hold off
    
    
    preSyn = tis.syn.post(isSyn);
    %postText = sprintf('postSyn to %d = %s',targ,num2str(preSyn'));
    
    postText = sprintf('allPost = %d.  RGC post = %d',length(isSyn),length(isRGC));
    
    showText(postText);
    
end


% --- Executes on button press in pushShrinkMarker.
function pushShrinkMarker_Callback(hObject, eventdata, handles)
% hObject    handle to pushShrinkMarker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob

glob.param.markerSize = glob.param.markerSize ^ .9;
glob.param.markerSize = max(1,glob.param.markerSize);
pushPostSyn_Callback(glob.handles.pushPostSyn)
pushPreSyn_Callback(glob.handles.pushPreSyn)


% --- Executes on button press in pushGrowMarker.
function pushGrowMarker_Callback(hObject, eventdata, handles)
% hObject    handle to pushGrowMarker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global glob

glob.param.markerSize = glob.param.markerSize ^ 1.1;
glob.param.markerSize = max(1,glob.param.markerSize);
pushPostSyn_Callback(glob.handles.pushPostSyn)
pushPreSyn_Callback(glob.handles.pushPreSyn)


% --------------------------------------------------------------------
function uitoolbar1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uitoolbar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uiDataTip_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiDataTip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushDataTip.
function pushDataTip_Callback(hObject, eventdata, handles)
% hObject    handle to pushDataTip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushDataTip
global glob

val = get(hObject,'Value');

% try
%     glob.dcm.Enable = 'off'
%     %glob.dcm.delete
% end

if val
    deselectToggleUI(handles, hObject)
    glob.dcm = datacursormode(handles.figure1);
    glob.dcm.UpdateFcn = @displayCoordinates;
    
    set(glob.dcm,'DisplayStyle','datatip',...
        'SnapToDataVertex','off','Enable','on')
else
    rotate3d(handles.figure1)
    delete(findall(handles.figure1,'Type','hggroup'))
end


function txt = displayCoordinates(~,info)
global glob
X = info.Position(2);
Y = info.Position(1);
Z = info.Position(3);
%c_info = getCursorInfo(glob.dcm)

anc2sub = (glob.em.res/ 1000);
umPos = [X Y Z] ;
umPosStr = sprintf('%.0f  %.0f  %.0f',umPos(end,2),umPos(end,1),umPos(end,3));
disp(umPos)

VASTpos = round([Y X Z] ./ anc2sub);
VASTposStr = sprintf('%.0f \r%.0f \r%.0f um',umPos(end,2),umPos(end,1),umPos(end,3));

set(glob.handles.textOut,'String',VASTpos);
tag = get(info.Target,'Tag');

txt = umPosStr;

clipboard('copy',VASTpos)






% --- Executes during object creation, after setting all properties.
function raiseLight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to raiseLight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

global glob
glob.light = lightangle(180,45);


% --- Executes on button press in toggleSkeleton.
function toggleSkeleton_Callback(hObject, eventdata, handles)
% hObject    handle to toggleSkeleton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleSkeleton

global glob

try
    delete(glob.p.skel)   ;
    delete(glob.p.plotSkel);
    delete(glob.p.scatterSkel);
end
try
    glob.p.cell.FaceAlpha = 1;
end

val = get(hObject,'Value');

if val
    fileName = sprintf('%sskelFV_%d.mat',glob.useFvDir,glob.pickCID)
    if exist(fileName,'file')
        fv = loadFV(fileName);
        fv.vertices = fv.vertices(:,[3 1 2]) ;
        glob.p.skel = renderFVnav(fv,[1 1 0],.6);
        glob.p.skel.FaceAlpha = .25;
    end
    
    try
        glob.p.cell.FaceAlpha = .25;
    end
    
    if 1 % show skel with edges and nodes
        fileName = sprintf('%snep_%d.mat',glob.useFvDir,glob.pickCID)
        if exist(fileName,'file')
            %fv = loadFV(fileName);
            load(fileName)
            hold on
            pos = nep.pos;
            edges = nep.edges;
            glob.p.scatterSkel = scatter3(pos(:,2),pos(:,1),pos(:,3),15,'o',...
                'w','filled');
            glob.p.plotSkel = plot3([pos(edges(:,1),2) pos(edges(:,2),2)]',...
                [pos(edges(:,1),1) pos(edges(:,2),1)]',...
                [pos(edges(:,1),3) pos(edges(:,2),3)]','color',[1 0 0],'linewidth',1);
            set(gca,'Clipping','Off');
            hold off
        end
    end
    
else
    try        glob.p.cell.FaceAlpha = 1;
    end
    
end


% --- Executes on button press in toggleRadius.
function toggleRadius_Callback(hObject, eventdata, handles)
% hObject    handle to toggleRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleRadius

global glob

if 0
    
    try
        delete(glob.p.radius)    ;
    end
    glob.p.cell.FaceAlpha = 1;
    
    
    val = get(hObject,'Value');
    
    if val
        fileName = sprintf('%sskelFV_%d.mat',glob.useFvDir,glob.pickCID)
        if exist(fileName,'file')
            fv = loadFV(fileName);
            fv.vertices = fv.vertices(:,[3 1 2]) ;
            glob.p.radius = renderFVnav(fv,[1 1 0],.6);
        end
        
        glob.p.cell.FaceAlpha = .25;
        
    else
        try        glob.p.cell.FaceAlpha = 1;
        end
        
    end
    
else
    disp('disabled')
end


% --- Executes on selection change in subType_popupMenue.
function subType_popupMenue_Callback(hObject, eventdata, handles)
% hObject    handle to subType_popupMenue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subType_popupMenue contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subType_popupMenue
global glob tis


val = get(hObject,'Value');


glob.subTypeID = val-1;

if val == 1;
    glob.listCellidx = find(tis.cells.type.typeID == glob.typeID);
else
    glob.listCellidx = find((tis.cells.type.typeID == glob.typeID) & ...
        (tis.cells.type.subTypeID == glob.subTypeID) );
    
end

set(handles.listCIDs,'Value',1 )
set(handles.listCIDs,'String',glob.cellStr(glob.listCellidx) )
pickCids = tis.cids(glob.listCellidx);
cellText = sprintf('selected cells  = %s ',num2str(pickCids,'%d '))
showText(cellText);




% --- Executes during object creation, after setting all properties.
function subType_popupMenue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subType_popupMenue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

global glob tis

if glob.typeID < 1
    subTypeNames = {'all'};
else
    subTypeNames = tis.cells.type.subTypeNames{glob.typeID};
end

set(hObject,'String',subTypeNames)



% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showSub_toggle.
function showSub_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to showSub_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showSub_toggle


global glob tis

if isfield(glob,'g')
    L = length(glob.g)+1;
else
    L = 1;
end

glob.g(L) = glob.defaultG;
glob.g(L).idx = glob.listCellidx;
glob.g(L).cid = tis.cids(glob.listCellidx);
glob.g(L).col = repmat([rand rand rand],[length(glob.g(L).idx) 1]);
glob.g(L).show = get(handles.togglebutton_showGroup,'Value')



if glob.typeID>0
    typeName = tis.cells.type.typeNames{glob.typeID};
    
    if glob.subTypeID>0
        subTypeName = tis.cells.type.subTypeNames{glob.typeID}{glob.subTypeID};
    else
        subTypeName = '-';
    end
    
else
    typeName = '-';
    subTypeName = '-';
end


glob.g(L).name = sprintf('g%d - %s %s',L,typeName,subTypeName);
showCellGroup(L)

updateGroups

function updateGroups


%newVal = max(min(G,length(groupNames)),1);
global glob
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



% --- Executes on selection change in subColor_popUp.
function subColor_popUp_Callback(hObject, eventdata, handles)
% hObject    handle to subColor_popUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subColor_popUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subColor_popUp

global glob tis
G = get(handles.renderGroups_popUp,'Value');

L = length(glob.g(G).idx);
colOption = get(hObject,'Value');
glob.g(G).col = getCol(colOption,L);

for p = 1:length(glob.g(G).patch)
   set(glob.g(G).patch(p),'FaceColor',glob.g(G).col(p,:)); 
end

%showCellGroup(G)


function[col] = getCol(colOption,L)

if ~exist('L','var')
    L = 1;
end
if colOption == 2
    col = hsv(L);
    col = col(randperm(L),:);
elseif colOption == 1
    col = [rand rand rand];
    col = repmat(col,[L 1]);
else
    colIdx = colOption - 2;
    colVals = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 1 1; 1 1 1; .3 .3 .3];
    colPick = colVals(colIdx,:);
    col = repmat(colPick,[L 1]);
end


% --- Executes during object creation, after setting all properties.
function subColor_popUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subColor_popUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob
set(hObject,'String', glob.colorOptions);



% --- Executes on selection change in renderGroups_popUp.
function renderGroups_popUp_Callback(hObject, eventdata, handles)
% hObject    handle to renderGroups_popUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns renderGroups_popUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from renderGroups_popUp

global glob tis
L = get(hObject,'Value');
set(handles.subColor_popUp,'Value',glob.g(L).colIdx);
set(handles.subAlpha_popUp,'Value',glob.g(L).alphIdx);
set(handles.togglebutton_showGroup,'Value',glob.g(L).show);



% --- Executes during object creation, after setting all properties.
function renderGroups_popUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to renderGroups_popUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob

glob.g = glob.defaultG;
str = {glob.g.name};
set(hObject,'String',str);


% --- Executes on button press in addRef_toggleButton.
function addRef_toggleButton_Callback(hObject, eventdata, handles)
% hObject    handle to addRef_toggleButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of addRef_toggleButton



global glob tis

if isfield(glob,'g')
    L = length(glob.g)+1;
else
    L = 1;
end


if isfield(glob,'pickCIDref')
    
    refCids = glob.pickCIDref;
    
    idx = [];
    for i = 1 : length(refCids)
        targ = find(tis.cids==refCids(i),1);
        if ~isempty(targ)
            idx = cat(1,idx,targ);
        end
    end
    
    
    %%Delete old ref
    try
        for r = 1:length(glob.p.refCell)
            delete(glob.p.refCell(r))
        end
    end
    glob.pickCIDref = [];
    
    
    %% make new group
    glob.g(L) = glob.defaultG;
    glob.g(L).idx = idx;
    glob.g(L).cid = tis.cids(idx);
    glob.g(L).col = repmat([rand rand rand],[length(glob.g(L).idx) 1]);
    glob.g(L).show = get(handles.togglebutton_showGroup,'Value')
    glob.g(L).name = sprintf('g%d - ref %s',L, num2str(refCids));
    showCellGroup(L)
    
    updateGroups
    set(handles.edit2,'String','')
    edit2_Callback(handles.edit2, eventdata, handles)
    
    
    
end





% --- Executes on button press in deleteGroup.
function deleteGroup_Callback(hObject, eventdata, handles)
% hObject    handle to deleteGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of deleteGroup

global glob tis

G = get(handles.renderGroups_popUp,'Value');

if G>0
    try
        for p = 1:length(glob.g(G).patch)
            delete(glob.g(G).patch(p))
        end
    end
    
    
    keep = setdiff([1:length(glob.g)],G);
    glob.g = glob.g(keep);
    
    groupNames = {glob.g.name};
    if isempty(groupNames)
        glob.g = glob.defaultG;      
    end
    
    updateGroups
    
end



function showCellGroup(V)

if ~exist('V','var')
    V = 1:length(glob.g);
end


global glob tis

for v = V
    
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
    
end


% --- Executes on selection change in subAlpha_popUp.
function subAlpha_popUp_Callback(hObject, eventdata, handles)
% hObject    handle to subAlpha_popUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subAlpha_popUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subAlpha_popUp

global glob tis
G = get(handles.renderGroups_popUp,'Value');

L = length(glob.g(G).idx);

alphOption = get(hObject,'Value');

alph = (alphOption -1) /11;

glob.g(G).alph = alph;

for i = 1:length(glob.g(G).patch)
    set(glob.g(G).patch(i),'FaceAlpha',alph);
end





% --- Executes during object creation, after setting all properties.
function subAlpha_popUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subAlpha_popUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

alphaOptions = {'0' '.1' '.2' '.3' '.4' '.5' '.5' '.6' '.7' '.8' '.9' '1'};
set(hObject,'String',alphaOptions);


% --- Executes on button press in toggle_dataOn.
function toggle_dataOn_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_dataOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_dataOn

global glob tisDat

load([glob.useFvDir 'tisDat.mat']);
val = get(hObject,'Value');
set(handles.panelData,'Visible',val)


% --- Executes on button press in toggle_CellData.
function toggle_CellData_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_CellData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_CellData

global glob tisDat

val = get(hObject,'Value');

try
    delete(glob.dat.h.cell)
end

if val
    cid = glob.pickCID
    cellIdx = glob.pickIdx;
    cellDat = tisDat.depthHist(cellIdx);
    depth = cellDat.histDat(:,1);
    surface = cellDat.histDat(:,2);
    surface = surface/max(surface);
    
    glob.dat.h.cell = plot(handles.axesDepth,surface,depth,...
        'Color',[0 0 0],'linewidth',2);
    set(handles.axesDepth,'XLim',[0 1],'YLim',[-.5 1.5],'ydir','reverse',...
        'YTick',[-.5:.1:1.5])
end



% --- Executes on button press in toggle_groupData1.
function toggle_groupData1_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_groupData1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_groupData1

global glob tisDat

val = get(hObject,'Value');

if val
    groupID = get(handles.renderGroups_popUp,'Value');
    
    idxs = glob.g(groupID).idx;
    hold on
    for i = 1:length(idxs)
        cellIdx = idxs(i);
        col  = glob.g(groupID).col(i,:);
        cellDat = tisDat.depthHist(cellIdx);
        if cellDat.isDat
            depth = cellDat.histDat(:,1);
            surface = cellDat.histDat(:,2);
            surface = surface/max(surface);
            set(handles.axesDepth, 'NextPlot', 'add')
            glob.dat.h.g1(i) = plot(handles.axesDepth,surface,depth,...
                'Color',col','linewidth',2);
        end
        set(handles.axesDepth,'XLim',[0 1],'YLim',[-.5 1.5],'ydir','reverse',...
            'YTick',[-.5:.1:1.5])
    end
    
else
    try
        for i = 1:length(glob.dat.h.g1)
            delete(glob.dat.h.g1(i))
        end
    end
end





% --- Executes on button press in toggle_groupData2.
function toggle_groupData2_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_groupData2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_groupData2



global glob tisDat

val = get(hObject,'Value');

if val
    groupID = get(handles.renderGroups_popUp,'Value');
    
    idxs = glob.g(groupID).idx;
    hold on
    for i = 1:length(idxs)
        cellIdx = idxs(i);
        col  = glob.g(groupID).col(i,:);
        cellDat = tisDat.depthHist(cellIdx);
        if cellDat.isDat
            depth = cellDat.histDat(:,1);
            surface = cellDat.histDat(:,2);
            surface = surface/max(surface);
            set(handles.axesDepth, 'NextPlot', 'add')
            glob.dat.h.g2(i) = plot(handles.axesDepth,surface,depth,...
                'Color',col','linewidth',2);
        end
        set(handles.axesDepth,'XLim',[0 1],'YLim',[-.5 1.5],'ydir','reverse',...
            'YTick',[-.5:.1:1.5])
    end
    
else
    try
        for i = 1:length(glob.dat.h.g1)
            delete(glob.dat.h.g2(i))
        end
    end
end




function toggle_dataOn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subAlpha_popUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in toggle_refDat.
function toggle_refDat_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_refDat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_refDat
global glob tisDat

val = get(hObject,'Value');

if val
    
    if isfield(glob,'pickCIDref')
        refCids = glob.pickCIDref;
        
        for i = 1:length(refCids)
            idxs(i) = find(glob.cids==refCids(i),1);
        end
        
        for i = 1:length(idxs)
            cellIdx = idxs(i);
            col  = [1 0 0];
            cellDat = tisDat.depthHist(cellIdx);
            if cellDat.isDat
                depth = cellDat.histDat(:,1);
                surface = cellDat.histDat(:,2);
                surface = surface/max(surface);
                set(handles.axesDepth, 'NextPlot', 'add')
                glob.dat.h.ref(i) = plot(handles.axesDepth,surface,depth,...
                    'Color',col','linewidth',2);
            end
            set(handles.axesDepth,'XLim',[0 1],'YLim',[-.5 1.5],'ydir','reverse',...
                'YTick',[-.5:.1:1.5])
        end
    end
    
else
    try
        for i = 1:length(glob.dat.h.ref)
            delete(glob.dat.h.ref(i))
        end
    end
end


% --- Executes on button press in toggle_highlightCell.
function toggle_highlightCell_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_highlightCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_highlightCell

global glob
val = get(hObject,'Value');


if val
    deselectToggleUI(handles, hObject)
    glob.dcm = datacursormode(handles.figure1);
    glob.dcm.UpdateFcn = @highlightCell;
    
    set(glob.dcm,'DisplayStyle','datatip',...
        'SnapToDataVertex','off','Enable','on')
else
    rotate3d(handles.figure1)
    delete(findall(handles.figure1,'Type','hggroup'))
    try
        set(glob.highlight.oldPatch,...
            'FaceColor', glob.highlight.oldColor,...
            'FaceAlpha',glob.highlight.oldAlpha )
    end
end


function txt = highlightCell(~,info)
global glob
'highlighting'
try
    set(glob.highlight.oldPatch,...
        'FaceColor', glob.highlight.oldColor,...
        'FaceAlpha',glob.highlight.oldAlpha )
end
glob.highlight.oldPatch = info.Target;
glob.highlight.oldAlpha = get(info.Target,'FaceAlpha');
glob.highlight.oldColor =  get(info.Target,'FaceColor');

tag = get(info.Target,'Tag');
set(glob.handles.textOut,'String',['tag = ' tag]);

txt = tag;
set(info.Target,'FaceAlpha',1,'FaceColor',[1 1 .5])


clipboard('copy',tag)


% --- Executes on button press in textCID.
function textCID_Callback(hObject, eventdata, handles)
% hObject    handle to textCID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of textCID

global glob


val = get(hObject,'Value');


if val
    try
        set(glob.p.cell,'Visible','on')
    catch
        showPickedCell
    end
else
    try
        set(glob.p.cell,'Visible','off')
    end
end


% --- Executes on button press in toggle_selectCell.
function toggle_selectCell_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_selectCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_selectCell

global glob
val = get(hObject,'Value');

if val
    deselectToggleUI(handles, hObject)
    glob.dcm = datacursormode(handles.figure1);
    glob.dcm.UpdateFcn = @cursorSelectCell;
    
    set(glob.dcm,'DisplayStyle','datatip',...
        'SnapToDataVertex','off','Enable','on')
else
    rotate3d(handles.figure1)
    delete(findall(handles.figure1,'Type','hggroup'))
    try
        set(glob.highlight.oldPatch,...
            'FaceColor', glob.highlight.oldColor,...
            'FaceAlpha',glob.highlight.oldAlpha )
    end
end


function txt = cursorSelectCell(~,info)

global glob
'cursor Select'
tag = get(info.Target,'Tag');
set(glob.handles.textOut,'String',['tag = ' tag]);
txt = tag;
clipboard('copy',tag);

cid = str2num(tag);
idx = find(glob.cids==cid,1);
if cid ~= glob.pickCID
    if isempty(idx)
        set(glob.handles.textOut,'String','cell(cid) not found');
    else
        glob.pickIdx = idx;
        glob.pickCID = cid;
        showPickedCell
    end
end
pause(.01)


% --- Executes on selection change in listbox_preCol.
function listbox_preCol_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_preCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_preCol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_preCol

global glob
pushPreCell_Callback(glob.handles.pushPreCell,[],glob.handles);





% --- Executes during object creation, after setting all properties.
function listbox_preCol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_preCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob
set(hObject,'String', glob.colorOptions);

% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3
global glob
pushPostCells_Callback(glob.handles.pushPostCells,[],glob.handles);

% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob
set(hObject,'String', glob.colorOptions);

function cellCon

global glob tis


targ = glob.pickCID;
isSyn = find(tis.syn.post == targ);
isPre = unique(tis.syn.pre(isSyn));
isPre = setdiff(isPre,0);

isSyn = find(tis.syn.pre == targ);
isPost = unique(tis.syn.post(isSyn));
isPost = setdiff(isPost,0);

glob.con.isPre = isPre;
glob.con.isPost = isPost;


% --- Executes on button press in pushbutton_preGroup.
function pushbutton_preGroup_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_preGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob tis

if isfield(glob,'g')
    L = length(glob.g)+1;
else
    L = 1;
end


if ~isempty(glob.con.isPre)
    cellCon
    refCids = glob.con.isPre;
    
    idx = [];
    for i = 1 : length(refCids)
        targ = find(tis.cids==refCids(i),1);
        if ~isempty(targ)
            idx = cat(1,idx,targ);
        end
    end
        
   
    
    %% make new group
    glob.g(L) = glob.defaultG;
    glob.g(L).idx = idx;
    glob.g(L).cid = tis.cids(idx);
    glob.g(L).col = repmat([rand rand rand],[length(glob.g(L).idx) 1]);
    glob.g(L).show = get(handles.togglebutton_showGroup,'Value')
    glob.g(L).name = sprintf('g%d - pre to %d',L, glob.pickCID);
    showCellGroup(L)
    
    updateGroups
    set(handles.edit2,'String','')
    edit2_Callback(handles.edit2, eventdata, handles)
    
    
    
end



% --- Executes on button press in pushbutton_postGroup.
function pushbutton_postGroup_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_postGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob tis

if isfield(glob,'g')
    L = length(glob.g)+1;
else
    L = 1;
end


if ~isempty(glob.con.isPost)
    cellCon
    refCids = glob.con.isPost;
    
    idx = [];
    for i = 1 : length(refCids)
        targ = find(tis.cids==refCids(i),1);
        if ~isempty(targ)
            idx = cat(1,idx,targ);
        end
    end
        
   
    
    %% make new group
    glob.g(L) = glob.defaultG;
    glob.g(L).idx = idx;
    glob.g(L).cid = tis.cids(idx);
    glob.g(L).col = repmat([rand rand rand],[length(glob.g(L).idx) 1]);
    glob.g(L).show = get(handles.togglebutton_showGroup,'Value')
    glob.g(L).name = sprintf('g%d - post to %d',L, glob.pickCID);
    showCellGroup(L)
    
    updateGroups
    set(handles.edit2,'String','')
    edit2_Callback(handles.edit2, eventdata, handles)
    
    
    
end

% --- Executes on button press in togglebutton_measurePath.
function togglebutton_measurePath_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_measurePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_measurePath

global glob


val = get(hObject,'Value');



if val
    try
        delete(glob.data.path.plotH);
    end
    deselectToggleUI(handles, hObject)
    glob.dcm = datacursormode(handles.figure1);
    glob.dcm.UpdateFcn = @makePath;
    
    set(glob.dcm,'DisplayStyle','datatip',...
        'SnapToDataVertex','off','Enable','on');
    plotPath
    
else
    rotate3d(handles.figure1);
    delete(findall(handles.figure1,'Type','hggroup'));
    
end


function txt = makePath(~,info)
global glob
X = info.Position(2);
Y = info.Position(1);
Z = info.Position(3);
%c_info = getCursorInfo(glob.dcm)

newPt = [Y X Z];

if ~isempty(glob.data.path.pts)
    lastPt = glob.data.path.pts(end,:);
else
    lastPt = [0 0 0];
end

if sum(abs(newPt-lastPt))
    
    glob.data.path.pts = cat(1,glob.data.path.pts,[Y X Z]);
    glob.data.path.Parent = info.Target.Parent;
    
    anc2sub = (glob.em.res/ 1000)./ glob.em.dsRes;
    allPos2 = [X Y Z] ./ anc2sub;
    VASTpos = sprintf('%.0f  %.0f  %.0f',allPos2(end,2),allPos2(end,1),allPos2(end,3));
    disp(VASTpos)
    
    anc2um =  1./ glob.em.dsRes;
    umPos = [X Y Z];
    umPosStr = sprintf('%.2f %.2f %.2f um',umPos(end,2),umPos(end,1),umPos(end,3));
    
    tag = get(info.Target,'Tag');
    
    
    glob.data.path.pos = cat(1,glob.data.path.pos,umPos);
    
    pos = glob.data.path.pos;
    
    L = sqrt((pos(2:end,1)-pos(1:end-1,1)).^2 + (pos(2:end,2)-pos(1:end-1,2)).^2 + ...
        (pos(2:end,3)-pos(1:end-1,3)).^2);
    glob.data.path.lengths = L;
    txt = sprintf('%0.2f um',sum(L));
    
    clipboard('copy',sum(L))
    
    plotPath
end

function[] =  plotPath()

global glob

pos = glob.data.path.pos;
pts = glob.data.path.pts;
textOutStr = num2str(round(pos));

set(glob.handles.textOut,'String',textOutStr);

try
    delete(glob.data.path.plotH);
end

if ~isempty(pos)
    set(glob.data.path.Parent, 'NextPlot', 'add')
    
    glob.data.path.plotH = plot3(glob.data.path.Parent,...
        pts(:,1),pts(:,2),pts(:,3),...
        'linewidth',10,'color','g');
    set(glob.data.path.Parent,'Clipping','Off')
end

set(glob.data.path.plotH,'Visible',...
    ~get(glob.handles.togglebutton_hidePath,'Value'));

if get(glob.handles.togglebutton_pathProperties,'Value')
    updatePathPanel
end


% --- Executes on button press in togglebutton_pathProperties.
function togglebutton_pathProperties_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_pathProperties (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_pathProperties

val = get(hObject,'Value');

if val
    set(handles.uipanel_pathProperties,'Visible','on')
    updatePathPanel
else
    set(handles.uipanel_pathProperties,'Visible','off')
end


function[] = updatePathPanel()

global glob

h = glob.handles;


pos = glob.data.path.pos;

posStr = num2str(pos,'%0.1f  ');
%posStr2 = mat2strFormat(glob.data.path.pos,1);
set(h.edit_pathPanelPoints,'String',posStr)

lengthsStr = num2str(glob.data.path.lengths,'%0.1f  ');
set(h.edit_pathPanelLengths,'String',lengthsStr)

lengthStr = compose('%0.1f',sum(glob.data.path.lengths));
set(h.edit5,'String',lengthStr)

area = 0;
convexArea = 0;
convexVolume = 0;

if ~isempty(pos)
    area = polyarea(pos(:,1),pos(:,2));
end
if size(pos,1)>2
    [hull2D convexArea] = convhull(pos(:,1),pos(:,2));
end
if size(pos,1)>3
    [hull3D convexVolume] = convhull(pos(:,1),pos(:,2),pos(:,3));
end

areaStr = compose('%0.1f',area);
set(h.edit_pathPanelXYArea,'String',areaStr)

convAreaStr = compose('%0.1f',convexArea);
set(h.edit_pathPanel_ConvexHullArea,'String',convAreaStr)

volStr = compose('%0.1f',sum(glob.data.path.lengths));
set(h.edit_pathPanelVolume,'String',volStr)


function[Mstr] =  mat2strFormat(M,n)

maxL = length(num2str(max(round(M(:)))))+n+3;
ys = size(M,1);
xs = size(M,2) * maxL-2;
Mstr(ys,xs) = ' ';
for y = 1:size(M,1)
    for x = 1:size(M,2)
        str1 = sprintf('%%0.%df',n);
        str2 = sprintf(str1,M(y,x));
        Mstr(y,maxL*x-length(str2)+1-2:maxL*x-2) = str2;
    end
end




function edit_pathPanelPoints_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pathPanelPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pathPanelPoints as text
%        str2double(get(hObject,'String')) returns contents of edit_pathPanelPoints as a double


% --- Executes during object creation, after setting all properties.
function edit_pathPanelPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pathPanelPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pathPanelLengths_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pathPanelLengths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pathPanelLengths as text
%        str2double(get(hObject,'String')) returns contents of edit_pathPanelLengths as a double


% --- Executes during object creation, after setting all properties.
function edit_pathPanelLengths_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pathPanelLengths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pathPanelXYArea_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pathPanelXYArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pathPanelXYArea as text
%        str2double(get(hObject,'String')) returns contents of edit_pathPanelXYArea as a double


% --- Executes during object creation, after setting all properties.
function edit_pathPanelXYArea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pathPanelXYArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pathPanelVolume_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pathPanelVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pathPanelVolume as text
%        str2double(get(hObject,'String')) returns contents of edit_pathPanelVolume as a double


% --- Executes during object creation, after setting all properties.
function edit_pathPanelVolume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pathPanelVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pathPanel_ConvexHullArea_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pathPanel_ConvexHullArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pathPanel_ConvexHullArea as text
%        str2double(get(hObject,'String')) returns contents of edit_pathPanel_ConvexHullArea as a double


% --- Executes during object creation, after setting all properties.
function edit_pathPanel_ConvexHullArea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pathPanel_ConvexHullArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_undoPath.
function pushbutton_undoPath_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_undoPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob

L = length(glob.data.path.pos);

if L>1
    glob.data.path.pos = glob.data.path.pos(1:end-1,:);
    glob.data.path.pts = glob.data.path.pts(1:end-1,:);
    
    pos = glob.data.path.pos;
    
    L = sqrt((pos(2:end,1)-pos(1:end-1,1)).^2 + (pos(2:end,2)-pos(1:end-1,2)).^2 + ...
        (pos(2:end,3)-pos(1:end-1,3)).^2);
    glob.data.path.lengths = L;
    
    pts = glob.data.path.pts;
    textOutStr = num2str(round(pos));
    
    try
        delete(glob.data.path.plotH);
    end
    set(glob.data.path.Parent, 'NextPlot', 'add')
    
    glob.data.path.plotH = plot3(glob.data.path.Parent,...
        pts(:,1),pts(:,2),pts(:,3),...
        'linewidth',10,'color','g');
    
    clipboard('copy',sum(L))
    txt = sprintf('%0.2f um',sum(L));
    
    
end

if get(glob.handles.togglebutton_pathProperties,'Value')
    updatePathPanel
end
plotPath
glob.data.path

% --- Executes on button press in pushbutton_clearPath.
function pushbutton_clearPath_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clearPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob

glob.data.path.pts = [];
glob.data.path.pos = [];
glob.data.path.lengths = [];
delete(findall(handles.figure1,'Type','hggroup'));
updatePathPanel
try
    delete(glob.data.path.plotH);
end


% --- Executes on selection change in popupmenu_funcTypes.
function popupmenu_funcTypes_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_funcTypes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_funcTypes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_funcTypes

global glob

val = get(hObject,'Value');
funcIDs = glob.com.typeFunctions{val};
if val == 1
    funcStrs = glob.com.functionFiles;
else
    
    if ~isempty(funcIDs)
        funcStrs = glob.com.functions{funcIDs};
    else
        funcStrs = ' ';
    end
end
set(handles.popupmenu_functions,'String',funcStrs,'Value',1);


% --- Executes during object creation, after setting all properties.
function popupmenu_funcTypes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_funcTypes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob
set(hObject,'String',glob.com.typeStrings)
set(hObject,'Value',1);

% --- Executes on selection change in popupmenu_functions.
function popupmenu_functions_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_functions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_functions contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_functions

%
% str = get(hObject,'String');
% str = str{get(hObject,'Value')};
% set(handles.edit_eval,'String',str)


% --- Executes during object creation, after setting all properties.
function popupmenu_functions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_functions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob
set(hObject,'String',glob.com.functionFiles);




function edit_eval_Callback(hObject, eventdata, handles)
% hObject    handle to edit_eval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_eval as text
%        str2double(get(hObject,'String')) returns contents of edit_eval as a double

'hi'

% --- Executes during object creation, after setting all properties.
function edit_eval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_eval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_result_Callback(hObject, eventdata, handles)
% hObject    handle to edit_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_result as text
%        str2double(get(hObject,'String')) returns contents of edit_result as a double


% --- Executes during object creation, after setting all properties.
function edit_result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Function.
function pushbutton_Function_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob
str = get(handles.popupmenu_functions,'String');
if iscell(str)
    str = str{get(handles.popupmenu_functions,'Value')};
end

glob.com.result = '';
try
    output = evalc(str);
catch err
    output = err.message
end
set(handles.edit_result,'String',output)



pause(.5)
if length(glob.com.result)>0
    set(handles.edit_result,'String',glob.com.result)
end

% --- Executes on button press in pushbutton_eval.
function pushbutton_eval_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_eval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob
str = get(handles.edit_eval,'String')

glob.com.result = '';
try
    output = evalc(str);
catch err
    output = err.message
end
set(handles.edit_result,'String',output)
pause(.5)
if length(glob.com.result)>0
    set(handles.edit_result,'String',glob.com.result)
end


% --- Executes on button press in togglebutton_showComPanel.
function togglebutton_showComPanel_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_showComPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_showComPanel

val = get(hObject,'Value');
if val
    set(handles.uipanel_Com ,'Visible','On')
else
    set(handles.uipanel_Com , 'Visible','Off')
end

% --- Executes on button press in togglebutton_ShowPathPanel.
function togglebutton_ShowPathPanel_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_ShowPathPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_ShowPathPanel


val = get(hObject,'Value');
if val
    set(handles.uipanel_pathProperties ,'Visible','On')
else
    set(handles.uipanel_pathProperties , 'Visible','Off')
end


% --- Executes on button press in togglebutton_pickRef.
function togglebutton_pickRef_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_pickRef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_pickRef


global glob
val = get(hObject,'Value');

if val
    deselectToggleUI(handles, hObject)
    glob.dcm = datacursormode(handles.figure1);
    glob.dcm.UpdateFcn = @cursorSelectRef;
    
    set(glob.dcm,'DisplayStyle','datatip',...
        'SnapToDataVertex','off','Enable','on')
else
    rotate3d(handles.figure1)
    delete(findall(handles.figure1,'Type','hggroup'))
    try
        set(glob.highlight.oldPatch,...
            'FaceColor', glob.highlight.oldColor,...
            'FaceAlpha',glob.highlight.oldAlpha )
    end
end


function txt = cursorSelectRef(~,info)

global glob
'cursor Select'
set(glob.dcm,'Enable','off')
tag = get(info.Target,'Tag');
set(glob.handles.textOut,'String',['tag = ' tag]);
txt = tag;
clipboard('copy',tag);

cid = str2num(tag);
idx = find(glob.cids==cid,1);

if sum(glob.pickCIDref==cid) %If alread a ref
    glob.pickCIDref = setdiff(glob.pickCIDref, cid);
else
    
    if isempty(idx)
        set(glob.handles.textOut,'String','cell(cid) not found');
    else
        glob.pickCIDref = [glob.pickCIDref cid];
    end
end

str = {num2str(glob.pickCIDref)};
set(glob.handles.edit2,'String',str);
edit2_Callback(glob.handles.edit2, [] , glob.handles)
pause(.2)

set(glob.dcm,'Enable','on')

% --- Executes on button press in textRefCell.
function textRefCell_Callback(hObject, eventdata, handles)
% hObject    handle to textRefCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of textRefCell

global glob

val = get(hObject,'Value');

for i = 1:length(glob.p.refCell)
    set(glob.p.refCell(i),'Visible',val)
end






% --- Executes on button press in togglebutton_editPatch.
function togglebutton_editPatch_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_editPatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_editPatch

val = get(hObject,'Value');
set(handles.uipanel_editPatch,'Visible',val);


% --- Executes on button press in togglebutton_saveStuff.
function togglebutton_saveStuff_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_saveStuff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_saveStuff

val = get(hObject,'Value');
set(handles.uipanel_saveStuff,'Visible',val)


function edit_color_Callback(hObject, eventdata, handles)
% hObject    handle to edit_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_color as text
%        str2double(get(hObject,'String')) returns contents of edit_color as a double

global glob

glob.editPatch.col = [];

str  = get(hObject,'String');
if iscell(str)
    str = str{1};
end

col = str2num(str);
col(col<0) = 0;
col(col>1) = 1;
col = round(col*100)/100;


if size(col,2) ~=3
    set(handles.textOut,'String','color must be 1 x 3 RGB [1 1 1]')
else
    if get(handles.togglebutton_SelectPatch,'Value')
        set(glob.editPatch.h,'FaceColor',col);
    end
    glob.editPatch.col = col;
end




% --- Executes during object creation, after setting all properties.
function edit_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_alpha_Callback(hObject, eventdata, handles)
% hObject    handle to edit_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_alpha as text
%        str2double(get(hObject,'String')) returns contents of edit_alpha as a double

global glob

str  = get(hObject,'String');

alph = str2num(str);
glob.editPatch.alph = [];

if ~isempty(alph)
    alph(alph<0) = 0;
    alph(alph>1) = 1;
    alph = alph(1);
    
    if size(alph,2) ~=1
        set(handles.textOut,'String','alpha must be between 0 and 1')
    else
        if get(handles.togglebutton_SelectPatch,'Value')
            set(glob.editPatch.h,'FaceAlpha',alph);
        end
        glob.editPatch.alph = alph;
    end
else
    set(handles.textOut,'String','alpha is empty')
    
end


% --- Executes during object creation, after setting all properties.
function edit_alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton_PaintPatch.
function togglebutton_PaintPatch_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_PaintPatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_PaintPatch

global glob
val = get(hObject,'Value');

if val
    deselectToggleUI(handles, hObject)
    glob.dcm = datacursormode(handles.figure1);
    glob.dcm.UpdateFcn = @cursorPaintPatch;
    
    set(glob.dcm,'DisplayStyle','datatip',...
        'SnapToDataVertex','off','Enable','on')
else
    rotate3d(handles.figure1)
    delete(findall(handles.figure1,'Type','hggroup'))
end


function txt = cursorPaintPatch(~,info)

global glob
'cursor Select'
set(glob.dcm,'Enable','off')

glob.editPatch.h = info.Target;

if ~isempty(glob.editPatch.col)
    set(info.Target,'FaceColor',glob.editPatch.col)
end
if ~isempty(glob.editPatch.alph)
    set(info.Target,'FaceAlpha',glob.editPatch.alph)
end


pause(.1)
set(glob.dcm,'Enable','on')




% --- Executes on button press in togglebutton_SelectPatch.
function togglebutton_SelectPatch_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_SelectPatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_SelectPatch

global glob
val = get(hObject,'Value');

if val
    deselectToggleUI(handles, hObject)
    glob.dcm = datacursormode(handles.figure1);
    glob.dcm.UpdateFcn = @cursorSelectPatch;
    
    set(glob.dcm,'DisplayStyle','datatip',...
        'SnapToDataVertex','off','Enable','on')
else
    rotate3d(handles.figure1)
    delete(findall(handles.figure1,'Type','hggroup'))
end


function txt = cursorSelectPatch(~,info)

global glob
'cursor Select'
set(glob.dcm,'Enable','off')
tag = get(info.Target,'Tag');
set(glob.handles.textOut,'String',['tag = ' tag]);
txt = tag;
clipboard('copy',tag);


col = get(info.Target,'FaceColor');
alph = get(info.Target,'FaceAlpha');

glob.editPatch.col = round(col*100)/100;
glob.editPatch.alph = round(alph*100)/100;
glob.editPatch.h = info.Target;

set(glob.handles.edit_color,'String',...
    num2str(glob.editPatch.col,'%0.2f  '));
set(glob.handles.edit_alpha,'String',...
    num2str(glob.editPatch.alph,'%0.2f  '));

pause(.1)
set(glob.dcm,'Enable','on')



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double

global glob

glob.save.fileName = get(hObject,'String');


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob
set(hObject,'String',glob.save.fileName);



% --- Executes on button press in pushbutton_SelectDir.
function pushbutton_SelectDir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_SelectDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



if exist('.\LastSaveDir.mat')
    load(['.\LastSaveDir.mat']);
    if exist('LastSaveDir','var')
        TPN = uigetdir(LastSaveDir);
    else
        TPN=uigetdir;
    end
else
    TPN=uigetdir;
end
LastSaveDir= [TPN '\'];

if LastSaveDir>0
    save('.\LastSaveDir.mat','LastSaveDir')
end
glob.save.dir = LastSaveDir;

set(handles.edit_saveDirectory,'String',glob.save.dir);

function edit_saveDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to edit_saveDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_saveDirectory as text
%        str2double(get(hObject,'String')) returns contents of edit_saveDirectory as a double


% --- Executes during object creation, after setting all properties.
function edit_saveDirectory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_saveDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob

set(hObject,'String',glob.save.dir);


% --- Executes on button press in pushbutton_snapShot.
function pushbutton_snapShot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_snapShot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



global glob




pause(.01)

imageName = [glob.save.dir glob.save.fileName];
for i = 1:1000
    snp = sprintf('_snp%d.png',i);
   if ~exist([imageName snp],'file')
       break
   end
end

set(handles.edit13,'String',['writing ...' glob.save.fileName snp] )
set(handles.textOut,'String',['writing ' imageName snp])
pause(.01)
fig1 = glob.handles.figure1;
fig2 = figure('visible','on');

fig2.Color = fig1.Color;
% fig2.Position = fig1.Position;
% fig2.OuterPosition = fig1.OuterPosition;
fig2.Position = [  1   1   1536   1024];

newax = copyobj(glob.handles.mainAx,fig2);
set(fig2,'PaperUnits','points','PaperPosition',[1 1 512 512]);
set(fig2, 'InvertHardCopy', 'off');


print(fig2,[imageName snp],'-dpng','-r256','-opengl','-noui');
pause(.03)

close(fig2)

set(handles.edit13,'String',glob.save.fileName )







% --- Executes on selection change in popupmenu_renderFunctions.
function popupmenu_renderFunctions_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_renderFunctions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_renderFunctions contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_renderFunctions



% --- Executes during object creation, after setting all properties.
function popupmenu_renderFunctions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_renderFunctions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob

set(hObject,'String',glob.save.functions);





% --- Executes on button press in pushbutton_runRender.
function pushbutton_runRender_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_runRender (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob

str = get(handles.popupmenu_renderFunctions,'String');
val = get(handles.popupmenu_renderFunctions,'Value');
str = str{val};
eval(str)



% --- Executes on button press in pushbutton_saveGlob.
function pushbutton_saveGlob_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_saveGlob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global glob
str = get(glob.handles.edit13,'String');
set(glob.handles.edit13,'String','Saving Figure ....')

glob.figData = guidata(glob.handles.figure1);
save([glob.save.defaultDir glob.save.fileName '.mat'],'glob')
set(glob.handles.edit13,'String',glob.save.fileName )


% glob.save.fileName = str;
% savefig(glob.handles.figure1,[glob.save.defaultDir glob.save.fileName])





function deselectToggleUI(handles, hObject)

tag = get(hObject,'Tag');
hList = {'togglebutton_SelectPatch','togglebutton_PaintPatch',...
    'togglebutton_measurePath','pushDataTip','toggle_highlightCell',...
    'toggle_selectCell','togglebutton_pickRef'};

for i = 1:length(hList)
    if ~strcmp(tag,hList{i})
        set(eval(['handles.' hList{i}]),'Value',0);
        eval([hList{i} '_Callback(handles.' hList{i} ',[],handles)']);
    end
end



% --- Executes on button press in togglebutton_hidePath.
function togglebutton_hidePath_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_hidePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_hidePath

global glob


try
    set(glob.data.path.plotH,'Visible',...
        ~get(glob.handles.togglebutton_hidePath,'Value'));
end


% --- Executes on button press in togglebutton_SynapsePanel.
function togglebutton_SynapsePanel_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_SynapsePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_SynapsePanel

val = get(hObject,'Value');
set(handles.uipanel_syn,'Visible',val);

% --- Executes on selection change in popupmenu_synPreType.
function popupmenu_synPreType_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_synPreType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_synPreType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_synPreType

global glob tis


val = get(hObject,'Value');

if val == 1
    glob.syn.prelistCellidx = 1:glob.cellNum;
    glob.syn.preSubTypeID = 0;
else
    glob.syn.preTypeID =glob.typeIDs(val);
    glob.syn.prelistCellidx = find(tis.cells.type.typeID == glob.syn.preTypeID);
    glob.syn.preSubTypeID = 0;
end

set(handles.popupmenu_synCell,'String',glob.cellStr(glob.syn.prelistCellidx))
glob.syn.prePickIdx = 1;
glob.syn.prePickCID = tis.cids(glob.syn.prePickIdx);

if glob.typeID < 1
    subTypeNames = {'all'};
else
    subTypeNames = tis.cells.type.subTypeNames{glob.syn.preTypeID};
    subTypeNames = cat(2,{'all'},subTypeNames);
end

set(handles.popupmenu_synPreSubType,'String',subTypeNames)
set(handles.popupmenu_synPreSubType,'Value',1)

drawSyn


% --- Executes during object creation, after setting all properties.
function popupmenu_synPreType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_synPreType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob tis

set(hObject,'String',glob.typeStrings);



% --- Executes on selection change in popupmenu_synPreSubType.
function popupmenu_synPreSubType_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_synPreSubType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_synPreSubType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_synPreSubType
global glob tis


val = get(hObject,'Value');


glob.syn.preSubTypeID = val-1;

if val == 1;
    glob.syn.prelistCellidx = find(tis.cells.type.typeID == glob.syn.preTypeID );
else
    glob.syn.prelistCellidx = find((tis.cells.type.typeID == glob.syn.preTypeID ) & ...
        (tis.cells.type.subTypeID == glob.syn.preSubTypeID ) );
    
end

set(handles.popupmenu_synCell,'String',glob.cellStr(glob.syn.prelistCellidx) )
pickCids = tis.cids(glob.syn.prelistCellidx);
cellText = sprintf('selected cells  = %s ',num2str(pickCids,'%d '))
showText(cellText);


% --- Executes during object creation, after setting all properties.
function popupmenu_synPreSubType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_synPreSubType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_synCell.
function popupmenu_synCell_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_synCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_synCell contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_synCell

global glob tis

val = get(hObject,'Value');
glob.syn.prePickIdx = glob.syn.prelistCellidx(val);
glob.syn.prePickCID = tis.cids(glob.syn.prePickIdx );
set(handles.edit_synPre, 'String',num2str(glob.syn.prePickCID))



% --- Executes during object creation, after setting all properties.
function popupmenu_synCell_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_synCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_synPostType.
function popupmenu_synPostType_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_synPostType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_synPostType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_synPostType

global glob tis


val = get(hObject,'Value');

if val == 1
    glob.syn.postlistCellidx = 1:glob.cellNum;
    glob.syn.postSubTypeID = 0;
else
    glob.syn.postTypeID =glob.typeIDs(val);
    glob.syn.postlistCellidx = find(tis.cells.type.typeID == glob.syn.postTypeID );
    glob.syn.postSubTypeID = 0;
end

set(handles.popupmenu_synPostCell,'String',glob.cellStr(glob.syn.postlistCellidx))
glob.syn.postPickIdx = 1;
glob.syn.postPickCID = tis.cids(glob.syn.postPickIdx);

if glob.syn.postTypeID < 1
    subTypeNames = {'all'};
else
    subTypeNames = tis.cells.type.subTypeNames{glob.syn.postTypeID };
    subTypeNames = cat(2,{'all'},subTypeNames);
end

set(handles.popupmenu_synPostSubType,'String',subTypeNames)
set(handles.popupmenu_synPostSubType,'Value',1)


% --- Executes during object creation, after setting all properties.
function popupmenu_synPostType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_synPostType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob tis

set(hObject,'String',glob.typeStrings);

% --- Executes on selection change in popupmenu_synPostSubType.
function popupmenu_synPostSubType_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_synPostSubType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_synPostSubType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_synPostSubType
global glob tis


val = get(hObject,'Value');


glob.syn.postSubTypeID = val-1;

if val == 1;
    glob.syn.postlistCellidx = find(tis.cells.type.typeID == glob.syn.preTypeID);
else
    glob.syn.postlistCellidx = find((tis.cells.type.typeID == glob.syn.preTypeID) & ...
        (tis.cells.type.subTypeID == glob.syn.postSubTypeID) );
    
end

set(handles.popupmenu_synPostCell,'String',glob.cellStr(glob.syn.postlistCellidx) )
pickCids = tis.cids(glob.syn.postlistCellidx);
cellText = sprintf('selected cells  = %s ',num2str(pickCids,'%d '))
showText(cellText);


% --- Executes during object creation, after setting all properties.
function popupmenu_synPostSubType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_synPostSubType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_synPostCell.
function popupmenu_synPostCell_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_synPostCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_synPostCell contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_synPostCell

global glob tis

val = get(hObject,'Value');
glob.syn.postPickIdx = glob.syn.postlistCellidx(val);
glob.syn.postPickCID = tis.cids(glob.syn.postPickIdx );
set(handles.edit_synPost, 'String',num2str(glob.syn.postPickCID))


% --- Executes during object creation, after setting all properties.
function popupmenu_synPostCell_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_synPostCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_synSynapseType.
function popupmenu_synSynapseType_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_synSynapseType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_synSynapseType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_synSynapseType

global glob 

val = get(hObject,'Value');
str = get(hObject,'String');

G = get(handles.popupmenu_synGroup,'Value');
glob.syn.g(G).synType = str{val};

drawSyn

% --- Executes during object creation, after setting all properties.
function popupmenu_synSynapseType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_synSynapseType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

synTypeStrings = {'all' '0' '1' '2'};
set(hObject,'String',synTypeStrings)



function edit_synPre_Callback(hObject, eventdata, handles)
% hObject    handle to edit_synPre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_synPre as text
%        str2double(get(hObject,'String')) returns contents of edit_synPre as a double
global glob

str = get(hObject,'string');
if iscell(str)
    str = str{1};
end
cid = str2num(str);
idx = find(glob.cids==cid,1);

if isempty(idx)
    set(handles.textOut,'String','cell(cid) not found');
else
    
    
    glob.syn.prePickIdx = idx;
    glob.syn.prePickCID = cid;
    
end

% --- Executes during object creation, after setting all properties.
function edit_synPre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_synPre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_synPost_Callback(hObject, eventdata, handles)
% hObject    handle to edit_synPost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_synPost as text
%        str2double(get(hObject,'String')) returns contents of edit_synPost as a double
global glob

str = get(hObject,'string');
if iscell(str)
    str = str{1};
end
cid = str2num(str);
idx = find(glob.cids==cid,1);

if isempty(idx)
    set(handles.textOut,'String','cell(cid) not found');
else
    
    
    glob.syn.postPickIdx = idx;
    glob.syn.postPickCID = cid;
    
    
end

% --- Executes during object creation, after setting all properties.
function edit_synPost_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_synPost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_synMarker.
function popupmenu_synMarker_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_synMarker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_synMarker contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_synMarker

global glob

G = get(handles.popupmenu_synGroup,'Value');

str = get(hObject,'String');
glob.syn.g(G).markerType = str{get(hObject,'Value')};
glob.syn.g(G).markerTypeIdx = get(hObject,'Value');



drawSyn

% --- Executes during object creation, after setting all properties.
function popupmenu_synMarker_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_synMarker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global glob
str = {'o','+','*','.','x','square','diamond','^','V','<','>','pentagram','hexagram','none'};
set(hObject,'String',str)

set(hObject,'Value',glob.syn.g.markerTypeIdx);

% --- Executes on selection change in popupmenu_synMarkerColor.
function popupmenu_synMarkerColor_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_synMarkerColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_synMarkerColor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_synMarkerColor


global glob tis
G = get(handles.popupmenu_synGroup,'Value');

L = 1;%length(glob.syn.g(G).idx);
colOption = get(hObject,'Value');
glob.syn.g(G).col = getCol(colOption,L);
glob.syn.g(G).colIdx = get(hObject,'Value');


drawSyn


% --- Executes during object creation, after setting all properties.
function popupmenu_synMarkerColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_synMarkerColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob
set(hObject,'String', glob.colorOptions);
set(hObject,'Value',glob.syn.g.colIdx);

% --- Executes on selection change in popupmenu_synMarkerAlpha.
function popupmenu_synMarkerAlpha_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_synMarkerAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_synMarkerAlpha contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_synMarkerAlpha


global glob tis

G = get(handles.popupmenu_synGroup,'Value');
alphOption = get(hObject,'Value');
alphStr = get(hObject,'String');

alph = str2num(alphStr{alphOption});

glob.syn.g(G).alph = alph;
glob.syn.g(G).alphIdx = alphOption;

drawSyn

% --- Executes during object creation, after setting all properties.
function popupmenu_synMarkerAlpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_synMarkerAlpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob

alphaOptions = {'0' '.1' '.2' '.3' '.4' '.5' '.5' '.6' '.7' '.8' '.9' '1'};
set(hObject,'String',alphaOptions);
set(hObject,'Value',glob.syn.g.alphIdx);

% --- Executes on button press in pushbutton_synMakeGroup.
function pushbutton_synMakeGroup_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_synMakeGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



global glob tis

L = length(glob.syn.g)+1;
glob.syn.g(L) = glob.syn.defaultG;

groupName = {glob.syn.g(L).name};
groupNames = cat(1,get(handles.popupmenu_synGroup,'String'),groupName);
set(handles.popupmenu_synGroup,'String',groupNames)
set(handles.popupmenu_synGroup,'Value',length(groupNames))
synGroup2Panel
drawSyn

% --- Executes on selection change in popupmenu_synGroup.
function popupmenu_synGroup_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_synGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_synGroup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_synGroup
global glob

synGroup2Panel


% --- Executes during object creation, after setting all properties.
function popupmenu_synGroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_synGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


global glob
set(hObject,'String',{glob.syn.g.name});
set(hObject,'Value',1)


% --- Executes on button press in pushbutton_synDelete.
function pushbutton_synDelete_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_synDelete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob

val = get(handles.popupmenu_synGroup,'Value');
keep = setdiff(1:length(glob.syn.g),val);

try
    delete(glob.syn.g(val).p);
end

if length(keep)>0
    glob.syn.g = glob.syn.g(keep);
    names = {glob.syn.g.name};
    set(handles.popupmenu_synGroup,'String',names');
    set(handles.popupmenu_synGroup,'Value',length(names));
else
    
    glob.syn.g = glob.syn.defaultG;    
end
synGroup2Panel;


function synGroup2Panel

global glob
val = get(glob.handles.popupmenu_synGroup,'Value');
set(glob.handles.popupmenu_synMarker,'Value',glob.syn.g(val).markerTypeIdx);
set(glob.handles.popupmenu_synMarkerColor,'Value',glob.syn.g(val).colIdx);
set(glob.handles.popupmenu_synMarkerAlpha,'Value',glob.syn.g(val).alphIdx);
set(glob.handles.popupmenu_synPreGroup,'Value',1)
set(glob.handles.popupmenu_synPostGroup,'Value',1)
set(glob.handles.edit_synPreGroup,'String',glob.syn.g(val).preName);
set(glob.handles.edit_synPostGroup,'String',glob.syn.g(val).postName);
set(glob.handles.togglebutton_synVisible,'Value',glob.syn.g(val).show);

gStr = get(glob.handles.popupmenu_synGroup,'String');
gVal = get(glob.handles.popupmenu_synGroup,'Value');
gStr{gVal} = glob.syn.g(val).name;
set(glob.handles.popupmenu_synGroup,'String',gStr);



% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global glob
G = get(handles.popupmenu_synGroup,'Value');
glob.syn.g(G).markerSize = glob.syn.g(G).markerSize ^ .9;
glob.syn.g(G).markerSize = max(1,glob.syn.g(G).markerSize);
drawSyn

% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global glob
G = get(handles.popupmenu_synGroup,'Value');

glob.syn.g(G).markerSize = glob.syn.g(G).markerSize ^ 1.1;
glob.syn.g(G).markerSize = max(1,glob.syn.g(G).markerSize);
drawSyn


% --- Executes on button press in togglebutton_synDisplay.
function togglebutton_synDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_synDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_synDisplay


function drawSyn

global glob tis

L = get(glob.handles.popupmenu_synGroup,'Value');

synfo = glob.syn.g(L);
synfo
try
    delete(synfo.p)
end


if isempty(synfo.preName) & isempty(synfo.postName)
    
    pos = synfo.pos;
    synText = synfo.name;
else
    
    
    
    uPreCid = tis.cids(synfo.preCellIdx);
    uPostCid = tis.cids(synfo.postCellIdx);
    
    if isempty(synfo.preName) | strcmp(synfo.preName,'none')
        uPreCid = [0  tis.cids];
    end
    if isempty(synfo.postName)| strcmp(synfo.postName,'none')
        uPostCid = [0  tis.cids];
    end
    
    
    
    
    pre = tis.syn.pre;
    post = tis.syn.post;
    
%     [ix preSynID ib] = intersect(pre,uPreCid);
%     [ix postSynID ib] = intersect(post,uPostCid);
    postSynID = [];
    for i = 1:length(uPostCid);
        postSynID = [postSynID; find(post==uPostCid(i))];
    end
    preSynID = [];
    for i = 1:length(uPreCid);
        preSynID = [preSynID; find(pre==uPreCid(i))];
    end
    
%     if isempty(uPreCid) & ~isempty(uPostCid)
%         isSyn = postSynID;
%     elseif ~isempty(uPreCid) & isempty(uPostCid)
%         isSyn = preSynID;
%     else
%         isSyn = intersect(postSynID,preSynID);
%     end
    isSyn = intersect(postSynID,preSynID);
    
 length(isSyn)
 
    synType = str2num(synfo.synType);
    if ~isempty(synType)
        isType = find(tis.syn.synType == synType);
        isSyn = intersect(isSyn,isType);
    end
    
   % pos = tis.syn.synPosDS(isSyn,[2 1 3]) * glob.em.dsRes(1);
    pos = tis.syn.pos(isSyn,[2 1 3]);
    synfo.pos = pos;
    synfo.synIdx = isSyn;
    
    preStr =  get(glob.handles.edit_synPreGroup,'String');
    postStr = get(glob.handles.edit_synPostGroup,'String');
    
    if isempty(preStr),preStr = 'all';end
    if isempty(postStr),postStr = 'all';end
    synfo.name = sprintf('[ %s --> %s ] synType = %s',preStr, postStr, synfo.synType);
    synText = num2str([pre(isSyn) post(isSyn)]);
end

set(glob.handles.mainAx, 'NextPlot', 'add')
if ~isempty(pos)
    synfo.p = scatter3(pos(:,1),pos(:,2),pos(:,3),synfo.markerSize,...
        'markerfacecolor',synfo.col,'markerfacealpha',synfo.alph,...
        'marker',synfo.markerType,'markeredgecolor','w');
end
set(synfo.p,'clipping','off')


gStr = get(glob.handles.popupmenu_synGroup,'String');
gVal = get(glob.handles.popupmenu_synGroup,'Value');
gStr{gVal} = synfo.name;
set(glob.handles.popupmenu_synGroup,'String',gStr);

showText(synText);
glob.syn.g(L) = synfo;


% --- Executes on selection change in popupmenu_synPreGroup.
function popupmenu_synPreGroup_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_synPreGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_synPreGroup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_synPreGroup

global glob

val = get(hObject,'Value')
G = get(handles.popupmenu_synGroup,'Value');

glob.syn.g(G).preCellIdx = glob.g(val).idx;
glob.syn.g(G).preName = glob.g(val).name;
set(handles.edit_synPreGroup,'String',glob.g(val).name);

drawSyn

% --- Executes during object creation, after setting all properties.
function popupmenu_synPreGroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_synPreGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_synPostGroup.
function popupmenu_synPostGroup_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_synPostGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_synPostGroup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_synPostGroup


global glob

val = get(hObject,'Value')
G = get(handles.popupmenu_synGroup,'Value');

glob.syn.g(G).postCellIdx = glob.g(val).idx;
glob.syn.g(G).postName = glob.g(val).name;
set(handles.edit_synPostGroup,'String',glob.g(val).name);
glob.syn.g(G)
drawSyn


% --- Executes during object creation, after setting all properties.
function popupmenu_synPostGroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_synPostGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton_cell2group.
function togglebutton_cell2group_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_cell2group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_cell2group


global glob tis

if isfield(glob,'g')
    L = length(glob.g)+1;
else
    L = 1;
end


if isfield(glob,'pickCID')
    
    cid = glob.pickCID;
    idx = find(tis.cids==cid,1);
           
    glob.g(L) = glob.defaultG;
    glob.g(L).idx = glob.pickIdx;
    glob.g(L).cid = cid;
    %glob.g(L).col = glob.p.cell.FaceColor;
    %glob.g(L).alph = glob.p.cell.FaceAlpha;
    glob.g(L).show = get(handles.togglebutton_showGroup,'Value')
    
    glob.g(L).name = sprintf('g%d - cell %d',L,cid);
    showCellGroup(L)
    
    updateGroups
%     set(handles.edit2,'String','')
%     edit2_Callback(handles.edit2, eventdata, handles)
%      
    set(handles.textCID,'Value',0);
    textCID_Callback(handles.textCID,[],handles);
      try
        delete(glob.p.cell);
    end
    
end


% --- Executes on button press in togglebutton_showGroup.
function togglebutton_showGroup_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_showGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_showGroup
global glob

G = get(handles.renderGroups_popUp,'Value');
val = get(hObject,'Value');

glob.g(G).show = val;

if val
    set(hObject,'String','ON');
else
    set(hObject,'String','OFF');
end

if ~isempty(glob.g(G).patch)
    for i = 1: length(glob.g(G).patch)
        set(glob.g(G).patch(i),'Visible',val);
        pause(.01)
    end
elseif val
    showCellGroup(G)
end




function edit_synPreGroup_Callback(hObject, eventdata, handles)
% hObject    handle to edit_synPreGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_synPreGroup as text
%        str2double(get(hObject,'String')) returns contents of edit_synPreGroup as a double


% --- Executes during object creation, after setting all properties.
function edit_synPreGroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_synPreGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_synPostGroup_Callback(hObject, eventdata, handles)
% hObject    handle to edit_synPostGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_synPostGroup as text
%        str2double(get(hObject,'String')) returns contents of edit_synPostGroup as a double


% --- Executes during object creation, after setting all properties.
function edit_synPostGroup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_synPostGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton_synVisible.
function togglebutton_synVisible_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_synVisible (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_synVisible

global glob

val = get(hObject,'Value');
G = get(handles.popupmenu_synGroup,'Value');


try
        glob.syn.g(G).p.Visible = val;
end

if val
    set(hObject,'String','Visible')
    glob.syn.g(G).show = val;
else
    set(hObject,'String','Hidden')
    glob.syn.g(G).show = val;
end


% --- Executes on button press in pushbutton_jumpToObjects.
function pushbutton_jumpToObjects_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_jumpToObjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on button press in pushbutton_resetZoom.
function pushbutton_resetZoom_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_resetZoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob

set(glob.handles.mainAx,'color',[0 0 0])
set(glob.handles.mainAx,'visible','off')
set(glob.handles.mainAx,'View',[0 0])

val = get(hObject,'Value');
if val
    set(glob.handles.mainAx,'CameraPositionMode','auto')
    set(glob.handles.mainAx,'CameraTargetMode','auto')
    set(glob.handles.mainAx,'CameraViewAngleMode','auto')
else
    set(glob.handles.mainAx,'CameraPositionMode','manual')
    set(glob.handles.mainAx,'CameraTargetMode','manual')
    set(glob.handles.mainAx,'CameraViewAngleMode','manual')
end

% --- Executes during object creation, after setting all properties.
function pushbutton_resetZoom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_resetZoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton_loadGlob.
function pushbutton_loadGlob_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadGlob (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob
[TFN TPN ] = uigetfile(glob.save.defaultDir);

close (glob.handles.figure1)
load([TPN TFN]);

%guidata(glob.handles.figure1,glob.figData)


% --- Executes on selection change in popupmenu_selectWindows.
function popupmenu_selectWindows_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_selectWindows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_selectWindows contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_selectWindows

strs = get(hObject,'String');
val = get(hObject,'Value');
str = strs{val};

switch str
    case 'Import Data'
        glob.windows.importData = ImportData;
    case 'Create Custom Object'
        glob.windows.customObject = customObject;
    case 'Copy cellNav'
        glob.windows.copyCellNav = copyCellNav;
    case 'Transform Volume'
        glob.windows.transformVolume = transformVolume;
    case 'Generate point to point graphs'
        glob.windows.pt2ptGraph = GraphPointToPoint;
    case 'Cell Table'
        glob.windows.cellTable = cellTable;
    case 'Translate List'
        glob.windows.translateList = translateList;
    case 'Create Custom Group'
        glob.windows.customGroup = customGroup;
    otherwise
        set(handles.textOut,'String','Window not registered')
end





% --- Executes during object creation, after setting all properties.
function popupmenu_selectWindows_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_selectWindows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

str = {'Import Data','Generate point to point graphs','Translate List','Create Custom Object', 'Create Custom Group',...
    'Model Transmission','Transform Volume','Copy cellNav','Cell Table'};
set(hObject,'String',str);



function blendPatches

global glob

pch = findobj(glob.handles.mainAx,'type','patch');

for i = 1:length(pch)
    tag(i) = str2num(pch(i).Tag);    
end

uTags = unique(tag);
for i = 1:length(uTags)
   isTag = find(tag==uTags(i)); 
   if length(isTag)>1     
       cols = cat(1,pch(isTag).FaceColor);
       alphs = cat(1,pch(isTag).FaceAlpha);
       alphs = alphs/sum(alphs);
       cols = cols.*repmat(alphs,[1,3]);
       newCol = sum(cols,1);
       for p = 1:length(isTag)
            pch(isTag(p)).FaceColor = newCol;
       end
   end
end


% --- Executes on button press in pushbutton_blendPatches.
function pushbutton_blendPatches_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_blendPatches (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

blendPatches


% --- Executes on selection change in popupmenu_OtherObjects.
function popupmenu_OtherObjects_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_OtherObjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_OtherObjects contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_OtherObjects
global glob tis tisDat

strs = get(hObject,'String');
val = get(hObject,'Value');
str = lower(strs{val});

uVal =  ~glob.param.ref(val);
glob.param.ref(val) = uVal;

if uVal
      strs{val} = upper(str);
else
      strs{val} = lower(str);
end
set(hObject,'String',strs)



switch str
    case lower('IPL Borders')
        
        try
            isHand = isvalid(glob.p.pRefINL);
        catch err
            isHand = 0;
        end
        
        if uVal
            if isHand
                glob.p.pRefGCL.Visible = 'on';
                glob.p.pRefINL.Visible = 'on';
            else
                load([glob.useFvDir 'ref_gcl nucEdge.mat'])
                glob.p.pRefGCL = renderFVnav(fv,[1 1 0],.5)
                
                load([glob.useFvDir 'ref_inl nucEdge.mat'])
                glob.p.pRefINL = renderFVnav(fv,[1 0 1],.5)
            end
        else
            if isHand
                glob.p.pRefGCL.Visible = 'off'
                glob.p.pRefINL.Visible = 'off'
            end
        end
        
    case lower('Scale Bar')
        try
            isHand = isvalid(glob.p.pRefMicronBar);
        catch err
            isHand = 0;
        end
        
        if uVal
            if isHand
                glob.p.pRefMicronBar.Visible = 'on';
                glob.p.pRefMicronPt1.Visible = 'on';
                glob.p.pRefMicronPt2.Visible = 'on';
            else
                load([glob.useFvDir 'ref_10 micron bar.mat'])
                glob.p.pRefMicronBar = renderFVnav(fv,[1 1 1],1)
                
                load([glob.useFvDir 'ref_10 micron point 1.mat'])
                glob.p.pRefMicronPt1 = renderFVnav(fv,[1 1 1],.5)
                
                load([glob.useFvDir 'ref_10 micron point 2.mat'])
                glob.p.pRefMicronPt2 = renderFVnav(fv,[1 1 1],.5)
            end
        else
            if isHand
                glob.p.pRefMicronBar.Visible = 'off';
                glob.p.pRefMicronPt1.Visible = 'off';
                glob.p.pRefMicronPt2.Visible = 'off';
            end
        end
        
    case lower('All Bipolars')
        
        try
            isHand = isvalid(glob.p.pBipolars);
        catch err
            isHand = 0;
        end
        
        if uVal
            if isHand
                glob.p.pBipolars.Visible = 'on';
            else
                bipCids = glob.cids(tis.cells.type.typeID == 7);
                vert = [];
                fac = [];
                for i = 1:length(bipCids)
                    fileName = sprintf('%s%d.mat',glob.useFvDir,bipCids(i));
                    fv = loadFV(fileName);;
                    fac = cat(1,fac,fv.faces+size(vert,1));
                    vert = cat(1,vert,fv.vertices);
                end
                
                fv.vertices = vert;
                fv.faces = fac;
                glob.p.pBipolars = renderFVnav(fv,[0 .8 0],.1)
                
            end
        else
            if isHand
                glob.p.pBipolars.Visible = 'off';
            end
        end
        
end



% --- Executes during object creation, after setting all properties.
function popupmenu_OtherObjects_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_OtherObjects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


str = {'IPL Borders', 'Scale Bar', 'All Bipolars'}
set(hObject,'String',str)
set(hObject,'Value',1)


% --- Executes on selection change in popupmenu_sourceVolume.
function popupmenu_sourceVolume_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_sourceVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_sourceVolume contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_sourceVolume

global glob tis tisDat

strs = get(hObject,'String');
val = get(hObject,'Value');
str = strs{val};

if val>1
    glob.useFvDir = [glob.dir.Volumes str '\Analysis\fvLibrary\'];
else
    glob.useFvDir = glob.fvDir;
end

glob.vol.activeID = val-1;
glob.vol.activeName = str;

load([glob.useFvDir 'tis.mat']);
load([glob.useFvDir 'tisDat.mat']);
updateCellNavGlob
set(handles.popupCellType,'Value',1);
set(handles.popupCellType,'String',glob.typeStrings);

popupCellType_Callback(handles.popupCellType,[],handles);


% --- Executes during object creation, after setting all properties.
function popupmenu_sourceVolume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_sourceVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob
str = {'Main',glob.vol.names{:}};
set(hObject,'String',str);


% --- Executes on button press in pushbutton_makeTable.
function pushbutton_makeTable_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_makeTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global glob tis

glob.windows.cellTable = cellTable;


% --------------------------------------------------------------------
function manageLibrary_Callback(hObject, eventdata, handles)
% hObject    handle to manageLibrary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuImport_Callback(hObject, eventdata, handles)
% hObject    handle to menuImport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ImportData


% --------------------------------------------------------------------
function menuTransformVolume_Callback(hObject, eventdata, handles)
% hObject    handle to menuTransformVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

transformVolume


% --------------------------------------------------------------------
function menueAnalyze_Callback(hObject, eventdata, handles)
% hObject    handle to menueAnalyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuGraphPointToPoint_Callback(hObject, eventdata, handles)
% hObject    handle to menuGraphPointToPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GraphPointToPoint


% --------------------------------------------------------------------
function menuCustomize_Callback(hObject, eventdata, handles)
% hObject    handle to menuCustomize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuObjectGroups_Callback(hObject, eventdata, handles)
% hObject    handle to menuObjectGroups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


customObject


% --------------------------------------------------------------------
function menuAnnotate_Callback(hObject, eventdata, handles)
% hObject    handle to menuAnnotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuePointList_Callback(hObject, eventdata, handles)
% hObject    handle to menuePointList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


translateList


% --------------------------------------------------------------------
function menuMakePath_Callback(hObject, eventdata, handles)
% hObject    handle to menuMakePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    set(handles.uipanel_pathProperties,'Visible','on')
    set(handles.togglebutton_pathProperties,'Value',1)
    updatePathPanel


% --------------------------------------------------------------------
function menuCellTable_Callback(hObject, eventdata, handles)
% hObject    handle to menuCellTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


cellTable


% --------------------------------------------------------------------
function menuDataPanel_Callback(hObject, eventdata, handles)
% hObject    handle to menuDataPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global glob tisDat

load([glob.useFvDir 'tisDat.mat']);
set(handles.panelData,'Visible',1)
set(handles.toggle_dataOn,'Value',1)

% --------------------------------------------------------------------
function menuCustomGroups_Callback(hObject, eventdata, handles)
% hObject    handle to menuCustomGroups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

customGroup


% --------------------------------------------------------------------
function customSynGroup_Callback(hObject, eventdata, handles)
% hObject    handle to customSynGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

customSynGroup


% --------------------------------------------------------------------
function menu_FindAppositions_Callback(hObject, eventdata, handles)
% hObject    handle to menu_FindAppositions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

findAppositions


% --------------------------------------------------------------------
function menu_importSWC_Callback(hObject, eventdata, handles)
% hObject    handle to menu_importSWC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

importSWC


% --------------------------------------------------------------------
function runEditSkeleton_Callback(hObject, eventdata, handles)
% hObject    handle to runEditSkeleton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

editSkeleton
