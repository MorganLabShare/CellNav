clear all
load('MPN.mat');
load([MPN 'obI.mat']);
targCell = 125;
maxDist = 3;
iptsetpref('ImshowBorder','tight');

disp('combining spreadsheet and segmentation synapses')
sm = addDatToSynMat(obI)
disp('finding topological distance between synapses on target cell within max range')
sm  = getTopoEucDistBetweenSyn(sm);
sm = getTopoEucDistBetweenSkelAndSyn(sm);
%sm = getTortSkel(sm);
sm = labelShaftSkel(sm);



%%
targetStep = 4;

edge = sm.skelEdges;
pos = sm.skelPos;
nodes = sm.skelNodes;

steps = 10;
span = zeros(length(nodes),steps);
path = span;
pathNodes = zeros(length(nodes),targetStep*2+1);
targetSpan = zeros(length(nodes),1);
targetPath = targetSpan;


for i = 1:length(nodes)
    
    ns = nodes(i);
    usedNodes =  ns;
    
    hit1 = edge(edge(:,1) == ns,2);
    hit2 = edge(edge(:,2) == ns,1);
    
    tr = 0;
    trackPos1 = pos(ns,:);
    trackPos2 = pos(ns,:);
    
    if  (length(hit1) == 1) & (length(hit2)==1) %only linear non-branched segments
        
        usedNodes = [usedNodes hit1 hit2];
        
        trackPos1 = cat(1,trackPos1,pos(hit1,:));
        trackPos2 = cat(1,trackPos2,pos(hit2,:));
        
        span(i,1) = sqrt((pos(hit1,1)-pos(hit2,1)).^2 + ...
            (pos(hit1,2)-pos(hit2,2)).^2 + (pos(hit1,3)-pos(hit2,3)).^2);
        
        path(i,1) = sqrt((pos(hit1,1)-pos(ns,1))^2 + ...
            (pos(hit1,2)-pos(ns,2))^2 + (pos(hit1,3)-pos(ns,3))^2);
        
        path(i,1) = path(i,1) + sqrt((pos(hit2,1)-pos(ns,1)).^2 + ...
            (pos(hit2,2)-pos(ns,2)).^2 + (pos(hit2,3)-pos(ns,3)).^2);
        
        if 0
            hold off
            scatter3(pos(ns,1),pos(ns,2),pos(ns,3),1000,'.','r')
            daspect([1 1 1])
            hold on
            
            tr = tr + sqrt((pos(hit1,1)-pos(ns,1)).^2 + ...
                (pos(hit1,2)-pos(ns,2)).^2 + (pos(hit1,3)-pos(ns,3)).^2)
            tr = tr + sqrt((pos(hit2,1)-pos(ns,1)).^2 + ...
                (pos(hit2,2)-pos(ns,2)).^2 + (pos(hit2,3)-pos(ns,3)).^2)
            scatter3(pos(hit1,1),pos(hit1,2),pos(hit1,3),1000,'.','b')
            scatter3(pos(hit2,1),pos(hit2,2),pos(hit2,3),1000,'.','b')
        end
        
        for step = 2 : steps
            
            hit1a = edge(edge(:,1) == hit1,2);
            hit1b = edge(edge(:,2) == hit1,1);
            hit1c = setdiff([hit1a; hit1b],usedNodes);
            
            hit2a = edge(edge(:,1) == hit2,2);
            hit2b = edge(edge(:,2) == hit2,1);
            hit2c = setdiff([hit2a; hit2b], usedNodes);
            
            if  (length(hit1c) == 1) & (length(hit2c)==1)
                usedNodes = [usedNodes hit1c hit2c];
                
                trackPos1 = cat(1,trackPos1,pos(hit1c,:));
                trackPos2 = cat(1,trackPos2,pos(hit2c,:));
                
                span(i,step) = sqrt((pos(hit1c,1)-pos(hit2c,1)).^2 + ...
                    (pos(hit1c,2)-pos(hit2c,2)).^2 + (pos(hit1c,3)-pos(hit2c,3)).^2);
                
                path(i,step) = path(i,step-1) + sqrt((pos(hit1,1)-pos(hit1c,1)).^2 + ...
                    (pos(hit1,2)-pos(hit1c,2)).^2 + (pos(hit1,3)-pos(hit1c,3)).^2);
                
                path(i,step) = path(i,step) + sqrt((pos(hit2,1)-pos(hit2c,1)).^2 + ...
                    (pos(hit2,2)-pos(hit2c,2)).^2 + (pos(hit2,3)-pos(hit2c,3)).^2);
                
                if 0
                    tr = tr + sqrt((pos(hit1,1)-pos(hit1c,1)).^2 + ...
                        (pos(hit1,2)-pos(hit1c,2)).^2 + (pos(hit1,3)-pos(hit1c,3)).^2)
                    tr = tr + sqrt((pos(hit2,1)-pos(hit2c,1)).^2 + ...
                        (pos(hit2,2)-pos(hit2c,2)).^2 + (pos(hit2,3)-pos(hit2c,3)).^2)
                    scatter3(pos(hit1c,1),pos(hit1c,2),pos(hit1c,3),1000*step,'.','c')
                    scatter3(pos(hit2c,1),pos(hit2c,2),pos(hit2c,3),1000*step,'.','b')
                    scatter3(pos(hit1,1),pos(hit1,2),pos(hit1,3),1000*step,'.','g')
                    scatter3(pos(hit2,1),pos(hit2,2),pos(hit2,3),1000*step,'.','m')
                end
                
                hit1 = hit1c;
                hit2 = hit2c;
                
                axis square
                
                
                if step  == targetStep
                    
                    pathNodes(i,:) = usedNodes;
                    targetSpan(i) = span(i,step);
                    targetPath(i) = path(i,step);
                    
                end
                
                
                %                 sp = span(i,step)
                %                 pa = path(i,step)
                %                 tr
            else % wrong hit num
                
                break
            end
            
        end  % check steps
        
    end
    
    
    if 0 % recheck path
        trackPos = cat(1,flipud(trackPos1), (trackPos2(2:end,:)))
        
        pathCheck = zeros(size(trackPos1,1)-1,2);
        spanCheck = zeros(size(trackPos1,1)-1,1);
        
        if size(trackPos,1)>1
            
            hold off
            scatter3(trackPos(:,1),trackPos(:,2),trackPos(:,3),500,'.')
            hold on
            plot3(trackPos(:,1),trackPos(:,2),trackPos(:,3),'r')
            daspect([1 1 1])
            
            L = 0;
            for p = 1:size(trackPos,1)-1
                L = L + sqrt((trackPos(p,1)-trackPos(p+1,1)).^2 + ...
                    (trackPos(p,2)-trackPos(p+1,2)).^2 + (trackPos(p,3)-trackPos(p+1,3)).^2 )
                plot3(trackPos(p:p+1,1),trackPos(p:p+1,2),trackPos(p:p+1,3),'g')
                pause(.01)
            end
            L2 = sqrt((trackPos(1,1)-trackPos(end,1)).^2 + ...
                (trackPos(1,2)-trackPos(end,2)).^2 + (trackPos(1,3)-trackPos(end,3)).^2 )
            
            
            for p = 1:size(trackPos1,1)-1
                pathCheck(p,1) = sqrt((trackPos1(p,1)-trackPos1(p+1,1)).^2 + ...
                    (trackPos1(p,2)-trackPos1(p+1,2)).^2 + (trackPos1(p,3)-trackPos1(p+1,3)).^2 );
                pathCheck(p,2) = sqrt((trackPos2(p,1)-trackPos2(p+1,1)).^2 + ...
                    (trackPos2(p,2)-trackPos2(p+1,2)).^2 + (trackPos2(p,3)-trackPos2(p+1,3)).^2 );
                spanCheck(p) = sqrt((trackPos1(p+1,1)-trackPos2(p+1,1)).^2 + ...
                    (trackPos1(p+1,2)-trackPos2(p+1,2)).^2 + (trackPos1(p+1,3)-trackPos2(p+1,3)).^2 );
            end
            
            pathLength = cumsum(sum(pathCheck,2))
            
        end
        
        pause
    end
