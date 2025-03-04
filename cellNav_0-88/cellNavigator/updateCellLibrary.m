function  updateCellLibrary

%%Make fv files and skeletons for new objects

global glob tis tisDat
tempFig = figure;
tempAx = gca(tempFig);

MPN = glob.NA.MPN;
WPN = glob.NA.WPN;




load([MPN 'obI.mat'])
load([MPN 'dsObj.mat'])

if exist([MPN 'shiftZ.mat']);
    load([MPN 'shiftZ.mat']);
    shouldShiftZ = 1;
else
    shouldShiftZ = 0;
end

obI.nameProps = getNameProps2019(obI.colStruc.names);
obI = getObiCellProps(obI);

save([MPN 'vastSubs.mat'],'vastSubs','-v7.3')
save([MPN 'obI.mat'],'obI')





d = dir([MPN 'obI.mat']); % Get the time obI was made
obIDateNum = d.datenum;

%load([WPN 'tis.mat'])
tis = makeTis;

flipDim = [1 3 2 ];

downSamp = 1;
renderProps.smooth = 0;
renderProps.resize = 1;
renderProps.smoothPatch = 0;
renderProps.smoothSections = 0;


%% Pick cells

cellList = tis.cells.cids;

col = ones(length(cellList),3);
alph = ones(length(cellList),1);


%%
fvDir = [WPN 'fvLibrary\'];

if ~exist(fvDir,'dir')
    mkdir(fvDir)
end

save([fvDir 'obI.mat'],'obI');
save([fvDir 'tis.mat'],'tis');

%% Draw cells
trackCells = [];
cellsShown = {};
cellsNotShown = {};
for i = 1:length(cellList)
    subCell = names2Subs(obI,dsObj,cellList(i));
    sub = subCell{1};
    obName = cellList(i);
    fvFilename = sprintf('%s%d.mat',fvDir,obName);
    
    if ~exist(fvFilename,'file')
        drawCell = 1;
    else
        d = dir(fvFilename);
        if obIDateNum > d.datenum
            drawCell = 1;
        else %there exists an fv that is newer than the obI
            drawCell = 0;
        end
    end
        
    if drawCell
        
        if ~isempty(sub)
            if iscell(obName); obName = obName{1};end
              if shouldShiftZ %shift each plane
                if strcmp(shiftZ.type, 'translation')
                    shiftY = shiftZ.shifts(sub(:,3),1);
                    shiftX = shiftZ.shifts(sub(:,3),2);
                    sub(:,1) = sub(:,1) + shiftY;
                    sub(:,2) = sub(:,2) + shiftX;
                end
            end
            smallSub = shrinkSub(sub,downSamp);
            smallSub = smallSub(:,flipDim);
            
        else
            smallSub = [];
        end
        %trackCells = cat(1,trackCells,[obName size(sub,1)]);
        tic
        if isempty(smallSub)
            fv.vertices = [];
            fv.faces = [];
        else
            fv = subVolFV(smallSub,[],renderProps);
        end
        
        %% Scale
        fv.vertices = fv.vertices * obI.em.dsRes(1);
        
        fvFilename = sprintf('%s%d.mat',fvDir,obName);
        save(fvFilename,'fv');
        cla
        patch(tempAx,fv)
        pause(.01)
    end
    
end

%% Run SMs

smDir = [WPN 'SMs\'];
libDir = [WPN 'fvLibrary\'];
dSMs = dir([smDir '*.mat']);
nams = { dSMs.name};


for i = 1:length(nams)
    clf
    %%parse cid
    cidIx = regexp(nams{i},'cid');
    dotIx = regexp(nams{i},'.mat');
    cid = str2num(nams{i}(cidIx(1)+3:dotIx(1)-1));
    filenameNep = sprintf('%snep_%d.mat',libDir,cid);    
    d = dir(filenameNep);
    if length(d)
    if obIDateNum > d.datenum
        load([smDir nams{i}])
        %showNepBones(sm.nep);
        %showRadSurf(sm.nep.pos,sm.nep.edges,sm.nep.nodeRad,[0 1 0],.4)
        if isfield(sm,'nep')
            if ~isempty(sm.nep)
                fv = showRadSurf_cnv(sm.nep.pos,sm.nep.edges,sm.nep.nodeRad*0+.1,[1 1 1],1,tempFig);
                pause(.01)
                filename = sprintf('%sskelFV_%d.mat',libDir,sm.cid);
                save(filename,'fv')
                
                filenameNep = sprintf('%snep_%d.mat',libDir,sm.cid);
                nep = sm.nep;
                save(filenameNep,'nep')
            end
        end
    end
    end
end
close(tempFig)


%renderRefs
makeTisDat



















