
load('MPN.mat')

load('D:\LGNs1\mergeSeg_mat\nep\paintWidth.mat');
load([MPN 'nep\skelNep125.mat'])



pos = nep.nodePos;
edges = nep.edges;
[edges pos] = doubleEdge(edges,pos)

points1 = paintWidth.cents;
widths = paintWidth.widths;

scatter3(pos(:,1),pos(:,2),pos(:,3),'k','o');
hold on
scatter3(points1(:,1),points1(:,2),points1(:,3),10,widths*10);
hold off

widthRec = points2nodeVal(pos,points1,widths);
isNode1 = widthRec.isNode;

%% fetch values

nodeWidth = zeros(size(pos,1),1);
for i = 1:size(pos,1)
    hit = find(isNode1 == i);
    if isempty(hit)
        nodeWidth(i) = 0;
    else
        vals = widths(hit);
        nodeWidth(i) = max(vals);
    end
end
cmap = jet(100)
cVal = round(nodeWidth*100);
cVal(cVal>100) = 100;
cVal(cVal<1) = 1;

useNodes = nodeWidth>0;
cols = val2cmap(nodeWidth(useNodes)*100);
scatter3(pos(useNodes,1),pos(useNodes,2),pos(useNodes,3),10,cols,'filled');

%% average node properteis
aveDist = 20;
edgeLength = getLengths(edges,pos);

[aveWidth recWidth] = averageNepProperties(edges,edgeLength,nodeWidth,useNodes,aveDist,1);

meanFirstQuart = nodeWidth * 0;
vals = recWidth.vals;
for i = 1:length(vals)
   val = vals{i}; 
   sampVal = sort(val,'ascend');
   sampVal = sampVal(1:ceil(length(sampVal)*.25));
   meanFirstQuart(i) = median(sampVal);
    
end
    
procWidth = meanFirstQuart;

cols = val2cmap(procWidth*120);
cols = val2cmap((aveWidth>.6)*99+1);
scatter3(pos(:,1),pos(:,2),pos(:,3),10,cols,'filled');
axis off



%% Get synapse properties
load([MPN 'nep\useSynPos125.mat'])

points1 = useSynPos.synPos125toTCR;
points1 = useSynPos.fromRGC_dat;

points1 = points1(sum(points1,2)>1,:);


rgcOnSkel = points2nodeVal(pos,points1);
nodeVal = rgcOnSkel.nodeVal;

cols = val2cmap(nodeVal*200);
scatter3(pos(:,1)+20,pos(:,2),pos(:,3),10,cols,'filled');

useNodes = nodeVal * 0+1;

aveDist = 20;
edgeLength = getLengths(edges,pos);

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

hold on
cols = val2cmap(density*200);
scatter3(pos(:,1)+20,pos(:,2),pos(:,3),10,cols,'filled');
axis off
hold off
%% Compare processes and synapses

scatter(procWidth,density,'.')




