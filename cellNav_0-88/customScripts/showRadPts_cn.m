function[fv,p] = showRadPts_cn(posR,edgeR,radR,nodeColR,alph)




%% Get Data
edgeNum = size(edgeR,1);
nodeNum = size(posR,1);

if ~exist('radR','var') | isempty('rad')
    radR = ones(size(posR,1),1)*.1;
end


if ~exist('nodeColR','var')
    nodeColR = ones(size(posR));
end

if size(nodeColR,1) == 1;
    nodeColR = repmat(nodeColR,[size(posR,1) 1]);
end

if ~exist('alph','var') | isempty('alph')
    alph = 1;%ones(size(posR,1),1)*.1;
end




%% fix repeats
bPos = round(posR*1000);
maxPos = max(bPos,[],1);
oldInd = sub2ind(maxPos,bPos(:,1),bPos(:,2),bPos(:,3));
[uInd iA iC] = unique(oldInd);
pos = posR(iA,:);
edge = iC(edgeR);
if size(edge,2)==1,edge = edge';end
rad = radR(iA);
nodeCol = nodeColR(iA,:);

edgeNum = size(edge,1);
nodeNum = size(pos,1);

%disp(sprintf('percent unique nodes = %.1f',length(uInd)/size(posR,1)*100))

% s1 = scatter3(pos(:,2), pos(:,1), pos(:,3),'r','o')
% delete(s1)

%%Make circle
cNum = 20;
cNum = ceil(cNum/2)*2;
div = pi/(cNum/2);
d = div:div:(2 * pi);
x = cos(d)';
y = sin(d)';
z = x * 0';
cSub = [x y z x*0 ];
cNodes = [1:cNum]';

%%make cylinder
cynFace = [cNodes circshift(cNodes,1)];
cynFace = [cynFace cynFace(:,[2 1])+cNum];

%%Set up figure
plot([])
hold on


%%Set up fv
fv.CDataMapping = 'direct';%repmat([1 1 1],[size(fv.vertices,1) 1]);
fv.FaceColor = 'flat';%[1 1 1];%repmat([1 1 1],[size(fv.vertices,1) 1]);%'flat';
fv.EdgeColor = [1 0 0];
fv.LineWidth = 1;

fv.FaceAlpha = alph;
fv.EdgeAlpha = 0;
fv.AlphaData = 'direct';
fv.AlphaDataMapping = 'direct';

fv.FaceLighting = 'gouraud';
fv.AmbientStrength = .5;
fv.DiffuseStrength = .9;
fv.SpecularExponent = 10;
fv.SpecularStrength = .9;
fv.BackFaceLighting = 'lit';


%%Run edges
vPos = zeros(edgeNum * cNum * 2,3);
vCol = vPos;
faces = zeros(edgeNum * cNum,4);
for i = 1:nodeNum
    nodeRing{i} = [];
end

for i = 1:edgeNum
    
    p1 =  pos(edge(i,1),:);
    p2 = pos(edge(i,2),:);
    dif =   p2 - p1;
    if sum(abs(dif))
        ar1= atan2(dif(1),dif(2))-pi/2;
        ax = [sin(ar1) cos(ar1) 0];
        dist = sqrt(sum(dif.^2));
        ar2 = asin(dif(3)/dist)-pi/2;
        mt = makehgtform('axisrotate',ax,ar2);
    else
        %pause
        mt = [1 0 0 0;0 1 0 0; 0 0 1 0; 0 0 0 1];
    end
    
    rSub1 = cSub * mt;
    rSub1 = rSub1 * rad(edge(i,1));
    rSub1 = rSub1(:,[1 2 3]) + repmat(p1,[size(rSub1,1) 1]);
    rSub2 = cSub * mt;
    rSub2 = rSub2(:,[1 2 3])  * rad(edge(i,2));
    rSub2 = rSub2 + repmat(p2,[size(rSub1,1) 1]);
   
    
    col1 = nodeCol(edge(i,1),:);
    col2 = nodeCol(edge(i,2),:);
    
    vNum = (i-1) * cNum * 2;
    faceNum = (i-1) * cNum;
    newVert= vNum+1:vNum+cNum*2;
    vPos(newVert,:) = cat(1,rSub1,rSub2);
    vCol(newVert,:) = cat(1,repmat(col1,[cNum 1]),repmat(col1,[cNum 1]));
    faces(faceNum+1:faceNum+cNum,:) = cynFace+vNum;
    
    
    
    nodeRing{edge(i,1)} = cat(2,nodeRing{edge(i,1)},[vNum+1:vNum+cNum]');
    nodeRing{edge(i,2)} = cat(2,nodeRing{edge(i,2)},[vNum+cNum+1:vNum+cNum*2]');
    
    %     plot3(rSub1(:,1),rSub1(:,2),rSub1(:,3),'g')
    %     plot3(rSub2(:,1),rSub2(:,2),rSub2(:,3),'g')
    %     plot3([0 ax(1)],[0 ax(2)],[0 ax(3)],'w')
    %     plot3([0 dif(1)],[0 dif(2)],[0 dif(3)],'y')
    
end




nodeFaces = [];
endSquare = [1 2 cNum/2+1 cNum/2+2]+(0:cNum/2-1)';
endSquare = mod(endSquare,cNum);
endSquare(endSquare==0) = cNum;
for i = 1:length(nodeRing)
    
    rings = nodeRing{i};
    if isempty(rings)
        'no ring';
    elseif size(rings,2) == 1
        nodeFaces = cat(1,nodeFaces,rings(endSquare));
    else
        n = size(rings,2);
        ringPairs = nchoosek(1:n,2);
        for r = 1:size(ringPairs,1)
            pairNodes = cat(1,rings(:,ringPairs(1)),rings(:,ringPairs(2)));
            nodeFaces = cat(1,nodeFaces,pairNodes(cynFace));
        end
    end
    
end


fv.FaceVertexCData = vCol;%repmat(faceCol,[size(fv.vertices,1) 1]);;

usePatch = 0;

if usePatch
    fv.vertices = vPos;
    fv.faces = cat(1,faces,nodeFaces);
    p = patch(fv)
    
else
    
    p = scatter3(vPos(:,2), vPos(:,1),vPos(:,3),'.','markeredgecolor',...
    nodeColR(1,:),'markeredgealpha',alph)
end



















