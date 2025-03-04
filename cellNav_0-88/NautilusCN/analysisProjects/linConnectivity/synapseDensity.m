
%%find synapse density





load('MPN.mat')
%nepFileName = sprintf('%snep\\skelNep%d.mat',MPN,skelList);

load([MPN 'nep\skelNep125.mat'])
load([MPN 'nep\useSynPos125.mat'])
pos = nep.nodePos;
edges = nep.edges;
[edges pos] = doubleEdge(edges, pos);


edgeLength = getLengths(edges,pos);



%% RGC input
points1 = useSynPos.fromRGC_dat;
points1 = points1(sum(points1,2)>1,:);

rgcOnSkel = points2nodeVal(pos,points1);
nodeVal = rgcOnSkel.nodeVal;
useNodes = nodeVal * 0+1;

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

rgcDensity = density;


%% TCR output
points1 = useSynPos.synPos125toTCR;
points1 = points1(sum(points1,2)>1,:);

rgcOnSkel = points2nodeVal(pos,points1);
nodeVal = rgcOnSkel.nodeVal;
useNodes = nodeVal * 0+1;

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











