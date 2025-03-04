

%% on bcs
global glob tis
app = glob.app;



view(glob.ax,0,270)

% on patch
all_cids = [1003 1004 1006 1013 1025 1027 1034 1037 1040 1048 1050 1054 1063 1072 1090 1104 1117 1118 1125];
group1_cids  = [1003 1006 1027 1050 1072 1090 1118];
group2_cids  = [1004 1025 1040 1048 1104 1125 ];
group3_cids  = [1013 1034 1037 1054 1063 1117];


for c = 1:length(all_cids)
    cid = all_cids(c);
    fileName = sprintf('%s%d.mat',glob.useFvDir,cid);
    fv = loadFV(fileName);
    
    cMap = [1 0 1; 1 1 0;0 1 1];
    if ismember(cid, group1_cids)
        gc = 1;
    elseif ismember(cid, group2_cids)
        gc = 2;
    elseif ismember(cid, group3_cids)
        gc = 3;
    else
        gc = 0; % Not in any group
    end
    newG = length(glob.g)+1;
    idx = find(tis.cids==cid);
    if gc > 0
        fvc = repmat(cMap(gc, :), size(fv.vertices, 1), 1);
    else
        fvc = repmat([0, 0, 0], size(fv.vertices, 1), 1); % Default to black if not in any group
    end    
    %% make new group
    glob.g(newG) = glob.defaultG;
    glob.g(newG).idx = idx;
    glob.g(newG).cid = cid;
    glob.g(newG).col = [1 1 1];
    glob.g(newG).alph = 1.0;
    glob.g(newG).show = 1;
    glob.g(newG).name = sprintf('group %d',cid);


    %% Show groups
    showCellGroup(app, newG)
    updateGroups(app)
    %edit2_function(app)

    pIdx =  glob.g(newG(1)).patch;
    set(pIdx,"FaceVertexCData",fvc)
    set(pIdx,"FaceColor",'interp')
    set(pIdx,"EdgeColor",'none')

end





%% off bcs

global glob tis
app = glob.app;



view(glob.ax,0,270)

% off  patch
all_cids = [1001 1002 1005 1007 1016 1017 1018 1021 1024 1030 1031 1033 1035 1036 1039 1051 1056 1062 1071 1074 1091 1094 1105 1133 1201 1207 1208  ];
group1_cids  = [ 1001 1005 1017 1024 1030 1039 1105 1133 1207 1056 ];
group2_cids  = [ 1002 1007 1018 1071 1074 1091 1094 1201 ];
group3_cids  = [ 1016 1021 1031 1033 1035  1051   1062 1208 ];
group4_cids = [1036] ;

for c = 1:length(all_cids)
    cid = all_cids(c);
    fileName = sprintf('%s%d.mat',glob.useFvDir,cid);
    fv = loadFV(fileName);
    
    cMap = [1 0 1; 1 1 0;0 1 1;0 0 1];
    if ismember(cid, group1_cids)
        gc = 1;
    elseif ismember(cid, group2_cids)
        gc = 2;
    elseif ismember(cid, group3_cids)
        gc = 3;
    elseif ismember(cid, group4_cids)
        gc = 4;
    else
        gc = 0; % Not in any group
    end
    newG = length(glob.g)+1;
    idx = find(tis.cids==cid);
    if gc > 0
        fvc = repmat(cMap(gc, :), size(fv.vertices, 1), 1);
    else
        fvc = repmat([0, 0, 0], size(fv.vertices, 1), 1); % Default to black if not in any group
    end    
    %% make new group
    glob.g(newG) = glob.defaultG;
    glob.g(newG).idx = idx;
    glob.g(newG).cid = cid;
    glob.g(newG).col = [1 1 1];
    glob.g(newG).alph = 1;
    glob.g(newG).show = 1;
    glob.g(newG).name = sprintf('group %d',cid);


    %% Show groups
    showCellGroup(app, newG)
    updateGroups(app)
    %edit2_function(app)

    pIdx =  glob.g(newG(1)).patch;
    set(pIdx,"FaceVertexCData",fvc)
    set(pIdx,"FaceColor",'interp')
    set(pIdx,"EdgeColor",'none')

end
