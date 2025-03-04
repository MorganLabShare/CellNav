function[aPos] = runFindAppositions()

disp('run apposition')

global glob globFA
showI = 0;


look = globFA.appDist;

f = figure

%% Get fv for group 1

idx1 = globFA.group1.idx;
cid1 = glob.cids(idx1);
vert1 = [];
fac = [];
num = 0;
for i  = 1:length(cid1)
    
    fileName = sprintf('%s%d.mat',glob.useFvDir,cid1(i));
    fv = loadFV(fileName);
    vert1 = cat(1,vert1,fv.vertices);
    num = size(vert1,1);
    fac = cat(1,fac,fv.faces + num);
    
end

fv1.vertices = vert1;
fv1.faces = fac;



%% Get fv for group 2

idx2 = globFA.group2.idx;
cid2 = glob.cids(idx2);
vert2 = [];
fac = [];
num = 0;
for i  = 1:length(cid2)
    
    fileName = sprintf('%s%d.mat',glob.useFvDir,cid2(i));
    fv = loadFV(fileName);
    vert2 = cat(1,vert2,fv.vertices);
    num = size(vert2,1);
    fac = cat(1,fac,fv.faces + num);
    
end

fv2.vertices = vert2;
fv2.faces = fac;


offSet = min(min(vert1,[],1),min(vert2,[],1));
%offSet = [0 0 0];
vert1 = vert1 - repmat(offSet,[size(vert1,1) 1]) ;
vert2 = vert2 - repmat(offSet,[size(vert2,1) 1]) ;

%% down sample verticies into search blocks
ds = 2;
ds1 = round(vert1/ds)+1;
m1 = max(ds1,[],1);
ind1 = sub2ind(m1,ds1(:,1),ds1(:,2),ds1(:,3));
[ind1 ia ic1] = unique(ind1);
[Y X Z] = ind2sub(m1,ind1);
ds1 = ([Y X Z] - 1)*ds;

ds2 = round(vert2/ds)+1;
m2 = max(ds2,[],1);
ind2 = sub2ind(m2,ds2(:,1),ds2(:,2),ds2(:,3));
[ind2 ia ic2] = unique(ind2);
[Y X Z] = ind2sub(m2,ind2);
ds2 = ([Y X Z]-1)*ds;

%% Get distances between search blocks 
difY = ds1(:,1) - ds2(:,1)';
difX = ds1(:,2) - ds2(:,2)';
difZ = ds1(:,3) - ds2(:,3)';

dist = sqrt(difY.^2 + difX.^2 + difZ.^2);

dsThresh = sqrt(ds.^2 + ds.^2 + ds.^2)+look;

[g1 g2] = find(dist<=dsThresh); %Find points that are close together


%% Run Ds

if showI
    f = figure;
    %     scatter3(vert1(:,1),vert1(:,2),vert1(:,3),3,'o','r','filled','MarkerEdgeAlpha',.0,'MarkerFaceAlpha',.02)
    %     hold on
    %     scatter3(vert2(:,1),vert2(:,2),vert2(:,3),3,'o','b','filled','MarkerEdgeAlpha',.0,'MarkerFaceAlpha',.02)
    %     set(gca,'clipping', 'off')
    %     pause(.01)
    scatter3(vert1(:,1),vert1(:,2),vert1(:,3),3,'.','r')
    hold on
    scatter3(vert2(:,1),vert2(:,2),vert2(:,3),3,'.','b')
    set(gca,'clipping', 'off')
    pause(.01)
end

%% Search for vertices within each block
aMean = zeros(1000,3);
aDists = zeros(1000,1);
oldL = 0;
newL = 0;
for i = 1:length(g1)
    tic

    is1 = find(ic1==g1(i));
    sub1 = vert1(is1,:);
    is2 = find(ic2==g2(i));
    sub2 = vert2(is2,:);
    
    difY = sub1(:,1) - sub2(:,1)';
    difX = sub1(:,2) - sub2(:,2)';
    difZ = sub1(:,3) - sub2(:,3)';
    
    dist = sqrt(difY.^2 + difX.^2 + difZ.^2);
    
    %% select closest points under threshold
    [s1 s2] = find(dist<=look);
    d = dist(dist<=look);


    sMean = mean(cat(3,sub1(s1,:),sub2(s2,:)),3); %middle point between nearby verticies


    newL = size(sMean,1);
    fullL = size(aMean,1);
    if (oldL + newL ) > fullL
        aMean(fullL * 2,:) = [0 0 0];
        aDists(fullL * 2) = 0;
    end
    aMean(oldL+1:oldL+newL,:) = sMean;
    aDists(oldL+1:oldL+newL) = d;

    oldL = oldL+newL;

    if ~mod(i,10)
        set(globFA.h.textOut,'String',sprintf('Checking %d of %d points',i,length(g1)))
        if  showI & (size(sMean,1)>0)
            scatter3(sMean(:,1),sMean(:,2),sMean(:,3),3,'o','g','markerfacealpha',.1)
        end
        drawnow
        toc
    end
end

aMean = aMean(1:oldL,:);
aDists = aDists(1:oldL);

%% down sample appositions
if ~isempty(aMean)
    dsRes = globFA.outputGrid ;
    
    dsA = round(aMean*dsRes)+1;
    mA = max(dsA,[],1);
    indA = sub2ind(mA,dsA(:,1),dsA(:,2),dsA(:,3));
    [indA ia icA] = unique(indA);
    [Y X Z] = ind2sub(mA,indA);
    dsA = ([Y X Z]-1) / dsRes;
    
    aPos = zeros(length(indA),3);
    for i = 1:length(indA)
        subMean =  aMean(icA == i,:);
        subDist = aDists(icA == i );
        useD = subDist == min(subDist);
        aPos(i,:) = mean(subMean(useD,:),1);
    end
    
    if showI
        scatter3(aPos(:,1),aPos(:,2),aPos(:,3),300,'o','m','filled')
        hold off
        pause(.01)
    end
    
    aPos = aPos + repmat(offSet,[size(aPos,1),1]);

    
else
    aPos = [];
end

pause(2)
try
    close(f)
end
