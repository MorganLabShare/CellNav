clear all
load('MPN.mat');
load([MPN 'obI.mat']);
targCell = 125;
maxDist = 5;
iptsetpref('ImshowBorder','tight');

disp('combining spreadsheet and segmentation synapses')
sm = addDatToSynMat(obI)
disp('finding topological distance between synapses on target cell within max range')
sm  = getTopoEucDistBetweenSyn(sm);
sm = getTopoEucDistBetweenSkelAndSyn(sm)

%% analyze Motifs


isTarg =(sm.pre == targCell) | (sm.post == targCell);
isRGC = sm.preClass == 1;
isTC = sm.postClass == 2;
isPreLIN = sm.preClass == 3;
isPostLIN = sm.postClass == 3;
isPreUNK = sm.preClass == 4;


%search all RGC input, check for non RGC TC
%search all LIN input, check for isolated LIN output
%search for all UNK input


%% find checkIn relative motifs

findRGC = find(isRGC & isTarg);
findTC = find(isTC & isTarg);


[checkRgc] = checkMotifAroundSyns(sm,find(isRGC & isTarg),maxDist);
[checkPreLin] = checkMotifAroundSyns(sm,find(isPreLIN & (sm.post == targCell)),maxDist);
[checkUnk] = checkMotifAroundSyns(sm,find(isPreUNK & isTarg),maxDist);
[checkPostLin] = checkMotifAroundSyns(sm,find(isPostLIN & (sm.pre == targCell)),maxDist);
[checkTc] = checkMotifAroundSyns(sm,find(isTC & isTarg),maxDist);





%% Simple stats

for i = 1:100;%length(checkRgc.m)
    checkRgc.m(i)
    
    c(i) = checkRgc.m(i).preTcDi;
end
plot([checkRgc.m.diadTCs])
hold on
plot([checkTc.m.diadRGCs])
hold off


plot([checkRgc.m.preTcTri])
hold on
plot([checkRgc.m.preTcDi])
hold off


numTCnearRGCLIN = [checkRgc.m.diadTCs]
numRGCnearLINTC = [checkTc.m.diadRGCs]

histRange = [0:30];
histNumTC = hist(numTCnearRGCLIN,histRange);
histNumRGC = hist(numRGCnearLINTC,histRange);
scatter(histRange,histNumTC/sum(histNumTC),'b')
hold on
scatter(histRange,histNumRGC/sum(histNumRGC),'r')
hold off

cumSumTC = cumsum(histNumTC,'reverse')/sum(histNumTC);
cumSumRGC = cumsum(histNumRGC,'reverse')/sum(histNumRGC);

median(numTCnearRGCLIN)
median(numRGCnearLINTC)

mean(numTCnearRGCLIN)
mean(numRGCnearLINTC)

plot(histRange,cumSumTC,'r')
hold on
plot(histRange,cumSumRGC,'g')
hold off

sum(numTCnearRGCLIN>0)
sum(numRGCnearLINTC>0)

%% random stats
reps = 1000;
numTCnearRGCLINRand = zeros(reps,length(find(isRGC & isTarg)));
numRGCnearLINTCRand = zeros(reps,length(find(isTC & isTarg)));
cumSumTCRand = zeros(reps,length(histRange));
cumSumRGCRand = zeros(reps,length(histRange));


for r = 1:reps
    sprintf('running %d of %d',r,reps)
    [checkRgcRand] = checkMotifAroundSynsRandShort(sm,findRGC,maxDist);
    [checkTcRand] = checkMotifAroundSynsRandShort(sm,findTC,maxDist);
    


    numTCnearRGCLINRand(r,:) = [checkRgcRand.m.diadTCs];
    numRGCnearLINTCRand(r,:) = [checkTcRand.m.diadRGCs];

    histNumTCRand = hist(numTCnearRGCLINRand(r,:),histRange);
    histNumRGCRand = hist(numRGCnearLINTCRand(r,:),histRange);
    cumSumTCRand(r,:) = cumsum(histNumTCRand,'reverse')/sum(histNumTCRand);
    cumSumRGCRand(r,:) = cumsum(histNumRGCRand,'reverse')/sum(histNumRGCRand);
    
    plot(histRange,cumSumTCRand(r,:),'m')
    hold on
    plot(histRange,cumSumRGCRand(r,:),'c')
    pause(.01)
