function varargout = GraphPointToPoint(varargin)
% GRAPHPOINTTOPOINT MATLAB code for GraphPointToPoint.fig
%      GRAPHPOINTTOPOINT, by itself, creates a new GRAPHPOINTTOPOINT or raises the existing
%      singleton*.
%
%      H = GRAPHPOINTTOPOINT returns the handle to a new GRAPHPOINTTOPOINT or the handle to
%      the existing singleton*.
%
%      GRAPHPOINTTOPOINT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRAPHPOINTTOPOINT.M with the given input arguments.
%
%      GRAPHPOINTTOPOINT('Property','Value',...) creates a new GRAPHPOINTTOPOINT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GraphPointToPoint_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GraphPointToPoint_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GraphPointToPoint

% Last Modified by GUIDE v2.5 04-Jul-2020 12:44:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GraphPointToPoint_OpeningFcn, ...
                   'gui_OutputFcn',  @GraphPointToPoint_OutputFcn, ...
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


% --- Executes just before GraphPointToPoint is made visible.
function GraphPointToPoint_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GraphPointToPoint (see VARARGIN)

% Choose default command line output for GraphPointToPoint
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GraphPointToPoint wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global glob globSM


globSM.h = handles;

IN.num = 0;
OUT.num = 0;
OUT.editPts = [];
IN.editPts = [];
globSM.IN = IN;
globSM.OUT = OUT;


strs = get(handles.popupmenu_pickFunction,'String');
globSM.dFunc = strs{1};

updateSMfig




% --- Outputs from this function are returned to the command line.
function varargout = GraphPointToPoint_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_customOUT_Callback(hObject, eventdata, handles)
% hObject    handle to edit_customOUT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_customOUT as text
%        str2double(get(hObject,'String')) returns contents of edit_customOUT as a double


% --- Executes during object creation, after setting all properties.
function edit_customOUT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_customOUT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_makeAllSM.
function pushbutton_makeAllSM_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_makeAllSM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


globSM.figH = figure
runAllSM
close(globSM.figH)

edit_selectCell_Callback(handles.selectCell, [], handles)


% --- Executes on button press in pushbutton_makeSM.
function pushbutton_makeSM_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_makeSM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global glob globSM

globSM.figH = figure;
makeSM(globSM.pickCID)
pause(.01)
close(globSM.figH) 

updateSMfig



function edit_selectCell_Callback(hObject, eventdata, handles)
% hObject    handle to edit_selectCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_selectCell as text
%        str2double(get(hObject,'String')) returns contents of edit_selectCell as a double

global glob globSM

str = get(hObject,'String');
cid = str2num(str);
if ~isempty(cid)
       globSM.pickCID = cid;
end

updateSMfig



% --- Executes during object creation, after setting all properties.
function edit_selectCell_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_selectCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


global glob globSM

globSM.pickCID = glob.pickCID;
set(hObject,'String',num2str(globSM.pickCID));



% --- Executes on selection change in popupmenu_volume.
function popupmenu_volume_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_volume contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_volume


global glob globSM

