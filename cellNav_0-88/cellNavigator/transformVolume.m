function varargout = transformVolume(varargin)
% TRANSFORMVOLUME MATLAB code for transformVolume.fig
%      TRANSFORMVOLUME, by itself, creates a new TRANSFORMVOLUME or raises the existing
%      singleton*.
%
%      H = TRANSFORMVOLUME returns the handle to a new TRANSFORMVOLUME or the handle to
%      the existing singleton*.
%
%      TRANSFORMVOLUME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRANSFORMVOLUME.M with the given input arguments.
%
%      TRANSFORMVOLUME('Property','Value',...) creates a new TRANSFORMVOLUME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before transformVolume_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to transformVolume_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help transformVolume

% Last Modified by GUIDE v2.5 25-Jun-2020 15:16:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @transformVolume_OpeningFcn, ...
    'gui_OutputFcn',  @transformVolume_OutputFcn, ...
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


% --- Executes just before transformVolume is made visible.
function transformVolume_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to transformVolume (see VARARGIN)

% Choose default command line output for transformVolume
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes transformVolume wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = transformVolume_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_pts1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pts1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pts1 as text
%        str2double(get(hObject,'String')) returns contents of edit_pts1 as a double



% --- Executes during object creation, after setting all properties.
function edit_pts1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pts1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pts2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pts2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pts2 as text
%        str2double(get(hObject,'String')) returns contents of edit_pts2 as a double


% --- Executes during object creation, after setting all properties.
function edit_pts2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pts2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_showTransform_Callback(hObject, eventdata, handles)
% hObject    handle to edit_showTransform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_showTransform as text
%        str2double(get(hObject,'String')) returns contents of edit_showTransform as a double


% --- Executes during object creation, after setting all properties.
function edit_showTransform_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_showTransform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_chooseVolume.
function popupmenu_chooseVolume_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_chooseVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_chooseVolume contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_chooseVolume


% --- Executes during object creation, after setting all properties.
function popupmenu_chooseVolume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_chooseVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global glob
if isfield(glob,'vol')
    set(hObject,'String',glob.vol.names)
else
    set(hObject,'String','None')
end

% --- Executes on selection change in popupmenu_Method01.
function popupmenu_Method01_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Method01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Method01 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Method01


% --- Executes during object creation, after setting all properties.
function popupmenu_Method01_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Method01 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

str = {'pointToPoint'}
set(hObject,'String',str);

% --- Executes on button press in pushbutton_saveTransform.
function pushbutton_saveTransform_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_saveTransform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global glob globTranslate

volTransform = globTranslate.vTran;
volID = get(handles.popupmenu_chooseVolume,'Value');
glob.vol.tforms{volID} = volTransform;

save([glob.dir.Volumes glob.vol.names{volID} '\volTransform.mat'],'volTransform');
save([glob.dir.Volumes glob.vol.names{volID} '\Analysis\fvLibrary\volTransform.mat'],'volTransform');



% --- Executes on button press in pushbutton_runTransform.
function pushbutton_runTransform_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_runTransform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global globTranslate

pts1str = get(handles.edit_pts1,'String');
pts2str = get(handles.edit_pts2,'String');
vol = get(handles.popupmenu_chooseVolume,'String');
meth1str = get(handles.popupmenu_Method01,'String');
meth1val = get(handles.popupmenu_Method01,'Value');
meth1 = meth1str{meth1val};

transStr = get(handles.popupmenu_transform,'String');
transVal = get(handles.popupmenu_transform,'Value');
transType = transStr{transVal};

regTypeVal = get(handles.popupmenu_registraton,'Value');
regTypeStr = get(handles.popupmenu_registraton,'String');
regType = regTypeStr{regTypeVal};

vox1 = str2num(get(handles.edit_voxSize1,'String'));
vox2 = str2num(get(handles.edit_voxSize2,'String'));


pts1 = zeros(size(pts1str,1),3);
for i = 1:size(pts1str)
    line = pts1str(i,:);
    nums = regexp(line,'\d');
    new = find(nums(2:end)-nums(1:end-1)>1);
    X = str2num(line(nums(1):nums(new(1)))) * vox1(1)/1000;
    Y = str2num(line(nums(new(1)+1):nums(new(2)))) * vox1(2)/1000;
    Z = str2num(line(nums(new(2)+1):nums(end))) * vox1(3)/1000;
    pts1(i,:) = [Y X Z];
end

