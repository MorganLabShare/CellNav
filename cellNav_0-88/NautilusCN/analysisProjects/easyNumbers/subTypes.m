global tis sm

targ = 2

isIn = tis.syn.post == targ;
isOut = tis.syn.pre == targ;
inCid = tis.syn.pre(isIn);
outCid = tis.syn.post(isOut);


checkCid = outCid;
clear synSubType
for i = 1:length(checkCid)
    idx = find(tis.cids == checkCid(i),1);
    if isempty(idx)
        synSubType{i,1} = 'no cid';
    else
        typeID = tis.cells.type.typeID(idx);
        subTypeID = tis.cells.type.subTypeID(idx);
        if subTypeID
        synSubType{i,1} = tis.cells.type.subTypeNames{typeID}{subTypeID};
        else
            synSubType{i,1} = 'no subtype';
        end
    end
end

        dyadSubType = {};
isVV = [];
for s = 1:length(tis.syn.synProp)
    if length(tis.syn.synProp{s}.postGroup)>0
        checkCid = tis.syn.synProp{s}.postGroup;
        
        for i = 1:length(checkCid)
            idx = find(tis.cids == checkCid(i),1);
            if isempty(idx)
                dyadSubType{s}{i} = 'no cid';
            else
                typeID = tis.cells.type.typeID(idx);
                subTypeID = tis.cells.type.subTypeID(idx);
                if subTypeID
                    dyadSubType{s}{i} = tis.cells.type.subTypeNames{typeID}{subTypeID};
                else
                    dyadSubType{s}{i} = 'no subtype';
                end
            end
        end
        
        if length(dyadSubType{s})>1
            c = 0;
            for i = 1:length(dyadSubType{s})
                c = c + (regexp(dyadSubType{s}{i},'vgc')>0);
            end
            if c>1
                isVV = [isVV s];
            end
        end
        
        
    end
end

disp('vv dyads')
vvProp = tis.syn.synProp(isVV)
for i = 1:length(vvProp)
    vvProp{i}
end


