function[sm] = syn2SkelSM(sm)


show = 1;

%% Get skeletons

pos = sm.nep.pos;
edges = sm.nep.edges;
pts = sm.syn.pos;


if show
scatter3(pos(:,1),pos(:,2),pos(:,3),'.','b')
hold on
scatter3(pts(:,1),pts(:,2),pts(:,3),300,'.','r')
hold off
end

dif = cat(3,pos(:,1)'-pts(:,1),pos(:,2)'-pts(:,2),pos(:,3)'-pts(:,3));
syn2Skel.skelEucDist = sqrt(sum(dif.^2,3)); %first dimension is skel, second is synapses
syn2Skel.skelMinDist = min(syn2Skel.skelEucDist,[],2);

syn2Skel.closest = syn2Skel.skelMinDist * 0;
for i = 1:size(pts,1)
    syn2Skel.closest(i) = find(syn2Skel.skelEucDist(i,:)==syn2Skel.skelMinDist(i),1);
end


if show
    hold on
    scatter3(pos(syn2Skel.closest,1),pos(syn2Skel.closest,2),pos(syn2Skel.closest,3),'.','g')
    hold off
end




sm.syn2Skel = syn2Skel;


maxDist = max(syn2Skel.skelMinDist);

if maxDist>2
    sprintf('distance of %d found between a synapse and a skeleton.',maxDist)
end


%% extract syn2skel topoDistances


syn2Skel.skelTopoDist = sm.skel2skel.linDist(syn2Skel.closest,:);
syn2Skel.syn2SkelDist = max(syn2Skel.skelTopoDist,syn2Skel.skelEucDist); %topo cant bring closer together
syn2Skel.syn2SynDist = syn2Skel.syn2SkelDist(:,syn2Skel.closest);



sm.syn2Skel = syn2Skel;














