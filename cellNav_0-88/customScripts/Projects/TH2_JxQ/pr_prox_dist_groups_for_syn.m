
global glob tis
app = glob.app;



view(glob.ax,0,270)


cids = [1 10];


for c = 1:length(cids)
    cid = cids(c);
    fileName = sprintf('%s%d.mat',glob.useFvDir,cid);
    fv = loadFV(fileName);


    fileNameLab = sprintf('%s%d_labels_44.mat',glob.useFvDir,cid);
    data = load(fileNameLab);
    
    fv_1_vertices = data.fv_1_vertices;
    vertLab = fv_1_vertices(:,4);
    vertLab(vertLab==0) = 3;
    cMap = [0 0 0; 1 0 1; 0 0 0];

    newG = length(glob.g)+1;
    idx = find(tis.cids==cid);
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
    set(pIdx,"FaceVertexCData",cMap(vertLab,:))
    set(pIdx,"FaceColor",'interp')
    set(pIdx,"EdgeColor",'none')

end