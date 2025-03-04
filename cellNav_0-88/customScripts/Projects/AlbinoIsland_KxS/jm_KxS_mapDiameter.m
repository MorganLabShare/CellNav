
global glob tis
app = glob.app;


g1 = [1001  1003 1004 1006 1016  1015 ]; %red
g2 = [1002 1005 1007 1008 1011 1013 1014 1009 1019]; % blue


figR = figure;
figR.Color = [0 0 0];
axR = subplot(1,1,1,'parent',figR);
axR.Color = [0 0 0];
view(axR,0,90);
axis(axR,'equal');
axR.Clipping = 'off';

for i = 1:length(sms)
    disp(sprintf('running cell %d of %d',i,length(sms)))
    sm = sms(i).sm;
    if ~isempty(sm)

        nodeRad = sm.nep.nodeRad;

        fileName = sprintf('%s%d.mat',glob.useFvDir,sm.cid);
        fv = loadFV(fileName);;
        fv.vertices = fv.vertices(:,[2 3 1]);

        volName = glob.vol.activeName;

        if exist([glob.dir.Volumes volName '\volTransform.mat'],'file');
            load([glob.dir.Volumes volName '\volTransform.mat']);
        else
            volTransform = [];
        end

        glob.p.cell = renderFVnav(fv,[1 1 1],1,glob.pickCID,volTransform);




        %fv = sm.nep.fv;
        vert = fv.vertices;
        pos = sm.nep.pos;

        v2n = zeros(size(vert,1),1);
        for v = 1:size(vert,1)
            dist = sqrt((pos(:,1)-vert(v,1)).^2 + (pos(:,2)-vert(v,2)).^2 +...
                (pos(:,3)-vert(v,3)).^2);
            v2n(v) = find(dist==min(dist),1);
        end
        vRad = nodeRad(v2n);

        vProp = round(vRad*100);
        vProp(vProp<1) = 1;
        vProp(vProp>100) = 100;
        cMap = jet(100);

        p(i) = patch(axR,fv);
        p(i).FaceVertexCData = cMap(vProp,:);
        p(i).FaceColor = 'interp';
        p(i).EdgeColor = 'none';
        drawnow
    end
end


gShow = g1;
gHide = g2;

for i = 1:length(sms);
   
    sm = sms(i).sm;
    if ~isempty(sm)
        cid = sm.cid;
            p(i).FaceAlpha = 0;
        if sum(gShow==cid)
            p(i).FaceAlpha = 0.9;
            p(i).FaceColor = 'interp';
        elseif sum(gHide==cid)
            p(i).FaceAlpha = 0.1;
            p(i).FaceColor = [1 1 1];
        end
    end

end





