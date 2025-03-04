function[triPoints] = drawTriads(tri,useTri);

smp = 1;
eS = [1 2; 1 3; 2 3];

lineCols = repmat([1 1 .5],[size(tri.triCell,1) 1]) * 100;
ballCols = repmat([0 1 1],[size(tri.triCell,1) 1]) * 160;
lineGroup = {};
lineRad = ones(size(tri.triCell,1),1)* 2;
ballRad = ones(size(tri.triCell,1),1)*8;

for tU = 1:length(useTri)
    t = useTri(tU);
    
    cG = tri.triCell(t,:);
    cellGroup(tU,:) = cG;
    
    
    
    gB = [];
    for c = 1:3
        gB = cat(1,gB,tri.synPos{t,c});
    end
    
    
    
    gL = [];
    S12 = tri.synPos{t,1};
    S13 = tri.synPos{t,2};
    S23 = tri.synPos{t,3};
    clear tC
    for d = 1:size(S12,1)
        
        pos1 = S12(d,:);
        dists = sqrt((S13(:,1)-S12(d,1)).^2 + ...
            (S13(:,2)-S12(d,2)).^2 + (S13(:,3)-S12(d,3)).^2);
        dist2 = min(dists);
        pos2 = S13(find(dists==min(dists),1),:);
        
        dists = sqrt((S23(:,1)-S12(d,1)).^2 + ...
            (S23(:,2)-S12(d,2)).^2 + (S23(:,3)-S12(d,3)).^2);
        dist3 = min(dists);
        pos3 = S23(find(dists==min(dists),1),:);
        
        tC = [pos1; pos2; pos3];
        tD = [dist2; dist3];
        
        for e = 1:3
            ns1 = tC(eS(e,1),:);
            ns2 = tC(eS(e,2),:);
            
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
        
        triClose(:,:,d) = tC;
        triDist(:,:,d) = tD;
    end
    
    
    
    
    %     gL = [];
    %     for e = 1:3
    %         ns1 = tri.synPos{t,eS(e,1)};
    %         ns2 = tri.synPos{t,eS(e,2)};
    %
    %         for a = 1:size(ns1,1)
    %             for b = 1:size(ns2,1)
    %                 n1 = ns1(a,:);
    %                 n2 = ns2(b,:);
    %
    %                 slp = n2-n1;
    %                 dis = sqrt(sum(slp.^2));
    %                 steps = ceil(dis*smp);
    %                 shift = repmat(slp,[steps 1]) .* repmat([1:steps]'/smp,[1 3])/dis;
    %                 %8885697800
    %                 L = cat(1,n1,n1+shift);
    %                 gL = cat(1,gL,L);
    %             end
    %         end
    %     end
    
    lineGroup{tU} = gL;
    ballGroup{tU} = gB;
    closest{tU} = triClose;
    triDists{tU} = triDist;
end

triPoints.lineGroup = lineGroup;
triPoints.lineCol = lineCols(useTri,:);
triPoints.ballGroup = ballGroup;
triPoints.ballCol = ballCols(useTri,:);
triPoints.cellGroup = cellGroup;
triPoints.lineRad = lineRad(useTri);
triPoints.ballRad = ballRad(useTri);
triPoints.closest = closest;
triPoints.triDists = triDists;





















