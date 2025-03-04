

clear all
load('MPN.mat')
load([MPN 'obI.mat']);
mot = getMotifs(obI);
synStruct = getSynMat(obI);
%anaMot = analyzeMotifs(obI);

allEdges = obI.nameProps.edges;
tri = mot.tri;
numTri = size(tri.triCell,1);
tcrs = mot.cel.types.tcrs;
rgcs = mot.cel.types.rgcs;

%% Get skel

load([MPN 'nep\skelNep125.mat'])
skelPos = nep.nodePos;
skelEdges = nep.edges;
[skelEdges skelPos] = doubleEdge(skelEdges,skelPos,2);



%% find *t experiments
names = obI.nameProps.names;
tag = '125 part 9';
clear nameTag tagged
c = 0;
for i = 1:length(names)
    nam = names{i};
    hit = regexp(nam, tag);
    if sum(hit) & (nam(end) == 't')
        c = c+1;
        nameTag{c} = nam;
        tagged(c) = i;
    end
end

%% 


toTCR = zeros(size(allEdges,1),1);
for i = 1:size(allEdges,1)
    toTCR(i,1) = sum(tcrs == allEdges(i,1))>0;
end

fromRGC = zeros(size(allEdges,1),1);
for i = 1:size(allEdges,1)
    fromRGC(i,1) = sum(rgcs == allEdges(i,2))>0;
end

% is125 = (allEdges(:,1)==125) | (allEdges(:,2) == 125);
% tags125 = allEdges(is125,3);
anchors = obI.colStruc.anchors;
dSamp =  (obI.em.res .* [4 4 1])./1000;
anchors(:,1) = anchors(:,1)*dSamp(1);
anchors(:,2) = anchors(:,2)*dSamp(2);
anchors(:,3) = anchors(:,3)*dSamp(3);
%anchors = round(anchors);
anchors(anchors<1) = 1;


sampleObjs = [];
for i = 1:length(tagged)
        targ = find(allEdges(:,3) == tagged(i));
        if fromRGC(targ)
            sampleObjs = [sampleObjs; tagged(i)];
        end
end




for i = 1:length(sampleObjs)
    
    hold off
    scatter3(skelPos(:,1),skelPos(:,2),skelPos(:,3),'k','.')
    hold on
    nameTag{i}
    
    targ = find(allEdges(:,3) == sampleObjs(i));
    edge = allEdges(targ,1:2);
    anch = anchors(sampleObjs(i),:);
    tNum = 0;  % number of triads found
    triDists = [];
    triInfo(i).RGCtoLINpos = anch;
    triInfo(i).edge = edge;
    
    
                   scatter3(anch(:,1),anch(:,2),anch(:,3),200,'r','filled')
 
    %% Find TC
    isPost = allEdges(:,2) == edge(2);
    isPostTCR = isPost & toTCR;
    toTCRpos = anchors(allEdges(isPostTCR,3),:);
    if isempty(toTCRpos)
       toTCRdists{i} = []; 
    else
        toTCRdists{i} = sqrt((toTCRpos(:,1) - anch(1)).^2 + ...
            (toTCRpos(:,2) - anch(2)).^2 + (toTCRpos(:,3) - anch(3)).^2);
    end
    scatter3(toTCRpos(:,1),toTCRpos(:,2),toTCRpos(:,3),150,'m','s','filled')
    
    
    
    
    %% check triad
    clear triDists topoDist12_23
    for t = 1:numTri % run the triad
        
        hit = (tri.triCell(t,1) == edge(2)) & ...
            (tri.triCell(t,2) == edge(1));
        if hit %% if it is the right RGC to LIN identity
            tNum = tNum+1;
            triInfo(i).hit(tNum) = t;
            triInfo(i).triCell(tNum,:) = tri.triCell(t,:);

            
            %% find nearest RGC in
            prePos = tri.synPos{t,1};
            

            dist = sqrt((prePos(:,1)-anch(1)).^2 + ...
                (prePos(:,2)-anch(2)).^2 + ...
                (prePos(:,3)-anch(3)).^2);
            minDist = min(dist);
            sameIn = find(dist==minDist,1);
            pos12 = prePos(sameIn,:);
                    
            %scatter3(prePos(:,1),prePos(:,2),prePos(:,3),100,'y','filled')
            %scatter3(pos12(:,1),pos12(:,2),pos12(:,3),100,'k','d')
    
            if size(prePos,1)>1
               'bark'
            end
        
            %% find nearest LIN to TC
            
            prePos = tri.synPos{t,3};
            dist = sqrt((prePos(:,1)-pos12(1)).^2 + ...
                (prePos(:,2)-pos12(2)).^2 + ...
                (prePos(:,3)-pos12(3)).^2);
            minDist = min(dist);
            sameIn = find(dist==minDist,1);
            pos13 = prePos(sameIn,:);
            
            scatter3(pos13(:,1),pos13(:,2),pos13(:,3),100,'b','filled')

            
            %% find nearest RGC to TC
        
            prePos = tri.synPos{t,2};
            dist = sqrt((prePos(:,1)-pos12(1)).^2 + ...
                (prePos(:,2)-pos12(2)).^2 + ...
                (prePos(:,3)-pos12(3)).^2);
            minDist = min(dist);
            sameIn = find(dist==minDist,1);
            pos23 = prePos(sameIn,:);
            
           %scatter3(pos13(:,1),pos13(:,2),pos13(:,3),100,[0 .7 0],'filled')

            %% Get triad distances
            eshift = tri.edgeOrder;    
            triOrd = '12 - 13, 12 - 23, 13 - 23';
            
            dist12_13 = sqrt((pos12(1)-pos13(1))^2 + ...
                (pos12(2)-pos13(2))^2 + ...
                (pos12(3)-pos13(3))^2);
            
            dist12_23 = sqrt((pos12(1)-pos23(1))^2 + ...
                (pos12(2)-pos23(2))^2 + ...
                (pos12(3)-pos23(3))^2);
            
            dist13_23 = sqrt((pos13(1)-pos23(1))^2 + ...
                (pos13(2)-pos23(2))^2 + ...
                (pos13(3)-pos23(3))^2);
            
            triDists(tNum,:) = [dist12_13 dist12_23 dist13_23] ;
            
            
            pp = shortestPoint2Point(skelEdges,skelPos,pos12,pos23 );
            topoDist12_23(tNum) = pp.minMax;
            
