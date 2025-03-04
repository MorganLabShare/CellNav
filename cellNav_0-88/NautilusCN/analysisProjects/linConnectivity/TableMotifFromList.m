
if 0
    clear all
    load(['D:\LGNs1\Analysis\motifImages\listMotifWorkSpace2.mat'])
    
    obMovDir = 'D:\LGNs1\Analysis\movies\subLin125_TargFac\'
    if ~exist(obMovDir,'dir'),mkdir(obMovDir),end
    % else
    %     'directory already exists'
    %     return
    % end
    
    load('MPN.mat')
    load([MPN 'obI.mat'])
    load([MPN 'dsObj.mat'])
    
    sm = addDatToSynMat(obI)
    sm = getTopoEucDistBetweenSyn(sm);
    sm = getTopoEucDistBetweenSkelAndSyn(sm);
    sm = labelShaftSkel(sm);
    sm = labelSubTypes(sm);
    
end



%% get motifs
nodeNum = length(sm.skelNodes);
nodeProcType = sm.isTarg + sm.isAx * 2 + sm.isShaft * 3 + sm.isBody * 4;
motifCodes = [...
    '1 = RGC only, 2 = TC only, 3 = LINin only, 4 = LINout only, 5 = UNKin only, ' ...
    '6 = recip, 7 = autapse,'...
    '8 = RGC-LIN-TC diad, 9 = RGC-LIN-TC triad, 10 = RGC-LIN-TC mult triad, ' ...
    '11 = RGC-LIN-LIN diad, 12 = RGC-LIN-LIN IN triad,  13 = RGC-LIN-LIN out triad, 14 = RGC-LIN-LIN recip triad, ' ...
    '15 = LIN-LIN-TC diad (top), 16 = LIN-LIN-TC diad (mid), '...
    '17 = LIN-LIN-TC triad(top), 18 = LIN-LIN-TC triad(mid), 19 = LIN-LIN-TC recip triad, '...
    '20 = LLL diad, 21 = LLL tri top, 22 = LLL tri mid, 23 = LLL tri bot, 24 = LLL recip triad, '...
    '25 = UNK-LIN-TC(diad), 26 = UNK-LIN-TC triad, 27 = LIN-TC without RGC, 28 = LIN-TC with near RGC'];

if 1
    group1 = [8 9];
    group2 = [ 8 9 15 16 17 18 19 25 ];
    %group2 = [27]
    pos1 = cat(1,mPos{group1})
    pos2 = cat(1,mPos{group2});
    post1 = pos1(:,1)*0;
    pre1 = pos1(:,1) * 0;
    tcOut = pos1(:,1) * 0 + 1;
else
    rgcIn = ((sm.post == 125) & (sm.preClass == 1));
    linIn = ((sm.post == 125) & (sm.preClass == 3));
    linOut = ((sm.pre == 125) & (sm.postClass == 3));
    unkOut = ((sm.pre == 125) & (sm.postClass == 4));
    unkIn = ((sm.post == 125) & (sm.preClass == 4));
    tcOut = ((sm.pre == 125) & (sm.postClass == 2));
    allIn = (sm.post == 125);
    allOut = (sm.pre == 125);
    
    check1 = unkIn;
    
    pre1 = sm.pre(check1);
    post1 = sm.post(check1,:);
    pos1 = sm.pos(check1,:);
    pos2 = sm.pos(unkIn,:);
end

%% check other way
allEdges = obI.nameProps.edges
rgcs = obI.cell.name(obI.nameProps.rgc(obI.cell.mainObID));
tcrs = obI.cell.name(obI.nameProps.tcr(obI.cell.mainObID));
lins = obI.cell.name(obI.nameProps.lin(obI.cell.mainObID));
unks = obI.cell.name(obI.nameProps.unk(obI.cell.mainObID));

rawTypeList = zeros(max(allEdges(:)),1);
rawTypeList(rgcs) = 1;
rawTypeList(tcrs) = 2;
rawTypeList(lins) = 3;
rawTypeList(unks) = 4;



pos = cat(1,pos1,pos2);
type = cat(1,ones(size(pos1,1),1),ones(size(pos2,1),1)* 2);
num = size(pos,1);
scatter(pos(:,2),pos(:,1))