end



plot(histRange,cumSumTC,'b')
plot(histRange,cumSumRGC,'g')
hold off



median(numTCnearRGCLIN)
median(numRGCnearLINTC)
median(numTCnearRGCLINRand,2);
median(numRGCnearLINTCRand,2);


realTC = mean(numTCnearRGCLIN)
seTC = std(numTCnearRGCLIN)/sqrt(length(numTCnearRGCLIN))
realRGC = mean(numRGCnearLINTC)
seRGC = std(numRGCnearLINTC)/sqrt(length(numRGCnearLINTC))
randTC = sort(mean(numTCnearRGCLINRand,2));
randRGC = sort(mean(numRGCnearLINTCRand,2));

mean(randTC)
mean(randRGC)
[randTC(round(length(randTC)*.025)) randTC(round(length(randTC)*.975))]
[randRGC(round(length(randRGC)*.025)) randRGC(round(length(randRGC)*.975))]
Ptc = mean(randTC>=realTC)
Prgc = mean(randRGC>=realRGC)

%% TPN = 'C:\Users\jlmorgan\Documents\Publications\LIN\Revision\Pics\'
%% saveas(gcf,[TPN 'closeToCon'],'epsc')
%%    print(gcf, [TPN 'closeToCon2'], '-depsc2','-painters')
%%

motifCodes = [...
    '1 = RGC only, 2 = TC only, 3 = LINin only, 4 = LINout only, 5 = UNKin only, ' ...
    '6 = recip, 7 = autapse,'...
    '8 = RGC-LIN-TC diad, 9 = RGC-LIN-TC triad, 10 = RGC-LIN-TC mult triad, ' ...
    '11 = RGC-LIN-LIN diad, 12 = RGC-LIN-LIN IN triad,  13 = RGC-LIN-LIN out triad, 14 = RGC-LIN-LIN recip triad, ' ...
    '15 = LIN-LIN-TC diad (top), 16 = LIN-LIN-TC diad (mid), '...
    '17 = LIN-LIN-TC triad(top), 18 = LIN-LIN-TC triad(mid), 19 = LIN-LIN-TC recip triad, '...
    '20 = LLL diad, 21 = LLL tri top, 22 = LLL tri mid, 23 = LLL tri bot, 24 = LLL recip triad, '...
    '25 = UNK-LIN-TC(diad), 26 = UNK-LIN-TC triad, 27 = LIN-TC without RGC, 28 = LIN-TC with near RGC'];



%% classify motifs


for i = 1:30, mPos{i} = []; end

for i = 1:length(checkRgc.m)
    m = checkRgc.m(i);
    
    if m.preOnly
        mPos{1} = [mPos{1};checkRgc.pos(i,:)];
    elseif m.preTcTri
        mPos{9} = [mPos{9};checkRgc.pos(i,:)];
    elseif m.preTcDi
        mPos{8} = [mPos{8};checkRgc.pos(i,:)];
    elseif m.preLinDi
        mPos{11} = [mPos{11};checkRgc.pos(i,:)];
    elseif m.preLinInTri
        mPos{13} = [mPos{13};checkRgc.pos(i,:)];
    elseif m.preLinOutTri
        mPos{12} = [mPos{12};checkRgc.pos(i,:)];
    end
    
    
    %     if m.preOnly
    %         mPos{1} = [mPos{1};checkRgc.pos(i,:)];
    %     else
    %         if m.preTcTri
    %             mPos{9} = [mPos{9};checkRgc.pos(i,:)];
    %         elseif m.preTcDi
    %             mPos{8} = [mPos{8};checkRgc.pos(i,:)];
    %         elseif m.closePostTC
    %             mPos{8} = [mPos{8}; checkRgc.pos(i,:)]
    %         end
    %         if m.preLinDi
    %             mPos{11} = [mPos{11};checkRgc.pos(i,:)];
    %         elseif m.preLinInTri
    %             mPos{13} = [mPos{13};checkRgc.pos(i,:)];
    %         elseif m.preLinOutTri
    %             mPos{12} = [mPos{12};checkRgc.pos(i,:)];
    %         end
    %     end