end

%%Find nodeMax
pathNodes(i,:) = usedNodes;
targetSpan(i) = span(i,step);
targetPath(i) = path(i,step);
targetRat = targetPath./targetSpan;
targetRat(isnan(targetRat)) = 0;
targetMaxRat = targetRat *0;
for i = 1:length(nodes)
    isNode = sum(pathNodes==nodes(i),2)>0;
    if sum(isNode)
        maxRat = max(targetRat.*isNode);
        targetMaxRat(i) = maxRat;
    end
end

%% find average value for nodes

foundNodes = unique(pathNodes(:));
for i = 1:length(foundNodes);
    [y x] = find(pathNodes==foundNodes(i));
    spanVal = span(y);
    pathVal = path(y);
    useVal = spanVal>0;
    voteTort(i) = mean(pathVal(useVal)./spanVal(useVal));

end
%% Show Tort


if 0
    checkStep = 2;
    
    useStep = path(:,checkStep)>0;
    findStep = find(useStep);
    rats = path./span;
    rats(isnan(rats)) = 0;
    path(useStep,checkStep) ./ span(useStep,checkStep);
    rat = rats(useStep,checkStep);
else
    useStep = targetMaxRat>0;
    findStep = find(useStep);
    rat = targetMaxRat(useStep);
end


