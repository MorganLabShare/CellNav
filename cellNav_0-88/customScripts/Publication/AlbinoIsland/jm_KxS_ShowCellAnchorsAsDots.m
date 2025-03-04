%%Display three groups of TCRS and their synapses

global glob tis
app = glob.app;

%% Set defined camera position
glob.ax.CameraTargetMode = 'manual';
glob.ax.CameraViewAngleMode = 'manual';
glob.ax.CameraTargetMode = 'manual';
%view(glob.ax,115,-30)
camproj(glob.ax,'orthographic')
lightangle(glob.light,64,-43)
glob.ax.CameraPosition = [1.0269    0.8514   -0.8505]*1000;
glob.ax.CameraTarget = [ 163.5891  161.0452   46.5029];
glob.ax.CameraViewAngle = 6;

%% Define groups
if isfield(glob,'g')
    L = length(glob.g);
else
    L = 0;
end

g1 = [1001  1003 1004 1006 1016  1015 ]; %red
g2 = [1002 1005 1007 1008 1011 1013 1014 1009 1019]; % blue
g3 = [1017];

refCids = [g1 g2 g3];



rCol = zeros(length(refCids),3)+.2;
rAlph = .6; % cells

rsCol = zeros(length(refCids),3);
for i = 1:length(g1)
    targ = find(refCids==g1(i));
    rCol(targ,:) = [0 1 0];
end
for i = 1:length(g2)
    targ = find(refCids==g2(i));
    rCol(targ,:) = [1 0 1];
end

for i = 1:length(g3)
    targ = find(refCids==g3(i));
    rCol(targ,:) = [1 1 1];
end

idx = refCids * 0;
for i = 1 : length(refCids)
    targ = find(tis.cids==refCids(i),1);
    if ~isempty(targ)
        idx(i) = targ;
    end
end

%% Find anchors
centUm = zeros(length(refCids),3);
for i = 1:length(refCids)
    targ = find(tis.cids==refCids(i));
    anch = double(tis.cells.anchors(targ,:));
    centUm(i,:) = anch .* tis.obI.em.res([2 1 3]) / 1000;
end


%% Make synapse groups
G = length(glob.syn.g) + 1;
glob.syn.g(G) = glob.syn.defaultG;
glob.syn.g(G).pos = centUm;
glob.syn.g(G).col = [ 0 0 1];
glob.syn.g(G).markerSize = 150;
drawSyn(glob.app)








