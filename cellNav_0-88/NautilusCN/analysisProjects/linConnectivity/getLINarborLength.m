%% Measure cell
skelList = 125;
minTip = 2;
minSpace = 2;
i = 1

fileName = sprintf('%sskel\\mat\\%d.mat',MPN,skelList(i));
load(fileName)
%%
skel = cellStruct.arbor;
node2subs = skel.nodes.node2subs;
bones = skel.branches;

edges = cat(1,bones.edges, skel.bridges);
nodes = 1:size(node2subs,1); % will go wrong if gaps

nodePos = node2subs(nodes,:);
voxelScale = obI.em.dsRes * 2; %adjusted for skeleton down samp
nodePos = scaleSubs(nodePos,voxelScale);
nep.nodePos = nodePos;

nep.nodes = nodes;
nep.edges = edges;



%% condition skeleton

showNep(nep)

% nep = uniteSkel(nep);%% fix breaks in skeleton
nep = groupNepEdges(nep); %% group edges into bones
nep = edgeGroup2bones(nep);
nep = bonesVsSpurs(nep,minTip); %% sort bones and spurs

%%redo without spurs
nep.edges = cat(1,nep.bones.edges);
nep = groupNepEdges(nep);
nep = edgeGroup2bones(nep);
showNepBones(nep,2);

%%Simplify skeleton
nep = simpleNep(nep,minSpace);
showNepBones(nep)
nep = cleanBones(nep);
showNepBones(nep);

skels(i).id = skelList(i);
skels(i).nep = nep;




arborL = sum(nep.edgeLength)




745/arborL
arborL/745

493/arborL
arborL/493



























