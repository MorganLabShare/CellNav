if 0
    clear all
    load('MPN.mat');
    load([MPN 'obI.mat']);
    targCell = 125;
    maxDist = 5;
    iptsetpref('ImshowBorder','tight');
    
    load('D:\LGNs1\Analysis\sm.mat')
    
    
end

%% analyze Motifs


% save(['D:\LGNs1\Analysis\motifImages\listMotifWorkSpaceR.mat'])
% load(['D:\LGNs1\Analysis\motifImages\listMotifWorkSpaceR.mat'])

isTarg =(sm.pre == targCell) | (sm.post == targCell);
isRGC = sm.preClass == 1;
isTC = sm.postClass == 2;
isPreLIN = sm.preClass == 3;
isPostLIN = sm.postClass == 3;
isPreUNK = sm.preClass == 4;


%search all RGC input, check for non RGC TC
%search all LIN input, check for isolated LIN output
%search for all UNK input


%% find checkIn relative motifs



[checkRgc] = checkMotifAroundSyns(sm,find(isRGC & isTarg),maxDist);
[checkPreLin] = checkMotifAroundSyns(sm,find(isPreLIN & (sm.post == targCell)),maxDist);
[checkUnk] = checkMotifAroundSyns(sm,find(isPreUNK & isTarg),maxDist);
[checkPostLin] = checkMotifAroundSyns(sm,find(isPostLIN & (sm.pre == targCell)),maxDist);
[checkTc] = checkMotifAroundSyns(sm,find(isTC & isTarg),maxDist);

sum([checkRgc.m.syn2skelDi]>0)
sum([checkRgc.m.diadTCs]>0)
sum([checkRgc.m.preTcDi]>0)



motifCodes = [...
    '1 = RGC only, 2 = TC only, 3 = LINin only, 4 = LINout only, 5 = UNKin only, ' ...
    '6 = recip, 7 = autapse,'...
    '8 = RGC-LIN-TC diad, 9 = RGC-LIN-TC triad, 10 = RGC-LIN-TC mult triad, ' ...
    '11 = RGC-LIN-LIN diad, 12 = RGC-LIN-LIN IN triad,  13 = RGC-LIN-LIN out triad, 14 = RGC-LIN-LIN recip triad, ' ...
    '15 = LIN1-LIN-TC diad (top), 16 = LIN-LIN1-TC diad (mid), '...
    '17 = LIN1-LIN-TC triad(top), 18 = LIN-LIN1-TC triad(mid), 19 = LIN-LIN-TC recip triad, '...
    '20 = LLL diad, 21 = LLL tri top, 22 = LLL tri mid, 23 = LLL tri bot, 24 = LLL recip triad, '...
    '25 = UNK-LIN-TC(diad), 26 = UNK-LIN-TC triad, 27 = LIN-TC without RGC, 28 = LIN-TC with near RGC, diad'];



%% classify motifs


for i = 1:30, mPos{i} = []; end

for i = 1:length(checkRgc.m)
    m = checkRgc.m(i);
    if m.goodPos
        if m.preOnly
            mPos{1} = [mPos{1};checkRgc.pos(i,:)];
        elseif m.preTcTri
            mPos{9} = [mPos{9};checkRgc.pos(i,:)];
        elseif m.diadTCs;%preTcDi
            mPos{8} = [mPos{8};checkRgc.pos(i,:)];
        end
        
        
       if m.preLinOutTri
            mPos{12} = [mPos{12};checkRgc.pos(i,:)]; 
       elseif m.diadToLIN
            mPos{11} = [mPos{11};checkRgc.pos(i,:)];
       end
       if m.preLinInTri
            mPos{13} = [mPos{13};checkRgc.pos(i,:)];
        end
        
        
        %     if m.preOnly
        %         mPos{1} = [mPos{1};checkRgc.pos(i,:)];
        %     else
        %         if m.preTcTri
        %             mPos{9} = [mPos{9};checkRgc.pos(i,:)];
        %         elseif m.preTcDi
        %             mPos{8} = [mPos{8};checkRgc.pos(i,:)];
        %         elseif m.closePostTC
        %             mPos{8} = [mPos{8}; checkRgc.pos(i,:)]
        %         end
        %         if m.preLinDi
        %             mPos{11} = [mPos{11};checkRgc.pos(i,:)];
        %         elseif m.preLinInTri
        %             mPos{13} = [mPos{13};checkRgc.pos(i,:)];
        %         elseif m.preLinOutTri
        %             mPos{12} = [mPos{12};checkRgc.pos(i,:)];
        %         end
        %     end
    end
