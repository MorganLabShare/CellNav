function[nep2] = bonesVsSpurs(nep,minTip);


bones = nep.bones;



useRun = ones(length(bones),1);
for b = 1:length(bones)
    if bones(b).isTip
        if sum(bones(b).lengths)<minTip
            useRun(b) = 0;
        end
    end
end


if isfield(nep,'spurs')
    spurs = nep.spurs;
    useSpurs = ones(length(spurs),1);
    for b = 1:length(spurs)
        if sum(spurs(b).lengths)<minTip
            useSpurs(b) = 0;
        end
    end
    
newBones = [bones(useRun>0) spurs(useSpurs>0)];
newSpurs = [bones(useRun==0) spurs(useSpurs==0)];

else
    
newBones = [bones(useRun>0)];
newSpurs = [bones(useRun==0) ];

    
end 

nep2 = nep;
nep2.bones = newBones;
nep2.spurs = newSpurs;