function[pp] = shortestPoint2Point(edges,pos,points1,points2);

%%function[pp] = shortestPoint2Point(edges,pos,points1,points2);
%Associate points to possitions on a skeleton and then run node2nodeDist
%to find topological distances either two groups of points (if no points2
%exists or between points1 and all points in the possition list


if ~exist('points2','var')
    points2 = pos;
    allPos = 1;
else
    allPos = 0;
end

%% find closest nodes 


posDists = sqrt((points1(:,1)-pos(:,1)').^2 + (points1(:,2)-pos(:,2)').^2  + (points1(:,3)-pos(:,3)').^2);
minDist1 = min(posDists,[],2);
isNode1 = minDist1 * 0;
for p = 1:size(points1,1)
    isNode1(p,1) = find(posDists(p,:) == minDist1(p),1);
end

    posDists = sqrt((points2(:,1)-pos(:,1)').^2 + (points2(:,2)-pos(:,2)').^2  + (points2(:,3)-pos(:,3)').^2);
    minDist2 = min(posDists,[],2);
    isNode2 = minDist2 * 0;
    for p = 1:size(points2,1)
        isNode2(p,1) = find(posDists(p,:) == minDist2(p),1);
    end

%
% scatter3(pos(:,1),pos(:,2),pos(:,3),'.','k')
% hold on
% scatter3(points1(:,1),points1(:,2),points1(:,3),'.','g')
% bad = minDist1>100;
% scatter3(points1(bad,1),points1(bad,2),points1(bad,3),'.','r')
% hold off


%% get edge lengths

edgeLength = getLengths(edges,pos);


%% Get euclidian
posDists = sqrt((points1(:,1)-points2(:,1)').^2 + (points1(:,2)-points2(:,2)').^2  + (points1(:,3)-points2(:,3)').^2);
eucMinDist = min(posDists,[],2);
pp.eucMinDist = eucMinDist;
pp.eucDists = posDists;


%% get distances
for i = 1:length(isNode1);
    disp(sprintf('running %d of %d',i,length(isNode1)))
    
    %paths = shortestPathToSeed(edges,edgeLength,isNode1(i),pos);
  if allPos
     pp.topo(i) = node2nodeDist(edges,edgeLength,isNode1(i));

  else
    pp.topo(i) = node2nodeDist(edges,edgeLength,isNode1(i),isNode2);
  end
end


pp.distMat = cat(2,pp.topo.dists);
pp.topoMinDist = min(pp.distMat,[],1);
pp.topoMinDistBack = min(pp.distMat,[],2);
pp.minMax = max(pp.topoMinDist,pp.eucMinDist);





















