function[cam] = orbitCamPartial(cam,s)

%%
global glob


foldName = glob.save.fileName;
directory = glob.save.dir;
obMovDir = [directory foldName '\'];
if ~exist(obMovDir,'dir'),mkdir(obMovDir);else
    disp('directory exists');
end

pngs = dir([obMovDir '*.png']);
c = length(pngs);


fig1 = glob.fig;
fig2 = figure('visible','on')

fig2.Color = fig1.Color;
% fig2.Position = fig1.Position;
% fig2.OuterPosition = fig1.OuterPosition;

fig2.Position = [  1   1   1536   1024];
fig2.Visible = 'on';%'off';
newax = copyobj(glob.ax,fig2);
set(fig2,'PaperUnits','points','PaperPosition',[1 1 512 512])
set(fig2, 'InvertHardCopy', 'off');

newlight = copyobj(glob.light,newax);
[ca ce] = lightangle(newlight);

newax.CameraPosition = cam.pos;
newax.CameraTarget = cam.targ;
newax.DataAspectRatio = cam.dar;
newax.CameraUpVector = cam.up;



% l = findobj(fig2,'Type','Light');
% [ca ce] = lightangle(l);

for r = 1:1:s;

    c = c+1;

    %rotate(newax, [1 0 0], 20)
    camorbit(newax,2,0,'camera',[0 1 0])
    drawnow
    %view(newax,a+r,e)
    %lightangle(newlight,ca+r,ce)

    % rotate3d
    % camorbit(r,0)
    % pause(.1)
    % %camorbit

    %drawnow
    imageName = sprintf('%srot_%05.0f.png',obMovDir,c);
    print(fig2,imageName,'-dpng','-r256','-opengl','-noui')


    cam.pos  = newax.CameraPosition;
    cam.targ  = newax.CameraTarget;
    cam.dar  = newax.DataAspectRatio;
    cam.up  = newax.CameraUpVector;

end
close(fig2)


