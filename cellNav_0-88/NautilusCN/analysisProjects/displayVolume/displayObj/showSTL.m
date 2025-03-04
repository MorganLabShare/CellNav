function[] = showSTL(viewProps,objDir)
%%
cellId = viewProps.cellId;
obI = viewProps.obI;
dsObj = viewProps.dsObj;
col = viewProps.col;
dim = viewProps.dim;
fsize = ceil(viewProps.fsize);
viewWindow = viewProps.viewWindow;

resamp = [];
if isfield(viewProps,'resamp')
    resamp = viewProps.resamp;
    viewWindow = viewWindow .* [resamp;resamp];
end

rotDim = 2;

if dim == 1
    dims = [3 2];
elseif dim == 2
    dims = [3 1];
elseif dim == 3
    dims = [1 2];
end
changeDim = dims(rotDim);

viewSize = viewWindow(2,:) - viewWindow(1,:);
center = viewSize/2;
maxDist = sqrt(center(changeDim).^2 + center(dim).^2);
fsize = ceil(viewSize);
shiftRotDim = maxDist - fsize(changeDim)/2;
fsize(changeDim) = ceil(maxDist*2);
center(changeDim) = center(changeDim)+shiftRotDim;

% anchorScale = [.0184 0.016 0.030];
% voxelScale = [anchorScale(1) * 8  anchorScale(2) * 8  anchorScale(3) * 4];
% subScale = voxelScale/max(voxelScale(:));


if ~isfield(viewProps,'degRot')
    degRot = 0;
else
    degRot = viewProps.degRot;
end

if ~isfield(viewProps,'minInt')
    minInt = 20;
else
    minInt = viewProps.minInt;
end

mask = [];
if isfield(viewProps,'mask')
    mask = viewProps.mask;
    
    mask(:,1) = mask(:,1) - viewWindow(1,1)+1;
    mask(:,2) = mask(:,2) - viewWindow(1,2)+1;
    mask(:,3) = mask(:,3) - viewWindow(1,3)+1;
    
    if isfield(viewProps,'useMask')
        useMask = viewProps.useMask;
    else
        useMask = ones(length(viewProps.cellId),1);
    end
else
    useMask = zeros(length(viewProps.cellId),1);
end

if ~isfield(viewProps,'contrastFactor')
    contrastFactor = 5;
else
    contrastFactor = viewProps.contrastFactor;
end

if isfield(viewProps,'sumScaleFactor')
    sumScaleFactor = viewProps.sumScaleFactor;
else
    sumScaleFactor = 1; %3
end

if isfield(viewProps,'maxScaleFactor')
    maxScaleFactor = viewProps.maxScaleFactor;
else
    maxScaleFactor = .3;
end

if viewProps.viewWindow == 0;
    viewWindow = [1 1 1; fsize];
end


%%
%fsize = [1700 1700 1300];


if isempty(cellId)
    uCellId = 1:length(dsObj);
    
else
    uCellId = cellId;
end

if length(uCellId) ~= size(col,1)
    disp('Bad color size')
    %     colMap = hsv(256);
    %     col = colMap(ceil((1:length(uCellId))*256/length(uCellId)),:);
    %     col = col(randperm(size(col,1)),:);
end


