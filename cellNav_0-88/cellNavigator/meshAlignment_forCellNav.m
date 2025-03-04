global glob globMA

load('MPN.mat');
load([MPN 'obI.mat'])
load([MPN 'dsObj.mat'])

groupList = globMA.groupList;
cidList = [glob.g(groupList).cid];

for i = 1:length(cidList)
    %     fileName = sprintf('%s%d.mat',glob.useFvDir,cidList(i));
    %     disp(sprintf('loading cid%d, %d of %d',cidList(i),i,length(cidList)))
    %     fv = loadFV(fileName);
    %     allVert{i} = fv.vertices;
    cellSubs{i} = getCellSubs(obI,dsObj,cidList(i));

end

%% Collect cell positions and average in Y and X
clear meanYX cellZ
minZ = inf;
maxZ = -inf;
f = figure;
hold on
for c = 1:length(cellSubs)
    subs = cellSubs{c};
    if ~isempty(subs)
        uZ = unique(subs(:,3));
        cellZ{c} = uZ;
        minZ = min(minZ,min(subs(:,3)));
        maxZ = max(maxZ,max(subs(:,3)));
        for z = 1:length(uZ)
            isZ = find(subs(:,3)==uZ(z));
            meanYX{c}(z,:) = mean(subs(isZ,1:2),1);
        end

        plot3(meanYX{c}(:,1),meanYX{c}(:,2),cellZ{c});
        drawnow
    end
end

%% find pairs of y and x mean positions for each z step
clear yPair xPair
zRange = minZ:maxZ;
for c = 1:length(cellZ)
    cZ = cellZ{c};
    for z = 1:length(zRange)-1
        if c ==1
            yPair{z} = [];
            xPair{z} = [];
        end
        z1 = zRange(z);
        z2 = zRange(z+1);

            mean1 = meanYX{c}(cZ==z1,:);
            mean2 = meanYX{c}(cZ==(z2),:);
            if (~isempty(mean1) & ~isempty(mean2))
                yPair{z} = cat(2,yPair{z},[mean1(1);mean2(1)]);
                xPair{z} = cat(2,xPair{z},[mean1(2);mean2(2)]);
            end
    end
end

%% Find offsets for each z step


yShift = zeros(length(yPair),1);
xShift = yShift;
for z = 1:length(yPair)
    if 1 %check against other points
        yP = yPair{z};
        xP = xPair{z};
        pNum = size(yP,2);


        yD = yP(1,:)-yP(2,:);
        xD = xP(1,:)-xP(2,:);
        
        D = [yD' xD'];
        

        for n = 1:100
            neighborHood = n;
            minNeighbors = ceil(length(yD)/2);

            [dIdx core] = dbscan(D,neighborHood, minNeighbors);

%             clf
%             hold on
%             scatter(xD(1,:),yD(1,:),'b')
%             scatter(xD(dIdx==1),yD(dIdx==1),'r')
%             scatter(xD(core==1),yD(core==1),'r','.')
% 
%             pause

            if sum(core)
                break
            end
        end

        yShift(z) = mean(yD(core));
        xShift(z) = mean(xD(core));

        newY = yP(2,:)+yShift(z);
        newX = xP(2,:)+xShift(z);

        clf
        hold on
        scatter(xP(1,:),yP(1,:),'b')
        scatter(xP(2,:),yP(2,:),'r')
        scatter(newX,newY,'r','.')
        xlim([600 1800])
        ylim([800 2000])
        drawnow
    end

end

cumYShift = [0; cumsum(yShift)];
cumXShift = [0; cumsum(xShift)];

clf
    hold on
for c = 1:length(cellZ)

    cZ = cellZ{c};
    if ~isempty(cZ)
    cYshift = cumYShift(cZ);
    cXshift = cumXShift(cZ);
    cYX = meanYX{c};
    cYXshift = cYX - [cYshift cXshift];

    subplot(2,1,1)
        hold on

    plot(cZ,cYX(:,2),'r')

    subplot(2,1,2)
    hold on

    plot(cZ,cYXshift(:,2),'g')
    pause
    end

end



