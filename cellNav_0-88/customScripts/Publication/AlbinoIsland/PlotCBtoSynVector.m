



global tis

fig = figure;
fig2 = figure;
ax1 = subplot(1,1,1,'parent',fig);
ax2 = subplot(1,1,1,'parent',fig2);

ax1.NextPlot ="add";
ax2.NextPlot ="add";


ax1.CameraTargetMode = 'manual';
ax1.CameraViewAngleMode = 'manual';
ax1.CameraTargetMode = 'manual';
%view(ax1,115,-30)
view(ax1,128.7, -39)
camproj(ax1,'orthographic')
ax1.CameraPosition = [830.5858  680.7245 -635.7334];
ax1.CameraTarget = [170.3253  152.6940   50.3190];
ax1.CameraViewAngle = 6;



tcCids = [1001 1002 1003 1004 1005 1006 1007 1009 1011 1013 1014 1015 1016 1017 1019];


%% Parse synaspse type

for o = 1:length(tis.syn.obID)
    nam = obI.nameProps.names{tis.syn.obID(o)};
    findRGC = regexp(lower(nam),'rgc');
    if ~isempty(findRGC)
        tis.syn.preClass(o) = 1;
        tis.syn.synType(o) = 3;
    else
        tis.syn.synType(o) = 4;
    end
end


%% Collect cell data
clear tc rsNums
for i = 1:length(tcCids)
    cid = tcCids(i);
    tc(i).cid = cid;

    %%Mark cell body
    cidID = find(tis.cids==cid,1);
    anchor = tis.cells.anchors(cidID,:);
    tc(i).cbPos = double(anchor([2 1 3])) .* obI.em.res/1000;
   
    %%Find synapses
    isPost = tis.syn.post==cid;
    fromRGC = tis.syn.preClass == 1;
    rsID = find(isPost & fromRGC);
    tc(i).rs.synID = rsID;
    tc(i).rs.pos = tis.syn.pos(rsID,:);
    tc(i).rs.meanPos = mean(tc(i).rs.pos,1);
    tc(i).rs.num = length(rsID);
    rsNums(i) = length(rsID);
end



