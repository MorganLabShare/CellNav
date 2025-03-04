function[nepCSS] = mergeSkelCellSyn(skels,nepCell,nepSyn);
%%

skelList = cat(1,skels.id);

%% Get nodes
nodeTypeCode = {'cell', 'syn', 'skel'};
clear nodeName nodeType nodePos

%%Cell
cellNodeIdx = 1:length(nepCell.nodes);
nodeName(cellNodeIdx) = nepCell.nodes;
nodeType(cellNodeIdx) = 1;
nodePos(cellNodeIdx,:) = nepCell.nodePos;
nodeParent(cellNodeIdx) = nepCell.nodeParent;

%%Syn
synNodeIdx = (1:length(nepSyn.nodes)) + max(cellNodeIdx);
nodeType(synNodeIdx) = 2;
nodePos(synNodeIdx,:) = nepSyn.nodePos;
nodeName(synNodeIdx) = 0;%nepSyn.subEdge(:,1);

%%skel
numNodes = max(synNodeIdx);
for i = 1:length(skels)
    
    skelNodeIdx{i} = (1:length(skels(i).nep.nodes)) + numNodes;
    numNodes = max(skelNodeIdx{i});
    nodeType(skelNodeIdx{i}) = 3;
    nodePos(skelNodeIdx{i},:) = skels(i).nep.nodePos;
    nodeParent(skelNodeIdx{i}) = skels(i).id;
    nodeName(skelNodeIdx{i}) = 0;%skels(i).id;
end



%% Get synapse Edges
c = 0;
clear synEdge synEdgeType
for i = 1: length(nepSyn.nodes)
    newPos = [];
    shift = 1;
    preTarg = cellNodeIdx(find(nepCell.nodes == nepSyn.cellEdges(i,1),1));
    postTarg = cellNodeIdx(find(nepCell.nodes == nepSyn.cellEdges(i,2),1));
    useNode(synNodeIdx(i)) = 0;

    
    if sum(skelList == nepSyn.cellEdges(i,1))% pre skeleton
        c = c+1;
        preTarg = find(skelList==nepSyn.cellEdges(i,1));
        preNode = skelNodeIdx{preTarg}(nepSyn.subEdge(i,1));
        synEdge(c,:) = [preNode synNodeIdx(i)];
        synEdgeType(c) = 1;
        shift = 0;
            useNode(synNodeIdx(i)) = 1;

    elseif ~isempty(preTarg)
        c = c+1;
        synEdge(c,:) = [preTarg synNodeIdx(i)];
        synEdgeType(c) = 1;
        newPos = cat(1,newPos,nodePos((preTarg),:));
        useNode(synNodeIdx(i)) = 1;
    end
    
    
    
    if sum(skelList == nepSyn.cellEdges(i,2))%post skeleton
        c = c+1;
        postTarg = find(skelList==nepSyn.cellEdges(i,2));
        postNode = skelNodeIdx{postTarg}(nepSyn.subEdge(i,2));
        synEdge(c,:) = [synNodeIdx(i) postNode];
        synEdgeType(c) = 2;
        shift = 0;
        useNode(synNodeIdx(i)) = 1;
    elseif ~isempty(postTarg)
        c = c+1;
        synEdge(c,:) = [synNodeIdx(i) postTarg];
        synEdgeType(c) = 2;
        newPos = cat(1,newPos,nodePos((postTarg),:));
        useNode(synNodeIdx(i)) = 1;
    end
    
    
    if shift & ~isempty(newPos) % if syn is not attatched to skeleton, shift to mean between CB
        nodePos(synNodeIdx(i),:) = mean(newPos,1);
    end
    
end

%% get / transform skeleton edges
skelEdges = [];
skelLengths = [];
for i = 1:length(skels)
    edges = skels(i).nep.edges;
   skelEdges =  cat(1,skelEdges,skelNodeIdx{i}(edges));
   skelLengths =  cat(1,skelLengths(:),(skels(i).nep.edgeLength(:)));

end

%% link skel to cell
cell2skel = [];
for i = 1:length(skels)
    cellTarg = find((nodeName == skels(i).id) & (nodeType == 1));
    dists = sqrt((skels(i).nep.nodePos(:,1) -nodePos(cellTarg,1)).^2 + ...
            (skels(i).nep.nodePos(:,2) -nodePos(cellTarg,2)).^2 + ...
          	(skels(i).nep.nodePos(:,3) -nodePos(cellTarg,3)).^2 );
        minDist = min(dists);
    skelTarg = find(dists==minDist,1);
    cell2skel(i,:) = [cellTarg skelNodeIdx{i}(skelTarg)];
      
end


%%
edgeTypeCode = {'pre','post','skel','cell2skel'};
synEdgeIdx = 1:length(synEdge);
edges = synEdge;
edgeLengths(synEdgeIdx) = 0;
edgeType(synEdgeIdx) = synEdgeType;

edgeNum = size(edges,1);

skelEdgeIdx= (1:length(skelEdges)) + edgeNum;
edgeNum = max(skelEdgeIdx);
edges(skelEdgeIdx,:) = skelEdges;
edgeLengths(skelEdgeIdx) = skelLengths;
edgeType(skelEdgeIdx) = 3;

c2eIdx = (1:size(cell2skel,1)) + edgeNum;
edgeNum = max(c2eIdx);
edges(c2eIdx,:) = cell2skel;
edgeLengths(c2eIdx) = 0;
edgeType(c2eIdx) = 4;

nodes = 1:numNodes;

%% Define used

useEdge = ones(size(edges,1),1);

useNode = hist(edges(:),nodes);

find(useNode==0)





%%

nepCSS.nodes = nodes;
nepCSS.edges = edges;
nepCSS.nodeName = nodeName;
nepCSS.nodePos = nodePos;
nepCSS.nodeTypeCode = nodeTypeCode;
nepCSS.nodeType = nodeType;
nepCSS.edgeLengths = edgeLengths;
nepCSS.nodeParent = nodeParent;
nepCSS.edgeType = edgeType;
nepCSS.edgeTypeCode = edgeTypeCode;
nepCSS.useEdge = useEdge;
nepCSS.useNode = useNode;














%%