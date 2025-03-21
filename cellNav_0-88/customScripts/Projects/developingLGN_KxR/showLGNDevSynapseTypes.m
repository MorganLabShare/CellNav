global glob tis
app = glob.app;

parsedTypes = parseDevSyn();
refCids = [3097];
rCol = ones(length(refCids),3);
rAlph = ones(length(refCids),1) * .1;

%% Set defined camera position
glob.ax.CameraTargetMode = 'manual';
glob.ax.CameraViewAngleMode = 'manual';
glob.ax.CameraTargetMode = 'manual';
view(glob.ax,115,-30)
camproj(glob.ax,'orthographic')
lightangle(glob.light,190,-40)
glob.ax.CameraPosition = [845.9821  443.0145 -486.1594];
glob.ax.CameraTarget = [161.0960  117.0138   53.0138];
glob.ax.CameraViewAngle = 6;


idx = refCids * 0;
for i = 1 : length(refCids)
    targ = find(tis.cids==refCids(i),1);
    if ~isempty(targ)
        idx(i) = targ;
    end
end


% Clear groups
clearAllGroups(app)

L = length(glob.g);
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
    glob.g(newG(i)).name = sprintf('g%d - c%s',L, num2str(glob.g(newG(i)).cid));

    cellGids(i,:) = [tis.cids(idx(rID)) newG(i)];

end

%%Show groups
showCellGroup(app, newG)


%% plot syns

%%Delete syn plots if any
for s = 1:length(glob.syn.g)
    try
        delete(glob.syn.g(s).p);
    end
end
glob.syn.g = glob.syn.defaultG;

%%If volume transform
volName = glob.vol.activeName;
if exist([glob.dir.Volumes volName '\volTransform.mat'],'file');
    load([glob.dir.Volumes volName '\volTransform.mat']);
else
    volTransform = [];
end

clear synProp
if 1 %RGC sheath vs giant
synProp(1).name = 'one';
synProp(1).is = (~parsedTypes.ps.giant & parsedTypes.tp.rgc);
synProp(1).color = [0 .5 1];
synProp(1).mark = '^';
synProp(1).size = 50;
synProp(1).alpha = .8;
synProp(1).jit = [0 0 0];


synProp(2).name = 'two';
synProp(2).is = (parsedTypes.ps.isSheath & parsedTypes.tp.rgc);
synProp(2).color = [1 0 0];
synProp(2).mark = 'o';
synProp(2).size = 400;
synProp(2).alpha = .2;
synProp(2).jit = [0 .01 0];


synProp(3).name = 'three';
synProp(3).is = (parsedTypes.ps.giant & parsedTypes.tp.rgc);
synProp(3).color = [0 1 0];
synProp(3).mark = '^';
synProp(3).size = 200;
synProp(3).alpha = .8;
synProp(3).jit = [0 -.01 0];

synProp(4).name = 'four';
synProp(4).is = (parsedTypes.ps.isSpine & parsedTypes.tp.rgc);
synProp(4).color = [1 0 1];
synProp(4).mark = 'o';
synProp(4).size = 40;
synProp(4).alpha = .8;
synProp(4).jit = [.01 0 0];

elseif 0

synProp(1).name = 'one';
synProp(1).is = ( parsedTypes.tp.rgc);
synProp(1).color = [0 1 0];
synProp(1).mark = 'o';
synProp(1).size = 200;
synProp(1).alpha = .5;
synProp(1).jit = [0 0 0];


synProp(2).name = 'two';
synProp(2).is = (parsedTypes.ps.darkMito);
synProp(2).color = [1 0 0];
synProp(2).mark = 'o';
synProp(2).size = 200;
synProp(2).alpha = .5;
synProp(2).jit = [0 .1 0];


synProp(3).name = 'three';
synProp(3).is = (parsedTypes.ps.noMito);
synProp(3).color = [0 0 1];
synProp(3).mark = 'o';
synProp(3).size = 200;
synProp(3).alpha = .5;
synProp(3).jit = [0 -.1 0];

synProp(4).name = 'four';
synProp(4).is = (parsedTypes.ps.isSpine );
synProp(4).color = [1 0 1];
synProp(4).mark = 'p';
synProp(4).size = 120;
synProp(4).alpha = .8;
synProp(4).jit = [.01 0 0];

elseif 1

synProp(1).name = 'one';
synProp(1).is = ( parsedTypes.ps.isDenseVec & parsedTypes.ps.darkMito);
synProp(1).color = [0 1 0];
synProp(1).mark = 'o';
synProp(1).size = 200;
synProp(1).alpha = .5;
synProp(1).jit = [0 0 0];


synProp(2).name = 'two';
synProp(2).is = ( parsedTypes.ps.isDenseVec & parsedTypes.ps.noMito);
synProp(2).color = [1 0 0];
synProp(2).mark = 'o';
synProp(2).size = 200;
synProp(2).alpha = .5;
synProp(2).jit = [0 .1 0];



end


for i = 1:length(refCids)

    cid = refCids(i);
    isCid = tis.syn.post == cid;

    for s = 1:length(synProp)

        synfo = glob.syn.defaultG;
        synfo.preCellIdx = 0;
        synfo.preName = 'none';
        synfo.postCellIdx = 0;
        synfo.postName = 'none';
        synfo.preName = 'none';
        synfo.synType = 'all'
        synfo.col = synProp(s).color;
        synfo.markerSize = synProp(s).size;
        synfo.markerType = synProp(s).mark;
        synfo.preTypeID = 1;
        synfo.preType = 'rgc';
        synfo.alph = synProp(s).alpha;
        % glob.syn.g(1).show = 1;

        %%Get positions
        isSyn = isCid & synProp(s).is;
        pos = tis.syn.synPosDS(isSyn,[2 1 3]) * glob.em.dsRes(1);
        pos = pos + repmat(synProp(s).jit,[size(pos,1) 1]);
        %%Translate positions
        if isfield(glob.vol,'shiftZ')
            dsPos = pos / tis.obI.em.dsRes;
            zInd = ceil(dsPos(:,3));
            zInd(zInd<1) = 1;
            shiftZ = glob.vol.shiftZ.shifts;
            shiftZ = shiftZ * tis.obI.em.dsRes;
            maxPos = max(zInd);
            if maxPos>length(shiftZ)
                shiftZ(maxPos,:) = [0 0];
            end
            yshift = shiftZ(zInd,2);
            xshift = shiftZ(zInd,1);
            pos(:,1) = pos(:,1) + yshift;
            pos(:,2) = pos(:,2) + xshift;
        end
        synfo.pos = pos;

        %%Create markers
        set(glob.ax, 'NextPlot', 'add')
        synfo.p = scatter3(glob.ax,pos(:,1),pos(:,2),pos(:,3),synfo.markerSize,...
            'markerfacecolor',synfo.col,'markerfacealpha',synfo.alph,...
            'marker',synfo.markerType,'markeredgecolor','w');

        %%Cleanup figure
        set(synfo.p,'clipping','off')
        synfo.synIdx = 0;
        synfo.name = synProp(s).name;
        gStr = get(glob.handles.popupmenu_synGroup,'String');
        gStr{L} = synfo.name;
        set(glob.handles.popupmenu_synGroup,'String',gStr);
        set(glob.handles.popupmenu_synGroup,'Value',L);

        glob.syn.g(s) = synfo;
    end

    drawnow
end









