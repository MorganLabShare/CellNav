function[sm] = labelSubTypes(sm)


shaftSub = sm.skelPos(sm.isShaft,:);
axSub = sm.skelPos(sm.isAx,:);
targSub = sm.skelPos(sm.isTarg,:);
bodySub = sm.skelPos(sm.isBody,:);

load('MPN.mat')
load([MPN 'obI.mat'])
load([MPN 'dsObj.mat'])

targCell = 125;
subCell = names2Subs(obI,dsObj,targCell);
sm.subs = subCell{1};
sub = double(subCell{1}) * obI.em.dsRes(1);
% sub = double(shrinkSub(sub,downSamp));

distThresh = 3;


subType = zeros(size(sub,1),1);
for i = 1:size(sub,1)

    distTarg = min(sqrt((targSub(:,1)-sub(i,1)).^2 + (targSub(:,2)-sub(i,2)).^2 + ...
        (targSub(:,3)-sub(i,3)).^2));
    distShaft = min(sqrt((shaftSub(:,1)-sub(i,1)).^2 + (shaftSub(:,2)-sub(i,2)).^2 + ...
        (shaftSub(:,3)-sub(i,3)).^2));
    distAx = min(sqrt((axSub(:,1)-sub(i,1)).^2 + (axSub(:,2)-sub(i,2)).^2 + ...
        (axSub(:,3)-sub(i,3)).^2));
    distBody = min(sqrt((bodySub(:,1)-sub(i,1)).^2 + (bodySub(:,2)-sub(i,2)).^2 + ...
        (bodySub(:,3)-sub(i,3)).^2));
            
    if distBody <= distThresh
        subType(i) = 4;
    elseif distAx <= distThresh
        subType(i) = 2;
    elseif distTarg <= distShaft
        subType(i) = 1;
    else
        subType(i) = 3;
    end

end


sm.subType = subType;
sm.subTypeNames = {'targ ax shaft body'};
    


if 0
    downSamp = 8;
    smallSub = shrinkSub(subCell{1},downSamp);
    fv = subVolFV(smallSub,[]);
    [p] = renderFV(fv,[1 0 0],1);
    view([0 0])
    axis off
    
    
end