end

for i = 1:length(checkPreLin.m)
    m = checkPreLin.m(i);
    if m.goodPos
        if m.preOnly
            mPos{3} = [mPos{3};checkPreLin.pos(i,:)];
        elseif m.preTcTri
            mPos{18} = [mPos{18};checkPreLin.pos(i,:)];
        elseif m.diadTCs;%preTcDi
            mPos{16} = [mPos{16};checkPreLin.pos(i,:)];
        end
        if m.diadToLIN;%preLinDi
            mPos{20} = [mPos{20};checkPreLin.pos(i,:)];
        end
        if m.preLinInTri
            mPos{23} = [mPos{23};checkPreLin.pos(i,:)];
        end
        if m.preLinOutTri
            mPos{22} = [mPos{23};checkPreLin.pos(i,:)];
        end
    end
end

for i = 1:length(checkUnk.m)
    m = checkUnk.m(i);
    if m.goodPos
        if m.preOnly
            mPos{5} = [mPos{5};checkUnk.pos(i,:)];
        elseif m.preTcTri
            mPos{26} = [mPos{26};checkUnk.pos(i,:)];
        elseif m.diadTCs;%preTcDi
            mPos{25} = [mPos{25};checkUnk.pos(i,:)];
        end
        if m.preLinDi
            mPos{27} = [mPos{27};checkUnk.pos(i,:)];
        end
        if m.preLinInTri
            mPos{28} = [mPos{28};checkUnk.pos(i,:)];
        elseif m.preLinOutTri
            mPos{29} = [mPos{29};checkUnk.pos(i,:)];
        end
    end
end

for i = 1:length(checkPostLin.m)
    m = checkPostLin.m(i)
    if m.goodPos
        if m.preOnly
            mPos{4} = [mPos{4};checkPostLin.pos(i,:)];
        end
        if m.preTcTri
            mPos{17} = [mPos{17};checkPostLin.pos(i,:)];
        elseif m.diadTCs; %preLinDi
            mpfos{15} = [mPos{15};checkPostLin.pos(i,:)];
        end
        if m.recTcTri
            mPos{19} = [mPos{19};checkPostLin.pos(i,:)];
        elseif m.recRgcTri
            mPos{14} = [mPos{14};checkPostLin.pos(i,:)];
        elseif m.recLinInTri
            mPos{24} = [mPos{24};checkPostLin.pos(i,:)];
        elseif m.recLinOutTri
            mPos{24} = [mPos{24};checkPostLin.pos(i,:)];
        elseif m.recLinInOut
            mPos{24} = [mPos{24};checkPostLin.pos(i,:)];
        elseif m.recLinOutIn
            mPos{24} = [mPos{24};checkPostLin.pos(i,:)];
        end
        if m.reciprocal
            mPos{6} = [mPos{6};checkPostLin.pos(i,:)];
        end
        if m.autapse
            mPos{7} = [mPos{7};checkPostLin.pos(i,:)];
        end
    end
end

for i = 1:length(checkTc.m)
    m = checkTc.m(i);
    if m.goodPos
        if m.postOnly
            mPos{2} = [mPos{2};checkTc.pos(i,:)];
        end
        if m.closePreRGC ==0
            mPos{27} = [mPos{27}; checkTc.pos(i,:)];
        
        else
            mPos{28} = [mPos{28}; checkTc.pos(i,:)]; %diad from TC
        end
        
    end
end

%% shaft not shaft
%1 = RGC only,
%'8 = RGC-LIN-TC diad, 9 = RGC-LIN-TC triad, 10 = RGC-LIN-TC mult triad, '

group1 = mPos{27};
group2 = cat(1,mPos{[28]});

group1 = group1(sum(group1,2)>0,:);
group2 = group2(sum(group2,2)>0,:);


shaftSub = sm.shaftSub;
distThresh = 4;

isAx1 = zeros(size(group1,1),1,'logical'); isTarg1 = isAx1; isShaft1 = isAx1;

for i = 1:size(group1,1);
    distsTarg = sqrt((sm.targSub(:,1) - group1(i,1)).^2 + (sm.targSub(:,2)-group1(i,2)).^2 + ...
        (sm.targSub(:,3)-group1(i,3)).^2);
    distsAx = sqrt((sm.axSub(:,1) - group1(i,1)).^2 + (sm.axSub(:,2)-group1(i,2)).^2 + ...
        (sm.axSub(:,3)-group1(i,3)).^2);
    if min(distsAx)<distThresh
        isAx1(i) = 1;
    elseif min(distsTarg)<distThresh
        isTarg1(i) = 1;
    else
        isShaft1(i) = 1;
    end
