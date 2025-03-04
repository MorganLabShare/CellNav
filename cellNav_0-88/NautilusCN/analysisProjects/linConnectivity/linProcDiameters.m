
%% measures the diameter of neurites based on 2D segmentations and compares diameter
%% to the process type of the associated skeleton node.

clear all
load('MPN.mat');
load([MPN 'obI.mat']);
load([MPN 'dsObj.mat'])
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

%% Fetch Subs

subCell = names2Subs(obI,dsObj,targCell);
sub = subCell{1};
subScale = sub * .2;

%% Match subs to skel

scatter3(sm.skelPos(:,1),sm.skelPos(:,2),sm.skelPos(:,3),'r')
hold on
scatter3(subScale(:,1),subScale(:,2),subScale(:,3),'g','.')
hold off


scatter(sm.skelPos(:,1),sm.skelPos(:,2),'r')
hold on
scatter(subScale(:,1),subScale(:,2),'g','.')
hold off


skelZs = unique(sm.skelPos(:,3));
subZs = unique(subScale(:,3));


for z = 1:length(skelZs)
    
    skelZ = skelZs(z)
    %% Get segmentation planes
    difZ = subZs-skelZ;
    [a b] = sort(abs(difZ),'ascend');
    closest = subZs(b(1:3));
    isClose = (subScale(:,3)==closest(1)) | (subScale(:,3) == closest(2)) | ...
        (subScale(:,3) == closest(3));
    closeVox = round(sub(isClose,:));
    
    I = zeros(ceil(max(closeVox(:,1))),ceil(max(closeVox(:,2))));
    inds = sub2ind(size(I),closeVox(:,1),closeVox(:,2));
    I(inds) = 1;
    %image(I*1000),pause(.01)

    lab = bwlabel(I,8);
    deep = bwdist(~I);
    [y x v] = find(lab);
    depth = deep(deep>0);  
    
    maxDistToDeep = 5; %pix distance to find middle of process
    %% get skel points
    
    checkNs = find(sm.skelPos(:,3) == skelZs(z));

    for n = 1:length(checkNs)
        checkPos = sm.skelPos(checkNs(n),:) / .2;
        hold on
        scatter(checkPos(1),checkPos(2))
        
        dist = sqrt((y-checkPos(1)).^2 + (x-checkPos(2)).^2);
        nearLab = find(dist==min(dist),1);
        distToLab(checkNs(n)) = min(dist);
        labVal = v(nearLab);
        
        checkDepth = find((v==labVal ) & ( dist<=maxDistToDeep));
        bestDepth = find(depth(checkDepth) == max(depth(checkDepth)),1)
        
        
        nearPix = [y(v==labVal) x(v==labVal)];
        nearestPix = [y(checkDepth(bestDepth)) x(checkDepth(bestDepth))];
        scatter(nearPix(:,2), nearPix(:,1),'r','.')
        hold on
        scatter(checkPos(2), checkPos(1),'b','o')
        hold off
    
       %% measure by rotation
       
       
       spinRad = 100;
       shiftPix = [nearPix(:,1) - nearestPix(:,1) nearPix(:,2) - nearestPix(:,2)] + spinRad +1;
       goodPix = ~sum((shiftPix<1) | (shiftPix >(spinRad * 2 + 1)),2);
       shiftPix = shiftPix(goodPix,:);
       spinI = zeros(spinRad * 2 + 1);
       shiftInd = sub2ind(size(spinI),shiftPix(:,1),shiftPix(:,2));
       spinI(shiftInd) = 1;
       
       angleStep = 5;
       divs = [0:angleStep:90];
       spinWidth = zeros(length(divs),1);
       
       
       
       
       
       for d = 1:length(divs)
           rotSpinI = imrotate(spinI,divs(d),'nearest','crop');
%            image(rotSpinI*1000)
%            hold on
%            scatter(spinRad + 1, spinRad + 1,'r','.')
%            hold off
%            pause(.01)
           
           labLine = rotSpinI(spinRad+1,:);
           difLine = labLine(2:end)-labLine(1:end-1);
           frontLine = find(difLine(1:spinRad)==1);
           backLine = find(difLine(spinRad:end)==-1);
           spinWidth(d) = spinRad - frontLine(end) + backLine(1) - 1;
       end
       minWidth(checkNs(n)) = min(spinWidth) * .2;
            min(spinWidth) 
       image(rotSpinI*1000)
           hold on
           scatter(spinRad + 1, spinRad + 1,'r','.')
           hold off
           pause(.01)
        
    end
    
end

%% analyze
sm.minWidth = minWidth;

axDiams = minWidth(sm.isAx)
targDiams = minWidth(sm.isTarg)
shaftDiams = minWidth(sm.isShaft)

rng = [0:.3:5]
hAxDiams = hist(axDiams,rng);
hTargDiams = hist(targDiams,rng);
hShaftDiams = hist(shaftDiams,rng);


plot(rng,hAxDiams/sum(hAxDiams),'r');
hold on
plot(rng,hTargDiams/sum(hTargDiams),'g');
plot(rng,hShaftDiams/sum(hShaftDiams),'b');

hold off

'ax'
mean(axDiams)
SE(axDiams)
length(axDiams)

'targ'
mean(targDiams)
SE(targDiams)
length(targDiams)

'shaft'
mean(shaftDiams)
SE(shaftDiams)
length(shaftDiams)




ranksum(shaftDiams, targDiams)





%%

























