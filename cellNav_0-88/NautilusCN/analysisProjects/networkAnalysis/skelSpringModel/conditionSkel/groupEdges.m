function[nep2] = groupNepEdges(nep); 


edges = nep.edges; 

%% group edges into bones

    
    %freeze tips and branch points
    hE = hist(edges(:),nodes);
    fixedNode = hE~=2;
    
    checkNodes = ~fixedNode;
    checkEdge = ones(size(edges,1),1);
    groupNodes = zeros(size(nodes));
    groupEdges = zeros(size(edges,1),1);
    listFixed = nodes(fixedNode>0);
    g = 0;
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
                groupEdges(foundEdges) = g;
                checkEdge(foundEdges) = 0;
                newNodes = [newNodes; setdiff(edges(foundEdges,:),oldNodes(n))];
            end
            newNodes = setdiff(newNodes,listFixed);
        end
    end
  
    %%label zeros
    zeroEdge = find(groupEdges ==0);
    zeroNames = [1:length(zeroEdge)] + max(groupEdges);
    groupEdges(zeroEdge) = zeroNames;
    
    
    subplot(1,1,1),clf
    hold on
    colmap = hsv(100);
    for i = 0:max(groupEdges);
        showEdges =  edges(groupEdges == i,:);
        sub1 = node2subs(showEdges(:,1),:);
        sub2 = node2subs(showEdges(:,2),:);
        rCol = colmap(ceil(rand*100),:)/2;
        for e = 1:size(showEdges,1)
            
            plot([sub1(e,1) sub2(e,1)], [sub1(e,2) sub2(e,2)],'color',rCol,'linewidth',1)
            
        end
    end
    pause(.01)

    hold off