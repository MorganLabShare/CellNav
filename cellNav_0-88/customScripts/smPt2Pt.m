function[ptp] = smPt2Pt

global globSM tis


try
    load([globSM.smDir globSM.smFileName])
catch
    disp('failed to load  SM file')
end



%% get all synapse to node distances
d = sm.skel2skel.linDist;

%% Distance to voltage
% http://www.columbia.edu/cu/biology/courses/w3004/Lecture5.pdf
switch globSM.dFunc
    case 'fixed radius length constant'
        resistivity = 2000; %resistivity = resistance of cm^3
        Rm = 2000; %ohms cm^2
        radius = .1; %radius in um
        Vo = 1;
        
        a = radius/10000; %radius in centimeters
        x = d/10000; %distance in centimeters
        ra = resistivity/(pi*a^2); %axial resitance
        rm = Rm/(2*pi*a); %membrane resistance
        lc = sqrt(rm/ra); %length constant = sqrt of membrane resistance/axial resistance
        V = Vo * exp(-x/lc);
        W = V;
    case 'w = 1'
        W = d*0+1;
    otherwise
        eval(sprintf('%s;',globSM.dFunc));
        W = w;
end

%% Get positions
pos = sm.nep.pos;
L = 0;
clear posIN posOUT indIN indOUT nodeIN nodeOUT listIN listOUT
for i = 1:globSM.IN.num
%     if strcmp(globSM.IN.g(i).type,'synGroup')
%         posIN{i} = tis.syn.pos(globSM.IN.g(i).dat.synIdx,:);
%     else
        posIN{i} = globSM.IN.g(i).dat.pos;
%     end
    nL = L+size(posIN{i},1);
    indIN{i} = (L+1):nL;
    distY = pos(:,1)'-posIN{i}(:,1);
    distX = pos(:,2)'-posIN{i}(:,2);
    distZ = pos(:,3)'-posIN{i}(:,3);
    dist = sqrt(distY.^2+distX.^2+distZ.^2);
    [y x] = find(dist== repmat(min(dist,[],2),[1 size(dist,2)]));
    nodeIN{i}(y) = x;
    listIN(indIN{i}) = nodeIN{i};
    L = nL;
end
numIN = L;

L = 0;
for i = 1:globSM.OUT.num
%     if strcmp(globSM.OUT.g(i).type,'synGroup')
%         posOUT{i} = tis.syn.pos(globSM.OUT.g(i).dat.synIdx,:);
%     else
        posOUT{i} = globSM.OUT.g(i).dat.pos;
%     end
    nL = L+size(posOUT{i},1);
    indOUT{i} = (L+1):nL;
    distY = pos(:,1)'-posOUT{i}(:,1);
    distX = pos(:,2)'-posOUT{i}(:,2);
    distZ = pos(:,3)'-posOUT{i}(:,3);
    dist = sqrt(distY.^2+distX.^2+distZ.^2);
    [y x] = find(dist== repmat(min(dist,[],2),[1 size(dist,2)]));
    nodeOUT{i}(y) = x;
    listOUT(indOUT{i}) = nodeOUT{i};
    L = nL;
end
numOUT = L;

%% Build graphs

%%Main point to point graph
con1 = W(listIN,:);
con = con1(:,listOUT);

%%Grouped graphs
conGin = zeros(length(indIN),size(con,2));
for i = 1:length(indIN);
    conGin(i,:) = sum(con(indIN{i},:),1);
end

conGout = zeros(size(con,1),length(indOUT));
for i = 1:length(indOUT);
    conGout(:,i) = sum(con(:,indOUT{i}),2);
    conG(:,i) = sum(conGin(:,indOUT{i}),2);
end

%% Collect variables in structure
ptp.con = con;
ptp.conG = conG;
ptp.conGin = conGin;
ptp.conGout = conGout;
ptp.node2nodeDist = d;
ptp.node2nodeWeight = W;
ptp.nodeIN = nodeIN;
ptp.nodeOUT = nodeOUT;
ptp.indIN = indIN;
ptp.indOUT = indOUT;

















