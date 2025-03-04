function[sm] = getTopoEucDistBetweenSyn(sm)

%% Get data
loadData = 1;
if loadData
    %MPN = GetMyDir;
    load('MPN.mat');
    WPN = MPN;
    DPN = [MPN 'data\'];
    if ~exist(DPN,'dir'),mkdir(DPN);end
    load([MPN 'obI.mat']);
    allEdges = obI.nameProps.edges(:,[2 1]);
    
end

show = 0;
cells = obI.cell.name(obI.cell.isCell>0);

%% Get skeletons
minTip = 1;
minSpace = 1;

load([MPN 'nep\skelNep125.mat'])

%load([MPN 'nep\useSynPos125.mat'])
pos = nep.nodePos;
edges = nep.edges;
lengths = sqrt((pos(edges(:,1),1)-(pos(edges(:,2),1))).^2 + ...
    (pos(edges(:,1),2)-(pos(edges(:,2),2))).^2 + ...
    (pos(edges(:,1),3)-(pos(edges(:,2),3))).^2);

pts = sm.pos;


dif = cat(3,pts(:,1)-pts(:,1)',pts(:,2)-pts(:,2)',pts(:,3)-pts(:,3)');
sm.eucDist = sqrt(sum(dif.^2,3));

%nepSyn = obISyn2nep(obI);
%nepSyn = linkSyn2Skel(nepSyn,skels);


%% One at a time

syn = [sm.pre sm.post];

cellID = 125;
skel = nep;
sPos = skel.nodePos;

isSyn = find((syn(:,2) == cellID) | (syn(:,1) == cellID));

distThresh = 5;
if length(isSyn)>1
    synPos = sm.pos(isSyn,:);
    syns = 1:length(isSyn);
    
    pairs = nchoosek(syns,2);
    clear pLengths eucDist keepPaths keepLengths
    
    for p = 1:size(pairs,1)
        if ~mod(p,1000)
            disp(sprintf('measuring pair %d of %d.',p,size(pairs,1)))
        end
        pos1 = synPos(pairs(p,1),:);
        pos2 = synPos(pairs(p,2),:);
        
        eucDist(p) = sqrt((pos1(1)-pos2(1)).^2 + (pos1(2)-pos2(2)).^2 + ...
            (pos1(3)-pos2(3)).^2 );
        
        if eucDist(p) <= distThresh
            
            
            syn2Skel = sqrt((sPos(:,1)-pos1(1)).^2 + (sPos(:,2)-pos1(2)).^2 + ...
                (sPos(:,3)-pos1(3)).^2 );
            link1 = (find(syn2Skel==min(syn2Skel),1));
            
            syn2Skel = sqrt((sPos(:,1)-pos2(1)).^2 + (sPos(:,2)-pos2(2)).^2 + ...
                (sPos(:,3)-pos2(3)).^2 );
            link2 = (find(syn2Skel==min(syn2Skel),1));
            
            %% find path
            if link1 ~= link2
                edges = skel.edges;
                nodePos = sPos;
                startNode = link1;
                stopNode = link2;
                
                pp = node2nodeDist(edges,lengths,startNode,stopNode);
                %pp = node2nodeDist(edges,lengths,startNode);
                path = pp.path;
                
                
                
                %             scatter3(sPos(:,1),sPos(:,2),sPos(:,3),2,'k','filled')
                %             scatter3(sPos(:,1),sPos(:,2),sPos(:,3),[],pp.dists)
                %             hold on
                %             scatter3(sPos(startNode,1),sPos(startNode,2),sPos(startNode,3),300,'g','filled')
                %             scatter3(sPos(stopNode,1),sPos(stopNode,2),sPos(stopNode,3),300,'r','filled')
                %             hold off
                
                
                
                %                 %% path length
                %                 clear pLengths
                %                 for pa = 1:size(path,1)
                %                     pLengths(pa) = sqrt((sPos(path(pa,1),1) - sPos(path(pa,2),1)).^2 + ...
                %                         (sPos(path(pa,1),2) - sPos(path(pa,2),2)).^2 +...
                %                         (sPos(path(pa,1),3) - sPos(path(pa,2),3)).^2);
                %                     plot3(sPos(path(pa,:),1),sPos(path(pa,:),2),...
                %                         sPos(path(pa,:),3),'r','linewidth',4)
                %                 end
                
                pLengths(p) = max(pp.cumDist);
                keepPaths{p} = pp.path;
                keepLengths{p} = pp.cumDist;
                
                %% show path
                if show
                    scatter3(pos1(1),pos1(2),pos1(3),'r','filled')
                    scatter3(pos2(1),pos2(2),pos2(3),'g','filled')
                    scatter3(sPos(link1,1),sPos(link1,2),sPos(link1,3),'m','filled')
                    scatter3(sPos(link2,1),sPos(link2,2),sPos(link2,3),'c','filled')
                    
                    scatter3(sPos(path(:),1),sPos(path(:),2),sPos(path(:),3),'b','filled')
                    sum(pLengths)
                    eucDist(p);
                    pathRat = sum(pLengths)/eucDist(p);
                    pause(.1)
                    %pause
                    hold off
                end
            else
                pLengths(p) = 0;
                keepPaths{p} = [];
                keepLengths{p} = [];
            end
        else % same node on arbor
            pLengths(p) = 0;
            keepPaths{p} = [];
            keepLengths{p} = [];
        end
        
    end %run all pairs
    
else % no pairs on cell
    pLengths = [];
    eucDist = [];
    keepPaths = [];
    keepLengths = [];
end

useLength = max(pLengths,eucDist);
sm.dist = sm.eucDist;
sm.eucDist = sm.eucDist;
synInd = sub2ind(size(sm.dist),isSyn(pairs(:,1)),isSyn(pairs(:,2)));
sm.dist(synInd) = useLength;
%scatter(sm.eucDist(synInd),sm.dist(synInd),'.')









