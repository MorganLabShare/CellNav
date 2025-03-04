function[] = makeCellNavGlob()


clear global glob tis tisDat
global glob tis

%% save
curDir = dir('..');
glob.datDir = [curDir(end).folder '\'];
glob.fvDir = [glob.datDir 'Analysis\fvLibrary\'];


if ~exist(glob.fvDir,'dir')
    
    
    if exist('.\LastFvDir.mat')
        try load(['.\LastFvDir.mat']);end
        if exist('LastFvDir','var')  %%BLOCK due to drive failure
            TPN = uigetdir(LastFvDir);
        else
           %TPN=uigetdir(psw,'Define data directory (to contain Merge and Analysis');
           %Karl changed 'psw' to '[]' because it was throwing an error for
           %'psw' not being defined
           TPN=uigetdir([],'Define data directory (to contain Merge and Analysis');
        end
    else
        %TPN=uigetdir(psw,'Define data directory (to contain Merge and Analysis');
        TPN=uigetdir([],'Define data directory (to contain Merge and Analysis');
    end
    LastFvDir= [TPN '\'];
    
    if LastFvDir>0
        save('.\LastFvDir.mat','LastFvDir')
    end
    glob.datDir = LastFvDir;
end
glob.fvDir = [glob.datDir 'Analysis\fvLibrary\'];
glob.dir.Analysis = [glob.datDir 'Analysis\'];
glob.dir.Volumes = [glob.datDir 'Volumes\'];
glob.dir.Temp = [glob.datDir 'Temp\'];
if exist(glob.dir.Temp,'dir')
    rmdir(glob.dir.Temp,'s');
end
mkdir(glob.dir.Temp);


if ~exist(glob.dir.Analysis,'dir'),...
        mkdir(glob.dir.Analysis);end
if ~exist(glob.dir.Volumes,'dir'),...
        mkdir(glob.dir.Volumes);end
if ~exist(glob.fvDir,'dir'),mkdir(glob.fvDir);end

glob.vol.names = getDirs(glob.dir.Volumes);

for i = 1:length(glob.vol.names)
    tformName = [glob.dir.Volumes glob.vol.names{i} '\volTransform.mat'];
    if exist(tformName,'file')
        load(tformName);
        glob.vol.tforms{i} = volTransform;
    else
        glob.vol.tforms{i} = [];
    end
end

%Define active volume
glob.useFvDir = glob.fvDir;
glob.vol.activeID =0;
glob.vol.activeName = 'Main';
glob.vol.shiftPlane = 0;


glob.NA.MPN = glob.dir.Volumes;


glob.save.defaultDir = [glob.datDir 'saves\'];
glob.save.dir = glob.save.defaultDir;
if ~exist(glob.save.defaultDir,'dir'), mkdir(glob.save.defaultDir),end
glob.save.fileName = 'cellNavSave';

glob.save.functions = {'orbitCam'};

glob.vol.names = getDirs(glob.dir.Volumes);
vDir = glob.dir.Volumes;
libNames = {};
for i = 1:length(glob.vol.names);
    if exist([vDir glob.vol.names{i} '\Analysis\fvLibrary'],'dir')
        libNames = cat(1,libNames,glob.vol.names{i});
    end
end
glob.vol.libNames = libNames;




%% load
glob.swc = ['..\swc\'];
glob.p = [];
clear gca

glob.fvOK = 1;
if exist([glob.fvDir 'obI.mat'],'file')
    load([glob.fvDir 'obI.mat'])
    glob.em = obI.em;
    
else
    glob.fvOK = 0;
    glob.em = [];
end

if exist([glob.fvDir 'tis.mat'])
    load([glob.fvDir 'tis.mat'])
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

glob.param.markerSize = 100;
glob.fvRes = 0.1;

glob.typeID = 0;
glob.subTypeID = 0;

glob.g.idx = [];
glob.start = 1;


glob.highlight.idx = glob.pickIdx;
glob.highlight.cid = glob.pickCID;
glob.highlight.on = 0;

glob.colorOptions = {'rand','rainbow','red','green','blue','yellow','magenta','cyan',...
    'white','grey'};


glob.data.path.pts = [];
glob.data.path.pos = [];
glob.data.path.lengths = [];

%% Groups
glob.defaultG.idx = [];
glob.defaultG.cid = [];
glob.defaultG.col = [0 0 1];
glob.defaultG.alph = .7;
glob.defaultG.show = 0;
glob.defaultG.colIdx = 1;
glob.defaultG.alphIdx = 8;
glob.defaultG.name = 'none';
glob.defaultG.patch = [];

%% Com panel

glob.com.typeID = 1;
glob.com.funcID = 0;
glob.com.evalStr = char;
glob.com.result = char;

glob.com.typeStrings = {'all files', 'all registered','morphology','connectivity','path'};
dFunc = dir('.\functions\*.m') ;
fName = {dFunc.name};
for i = 1:length(fName);
    glob.com.functionFiles{i} = fName{i}(1:end-2);
end
glob.com.functions = {'testFunction'};
glob.com.typeFunctions{1} = [1:length(dFunc)];
glob.com.typeFunctions{2} = [1:length(glob.com.functions)];
glob.com.typeFunctions{3} = [];
glob.com.typeFunctions{4} = [1];
glob.com.typeFunctions{5} = [];


%% View panel list

glob.view.panelStrs = {'Com Window', 'Depth Histograms', 'Path Data'};


%% Edit Patch
glob.editPatch.col = [];
glob.editPatch.alph = [];

%% Syn
glob.syn.g.preCellIdx = [];
glob.syn.g.postCellIdx = [];
glob.syn.g.col = [1 0 0];
glob.syn.g.colIdx = 3;
glob.syn.g.alph = 1;
glob.syn.g.alphIdx = 11;
glob.syn.g.markerSize = 50;
glob.syn.g.markerType = 'o';
glob.syn.g.markerTypeIdx = 1;
glob.syn.g.preName = [];
glob.syn.g.postName = [];
glob.syn.g.show = 1;
glob.syn.g.pos = [];

glob.syn.g.synType = 'all';
glob.syn.g.synTypeID = 0;
glob.syn.g.synTypeListIdx = 1;
glob.syn.g.synIdx = [];
glob.syn.g.name = 'starter';
glob.syn.g.p = [];
glob.syn.g.preType = 'all';
glob.syn.g.preTypeID = 0;
glob.syn.g.postType = 'all';
glob.syn.g.postTypeID = 0;
glob.syn.defaultG =  glob.syn.g;

%% Functions

%% Connections
glob.con.isPre = [];
glob.con.isPost = [];

%% Other Objects (ref)

glob.param.ref = zeros(100);

%% NautilusCNV
glob.NA.export.exportName = 'exportName';
glob.NA.export.useLib = {};

%% Create functions

cellStr = {};
for i = 1:glob.cellNum
    cellStr{i} = sprintf('%d    %s',tis.cells.cids(i),tis.cells.label{i}) ;
end

glob.cellStr = cellStr;

glob.listCellidx = 1:glob.cellNum;
