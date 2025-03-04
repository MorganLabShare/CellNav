function[nep2] = uniteSkel(nep);
%%

    tempFig = figure;
    tempAx = gca(tempFig);

    edges = nep.edges;
    nodes = nep.nodes;
    
    try nodePos = nep.nodePos;
    catch err
        nodePos = nep.pos;
    end
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
        
            
   ug =  unique(groupNodes);
   while length(ug) >1
        minMat = distMat;
        minMat(groupNodes ~= 1,:) = inf;
        minMat(:,groupNodes == 1) = inf;
        minDist = min(minMat(:));
        [my mx] = find(minMat==minDist,1);
        mergeGroups = groupNodes([my mx]);
        newEdge =[my mx];
        edges = cat(1,edges,newEdge);
        addedEdges = cat(1,addedEdges,newEdge);
        
        
        groupNodes(groupNodes == groupNodes(mx)) = 1;
           ug =  unique(groupNodes);
        disp(sprintf('g = %d',length(ug)'))
   end
     
%     plot3([nodePos(newEdge(:,1),1) nodePos(newEdge(:,2),1)]',...
%             [nodePos(newEdge(:,1),2) nodePos(newEdge(:,2),2)]',...
%             [nodePos(newEdge(:,1),3) nodePos(newEdge(:,2),3)]','color',[1 0 0],'linewidth',10);  
        
    
       
        
    end    
%%
if size(addedEdges,1)
    sub1 = nodePos(addedEdges(:,1),:);
    sub2 = nodePos(addedEdges(:,2),:);
    for e = 1:size(addedEdges,1)
        plot(gca(tempFig),[sub1(e,1) sub2(e,1)], [sub1(e,2) sub2(e,2)],'color','r','linewidth',3)
    end
    pause(.01)
    
    hold off
end

nep2 = nep;
nep2.edges = edges;

pause(2)
close(tempFig)





    
    