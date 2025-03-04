function[topo] = swc2topo(pred,dist2Seed)

%%Calculate a topological description of branching based on a pred list
%%from an swc formatted skeleton

nodes = 1:length(pred);



%which branch point does every node belong to
numChild = hist(pred,nodes);
bp = find(numChild>1);
tagBP = pred * 0;
tagBP(bp) = bp;
predFix = pred(:);
predFix(1) = 1;

%%Find first children (branch bases)
fc = [];
for b = 1:length(bp)
    fc = [fc; find(predFix == bp(b))];
end
tagBranches = pred*0;
tagBranches(fc) = fc;

branchParent = tagBranches;
%%Look upstream for nearest branch point
for c = 1:length(pred)
    oldSum = sum(branchParent);
    newBpParent = branchParent(predFix);
    branchParent(branchParent==0) = newBpParent(branchParent==0);
    newSum = sum(branchParent);
    if oldSum == newSum
        break
    end
end

%Translate into branchIDs
uBranchParent = unique(branchParent); %get root node IDs of branches
numBranches = length(uBranchParent); %count branches


branchParentBPNode = predFix(uBranchParent); %identify branch points giving rise to each branch (nodeID)
branchPredNodes = branchParent(branchParentBPNode); %Identify branch  (nodeID) that is parent of each branch

branchList = 1:numBranches; %make list of branches
lookupBranches(uBranchParent) = branchList; %make up lookup table for branches
branchPredBranch = lookupBranches(branchPredNodes); %Make branch to branch ID pred list



topo.pred = pred(:);
topo.numChild = numChild(:);
topo.numBranches = numBranches;
topo.branch.base = fc(:);
topo.branchPoints = bp(:);
topo.branch.parentBPNode = branchParentBPNode(:);
topo.branch.baseIDofAllNodes = branchParent(:);
topo.branch.IDofAllNodes = lookupBranches(branchParent);
topo.branch.list = branchList(:);
topo.branch.predNodeIDs = branchPredNodes(:);
topo.branch.pred = branchPredBranch(:);



%% Make topoGraph

%%Get dist2Seed if none provided
if ~exist('dist2Seed','var')
    dist2Seed = pred * 0 + inf;
    dist2Seed(1) = 0;
    for p = 1:length(pred)
        newDist = dist2Seed(predFix) + 1;
        dist2Seed = min(dist2Seed,newDist);
        if sum(dist2Seed)<inf,break,end
    end
end

%%Set up variables
bpSeedDistance = dist2Seed(topo.branchPoints);
bPred = topo.branch.pred;

branchNum = length(topo.branch.list);
branchX = zeros(branchNum,1);
branchY = zeros(branchNum,2);
for b = 1:branchNum
    branchNodes = find(topo.branch.IDofAllNodes == b);
    branchY(b,:) = [dist2Seed(branchNodes(1)) dist2Seed(branchNodes(end))];
end

%%Find longest child
maxLength = branchY(:,2);
for b2 = 1:branchNum
    for b = branchNum: - 1:1
        maxLength(bPred(b)) = max(maxLength(bPred(b)),maxLength(b));
    end
end

%%Find xs%%%%%%
bp = topo.branchPoints;
parentBP = topo.branch.parentBPNode;
parentBP(1) = 0;

%%Get default info for bps (branch point structure)
for b = 1:length(bp)
    bps(b).children = find(parentBP==bp(b));
    bps(b).offsets = zeros(length(bps(b).children),1);
end

branchOffsets = branchX*0;
branchChildrenXbounds = branchY*0;

%%Itterate offsets starting at terminal branches
trackBranchPred = topo.branch.pred; % make list of branch preds to be pruned
trackBranchPred(1) = 0;
bpFinished = [];
for r = 1:length(bp);

    branchChildren = hist(trackBranchPred,topo.branch.list);
    notTerminalBranches = find(branchChildren>0);
    notTerminalBP = unique(parentBP(notTerminalBranches));
    terminalBP = setdiff(bp,notTerminalBP);
    terminalBP = setdiff(terminalBP,bpFinished);

    nextBP = terminalBP;

    % if isempty(nextBP)
    %     break
    % end
    for t = 1:length(nextBP)

        bpID = nextBP(t);
        bpFinished = [bpFinished bpID];
        bpTarg = find(bp==bpID);
        bpBranch = topo.branch.IDofAllNodes(bpID);
        children = find(parentBP == nextBP(t));
        trackBranchPred(children) = children; %remove from future consideration
        xOffset = zeros(length(children),1);
        dists = maxLength(children);
        [sd idx] = sort(dists,'descend');


        xOffset(idx(1)) = 0; %longest downstream gets no offset
        mainBranchOffsets =  branchChildrenXbounds(children(idx(1)),:);
        toLeft = mainBranchOffsets(1);
        toRight = mainBranchOffsets(2);
        for s = 2:length(idx)
            if mod(s,2)
                xOffset(idx(s)) = toLeft - branchChildrenXbounds(children(idx(s)),2)-1;
                toLeft = toLeft + branchChildrenXbounds(children(idx(s)),1)-1;
            else

                xOffset(idx(s)) = toRight - branchChildrenXbounds(children(idx(s)),1)+1;
                toRight = toRight + branchChildrenXbounds(children(idx(s)),2)+1;
            end
        end

        % bps(bpTarg).children = children;
        % bps(bpTarg).xOffset = xOffset;
        % newWidth = max(xOffset)-min(xOffset)+1
        %branchWidth(bpBranch) = r;
        branchChildrenXbounds(bpBranch,:) = [toLeft toRight];
        branchOffsets(children) = xOffset;

    end

end

%%Forward propogate branch offsets
lastB = 1;
parentOffset = 0;
for b = 1:length(topo.branch.pred)
    nextB = [];
    for n = 1:length(lastB)
        new = find(topo.branch.pred == lastB(n));
        branchX(new) = branchX(lastB(n)) + branchOffsets(new);
        nextB = [nextB; new];
    end
    lastB = nextB;
end

topo.graph.branchX = [branchX branchX]';
topo.graph.branchY = branchY';


topo.graph.bpX = [branchX(topo.branch.pred) branchX]';
topo.graph.bpY = [branchY(topo.branch.pred,2) branchY(:,1)]';

topo.graph.help = ['to plot topoGraph:' newline ...
    'plot(bpX,bpY)' newline ...
    'hold on' newline ...
    'plot(branchX,branchY)' newline newline ...
    'Vertical lines are branches with Y representing distance to root' newline ...
    'Horizontal lines link branches to branch points' newline ...
    'X diminsion is used to spread out branches and has no meaning' newline ...
    'Branches are arranged so that longest branch has no X offset' newline ...
    'Unless branch point produces more than two offspring,' newline ...
    'smaller branches are shifted to the right'];

%%Plot
if 0
    plot(topo.graph.bpX,topo.graph.bpY,'color',[.9 .9 .9])
    hold on
    plot(topo.graph.branchX,topo.graph.branchY,'k');
end


topo.dat.pred = pred;
topo.dat.dist2seed = dist2Seed;
topo.dat.nodes = nodes;


%%
if 0
    cols = hsv(100);
    cla
    hold on
    for i = 1:length(fc)
        isBranch = find(branchParent==fc(i));
        scatter(nep.swcS.pos(isBranch,1),nep.swcS.pos(isBranch,2),...
            'markerfacecolor',cols(ceil(rand*100),:),'MarkerEdgeColor','none');
    end
    scatter(nep.pos(:,1),nep.pos(:,2),'.','k')
end