procType = zeros(size(sm.skelPos,1),1);
procType(sm.isShaft) = 1;
procType(sm.isTarg) = 2;
procType(sm.isAx) = 3;

%%motif to skeleton
mot2skel = zeros(num,1);
for i = 1:num
    
    dists = sqrt((sm.skelPos(:,1)-pos(i,1)).^2 + ...
        (sm.skelPos(:,2)-pos(i,2)).^2 + ...
        (sm.skelPos(:,3)-pos(i,3)).^2);
    
    mot2skel(i) = find(dists==min(dists),1);
    
end

scatter(sm.skelPos(sm.isAx,2),sm.skelPos(sm.isAx,1),'.','r')
hold on
scatter(sm.skelPos(sm.isTarg,2),sm.skelPos(sm.isTarg,1),'.','g')
scatter(sm.skelPos(sm.isShaft,2),sm.skelPos(sm.isShaft,1),'.','b')
scatter(sm.skelPos(mot2skel(type==1),2),sm.skelPos(mot2skel(type==1),1),'o','filled','m')
scatter(sm.skelPos(mot2skel(type==2),2),sm.skelPos(mot2skel(type==2),1),'o','filled','c')

hold off
pause(.1)

%% Measure real

s1 = sm.skelPos(sm.skelEdges(:,1),:);
s2 = sm.skelPos(sm.skelEdges(:,2),:);

skelLengths = sqrt((s1(:,1)-s2(:,1)).^2 + (s1(:,2)-s2(:,2)).^2 +(s1(:,3)-s2(:,3)).^2);
skelPos =(s1 + s2)/2;

shaftNodes = find(sm.isShaft);
targNodes = find(sm.isTarg);
axNodes = find(sm.isAx);


typeForMot1 = procType(mot2skel(type == 1));
typeForMot2 = procType(mot2skel(type == 2));


tot1 = sum(type==1)

cellNames = obI.cell.name(obI.cell.isCell>0);
partProcMot = post1(typeForMot1==3);
numPart = length(unique(intersect(cellNames,partProcMot)))


