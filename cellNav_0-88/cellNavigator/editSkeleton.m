function varargout = editSkeleton(varargin)
% EDITSKELETON MATLAB code for editSkeleton.fig
%      EDITSKELETON, by itself, creates a new EDITSKELETON or raises the existing
%      singleton*.
%
%      H = EDITSKELETON returns the handle to a new EDITSKELETON or the handle to
%      the existing singleton*.
%
%      EDITSKELETON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDITSKELETON.M with the given input arguments.
%
%      EDITSKELETON('Property','Value',...) creates a new EDITSKELETON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before editSkeleton_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to editSkeleton_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help editSkeleton

% Last Modified by GUIDE v2.5 07-Apr-2021 13:37:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @editSkeleton_OpeningFcn, ...
    'gui_OutputFcn',  @editSkeleton_OutputFcn, ...
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


% --- Executes just before editSkeleton is made visible.
function editSkeleton_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to editSkeleton (see VARARGIN)

% Choose default command line output for editSkeleton
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes editSkeleton wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global glob globES
clear globES
global globES



%%Set up figure
globES.h = handles;
mainAx = handles.mainAx;
z = zoom(gcf);

setAxes3DPanAndZoomStyle(z,mainAx,'limits')
set(globES.h.mainAx,'Clipping','Off');

set(mainAx,'color',[0 0 0])
set(mainAx,'visible','off')
set(mainAx,'View',[0 0])
set(mainAx,'CameraPositionMode','auto')
set(mainAx,'CameraTargetMode','auto')
set(mainAx,'CameraViewAngleMode','auto')

daspect([1,1,1]);
view(3); axis tight
set(gcf,'color',[0 0 0]);

l = lightangle(145,45) ;


set(mainAx,'color',[0 0 0])
set(globES.h.figure1,'color',[0 0 0])

%set(gcf,'color',[0 0 0])
set(mainAx,'visible','off')
set(mainAx, 'NextPlot', 'add')


%%Set variables
globES.branch.on = 0;
globES.branch.nodes = [];
globES.branch.rads = [];
globES.branch.edges = [];
globES.view.clip = 0;
globES.view.surfAlph = .3;
globES.view.winWidth = 10;
globES.view.pickNode = 1;
set(handles.edit_winSize,'String',num2str(globES.view.winWidth))
globES.view.showOriginal = 0;

try
    globES.pickCID = glob.pickCID
catch err
    globES.pickCID = [];
end


%%Set up files
try globES.f.useFvDir = glob.useFvDir;
catch
    globES.f.useFvDir = [];
end

