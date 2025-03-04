function[] = makeCellNavGlob()


clear global glob
global glob tis
    
%% save
    glob.fvDir = ['..\fvLibrary\'];
    if ~exist(glob.fvDir,'dir')
        
        
        if exist('.\LastFvDir.mat')
            load(['.\LastFvDir.mat']);
            if exist('LastFvDir','var')
                TPN = uigetdir(LastFvDir);
            else
                TPN=uigetdir;
            end
        else
            TPN=uigetdir;
        end
        LastFvDir= [TPN '\'];
        
        if LastFvDir>0
            save('.\LastFvDir.mat','LastFvDir')
        end
        glob.fvDir = LastFvDir;
    end
    
    glob.save.defaultDir = [glob.fvDir 'saves\'];
    glob.save.dir = glob.save.defaultDir;
    if ~exist(glob.save.defaultDir,'dir'), mkdir(glob.save.defaultDir),end
    glob.save.fileName = 'cellNavSave';

    
    
    glob.save.functions = {'orbitCam'};
    
    
    
    
    %% load 
    glob.swc = ['..\swc\'];
    glob.p = [];
    clear gca
    
    load([glob.fvDir 'obI.mat'])
    % load([MPN 'dsObj.mat'])
    load([glob.fvDir 'tis.mat'])
    %
    % glob.MPN = MPN;
    % glob.WPN = WPN;
    
    %% Get types
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
    
    glob.typeStrings = typeStrings;
    
    
    glob.pickIdx = 1;
    glob.pickCID = tis.cids(glob.pickIdx);
    glob.pickCIDref = [];
    
    glob.param.markerSize = 100;
    glob.fvRes = 0.1;
    glob.em = obI.em;
    
    glob.cellNum = length(tis.cells.cids);
    glob.cids = tis.cells.cids;
    glob.listCellidx = 1:glob.cellNum;
    glob.typeID = 0;
    glob.subTypeID = 0;

    glob.g.idx = [];
    glob.start = 1;

    
    glob.highlight.idx = 1;
    glob.highlight.cid = tis.cids(1);
    glob.highlight.on = 0;
    
    glob.colorOptions = {'rand','rainbow','red','green','blue','yellow','magenta','cyan',...
    'white','grey'};


    glob.data.path.pts = [];
    glob.data.path.pos = [];
    glob.data.path.lengths = [];

    %% Groups
    glob.defaultG.idx = [];
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
    
    glob.syn.g.synType = 'all';
    glob.syn.g.synIdx = [];
    glob.syn.g.name = 'starter';
    glob.syn.g.p = [];
    glob.syn.defaultG =  glob.syn.g;
    
    %% Functions
    
    %% Connections
    glob.con.isPre = [];
    glob.con.isPost = [];
    
    %% Other Objects (ref)
    
    glob.param.ref = zeros(100);
    
    %% NautilusCNV
    glob.NA.exportName = 'exportName';



    