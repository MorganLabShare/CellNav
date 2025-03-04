function[dSubs] = dilateSubs(subs)


shiftVox = [0 0 0; -1 0 0; 1 0 0; 0 -1 0; 0 1 0; 0 0 -1; 0 0 1];
L =  size(subs,1);
sSubs = zeros(L*size(shiftVox,1),3);
for s = 1:size(shiftVox,1)
    shiftStart = (s-1)* L;
    shiftMat = repmat(shiftVox(s,:),[L 1]);
    sSubs((s-1)* L + 1: (s-1) * L+ L,:) = subs + shiftMat;
end
zSubs = sSubs ==0;
sSubs = sSubs(sum(zSubs,2)==0,:);

maxs = max(sSubs,[],1);
inds = sub2ind(maxs,sSubs(:,1),sSubs(:,2),sSubs(:,3));
uinds = unique(inds);
[y x z] = ind2sub(maxs,inds);
dSubs = [y x z];