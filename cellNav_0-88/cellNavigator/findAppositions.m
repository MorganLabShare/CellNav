function varargout = findAppositions(varargin)
% FINDAPPOSITIONS MATLAB code for findAppositions.fig
%      FINDAPPOSITIONS, by itself, creates a new FINDAPPOSITIONS or raises the existing
%      singleton*.
%
%      H = FINDAPPOSITIONS returns the handle to a new FINDAPPOSITIONS or the handle to
%      the existing singleton*.
%
%      FINDAPPOSITIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINDAPPOSITIONS.M with the given input arguments.
%
%      FINDAPPOSITIONS('Property','Value',...) creates a new FINDAPPOSITIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before findAppositions_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to findAppositions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help findAppositions

% Last Modified by GUIDE v2.5 22-Sep-2020 15:52:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @findAppositions_OpeningFcn, ...
                   'gui_OutputFcn',  @findAppositions_OutputFcn, ...
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


% --- Executes just before findAppositions is made visible.
function findAppositions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to findAppositions (see VARARGIN)

% Choose default command line output for findAppositions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes findAppositions wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global glob globFA

globFA.h = handles;

str = get(globFA.h.edit_outputDensity,'String')
num = str2num(str);
if ~isempty(num)
    globFA.outputGrid = num;
end


str = get(globFA.h.edit_appoDist,'String')
num = str2num(str);
if ~isempty(num)
    globFA.appDist = num;
end





% --- Outputs from this function are returned to the command line.
function varargout = findAppositions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu_groupOne.
function popupmenu_groupOne_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_groupOne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_groupOne contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_groupOne

global glob globFA

strs = get(hObject,'String');
val = get(hObject,'Value');
str = strs{val};


set(globFA.h.edit_groupOne,'String',str);
globFA.group1.val = val;
globFA.group1.idx = glob.g(val).idx;

% --- Executes during object creation, after setting all properties.
function popupmenu_groupOne_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_groupOne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob globFA

str = {glob.g.name};
set(hObject,'String',str);



% --- Executes on selection change in popupmenu_groupTwo.
function popupmenu_groupTwo_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_groupTwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_groupTwo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_groupTwo

global glob globFA

strs = get(hObject,'String');
val = get(hObject,'Value');
str = strs{val};

set(globFA.h.edit_groupTwo,'String',str);
globFA.group2.val = val;
globFA.group2.idx = glob.g(val).idx;


% --- Executes during object creation, after setting all properties.
function popupmenu_groupTwo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_groupTwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob globFA

str = {glob.g.name};
set(hObject,'String',str);

function edit_appoDist_Callback(hObject, eventdata, handles)
% hObject    handle to edit_appoDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_appoDist as text
%        str2double(get(hObject,'String')) returns contents of edit_appoDist as a double

global globFA

str = get(hObject,'String')
num = str2num(str);
if ~isempty(num)
    globFA.appDist = num;
end


% --- Executes during object creation, after setting all properties.
function edit_appoDist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_appoDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_FindAppositions.
function pushbutton_FindAppositions_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FindAppositions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob globFA

%globFA.h.textOut = 'Finding Appositions';
set(globFA.h.textOut,'String','Finding Appositions');


str = get(globFA.h.edit_outputDensity,'String')
num = str2num(str);
if ~isempty(num)
    globFA.outputGrid = num;
end


str = get(globFA.h.edit_appoDist,'String')
num = str2num(str);
if ~isempty(num)
    globFA.appDist = num;
end

pts1 = runFindAppositions;
if isempty(pts1)
    set(handles.edit_umPos,'String','none')
    set(handles.edit_VASTpos,'String','none');
    set(globFA.h.textOut,'String','Found no appositions.');

else
    pts1 = pts1(:,[3 2 1]);
    globFA.appoPts = pts1;
    str = num2str(pts1);
    set(handles.edit_umPos,'String',str)

    anc2sub = (glob.em.res/ 1000);
    umPos = pts1 ;

    VASTpos = round(umPos ./ anc2sub);
    set(handles.edit_VASTpos,'String',num2str(VASTpos));
    globFA.vastPts = VASTpos;
    %clipboard('copy',VASTpos)
    set(globFA.h.textOut,'String','Finished finding appositions.');
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



function edit_groupOne_Callback(hObject, eventdata, handles)
% hObject    handle to edit_groupOne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_groupOne as text
%        str2double(get(hObject,'String')) returns contents of edit_groupOne as a double


% --- Executes during object creation, after setting all properties.
function edit_groupOne_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_groupOne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_groupTwo_Callback(hObject, eventdata, handles)
% hObject    handle to edit_groupTwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_groupTwo as text
%        str2double(get(hObject,'String')) returns contents of edit_groupTwo as a double


% --- Executes during object creation, after setting all properties.
function edit_groupTwo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_groupTwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_umPos_Callback(hObject, eventdata, handles)
% hObject    handle to edit_umPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_umPos as text
%        str2double(get(hObject,'String')) returns contents of edit_umPos as a double


% --- Executes during object creation, after setting all properties.
function edit_umPos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_umPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_VASTpos_Callback(hObject, eventdata, handles)
% hObject    handle to edit_VASTpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_VASTpos as text
%        str2double(get(hObject,'String')) returns contents of edit_VASTpos as a double


% --- Executes during object creation, after setting all properties.
function edit_VASTpos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_VASTpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_makeGroup.
function pushbutton_makeGroup_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_makeGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob globFA

L = length(glob.syn.g)+1;

synfo = glob.syn.defaultG;
synfo.preCellIdx = [];
synfo.preName = 'none';
synfo.postCellIdx = [];
synfo.postName = [];
synfo.preName = [];
synfo.synType = 'all'

try 
    delete(synfo.p)
end

pos = globFA.appoPts; %tis.syn.synPosDS(isSyn,[2 1 3]) * glob.em.dsRes(1);
synfo.pos = pos;
set(glob.ax, 'NextPlot', 'add')
synfo.p = scatter3(glob.ax,pos(:,1),pos(:,2),pos(:,3),synfo.markerSize,...
    'markerfacecolor',synfo.col,'markerfacealpha',synfo.alph,...
    'marker',synfo.markerType,'markeredgecolor','w');

set(synfo.p,'clipping','off')

synfo.synIdx = 0;

synfo.name = sprintf('group%d apposition list',L);

gStr = get(glob.handles.popupmenu_synGroup,'String');
gStr{L} = synfo.name;
set(glob.handles.popupmenu_synGroup,'String',gStr);
set(glob.handles.popupmenu_synGroup,'Value',L);

glob.syn.g(L) = synfo;



function edit_outputDensity_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outputDensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_outputDensity as text
%        str2double(get(hObject,'String')) returns contents of edit_outputDensity as a double

global globFA

str = get(hObject,'String');
num = str2num(str);
if ~isempty(num)
    globFA.outputGrid = num;
end


% --- Executes during object creation, after setting all properties.
function edit_outputDensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outputDensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global globFA


str = get(hObject,'String');
num = str2num(str);
if ~isempty(num)
    globFA.outputGrid = num;
end
