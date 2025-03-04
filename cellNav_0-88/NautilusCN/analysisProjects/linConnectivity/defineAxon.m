



load('MPN.mat')
%nepFileName = sprintf('%snep\\skelNep%d.mat',MPN,skelList);

load([MPN 'obI.mat'])
load([MPN 'nep\skelNep125.mat'])
load([MPN 'nep\useSynPos125.mat'])
pos = nep.nodePos;
edges = nep.edges;
[edges pos] = doubleEdge(edges, pos);
edgeLength = getLengths(edges,pos);



mark1 = [522.4 142.4 125.6];
mark2 = [524.8 141.2 126];

% 
% mark1 = [492.4 238.4 80.4];
% mark2 = [492 240.4 76.8];


scatter3(mark1(1),mark1(2),mark1(3))
pp = shortestPoint2Point(edges,pos,mark1); 
dist2mark1 = pp.topoMinDistBack;
pp = shortestPoint2Point(edges,pos,mark2);    
dist2mark2 = pp.topoMinDistBack;
isAx = dist2mark2<dist2mark1;


scatter3(pos(:,1),pos(:,2),pos(:,3),10,isAx*100,'filled');

axNodes = find(isAx);

isAxEdge = zeros(size(edges,1),1);
for e = 1:size(edges,1)
    if (sum(axNodes==edges(e,1)>0)) & (sum(axNodes==edges(e,2))>0)
        isAxEdge(e) = 1;
    end
end
axEdges = find(isAxEdge);

axLength = sum(edgeLength(axEdges))

%% show axon
plot3([pos(edges(:,1),1) pos(edges(:,2),1)]',...
    [pos(edges(:,1),2) pos(edges(:,2),2)]',...
    [pos(edges(:,1),3) pos(edges(:,2),3)]','color',[0 1 0]);
hold on
plot3([pos(edges(axEdges,1),1) pos(edges(axEdges,2),1)]',...
    [pos(edges(axEdges,1),2) pos(edges(axEdges,2),2)]',...
    [pos(edges(axEdges,1),3) pos(edges(axEdges,2),3)]','color',[1 0 0]);


axis off
grid off
set(gcf,'color',[0 0 0])
hold off


%% compare to synapses

points1 = useSynPos.synPos125toTCR;
points1 = points1(sum(points1,2)>1,:);

rgcOnSkel = points2nodeVal(pos,points1);
nodeVal = rgcOnSkel.nodeVal;

tcrOnSkel = points2nodeVal(pos,useSynPos.synPos125toTCR);
rgcOnSkel = points2nodeVal(pos,useSynPos.fromRGC_dat);
toLINonSkel = points2nodeVal(pos,useSynPos.synPos125toLIN);


sum(tcrOnSkel.nodeVal(axNodes))/sum(tcrOnSkel.nodeVal)
sum(rgcOnSkel.nodeVal(axNodes))/sum(rgcOnSkel.nodeVal)
sum(toLINonSkel.nodeVal(axNodes))/sum(toLINonSkel.nodeVal)



foundTCR = intersect(find(tcrOnSkel.nodeVal>0),axNodes);

hold on
scatter3(pos(foundTCR,1),pos(foundTCR,2),pos(foundTCR,3),'w','o','filled')
hold off










