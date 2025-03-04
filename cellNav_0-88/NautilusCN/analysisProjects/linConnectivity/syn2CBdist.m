

clear all
load('MPN.mat')
if ~exist('MPN','var')
    MPN = GetMyDir;
end

synDir = [MPN 'synPos3\'];
if ~(exist(synDir,'dir')),mkdir(synDir); end

if ~exist('obI','var') | ~exist('dsObj','var')
    disp('loading')
    load([MPN 'obI.mat'])
    load([MPN 'dsObj.mat'])
end


mot = getMotifs(obI);
syn = getSynMat(obI);


%%

from125 = syn.pre==125;
toTC = syn.postClass == 2;
isCell = isCellBody;
%inBounds = isAtBoarder;

useSyn = find(from125&toTC);
dists = [];
colPos = [];
cellNames = [];
for i = 1:length(useSyn)
    
    synPos = syn.synPos(useSyn(i),:);
    cellName = syn.post(useSyn(i));
    cellPos = obI.cell.anchors(find(obI.cell.name == cellName),:);
    isCell2 = obI.cell.isCell(find(obI.cell.name == cellName))
    dSamp =  (obI.em.res .* [4 4 1])./1000;
    cellPos(:,1) = cellPos(:,1)*dSamp(1);
    cellPos(:,2) = cellPos(:,2)*dSamp(2);
    cellPos(:,3) = cellPos(:,3)*dSamp(3);
    colPos = [colPos;cellPos];
    dist = sqrt((cellPos(1)-synPos(1)).^2 + (cellPos(2)-synPos(2)).^2 + ...
        (cellPos(3)-synPos(3)).^2);
    
    if (sum(synPos)>3) & ( sum(cellPos) >3) 
        if sum(isCell == cellName)
            dists = [dists dist];
            cellNames = [cellNames cellName];
            
        end
    end
end

hRange = [0:10:300];
hDist = hist(dists,hRange);
bar(hRange,hDist);
cellNames(dists>200)

mean(dists)
median(dists)

dists = sort(dists);

num = length(dists);

dists(round(num * .025))
dists(round(num * .975))

distsTC = dists;
%return
%% Trace to LIN

from125 = syn.pre==125;
toTC = syn.postClass == 3;
useSyn = find(from125&toTC);
allPost = unique(syn.post(useSyn));

isCell = isCellBody;
cbPost = intersect(allPost,isCell);


dists = [];
for i = 1:length(useSyn)
    
    synPos = syn.synPos(useSyn(i),:);
    cellName = syn.post(useSyn(i));
    cellPos = obI.cell.anchors(find(obI.cell.name == cellName),:);
    dSamp =  (obI.em.res .* [4 4 1])./1000;
    cellPos(:,1) = cellPos(:,1)*dSamp(1);
    cellPos(:,2) = cellPos(:,2)*dSamp(2);
    cellPos(:,3) = cellPos(:,3)*dSamp(3);
    dist = sqrt((cellPos(1)-synPos(1)).^2 + (cellPos(2)-synPos(2)).^2 + ...
        (cellPos(3)-synPos(3)).^2);
    if (sum(synPos)>3) & ( sum(cellPos) >3)
        
        if sum(isCell == cellName)
            dists = [dists dist];
            
        end
    end
    
end




hRange = [0:10:300];
hDist = hist(dists,hRange)
bar(hRange,hDist)

mean(dists)
median(dists)

dists = sort(dists);

num = length(dists);

dists(round(num * .025))
dists(round(num * .975))





%%


mean(distsTC)
median(distsTC)

distsTC = sort(distsTC);

num = length(distsTC);

distsTC(round(num * .025))
distsTC(round(num * .975))


ranksum(dists,distsTC)











