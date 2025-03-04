function[report] = point2point(edges,lengths,startNode,stopNode)

report.startNode = startNode;
if ~exist('stopNode','var')
    stopNode = [];
end
%
% edges = skel.edges;
%                 nodePos = sPos;
%                 startNode = link1;
%                 stopNode = link2;


doubleCheck = 2; % factor of spreads past first hitting target
reps = size(edges,1);
nodeNum = max(edges(:));
pred = zeros(nodeNum,1);
dists = inf(nodeNum,1);
dists(startNode) = 0;
% lengths = sqrt((nodePos(edges(:,1),1)-(nodePos(edges(:,2),1))).^2 + ...
%     (nodePos(edges(:,1),2)-(nodePos(edges(:,2),2))).^2 + ...
%     (nodePos(edges(:,1),3)-(nodePos(edges(:,2),3))).^2);

firstHit = 0;
stops = zeros(nodeNum,1);
stops(stopNode) = 1;

for r = 1:reps*10
    
    oldDists = [dists(edges(:,1)) dists(edges(:,2))]; %current distance of nodes in edges
    newDists = oldDists(:,[2 1]) + repmat(lengths,[1 2]); %Distance of nodes if connected through edge
    closer = newDists<oldDists; %nodes who would benefit from given edge
    
    [e a] = find(closer);
    b = 3-a;
    n = edges(sub2ind(size(edges),e,a));
    n2 = edges(sub2ind(size(edges),e,b));
    
    for ce = 1:length(n)
        if newDists(e(ce),a(ce)) < dists(n(ce));
            pred(n(ce)) = n2(ce);
            dists(n(ce)) = newDists(e(ce),a(ce));
        end
    end
    
    %% Check for finish
    if (sum(stops(n)) & ~firstHit) | ~sum(pred==0);
        firstHit = r;
    end
    
    if firstHit & (r > (firstHit * doubleCheck))
        break
    end
    
end

report.pred = pred;
report.dists = dists;


%% read path
if sum(stops)
    stopDists = dists(stops>0);
    lastNode = stopNode(find(stopDists == min(stopDists),1));
    
    clear path
    for pa = 1:reps
        %             scatter3(sPos(lastNode,1),sPos(lastNode,2),sPos(lastNode,3),'b','filled')
        %             pause(.1)
        predNode = pred(lastNode);
        path(pa,:) = [predNode lastNode];
        lastNode = predNode;
        if lastNode == startNode
            break
        end
    end
    path = flipud(path);
    cumDist = dists(path(:,2));
    report.closestNode = lastNode;
    report.minDist = max(cumDist);
    report.cumDist = cumDist;
    report.path = path;
end





