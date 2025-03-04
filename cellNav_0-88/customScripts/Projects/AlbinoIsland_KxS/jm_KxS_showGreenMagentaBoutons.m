%%Display three groups of TCRS and their synapses

global glob tis
app = glob.app;


%% Set defined camera position
glob.ax.CameraTargetMode = 'manual';
glob.ax.CameraViewAngleMode = 'manual';
glob.ax.CameraTargetMode = 'manual';
%view(glob.ax,115,-30)
camproj(glob.ax,'orthographic')
lightangle(glob.light,64,-43)
glob.ax.CameraPosition = [1.0269    0.8514   -0.8505]*1000;
glob.ax.CameraTarget = [ 163.5891  161.0452   46.5029];
glob.ax.CameraViewAngle = 6;
glob.ax.CameraUpVectorMode = 'manual';


vec = [.15 -.5 0]
nVec = vec/ sqrt(sum(vec.^2));
glob.ax.CameraUpVector = nVec;



%% Define groups
if isfield(glob,'g')
    L = length(glob.g);
else
    L = 0;
end


g1 = [1001  1003 1004 1006 1016  1015 ]; %red
g2 = [1002 1005 1007 1008 1011 1013 1014 1009 1019]; % blue
g3 = [1017];

refCids = [g1 g2 g3];

sCol = zeros(length(refCids),3)+.2;
rAlph = 0; % cells
sAlph = 0; %Synapses
rsAlph = .3; %Rgc synapses 0.15 standard

rCol = zeros(length(refCids),3)+.2;
rAlph = 0;%.2; % cells


rsCol = zeros(length(refCids),3);
for i = 1:length(g1)
    targ = find(refCids==g1(i));
    sCol(targ,:) = [.5 1 .5];
    rsCol(targ,:) = [0 1 0];
end
for i = 1:length(g2)
    targ = find(refCids==g2(i));
    sCol(targ,:) = [1 .5 1];
    rsCol(targ,:) = [1 0 1];

end

for i = 1:length(g3)
    targ = find(refCids==g3(i));
    sCol(targ,:) = [.3 .3 .3];
    rsCol(targ,:) = [.5 .5 .5];

end


idx = refCids * 0;
for i = 1 : length(refCids)
    targ = find(tis.cids==refCids(i),1);
    if ~isempty(targ)
        idx(i) = targ;
    end
end


useRef = find(idx>0);
newG = [1:length(useRef)] + L;
cellGids = zeros(length(useRef),2);
for i = 1:length(useRef)

    %% make new group
    rID = useRef(i);
    glob.g(newG(i)) = glob.defaultG;
    glob.g(newG(i)).idx = idx(rID);
    glob.g(newG(i)).cid = tis.cids(idx(rID));
    glob.g(newG(i)).col = rCol(rID,:);
    glob.g(newG(i)).alph = rAlph;
    glob.g(newG(i)).show = 1;
    glob.g(newG(i)).name = sprintf('g%d - c%s',L, num2str(glob.g(L+i).cid));
    cellGids(i,:) = [tis.cids(idx(rID)) newG(i)];


end

if 0
%%Load references
 rID = useRef(i);
    glob.g(newG(i)) = glob.defaultG;
    glob.g(newG(i)).idx = idx(rID);
    glob.g(newG(i)).cid = {'Exclusion top plane'};
    glob.g(newG(i)).col = [0 0 1];
    glob.g(newG(i)).alph = .2;
    glob.g(newG(i)).show = 1;
    glob.g(newG(i)).name = 'Exclusion top plane';
end



    %% Show groups
showCellGroup(app, newG)



%% Make synapses


%%Create temp FV
load([glob.dir.Volumes glob.vol.activeName '\Merge\dsObj.mat'])
load([glob.dir.Volumes glob.vol.activeName '\Merge\obI.mat'])

nams = obI.nameProps.names;

%%Find all rgc tags
isRGC = zeros(length(nams),1);
hitsC = regexp(lower(nams),'rgc');
for o = 1:length(nams)
    isRGC(o) =  sum(hitsC{o});
end

synCount = refCids * 0;
rgcInCount = refCids * 0;
for i = 1:length(refCids)


    % %%Find all pre
    isPre = zeros(length(nams),1);
    % hitsC = regexp(nams,sprintf('pre cid%d',refCids(i)));
    % for o = 1:length(nams)
    %     isPre(o) = sum(hitsC{o});
    % end

    hitsC = regexp(nams,sprintf('syn cid%d',refCids(i)));
    for o = 1:length(nams)
        isPre(o) = isPre(o) + sum(hitsC{o});
    end

   
    synObIds{i} = find(isPre>0);
    synCount(i) = sum(isPre>0);
    
    rgcInObIds{i} = find((isPre & isRGC)>0);
    rgcInCount(i) = sum((isPre & isRGC)>0);
end

usePre = find(synCount>0);
newPG = [1:length(usePre)] + length(glob.g);



for i = 1:length(usePre)

    rID = newPG(i);
    obIds = setdiff(synObIds{usePre(i)},rgcInObIds{usePre(i)});

    glob.g(rID) = glob.defaultG;
    glob.g(rID).idx = obIds;
    glob.g(rID).cid = nams(obIds);
    glob.g(rID).alph = sAlph;
    glob.g(rID).col = repmat(sCol(usePre(i),:),[length(glob.g(rID).idx) 1]);
    glob.g(rID).show = 1;

    namStr = sprintf('pre %d',refCids(usePre(i)));
    glob.g(rID).name = sprintf('cg%d - %s',rID,namStr);

    drawObj(glob.app,dsObj,obI,obIds,newPG(i))

end

usePre = find(rgcInCount>0);
newPG = [1:length(usePre)] + length(glob.g);

rSynGids = zeros(length(usePre),2);
for i = 1:length(usePre)

    rID = newPG(i);
    obIds = rgcInObIds{usePre(i)};

    glob.g(rID) = glob.defaultG;
    glob.g(rID).idx = obIds;
    glob.g(rID).cid = nams(obIds);
    glob.g(rID).alph = rsAlph;
    glob.g(rID).col = repmat(rsCol(usePre(i),:),[length(glob.g(rID).idx) 1]);
    glob.g(rID).show = 1;

    namStr = sprintf('rgc pre %d',refCids(usePre(i)));
    glob.g(rID).name = sprintf('cg%d - %s',rID,namStr);

    drawObj(glob.app,dsObj,obI,obIds,newPG(i))
    rSynGids(i,:) = [refCids(usePre(i)) rID];
end

updateGroups(app)
%edit2_function(app)