%%%%
%{
if 0 %3d point cloud


    T = zeros(3);
    T(3,3) = 1;

    if pNum >=3

        pc1 = [yP(1,:)' xP(1,:)' xP(1,:)'*0];
        pc2 = [yP(2,:)' xP(1,:)' xP(1,:)'*0];
        ptCloud1 = pointCloud(pc1);
        ptCloud2 = pointCloud(pc2);

        tform3D = pcregistericp(ptCloud2,ptCloud1);
        T(1:2,1:2) = tform3D.Rotation(1:2,1:2);
        T(3,1:2) = tform3D.Translation(1:2);
        tform2D = affine2d(T);

        [newX newY] = transformPointsForward(tform2D,xP(2,:),yP(2,:));

    else

        newY = yP(2,:);
        newX = xP(2,:);
        T(1,1) = 1;
        T(2,2) = 1;
        tform2D = affine2d(T);

    end

    end

if 0 %%shift by cluster

    maxShift = 4;
    maxR = 3;
    shiftInc = 1;
    rInc = .1;
    testShift = [-maxShift:shiftInc:maxShift];
    testR = 0;%[-maxR:rInc:maxR];




    points2 = [xP(2,:)' yP(2,:)'];
    clear yxD
    newX
    yxD = zeros(length(testShift),length(testShift),size(yP,2));
    for r = 1:length(testR);
        for x = 1:length(testShift);
            for y = 1:length(testShift);
                R = testR(r);
                Y = testShift(y);
                X = testShift(x);
                T = [cos(R) sin(R) 0; -sin(R) cos(R) 0; X Y 1];

                tform = rigid2d(T);
                [newX newY] = transformPointsForward(tform,xP(2,:),yP(2,:));
                yD = yP(1,:)-newY;
                xD = xP(1,:)-newX;
                yxD(y,x,:) = sqrt(xD.^2+yD.^2);


%                 clf
%                 hold on
%                 scatter(xP(1,:),yP(1,:),'b')
%                 scatter(xP(2,:),yP(2,:),'r')
%                 scatter(newX,newY,'r','.')
%                 mean(yxD(y,x,:))
%                 pause
            end
        end
    end

    %% find best shifts for each pair
    clear yB xB
    for p = 1:size(yxD,3)
        yxP = yxD(:,:,p);
        [yB(p) xB(p)] = find(yxP==min(yxP(:)),1);
    end

    yBshift = testShift(yB);
    xBshift = testShift(xB);

    yShift(z) = median(yBshift);
    xShift(z) = median(xBshift);
    T = [cos(R) sin(R) 0; -sin(R) cos(R) 0; xShift(z) yShift(z) 1];
    tform = rigid2d(T);
end


    if 0 %check against other points
        yD = yP(1,:)-yP(2,:);
        xD = xP(1,:)-xP(2,:);
        xS = xD-xD';
        yS = yD-yD';
        yxS = sqrt(xS.^2+yS.^2);
        medS = median(yxS,1);
        [a idx] = sort(medS,'ascend');
        useShifts = idx(1:ceil(length(idx)*aveChunk));
        yShift = mean(yD(useShifts));
        xShift = mean(xD(useShifts));

        newY = yP(2,:)+yShift;
        newX = xP(2,:)+xShift;

        clf
        hold on
        scatter(xP(1,:),yP(1,:),'b')
        scatter(xP(2,:),yP(2,:),'r')
        scatter(newX,newY,'r','.')
        xlim([600 1800])
        ylim([800 2000])
        pause
    end


% 
%     yP = yPair{z};
%     xP = xPair{z};
%     pNum = size(yP,2);
%    
%    if 0 %%shift by cluster
% 
%     maxShift = 4;
%     maxR = 3;
%     shiftInc = 1;
%     rInc = .1;
%     testShift = [-maxShift:shiftInc:maxShift];
%     testR = 0;%[-maxR:rInc:maxR];
% 
% 
% 
% 
%     points2 = [xP(2,:)' yP(2,:)'];
%     clear yxD
%     newX
%     yxD = zeros(length(testShift),length(testShift),size(yP,2));
%     for r = 1:length(testR);
%         for x = 1:length(testShift);
%             for y = 1:length(testShift);
%                 R = testR(r);
%                 Y = testShift(y);
%                 X = testShift(x);
%                 T = [cos(R) sin(R) 0; -sin(R) cos(R) 0; X Y 1];
% 
%                 tform = rigid2d(T);
%                 [newX newY] = transformPointsForward(tform,xP(2,:),yP(2,:));
%                 yD = yP(1,:)-newY;
%                 xD = xP(1,:)-newX;
%                 yxD(y,x,:) = sqrt(xD.^2+yD.^2);
% 
% 
% %                 clf
% %                 hold on
% %                 scatter(xP(1,:),yP(1,:),'b')
% %                 scatter(xP(2,:),yP(2,:),'r')
% %                 scatter(newX,newY,'r','.')
% %                 mean(yxD(y,x,:))
% %                 pause
%             end
%         end
%     end
% 
%     %% find best shifts for each pair
%     clear yB xB
%     for p = 1:size(yxD,3)
%         yxP = yxD(:,:,p);
%         [yB(p) xB(p)] = find(yxP==min(yxP(:)),1);
%     end
% 
%     yBshift = testShift(yB);
%     xBshift = testShift(xB);
% 
%     yShift(z) = median(yBshift);
%     xShift(z) = median(xBshift);
%     T = [cos(R) sin(R) 0; -sin(R) cos(R) 0; xShift(z) yShift(z) 1];
%     tform = rigid2d(T);
% end


%}




