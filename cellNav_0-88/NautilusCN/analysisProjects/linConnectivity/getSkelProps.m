function[sm] = getSkelProps(sm)


pos = sm.nep.pos;
edges = sm.nep.edges;

%% get lengths for nodes

lengths = sqrt((pos(edges(:,1),1)-(pos(edges(:,2),1))).^2 + ...
    (pos(edges(:,1),2)-(pos(edges(:,2),2))).^2 + ...
    (pos(edges(:,1),3)-(pos(edges(:,2),3))).^2);

skelProps.edgeLength = lengths;


skelProps.nodeLength = sm.nep.nodes * 0;
for i = 1:length(lengths) 
    skelProps.nodeLength(edges(i,1)) =  skelProps.nodeLength(edges(i,1)) + lengths(i)/2;
    skelProps.nodeLength(edges(i,2)) =  skelProps.nodeLength(edges(i,2)) + lengths(i)/2;    
end


sm.nep.props=skelProps;