%partnerNum = length(unique(procType==1)

onShaft1 = sum(typeForMot1==1)
onTarg1 = sum(typeForMot1==2)
onAx1 = sum(typeForMot1==3)
onShaft2 = sum(typeForMot2==1);
onTarg2 = sum(typeForMot2==2);
onAx2 = sum(typeForMot2==3);

% onShaft1 = length(intersect(shaftNodes,mot2skel(type == 1)))
% onTarg1 = length(intersect(targNodes,mot2skel(type == 1)))
% onAx1 = length(intersect(axNodes,mot2skel(type == 1)))
% onShaft2 = length(intersect(shaftNodes,mot2skel(type == 2)));
% onTarg2 = length(intersect(targNodes,mot2skel(type == 2)));
% onAx2 = length(intersect(axNodes,mot2skel(type == 2)));




shaftRat = onShaft1/(onShaft1+onShaft2);
targRat = onTarg1/(onTarg1+onTarg2);
axRat = onAx1/(onAx1 + onAx2);

ratDif = targRat - shaftRat;

onShell1 = sum((sm.skelPos(mot2skel(type == 1),1)<250));
onCore1 = sum((sm.skelPos(mot2skel(type == 1),1)>300)) ;
onShell2 = sum((sm.skelPos(mot2skel(type == 2),1)<250));
onCore2 = sum((sm.skelPos(mot2skel(type == 2),1)>300)) ;
isShell = sum(( sm.skelPos(:,1)<250));
isCore = sum((sm.skelPos(:,1)>300)) ;
lengthShell = sum(skelLengths(skelPos(:,1) <250));
lengthCore = sum(skelLengths(skelPos(:,1) >300));
lengthAll = sum(skelLengths);

shellRat = onShell1/(onShell1 + onShell2);
coreRat = onCore1/(onCore1 + onCore2);

motDensityShell = onShell1/lengthShell;
motDensityCore = onCore1/lengthCore;

scDensRes = motDensityShell/motDensityCore;


return

%% Monte
reps = 100000;

onShaftRand = zeros(1,reps);
onTargRand = zeros(1,reps);
onAxRand = zeros(1,reps);

onShaft1Rand = zeros(reps,1); onTarg1Rand= zeros(reps,1);  coreRatRand = zeros(reps,1); shellRatRand = zeros(reps,1);
onCore2Rand = zeros(reps,1); onShell2Rand = zeros(reps,1); onShell2Rand = zeros(reps,1);
onCore1Rand = zeros(reps,1);  onShell1Rand = zeros(reps,1); axRatRand = zeros(reps,1);
targRatRand = zeros(reps,1); shaftRatRand = zeros(reps,1); onAx2Rand = zeros(reps,1); onTarg2Rand = zeros(reps,1);
onShaft2Rand = zeros(reps,1); onAx1Rand = zeros(reps,1); onTarg1Rand = zeros(reps,1); onShaft1Rand = zeros(reps,1);



for r = 1:reps
    
    mot2skelRand = randperm(size(sm.skelPos,1),num);
    
    scatter(sm.skelPos(sm.isAx,2),sm.skelPos(sm.isAx,1),'.','r')
    hold on
    scatter(sm.skelPos(sm.isTarg,2),sm.skelPos(sm.isTarg,1),'.','g')
    scatter(sm.skelPos(sm.isShaft,2),sm.skelPos(sm.isShaft,1),'.','b')
    scatter(sm.skelPos(mot2skelRand,2),sm.skelPos(mot2skelRand,1),'o','filled','m')
    hold off
    pause(.1)
    
    
    onShaft1Rand(r) = length(intersect(shaftNodes,mot2skelRand(type == 1)));
    onTarg1Rand(r) = length(intersect(targNodes,mot2skelRand(type == 1)));
    onAx1Rand(r) = length(intersect(axNodes,mot2skelRand(type == 1)));
    onShaft2Rand(r) = length(intersect(shaftNodes,mot2skelRand(type == 2)));
    onTarg2Rand(r) = length(intersect(targNodes,mot2skelRand(type == 2)));
    onAx2Rand(r) = length(intersect(axNodes,mot2skelRand(type == 2)));
    
    shaftRatRand(r) = onShaft1Rand(r)/(onShaft1Rand(r)+onShaft2Rand(r));
    targRatRand(r) = onTarg1Rand(r)/(onTarg1Rand(r)+onTarg2Rand(r));
    axRatRand(r) = onAx1Rand(r)/(onAx1Rand(r) + onAx2Rand(r));
    
    
    onShell1Rand(r) = sum((sm.skelPos(mot2skelRand(type == 1),1)>150) & ( sm.skelPos(mot2skelRand(type == 1),1)<250));
    onCore1Rand(r) = sum((sm.skelPos(mot2skelRand(type == 1),1)>300)) ;
    onShell2Rand(r) = sum((sm.skelPos(mot2skelRand(type == 2),1)>150) & ( sm.skelPos(mot2skelRand(type == 2),1)<250));
    onCore2Rand(r) = sum((sm.skelPos(mot2skelRand(type == 2),1)>300)) ;
    
    motDensityShellRand(r) = onShell1Rand(r)/lengthShell;
    motDensityCoreRand(r) = onCore1Rand(r)/lengthCore;
    
    shellRatRand(r) = onShell1Rand(r)/(onShell1Rand(r) + onShell2Rand(r));
    coreRatRand(r) = onCore1Rand(r)/(onCore1Rand(r) + onCore2Rand(r));
end



ratDifRand = targRatRand - shaftRatRand;

sortRatDifRand = sort(ratDifRand,'ascend');
mean(sortRatDifRand)
ci95 = [sortRatDifRand(round(reps*.025)) sortRatDifRand(round(reps * .975))]
P = mean(sortRatDifRand > ratDif)

scDensRes
scDensResRand = motDensityShellRand./motDensityCoreRand;

sortRatDifRand = sort(scDensResRand,'ascend');
mean(sortRatDifRand)
ci95 = [sortRatDifRand(round(reps*.025)) sortRatDifRand(round(reps * .975))]
P = mean(sortRatDifRand > scDensRes)


%%number on axon


onAx1
onAx1RandRand = sort(onAx1Rand,'ascend');
mean(onAx1RandRand)
ci95 = [onAx1RandRand(round(reps*.025)) onAx1RandRand(round(reps * .975))]
P = mean(onAx1RandRand > onAx1)














