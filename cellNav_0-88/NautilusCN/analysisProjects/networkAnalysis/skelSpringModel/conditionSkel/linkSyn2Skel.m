function[nepSyn] = linkSyn2Skel(nepSyn,skels);

skelList = cat(1,skels.id);
synPos = nepSyn.nodePos;
edges = nepSyn.cellEdges;


%% Identify nearest sub nodes
for i = 1:length(nepSyn.nodes)
    
    if sum(skelList == edges(i,1));
        preTarg = find(skelList == edges(i,1));
        nepSkel = skels(preTarg).nep;
        skelPos = nepSkel.nodePos;
        dists = sqrt((skelPos(:,1)-synPos(i,1)).^2 + (skelPos(:,2)-synPos(i,2)).^2 + ...
            (skelPos(:,3)-synPos(i,3)).^2);
        minDist = min(dists);
        nearestNode =  find(dists==minDist,1);
        subEdge(i,1) = nearestNode;
    else
        subEdge(i,1) = 0;
    end
    
    if sum(skelList == edges(i,2));
        postTarg = find(skelList == edges(i,2));
        nepSkel = skels(postTarg).nep;
        skelPos = nepSkel.nodePos;
        dists = sqrt((skelPos(:,1)-synPos(i,1)).^2 + (skelPos(:,2)-synPos(i,2)).^2 + ...
            (skelPos(:,3)-synPos(i,3)).^2);
        minDist = min(dists);
        nearestNode = find(dists==minDist,1);
        subEdge(i,2) = nearestNode;
    else
        subEdge(i,2) = 0;
    end
end

nepSyn.subEdge = subEdge;