end

for i = 1:length(checkPreLin.m)
    m = checkPreLin.m(i);
    if m.preOnly
        mPos{3} = [mPos{3};checkPreLin.pos(i,:)];
    elseif m.preTcTri
        mPos{18} = [mPos{18};checkPreLin.pos(i,:)];
    elseif m.preTcDi
        mPos{16} = [mPos{16};checkPreLin.pos(i,:)];
    elseif m.preLinDi
        mPos{20} = [mPos{20};checkPreLin.pos(i,:)];
    elseif m.preLinInTri
        mPos{23} = [mPos{23};checkPreLin.pos(i,:)];
    elseif m.preLinOutTri
        mPos{22} = [mPos{23};checkPreLin.pos(i,:)];
    end
end

for i = 1:length(checkUnk.m)
    m = checkUnk.m(i);
    if m.preOnly
        mPos{5} = [mPos{5};checkUnk.pos(i,:)];
    elseif m.preTcTri
        mPos{26} = [mPos{26};checkUnk.pos(i,:)];
    elseif m.preTcDi
        mPos{25} = [mPos{25};checkUnk.pos(i,:)];
    elseif m.preLinDi
        mPos{27} = [mPos{27};checkUnk.pos(i,:)];
    elseif m.preLinInTri
        mPos{28} = [mPos{28};checkUnk.pos(i,:)];
    elseif m.preLinOutTri
        mPos{29} = [mPos{29};checkUnk.pos(i,:)];
    end
end

for i = 1:length(checkPostLin.m)
    m = checkPostLin.m(i)
    
    if m.preOnly
        mPos{4} = [mPos{4};checkPostLin.pos(i,:)];
    elseif m.preLinDi
        mpfos{15} = [mPos{15};checkPostLin.pos(i,:)];
    elseif m.preTcTri
        mPos{17} = [mPos{17};checkPostLin.pos(i,:)];
        
    elseif m.recTcTri
        mPos{19} = [mPos{19};checkPostLin.pos(i,:)];
    elseif m.recRgcTri
        mPos{14} = [mPos{14};checkPostLin.pos(i,:)];
    elseif m.recLinInTri
        mPos{24} = [mPos{24};checkPostLin.pos(i,:)];
    elseif m.recLinOutTri
        mPos{24} = [mPos{24};checkPostLin.pos(i,:)];
    elseif m.recLinInOut
        mPos{24} = [mPos{24};checkPostLin.pos(i,:)];
    elseif m.recLinOutIn
        mPos{24} = [mPos{24};checkPostLin.pos(i,:)];
    end
    if m.reciprocal
        mPos{6} = [mPos{6};checkPostLin.pos(i,:)];
    end
    if m.autapse
        mPos{7} = [mPos{7};checkPostLin.pos(i,:)];
    end
end

for i = 1:length(checkTc.m)
    m = checkTc.m(i);
    if m.postOnly
        mPos{2} = [mPos{2};checkTc.pos(i,:)];
    end
    if m.closePreRGC ==0
        mPos{27} = [mPos{27}; checkTc.pos(i,:)];
    else
        mPos{28} = [mPos{28}; checkTc.pos(i,:)];
    end
    
end