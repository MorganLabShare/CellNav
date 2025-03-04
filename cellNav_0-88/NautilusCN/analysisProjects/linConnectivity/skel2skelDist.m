function[sm] = skel2skelDist(sm)
clear q

D = parallel.pool.DataQueue;
h = waitbar(0, 'Please wait ...');
afterEach(D, @nUpdateWaitbar);
p = 1;

edges = sm.nep.edges;
nodes = sm.nep.nodes;
num = length(nodes);


pos = sm.nep.pos;
lengths = sqrt((pos(edges(:,1),1)-pos(edges(:,2),1)).^2 + ...
    (pos(edges(:,1),2)-pos(edges(:,2),2)).^2 + ...
    (pos(edges(:,1),3)-pos(edges(:,2),3)).^2);
eucDist = zeros(num);
linDist = zeros(num);
n = num;
%fprintf(1,'%s\n\n',repmat('.',1,n));
parfor y = 1:num
    
    pp = node2nodeDist(edges,lengths,nodes(y));
    eucDist(y,:) = sqrt((pos(:,1)-pos(nodes(y),1)).^2 + (pos(:,2)-pos(nodes(y),2)).^2 + ...
        (pos(:,3)-pos(nodes(y),3)).^2);
    linDist(y,:) = pp.dists;
    %fprintf(1,'\b.\n'); % \b is backspace
    send(D, y);
end
    function nUpdateWaitbar(~)
        waitbar(p/num, h);
        p = p + 1;
    end

linDist2 = max(linDist,eucDist);
% plot(1:1000,1:1000)
% hold on
% scatter(eucDist(:),linDist(:),'.');
% hold off

sm.skel2skel.linDist = linDist2;
sm.skel2skel.eucDist = eucDist;


close(h)





end