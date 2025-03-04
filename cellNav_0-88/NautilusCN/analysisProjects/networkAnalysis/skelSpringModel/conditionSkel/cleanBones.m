function[nep2] = cleanBones(nep)

%% Clean Bones, remove everthing not in the bones. reduce node names to index
    edges = cat(1,nep.bones.edges);
    oldNodes = nep.nodes;
    hE = hist(edges(:),oldNodes);
    oldInds = find(hE>0);
    oldIDs = oldNodes(oldInds);
    newIDs = [1:length(oldIDs)]';
    old2new(oldIDs) = newIDs;
    new2old(newIDs) = oldIDs;
    
    nep2 = nep;
    nep2.nodes = newIDs;
    nep2.edges = old2new(edges);
    nep2.seedNode = old2new(nep.seedNode);
    nep2.pos = nep.pos(oldInds,:);
    nep2.nodeRad = nep.nodeRad(oldInds);
    nep2.meanNodeRad = nep.meanNodeRad(oldInds);
    
    if isfield(nep2,'groupEdges'),nep2 = rmfield(nep2,'groupEdges');end
    if isfield(nep2,'spurs'),nep2 = rmfield(nep2,'spurs');end
    
    bones = nep2.bones;
    for b= 1:length(bones)
        bones(b).edges = old2new(bones(b).edges);        
    end
    nep2.bones = bones;
    
    %% get edge length
    edges = nep2.edges;
    nodePos = nep2.pos;
    sub1 = nodePos(edges(:,1),:);
    sub2 = nodePos(edges(:,2),:);
        for e = 1:length(edges);
        
          L(e) = sqrt((sub1(e,1)-sub2(e,1)).^2 +  (sub1(e,2)-sub2(e,2)).^2 + ...
                (sub1(e,3)-sub2(e,3)).^2);
        end
    nep2.edgeLength = L;
    
    
    nep2.edgeRad = (nep2.meanNodeRad(nep2.edges(:,1)) +  nep2.meanNodeRad(nep2.edges(:,2)) )/2;