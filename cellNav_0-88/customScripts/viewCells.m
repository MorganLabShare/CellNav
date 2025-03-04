clear all
clf
load('MPN.mat')
load([WPN 'tis.mat'])
fvDir = [WPN 'fvLibrary\'];

%% Pick cell

cellList = [4 5];




%% Load ref volumes

load([fvDir 'ref_gcl nucEdge.mat'])
pRefGCL = renderFV(fv,[1 1 0],.5)

load([fvDir 'ref_inl nucEdge.mat'])
pRefINL = renderFV(fv,[1 0 1],.5)

load([fvDir 'ref_10 micron bar.mat'])
pRefMicronBar = renderFV(fv,[0 1 0],1)

load([fvDir 'ref_10 micron point 1.mat'])
pRefMicronPt1 = renderFV(fv,[1 1 1],.5)

load([fvDir 'ref_10 micron point 2.mat'])
pRefMicronPt2 = renderFV(fv,[1 1 1],.5)


%% Load Bips

bipCids = tis.cells.type.typeLists.bpc;

vert = [];
fac = [];
for i = 1:length(bipCids)
    fileName = sprintf('%s%d.mat',fvDir,bipCids(i));
    load(fileName);
    fac = cat(1,fac,fv.faces+size(vert,1));
    vert = cat(1,vert,fv.vertices);
end

fv.vertices = vert;
fv.faces = fac;
pBip = renderFV(fv,[0 .8 0],.1)



%% Draw cells
% cellList = 125;


flipDim = [1 3 2 ];
downSamp = 1;

aL = lightangle(0,45) ;
trackCells = [];
cellsShown = {};
cellsNotShown = {};
for i = 1:length(cellList)
    if exist('p'),delete(p);end
    fileName = sprintf('%s%d.mat',fvDir,cellList(i));
    load(fileName);
    p = renderFV(fv,[1 1 1],1);
    view([0 0])
    axis off
    pause(.01)
    hold on
    disp(sprintf('cell %d.  (%d of %d)',cellList(i),i,length(cellList)))
    pause
end
%aL = lightangle(0,45) ;