%% Show 3D
if 1
    cla(ax1)
    view(ax1,0,-90)
    axis(ax1,'equal')
    for i = 1:length(tcCids)
        for s = 1:tc(i).rs.num
            plot3(ax1,[tc(i).rs.meanPos(2) tc(i).rs.pos(s,2)],[tc(i).rs.meanPos(1) tc(i).rs.pos(s,1)],...
                [tc(i).rs.meanPos(3) tc(i).rs.pos(s,3)],'color',[0 0 0 .2])
            scatter3(ax1,tc(i).rs.pos(s,2),tc(i).rs.pos(s,1),tc(i).rs.pos(s,3),...
                20,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor','none','MarkerFaceAlpha',.3)
        end
        scatter3(ax1,tc(i).rs.meanPos(2),tc(i).rs.meanPos(1),tc(i).rs.meanPos(3),...
            100,'MarkerFaceColor',[.9 .9 .9],'MarkerEdgeColor',[0 0 0],'LineWidth',2)
        drawnow
    end
    for i = 1:length(tcCids)
        x = [tc(i).cbPos(2) tc(i).rs.meanPos(2)];
        y = [tc(i).cbPos(1) tc(i).rs.meanPos(1)];
        z = [tc(i).cbPos(3) tc(i).rs.meanPos(3)];
        %h = annotation(fig,'arrow');
        % set(h,'parent', ax1, ...
        %     'position', [x(1),y(1),x(2)-x(1),y(2)-y(1)], ...
        %     'HeadLength', 10, 'HeadWidth', 10, 'HeadStyle', 'cback1','Color',[1 0 0],'LineWidth',3);
        % scatter(ax1,tc(i).cbPos(2),tc(i).cbPos(1),200,'MarkerFaceColor',[1 .8 .8],'MarkerEdgeColor',[1 0 0],'LineWidth',2)
        scatter3(ax1,tc(i).cbPos(2),tc(i).cbPos(1),tc(i).cbPos(3),...
            150,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor','none','LineWidth',2)
        %scatter(ax1,tc(i).cbPos(2),tc(i).cbPos(1),400,'MarkerFaceColor','none','MarkerEdgeColor','r','lineWidth',2)
        plot3(ax1,[tc(i).cbPos(2) tc(i).rs.meanPos(2)],[tc(i).cbPos(1) tc(i).rs.meanPos(1)],...
            [tc(i).cbPos(3) tc(i).rs.meanPos(3)],'r','linewidth',1)
        drawnow
        text(ax1,x(1),y(1),z(1),sprintf('%d',tc(i).cid))

    end

    % scatter3(ax1,tc(i).cbPos(2),tc(i).cbPos(1),tc(i).cbPos(3),100,'MarkerFaceColor','b','MarkerEdgeColor','none')
    % scatter3(ax1,tc(i).cbPos(2),tc(i).cbPos(1),tc(i).cbPos(3),400,'MarkerFaceColor','none','MarkerEdgeColor','b','lineWidth',2)
    %
    % plot3(ax1,[tc(i).cbPos(2) tc(i).rs.meanPos(2)],[tc(i).cbPos(1) tc(i).rs.meanPos(1)],[tc(i).cbPos(3) tc(i).rs.meanPos(3)],'k','linewidth',5)
    % scatter3(ax1,tc(i).rs.meanPos(2),tc(i).rs.meanPos(1),tc(i).rs.meanPos(3),100,'MarkerFaceColor','r','MarkerEdgeColor','none')
    %
    % for s = 1:tc(i).rs.num
    %     plot3(ax1,[tc(i).rs.meanPos(2) tc(i).rs.pos(s,2)],[tc(i).rs.meanPos(1) tc(i).rs.pos(s,1)],[tc(i).rs.meanPos(3) tc(i).rs.pos(s,3)],'color',[0 0 0 .3])
    %     scatter3(ax1,tc(i).rs.pos(s,2),tc(i).rs.pos(s,1),tc(i).rs.pos(s,3),20,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor','none','MarkerFaceAlpha',.3)



    drawnow
end


%% Show 2D
if 0
    cla(ax1)
    %view(ax1,0,-90)
    axis(ax1,'equal')
    ax1.YDir = 'normal';
    % ax1.YLim = [30 90];
    % ax1.XLim = [40 130];
    for i = 1:length(tcCids)
        for s = 1:tc(i).rs.num
            plot(ax1,[tc(i).rs.meanPos(2) tc(i).rs.pos(s,2)],[tc(i).rs.meanPos(1) tc(i).rs.pos(s,1)],'color',[0 0 0 .2])
            scatter(ax1,tc(i).rs.pos(s,2),tc(i).rs.pos(s,1),20,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor','none','MarkerFaceAlpha',.3)
        end
        scatter(ax1,tc(i).rs.meanPos(2),tc(i).rs.meanPos(1),100,'MarkerFaceColor',[.9 .9 .9],'MarkerEdgeColor',[0 0 0],'LineWidth',2)
        drawnow
    end
    for i = 1:length(tcCids)
        x = [tc(i).cbPos(2) tc(i).rs.meanPos(2)];
        y = [tc(i).cbPos(1) tc(i).rs.meanPos(1)];
        %h = annotation(fig,'arrow');
        % set(h,'parent', ax1, ...
        %     'position', [x(1),y(1),x(2)-x(1),y(2)-y(1)], ...
        %     'HeadLength', 10, 'HeadWidth', 10, 'HeadStyle', 'cback1','Color',[1 0 0],'LineWidth',3);
        % scatter(ax1,tc(i).cbPos(2),tc(i).cbPos(1),200,'MarkerFaceColor',[1 .8 .8],'MarkerEdgeColor',[1 0 0],'LineWidth',2)
        scatter(ax1,tc(i).cbPos(2),tc(i).cbPos(1),150,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor','none','LineWidth',2)
        %scatter(ax1,tc(i).cbPos(2),tc(i).cbPos(1),400,'MarkerFaceColor','none','MarkerEdgeColor','r','lineWidth',2)
        plot(ax1,[tc(i).cbPos(2) tc(i).rs.meanPos(2)],[tc(i).cbPos(1) tc(i).rs.meanPos(1)],'r','linewidth',1)
        drawnow
               text(ax1,x(1),y(1),sprintf('%d',tc(i).cid))
 
    end


end


%% Make report

cla(ax2)
clear report
for i = 1:length(tc)
    report(i,1) = tc(i).cid;
    report(i,2) = tc(i).rs.num;

end

report = cat(1,report,[1008 0]);
rsNum = report(:,2);
swarmchart(ax2,rsNum*0,rsNum);

range1 = 0:max(rsNum);
h1 = histc(rsNum,range1);
bar(range1,h1)

cla(ax2)
cumNum = cumsum(h1);
plot(ax2,range1,cumNum,'k')
xlim(ax2,[-10 max(rsNum)+10])
ylim(ax2,[0 20]);
hold on
ypos = cumNum(rsNum+1)+1;
for t = 1:length(rsNum);
    plot(ax2,[rsNum(t) rsNum(t)],[0 ypos(t)],'k')
    text(ax2,rsNum(t)-2,ypos(t)+.5,num2str(rsNum(t)))

end


%% Save figure

if 0
    % saveName = 'D:\WorkDocs\Publications\Statistics\Figures\Kidney\kidney3.eps'
    % print(fig,'-depsc','-painters',saveName)

    disp('printing pdf')
    if 1
        saveName = 'D:\WorkDocs\Publications\AlbinoIsaland\Figures\Pics\CBvectors5.pdf'
    else
        TFN = uigetdir;
        saveName = [TFN '\CBvectorsX.pdf'];
    end

    print(fig,'-dpdf','-painters',saveName)
    disp('finished printing pdf')

    % saveName = 'D:\WorkDocs\Publications\Statistics\Figures\Kidney\kidney3.svg'
    % print(fig,'-dsvg','-painters',saveName)

end






