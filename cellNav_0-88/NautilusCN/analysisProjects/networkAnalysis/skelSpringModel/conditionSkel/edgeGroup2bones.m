function[nep2] = edgeGroup2bones(nep);

edges = nep.edges;
nodes = nep.nodes;
groupEdges = nep.groupEdges;
nodePos = nep.pos;

edgeGroups = unique(groupEdges);    
    hE = hist(edges(:),nodes);

    for i = 1:length(edgeGroups)
        
        gEdges = edges(groupEdges == edgeGroups(i),:);
        hCE = hist(gEdges(:),nodes);
        ends = nodes(hCE==1);
        isTip = 0; 
        if isempty(ends)
            isTip = 1;
            startN = gEdges(1,1);
        elseif hE(find(nodes == ends(1))) == 1
            startN = ends(1);
            isTip = 1;
        elseif hE(find(nodes == ends(2))) == 1
            startN = ends(2);
            isTip = 1;
        else
            isTip = 0;
            startN = ends(1);
        end
       
        newNode = startN;
        c = 0;
        checkEdges = ones(size(gEdges));
        newEdges = zeros(size(checkEdges));
        L = zeros(size(checkEdges,1),1);
        tog = [2 1];
        while 1
            c = c+1;
            oldNode = newNode;
            [y x] = find((gEdges == oldNode) & checkEdges,1);
            if ~isempty(y)
                
                checkEdges(y,:) = 0;
                newNode = gEdges(y,tog(x));
                sub1 = nodePos(nodes==oldNode,:);
                sub2 = nodePos(nodes==newNode,:);
                %             scatter(sub1(e,1), sub1(e,2),'b')
                %             scatter(sub2(e,1),sub2(e,2),'r','^')
                
                L(c) = sqrt((sub1(1)-sub2(1)).^2 +  (sub1(2)-sub2(2)).^2 + ...
                    (sub1(3)-sub2(3)).^2);
                newEdges(c,:) = [oldNode newNode];
            else
                break
            end
        end
          
         bRun(i).edges = newEdges;
    bRun(i).lengths = L;
    bRun(i).isTip = isTip;
        
    end
    
    
    
    nep2 = nep;
    nep2.bones = bRun;
    
    
    