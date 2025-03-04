function varargout = translateList(varargin)
% TRANSLATELIST MATLAB code for translateList.fig
%      TRANSLATELIST, by itself, creates a new TRANSLATELIST or raises the existing
%      singleton*.
%
%      H = TRANSLATELIST returns the handle to a new TRANSLATELIST or the handle to
%      the existing singleton*.
%
%      TRANSLATELIST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRANSLATELIST.M with the given input arguments.
%
%      TRANSLATELIST('Property','Value',...) creates a new TRANSLATELIST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before translateList_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to translateList_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help translateList

% Last Modified by GUIDE v2.5 10-Jul-2020 17:35:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @translateList_OpeningFcn, ...
                   'gui_OutputFcn',  @translateList_OutputFcn, ...
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


% --- Executes just before translateList is made visible.
function translateList_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to translateList (see VARARGIN)

% Choose default command line output for translateList
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes translateList wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = translateList_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_IN_Callback(hObject, eventdata, handles)
% hObject    handle to edit_IN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_IN as text
%        str2double(get(hObject,'String')) returns contents of edit_IN as a double


% --- Executes during object creation, after setting all properties.
function edit_IN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_IN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_OUT_Callback(hObject, eventdata, handles)
% hObject    handle to edit_OUT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_OUT as text
%        str2double(get(hObject,'String')) returns contents of edit_OUT as a double


% --- Executes during object creation, after setting all properties.
function edit_OUT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_OUT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_X_Callback(hObject, eventdata, handles)
% hObject    handle to edit_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_X as text
%        str2double(get(hObject,'String')) returns contents of edit_X as a double


% --- Executes during object creation, after setting all properties.
function edit_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Y as text
%        str2double(get(hObject,'String')) returns contents of edit_Y as a double


% --- Executes during object creation, after setting all properties.
function edit_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Z as text
%        str2double(get(hObject,'String')) returns contents of edit_Z as a double


% --- Executes during object creation, after setting all properties.
function edit_Z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_order_Callback(hObject, eventdata, handles)
% hObject    handle to edit_order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_order as text
%        str2double(get(hObject,'String')) returns contents of edit_order as a double


% --- Executes during object creation, after setting all properties.
function edit_order_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_TranslateSimple.
function pushbutton_TranslateSimple_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_TranslateSimple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global globTransList

X = str2num(get(handles.edit_X,'str'));
Y = str2num(get(handles.edit_Y,'str'));
Z = str2num(get(handles.edit_Z,'str'));


ordStr = lower(get(handles.edit_order,'str'));
pts1str = get(handles.edit_IN,'str');
outStr = get(handles.edit_OUT,'str');

%%parse order
xr = regexp(ordStr,'x');
yr = regexp(ordStr,'y');
zr = regexp(ordStr,'z');
abOrd = [xr(1) yr(1) zr(1)];
[a xyzSwitch] = sort(abOrd);
dimScale = [X Y Z];
dimScale = dimScale(xyzSwitch);

%%Parse IN

pts1 = zeros(size(pts1str,1),3);
for i = 1:size(pts1str)
   if strcmp(class(pts1str),'char')
       line = pts1str(i,:);
   else
    line = pts1str{i};
   end
    nums = regexp(line,'\d');
    new = find(nums(2:end)-nums(1:end-1)>1);
    p1 = str2num(line(nums(1):nums(new(1)))) ;
    p2 = str2num(line(nums(new(1)+1):nums(new(2)))) ;
    p3 = str2num(line(nums(new(2)+1):nums(end))) ;
    pts1(i,:) = [p1 p2 p3];
end

pts2 = pts1(:,xyzSwitch);
pts2 = pts2.* repmat(dimScale,[size(pts2,1) 1]);

newOutStr = num2str(pts2);

set(handles.edit_OUT,'String',newOutStr)

globTransList.pts2 = pts2;





% --- Executes on button press in pushbutton_makeSynGroup.
function pushbutton_makeSynGroup_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_makeSynGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global glob globTransList

L = length(glob.syn.g)+1;

synfo = glob.syn.defaultG;
synfo.preCellIdx = 0;
synfo.preName = 'none';
synfo.postCellIdx = 0;
synfo.postName = 'none';
synfo.preName = 'none';
synfo.postName = 'none';
synfo.synType = 'all'


try 
    delete(synfo.p)
end


pos = globTransList.pts2; %tis.syn.synPosDS(isSyn,[2 1 3]) * glob.em.dsRes(1);
synfo.pos = pos;
set(glob.ax, 'NextPlot', 'add')
synfo.p = scatter3(glob.ax,pos(:,1),pos(:,2),pos(:,3),synfo.markerSize,...
    'markerfacecolor',synfo.col,'markerfacealpha',synfo.alph,...
    'marker',synfo.markerType,'markeredgecolor','w');

set(synfo.p,'clipping','off')

synfo.synIdx = 0;

synfo.name = sprintf('group%d custom list',L);

gStr = get(glob.handles.popupmenu_synGroup,'String');
gStr{L} = synfo.name;
set(glob.handles.popupmenu_synGroup,'String',gStr);
set(glob.handles.popupmenu_synGroup,'Value',L);

glob.syn.g(L) = synfo;
