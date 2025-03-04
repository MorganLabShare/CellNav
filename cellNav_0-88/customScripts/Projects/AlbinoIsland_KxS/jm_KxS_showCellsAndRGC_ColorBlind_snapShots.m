%%Display three groups of TCRS and their synapses

% %% Set defined camera position
% glob.ax.CameraTargetMode = 'manual';
% glob.ax.CameraViewAngleMode = 'manual';
% glob.ax.CameraTargetMode = 'manual';
% view(glob.ax,115,-30)
% camproj(glob.ax,'orthographic')
% lightangle(glob.light,190,-40)
% glob.ax.CameraPosition = [845.9821  443.0145 -486.1594];
% glob.ax.CameraTarget = [161.0960  117.0138   53.0138];
% glob.ax.CameraViewAngle = 6;
% 
% 
% %% Define groups
% if isfield(glob,'g')
%     L = length(glob.g);
% else
%     L = 0;
% end
% 
% 
% g1 = [1001  1003 1004 1006 1016  1015 ]; %red
% g2 = [1002 1005 1007 1008 1011 1013 1014 1009 1019]; % blue
% g3 = [1017];
% 
% refCids = [g1 g2 g3];
% 
% rCol = zeros(length(refCids),3)+.2;
% sCol = zeros(length(refCids),3)+.2;
% rAlph = 0; % cells
% sAlph = 0; %Synapses
% rsAlph = .1; %Rgc synapses
% 
% for i = 1:length(g1)
%     targ = find(refCids==g1(i));
%     rCol(targ,:) = [0 1 0];
%     sCol(targ,:) = [1 .2 0];
%     rsCol(targ,:) = [0 1 0]
% end
% for i = 1:length(g2)
%     targ = find(refCids==g2(i));
%     rCol(targ,:) = [1 0 1];
%     sCol(targ,:) = [1 0 .2];
%     rsCol(targ,:) = [1 0 1];
% 
% end
% 
% 
% 
% idx = refCids * 0;
% for i = 1 : length(refCids)
%     targ = find(tis.cids==refCids(i),1);
%     if ~isempty(targ)
%         idx(i) = targ;
%     end
% end
% 
% 
% useRef = find(idx>0);
% newG = [1:length(useRef)] + L;
% cellGids = zeros(length(useRef),2);
% for i = 1:length(useRef)
% 
%     %% make new group
%     rID = useRef(i);
%     glob.g(newG(i)) = glob.defaultG;
%     glob.g(newG(i)).idx = idx(rID);
%     glob.g(newG(i)).cid = tis.cids(idx(rID));
%     glob.g(newG(i)).col = rCol(rID,:);
%     glob.g(newG(i)).alph = rAlph;
%     glob.g(newG(i)).show = 1;
%     glob.g(newG(i)).name = sprintf('g%d - c%s',L, num2str(glob.g(L+i).cid));
% 
%     cellGids(i,:) = [tis.cids(idx(rID)) newG(i)];
% 
% 
% end
% 
% if 0
% %%Load references
%  rID = useRef(i);
%     glob.g(newG(i)) = glob.defaultG;
%     glob.g(newG(i)).idx = idx(rID);
%     glob.g(newG(i)).cid = {'Exclusion top plane'};
%     glob.g(newG(i)).col = [0 0 1];
%     glob.g(newG(i)).alph = .2;
%     glob.g(newG(i)).show = 1;
%     glob.g(newG(i)).name = 'Exclusion top plane';
% end
% 
% 
% 
%     %% Show groups
% showCellGroup(app, newG)
% 
% 
% 
% %% Make synapses
% 
% 
% 
% %%Create temp FV
% load([glob.dir.Volumes glob.vol.activeName '\Merge\dsObj.mat'])
% load([glob.dir.Volumes glob.vol.activeName '\Merge\obI.mat'])
% 
% nams = obI.nameProps.names;
% 
% %%Find all rgc tags
% isRGC = zeros(length(nams),1);
% hitsC = regexp(lower(nams),'rgc');
% for o = 1:length(nams)
%     isRGC(o) =  sum(hitsC{o});
% end
% 
% synCount = refCids * 0;
% rgcInCount = refCids * 0;
% for i = 1:length(refCids)
% 
% 
%     %%Find all pre
%     isPre = zeros(length(nams),1);
%     hitsC = regexp(nams,sprintf('pre cid%d',refCids(i)));
%     for o = 1:length(nams)
%         isPre(o) = sum(hitsC{o});
%     end
% 
%     hitsC = regexp(nams,sprintf('syn cid%d',refCids(i)));
%     for o = 1:length(nams)
%         isPre(o) = isPre(o) + sum(hitsC{o});
%     end
% 
% 
%     synObIds{i} = find(isPre>0);
%     synCount(i) = sum(isPre>0);
% 
%     rgcInObIds{i} = find((isPre & isRGC)>0);
%     rgcInCount(i) = sum((isPre & isRGC)>0);
% end
% 
% usePre = find(synCount>0);
% newPG = [1:length(usePre)] + length(glob.g);
% 
% 
% for i = 1:length(usePre)
% 
%     rID = newPG(i);
%     obIds = setdiff(synObIds{usePre(i)},rgcInObIds{usePre(i)});
% 
%     glob.g(rID) = glob.defaultG;
%     glob.g(rID).idx = obIds;
%     glob.g(rID).cid = nams(obIds);
%     glob.g(rID).alph = sAlph;
%     glob.g(rID).col = repmat(sCol(usePre(i),:),[length(glob.g(rID).idx) 1]);
%     glob.g(rID).show = 1;
% 
%     namStr = sprintf('pre %d',refCids(usePre(i)));
%     glob.g(rID).name = sprintf('cg%d - %s',rID,namStr);
% 
%     drawObj(glob.app,dsObj,obI,obIds,newPG(i))
% end
% 
% usePre = find(rgcInCount>0);
% newPG = [1:length(usePre)] + length(glob.g);
% 
% rSynGids = zeros(length(usePre),2);
% for i = 1:length(usePre)
% 
%     rID = newPG(i);
%     obIds = rgcInObIds{usePre(i)};
% 
%     glob.g(rID) = glob.defaultG;
%     glob.g(rID).idx = obIds;
%     glob.g(rID).cid = nams(obIds);
%     glob.g(rID).alph = rsAlph;
%     glob.g(rID).col = repmat(rsCol(usePre(i),:),[length(glob.g(rID).idx) 1]);
%     glob.g(rID).show = 1;
% 
%     namStr = sprintf('rgc pre %d',refCids(usePre(i)));
%     glob.g(rID).name = sprintf('cg%d - %s',rID,namStr);
% 
%     drawObj(glob.app,dsObj,obI,obIds,newPG(i))
%     rSynGids(i,:) = [refCids(usePre(i)) rID];
% 
% end
% 
% updateGroups(app)
% %edit2_function(app)
% 
% return



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
        newCidAlph = 0.2;

        for p = 1:length(glob.g(cidTarg).patch)
            set(glob.g(cidTarg).patch(p),'FaceColor',newCidCol(p,:));
            set(glob.g(cidTarg).patch(p),'FaceAlpha',newCidAlph);
        end




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









