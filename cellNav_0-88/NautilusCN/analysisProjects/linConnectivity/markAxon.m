



load('MPN.mat')
%nepFileName = sprintf('%snep\\skelNep%d.mat',MPN,skelList);

load([MPN 'obI.mat'])
load([MPN 'nep\skelNep125.mat'])
load([MPN 'nep\useSynPos125.mat'])
pos = nep.nodePos;
edges = nep.edges;
[edges pos] = doubleEdge(edges, pos);
edgeLength = getLengths(edges,pos);



obNam = obI.nameProps.names;
tags = {'125 ax' '125ax'}
isTagged = zeros(length(obNam),1);
for i = 1:length(obNam)
    for t= 1:length(tags)
        if sum(regexp(obNam{i},tags{t}));
            isTagged(i) = 1;
        end
    end
end

anch = obI.colStruc.anchors(isTagged>0,:);
    dSamp =  (obI.em.res .* [4 4 1])./1000;
    anch(:,1) = anch(:,1)*dSamp(1);
    anch(:,2) = anch(:,2)*dSamp(2);
    anch(:,3) = anch(:,3)*dSamp(3);
    
    
    
%Find distance to axon synapses   
pp = shortestPoint2Point(edges,pos,anch);    
dist2Ax = pp.topoMinDistBack;


%Find distance to RGC synapses
pp = shortestPoint2Point(edges,pos,useSynPos.fromRGC_dat);    
dist2RGC = pp.topoMinDistBack;

isAx = dist2Ax<(dist2RGC * .3);


%% plotrelative

scatter3(pos(:,1)+20,pos(:,2),pos(:,3),10,isAx*100,'filled');
axis off
hold off










    
tagSkel = points2nodeVal(pos,anch);
nodeVal = tagSkel.nodeVal;
useNodes = nodeVal * 0+1;
stopNode = find(nodeVal);
%startNode = 1:length(

report = node2nodeDist(edges,edgeLength,startNode,stopNode,maxLook)






aveDist = 25;

[nearVal rec] = averageNepProperties(edges,edgeLength,nodeVal,useNodes,aveDist,1);
vals = rec.vals;
density = zeros(length(vals),1);
for i = 1:length(vals)
    val = vals{i};
    if isempty(val)
        pause
    end
   density(i) = sum(val)/aveDist; 
end

tcrDensity = density;

%% plotrelative

cols = [tcrDensity * 2 rgcDensity *2 tcrDensity*0]+.2
cols(cols>1) = 1;


scatter3(pos(:,1)+20,pos(:,2),pos(:,3),10,cols,'filled');
axis off
hold off


