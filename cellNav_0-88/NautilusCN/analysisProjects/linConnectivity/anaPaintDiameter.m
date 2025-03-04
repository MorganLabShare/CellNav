clear all
load('MPN.mat')
load([MPN 'obI.mat'])
load([MPN 'dsObj.mat'])

cellList = 125;

subCell = names2Subs(obI,dsObj,cellList);
sub = subCell{1};

sizes = max(sub,[],1);

plane = zeros(sizes(1), sizes(2));

newSubs = [];
widths = [];
for i = 1:sizes(3);
    disp(sprintf('%d of %d',i,sizes(3)))
    useSub = sub(:,3) == i;
    if sum(useSub)
        plane = plane * 0;
        
        subind = sub2ind(sizes(1:2),sub(useSub,1),sub(useSub,2));
        plane(subind) = 1;
        lab = bwlabel(plane,4);
        props = regionprops(lab,'area','centroid','minoraxislength');
        numOb = length(props);
        centroids = cat(1,props.Centroid);
        newSubs = cat(1,newSubs,[centroids repmat(i,[numOb 1])]);
        widths = cat(1,widths,props.MinorAxisLength);
    end
    
end

%% scale

paintWidth.cents = newSubs(:,[2 1 3]) *.2;
paintWidth.widths = widths *.2;

if 0
save('D:\LGNs1\mergeSeg_mat\nep\paintWidth.mat','paintWidth');
end

%%
cmap = jet(100)
cVal = round(widths * 10);
cVal(cVal<1) = 1;
cVal(cVal>100) = 100;
scatter3(newSubs(:,1),newSubs(:,2),newSubs(:,3),10,cmap(cVal,:),'.')
%scatter3(sub(:,1),sub(:,2),sub(:,3),10,'k','.')






