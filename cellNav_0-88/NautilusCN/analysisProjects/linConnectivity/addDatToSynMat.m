function[sm] = addDatToSynMat(tis,targ);


%% Get data
%mot = getMotifs(obI);
synMat = tis.syn;
%synStruct = getSynMat(obI);
synPos = getSynPos(1);
if ~exist('targ','var')
    targ = 125;
end

%% Match synapses 
%%Find all synapses in synPos that are not in synMat.

onTarg = ((synMat.pre == targ) | (synMat.post == targ))  &...
    (sum(synMat.synPos,2)>0);
oPos = synMat.synPos(onTarg,:);
oPreClass = synMat.preClass(onTarg);
oPostClass = synMat.postClass(onTarg);
oPre = synMat.pre(onTarg);
oPost = synMat.post(onTarg);
oUse = ones(size(oPre)); % using synmat traced objects

res = obI.em.res; 
dSamp =  (res .* [4 4 1])./1000;

%%Pool labels
pos = synPos.postRGCPos;
pos = pos(:,[2 1 3]);
pos(:,1) = pos(:,1)*dSamp(1);
pos(:,2) = pos(:,2)*dSamp(2);
pos(:,3) = pos(:,3)*dSamp(3);
L = size(pos,1);
nPos = pos;
preClass = zeros(L,1) + 1;
postClass = zeros(L,1) + 3;
pre = zeros(L,1);
post = zeros(L,1) + targ;


pos = synPos.postUnkPos;
pos = pos(:,[2 1 3]);
pos(:,1) = pos(:,1)*dSamp(1);
pos(:,2) = pos(:,2)*dSamp(2);
pos(:,3) = pos(:,3)*dSamp(3);
L = size(pos,1);
nPos = [nPos; pos];
preClass = [preClass; zeros(L,1) + 4];
postClass = [postClass; zeros(L,1) + 3];
pre = [pre; zeros(L,1)];
post = [post; zeros(L,1) + targ];


pos = synPos.postLinPos;
pos = pos(:,[2 1 3]);
pos(:,1) = pos(:,1)*dSamp(1);
pos(:,2) = pos(:,2)*dSamp(2);
pos(:,3) = pos(:,3)*dSamp(3);
L = size(pos,1);
nPos = [nPos; pos];
preClass = [preClass; zeros(L,1) + 3];
postClass = [postClass; zeros(L,1) + 3];
pre = [pre; zeros(L,1)];
post = [post; zeros(L,1) + targ];


dif = cat(3,oPos(:,1)-nPos(:,1)',oPos(:,2)-nPos(:,2)',oPos(:,3)-nPos(:,3)');
dist = sqrt(sum(dif.^2,3));
minDists = min(dist,[],1);




pos = synPos.postRGCPos;
pos = pos(:,[2 1 3]);
pos(:,1) = pos(:,1)*dSamp(1);
pos(:,2) = pos(:,2)*dSamp(2);
pos(:,3) = pos(:,3)*dSamp(3);





% 
% 
% maxDist = 2;
% nUse = ones(size(nPos,1),1); % use spresheat marked synapses
% for i = 1:size(pos,1)
%     isType = (oPreClass == preClass(i)) &  (oPostClass == postClass(i));
%     minDist = min(dist(isType & oUse,i));    
%     hit = find(isType & oUse & dist(:,i) == minDist,1);    
%     if minDist<=maxDist
%        oUse(hit) = 0;
%        nUse(i) = 0;
%     end
% end


maxDist = 2;
nUse = ones(size(nPos,1),1,'logical'); % use spresheat marked synapses
for i = 1:size(nPos,1)
    isType = (oPreClass == preClass(i)) &  (oPostClass == postClass(i));
    minDist = min(dist(isType & oUse,i)) ;   
    hit = find(isType & oUse & (dist(:,i) == minDist),1);    
    if minDist<=maxDist
       oUse(hit) = 0;
       nUse(i) = 0;
    end
end


%% Find leftovers
if 0
findLeft = find((oPreClass == 4) & ( oUse == 1) & (oPost == 125))
checkPos = oPos(findLeft,:);

pos = checkPos;
X = pos(:,2); Y = pos(:,1); Z = pos(:,3);
checkPos = [X./dSamp(2) Y./dSamp(1) Z./dSamp(3)]
for i = 1:size(checkPos,1)
    i
sprintf('%05.0f %05.0f %05.0f',checkPos(i,1), checkPos(i,2), checkPos(i,3))
pause
end



%%Find leftover npos
findLeft = find((preClass == 4) & ( nUse == 1))
checkPos = nPos(findLeft,:);

pos = checkPos;
X = pos(:,2); Y = pos(:,1); Z = pos(:,3);
checkPos = [X./dSamp(2) Y./dSamp(1) Z./dSamp(3)]
for i = 1:size(checkPos,1)
    i
sprintf('%05.0f %05.0f %05.0f',checkPos(i,1), checkPos(i,2), checkPos(i,3))
pause
end

missSyn = nPos(findLeft(2),:)


scatter3(oPos(:,1),oPos(:,2),oPos(:,3),'o','k')
hold on
scatter3(nPos(:,1),nPos(:,2),nPos(:,3),'x','r')
scatter3(missSyn(1),missSyn(2),missSyn(3),'s','b')
hold off

X = 181.6
Y = 185.9
Z = 172.8
checkPos = [X./dSamp(2) Y./dSamp(1) Z./dSamp(3)]
sprintf('%05.0f %05.0f %05.0f',checkPos(1), checkPos(2), checkPos(3))

end

%% Record

sm.pre = cat(1,synMat.pre,pre(nUse));
sm.post = cat(1,synMat.post,post(nUse));
sm.preClass = cat(1,synMat.preClass,preClass(nUse));
sm.postClass = cat(1,synMat.postClass,postClass(nUse));
sm.pos = cat(1,synMat.synPos,nPos(nUse,:));
sm.typeNames = synMat.typeNames;

sum((sm.preClass == 4) & (sm.post == 125))






