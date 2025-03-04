function results = cid2type(cid, curtis)
for i=1:length(cid)
    curCid=cid(i);
    if curCid==0
        typStr(i)={'none'};
        subTypStr(i)={'none'};
        typ(i)=0;
        subTyp(i)=0;
    else
        cellID=find(curtis.cells.cids==curCid);
        if ~isempty(cellID)
        typ(i)=curtis.cells.type.typeID(cellID);
        if typ(i)==0
            typStr(i)={'none'};
        else
            if find(curtis.cells.type.typeNameIDs==typ(i))
                typStr{i}=curtis.cells.type.typeNames{find(curtis.cells.type.typeNameIDs==typ(i))};
            else
                typStr{i}='null';
            end
        end
        %typStr{i}=curtis.cells.type.typeNames{find(curtis.cells.type.typeNameIDs==typ(i))};
        subTyp(i)=curtis.cells.type.subTypeID(cellID);
        if subTyp(i)==0
            subTypStr(i)={'none'};
        else
            subTypStr{i}=curtis.cells.type.subTypeNames{typ(i)}{subTyp(i)};
        end
        else
            typStr(i)={'none'};
            subTypStr(i)={'none'};
        end
    end
end
results={typ,typStr,subTyp,subTypStr};
end