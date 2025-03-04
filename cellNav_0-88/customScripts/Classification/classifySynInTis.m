

global glob tis

mergeDir =  [glob.dir.Volumes  glob.vol.activeName '\Merge\'];
load([mergeDir 'obI.mat'])
load([mergeDir 'dsObj.mat'])


rgcs = tis.cids(find(tis.cells.type.typeID==1));
tcrs = tis.cids(find(tis.cells.type.typeID==2));
lins = tis.cids(find(tis.cells.type.typeID==3));

%% Search tags to define synapse type
for o = 1:length(tis.syn.obID)
    nam = obI.nameProps.names{tis.syn.obID(o)};
    findRGC = regexp(lower(nam),'rgc');
    findLIN = regexp(lower(nam),'lin');

    if ~isempty(findRGC)
        tis.syn.preClass(o) = 1;
        tis.syn.synType(o) = 3;
    elseif ~isempty(findLIN)
        tis.syn.preClass(o) = 3;
        tis.syn.synType(o) = 4;    
    else
        tis.syn.synType(o) = 0;
    end
end

%% Define synapse type by pre/post class

prePostTypeRule = [1 2 3; 3 2 4; 1 3 5; 3 3 6];
tis.syn.prePostTypeName = {'Conventional','Ribbon','RGCtoTC','LINtoTC','RGCtoLIN','LINtoLIN'};
tis.syn.prePostTypeRule = prePostTypeRule;
preClass = tis.syn.preClass;
postClass = tis.syn.postClass;

for i = 1:size(prePostTypeRule,1)
isType = (preClass==prePostTypeRule(i,1)) & (postClass == prePostTypeRule(i,2));
tis.syn.synType(isType) = prePostTypeRule(i,3);
end


if 1
    save([glob.fvDir 'tis.mat'],'tis')
end


%s = makeSynapseClassifyer(COI); %make structure describing types of synapses


