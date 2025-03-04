function[] = orbitCam

global glob


[a e] = view;

foldName = glob.save.fileName;
directory = glob.save.dir;
obMovDir = [directory foldName '\'];
if ~exist(obMovDir,'dir'),mkdir(obMovDir);else
    disp('directory exists');
end

fig1 = glob.fig;
fig2 = figure('visible','on')

fig2.Color = fig1.Color;
% fig2.Position = fig1.Position;
% fig2.OuterPosition = fig1.OuterPosition;

fig2.Position = [  1   1   1536   1024];
fig2.Visible = 'off';
newax = copyobj(glob.ax,fig2);
 set(fig2,'PaperUnits','points','PaperPosition',[1 1 512 512])
    set(fig2, 'InvertHardCopy', 'off');

newlight = copyobj(glob.light,newax);


[ca ce] = lightangle(newlight);
% 
% l = findobj(fig2,'Type','Light');
% [ca ce] = lightangle(l);


for r = 2:2:360;
    

rotate(newax, [1 0 0], 20)
camorbit(newax,2,0,'camera',[0 1 0])

    %view(newax,a+r,e)
    %lightangle(newlight,ca+r,ce)

    %
    % rotate3d
    % camorbit(r,0)
    % pause(.1)
    % %camorbit
    
    imageName = sprintf('%srot_%05.0f.png',obMovDir,r);
    print(fig2,imageName,'-dpng','-r256','-opengl','-noui')
    pause(.03)

end

close(fig2)


