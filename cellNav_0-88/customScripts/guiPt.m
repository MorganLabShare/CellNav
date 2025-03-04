function[res] = guiPt

global globPt

globPt.idx = 0;

% --- Executes on button press in togglebutton_SelectPatch.
globPt.figH = gcf;
globPt.axH = gca;
globPt.dcm = datacursormode(globPt.figH);
globPt.dcm.UpdateFcn = @cursorSelectPt;

set(globPt.dcm ,'DisplayStyle','datatip',...
    'SnapToDataVertex','off','Enable','on')



function txt = cursorSelectPt(~,info)

global globPt
disp('Select point.')
set(globPt.dcm,'Enable','off')

globPt.X = info.Position(2);
globPt.Y = info.Position(1);
globPt.Z = info.Position(3);



globPt.idx = get(info.Target,'SeriesIndex');
txt = 'Selected Seed';






