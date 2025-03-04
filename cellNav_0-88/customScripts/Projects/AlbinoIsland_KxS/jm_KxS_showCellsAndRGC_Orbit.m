
%% Take snapshots
%%First run boutons

picName = 'testRotationSeries7';
app.edit13.Value = picName;
glob.save.fileName = picName;

s = 60;
[a e] = view(glob.ax);


cam.pos  = glob.ax.CameraPosition;
cam.targ  = glob.ax.CameraTarget;
cam.dar  = glob.ax.DataAspectRatio;
cam.up  = glob.ax.CameraUpVector;

% 
% %%Turn cells off
% for i = 1:length(refCids)
% 
%     cid = refCids(i);
% 
%     synTarg = rSynGids(find(rSynGids(:,1) == cid,1),2);
%     cidTarg = cellGids(find(cellGids(:,1) == cid,1),2);
% 
%     if ~isempty(cidTarg)
%         for p = 1:length(glob.g(cidTarg).patch)
%             set(glob.g(cidTarg).patch(p),'FaceAlpha',0);
%         end
% 
%     end
% end

%%Turn cells on one at a time
for i = 1:length(refCids)

    cid = refCids(i);

    synTarg = rSynGids(find(rSynGids(:,1) == cid,1),2);
    cidTarg = cellGids(find(cellGids(:,1) == cid,1),2);

    if ~isempty(cidTarg)

        oldCidCol = glob.g(cidTarg).col;
        oldCidAlph = glob.g(cidTarg).alph;

        newCidCol = [1 1 1];
        newCidAlph = 0.6;

        for p = 1:length(glob.g(cidTarg).patch)
            set(glob.g(cidTarg).patch(p),'FaceColor',newCidCol(p,:));
            set(glob.g(cidTarg).patch(p),'FaceAlpha',newCidAlph);
        end

    end

    if ~isempty(synTarg)
        oldSynCol = glob.g(synTarg).col;
        oldSynAlph = glob.g(synTarg).alph;

        newSynCol = [1 0 0];
        newSynAlph = 1;

        for p = 1:length(glob.g(synTarg).patch)
            set(glob.g(synTarg).patch(p),'FaceColor',newSynCol);
            set(glob.g(synTarg).patch(p),'FaceAlpha',newSynAlph);
        end

    end

    if ~isempty(cidTarg)


        %takeSnapShot(app)
        [cam] = orbitCamPartial(cam,s)

        drawnow

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