pts2 = zeros(size(pts2str,1),3);
for i = 1:size(pts2str)
    line = pts2str(i,:);
    nums = regexp(line,'\d');
    new = find(nums(2:end)-nums(1:end-1)>1);
    X = str2num(line(nums(1):nums(new(1)))) * vox2(1)/1000;
    Y = str2num(line(nums(new(1)+1):nums(new(2)))) * vox2(2)/1000;
    Z = str2num(line(nums(new(2)+1):nums(end))) * vox2(3)/1000;
    pts2(i,:) = [Y X Z];
end



pc1 = pointCloud(pts1);
pc2 = pointCloud(pts2);
tformStr = 'transform rendered in red';
if sum(regexp(regType,'pcregistericp'))
    tform = pcregistericp(pc2,pc1,'Metric',meth1,'Extrapolate',true);
    pc3 = pctransform(pc2,tform);
    pts3 = pc3.Location;    
    vTran.type = 'pc';
    vTran.tform = tform;
    tformStr = num2str(tform,' %0.2f ');

    
elseif sum(regexp(regType,'pcregistercpd'))
    tform = pcregistercpd(pc2,pc1,'Transform',transType,'InteractionSigma',.01);
    vTran.type = 'pc';
    vTran.tform = tform;

elseif sum(regexp(regType,'fitgeotrans'))
    tform = fitgeotrans(pts2,pts1,transType);
    pc3 = pctransform(pc2,tform);
    pts3 = pc3.Location;
    vTran.type = 'pc';
    vTran.tform = tform;
    
elseif sum(regexp(regType,'absor'))
    regParam = absor(pts2',pts1','doScale',1,'doTrans',1);
    %tform = maketform('affine',regParam.M);
    tform = rotm2tform(regParam.M)
    pc3 = pctransform(pc2,tform);
    pts3 = pc3.Location;
    vTran.type = 'pc';
    vTran.tform = tform;
else
    tform1 = estimateGeometricTransform(pts1(:,1:2),pts2(:,1:2),transType);
    pts3a = pts2;
    pts3a(:,1:2) = transformPointsInverse(tform1,pts2(:,1:2));
    
    tform2 = estimateGeometricTransform(pts1(:,2:3),pts3a(:,2:3),transType);
    pts3b = pts3a;
    pts3b(:,2:3) = transformPointsInverse(tform2,pts3b(:,2:3));
    
    pts3 = pts3b;
    
    vTran.type = 'YX XZ';
    vTran.tform1 = tform1;
    vTran.tform2 = tform2;
    tformStr = num2str(cat(1,tform1.T,tform2.T),'      %0.2f      ');
    
    %T = maketform('composite',T1,T2); 
    %pts3 = transformPointsInverse(tform,pts2);

end

scatter3(handles.axes1,pts1(:,1),pts1(:,2),pts1(:,3),100,'o','k','MarkerFaceAlpha',1)
hold on
scatter3(handles.axes1,pts2(:,1),pts2(:,2),pts2(:,3),50,'o','b','filled','MarkerFaceAlpha',.2)
scatter3(handles.axes1,pts3(:,1),pts3(:,2),pts3(:,3),50,'o','r','filled','MarkerFaceAlpha',.6)
hold off
rotate3d on

set(handles.edit_showTransform,'String',tformStr);

globTranslate.vTran = vTran;


% --- Executes on selection change in popupmenu_transform.
function popupmenu_transform_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_transform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_transform contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_transform


% --- Executes during object creation, after setting all properties.
function popupmenu_transform_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_transform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

str = {'Nonrigid','Rigid','Affine'};
set(hObject,'String',str);
set(hObject,'Value',3);

% --- Executes on selection change in popupmenu_registraton.
function popupmenu_registraton_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_registraton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_registraton contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_registraton

% --- Executes during object creation, after setting all properties.
function popupmenu_registraton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_registraton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

str = {'YX XZ','pcregistericp - For unpaired point clouds', 'pcregistercpd', ...
    'fitgeotrans','absor'};
set(hObject,'String',str)



function edit_voxSize1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_voxSize1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_voxSize1 as text
%        str2double(get(hObject,'String')) returns contents of edit_voxSize1 as a double


% --- Executes during object creation, after setting all properties.
function edit_voxSize1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_voxSize1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_voxSize2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_voxSize2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_voxSize2 as text
%        str2double(get(hObject,'String')) returns contents of edit_voxSize2 as a double


% --- Executes during object creation, after setting all properties.
function edit_voxSize2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_voxSize2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