%%
for i = 1:length(uCellId)
    
    obName = uCellId{i};
    downSamp = 2;
    if strcmp(class(obName),'char')
    fileNameOBJ = sprintf('%s%s_%08.0f.obj',objDir,obName,i);
    else
            fileNameOBJ = sprintf('%s%d_%08.0f.obj',objDir,obName,i);
    end
    if ~exist(fileNameOBJ,'file')
        
        
        sub = []; dSub = [];
        I = zeros(fsize(dims));
        newHeight = I;
        maxHeight = I;
        Ic = cat(3,I,I,I);
        IcSum = Ic;
        
        if isfield(viewProps,'obIDs')
            obTarg = viewProps.obIDs(i);
            
        elseif strcmp(class(uCellId),'cell')
            term = uCellId{i};
            if strcmp(class(term),'char')
                isTerm = zeros(length(obI.nameProps.names),1);
                for n = 1:length(obI.nameProps.names)
                    isTerm(n) = sum(regexp(lower(obI.nameProps.names{n}),lower(term)));
                end
                obTarg = find(isTerm);
            else
                targ = find(obI.cell.name==term);
                if isempty(targ)
                    obTarg = [];
                    disp(sprintf('Could not find %d',term))
                else
                    obTarg = obI.cell.obIDs{targ};
                end
            end
        else
            obTarg = uCellId(i);
        end
        
        
        allSub = [];
        for o = 1:length(obTarg)
            if obTarg(o)<=length(dsObj)
                sub = double(dsObj(obTarg(o)).subs);
                
                if isfield(viewProps,'resamp')
                    sub = scaleSubsUnique(sub,resamp);
                end
                
                if ~isempty(sub)
                    
                    
                    if 0 %%Apply window
                        useSub = (sub(:,1)>=viewWindow(1,1)) & (sub(:,1)<=viewWindow(2,1)) & (sub(:,2)>=viewWindow(1,2)) & (sub(:,2)<=viewWindow(2,2)) & (sub(:,3)>=viewWindow(1,3)) & (sub(:,3)<=viewWindow(2,3));
                        sub = sub(useSub,:);
                        sub(:,1) = sub(:,1) - viewWindow(1,1)+1;
                        sub(:,2) = sub(:,2) - viewWindow(1,2)+1;
                        sub(:,3) = sub(:,3) - viewWindow(1,3)+1;
                    end
                    
                    if 0 % useMask(i)>1
                        %%Apply mask
                        maskInd = sub2ind(fsize,mask(:,1),mask(:,2),mask(:,3));
                        subInd = sub2ind(fsize,sub(:,1),sub(:,2),sub(:,3));
                        [sameInd idxA idxB] = intersect(subInd,maskInd);
                        sub = sub(idxA,:);
                    end
                    
                    
                    sub(:,changeDim) = sub(:,changeDim) + shiftRotDim;
                    
                    if 0
                        %%rotate
                        otherDim = setdiff([1 2 3],dims);
                        oldSub = sub;
                        %                 center = [viewWindow(2,dims(2)) - viewWindow(1,dims(2)) ...
                        %                     viewWindow(2,otherDim) - viewWindow(1,otherDim)]/2;
                        
                        dif1  = oldSub(:,dims(rotDim)) - center(dims(rotDim));
                        dif2 = oldSub(:,otherDim) - center(otherDim);
                        dists = sqrt(dif1.^2 + dif2.^2);
                        
                        rads = atan2(dif1,dif2);
                        %rads(isnan(rads)) = 0;
                        rads = rads - (pi/180)*degRot;
                        
                        new2 = cos(rads) .* dists;
                        new1 = sin(rads) .* dists;
                        
                        %                     new2 = sin(rads) .* dists;
                        %                     new1 = cos(rads) .* dists;
                        
                        sub(:,dims(rotDim)) = new1+center(dims(rotDim));
                        sub(:,otherDim) = new2 + center(otherDim);
                    end
                    
                    
                    if 0 %perspective
                        
                        %%add perspective
                        distTo = 1;
                        windowSize = (viewWindow(2,:) - viewWindow(1,:));
                        reCenter = windowSize/2;
                        
                        sub1 = sub(:,dims(1))-reCenter(dims(1));
                        sub2 = sub(:,dims(2))-reCenter(dims(2));
                        
                        
                        zDepth = windowSize(dim) -(sub(:,dim)); %distance to from front
                        s2 = atan2(reCenter(dim(1)),windowSize(dim)*distTo); %angle to top at distance
                        bigF = tan(s2).*(windowSize(dim)*distTo + zDepth); % size of field at angle
                        
                        smallF = tan(s2).*(windowSize(dim)*distTo);
                        zScale = smallF./bigF ;
                        sub(:,dims(1)) = sub1.* zScale + reCenter(dims(1));
                        sub(:,dims(2)) = sub2.* zScale + reCenter(dims(2));
                        
                        sub = round(sub);
                    end
                    
                    
                    for c = 1:3
                        badSub = sub(:,c)<1;
                        sub(badSub,c) = 1;
                        badSub = sub(:,c)>fsize(c);
                        sub(badSub,c) = fsize(c);
                    end
                    sub = round(sub);
                    
                    
                    if 0 % make max image
                        inds = sub2ind(fsize(dims),sub(:,dims(1)),sub(:,dims(2)));
                        uinds = unique((inds));
                        
                        if length(uinds)>1
                            hinds = hist(inds,uinds);
                        else
                            hinds = length(inds);
                        end
                        
                        try I(uinds) = I(uinds) + hinds';
                        catch err
                            'something went horribly wrong. -stereo cells and more 234'
                        end
                        newHeight(inds) = max(newHeight(inds),sub(:,dim));
                        
                    else
                        
                        
                        
                    end
                    
                end
                
            end
            
            allSub = [allSub;sub];
        end
        
        if 0 %% Cell image
            I = I * contrastFactor;
            I((I>0)) = I(I>0) + minInt;
            %I(I>255) = 255;
            I((I>0) & (I<minInt)) = minInt;
            
            
            useI = newHeight>maxHeight;
            maxHeight(useI) = newHeight(useI);
            
            for c = 1:3
                Itemp = Ic(:,:,c);
                Itemp(useI) = I(useI)*col(i,c);
                Ic(:,:,c) = Itemp;
            end
            
            IcSum(:,:,1) = IcSum(:,:,1) + I*col(i,1);
            IcSum(:,:,2) = IcSum(:,:,2) + I*col(i,2);
            IcSum(:,:,3) = IcSum(:,:,3) + I*col(i,3);
            
            
            image(uint8(IcSum)*3),    pause(.01)
            I = I * 0;
        end
        
        
        %%%%%%%% render vertex
        if ~isempty(allSub)
            renderOb = 0;
            tic
            
            
            if 1
                dSub = dilateSubs(allSub);
            end
            smallSub = shrinkSub(dSub,downSamp);
            
            useSub = smallSub;
            fv = subVolFV(useSub,[],renderOb);
            
            
            
            %fileNameSTL = sprintf('%sdSamp%d_%d.stl',objDir,downSamp,obName);
            %STLWRITE(FILE, FACES, VERTICES)
            %stlwrite(fileNameSTL,fv.faces,fv.vertices);
            
            %obLabel = sprintf('object%d',uCellId{i});
            %obLabel = uCellId{i};

                obLabel = sprintf('%s_%08.0f',labelOb(uCellId{i},obI),i);
           
            try vertface2objmtl(fv.vertices,fv.faces,fileNameOBJ,obLabel,col(i,:));
            catch err
                err
            end
            toc
            pause(.01)
        end
        
    end
end
% 
% 
% I_topSum = Ic * maxScaleFactor + IcSum * sumScaleFactor;
% image(uint8(I_topSum))
% %Ic = uint8(Ic);
% imwrite(uint8(I_topSum),[objDir 'refImage.png'])



