function[nep2] = simpleNep(nep,minSpace)     

if ~exist('minSpace')
    minSpace = 0;
end

    bones = nep.bones;
    nodePos = nep.pos;

    for b = 1:length(bones)
        bones(b).oldLengths = bones(b).lengths;
        
        bRun = [bones(b).edges] ;
        sub1 = nodePos(bRun(:,1),:);
        sub2 = nodePos(bRun(:,2),:);
        
        clear newEdges 
        
        newEdges(1,1) = bRun(1,1);
        edgeCount = 1;
        L = 0;
        eL = 0;
        for e = 1:size(bRun,1)-1
           
            L = L + sqrt((sub1(e,1)-sub2(e,1)).^2 +  (sub1(e,2)-sub2(e,2)).^2 + ...
                (sub1(e,3)-sub2(e,3)).^2);
            if (L >= minSpace) %|| fixedNode(bRun(e,2))>0
                
                eL(edgeCount) = L;
                L = 0;
                newEdges(edgeCount,2) = bRun(e,2);
                edgeCount = edgeCount + 1;
                newEdges(edgeCount,1) = bRun(e,2);
            end
            
        end
        eL(end) = L;
        newEdges(end,2) = bRun(end,2);
        
        bones(b).edges = newEdges;
        bones(b).lengths = eL;
        
        %scatter(cellNodePos(:,1),cellNodePos(:,2),'.'),pause(.01)
    end %bones
    
    nep2 = nep;
    nep2.bones = bones;
    nep2.minSpace = minSpace;
    
    
    
    
    
    
    