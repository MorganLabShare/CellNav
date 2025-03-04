function[report] = node2nodeDist(edges,lengths,startNode,stopNode,maxLook)

if ~exist('stopNode','var')
        stopNode = [];
end

if ~exist('maxLook','var')
        maxLook = Inf;
end


if size(lengths,2)>1
    lengths = getLengths(edges,lengths);
    disp('changing potential positions to lengths')
end


report.startNode = startNode;
report.stopoNode = stopNode;


if sum(stopNode==startNode)
    
    report.pred = startNode;
    report.dists = 0;
    report.r = 0;
    report.cumDist = 0;
    report.closestNode = startNode;
    report.minDist = 0;
    report.cumDist = 0;
    report.path = [startNode startNode];
    
else
    
   
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
    maxLooks = repmat(maxLook,size(edges));
   
    for r = 1:reps*10
        
        oldDists = [dists(edges(:,1)) dists(edges(:,2))]; %current distance of nodes in edges
        newDists = oldDists(:,[2 1]) + repmat(lengths,[1 2]); %Distance of nodes if connected through edge
        closer = newDists<oldDists; %nodes who would benefit from given edge
        closer2 = closer & (newDists <= maxLooks); % set maximum look distance
           
        
        [e a] = find(closer2);
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
        if (sum(stops(n)) & ~firstHit);
            firstHit = r;
        end
        
        if isempty(e)
            break
        elseif firstHit & (r > (firstHit * doubleCheck))
            break
        end
        
    end
  
    report.pred = pred;
    report.dists = dists;
    report.r = r;
    
    
    %% read path
    if sum(stops) %if stops were requested, report path to first stop
        stopDists = dists(stopNode);
        lastNode = stopNode(find(stopDists == min(stopDists),1));
        report.closestNode = lastNode;

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
        report.minDist = max(cumDist);
        report.cumDist = cumDist;
        report.path = path;
    end
    
    
end


