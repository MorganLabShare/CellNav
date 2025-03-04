


clear all
%MPN = GetMyDir;
load('MPN.mat')
load([MPN 'obI.mat']);
seedList = [ 108 201 907 903 125];
plusOne = 125;
%seedList = [ 108  201 109 ];

% useList = obI2cellList_seedInput_RGC_TCR(obI,seedList);
useList = obI2nodes_rtl_plus1(obI,plusOne);

cellList = unique([plusOne; useList.preList(:); useList.postList(:);forceNodes]);

seedPref = seedPreferences(seedList,useList);
allEdges = obI.nameProps.edges(:,[2 1]);

preSyn = allEdges(allEdges(:,1)==plusOne,:);
[a b] = sort(preSyn(:,2),'ascend');
preSyn = preSyn(b,:);

postSyn = allEdges(allEdges(:,2) == plusOne, :);
[a b] = sort(postSyn(:,1),'ascend');
postSyn = postSyn(b,:);


preNum = preTo(allEdges,plusOne)
postNum = postTo(allEdges,plusOne)

%% filter for types

useNum = postNum;
cellList = useNum(:,1);
use = zeros(length(cellList),1);
for i = 1:length(cellList)
    
    currCell = cellList(i);
    targIDX = find(obI.cell.name==currCell);
    targ  = obI.cell.mainObID(targIDX);
    
    if obI.nameProps.rgc(targ)
        use(i) = 0;
    elseif obI.nameProps.tcr(targ)
        use(i) = 1;
    elseif obI.nameProps.lin(targ)
        use(i) = 0;
    else
        use(i) = 0;
    end
    
end

useNum = useNum(use>0,:);
[a b ]= sort(useNum(:,2),'descend');
useNum = useNum(b,:);

cumSyn = cumsum(useNum(:,2))/sum(useNum(:,2));
plot(cumSyn)

histRange = [1:20];
histConv = hist(useNum(:,2),histRange);
[histRange histConv]

bar(histRange',histConv)
%bar(histRange',histConv(:) .* histRange(:))

synapseNums = histRange.*histConv;
sum(synapseNums(histRange>=4))/sum(synapseNums)



%% test for clustering by assuming one synapse and redistributing second
reps = 10000;

tNum = size(postNum,1);
allSyn = sum(postNum(:,2),1);
sNum = allSyn-tNum;

randHistConv = zeros(reps,length(histRange));
for r = 1:reps
    drop = ceil(rand(sNum,1)*tNum);
    randConv = histc(drop,1:tNum)+1;
    randHistConv(r,:) = histc(randConv,histRange);
end

meanHistConv = mean(randHistConv,1);

bar([meanHistConv' histConv])

bar([(meanHistConv'.*histRange') (histConv.*histRange')])
bar([(meanHistConv'.*histRange') (histConv.*histRange')])



%% test for clustering by choosing arbitrary available targets

reps = 10000;

realTNum = size(postNum,1);
tNum = realTNum *1.32;
sNum = sum(postNum(:,2),1);

randHistConv = zeros(reps,length(histRange));
for r = 1:reps
    drop = ceil(rand(sNum,1)*tNum);
    randConv = histc(drop,1:tNum);
    randHistConv(r,:) = histc(randConv,histRange);
end

meanHistConv = mean(randHistConv,1);
mean(sum(randHistConv,2))




bar([meanHistConv' histConv])

bar([(meanHistConv'.*histRange') (histConv.*histRange')])
