cmap = jet(100);
val = round((rat-1)*300);
val(val<1) = 1;
val(val>100) = 100;
faceCol = cmap(val,:);


faceCol = cat(2,(rat-1)*3,(rat-1)*10, 1 - (rat-1) * 3);
faceCol(faceCol>1) = 1;
faceCol(faceCol<0) = 0;
faceCol(isnan(faceCol)) = 0;

%scatter3(pos(useStep,1),pos(useStep,2),rats,'.')
hold off
%scatter3(pos(:,1),pos(:,2),pos(:,3),'.','markeredgecolor',[.6 .6 .6])
scatter(pos(:,2),pos(:,1),'.','markeredgecolor',[.6 .6 .6])

set(gcf,'color','k')
set(gca,'color','k')
axis 'off'

hold on
for r = 1:length(rat)
    %     scatter3(pos(findStep(r),1),pos(findStep(r),2),pos(findStep(r),3),...
    %         'markerfacecolor',faceCol(r,:),'markeredgecolor','none','marker','o');
    scatter(pos(findStep(r),2),pos(findStep(r),1),...
        'markerfacecolor',faceCol(r,:),'markeredgecolor','none','marker','o');
    pause(.01)
end
hold off


if 0
    springDir = 'D:\LGNs1\Analysis\LIN\revision\';
    if ~exist(springDir,'dir'), mkdir(springDir), end
    
    set(gcf,'PaperUnits','points','PaperPosition',[1 1 1024 1024])
    set(gcf, 'InvertHardCopy', 'off');
    tag = 'tortuosity15';
    
    epsName = sprintf('%sspringRun_%s.eps',springDir,tag);
    print(gcf, epsName, '-depsc2','-painters','-r300')
end

%% compare neurite types

if 0
    axCheck = sm.isAx' & (rats(:,checkStep)>0);
    shaftCheck = sm.isShaft' & (rats(:,checkStep)>0);
    targCheck = sm.isTarg' & (rats(:,checkStep)>0);
else
    
    axCheck = sm.isAx' & (targetMaxRat>0);
    shaftCheck = sm.isShaft' & (targetMaxRat>0);
    targCheck = sm.isTarg' & (targetMaxRat>0);
    
end

axRats = targetMaxRat(axCheck & (targetMaxRat>0));
shaftRats = targetMaxRat(shaftCheck & (targetMaxRat>0));
targRats = targetMaxRat(targCheck & (targetMaxRat>0));
allRats = targetMaxRat(targetMaxRat>0);

%scatter3(pos(useStep,1),pos(useStep,2),rats,'.')
% hold off
% scatter3(pos(:,1),pos(:,2),pos(:,3),'.','markeredgecolor',[.6 .6 .6])
%
% markerType = {'o','d','.'}
% hold on
% for r = 1:length(rat)
%     scatter3(pos(findStep(r),1),pos(findStep(r),2),pos(findStep(r),3),...
%          'markerfacecolor',faceCol(r,:),'markeredgecolor','none',...
%          'marker',markerType{sm.type(findStep(r))});
%
%    pause(.01)
% end
% hold off

'axon rats'
%median(axRats)
mean(axRats)
SE(axRats)
length(axRats)

'shaft rats'
%median(shaftRats)
mean(shaftRats)
SE(shaftRats)
length(shaftRats)

'targ rats'
%median(targRats)
mean(targRats)
SE(targRats)
length(targRats)

'all rats'
%median(allRats)
mean(allRats)
SE(allRats)
length(allRats)


hRange = [0 : .03 : 3];
axHist = hist(axRats,hRange)/length(axRats);
shaftHist = hist(shaftRats, hRange)/length(shaftRats);
targHist = hist(targRats, hRange)/length(targRats);
allHist = hist(allRats, hRange)/length(allRats);

ranksum(targRats,shaftRats)
ranksum(targRats,axRats)
ranksum(axRats,shaftRats)

clf


%bar(hRange,[shaftHist;targHist;axHist]')

plot(hRange,shaftHist/sum(shaftHist),'b')
hold on
plot(hRange,targHist/sum(targHist),'g')
plot(hRange,axHist/sum(axHist),'r')
plot(hRange,allHist/sum(allHist),'k')
hold off














