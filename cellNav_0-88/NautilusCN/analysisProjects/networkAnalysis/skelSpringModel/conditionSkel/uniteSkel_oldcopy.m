function[nep2] = uniteSkel(nep);
%%
    edges = nep.edges;
    nodes = nep.nodes;
    nodePos = nep.nodePos;
    nodeNum = size(nodePos,1);
    
    subplot(1,1,1),clf
    hold on
    showEdges =  edges;%edges(groupEdges == i,:);
    sub1 = nodePos(showEdges(:,1),:);
    sub2 = nodePos(showEdges(:,2),:);
    for e = 1:size(showEdges,1)
        plot([sub1(e,1) sub2(e,1)], [sub1(e,2) sub2(e,2)],'color','k')
    end
    pause(.01)

 
  distMat = sqrt((nodePos(:,1) - nodePos(:,1)').^2 +  (nodePos(:,2) - nodePos(:,2)').^2 +...
        (nodePos(:,3) - nodePos(:,3)').^2);  
 %%  
    addedEdges = [];
    c = 0;
   
%   plot3([nodePos(edges(:,1),1) nodePos(edges(:,2),1)]',...
%             [nodePos(edges(:,1),2) nodePos(edges(:,2),2)]',...
%             [nodePos(edges(:,1),3) nodePos(edges(:,2),3)]','color',[0 0 0]);
%     hold on
    
    while 1
        %%group nodes
        g = 0;
        checkEdge = ones(size(edges,1),1);
        checkNodes = ones(size(nodes));
        groupNodes = zeros(size(nodes));
        
        while sum(checkNodes)
            newNodes = nodes(find(checkNodes,1));
            g = g+1;
            while ~isempty(newNodes)
                oldNodes = newNodes;
                newNodes = [];
                for n = 1:length(oldNodes);
                    checkNodes(nodes == oldNodes(n)) = 0;
                    groupNodes(nodes == oldNodes(n)) = g;
                    [foundEdges p] = find((edges==oldNodes(n)) & [checkEdge checkEdge]);
                    checkEdge(foundEdges) = 0;
                    foundNodes = edges(foundEdges,:);
                    newNodes = [newNodes(:)' setdiff(foundNodes(:)',oldNodes(n))];
                end
            end
        end
        sprintf('found %d disconnected groups',max(groupNodes)-1)
        if max(groupNodes) == 1, break, end
        
            
        if 0
        groupNum = max(groupNodes);
            groupPairs = nchoosek(1:groupNum,2);
            
            minEdge = groupPairs * 0;
            minLength = groupPairs(:,1)*0;
            for gp = 1:size(groupPairs,1);
                minMat = distMat;
                minMat(groupNodes ~= groupPairs(gp,1),:) = 100000000;
                minMat(:,groupNodes ~= groupPairs(gp,2)) = 100000000;
                minDist = min(minMat(:));
                [my mx] = find(minMat==minDist,1);
                groupNodes([my mx]);
                minEdge(gp,:) = [my mx];
                minLength(gp) = minDist;
            end
            
            bestNew = find(minLength == min(minLength),1);
            newEdge = minEdge(bestNew,:);
        else
          groupPairs = [1 2];
          minMat = distMat;
          minMat(groupNodes ~= 1,:) = inf;
          minMat(:,groupNodes == 1) = inf;
            minDist = min(minMat(:));
                [my mx] = find(minMat==minDist,1);
                groupNodes([my mx]);
            newEdge =[my mx];
            
        end
%     plot3([nodePos(newEdge(:,1),1) nodePos(newEdge(:,2),1)]',...
%             [nodePos(newEdge(:,1),2) nodePos(newEdge(:,2),2)]',...
%             [nodePos(newEdge(:,1),3) nodePos(newEdge(:,2),3)]','color',[1 0 0],'linewidth',10);  
        
%         %%find tips and link disconnected objects by tips
%         uE = unique(edges(:));
%         hE = hist(edges(:),uE);
%         tips = uE(hE==1);
%         minDist = zeros(size(tips));
%         minNode = zeros(size(tips));
%         for t = 1:length(tips)
%             nodeTarg = find(nodes == tips(t));
%             nodeGroup = groupNodes(nodeTarg);
%             tPos = nodePos(nodeTarg,:);
%             dists = sqrt((nodePos(:,1)-tPos(1)).^2 + (nodePos(:,2)-tPos(2)).^2 + ...
%                 (nodePos(:,3)-tPos(3)).^2 );
%             dists(groupNodes == nodeGroup) = Inf;
%             minDist(t) = min(dists);
%             minNode(t) = nodes(find(dists==minDist(t),1));
%         end
%         
%         bestDist = min(minDist)
%         bestTarg = find(minDist==bestDist,1); 
    % newEdge = [tips(bestTarg) minNode(bestTarg)]
    
        edges = cat(1,edges,newEdge);
        addedEdges = cat(1,addedEdges,newEdge);
        disp(sprintf('g = %d',g'))
        
    end    
hold off
%%
if size(addedEdges,1)
    sub1 = nodePos(addedEdges(:,1),:);
    sub2 = nodePos(addedEdges(:,2),:);
    for e = 1:size(addedEdges,1)
        plot([sub1(e,1) sub2(e,1)], [sub1(e,2) sub2(e,2)],'color','r','linewidth',3)
    end
    pause(.01)
    
    hold off
end

nep2 = nep;
nep2.edges = edges;





    
    