if ~isempty(globES.f.useFvDir);
    slashes = regexp(globES.f.useFvDir,'\');
    globES.f.saveDir = [globES.f.useFvDir(1:slashes(end-1)) 'editSkel\'];
    if ~exist(globES.f.saveDir),mkdir(globES.f.saveDir);end
end

set(handles.edit_CID,'String',num2str(globES.pickCID))
set(handles.edit_saveFolder,'String',globES.f.saveDir);
globES.f.saveName = sprintf('nep_%d_edit',globES.pickCID);

set(handles.edit_saveName,'String',globES.f.saveName);

% --- Outputs from this function are returned to the command line.
function varargout = editSkeleton_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_CID_Callback(hObject, eventdata, handles)
% hObject    handle to edit_CID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_CID as text
%        str2double(get(hObject,'String')) returns contents of edit_CID as a double
global globES

str = get(hObject,'String');
num = str2num(str);
globES.pickCID = num;


% --- Executes during object creation, after setting all properties.
function edit_CID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_CID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pickNode_togglebutton.
function pickNode_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to pickNode_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pickNode_togglebutton
global glob globES

deselectToggleUI(handles, hObject)

val = get(hObject,'Value');

globES.pick.edgeID = [];
globES.pick.edgePos = [];
globES.pick.nodeID = [];
globES.pick.nodePos = [];
globES.skelSelect = [];
globES.skelPt = [];

if val
    delete(findall(handles.figure1,'Type','hggroup'));
    %try delete(globES.dcm);  end
    %deselectToggleUI(handles, hObject)
    globES.dcm = datacursormode(handles.figure1);
    globES.dcm.UpdateFcn = @pickEdge;
    set(globES.dcm,'DisplayStyle','window',...
        'SnapToDataVertex','off','Enable','on');
    
    set(globES.p.vert,'Visible','Off')
    set(globES.p.volPatch,'Visible','Off')
    set(globES.p.plotSkel,'Visible','Off')
    
    
    
else
    rotate3d(handles.figure1);
    delete(findall(handles.figure1,'Type','hggroup'));
    set(globES.p.vert,'Visible','On')
    set(globES.p.volPatch,'Visible','On')
    set(globES.p.plotSkel,'Visible','On')
    
end

% --- Executes on button press in pickEdge_togglebutton.
function pickEdge_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to pickEdge_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hint: get(hObject,'Value') returns toggle state of pickNode_togglebutton
global glob globES

deselectToggleUI(handles, hObject)

val = get(hObject,'Value');


globES.pick.edgeID = [];
globES.pick.edgePos = [];
globES.pick.nodeID = [];
globES.pick.nodePos = [];
globES.skelSelect = [];
globES.skelPt = [];

if val
    delete(findall(handles.figure1,'Type','hggroup'));
    %try delete(globES.dcm);  end
    %deselectToggleUI(handles, hObject)
    globES.dcm = datacursormode(handles.figure1);
    globES.dcm.UpdateFcn = @pickEdge;
    set(globES.dcm,'DisplayStyle','window',...
        'SnapToDataVertex','off','Enable','on');
    
    set(globES.p.vert,'Visible','Off')
    set(globES.p.volPatch,'Visible','Off')
    
    
    
else
    rotate3d(handles.figure1);
    delete(findall(handles.figure1,'Type','hggroup'));
    set(globES.p.vert,'Visible','On')
    set(globES.p.volPatch,'Visible','On')
end

function txt = pickEdge(~,info)
global globES


globES.data.skelSelect = [];
globES.data.skelPt = [];

tag = info.Target.Tag;
if strcmp(tag,'plotSkel')
    
    ePos = [info.Target.XData; info.Target.YData;info.Target.ZData];
    ePos = ePos([2 1 3],:);
    pos = globES.data.pos;
    n1 = find(sum(abs(pos - repmat(ePos(:,1)',[size(pos,1) 1])),2)==0,1);
    n2 = find(sum(abs(pos - repmat(ePos(:,2)',[size(pos,1) 1])),2)==0,1);
    
    edges = globES.data.edges;
    dE1 = edges - n1;
    dE2 = edges - n2;
    hit = find(~dE1(:,1) & ~dE2(:,2));
    if isempty(hit)
        hit = find(~dE1(:,2) & ~dE2(:,1));
    end
    
    globES.pick.edgeID = [globES.pick.edgeID hit];
    globES.pick.edgePos = cat(3,globES.pick.edgePos, [pos(n1,:); pos(n2,:)]);
    %     edgePos = permute(globES.pick.edgePos,[3 1 2]);
    %     globES.pick.edgePos1 = edgePos(:,:,2);
    %     globES.pick.edgePos2 = edgePos(:,:,1);
    %     globES.pick.edgePos3 = edgePos(:,:,3);
    % refreshdata
    %     drawnow
    
elseif strcmp(tag,'scatSkel')
    meanPt = info.Position([2 1 3]);
    pos = globES.data.pos;
    dists = sqrt((pos(:,1)-meanPt(1)).^2 + (pos(:,2)-meanPt(2)).^2 + ...
        (pos(:,3) - meanPt(3)).^2);
    targ =  find(dists == 0,1);
    
    globES.data.newPt = meanPt;
    globES.data.newRad = globES.data.rads(targ);
    globES.pick.nodeID = [globES.pick.nodeID targ];
    globES.pick.nodePos = meanPt;
end

txt = sprintf('picked edges =  %s, nodes = %s',...
    num2str(globES.pick.edgeID),num2str(globES.pick.nodeID));



function updatePlots

showEdges
showScatterSkel



% --- Executes on button press in pickSurface_togglebutton.
function pickSurface_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to pickSurface_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pickSurface_togglebutton


% --- Executes on button press in load_pushbutton.
function load_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to load_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

loadCID


function loadCID(nepFileName)

global glob globES

try   delete(globES.p.skel), end
try    delete(globES.p.plotSkel), end;
try    delete(globES.p.scatterSkel), end;
try   delete(globES.p.surface), end;


fileName = sprintf('%s%d.mat',globES.f.useFvDir,globES.pickCID);
fv = loadFV(fileName);
%globSE.p.surface = renderFVnav(fv,[0 .8 0],.2)
globES.data.vert = fv.vertices;
if exist(fileName,'file')
    fv = loadFV(fileName);
    fv.vertices = fv.vertices(:,[1 2 3]) ;
    try delete(globES.p.volPatch); end
    globES.p.volPatch = renderFVnav(fv,[1 1 1],.6);
    globES.p.volPatch.FaceAlpha = globES.view.surfAlph;
    set(globES.h.togglebutton_showSurface,'Value',1)
    
    %globES.p.fullPatch =  renderFVnav(fv,[1 1 1],.2); %% show full patch outside of window
    
    cellRange = cat(1, min(fv.vertices,[],1), max(fv.vertices,[],1));
    cellRange = cellRange(:,[3 2 1]);
    %    scatter3(cellRange(1,1),cellRange(1,2),cellRange(1,3),'*','r')
    %   scatter3(cellRange(2,1),cellRange(2,2),cellRange(2,3),'*','r')
    globES.view.cellRange = cellRange;
    globES.view.window = cellRange;
    
end
try  globES.p.cell.FaceAlpha = .25; end



if exist('nepFileName','var')
    fileName = nepFileName;
else
    fileName = sprintf('%snep_%d.mat',globES.f.useFvDir,globES.pickCID);
end

if 1 % show skel with edges and nodes
    if exist(fileName,'file')
        %fv = loadFV(fileName);
        load(fileName)
        globES.data.currentNep = nep;
        if isfield(nep,'autoNep')
            globES.data.autoNep = nep.autoNep;
        else
            globES.data.autoNep = nep;
        end
        hold on
        pos = nep.pos;
        globES.data.fileName = fileName;
        edges = nep.edges;
        globES.data.pos = pos;
        globES.data.edges = edges;
        globES.data.seedNode = nep.seedNode;
        globES.data.seedPos = pos(nep.seedNode,:);
        globES.data.rads = nep.nodeRad;
        globES.data.fv = nep.fv;
        %         try delete(globES.p.nepFV), end
        %         globES.p.nepFV = renderFV(nep.fv,[1 1 1],.3);
        
        globES.data.bones = nep.bones;
        globES.view.pickNumMax = length(nep.bones);
        globES.data.autoPos = pos;
        
        showEdges
        showScatterSkel
        
        globES.p.seed = scatter3(globES.data.seedPos(2),globES.data.seedPos(1),...
            globES.data.seedPos(3),300,'g','o')
    end
end

%%Show points across surface of cell. needed for selection
showVerts


%%Check radius
radVal = get(globES.h.radius_togglebutton,'Value');
if radVal
    showRad
else
    try delete(globES.p.rad), end
end

globES.f.saveName = sprintf('nep_%d_edit',globES.pickCID);
set(globES.h.edit_saveName,'String',globES.f.saveName);


function showVerts

global globES

%%Make scatter vertices for selection

vert = globES.data.vert;
dsamp = 10; % 1 = a few surface spots.  1000= ~all
v = round(vert*dsamp);
maxV = ceil(max(v,[],1));
ind = sub2ind(maxV,v(:,1),v(:,2),v(:,3));
uInd = unique(ind);
[y x z] = ind2sub(maxV,uInd);
v = [y x z] * 1/dsamp;
v = v(:,[3 2 1]); %!dim
%v = vert; %!!!!!!

globES.data.vertInd = 1:size(v,1);
if globES.view.clip
    [isPos isEdge] = winFilt(globES.view.window,v(:,[2 1 3])); %!dim
    globES.data.vertInd = find(isPos);
    v = v(isPos,:);
end


set(globES.h.mainAx, 'NextPlot', 'add');
try delete(globES.p.vert); end
globES.p.vert = scatter3(v(:,1),v(:,2),v(:,3),5,...
    'b','filled','MarkerEdgeAlpha',0,'MarkerFaceAlpha',0); %!dim
%set(globES.p.vert,'visible','off')
set(globES.p.vert,'Tag','vert')



function[] = showScatterSkel

global globES

pos = globES.data.pos;
globES.data.nodeInd = 1:size(pos,1);
if globES.view.clip
    [isPos isEdge] = winFilt(globES.view.window,pos);
    globES.data.nodeInd = find(isPos);
    pos = pos(isPos,:);
end


try delete(globES.p.scatterSkel); catch, end
globES.p.scatterSkel = scatter3(pos(:,2),pos(:,1),pos(:,3),30,...
    'o','markeredgecolor',[0 .2 0],'markerfacecolor',[0 1 0]);

set(gca,'Clipping','Off');
set(globES.p.scatterSkel,'Tag','scatSkel')

function[] = showEdges

global globES

pos = globES.data.pos;
edges = globES.data.edges;

if globES.view.clip
    [isPos isEdge] = winFilt(globES.view.window,pos,edges);
    %pos = pos(isPos,:);
    edges = edges(isEdge,:);
end


try delete(globES.p.plotSkel); catch, end
globES.p.plotSkel = plot3([pos(edges(:,1),2) pos(edges(:,2),2)]',...
    [pos(edges(:,1),1) pos(edges(:,2),1)]',...
    [pos(edges(:,1),3) pos(edges(:,2),3)]','color',[0 .8 0],'linewidth',2);
set(gca,'Clipping','Off');
set(globES.p.plotSkel,'Tag','plotSkel')

function showWindow

global globES


win = globES.view.window';

cornPts = [1 2 3; 1 2 6; 1 5 3; 1 5 6;...
    4 2 3; 4 2 6; 4 5 3; 4 5 6];
cornPos = win(cornPts);

cornFac = [3 1 2 4 ; 6 5 7 8;1 2 6 5; 3 4 8 7; 2 4 8 6 ; 5 1 3 7];

fv.vertices = cornPos;
fv.faces = cornFac;

try delete(globES.p.win); end
globES.p.win = patch(globES.h.mainAx,fv,'facecolor',[1 0 0],'facealpha',.07,...
    'edgealpha',1,'edgecolor','r');
globES.p.win.FaceColor = 'flat';
globES.p.win.FaceVertexCData = [ 1 0 0;1 0 0; 0 1 0; 0 1 0; 0 0 1; 0 0 1];


function[isPos isEdge] = winFilt(win,pos,edges);

if ~exist('edges','var')
    edges = [];
end
%!dim
pos = pos(:,[2 1 3]);
isPos = (pos(:,1) >= win(1,1)) & (pos(:,1) <= win(2,1)) & ...
    (pos(:,2) >= win(1,2)) & (pos(:,2) <= win(2,2)) & ...
    (pos(:,3) >= win(1,3)) & (pos(:,3) <= win(2,3));

edgeHit = isPos(edges);

isEdge = sum(edgeHit,2)==2;



% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function loadSkel_menu_Callback(hObject, eventdata, handles)
% hObject    handle to loadSkel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function loadAnySkel_menu_Callback(hObject, eventdata, handles)
% hObject    handle to loadAnySkel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function saveSkel_menu_Callback(hObject, eventdata, handles)
% hObject    handle to saveSkel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function saveSkelAs_menu_Callback(hObject, eventdata, handles)
% hObject    handle to saveSkelAs_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function deselectToggleUI(handles, hObject)

tag = get(hObject,'Tag');
hList = {'pickNode_togglebutton', 'pickEdge_togglebutton',...
    'pickSurface_togglebutton'};

for i = 1:length(hList)
    if ~strcmp(tag,hList{i})
        try
            set(eval(['handles.' hList{i}]),'Value',0);
            % eval([hList{i} '_Callback(handles.' hList{i} ',[],handles)']);
        end
    end
end


% --- Executes on selection change in file_popupmenu.
function file_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to file_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns file_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from file_popupmenu

global glob globES

strs = get(hObject,'String');
val = get(hObject,'Value');
str = strs{val};

if strcmp(str,'Load CID')
    set(handles.textOut,'String','Loading')
    loadCID
    set(handles.textOut,'String','Finished loading')
    
elseif strcmp(str,'Load Target Skeleton')
    set(handles.textOut,'String','Loading')
    [TFN TPN] = uigetfile(globES.f.saveDir);
    loadCID([TPN '/' TFN])
    set(handles.textOut,'String',sprintf('Finished loading %s',TFN))
    
elseif strcmp(str,'Save')
    set(handles.textOut,'String','Saving')
    nep = makeNep;
    fileName = sprintf('%snep_%d.mat',globES.f.useFvDir,globES.pickCID);
    save(globES.data.fileName,'nep');
    set(handles.textOut,'String',sprintf('Finished saving %s',fileName))
elseif strcmp(str,'Save As')
    set(handles.textOut,'String','Saving')
    fileName = sprintf('%s%s.mat',globES.f.saveDir,globES.f.saveName);
    nep = makeNep;
    save(fileName,'nep')
    set(handles.textOut,'String',sprintf('Finished saving %s',fileName))
end




% --- Executes during object creation, after setting all properties.
function file_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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


% --- Executes on button press in brushNode_togglebutton.
function brushNode_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to brushNode_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of brushNode_togglebutton

deselectToggleUI(handles, hObject)
val = get(hObject,'Value');

globES.pick.edgeID = [];
globES.pick.edgePos = [];
globES.pick.nodeID = [];
globES.pick.nodePos = [];
globES.skelSelect = [];
globES.skelPt = [];


if val
    makeBrush
else
    deleteBrush
end

function makeBrush
global glob globES

globES.brushOb = brush(globES.h.figure1);
set(globES.brushOb,'enable','on')
%set(globES.brushOb,'ActionPostCallback', @useBrush);

%      set(globES.brushOb,'ActionPostCallback',...
%         @(ohf,s) useBrush(ohf,s), 'enable','on');
%      set(globES.brushOb,'ActionPreCallback',...
%         @(ohf,s) useBrush(ohf,s), 'enable','on');

%addlistener(globES.p.vert,'BrushData',@(ohf,s) useBrush(ohf,s))

function deleteBrush
global glob globES

brush(globES.h.figure1,'off')
try set(globES.brushOb,'enable','off'),catch,end
brush(globES.h.figure1,'off')
try set(globES.brushOb,'enable','off'); end
try delete(globES.p.newPt), end
try delete(globES.p.skelPt), end

function useBrush(varargin)

global globES

skelSelect = globES.p.scatterSkel.BrushData;
%globES.p.plotSkel.BrushData
vertSelect = globES.p.vert.BrushData>0;
sum(vertSelect)
sum(skelSelect)
% set(globES.p.vert,'Visible','on')
%
Ys = globES.p.vert.YData(vertSelect);
Xs = globES.p.vert.XData(vertSelect);
Zs = globES.p.vert.ZData(vertSelect);
%
%
globES.data.newPt = [mean(Ys) mean(Xs) mean(Zs)];
%  pause(1)
%  brush off
%  pause(1)
% globES.p.newPt = scatter3(globES.h.mainAx,...
%     Xs,Ys,Zs,200,'*','markerlinewidth',4);



%set(globES.h.mainAx, 'NextPlot', 'add')
%vertSel = scatter3(globES.h.mainAx,Xs,Ys,Zs,200,'*');
pause(.01)
%brush(globES.h.figure1,'off')
%set(globES.brushOb,'Enable','off')

%rotate3d(globES.h.figure1)


%   set(globES.brushOb,'ActionPostCallback',...
%         @(ohf,s) useBrush(ohf,s), 'enable','off')

'bark'


% --- Executes on button press in brushEdge_togglebutton.
function brushEdge_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to brushEdge_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of brushEdge_togglebutton


val = get(hObject,'Value');

if val
    makeBrush
else
    deleteBrush
end


% --- Executes on button press in brushToEdge_pushbutton.
function brushToEdge_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to brushToEdge_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global globES

vertSelect = find(globES.p.scatterSkel.BrushData);
sum(vertSelect)
Ys = globES.p.scatterSkel.YData(vertSelect);
Xs = globES.p.scatterSkel.XData(vertSelect);
Zs = globES.p.scatterSkel.ZData(vertSelect);
rads = globES.data.rads(vertSelect);

ids = find(vertSelect);

set(globES.h.brushNode_togglebutton,'value',0)
deleteBrush

meanPt = [mean(Ys) mean(Xs) mean(Zs)];
dists = sqrt((Ys-meanPt(1)).^2 + (Xs-meanPt(2)).^2 + ...
    (Zs - meanPt(3)).^2);
targ =  find(dists == min(dists),1);
useNode = vertSelect(targ);

newPt = [Ys(targ) Xs(targ) Zs(targ)];
globES.data.newPt = newPt;
globES.data.newRad = rads(ids(targ));
%set(globES.brushOb,'Enable','Off')

hold on
if ~isempty(newPt)
    try delete(globES.p.newPt), end
    globES.p.newPt = scatter3(globES.h.mainAx,...
        newPt(:,2),newPt(:,1),newPt(:,3),200,'*','markeredgecolor','y',...
        'linewidth',4);
    pause(.01)
    
    skelPt = [Ys(:) Xs(:) Zs(:)];
    globES.data.skelPt = skelPt;
    globES.data.skelSelect = vertSelect;
    set(globES.brushOb,'Enable','Off')
    try delete(globES.p.skelPt), end
    globES.p.skelPt = scatter3(globES.h.mainAx,...
        skelPt(:,2),skelPt(:,1),skelPt(:,3),20,'o','filled',...
        'markerfacecolor','y','markeredgecolor','y');
    pause(.01)
    
    
    
    if globES.branch.on
        addPtToBranch
        set(globES.h.brushNode_togglebutton,'value',1)
        makeBrush
    end
    
else
    set(handles.textOut,'String','No skeleton points selected');
end



%
% edgeSelect = cat(1,globES.p.plotSkel.BrushData) > 0;
% sum(vertSelect)
% Ys = globES.p.vert.YData(vertSelect);
% Xs = globES.p.vert.XData(vertSelect);
% Zs = globES.p.vert.ZData(vertSelect);
% skelPt = [Ys Xs Zs];
% globES.data.skelPt = skelPt;
% set(globES.brushOb,'Enable','Off')
% %  pause(1)
% %  brush off
% %  pause(1)
% try delete(globES.p.skelPt), end
% globES.p.newPt = scatter3(globES.h.mainAx,...
%     skelPt(:,2),skelPt(:,1),skelPt(:,3),200,'*','linewidth',4);
% pause(.01)






% --- Executes on button press in surfaceToNode_pushbutton.
function surfaceToNode_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to surfaceToNode_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global globES

vertSelect = globES.p.vert.BrushData>0;
if sum(vertSelect)
    Ys = globES.p.vert.YData(vertSelect);
    Xs = globES.p.vert.XData(vertSelect);
    Zs = globES.p.vert.ZData(vertSelect);
    
    set(globES.h.brushNode_togglebutton,'value',0)
    deleteBrush
    
    newPt = [mean(Ys) mean(Xs) mean(Zs)];
    dists = sqrt((Ys-newPt(1)).^2 + (Xs-newPt(2)).^2 + (Zs-newPt(3)).^2);
    newRad = mean(dists);
    
    globES.data.newPt = newPt;
    globES.data.newRad = newRad;
    set(globES.brushOb,'Enable','Off')
    %  pause(1)
    %  brush off
    %  pause(1)
    try delete(globES.p.newPt), end
    globES.p.newPt = scatter3(globES.h.mainAx,...
        newPt(:,2),newPt(:,1),newPt(:,3),200,'*','y','linewidth',4);
    pause(.01)
    
    if globES.branch.on
        addPtToBranch
        set(globES.h.brushNode_togglebutton,'value',1)
        makeBrush
    end
    
else
    set(handles.textOut,'String','No selection detected')
end

% --- Executes on button press in remove_pushbutton.
function remove_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to remove_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global globES

pos = globES.data.pos;
edges = globES.data.edges;
rads = globES.data.rads;


if ~isempty(globES.pick.edgeID)
    edges = edges(setdiff([1:size(edges,1)],globES.pick.edgeID),:);
    globES.data.edges = edges;
    globES.pick.edgeID = [];
end

if isfield(globES.data,'skelSelect')
    skelSelect = globES.data.skelSelect;
    skelSelect = globES.data.nodeInd(skelSelect);
else
    skelSelect = [];
end

if ~isempty(globES.pick.nodeID)
    skelSelect = [skelSelect globES.pick.nodeID];
    globES.pick.nodeID = [];
end

if ~isempty(skelSelect)
    L = size(pos,1);
    n = pos(skelSelect,:);
    nL = size(n,1);
    keepID = setdiff(1:size(pos,1),skelSelect);
    pos = pos(keepID,:);
    newID = 1:length(keepID);
    lookUpT = zeros(L,1);
    lookUpT(keepID) = newID;
    edges = lookUpT(edges);
    cutEdges = sum(edges==0,2);
    edges = edges(~cutEdges,:);
    rads = rads(keepID);
    
    globES.data.pos = pos;
    globES.data.edges = edges;
    globES.data.rads = rads;
    
    try delete(globES.p.skelPt), end
    try delete(globES.p.newPt), end
    globES.data.skelSelect = [];
    globES.data.skelPt = [];
end

updateSkel
deleteBrush




function updateSkel

global globES
%
% pos = globES.data.pos;
% edges = globES.data.edges;
%
% % show skel with edges and nodes
% hold on
% try delete(globES.p.scatterSkel); catch, end
% globES.p.scatterSkel = scatter3(pos(:,2),pos(:,1),pos(:,3),5,'o',...
%     'w','filled');
% try delete(globES.p.plotSkel); catch, end
% globES.p.plotSkel = plot3([pos(edges(:,1),2) pos(edges(:,2),2)]',...
%     [pos(edges(:,1),1) pos(edges(:,2),1)]',...
%     [pos(edges(:,1),3) pos(edges(:,2),3)]','color',[1 0 0],'linewidth',1);
% set(gca,'Clipping','Off');
% set(globES.p.plotSkel,'Tag','plotSkel')
% set(globES.p.scatterSkel,'Tag','scatSkel')

globES.branch.nodes = [];
globES.branch.rads = [];
globES.branch.on = 0;

showEdges
showScatterSkel
showBranch




% --- Executes on button press in start_pushbutton.
function start_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to start_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global globES


if ~globES.branch.on | isempty(~globES.branch.nodes)
    globES.branch.on = 1;
    
    if isfield(globES.data, 'newPt')
        if length(globES.data.newPt) == 3
            globES.branch.nodes = globES.data.newPt(:)';
            globES.branch.rads = globES.data.newRad;
        end
    end
    showBranch
    
else
    set(handles.textOut,'String','Must clear previous branch before starting a new one');
end
globES.branch


function showBranch

global globES

n = globES.branch.nodes;

if globES.branch.on
    set(globES.h.Branch_uibuttongroup,'BackgroundColor',[1 1 0.70]);
else
    set(globES.h.Branch_uibuttongroup,'BackgroundColor',[.94 .94 .94]);
end

try delete(globES.p.branchNodes), end
if size(n,1)>0
    globES.p.branchNodes = scatter3(n(:,2),n(:,1),n(:,3),100,'o','c','filled');
end


try delete(globES.p.branchEdges), end
if size(n,1)>1
    globES.p.branchEdges = plot3([n(1:end-1,2) n(2:end,2)],...
        [n(1:end-1,1) n(2:end,1)],[n(1:end-1,3) n(2:end,3)],'c','linewidth',4);
end


try delete(globES.p.branchRad), end

posR = globES.branch.nodes;
L = size(posR,1);
edgeR = cat(2,[1:L-1]', [2:L]');
radR = globES.branch.rads;
nodeColR = [1 1 0];
alph = 1;

%posR(:,1) = posR(:,1) * -1;
if L>1
    %[fvRad globES.p.branchRad] = showRadSurf_cn(posR(:,[2 1 3]),edgeR,radR,nodeColR,alph,globES.h.figure1)
    [fvRad globES.p.branchRad] = showRadPts_cn(posR,edgeR,radR,nodeColR,alph)
    
elseif L==1
    posR = cat(1,posR,posR+.1);
    edgeR = [1 2];
    radR = [radR radR];
    [fvRad globES.p.branchRad] = showRadSurf_cn(posR,edgeR,radR,nodeColR,alph,globES.h.figure1)
    
end



% --- Executes on button press in add_pushbutton.
function add_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to add_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


addPtToBranch

function addPtToBranch
global globES

if globES.branch.on
    if isfield(globES.data, 'newPt')
        if length(globES.data.newPt) == 3
            globES.branch.nodes = cat(1,globES.branch.nodes,globES.data.newPt(:)');
            globES.branch.rads = cat(1,globES.branch.rads,globES.data.newRad);
        end
    end
end
showBranch
globES.branch

% --- Executes on button press in backup_pushbutton.
function backup_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to backup_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global globES

n = globES.branch.nodes;
if size(n,1)>0
    n = n(1:end-1,:);
    globES.branch.nodes = n;
end
showBranch

% --- Executes on button press in merge_pushbutton.
function merge_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to merge_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global globES

pos = globES.data.pos;
edges = globES.data.edges;
rads = globES.data.rads;

L = size(pos,1);
n = globES.branch.nodes;
nL = size(n,1);

difY = pos(:,1) - n(:,1)';
difX = pos(:,2) - n(:,2)';
difZ = pos(:,3) - n(:,3)';

difA = (difY==0) & (difX == 0) & (difZ == 0);
[sID bID] = find(difA);
changeID = setdiff([1:nL],bID);
newID = [1:length(changeID)]+L;
branchID = zeros(1,nL);
branchID(changeID) = newID;
branchID(bID) = sID;

pos(newID,:) = n(changeID,:);
rads(newID) = globES.branch.rads(changeID);
newEdges = [branchID(1:end-1)' branchID(2:end)'];
edges = cat(1,edges,newEdges);

globES.data.pos = pos;
globES.data.edges = edges;
globES.data.rads = rads;


showEdges
showScatterSkel

globES.branch.nodes = [];
globES.branch.rads = [];
globES.branch.on = 0;
globES.pick.edgeID = [];
globES.pick.nodeID = [];

showBranch


% --- Executes on button press in clear_pushbutton.
function clear_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clear_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global globES

globES.branch.nodes = [];
globES.branch.rads = [];
globES.branch.on = 0;

showBranch


% --- Executes on button press in radius_togglebutton.
function radius_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to radius_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radius_togglebutton

global globES

val = get(hObject,'Value');

try delete(globES.p.rad), end

if val
    showRad
end

function showRad

global globES

try delete(globES.p.rad), end

posR = globES.data.pos;
edgeR = globES.data.edges;
radR = globES.data.rads;
nodeNum = length(radR);
nodeColR = ones(nodeNum,3);
alph = .4;

[fvRad globES.p.rad] = showRadSurf_cn(posR(:,[2 1 3]),edgeR,radR,[1 0 0],alph,globES.h.figure1);



function[nep] =  makeNep

global globES

seedPos = globES.data.seedPos;
edges = globES.data.edges;
nodes = globES.data.pos; % will go wrong if gaps
rads = globES.data.rads;

nodePos = globES.data.pos;
dists = getDist(nodePos,seedPos);

clear nep
nep.seedNode = find(dists==min(dists));
nep.pos = nodePos;
nep.nodes = [1:size(nodePos,1)];
nep.edges = edges;
nep.edgeRad  = mean(rads(edges),2);
nep.nodeRad = rads;

nep = groupNepEdges(nep);
%showRadSurf(nep.pos,nep.edges, nep.nodeRad)

nep = edgeGroup2bones(nep);
nep = smoothRad(nep,.2);
nep.fv = globES.data.fv;
nep.props = getNepProps(nep);
nep.autoNep = globES.data.autoNep;
globES.data.currentNep = nep;

%
% showRadSurf(nep.pos,nep.edges, nep.meanNodeRad * 0 + .01, [ 0 1 0],1)
%
% v = nep.fv.vertices;
% scatter3(v(:,1),v(:,2),v(:,3),'.')
%
% nep.fv = arbor.vox.fv;
% nep.fv.vertices = nep.fv.vertices * arbor.voxSize(1);
%
% clf
% renderFV(nep.fv,[1 0 0],.2)
% %showRadSurf(nep.pos,nep.edges, nep.nodeRad,[0 1 0],.4)
% showRadSurf(nep.pos,nep.edges, nep.meanNodeRad, [ 0 0 1],.2)
% showRadSurf(nep.pos,nep.edges, nep.meanNodeRad * 0 + .01, [ 0 1 0],1)


% --- Executes on button press in togglebutton_showSurfacePlus.
function togglebutton_showSurfacePlus_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_showSurfacePlus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_showSurfacePlus
global globES


if isfield(globES.p,'volPatch')
    globES.view.surfAlph = min(1,globES.view.surfAlph +.1);
    globES.p.volPatch.FaceAlpha = globES.view.surfAlph ;
end

% --- Executes on button press in togglebutton_showSurfaceMinus.
function togglebutton_showSurfaceMinus_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_showSurfaceMinus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_showSurfaceMinus
global globES

if isfield(globES.p,'volPatch')
    globES.view.surfAlph = max(0,globES.view.surfAlph - .1);
    globES.p.volPatch.FaceAlpha = globES.view.surfAlph ;
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton_showSurface.
function togglebutton_showSurface_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_showSurface (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_showSurface
global globES

val = get(hObject,'Value');
if isfield(globES.p,'volPatch')
    if val
        globES.p.volPatch.Visible = 'on';
    else
        globES.p.volPatch.Visible = 'off';
    end
end


% --- Executes on button press in togglebutton_showRadiusPlus.
function togglebutton_showRadiusPlus_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_showRadiusPlus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_showRadiusPlus

global globES


try val = globES.p.rad.FaceAlpha;
catch
    showRad;
    globES.p.rad.FaceAlpha = 0;
    val = globES.p.rad.FaceAlpha;
end
val = min(1,val+.1);
globES.p.rad.FaceAlpha = val;
set(handles.radius_togglebutton,'Value',1)




% --- Executes on button press in togglebutton_showRadiusMinus.
function togglebutton_showRadiusMinus_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_showRadiusMinus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_showRadiusMinus

global globES

if isfield(globES.p,'rad')
    val = globES.p.rad.FaceAlpha;
    val = max(0,val-.1);
    
    globES.p.rad.FaceAlpha = val;
end


% --- Executes on button press in pushbutton_clear.
function pushbutton_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clearAxis

function clearAxis

global globES

p = fields(globES.p);
for i = 1:length(p)
    try
        eval(sprintf('globES.p.%s.delete;',p{i}));
        globES.p = rmfield(globES.p,p{i});
    end
end


% --- Executes on button press in togglebutton12.
function togglebutton12_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton12


% --- Executes on button press in togglebutton13.
function togglebutton13_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton13


% --- Executes on button press in togglebutton_showEdges.
function togglebutton_showEdges_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_showEdges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_showEdges

global globES

val = get(hObject,'Value');

try globES.p.plotSkel.delete;end
if val
    showEdges
end


% --- Executes on button press in togglebutton15.
function togglebutton15_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton15


% --- Executes on button press in togglebutton16.
function togglebutton16_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton16


% --- Executes on button press in togglebutton_showNodes.
function togglebutton_showNodes_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_showNodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_showNodes

global globES

val = get(hObject,'Value');

try globES.p.scatterSkel.delete;end
if val
    showScatterSkel
end


% --- Executes on button press in togglebutton18.
function togglebutton18_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton18


% --- Executes on button press in togglebutton19.
function togglebutton19_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton19


% --- Executes on button press in togglebutton_showVerts.
function togglebutton_showVerts_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_showVerts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_showVerts

global globES

val = get(hObject,'Value');

if val
    globES.p.vert.MarkerFaceAlpha = .6;
else
    globES.p.vert.MarkerFaceAlpha = 0;
end



% --- Executes during object creation, after setting all properties.
function Xmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes during object creation, after setting all properties.
function Xmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end





% --- Executes during object creation, after setting all properties.
function Ymin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Xmin_Callback(hObject, eventdata, handles)

global globES

val = get(hObject,'Value');

globES.view.window(1,3) = globES.view.cellRange(1,3) + ...
    diff(globES.view.cellRange(:,3)) * val;

%Fix opposite slider
val2 = get(handles.Xmax,'Value');
if val2<val
    set(handles.Xmax,'Value',val)
    globES.view.window(2,3) =globES.view.cellRange(1,3) + ...
        diff(globES.view.cellRange(:,3)) * val;
end


showWindow

% --- Executes on slider movement.
function Xmax_Callback(hObject, eventdata, handles)

global globES

val = get(hObject,'Value');
globES.view.window(2,3) = globES.view.cellRange(1,3) + ...
    diff(globES.view.cellRange(:,3)) * val;

%Fix opposite slider
val2 = get(handles.Xmin,'Value');
if val2>val
    set(handles.Xmin,'Value',val)
    globES.view.window(1,3) =globES.view.cellRange(1,3) + ...
        diff(globES.view.cellRange(:,3)) * val;
end


showWindow

% --- Executes on slider movement.
function Ymin_Callback(hObject, eventdata, handles)
global globES

val = get(hObject,'Value');
globES.view.window(1,1) =globES.view.cellRange(1,1) + ...
    diff(globES.view.cellRange(:,1)) * val;

%Fix opposite slider
val2 = get(handles.Ymax,'Value');
if val2<val
    set(handles.Ymax,'Value',val)
    globES.view.window(2,1) =globES.view.cellRange(1,1) + ...
        diff(globES.view.cellRange(:,1)) * val;
end

showWindow

% --- Executes on slider movement.
function Ymax_Callback(hObject, eventdata, handles)
global globES

val = get(hObject,'Value');
globES.view.window(2,1) =globES.view.cellRange(1,1) + ...
    diff(globES.view.cellRange(:,1)) * val;

%Fix opposite slider
val2 = get(handles.Ymin,'Value');
if val2>val
    set(handles.Ymin,'Value',val)
    globES.view.window(1,1) =globES.view.cellRange(1,1) + ...
        diff(globES.view.cellRange(:,1)) * val;
end



showWindow

% --- Executes on slider movement.
function Zmax_Callback(hObject, eventdata, handles)
global globES

val = get(hObject,'Value');
globES.view.window(2,2) = globES.view.cellRange(1,2) + ...
    diff(globES.view.cellRange(:,2)) * val;


%Fix opposite slider
val2 = get(handles.Zmin,'Value');
if val2>val
    set(handles.Zmin,'Value',val)
    globES.view.window(1,2) =globES.view.cellRange(1,2) + ...
        diff(globES.view.cellRange(:,2)) * val;
end


showWindow


% --- Executes on slider movement.
function Zmin_Callback(hObject, eventdata, handles)
global globES

val = get(hObject,'Value');
globES.view.window(1,2) = globES.view.cellRange(1,2) + ...
    diff(globES.view.cellRange(:,2)) * val;

%Fix opposite slider
val2 = get(handles.Zmax,'Value');
if val2<val
    set(handles.Zmax,'Value',val)
    globES.view.window(2,2) =globES.view.cellRange(1,2) + ...
        diff(globES.view.cellRange(:,2)) * val;
end
showWindow


% --- Executes during object creation, after setting all properties.
function Ymax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function Zmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function Zmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in togglebutton_window.
function togglebutton_window_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_window

global globES
h = handles;

val = get(hObject,'Value')

if val
    set(h.uipanel5,'Visible','on')
    set(h.Ymin,'Visible','on')
    set(h.Xmin,'Visible','on')
    set(h.Zmin,'Visible','on')
    set(h.Ymax,'Visible','on')
    set(h.Xmax,'Visible','on')
    set(h.Zmax,'Visible','on')
else
    set(h.uipanel5,'Visible','off')
    set(h.Ymin,'Visible','off')
    set(h.Xmin,'Visible','off')
    set(h.Zmin,'Visible','off')
    set(h.Ymax,'Visible','off')
    set(h.Xmax,'Visible','off')
    set(h.Zmax,'Visible','off')
end





% --- Executes on button press in pushbutton_highlight.
function pushbutton_highlight_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_highlight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbutton_highlight


% --- Executes on button press in pushbutton_clip.
function pushbutton_clip_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbutton_clip

global globES

globES.view.clip = 1;

showEdges
showScatterSkel
showVerts
pause(.01)

%hide surface
pos = globES.p.volPatch.Vertices;
[isPos isEdge] = winFilt(globES.view.window,pos(:,[2 1 3])); %!dim

globES.p.volPatch.AlphaDataMapping = 'none';
globES.p.volPatch.FaceAlpha = 'flat';
vAlph = ones(size(globES.p.volPatch.Vertices,1),1) * globES.view.surfAlph;
vAlph(~isPos) = 0.04;
globES.p.volPatch.FaceVertexAlphaData = vAlph;
set(globES.p.win,'Visible','Off')
set(globES.h.togglebutton_hideWin,'Value',0);

% --- Executes on button press in pushbutton_center.
function pushbutton_center_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_center (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbutton_center
global globES

val = get(hObject,'Value');

if val
    deselectToggleUI(handles, hObject)
    try delete(findall(handles.figure1,'Type','hggroup')); end
    globES.dcm = datacursormode(handles.figure1);
    globES.dcm.UpdateFcn = @pickWindowCenter;
    
    set(globES.dcm,'DisplayStyle','window',...
        'SnapToDataVertex','off','Enable','on')
else
    rotate3d(handles.figure1)
    delete(findall(handles.figure1,'Type','hggroup'))
end


function txt = pickWindowCenter(~,info)
global globES
X = info.Position(2);
Y = info.Position(1);
Z = info.Position(3);
%c_info = getCursorInfo(glob.dcm)

str = sprintf('X = %0.1f, Y = %0.1f, Z = %0.1f',X,Y,Z);

set(globES.h.textOut,'String',str);
tag = get(info.Target,'Tag');

txt = str;

rad = globES.view.winWidth/2;

globES.view.window = [Y-rad X-rad Z-rad; Y+rad X+rad Z+rad]; %!dim
if globES.h.togglebutton_hideWin.Value
    showWindow
end

if 1 % Move to origin
    X = info.Position(1);%!dim
    Y = info.Position(2);
    Z = info.Position(3);
    %c_info = getCursorInfo(glob.dcm)
    
    [a b] = view;
    yl = get(globES.h.mainAx,'YLim');
    xl = get(globES.h.mainAx,'XLim');
    zl = get(globES.h.mainAx,'ZLim');
    yr = diff(yl)/2;
    xr = diff(xl)/2;
    zr = diff(zl)/2;
    set(globES.h.mainAx,'XLim',[X-xr X+xr],...
        'YLim',[Y-yr Y+yr],'ZLim',[Z-zr Z+zr]);
    view([a b]);
end

updateCenter %%Show clipped

function updateCenter
global globES

set(globES.h.pushbutton_center,'Value',0)
try delete(findall(globES.h.figure1,'Type','hggroup')); end

if 1 % do clip
    %pushbutton_clip_Callback
    
    showEdges
    showScatterSkel
    showVerts
    pause(.01)
    
    %hide surface
    pos = globES.p.volPatch.Vertices;
    [isPos isEdge] = winFilt(globES.view.window,pos(:,[2 1 3])); %!dim
    
    globES.p.volPatch.AlphaDataMapping = 'none';
    globES.p.volPatch.FaceAlpha = 'flat';
    vAlph = ones(size(globES.p.volPatch.Vertices,1),1) * globES.view.surfAlph;
    vAlph(~isPos) = 0.04;
    globES.p.volPatch.FaceVertexAlphaData = vAlph;
    pause(.01)
end

% --- Executes on button press in togglebutton_hideWin.
function togglebutton_hideWin_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_hideWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_hideWin

global globES

val = get(hObject,'Value');
if val
    showWindow;
else
    try delete(globES.p.win);end
end

function edit_winSize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_winSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_winSize as text
%        str2double(get(hObject,'String')) returns contents of edit_winSize as a double
global globES

str = get(hObject,'String');
num = str2num(str);
if ~isempty(num)
    globES.view.winWidth = num;
end

% --- Executes during object creation, after setting all properties.
function edit_winSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_winSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton_XYZ.
function togglebutton_XYZ_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_XYZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_XYZ

global globES

val = get(hObject,'Value');

% try
%     glob.dcm.Enable = 'off'
%     %glob.dcm.delete
% end

if val
    deselectToggleUI(handles, hObject)
    globES.dcm = datacursormode(handles.figure1);
    globES.dcm.UpdateFcn = @displayCoordinates;
    
    set(globES.dcm,'DisplayStyle','datatip',...
        'SnapToDataVertex','off','Enable','on')
else
    rotate3d(handles.figure1)
    delete(findall(handles.figure1,'Type','hggroup'))
end


function txt = displayCoordinates(~,info)
global glob globES
X = info.Position(2);%!dim
Y = info.Position(1);
Z = info.Position(3);
%c_info = getCursorInfo(glob.dcm)

anc2sub = (glob.em.res/ 1000);

umPos = [X Y Z] ;
umPosStr = sprintf('%.0f  %.0f  %.0f',umPos(end,2),umPos(end,1),umPos(end,3));
disp(umPos)

VASTpos = round([Y X Z] ./ anc2sub);
VASTposStr = sprintf('%.0f \r%.0f \r%.0f um',umPos(end,2),umPos(end,1),umPos(end,3));

set(globES.h.textOut,'String',VASTpos);
tag = get(info.Target,'Tag');

txt = umPosStr;

clipboard('copy',VASTpos)


% --- Executes on button press in pushbutton_YZ.
function pushbutton_YZ_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_YZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

view([90 1])

% --- Executes on button press in pushbutton_XZ.
function pushbutton_XZ_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_XZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

view([0 0 ])

% --- Executes on button press in pushbutton_XY.
function pushbutton_XY_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_XY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

view([0 270])


% --- Executes on button press in togglebutton_Reset.
function togglebutton_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global globES

globES.view.window = globES.view.cellRange;
showWindow
pushbutton_clip_Callback(hObject,eventdata)

% --- Executes on button press in pushbutton_origin.
function pushbutton_origin_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_origin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global globES

val = get(hObject,'Value');
if val
    try delete(globES.p.win);end
    set(globES.h.togglebutton_hideWin,'Value',0);
    deselectToggleUI(handles, hObject)
    globES.dcm = datacursormode(handles.figure1);
    globES.dcm.UpdateFcn = @setOrigin;
    
    set(globES.dcm,'DisplayStyle','datatip',...
        'SnapToDataVertex','off','Enable','on')
else
    rotate3d(handles.figure1)
    delete(findall(handles.figure1,'Type','hggroup'))
end

pause(.01)


function txt =  setOrigin(~,info)

global globES
X = info.Position(1);%!dim
Y = info.Position(2);
Z = info.Position(3);
%c_info = getCursorInfo(glob.dcm)

[a b] = view;
yl = get(globES.h.mainAx,'YLim');
xl = get(globES.h.mainAx,'XLim');
zl = get(globES.h.mainAx,'ZLim');
yr = diff(yl)/2;
xr = diff(xl)/2;
zr = diff(zl)/2;
set(globES.h.mainAx,'XLim',[X-xr X+xr],...
    'YLim',[Y-yr Y+yr],'ZLim',[Z-zr Z+zr]);
view([a b]);
txt = 'origin'


% --- Executes on button press in togglebutton_show.
function togglebutton_show_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_show
val = get(hObject,'Value')
if val
    set(handles.show_uipanel,'Visible','On')
else
    set(handles.show_uipanel,'Visible','Off')
end

% --- Executes on button press in togglebutton_edit.
function togglebutton_edit_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_edit

val = get(hObject,'Value');
if val
    set(handles.brushPanel,'Visible','Off')
    set(handles.remove_pushbutton,'Visible','Off')
    set(handles.Branch_uibuttongroup,'Visible','Off')
    set(handles.uipanel_pick,'Visible','Off')
else
    set(handles.brushPanel,'Visible','On')
    set(handles.remove_pushbutton,'Visible','On')
    set(handles.Branch_uibuttongroup,'Visible','On')
    set(handles.uipanel_pick,'Visible','On')
end



% --- Executes on button press in togglebutton_Files.
function togglebutton_Files_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_Files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_Files


val = get(hObject,'Value');
if val
    set(handles.uipanel_file,'Visible','On');
else
    set(handles.uipanel_file,'Visible','Off');
end


% --- Executes on button press in pushbutton_folder.
function pushbutton_folder_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global globES

globES.f.saveDir = uigetdir(globES.f.saveDir);



function edit_saveFolder_Callback(hObject, eventdata, handles)
% hObject    handle to edit_saveFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_saveFolder as text
%        str2double(get(hObject,'String')) returns contents of edit_saveFolder as a double


% --- Executes during object creation, after setting all properties.
function edit_saveFolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_saveFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_saveName_Callback(hObject, eventdata, handles)
% hObject    handle to edit_saveName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_saveName as text
%        str2double(get(hObject,'String')) returns contents of edit_saveName as a double
global globES

globES.f.saveName = get(hObject,'String')


% --- Executes during object creation, after setting all properties.
function edit_saveName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_saveName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_makeSM.
function pushbutton_makeSM_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_makeSM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob globES

set(handles.textOut,'String',sprintf('Skeletonizing cell %d',globES.pickCID))
tempFig = figure;

makeVolMPNcnv

sm = makeSM(globES.pickCID);

load('MPN.mat')
smDir = [WPN 'SMs\'];
libDir = [WPN 'fvLibrary\'];
dSMs = dir([smDir '*.mat']);
nams = { dSMs.name};

%showNepBones(sm.nep);
%showRadSurf(sm.nep.pos,sm.nep.edges,sm.nep.nodeRad,[0 1 0],.4)
if isfield(sm,'nep')
    if ~isempty(sm.nep)
        fv = showRadSurf_cnv(sm.nep.pos,sm.nep.edges,sm.nep.nodeRad*0+.1,[1 1 1],1,tempFig);
        pause(.01)
        filename = sprintf('%sskelFV_%d.mat',libDir,sm.cid);
        save(filename,'fv')
        
        filename = sprintf('%snep_%d.mat',libDir,sm.cid);
        nep = sm.nep;
        save(filename,'nep')
    end
end
close(tempFig)

loadCID

set(handles.textOut,'String',sprintf('Finished skeletonizing cell %d',globES.pickCID))


% --- Executes on button press in pushbutton_loadCustom.
function pushbutton_loadCustom_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadCustom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob globES

set(handles.textOut,'String','Loading')
[TFN TPN] = uigetfile(globES.f.saveDir);
loadCID([TPN '/' TFN])
set(handles.edit_saveName,'String',TFN);
set(handles.textOut,'String',sprintf('Finished loading %s',TFN))



% --- Executes on button press in pushbutton_saveToLibrary.
function pushbutton_saveToLibrary_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_saveToLibrary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global glob globES

set(handles.textOut,'String','Saving')
nep = makeNep;
fileName = sprintf('%snep_%d.mat',globES.f.useFvDir,globES.pickCID);
save(fileName,'nep');
set(handles.textOut,'String',sprintf('Finished saving %s',fileName))



% --- Executes on button press in pushbutton_saveCustom.
function pushbutton_saveCustom_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_saveCustom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob globES

set(handles.textOut,'String','Saving')
fileName = sprintf('%s%s.mat',globES.f.saveDir,globES.f.saveName);
nep = makeNep;
save(fileName,'nep')
set(handles.textOut,'String',sprintf('Finished saving %s',fileName))


% --- Executes on button press in togglebutton_nodes.
function togglebutton_nodes_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_nodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_nodes

global globES

try delete(globES.p.goToNode); end
val = get(hObject,'Value');

if val
    set(globES.h.uipanel_nodes,'Visible','On')
else
    set(globES.h.uipanel_nodes,'Visible','Off')
    try delete(globES.p.goToNode); catch, end
    try delete(globES.p.goToEdge); catch, end
end




function edit_nodes_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nodes as text
%        str2double(get(hObject,'String')) returns contents of edit_nodes as a double

global globES

str = get(hObject,'String');
num = str2num(str);

if ~isempty(num)
    
    if num<1
        num = 1;
    elseif num > globES.view.pickNumMax
        num = globES.view.pickNumMax;
    end
    globES.view.pickNum = num;
    goToNode(num)
else
    set(hObject,'String','Must be number')
    pause(1)
    set(hObject,'String','')
end


function goToNode(num)
global globES

if globES.view.showOriginal
    nep = globES.data.autoNep;
else
    nep = globES.data.currentNep;
end

nodes = unique(nep.bones(num).edges(:));
pos = nep.pos(nodes,:);
edges = nep.bones(num).edges;

meanPos = mean(pos,1);

ePos1 = nep.pos(edges(:,1),:);
ePos2 = nep.pos(edges(:,2),:);

X = meanPos(2);%!dim
Y = meanPos(1);
Z = meanPos(3);
%c_info = getCursorInfo(glob.dcm)

[a b] = view;
yl = get(globES.h.mainAx,'YLim');
xl = get(globES.h.mainAx,'XLim');
zl = get(globES.h.mainAx,'ZLim');
yr = diff(yl)/2;
xr = diff(xl)/2;
zr = diff(zl)/2;
set(globES.h.mainAx,'XLim',[X-xr X+xr],...
    'YLim',[Y-yr Y+yr],'ZLim',[Z-zr Z+zr]);
view([a b]);

try delete(globES.p.goToNode); catch, end
globES.p.goToNode = scatter3(pos(:,2),pos(:,1),pos(:,3),50,...
    'o','markeredgecolor',[1 .4 0],'markerfacealpha',0,'linewidth',2);

try delete(globES.p.goToEdge); catch, end
globES.p.goToEdge = plot3([ePos1(:,2) ePos2(:,2)]',...
    [ePos1(:,1) ePos2(:,1)]',[ePos1(:,3) ePos2(:,3)]',...
    'color',[1 .5 0],'linewidth',2);


function goToNode2(num)

global globES

pos = globES.data.pos(num,:);

X = pos(2);%!dim
Y = pos(1);
Z = pos(3);
%c_info = getCursorInfo(glob.dcm)

[a b] = view;
yl = get(globES.h.mainAx,'YLim');
xl = get(globES.h.mainAx,'XLim');
zl = get(globES.h.mainAx,'ZLim');
yr = diff(yl)/2;
xr = diff(xl)/2;
zr = diff(zl)/2;
set(globES.h.mainAx,'XLim',[X-xr X+xr],...
    'YLim',[Y-yr Y+yr],'ZLim',[Z-zr Z+zr]);
view([a b]);

try delete(globES.p.goToNode); end
%globES.p.goToNode = scatter3(X,Y,Z,300,'r','o','filled','markerfacealpha',.3)
globES.p.goToNode = scatter3(X,Y,Z,700,'r','o','markerfacealpha',0)


% --- Executes during object creation, after setting all properties.
function edit_nodes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_nodeUp.
function pushbutton_nodeUp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_nodeUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbutton_nodeUp
global globES

num = globES.view.pickNum + 1;

if num<1
    num = 1;
elseif num > globES.view.pickNumMax
    num = globES.view.pickNumMax;
end
goToNode(num)
globES.view.pickNum = num;
set(globES.h.edit_nodes,'String',num2str(num));


% --- Executes on button press in pushbutton_nodeDown.
function pushbutton_nodeDown_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_nodeDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbutton_nodeDown
global globES

num = globES.view.pickNum - 1;

if num<1
    num = 1;
elseif num > globES.view.pickNumMax
    num = globES.view.pickNumMax;
end
goToNode(num)
globES.view.pickNum = num;
set(globES.h.edit_nodes,'String',num2str(num));


% --- Executes on button press in togglebutton_clearPick.
function togglebutton_clearPick_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_clearPick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_clearPick

global globES

globES.pick.edgeID = [];
globES.pick.edgePos = [];
globES.pick.nodeID = [];
globES.pick.nodePos = [];
info.Target.Tag = 'clear';
pickEdge('none',info)


% --- Executes on button press in togglebutton_nepOriginal.
function togglebutton_nepOriginal_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_nepOriginal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_nepOriginal

global globES

val = get(hObject,'Value');
if val
    globES.view.showOriginal = 1;
else
    globES.view.showOriginal = 0;
    
end
