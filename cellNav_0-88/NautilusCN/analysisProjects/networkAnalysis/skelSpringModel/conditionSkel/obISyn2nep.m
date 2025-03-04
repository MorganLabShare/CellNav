function[nep] = obISyn2nep(obI);

synapses = obI.nameProps.edges;
edges = synapses(:,[2 1]);
nep.nodes = 1:size(edges,1);
nep.cellEdges = edges;

%% Map existing synapses
rawSynAnchors = obI.colStruc.anchors(synapses(:,3),:);
%synAnchors = scaleSubs(double(rawSynAnchors),anchorScale);
dSamp =  (obI.em.res .* [4 4 1])./1000;%./obI.em.dsRes;
synAnchors(:,1) = rawSynAnchors(:,1)*dSamp(1);
synAnchors(:,2) = rawSynAnchors(:,2)*dSamp(2);
synAnchors(:,3) = rawSynAnchors(:,3)*dSamp(3);
%synAnchors = round(synAnchors);
synAnchors(synAnchors<1) = 1;
nep.nodePos = synAnchors;