end

isAx2 = zeros(size(group2,1),1,'logical'); isTarg2 = isAx2; isShaft2 = isAx2;
for i = 1:size(group2,1);
    distsTarg = sqrt((sm.targSub(:,1) - group2(i,1)).^2 + (sm.targSub(:,2)-group2(i,2)).^2 + ...
        (sm.targSub(:,3)-group2(i,3)).^2);
    distsAx = sqrt((sm.axSub(:,1) - group2(i,1)).^2 + (sm.axSub(:,2)-group2(i,2)).^2 + ...
        (sm.axSub(:,3)-group2(i,3)).^2);
    if min(distsAx)<distThresh
        isAx2(i) = 1;
    elseif min(distsTarg)<distThresh
        isTarg2(i) = 1;
    else
        isShaft2(i) = 1;
    end
end

shaftNoRGC = sum(isShaft1);
targNoRGC = sum(isTarg1);
shaftRGC = sum(isShaft2);
targRGC = sum(isTarg2);
axNoRGC = sum(isAx1);
axRGC = sum(isAx2);

shaftSyn = [isShaft1(isShaft1)-1; isShaft2(isShaft2)];
targSyn = [isTarg1(isTarg1)-1; isTarg2(isTarg2)];

mean(shaftSyn)
mean(targSyn)
sum(shaftSyn)
sum(targSyn)

ranksum(shaftSyn,targSyn)



if 1
    hold off
    scatter3(sm.shaftSub(:,1),sm.shaftSub(:,2),...
        sm.shaftSub(:,3),180,'b','.');
    hold on
    scatter3(sm.axSub(:,1),sm.axSub(:,2),...
        sm.axSub(:,3),180,'r','.');
    scatter3(sm.targSub(:,1),sm.targSub(:,2),...
        sm.targSub(:,3),180,'g','.');
    
    scatter3(group1(isShaft1,1),group1(isShaft1,2),...
        group1(isShaft1,3),180,'b','o');
    scatter3(group1(isTarg1,1),group1(isTarg1,2),...
        group1(isTarg1,3),180,'g','o');
    
    scatter3(group2(isShaft2,1),group2(isShaft2,2),...
        group2(isShaft2,3),180,'b','d');
    scatter3(group2(isTarg2,1),group2(isTarg2,2),...
        group2(isTarg2,3),180,'g','d');
    
    hold off
    
end

%% Convergence rate

postTC = (sm.pre == 125) & (sm.postClass == 2);
postTCpos = sm.pos(postTC>0,:);
postTCid = sm.post(postTC>0,:);
postTCcon = postTCid*0;
for i = 1:length(postTCcon)
    postTCcon(i) = sum(postTCid==postTCid(i));
end


isAx = zeros(size(postTCpos,1),1,'logical'); isTarg = isAx; isShaft = isAx;
for i = 1:size(postTCpos,1);
    distsTarg = sqrt((sm.targSub(:,1) - postTCpos(i,1)).^2 + (sm.targSub(:,2)-postTCpos(i,2)).^2 + ...
        (sm.targSub(:,3)-postTCpos(i,3)).^2);
    distsAx = sqrt((sm.axSub(:,1) - postTCpos(i,1)).^2 + (sm.axSub(:,2)-postTCpos(i,2)).^2 + ...
        (sm.axSub(:,3)-postTCpos(i,3)).^2);
    if min(distsAx)<distThresh
        isAx(i) = 1;
    elseif min(distsTarg)<distThresh
        isTarg(i) = 1;
    else
        isShaft(i) = 1;
    end
end

axCon = postTCcon(isAx);
shaftCon = postTCcon(isShaft);
targCon = postTCcon(isTarg);

ranksum(shaftCon>1,targCon>1)
ranksum(shaftCon,targCon)
ranksum(axCon>1,targCon>1)

%stop code here



%% find clusters

