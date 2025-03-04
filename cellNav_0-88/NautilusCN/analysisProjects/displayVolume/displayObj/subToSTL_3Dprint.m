clear all
load('MPN.mat')

load([MPN 'obI.mat'])
load([MPN 'dsObj.mat'])


projectDown = 1;


seedList = [ 108];
useList = obI2cellList_seedInput_RGC_TCR(obI,seedList);

RGC = useList.preList(:)';
TCR = useList.postList(:)';
RGC = RGC;
TCR = setdiff(TCR,seedList);


allEdges = obI.nameProps.edges;
postTarg = preTo(allEdges,108);
preTarg = postTo(allEdges,108);
linked = [];
%cellList = [108 RGC TCR]
%cellList = {125 'frag 125'};
cellList = 201;
% 
colNum = length(cellList)-1;
colMap = hsv(256);
rainBow = colMap(ceil([1:colNum] * 255/(colNum)),:);
rainBow = rainBow(randperm(size(rainBow,1)),:);
col = [rainBow; [1 1 1]]
col = [1 1 1;repmat([1 0 0],[length(RGC) 1]);repmat([0 1 0],[length(TCR) 1])]
cellAlpha = [1 ;repmat([.6],[length(RGC) 1]);repmat([.3],[length(TCR) 1])]
col = [1 1 1];

%%

renderOb = 0;
tag = 'testCrop';
objDir = [MPN 'stlFiles\']
if ~exist(objDir,'dir'),mkdir(objDir),end



downSamp = 4;

target = [908 490 555.5]*2; % ( X Y Z)
target = [13496, 19858, 3743];% glom A
rad = 1200;
%crop = [target- rad; target + rad];
%crop     = [1600  850 850;          1950 1100 1430]; %[ z x y

clf
% cellList = 125;
l = lightangle(0,45) ;

for i = 1:length(cellList)
    subCell = names2Subs(obI,dsObj,cellList(i));
    sub = subCell{1};
    obName = cellList(i);
    if iscell(obName); obName = obName{1};end
    if exist('crop','var')
        useSub = ((crop(1,1)<sub(:,1)) & (crop(2,1)>sub(:,1)) & ...
            (crop(1,2)<sub(:,2)) & (crop(2,2)>sub(:,2)) & ...
            (crop(1,3)<sub(:,3)) & (crop(2,3)>sub(:,3)));
        sub = sub(useSub,:);
        
    end
    smallSub = shrinkSub(sub,downSamp);
    tic
    if isempty(smallSub)
        disp(sprintf('no points on %d',cellList(i)))
    else
    fv = subVolFV(smallSub,[],renderOb);
    [p] = renderFV(fv,col(i,:),cellAlpha(i));

    view([0 0])
    
    pause(.01)
    hold on
    fileNameOBJ = sprintf('%sdSamp%d_%s_%d.obj',objDir,downSamp,tag,obName);
    fileNameSTL = sprintf('%sdSamp%d_%d.stl',objDir,downSamp,obName);
    %STLWRITE(FILE, FACES, VERTICES)
    
    %stlwrite(fileNameSTL,fv.faces,fv.vertices);
    vertface2obj(fv.vertices,fv.faces,fileNameOBJ,obName);
    toc
    %     cellDat(i).subs = sub;
    %     cellDat(i).fv = fv;
    end
    disp(sprintf('finished rendering cell %d.  (%d of %d)',cellList(i),i,length(cellList)));
end

hold off


%% movie
tag = 'testMove';
frames = 360;
el = ones(frames,1) * 0;
az = 1;%1:360/frames:360;
obMovDir = 'D:\LGNs1\Analysis\movies\seedRGCTCR\'
if ~exist(obMovDir,'dir'),mkdir(obMovDir),end
savefig([obMovDir tag '.fig'])

% 
% cam2 = light
% cam3 = camlight('headlight')
% set(cam2,'Position',[1 1 1])
shouldWrite = 1;



while 1
for i = 1:frames;
    
view([az(i) el(i)])
lightangle(l,az(i)+10, 50)
pause(.01)

set(gcf,'PaperUnits','points','PaperPosition',[1 1 700 700])

%runSprings(springDat,allResults{1})
set(gcf, 'InvertHardCopy', 'off');
imageName = sprintf('%sspringRun_%s%05.0f.png',obMovDir,tag,i);
%print(gcf,imageName,'-dpng','-r1024','-opengl','-noui')

if shouldWrite
    print(gcf,imageName,'-dpng','-r256','-opengl','-noui')
end


end
if shouldWrite, break,end
end






