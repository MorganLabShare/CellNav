function[tri] = getTriads(obI);

if ~exist('obI','var')
load('MPN.mat')
load([MPN 'obI.mat'])
end


allEdges = obI.nameProps.edges;
postTarg = preTo(allEdges,125);
preTarg = postTo(allEdges,125);

%% cell types
cells = unique([ obI.nameProps.cellNum' ; allEdges(:,1); allEdges(:,2)]);
rgcs = unique(obI.nameProps.cellNum(obI.nameProps.rgc));
tcrs = unique(obI.nameProps.cellNum(obI.nameProps.tcr));
lins = unique(obI.nameProps.cellNum(obI.nameProps.lin));
cells = setdiff(cells,0);
rgcs = setdiff(rgcs,0);
tcrs = setdiff(tcrs,0);
lins = setdiff(lins,0);

lookup = cells;
num = length(lookup);
lookdown = zeros(max(lookup),1);

lookdown(lookup) = 1:length(lookup);

cells = lookdown(cells);
% rgcs = lookdown(rgcs);
% tcrs = lookdown(tcrs);
% lins = lookdown(lins);

useSyn = sum(allEdges(:,1:2)~=0,2)==2;
syn = allEdges(useSyn,1:2);
syn = lookdown(syn);

con = zeros(num);
conInd = sub2ind([num num],syn(:,1),syn(:,2));
for i = 1:size(syn,1)
    con(syn(i,2),syn(i,1)) = con(syn(i,2),syn(i,1)) + 1;
end



%% find triads

triad = [];
c = 0;
for i = 1:length(cells)
    
    targ = cells(i);
    %     part1 = [allEdges(allEdges(:,1) == targ,2);...
    %         allEdges(allEdges(:,1) == targ,2)];
    part1 = find(con(targ,:)>0);
    part1 = setdiff(part1,targ);
    if ~isempty(part1)
        for p = 1:length(part1)
            targ2 = part1(p);
            part2 = find(con(targ2,:)>0); %third target
            link = intersect(part1,part2); %converge on same
            link = setdiff(link,targ2);
            if ~isempty(link)
                numTri = length(link);
                newTri = [repmat(targ,[numTri 1]) repmat(targ2,[numTri 1]),...
                    link']; %format source cell, second cell convergent target
                triad = cat(1,triad,newTri);
            end
        end
    end
end

triInd = sub2ind([num num num],triad(:,1),triad(:,2),triad(:,3));
triInd = unique(triInd);
[a b c] = ind2sub([num num num],triInd);
triad = [a b c];

cells = lookup(cells);
triad = lookup(triad);

%% Get list of triad synapses

anchors = double(obI.colStruc.anchors);
rawAnchors = anchors;

dSamp =  (obI.em.res .* [4 4 1])./1000./obI.em.dsRes;
anchors(:,1) = anchors(:,1)*dSamp(1);
anchors(:,2) = anchors(:,2)*dSamp(2);
anchors(:,3) = anchors(:,3)*dSamp(3);
anchors = round(anchors);
anchors(anchors<1) = 1;

eshift = [1 2; 1 3; 2 3];

tri.triCell = triad;
triSyn = {}; synPos = {}; synDir = {}; synPosRaw = {};
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

tri.triEdge = triEdge;
tri.synPos = synPos;
tri.synDir = synDir;
tri.synPosRaw = synPosRaw;

%% cell types
triClass = [];
triType = {};
for i = 1:size(triad,1)
   for t = 1:3
       
       if sum(intersect(rgcs,triad(i,t)))
           triType{i,t} = 'rgc';
           triClass(i,t) = 1;
       elseif sum(intersect(tcrs,triad(i,t)))
           triType{i,t} = 'tcr';
           triClass(i,t) = 2;
       elseif sum(intersect(lins,triad(i,t)))
           triType{i,t} = 'lin';
           triClass(i,t) = 3;
       else 
           triType{i,t} = 'unk';
           triClass(i,t) = 4;
       end
       
   end  
end

tri.triType = triType;
tri.triClass = triClass;



























