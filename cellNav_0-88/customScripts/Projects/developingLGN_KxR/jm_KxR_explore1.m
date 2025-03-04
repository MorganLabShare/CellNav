%%Display three groups of TCRS and their synapses

global glob tis app

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


%% Define groups
if isfield(glob,'g')
    L = length(glob.g);
else
    L = 0;
end


g1 = [3001	3004	3017	3018	3021	3031	3032	3040	3097	3098	3107	3203	3206	3209	3210	3213											]; %red
g2 = [4182	4275	4514	5003	5038	4125	4097	4095	4087	4077	4075	4057	4054	4053	4046	4045	4015	4011	4009	4007	4004	4003	4002	169	139]; % blue
g3 = [4001	4005	4035	4018];

refCids = [g1 g2 g3];

rCol = zeros(length(refCids),3)+.2;
sCol = zeros(length(refCids),3)+.2;
rAlph = 1; % cells
sAlph = 1; %Synapses
rsAlph = 1; %Rgc synapses

for i = 1:length(g1)
    targ = find(refCids==g1(i));
    rCol(targ,:) = [0 1 0];
    sCol(targ,:) = [1 .2 0];
    rsCol(targ,:) = [0 1 0];
end
for i = 1:length(g2)
    targ = find(refCids==g2(i));
    rCol(targ,:) = [1 0 1];
    sCol(targ,:) = [1 0 .2];
    rsCol(targ,:) = [1 0 1];

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

%% Show groups
updateGroups(glob.app)
showCellGroup(glob.app, newG)


%% Make synapses

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

return



%% Take snapshots

%%First run jm_KxS_showGreenMagentaBoutons.m

% for i = 1:length(glob.g)
%     cidTarg = i;
%     for p = 1:length(glob.g(cidTarg).patch)
%         %set(glob.g(cidTarg).patch(p),'FaceColor',newCidCol(p,:));
%         set(glob.g(cidTarg).patch(p),'FaceAlpha',0);
%     end
% end


for i = 1:length(refCids)

    cid = refCids(i);

    synTarg = rSynGids(find(rSynGids(:,1) == cid,1),2);
    cidTarg = cellGids(find(cellGids(:,1) == cid,1),2);

    if ~isempty(cidTarg)

        oldCidCol = glob.g(cidTarg).col;
        oldCidAlph = glob.g(cidTarg).alph;

        newCidCol = [1 1 1];
        newCidAlph = 0.4;

        for p = 1:length(glob.g(cidTarg).patch)
            set(glob.g(cidTarg).patch(p),'FaceColor',newCidCol(p,:));
            set(glob.g(cidTarg).patch(p),'FaceAlpha',newCidAlph);
        end


        glob.syn.g(1).preCellIdx = [];
        glob.syn.g(1).postCellIdx = glob.g(cidTarg).idx;
        glob.syn.g(1).col = [.1 .1 1];
        glob.syn.g(1).markerSize = 300;
        glob.syn.g(1).markerType = 'o';
        glob.syn.g(1).preTypeID = 1;
        glob.syn.g(1).preType = 'rgc';
        % glob.syn.g(1).preName = glob.g(cidTarg).name;
        % glob.syn.g(1).show = 1;
        drawSyn(app)
    end

    if ~isempty(synTarg)
        oldSynCol = glob.g(synTarg).col;
        oldSynAlph = glob.g(synTarg).alph;

        newSynCol = [.1 .1 1];
        newSynAlph = 1;

        for p = 1:length(glob.g(synTarg).patch)
            set(glob.g(synTarg).patch(p),'FaceColor',newSynCol);
            set(glob.g(synTarg).patch(p),'FaceAlpha',newSynAlph);
        end

    end

    if ~isempty(cidTarg)

        picName = sprintf('cid%d',cid);
        app.edit13.Value = picName;
        glob.save.fileName = picName;
        takeSnapShot(app)

        for p = 1:length(glob.g(cidTarg).patch)
            set(glob.g(cidTarg).patch(p),'FaceColor',oldCidCol);
            set(glob.g(cidTarg).patch(p),'FaceAlpha',oldCidAlph);
        end

    end

    if ~isempty(synTarg)
        for p = 1:length(glob.g(synTarg).patch)
            set(glob.g(synTarg).patch(p),'FaceColor',oldSynCol(p,:));
            set(glob.g(synTarg).patch(p),'FaceAlpha',oldSynAlph);
        end
    end

    drawnow
end









