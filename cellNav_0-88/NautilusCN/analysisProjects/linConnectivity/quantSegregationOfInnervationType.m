


if 0
    clear all
    
    obMovDir = 'D:\LGNs1\Analysis\movies\subLin125_TargFac\'
    if ~exist(obMovDir,'dir'),mkdir(obMovDir),end
    % else
    %     'directory already exists'
    %     return
    % end
    
    load('MPN.mat')
    load([MPN 'obI.mat'])
    load([MPN 'dsObj.mat'])
    
    sm = addDatToSynMat(obI)
    sm = getTopoEucDistBetweenSyn(sm);
    sm = getTopoEucDistBetweenSkelAndSyn(sm);
    sm = labelShaftSkel(sm);
    sm = labelSubTypes(sm);
    
end

%% Types {'targ ax shaft body'}

%% Syn Process type

syn2skel = sm.syn2skel;

for i = 1:length(syn2skel.closestSkel)
   
    if sm.isAx(syn2skel.closestSkel(i))
        synProcType(i) = 2;
    elseif sm.isShaft(syn2skel.closestSkel(i))
        synProcType(i) = 3;
    elseif sm.isTarg(syn2skel.closestSkel(i))
        synProcType(i) = 1;
    elseif sm.isBody(syn2skel.closestSkel(i))
        synProcType(i) = 4;
    end

   
end

%% Distances between synapses
dists = zeros(size(synPos,1));
for i = 1:size(synPos,1)
   
    dists(i,:) = sqrt((syn2skel.synPos(:,1)-syn2skel.synPos(i,1)).^2 + ...
        (syn2skel.synPos(:,2)-syn2skel.synPos(i,2)).^2 + ... 
        (syn2skel.synPos(:,3)-syn2skel.synPos(i,3)).^2);
        
end

%% Process type
procTypeMatch = zeros(size(synPos,1));
goodCheck = zeros(size(synPos,1));
for y = 1:size(synPos,1)
    for x = 1:size(synPos,1)
        
        procTypeMatch(y,x) = synProcType(y) * 10 + synProcType(x);
        goodCheck(y,x) = y>x;
        
    end
end

%% PrePost match

notZero = (syn2skel.syn(:,1)>0) & (syn2skel.syn(:,1)'>0) & ...
    (syn2skel.syn(:,2)>0) & (syn2skel.syn(:,2)'>0);

preNotTarg = syn2skel.syn(:,1) ~= 125;
goodPreMatch = preNotTarg .* preNotTarg';
image(goodPreMatch*1000)

postNotTarg = syn2skel.syn(:,2) ~= 125;
goodPostMatch = postNotTarg .* postNotTarg';
image(goodPostMatch*1000)

samePost = syn2skel.syn(:,2) == syn2skel.syn(:,2)';
samePre = syn2skel.syn(:,1) == syn2skel.syn(:,1)';
image(samePost*10000)




%% Ask your questions

bin = 3;

bins = [0:bin:100];
clear ddPostMatch ddPostAll ssPostMatch ssPostAll ttPostMatch ttPostAll
clear aaPostMatch aaPostAll stPostMatch stPostAll adPostMatch adPostAll
for i = 1:length(bins)-1
    
   useDist =  (dists >= bins(i)) & (dists < bins(i+1)) ;
    
   ssPostMatch(i) = sum(sum(notZero & useDist & goodPostMatch & goodCheck & (procTypeMatch == 33) & samePost));
   ssPostAll(i) = sum(sum(notZero & useDist & goodPostMatch & goodCheck & (procTypeMatch == 33)));

   ttPostMatch(i) = sum(sum(notZero & useDist & goodPostMatch & goodCheck & (procTypeMatch == 11) & samePost));
   ttPostAll(i) = sum(sum(notZero & useDist & goodPostMatch & goodCheck & (procTypeMatch == 11)));
   
   aaPostMatch(i) = sum(sum(notZero & useDist & goodPostMatch & goodCheck & (procTypeMatch == 22) & samePost));
   aaPostAll(i) = sum(sum(notZero & useDist & goodPostMatch & goodCheck & (procTypeMatch == 22)));
   
   stPostMatch(i) = sum(sum(notZero & useDist & goodPostMatch & goodCheck & (procTypeMatch == 31) & samePost));
   stPostAll(i) = sum(sum(notZero & useDist & goodPostMatch & goodCheck & (procTypeMatch == 31)));
   
   ddPostMatch(i) = sum(sum(notZero & useDist & goodPostMatch & goodCheck & ...
       ((procTypeMatch == 11) | (procTypeMatch == 33) | (procTypeMatch == 13) | (procTypeMatch == 31))...
        & samePost));
   ddPostAll(i) = sum(sum(notZero & useDist & goodPostMatch & goodCheck & ...
       ((procTypeMatch == 11) | (procTypeMatch == 33) | (procTypeMatch == 13) | (procTypeMatch == 31))));
   
   adPostMatch(i) = sum(sum(notZero & useDist & goodPostMatch & goodCheck & ...
       ((procTypeMatch == 12) | (procTypeMatch == 21) | (procTypeMatch == 23) | (procTypeMatch == 32))...
        & samePost));
   adPostAll(i) = sum(sum(notZero & useDist & goodPostMatch & goodCheck & ...
       ((procTypeMatch == 12) | (procTypeMatch == 21) | (procTypeMatch == 23) | (procTypeMatch == 32))));
   
   
      
end


plot(bins(2:end),adPostMatch./adPostAll,'b')
hold on
plot(bins(2:end),ddPostMatch./ddPostAll,'g')
plot(bins(2:end),aaPostMatch./aaPostAll,'r')
plot(bins(2:end),stPostMatch./stPostAll,'k')

hold off

% 
% 
% plot(bins(2:end),adPostMatch)
% hold on
% plot(bins(2:end),ddPostMatch)
% plot(bins(2:end),aaPostMatch)
% hold off








