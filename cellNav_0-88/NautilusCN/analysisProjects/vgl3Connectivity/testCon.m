global glob tis


tis.cells.type.typeNames
tis.cells.type.subTypeNames{8}
tis.cells.type.subTypeNames{7}

%% Get vglut 3 IDs
typeID = tis.cells.type.typeID;
subTypeID = tis.cells.type.subTypeID;
pre = tis.syn.pre;
post = tis.syn.post;

isVG3 = find((typeID == 8) & (subTypeID == 1));
 = tis.cids(isVG3);


%% Find vg3 input types

preCids = [];
for i = 1:length(cidVG3)
   
    preCid{i} = tis.syn.pre(tis.syn.post==cidVG3(i));
    preCids = [preCids; preCid{i}];
    
end
uPreCids = setdiff(unique(preCids),0);

for i = 1:length(uPreCids)
   
    targ = find(tis.cids==uPreCids(i));
    preType(i) = typeID(targ);
    preSubType(i) = subTypeID(targ);
    
end

preBipTypes = unique(preSubType(preType==7));


%% Find vg3 out types

postCids = [];
for i = 1:length(cidVG3)
   
    postCid{i} = tis.syn.post(tis.syn.pre==cidVG3(i));
    postCids = [postCids; postCid{i}];
    
end
uPostCids = setdiff(unique(postCids),0);

for i = 1:length(uPostCids)
    
    targ = find(tis.cids==uPostCids(i));
    if isempty(targ)
        postType(i) = 0;
        postSubType(i) = 0;
    else
        postType(i) = typeID(targ);
        postSubType(i) = subTypeID(targ);
    end
    
end

postRGCTypes = unique(postSubType(postType==1));
postRGCs = uPostCids(postType == 1);

%% Make cell to cell graph
con = zeros(length(uPreCids),length(uPostCids));
for y = 1:length(uPreCids)
    for x = 1:length(uPostCids)
        con(y,x) = con(y,x) + sum((pre == uPreCids(y))& (post == uPostCids(x)));      
    end
end
image(con*10)


%%

cidRGC = setdiff(unique(uPostCids(postType == 1)),0);


%%Get vg3 to vg3
clear conVG3VG3
for y = 1:length(cidVG3)
    for x = 1:length(cidVG3)
        conVG3VG3(y,x) =  sum((pre == cidVG3(y)) & (post == cidVG3(x)));
    end
end


%%Get vg3 to RGC
clear conVG3RGC
for y = 1:length(cidVG3)
    for x = 1:length(cidRGC)
    conVG3RGC(y,x) = sum((pre == cidVG3(y)) & (post == cidRGC(x)));
    end
end

%%get bip to vglut3
clear conBipVG3
for y = 1:length(preBipTypes)
    bipCid = tis.cids((typeID == 7) & (subTypeID == preBipTypes(y)));
    
    for x = 1:length(cidVG3)
        conSum = 0;
        for i = 1:length(bipCid)
            conSum = conSum + sum((pre == bipCid(i)) & (post == cidVG3(x)));
        end
        conBipVG3(y,x) = conSum;
        
    end
end


%%get bip to RGC
clear conBipRGC
for y = 1:length(preBipTypes)
    bipCid = tis.cids((typeID == 7) & (subTypeID == preBipTypes(y)));
    for x = 1:length(cidRGC)
        conSum = 0;
        for i = 1:length(bipCid)
            conSum = conSum + sum((pre == bipCid(i)) & (post == cidRGC(x)));
        end
        conBipRGC(y,x) = conSum;
    end
end


    
%%Combine graphs

conAll(1,1) = sum(conVG3VG3(:));
conAll(1,2:1 + size(conVG3RGC,2)) = sum(conVG3RGC,1);
conAll(2:1 + size(conBipVG3,1),1) = sum(conBipVG3,2);
conAll(2:end,2:end) = conBipRGC;

image(conAll+1)
cmap = jet(max(20));
cmap = cat(1,[0 0 0],cmap);
colormap(cmap)

%% merge on and off

onList = [6 7 8 9 10 11 14];
offList = [ 1 2 3 4 5 15];

[ a onInd] = intersect(preBipTypes,onList);
[a offInd] = intersect(preBipTypes,offList);

conOFFON(1,:) = conAll(1,:)
conOFFON(2,:) = sum(conAll(offInd,:));
conOFFON(3,:) = sum(conAll(onInd,:,1));

image(conOFFON+1)

%% select RGCs

useRGCs = [1069 1172 3051];
[usedRGCs rgcInd] = intersect(cidRGC,useRGCs);
conUseRGC = conAll(:,[1; rgcInd]);
image(conUseRGC + 1);





