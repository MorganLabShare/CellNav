%%Display three groups of TCRS and their synapses

global glob tis
app = glob.app;

showGroup = [1 2 3]; %pick group to show

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

g1 = []; g2 = []; g3 = [];
if sum(showGroup==1)
g1 = [1001  1003 1004 1006 1016  1015 ]; %red
end
if sum(showGroup==2)
g2 = [1002 1005 1007 1008 1011 1013 1014 1009 1019]; % blue
end
if sum(showGroup==3)
g3 = [1017];
end

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

useRef = find(idx>0);
newG = [1:length(useRef)] + L;
cellGids = zeros(length(useRef),2);
for i = 1:length(useRef)

    %% make new group
    rID = useRef(i);
    glob.g(newG(i)) = glob.defaultG;
    glob.g(newG(i)).idx = idx(rID);
    glob.g(newG(i)).cid = tis.cids(idx(rID));
    glob.g(newG(i)).col = rCol(rID,:);
    glob.g(newG(i)).alph = rAlph;
    glob.g(newG(i)).show = 1;
    glob.g(newG(i)).name = sprintf('g%d - c%s',L, num2str(glob.g(L+i).cid));
    cellGids(i,:) = [tis.cids(idx(rID)) newG(i)];
end


%% Show groups
showCellGroup(app, newG)
updateGroups(app)
%edit2_function(app)









