function[triPoints] = drawTriads(tri,useTri);

smp = 1;
eS = [1 2; 1 3; 2 3];

lineCols = hsv(size(tri.triCell,1))*0+50;
ballCols = hsv(size(tri.triCell,1))*0+200;
lineGroup = {};
lineRad = ones(size(tri.triCell,1),1)* 0.5;
ballRad = ones(size(tri.triCell,1),1)*6;

for tU = 1:length(useTri)
    t = useTri(tU);
    
    cellGroup{t} = tri.triCell(t,:);
    
    gB = [];
    for c = 1:3
        gB = cat(1,gB,tri.synPos{t,c});
    end
    
    gL = [];
    for e = 1:3
        ns1 = tri.synPos{t,eS(e,1)};
        ns2 = tri.synPos{t,eS(e,2)};
        
        
        
        
        for a = 1:size(ns1,1)
            for b = 1:size(ns2,1)
                n1 = ns1(a,:);
                n2 = ns2(b,:);
                
                slp = n2-n1;
                dis = sqrt(sum(slp.^2));
                steps = ceil(dis*smp);
                shift = repmat(slp,[steps 1]) .* repmat([1:steps]'/smp,[1 3])/dis;
                %8885697800
                L = cat(1,n1,n1+shift);
                gL = cat(1,gL,L);
            end
        end
    end
    
    lineGroup{t} = gL;
    ballGroup{t} = gB;
end

triPoints.lineGroup = lineGroup;
triPoints.lineCol = lineCols(useTri,:);
triPoints.ballGroup = ballGroup;
triPoints.ballCol = ballCols(useTri,:);
triPoints.cellGroup = cellGroup;
triPoints.lineRad = lineRad(useTri);
triPoints.ballRad = ballRad(useTri);





