%distances between skeleton points
sPos = sm.skelPos;
sDist = sqrt((sPos(:,1)-sPos(:,1)').^2 +  (sPos(:,2)-sPos(:,2)').^2 + ...
    (sPos(:,3)-sPos(:,3)').^2 ); % distance to other points on arbor
minClust = 3;
clustDist = 5;
clear clust
for i =  1:length(mPos)
    pos = mPos{i};
    
    if ~isempty(pos)
        dist = sqrt((pos(:,1)-sPos(:,1)').^2 +  (pos(:,2)-sPos(:,2)').^2 + ...
            (pos(:,3)-sPos(:,3)').^2 ); %distance to motif
        nearNum = sum(dist<=clustDist,1);
        eraseNum = nearNum;
        keepNum = nearNum * 0;
        c = 0;
        while sum(eraseNum)
            c = c + 1;
            targMax = find(eraseNum == max(eraseNum),1);
            keepNum(targMax) = nearNum(targMax); %record peak
            eraseNum(sDist(:,targMax)<(clustDist*2)) = 0; %erase nearby
        end
        isClust = find(keepNum>=minClust);
        clust(i).pos = sPos(isClust,:);
        clust(i).val = keepNum(isClust);
        
    else
        clust(i).pos = [];
        clust(i).val = [];
    end
    
end


%%find clustered

%distances between skeleton points
sPos = sm.skelPos;
sDist = sqrt((sPos(:,1)-sPos(:,1)').^2 +  (sPos(:,2)-sPos(:,2)').^2 + ...
    (sPos(:,3)-sPos(:,3)').^2 ); % distance to other points on arbor
minClust = 3;
clustDist = 5;
for i =  1:length(mPos)
    pos = mPos{i};
    if ~isempty(pos)
        dist = sqrt((pos(:,1)-pos(:,1)').^2 +  (pos(:,2)-pos(:,2)').^2 + ...
            (pos(:,3)-pos(:,3)').^2 );
        %distance to motif
        nearNum = sum(dist<=clustDist,1);
        mClust{i} = nearNum>=(minClust );
    else
        mClust{i} = [];
    end
end

%% Show result

obMovDir = 'D:\LGNs1\Analysis\motifImages\batch16rev\'
if ~exist(obMovDir),mkdir(obMovDir);end

% save(['D:\LGNs1\Analysis\motifImages\listMotifWorkSpace.mat'])
% load(['D:\LGNs1\Analysis\motifImages\listMotifWorkSpace.mat'])

oneAtATime = 2; % one for each motife.  2 for multiple motifs in the same image
shouldWrite = 1;
motNum = 30;
skelWidth = 4;
circSize = 80^2;
circWidth = 4;
skelCol = [1 0 0];
markWidth  = 5;

if ~exist(obMovDir,'dir'), mkdir(obMovDir);end

motText = {'1r' '1t' '1li' '1lo' '1u' '2b' '2a' '3d' '3t' '3m'...
    '4d' '4t' '4t'  '4r'  '5d' '5d' '5t' '5t' '5r' '5d'...
    '6t' '6m' '6b'  '6r'  '7d' '7t' '7l' '7l' '7l' '0'};

if oneAtATime == 1
    motCol = {'w' 'w' 'w' 'w' 'w' 'w' 'w' 'w' 'w' 'w'...
        'w' 'w' 'w'  'w'  'w' 'w' 'w' 'w' 'w' 'w'...
        'w' 'w' 'w'  'w'  'w' 'w' 'w' 'w' 'w' 'w'};
    for i = 1:motNum, motCol{i} = 'r'; end
    for i = 1:motNum, clustCol{i} = [0 0 1]; end
    
    motMark = {'p' 'p' 'p' 'p' 'p' 'p' 'p' 'p' 'p' 'p'...
        'p' 'p' 'p'  'p'  'p' 'p' 'p' 'p' 'p' 'p'...
        'p' 'p' 'p'  'p'  'p' 'p' 'p' 'p' 'p' 'p'};
    for i = 1:motNum, motMark{i} = 'o'; end
    
    motSize = [200 200 200 200 200 200 200 200 200 200 ...
        200 200 200  200  200 200 200 200 200 200 ...
        200 200 200  200  200 200 200 200 200 200];
    for i = 1:motNum, motSize(i) =40^2; end
    
    for i = 1:motNum, motSize(i) = 30^2; end
    motSize(7) = 40^2;
    for i = 1:motNum, motCol{i} = [.5 1 1]; end
    for i = 1:motNum, clustCol{i} = [0 0 1]; end
    for i = 1:motNum, edgeCol{i} = [0 0 0]; end
    
    showClust = [];
    
elseif oneAtATime == 0
    
    motCol = {'g' 'b' 'r' 'r' [1 .5 0] 'r' 'w' 'c' 'c' 'c'...
        'y' 'y' 'y'  'y'  'm' 'm' 'm' 'm' 'm' 'm'...
        'r' 'r' 'r'  'r'  [1 .5 1] [1 .5 1] [1 .5 0] [1 .5 0] 'm' 'w'};
    clustCol = motCol;
    
    motMark = {'o' 'o' 'o' 'o' 'o' 'p' 'p' 's' '^' '^'...
        's' '^' '^'  '^'  's' 's' 'v' '^' '^' 's'...
        'v' '^' '^'  '^'  's' '^' '^' '^' '^' 'o'};
    
    
    motSize = [50 50 50 50 50 90 1000 60 200 100 ...
        60 100 100  100  60 60 200 100 100 60 ...
        200 100 100  100  60 100 100 100 100 10];
    
    showClust = [];
    
elseif oneAtATime == 2;
    
    motCol = {'g' 'b' 'r' 'r' [1 .5 0] 'r' 'w' 'c' 'c' 'c'...
        'y' 'y' 'y'  'y'  'm' 'm' 'm' 'm' 'm' 'm'...
        'r' 'r' 'r'  'r'  [1 .5 1] [1 .5 1] [1 .5 0] [1 .5 0] 'm' 'w'};
    clustCol = motCol;
    
    motMark = {'o' 'o' 'o' 'o' 'o' 's' 'p' 's' '^' '^'...
        's' '^' '^'  '^'  's' 's' '^' '^' '^' 's'...
        '^' '^' '^'  '^'  's' '^' '^' '^' '^' 'o'};
    
    for i = 1:motNum, motSize(i) = 30^2; end
    motSize(7) = 70^2;
%     motSize(8) = 20^2;
%     motSize(9) = 20^2;
    for i = 1:motNum, motCol{i} = [.5 1 1]; end
    for i = 1:motNum, clustCol{i} = [0 0 1]; end
    for i = 1:motNum, edgeCol{i} = [0 0 0]; end
    
    showClust = [];
    
    motGroup = [8 9]; %RGC
      motGroup = [25 26]; % UNK
      motGroup = [16 18]; %Lin Lin
      motGroup = [15 17]; %Lin Lin Targ on top
%       motGroup = [6 7]; %Lin Lin Targ on top
%       motGroup = [11 12]; %rgc Lin Targ on top
%     
end



hold off
% scatter3(sm.skelNodes(:,1),sm.skelNodes(:,2),sm.skelNodes(:,3),10,'filled',...
%     'markerfacecolor',[0 0 0]);

sPos = sm.skelPos;
edges = sm.skelEdges;
% plot3([sPos(edges(:,1),1) sPos(edges(:,2),1)]',...
%     [sPos(edges(:,1),2) sPos(edges(:,2),2)]',...
%     [sPos(edges(:,1),3) sPos(edges(:,2),3)]','color',skelCol,...
%     'linewidth',skelWidth);

%% render cell
cellSurf = 'D:\LGNs1\mergeSeg_mat\FVFiles\Patch_dSamp4_cell_125.mat';
cellSurf = 'D:\LGNs1\mergeSeg_mat\FVFiles\Patch_dSamp2_cell2_125.mat';
cellSurf = 'D:\LGNs1\mergeSeg_mat\FVFiles\LIN125_procType.mat';



load(cellSurf)
hold off
scatter3([],[],[])
renderFVs(typeFV);
axis vis3d;
daspect([1,1,1])
axis tight
clight = camlight
lighting gouraud

hold on
set(gca,'Ydir','reverse')



%% run motifs

%
% axis vis3d;
% daspect([1,1,1])
% axis tight
% clight = camlight
% lighting gouraud
% set(gca,'Ydir','reverse')
% hold on
% showMot = [1]

if oneAtATime == 2
    runPos = motGroup;
else
    runPos = [1:length(mPos)];
end

for r =  1:length(runPos)
    disp(sprintf('showing %d of %d',r,length(runPos)))
    i = runPos(r);
    
    if oneAtATime == 1
        hold  off
        scatter3([],[],[])
        
        %         plot3([sPos(edges(:,1),1) sPos(edges(:,2),1)]',...
        %             [sPos(edges(:,1),2) sPos(edges(:,2),2)]',...
        %             [sPos(edges(:,1),3) sPos(edges(:,2),3)]','color',skelCol,...
        %             'linewidth',skelWidth);
        renderFVs(typeFV);
        
        %patch(fv)
        axis vis3d;
        daspect([1,1,1])
        axis tight
        clight = camlight
        lighting gouraud
        
        hold on
        set(gca,'Ydir','reverse')
    end
    %     else
    %
    %         scatter3([],[],[])
    %         axis vis3d;
    %         daspect([1,1,1])
    %         axis tight
    %         clight = camlight
    %         lighting gouraud
    %
    %         hold on
    %         set(gca,'Ydir','reverse')
    %
    %     end
    
    tag = motText{i};
    pos = mPos{i};
    % pos = pos(:,[ 2 1 3]);
    if ~isempty(pos)
        if sum([6 7] == i)
            use = (mClust{i} * 0)>0;
        else
            use = mClust{i};
        end
        scatter3(pos(use,1),pos(use,2),pos(use,3),motSize(i),'marker',motMark{i},...
            'MarkerFaceAlpha',.8 ,'MarkerEdgeAlpha',.8,...
            'markerfacecolor',motCol{i}, 'markeredgecolor',edgeCol{i},'linewidth',markWidth)
        scatter3(pos(~use,1),pos(~use,2),pos(~use,3),motSize(i),'marker',motMark{i},...
            'MarkerFaceAlpha',.4,'MarkerEdgeAlpha',.8,...
            'markerfacecolor',[.5 .5 .5],'markeredgecolor','k','linewidth',markWidth)
        %         scatter3(pos(~use,1),pos(~use,2),pos(~use,3),motSize(i),'marker',motMark{i},...
        %             'markerfacecolor',[.5 .5 .5],'markeredgecolor','k','linewidth',markWidth)
    end
    
    pos = clust(i).pos;
    if ~isempty(pos) & sum(showClust==i)
        scatter3(pos(:,1),pos(:,2),pos(:,3),circSize,...
            'markeredgecolor',clustCol{i},'linewidth',circWidth)
    end
    
    motStr = sprintf('%d %s m%d c%d' ,i,tag,size(mPos{i},1),size(clust(i).pos,1));
    
    %%Show figure
    %[an el ] = view(gca);
    
    an = -115.8;
    el = -15.6;
    
    an = -90;
    el = -90;
    lightangle(clight,an,el)
    set(gca,'view',[an el])
    set(gcf,'color',[1 1 1])
    set(gca,'color',[1 1 1])
    
    axis off
    ax = gca;
    ax.Clipping = 'on';
    set(gcf,'units','pixels','outerposition',[0 0 900 1000]);
    %set(gca,'box','off')
    set(gca,'position',[-.00 -.05 1.15 1.15])
    set(gca,'position',[-.05 -.05 1.1 1.1])
    
    set(gcf,'PaperUnits','points','PaperPosition',[1 1 1024 1024])
    set(gcf, 'InvertHardCopy', 'off');
    
    pause(.01)
    if (oneAtATime == 1) & shouldWrite
        text(120,350,[num2str(i) ' -' num2str(size(pos,1))],'color',[0 0 0])
        text(130,350,motStr,'color',[0 0 0])
        %title([num2str(i) ' -' num2str(size(pos,1))],'color','k')
        imageName = sprintf('%smot%d.png',obMovDir,i);
        print(gcf,imageName,'-dpng','-r512','-opengl','-noui')
    end
    
    
end

if (oneAtATime == 0) & shouldWrite
    imageName = sprintf('%sallMot.png',obMovDir);
    print(gcf,imageName,'-dpng','-r128','-opengl','-noui')
elseif (oneAtATime == 2) & shouldWrite
        motStr = sprintf('%d m%d c%d' ,motGroup(1),size(mPos{motGroup(1)},1),size(clust(motGroup(1)).pos,1));
        text(130,350,motStr,'color',[0 0 0])
        motStr = sprintf('%d m%d c%d' ,motGroup(2),size(mPos{motGroup(2)},1),size(clust(motGroup(2)).pos,1));
        text(140,350,motStr,'color',[0 0 0])
        
    imageName = sprintf('%smot_%d_%d.png',obMovDir,motGroup(1),motGroup(2));
    print(gcf,imageName,'-dpng','-r128','-opengl','-noui')
end





%
%
% outerpos = ax.OuterPosition;
% ti = ax.TightInset;
% left = ti(1) ;
% bottom = ti(2) ;
% ax_width = ti(3) ;
% ax_height = ti(4);
% ax.Position = [left bottom ax_width ax_height];