%             scatter3(skelPos(:,1),skelPos(:,2),skelPos(:,3),3,'k')
%             hold on
%             scatter3(skelPos(pp.topo.path(:,1),1),skelPos(pp.topo.path(:,1),2),skelPos(pp.topo.path(:,1),3),10,'r')
%                  hold off

        end

        
    end
    
    if tNum
        triTagged(i).is = 1;
        triTagged(i).triDists = triDists;
        triTagged(i).topoDist = topoDist12_23;
        topoDist12_23
pause(.01)
    else
        triTagged(i).is = 0;
    end
    
    
end

hold off


%% Pick

allMax = 5; %Maximum distance of link for triad

taggedNum = length(triTagged);
anyTri = sum([triTagged.is]);

clear allTri closeTri closest
for i = 1:length(triTagged)
    

    
    if isempty(toTCRdists{i})
        closestTCR(i) = inf;
    else
        closestTCR(i) = min(toTCRdists{i});
    end
    
   %% analyze triad
   if triTagged(i).is
   dists = triTagged(i).triDists
   %passThresh = sum(sum(dists<=allMax,2)==3,1)>0;
   passThresh = sum((dists(:,1)<=allMax),2)>0; % both RGC synapses must be withing 5 um
   useDist = find(passThresh);
   if isempty(useDist)
       allTri(i) = 0;
       closeTri(i) = 0;
       closest(i) = inf;
       closestLinRun(i) = inf;
   else
       allTri(i) = size(dists,1);
       closeTri(i) = length(useDist);
       closest(i) = min(max(dists(useDist,:),[],2),[],1);
       %closestLinRun(i) = min(dists(useDist,2));
       closestLinRun(i) = min(triTagged(i).topoDist(useDist));% min(dists(:,2)); %!!!!!!!!!!!
        
   end
   else
       allTri(i) = 0;
       closeTri(i) = 0;
       closest(i) = inf;
       closestLinRun(i) = inf;
   end
    
   
end
%% check outliers
tooLong = find((closestLinRun<1000)&(closestLinRun>50));
tooMany = find(closeTri>5)

%% has TCR
hasTCR = closestTCR<allMax;
percentClose = sum(hasTCR)/length(closestTCR)

ce = closestTCR(closestTCR<10000);
closeRange = [0:1:50  1000];
histClosest = histc(ce,closeRange)/length(ce);
bar(closeRange,histClosest,'k')
xlim([-5 20])


%% has triad
histRange = 0:6;

hasTriad = closeTri>0;
[closestTCR' closeTri' ]
histClose = hist(closeTri(hasTCR),histRange)/sum(hasTCR);

%bar(histRange,[histAll;histClose]')
percentTri = sum(closeTri(hasTCR)>0)/sum(hasTCR)

bar(histRange,histClose,'k')



%% Show closest LIN run

useTriad = hasTriad & hasTCR;
ce = closestLinRun(useTriad);
closeRange = [0:1:50  1000];
histClosest = histc(ce,closeRange)/length(ce);
bar(closeRange,histClosest,'k')
xlim([-5 20])

percentWithin = sum(ce<=5)/length(ce)





%% plot for all triads
isTri = cat(1,triTagged.is);
 allTriDist = cat(1,triTagged(isTri>0).triDists);
 
 useTri = (allTriDist(:,1)< 5) & (allTriDist(:,2)<1000)
 useDists = allTriDist(useTri,2);
 

ce = useDists;
closeRange = [0:1:600];
histClosest = histc(ce,closeRange)/length(ce);
bar(closeRange,histClosest,'k')
xlim([-5 300])



















