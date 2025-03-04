function[sm] = getSkelForSM(sm,maxSpace)

%% Get skeletons
if ~exist('maxSpace','var')
maxSpace = .5;
end

   
    load('MPN.mat')

pos = sm.skel.nodes;
edges = sm.skel.edges;



%% upsample skeleton
lengths = sqrt((pos(edges(:,1),1)-(pos(edges(:,2),1))).^2 + ...
    (pos(edges(:,1),2)-(pos(edges(:,2),2))).^2 + ...
    (pos(edges(:,1),3)-(pos(edges(:,2),3))).^2);

maxNode = max(edges(:));
upEdges = [];
upPos = [];
for i = 1:size(edges,1)
    edge = edges(i,:);
    pos1 = pos(edge(1),:);
    pos2 = pos(edge(2),:);
    L = lengths(i);
    num = ceil(L/maxSpace);
    if num > 1
        gap = 1/(num-1);
        dif = pos2-pos1;
        vec = [0:gap:1]';
        newPos = repmat(pos1,[length(vec) 1]) + [dif(:,1)*vec dif(:,2)*vec dif(:,3)*vec];
        newNodes = [edge(1) maxNode + [1:length(vec)-2] edge(2)];
        newEdges = zeros(length(newNodes)-1,2);
        for e = 1:length(newNodes)-1
            newEdges(e,:) = [newNodes(e) newNodes(e+1)];
        end
    else
        %return
        newNodes = edge;
        newPos = [pos1;pos2];
        newEdges = edge;
    end
    upEdges = cat(1,upEdges,newEdges);
    upPos(newNodes,:) = newPos;
    maxNode = max(upEdges(:));
end


%%



if 0

nodeDegree = hist(edges(:),unique(edges(:)));
branchPoints = find(nodeDegree>2);
scatter3(pos(:,1),pos(:,2),pos(:,3),5,'.','b')
hold on
scatter3(pos(branchPoints,1),pos(branchPoints,2),pos(branchPoints,3),60,'o','filled','r')


nodeDegree = hist(upEdges(:),unique(upEdges(:)));
branchPoints = find(nodeDegree>2);
scatter3(upPos(:,1),upPos(:,2),upPos(:,3),'.','k')
hold on
scatter3(upPos(branchPoints,1),upPos(branchPoints,2),upPos(branchPoints,3),30,'o','filled','g')

hold off
end





%%
sm.skel.raw = sm.skel;
sm.skel.nodes = 1:size(upPos,1);
sm.skel.edges = upEdges;
sm.skel.pos = upPos;
sm.skel.gap = maxSpace;