strs = get(hObject,'String');
val = get(hObject,'Value');
str = strs{val};
globSM.vol = str;
glob.NA.MPN = [glob.dir.Volumes str '\Merge\'];
makeMPNcnv





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

global glob globSM

set(hObject,'String',glob.vol.names);
set(hObject,'Value',1);

globSM.vol = glob.vol.names{1};
glob.NA.MPN = [glob.dir.Volumes globSM.vol '\Merge\'];
makeMPNcnv



function cellText_Callback(hObject, eventdata, handles)
% hObject    handle to cellText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cellText as text
%        str2double(get(hObject,'String')) returns contents of cellText as a double


% --- Executes during object creation, after setting all properties.
function cellText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cellText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function textOut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_dFunc_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dFunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dFunc as text
%        str2double(get(hObject,'String')) returns contents of edit_dFunc as a double

global globSM

str = get(hObject,'String');
globSM.dFunc = str;


% --- Executes during object creation, after setting all properties.
function edit_dFunc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dFunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_pickFunction.
function popupmenu_pickFunction_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_pickFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_pickFunction contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_pickFunction

global globSM

strs = get(hObject,'String');
val = get(hObject,'Value');
str = strs{val};

globSM.dFunc = str;
updateSMfig


% --- Executes during object creation, after setting all properties.
function popupmenu_pickFunction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_pickFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

str = {'w = 1','w = d','w = 1./(1+d)', 'w = 1./(1+d^2)','fixed radius length constant'}
set(hObject,'String',str)



% --- Executes on button press in pushbutton_applyFunction.
function pushbutton_applyFunction_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_applyFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob globSM


if globSM.IN.num & globSM.OUT.num
    set(handles.textOut,'BackgroundColor',[.7 1 .7])
    set(handles.textOut,'String','Analyzing point lists');
    pause(.01)
    globSM.ptp = smPt2Pt;
    set(handles.textOut,'BackgroundColor',[1 1 1])
    set(handles.textOut,'String','Finished point Lists');
else
    set(handles.textOut,'BackgroundColor',[1 .7 .7])
     set(handles.textOut,'String','Did not find in and out point lists');
    pause(1)
    set(handles.textOut,'BackgroundColor',[1 1 1])
end

get(handles.edit_dFunc,'backgroundcolor')
updateGraphs;


function updateGraphs

global globSM

handles = globSM.h;

if isfield(globSM,'ptp')
ptp = globSM.ptp;

gIN = get(handles.togglebutton_groupIN,'Value');
gOUT = get(handles.togglebutton_groupOUT,'Value');

nIN = get(handles.togglebutton_normalizeIN,'Value');
nOUT = get(handles.togglebutton_normalizeOUT,'Value');

%%Assign groups to graph positions
for i = 1:length(ptp.indIN)
    for p = 1:length(ptp.indIN{i})
        rowG{ptp.indIN{i}(p)} = sprintf('%d.%d',i,p);
    end
end
for i = 1:length(ptp.indOUT)
    for p = 1:length(ptp.indOUT{i})
        colG{ptp.indOUT{i}(p)} = sprintf('%d.%d',i,p);
    end
end
colG2 = [1:length(ptp.indOUT)];
rowG2 = [1:length(ptp.indIN)];

if gIN & gOUT  %% select grouping or not
    con = ptp.conG;
    colG = colG2;
    rowG = rowG2;
elseif gIN
    con = ptp.conGin;
    rowG = rowG2;
elseif gOUT
    con = ptp.conGout;
    colG = colG2;    
else
    con = ptp.con;     
end

if nIN & nOUT  %% select grouping or not
    con = con./ sum(con(:));
elseif nIN
    con = con./ repmat(sum(con,2),[1 size(con,2)]);
elseif nOUT
    con = con./ repmat(sum(con,1),[size(con,1) 1]);
else
    con = con;
end

set(globSM.h.uitable_con,'Data',con)
set(globSM.h.uitable_con,'RowName',rowG);
set(globSM.h.uitable_con,'ColumnName',colG);

showCon = con;
colormap(globSM.h.axes1,jet(256))
showCon = showCon*255/max(showCon(:));
image(globSM.h.axes1,showCon)
% set(globSM.h.axes1,'Xticklabel',colG)
% set(globSM.h.axes1,'Yticklabel',rowG)
end



% --- Executes on selection change in popupmenu_addSynGroupIN.
function popupmenu_addSynGroupIN_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_addSynGroupIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_addSynGroupIN contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_addSynGroupIN

global glob globSM

strs = get(hObject,'String');
val = get(hObject,'Value');
str = strs{val};

globSM.IN.num = globSM.IN.num + 1;
g.dat = glob.syn.g(val);
g.type = 'synGroup';
globSM.IN.g(globSM.IN.num) = g;
updateSMfig


% --- Executes during object creation, after setting all properties.
function popupmenu_addSynGroupIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_addSynGroupIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function textOut_DeleteFcn(hObject, eventdata, handles)
    'bye'


function updateSMfig
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global glob globSM

h = globSM.h;

%%update cell dir
globSM.smDir = [glob.dir.Volumes globSM.vol '\Analysis\SMs\'];
fileName = sprintf('sm_cid%d.mat',globSM.pickCID);
globSM.smFileName = fileName;
if exist([globSM.smDir globSM.smFileName],'file')
    str = 'Analysis SM file found';
else
    str = 'No anslysis SM file found';
end
set(h.cellText,'String',str);


%%update synList
str = {glob.syn.g.name};
set(h.popupmenu_addSynGroupIN,'String',str);
set(h.popupmenu_addSynGroupOUT,'String',str);

%%update point groups
if globSM.IN.num
        for n = 1:globSM.IN.num
    INnames{n} = globSM.IN.g(n).dat.name;
        end
else
    INnames = {};
end

set(h.listbox_inGroups,'String',INnames);
set(h.listbox_inGroups,'Value',1);

if globSM.OUT.num
    for n = 1:globSM.OUT.num
        OUTnames{n} = globSM.OUT.g(n).dat.name;
    end
else
    OUTnames = {};
end
set(h.listbox_outGroups,'String',OUTnames);
set(h.listbox_outGroups,'Value',1);


%%Custom pts
strs = num2str(globSM.OUT.editPts,'%0.2f ');
set(globSM.h.edit_customOUT,'String',strs);

strs = num2str(globSM.IN.editPts,'%0.2f ');
set(globSM.h.edit_customIN,'String',strs);

%%Distance Function

set(h.edit_dFunc,'String',globSM.dFunc)

updateGraphs

% --- Executes on selection change in listbox_outGroups.
function listbox_outGroups_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_outGroups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_outGroups contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_outGroups

global globSM

val = get(hObject,'Value');

keep = setdiff([1:globSM.OUT.num],val);
globSM.OUT.g = globSM.OUT.g(keep);
globSM.OUT.num = length(globSM.OUT.g);
updateSMfig




% --- Executes during object creation, after setting all properties.
function listbox_outGroups_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_outGroups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_addSynGroupOUT.
function popupmenu_addSynGroupOUT_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_addSynGroupOUT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_addSynGroupOUT contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_addSynGroupOUT



global glob globSM

strs = get(hObject,'String');
val = get(hObject,'Value');
str = strs{val};

globSM.OUT.num = globSM.OUT.num + 1;
g.dat = glob.syn.g(val);
g.type = 'synGroup';
globSM.OUT.g(globSM.OUT.num) = g;
updateSMfig

% --- Executes during object creation, after setting all properties.
function popupmenu_addSynGroupOUT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_addSynGroupOUT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_inGroups.
function listbox_inGroups_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_inGroups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_inGroups contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_inGroups

global globSM

val = get(hObject,'Value');

keep = setdiff([1:globSM.IN.num],val);

globSM.IN.g = globSM.IN.g(keep);
globSM.IN.num = length(globSM.IN.g);

set(hObject,'Value',1)
updateSMfig

% --- Executes during object creation, after setting all properties.
function listbox_inGroups_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_inGroups (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_customIN_Callback(hObject, eventdata, handles)
% hObject    handle to edit_customIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_customIN as text
%        str2double(get(hObject,'String')) returns contents of edit_customIN as a double


% --- Executes during object creation, after setting all properties.
function edit_customIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_customIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton_allowNonCell.
function togglebutton_allowNonCell_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_allowNonCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_allowNonCell


% --- Executes on button press in pushbutton_addCellBody.
function pushbutton_addCellBody_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_addCellBody (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_addFullArbor.
function pushbutton_addFullArbor_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_addFullArbor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in togglebutton_getProbePoints.
function togglebutton_getProbePoints_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_getProbePoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_getProbePoints
global glob globSM

val = get(hObject,'Value');

% try
%     glob.dcm.Enable = 'off'
%     %glob.dcm.delete
% end

if val
    deselectToggleUI(handles, hObject)
    glob.dcm = datacursormode(glob.handles.figure1);
    glob.dcm.UpdateFcn = @displayCoordinates;
    
    set(glob.dcm,'DisplayStyle','datatip',...
        'SnapToDataVertex','off','Enable','on')
else
    rotate3d(glob.handles.figure1)
    delete(findall(glob.handles.figure1,'Type','hggroup'))
end


function txt = displayCoordinates(~,info)
global glob globSM

X = info.Position(2);
Y = info.Position(1);
Z = info.Position(3);
%c_info = getCursorInfo(glob.dcm)

anc2sub = (glob.em.res/ 1000)./ glob.em.dsRes;
allPos2 = [X Y Z] ./ anc2sub;
VASTpos = sprintf('%.0f  %.0f  %.0f',allPos2(end,2),allPos2(end,1),allPos2(end,3));
disp(VASTpos)

anc2um =  1./ glob.em.dsRes;
umPos = [X Y Z] ;
umPosStr = sprintf('%.0f \r%.0f \r%.0f um',umPos(end,2),umPos(end,1),umPos(end,3));

set(globSM.h.textOut,'String',VASTpos);
tag = get(info.Target,'Tag');

txt = umPosStr;

clipboard('copy',umPos)

globSM.OUT.editPts = cat(1,globSM.OUT.editPts,umPos);

strs = num2str(globSM.OUT.editPts,'%0.2f ');
set(globSM.h.edit_customOUT,'String',strs);




% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global globSM
globSM.OUT.num = globSM.OUT.num + 1;
g.dat.pos = globSM.OUT.editPts;
g.type = 'pts';
g.dat.name = 'custom list';
globSM.OUT.g(globSM.OUT.num) = g;
updateSMfig


% --- Executes on button press in pushbutton_addINlist.
function pushbutton_addINlist_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_addINlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global globSM
globSM.IN.num = globSM.IN.num + 1;
g.dat.pos = globSM.IN.editPts;
g.type = 'pts';
g.dat.name = 'custom list';
globSM.IN.g(globSM.IN.num) = g;
updateSMfig



function deselectToggleUI(handles, hObject)


tag = get(hObject,'Tag');
hList = {'togglebutton_getINpts','togglebutton_getProbePoints'};

for i = 1:length(hList)
    if ~strcmp(tag,hList{i})
        set(eval(['handles.' hList{i}]),'Value',0);
        eval([hList{i} '_Callback(handles.' hList{i} ',[],handles)']);
    end
end


% --- Executes on button press in pushbutton_clearOUTpts.
function pushbutton_clearOUTpts_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clearOUTpts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global globSM

globSM.OUT.editPts = [];
updateSMfig


% --- Executes on button press in togglebutton_getINpts.
function togglebutton_getINpts_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_getINpts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_getINpts

global glob globSM

val = get(hObject,'Value');

% try
%     glob.dcm.Enable = 'off'
%     %glob.dcm.delete
% end

if val
    deselectToggleUI(handles, hObject)
    glob.dcm = datacursormode(glob.handles.figure1);
    glob.dcm.UpdateFcn = @displayCoordinates2;
    
    set(glob.dcm,'DisplayStyle','datatip',...
        'SnapToDataVertex','off','Enable','on')
else
    rotate3d(glob.handles.figure1)
    delete(findall(glob.handles.figure1,'Type','hggroup'))
end


function txt = displayCoordinates2(~,info)
global glob globSM

X = info.Position(2);
Y = info.Position(1);
Z = info.Position(3);
%c_info = getCursorInfo(glob.dcm)

anc2sub = (glob.em.res/ 1000)./ glob.em.dsRes;
allPos2 = [X Y Z] ./ anc2sub;
VASTpos = sprintf('%.0f  %.0f  %.0f',allPos2(end,2),allPos2(end,1),allPos2(end,3));
disp(VASTpos)

anc2um =  1./ glob.em.dsRes;
umPos = [X Y Z];
umPosStr = sprintf('%.0f \r%.0f \r%.0f um',umPos(end,2),umPos(end,1),umPos(end,3));

set(globSM.h.textOut,'String',VASTpos);
tag = get(info.Target,'Tag');

txt = umPosStr;

clipboard('copy',umPos)

globSM.IN.editPts = cat(1,globSM.IN.editPts,umPos);

strs = num2str(globSM.IN.editPts,'%0.2f ');
set(globSM.h.edit_customIN,'String',strs);



% --- Executes on button press in pushbutton_clearINpts.
function pushbutton_clearINpts_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clearINpts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global globSM

globSM.IN.editPts = [];
updateSMfig


% --- Executes on button press in pushbutton_printGraph.
function pushbutton_printGraph_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_printGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateGraphs

% --- Executes on button press in togglebutton_groupIN.
function togglebutton_groupIN_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_groupIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_groupIN
updateGraphs

% --- Executes on button press in togglebutton_groupOUT.
function togglebutton_groupOUT_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_groupOUT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_groupOUT

updateGraphs


% --- Executes on button press in togglebutton_normalizeIN.
function togglebutton_normalizeIN_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_normalizeIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_normalizeIN
updateGraphs

% --- Executes on button press in togglebutton_normalizeOUT.
function togglebutton_normalizeOUT_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_normalizeOUT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_normalizeOUT

updateGraphs


% --- Executes on button press in pushbutton_render.
function pushbutton_render_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_render (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
