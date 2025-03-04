function[syn] = getSynMat(tis)

obI = tis.obI;

allEdges = tis.syn.edges;

if isempty(allEdges)
    syn = tis.syn;
    syn.pre = [];
    syn.post = [];
    syn.obID = [];
    syn.synType = [];
    
    
else
    
    syn = tis.syn;
    syn.pre = allEdges(:,2);
    syn.post = allEdges(:,1);
    syn.obID = allEdges(:,3);
    syn.synType = allEdges(:,4);
end
%% cell types

maxCid = max([tis.cids(:); syn.pre(:); syn.post(:)]);
classes = zeros(maxCid+1,1);
classes(tis.cids + 1)  = tis.cells.type.typeID;

syn.preClass = classes(syn.pre+1);
syn.postClass = classes(syn.post+1);

%% Get list of positions

anchors = double(obI.colStruc.anchors);
anchors = anchors(:,[2 1 3]);
rawAnchors = anchors;

umSamp = (obI.em.res )./1000;
UManchors(:,1) = anchors(:,1)*umSamp(1);
UManchors(:,2) = anchors(:,2)*umSamp(2);
UManchors(:,3) = anchors(:,3)*umSamp(3);


dSamp =  (obI.em.res )./1000./obI.em.dsRes;
anchors(:,1) = anchors(:,1)*dSamp(1);
anchors(:,2) = anchors(:,2)*dSamp(2);
anchors(:,3) = anchors(:,3)*dSamp(3);
anchors = round(anchors);
anchors(anchors<1) = 1;

%% Get synapse  positions

synSyn = []; synPos = []; synPosRaw = []; synPosUM = []; synPosDS = [];
for i = 1:size(syn.obID,1)
        synPosDS(i,:) = anchors(syn.obID(i),:);
        synPosRaw(i,:) = rawAnchors(syn.obID(i),:);    
        synPosUM(i,:) = UManchors(syn.obID(i),:);    
end

syn.pos = synPosUM;
syn.synPosRaw = synPosRaw;
syn.synPosDS = synPosDS;

syn.order = 'pre to post';





























