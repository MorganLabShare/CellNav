function[] = updateCellNavGlob()


global glob tis tisDat


glob.NA.MPN;


glob.fvOK = 1;
if exist([glob.useFvDir 'obI.mat'],'file')
    load([glob.useFvDir 'obI.mat'])
    glob.em = obI.em;
    
else
%    glob.fvOK = 0;
    glob.em = [];
end

if exist([glob.useFvDir 'tis.mat'])
    load([glob.useFvDir 'tis.mat'])
else
    glob.fvOK = 0;
end


%% Get types

if glob.fvOK
    
    typeID = tis.cells.type.typeID;
    hasType = unique(typeID);
    typeStrings = {'all'};
    if sum(hasType==0)
        typeStrings{2} = 'unassigned';
    end
    
    isType = hasType(hasType>0);
    glob.typeIDs = [0 0 isType];
    typeStrings = cat(2,typeStrings,...
        {tis.cells.type.typeNames{isType}});
    glob.pickIdx = 1;
    glob.typeStrings = typeStrings;
    glob.pickCID = tis.cids(glob.pickIdx);
    glob.cellNum = length(tis.cells.cids);
    glob.cids = tis.cells.cids;
    glob.listCellidx = 1:glob.cellNum;
else
    glob.typeIDs = 1;
    glob.typeStrings = {'all'};
    glob.pickIdx = [];
    glob.pickCID = [];
    glob.cellNum = 0;
    glob.cids = [];
    glob.listCellidx = [];
end

glob.pickCIDref = [];

glob.typeID = 0;
glob.subTypeID = 0;


%% Create functions

cellStr = {};
for i = 1:glob.cellNum
    cellStr{i} = sprintf('%d    %s',tis.cells.cids(i),tis.cells.label{i}) ;
end

glob.cellStr = cellStr;

glob.listCellidx = 1:glob.cellNum;


