function[motif] = getMotifs(obI,dSamp);


if ~exist('dSamp','var')
    dSamp =  (obI.em.res .* [4 4 1])./1000;
end

if ~exist('obI','var')
    load('MPN.mat')
    load([MPN 'obI.mat'])
end
dSamp

allEdges = obI.nameProps.edges;
postTarg = preTo(allEdges,125);
preTarg = postTo(allEdges,125);

%% cell types
cells = unique([ obI.nameProps.cellNum' ; allEdges(:,1); allEdges(:,2)]);
if isfield(obI.cell, 'mainObID')
    rgcs = obI.cell.name(obI.nameProps.rgc(obI.cell.mainObID));
    tcrs = obI.cell.name(obI.nameProps.tcr(obI.cell.mainObID));
    lins = obI.cell.name(obI.nameProps.lin(obI.cell.mainObID));
    unks = obI.cell.name(obI.nameProps.unk(obI.cell.mainObID));
    
else
    rgcs = obI.cell.name(obI.nameProps.rgc(obI.cell.mainID));
    tcrs = obI.cell.name(obI.nameProps.tcr(obI.cell.mainID));
    lins = obI.cell.name(obI.nameProps.lin(obI.cell.mainID));
    unks = obI.cell.name(obI.nameProps.unk(obI.cell.mainID));
    
end

cells = setdiff(cells,0);
rgcs = setdiff(rgcs,0);
tcrs = setdiff(tcrs,0);
lins = setdiff(lins,0);

types.rgcs = rgcs;
types.tcrs = tcrs;
types.lins = lins;
types.unks = unks;


lookup = cells';
num = length(lookup);
lookdown = zeros(max(lookup),1);

lookdown(lookup) = 1:length(lookup);

cells = lookdown(cells);
% rgcs = lookdown(rgcs);
% tcrs = lookdown(tcrs);
% lins = lookdown(lins);

useSyn = sum(allEdges(:,1:2)~=0,2)==2;
synapse = allEdges(useSyn,[2 1]);
synapse = lookdown(synapse);

con = zeros(num);
conInd = sub2ind([num num],synapse(:,1),synapse(:,2));
for i = 1:size(synapse,1)
    con(synapse(i,1),synapse(i,2)) = con(synapse(i,1),synapse(i,2)) + 1;
end

[y x]  = find(con>0);
syns = [y x];

%% find triads

diad = [];
triad = [];
recip = [];
autap = [];
loop = [];
post = {};

c = 0;

for i = 1:length(cells)
    
    targ = cells(i);
    %     part1 = [allEdges(allEdges(:,1) == targ,2);...
    %         allEdges(allEdges(:,1) == targ,2)];
    part1 = find(con(targ,:)>0);
    if sum(part1==targ),autap = cat(1,autap,targ); end
    part1 = setdiff(part1,targ);
    
    
    if ~isempty(part1)
        for p = 1:length(part1)
            targ2 = part1(p);
            part2 = find(con(targ2,:)>0); %third target
            
            if sum(part2 == targ)
                recip = cat(1,recip,[targ targ2]);
            end
            
            die = setdiff(part2,[targ targ2]);
            if ~isempty(die)
                numDia = length(die);
                diad = cat(1,diad,[repmat(targ,[numDia 1]) repmat(targ2,[numDia 1]),...
                    die']);
            end
            
            link = intersect(part1,part2); %converge on same
            link = setdiff(link,targ2);
            if ~isempty(link)
                numTri = length(link);
                newTri = [repmat(targ,[numTri 1]) repmat(targ2,[numTri 1]),...
                    link']; %format source cell, second cell convergent target
                triad = cat(1,triad,newTri);
            end
            
            loo = intersect(targ,part2);
            if ~isempty(loo)
                numLoop = length(loo);
                loop = cat(1,loop,[repmat(targ,[numLoop 1]) repmat(targ2,[numLoop 1]),...
                    loo']);
            end
            
        end
    end
end

if ~isempty(recip)
    recip = sort(recip')';
    recipInd = sub2ind([num num ],recip(:,1),recip(:,2));
    recipInd = unique(recipInd);
    [a b] = ind2sub([num num],recipInd);
    recip = [a b];
end

if length(triad)
    triInd = sub2ind([num num num],triad(:,1),triad(:,2),triad(:,3));
    triInd = unique(triInd);
    [a b c] = ind2sub([num num num],triInd);
    triad = [a b c];
end

cells = lookup(cells);
triad = lookup(triad);
recip = lookup(recip);
diad = lookup(diad);
syns = lookup(syns);
loop = lookup(loop);

%% Get list of triad synapses

anchors = double(obI.colStruc.anchors);
rawAnchors = anchors;

anchors(:,1) = anchors(:,1)*dSamp(1);
anchors(:,2) = anchors(:,2)*dSamp(2);
anchors(:,3) = anchors(:,3)*dSamp(3);
%anchors = round(anchors);
anchors(anchors<1) = 1;


%% Get triad positions
eshift = [1 2; 1 3; 2 3];

tri.triCell = triad;
tri.edgeOrder = eshift;
triSyn = {}; synPos = {}; synDir = {}; synPosRaw = {}; triEdge = {};
for i = 1:size(triad,1)
    tr = triad(i,:);
    for t = 1:3
        
        d1 = (allEdges(:,1) == tr(eshift(t,1))) & (allEdges(:,2) == tr(eshift(t,2)));
        d2 = (allEdges(:,1) == tr(eshift(t,2))) & (allEdges(:,2) == tr(eshift(t,1)));
        hit1 = find(d1);
        hit2 = find(d2);
        hit = [hit1; hit2];
        triEdge{i,t} = allEdges(hit,:);
        synPos{i,t} = anchors(allEdges(hit,3),:);
        synDir{i,t} = [hit1*0+1; hit2*0+2];
        synPosRaw{i,t} = rawAnchors(allEdges(hit,3),:);
    end
    
end

if exist('triEdge','var')
    tri.triEdge = triEdge;
    tri.synPos = synPos;
    tri.synDir = synDir;
    tri.synPosRaw = synPosRaw;
    motif.tri = tri;
end

%% Get triad positions
eshift = [1 2; 1 3; 2 3];

loop3.loop = loop;
loopSyn = {}; synPos = {}; synDir = {}; synPosRaw = {};
for i = 1:size(loop,1)
    tr = loop(i,:);
    for t = 1:3
        
        d1 = (allEdges(:,1) == tr(eshift(t,1))) & (allEdges(:,2) == tr(eshift(t,2)));
        d2 = (allEdges(:,1) == tr(eshift(t,2))) & (allEdges(:,2) == tr(eshift(t,1)));
        hit1 = find(d1);
        hit2 = find(d2);
        hit = [hit1; hit2];
        loopEdge{i,t} = allEdges(hit,:);
        synPos{i,t} = anchors(allEdges(hit,3),:);
        synDir{i,t} = [hit1*0+1; hit2*0+2];
        synPosRaw{i,t} = rawAnchors(allEdges(hit,3),:);
    end
    
end

if exist('loopEdge','var')
    loop3.loopEdge = loopEdge;
    loop3.synPos = synPos;
    loop3.synDir = synDir;
    loop3.synPosRaw = synPosRaw;
    motif.loop3 = loop3;
end
%% Get diad  positions
eshift = [1 2; 2 3];

di.diCell = diad;
diSyn = {}; synPos = {}; synDir = {}; synPosRaw = {};
for i = 1:size(diad,1)
    tr = diad(i,:);
    for t = 1:2
        
        d1 = (allEdges(:,1) == tr(eshift(t,1))) & (allEdges(:,2) == tr(eshift(t,2)));
        d2 = (allEdges(:,1) == tr(eshift(t,2))) & (allEdges(:,2) == tr(eshift(t,1)));
        hit1 = find(d1);
        hit2 = find(d2);
        hit = [hit1; hit2];
        diEdge{i,t} = allEdges(hit,:);
        synPos{i,t} = anchors(allEdges(hit,3),:);
        synDir{i,t} = [hit1*0+1; hit2*0+2];
        synPosRaw{i,t} = rawAnchors(allEdges(hit,3),:);
    end
    
end

if exist('diEdge','var')
    di.diEdge = diEdge;
    di.synPos = synPos;
    di.synDir = synDir;
    di.synPosRaw = synPosRaw;
    motif.di = di;
end

%% Get recip  positions
eshift = [1 2; 2 1];

re.reCell = recip;
reSyn = {}; synPos = {}; synDir = {}; synPosRaw = {};
for i = 1:size(recip,1)
    tr = recip(i,:);
    for t = 1:2
        d1 = (allEdges(:,1) == tr(eshift(t,1))) & (allEdges(:,2) == tr(eshift(t,2)));
        hit1 = find(d1);
        hit = [hit1];
        reEdge{i,t} = allEdges(hit,:);
        synPos{i,t} = anchors(allEdges(hit,3),:);
        synPosRaw{i,t} = rawAnchors(allEdges(hit,3),:);
    end
    
end

if exist('reEdge','var')
    re.reEdge = reEdge;
    re.synPos = synPos;
    re.synPosRaw = synPosRaw;
    motif.re = re;
end

%% Get synapse  positions
eshift = [1 2];

syn.syns = syns;
synSyn = {}; synPos = {}; synPosRaw = {};
for i = 1:size(syns,1)
    tr = syns(i,:);
    for t = 1
        
        d1 = (allEdges(:,2) == tr(eshift(t,1))) & (allEdges(:,1) == tr(eshift(t,2)));
        hit = find(d1);
        synEdge{i,t} = allEdges(hit,:);
        synPos{i,t} = anchors(allEdges(hit,3),:);
        synPosRaw{i,t} = rawAnchors(allEdges(hit,3),:);
    end
    
end

if exist('syn','var')
    syn.synEdge = synEdge;
    syn.synPos = synPos;
    syn.synPosRaw = synPosRaw;
    motif.syn = syn;
end

%% cell types

classes = zeros(max(cells),1)+5;
classes(rgcs) = 1;
classes(tcrs) = 2;
classes(lins) = 3;
classes(unks) = 4;
typeNames = {'rgc' 'tcr' 'lin' 'unk' 'missing'};

tri.triClass = classes(tri.triCell);
tri.triType = typeNames(tri.triClass);

di.diClass = classes(di.diCell);
di.diType = typeNames(di.diClass);

re.reClass = classes(re.reCell);
re.reType = typeNames(re.reClass);

syn.synClass = classes(syn.syns);
syn.synType = typeNames(syn.synClass);

cel.cells = cells;
cel.cellClass = classes(cel.cells);
cel.cellTypes = typeNames(cel.cellClass);
cel.types = types;


motif.cel = cel;
motif.tri = tri;
motif.re = re;
motif.syn = syn;
motif.di = di;
motif.tri = tri;
























