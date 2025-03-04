function[] = showNepBones(nep,wdth)

bones = nep.bones;
nodePos = nep.pos;

if ~exist('wdth','var')
    wdth = 1;
end

colmap = hsv(100);
for i = 1:length(bones);
    showEdges =  bones(i).edges;
    sub1 = nodePos(showEdges(:,1),:);
    sub2 = nodePos(showEdges(:,2),:);
    rCol = colmap(ceil(rand*100),:)/2;
    for e = 1:size(showEdges,1)
        
        plot([sub1(e,1) sub2(e,1)], [sub1(e,2) sub2(e,2)],'color',rCol,'linewidth',wdth)
        hold on
        
    end
end
pause(.01)

hold off