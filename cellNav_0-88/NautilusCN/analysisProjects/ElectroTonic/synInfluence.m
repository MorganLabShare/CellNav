function[influence] = getCellListInfluence(sm,inputs);



synfluence = attenuateFixedRadius(sm.syn2Skel.syn2SkelDist);

sumfluence = zeros(length(inputs),size(synfluence,2));

for i = 1:length(inputs)
    
    inList = inputs{i};
    sumfluence = zeros(length(inList),size(synfluence,2));
    for c = 1:length(inList)
        
        isIn = sm.syn.pre == inList(c);
        cellfluence = synfluence(isIn,:);
        sumfluence(c,:) = sum(cellfluence,1);
        
    end    
    influence(i,:) = sum(sumfluence,1);
    
end

