% function[rleDat] = getRLEtoSubs(TPN,miplevel);
%
% %Please connect to VAST with vasttools first!
%
% global vdata;
%
% tic
clear all
vast=VASTControlClass();
res = vast.connect('127.0.0.1',22081,1000)

%TPN = GetMyDir;
writeLowRes = 0;


%

zStep = 16; %100 for mip3, 20 for mip 1
%xyStep = 4096;
xStep = 16*16*16;
yStep = 16*16*16;
miplevel = 0;
checkMip = 4;
checkDown = 2^checkMip;

blockDim = [yStep xStep zStep];



%% Get seg data
%if ~exist([SPN 'colData.mat'], 'file')
[nr, res] = vast.getnumberofsegments();
colData = vast.getallsegmentdata;
names = vast.getallsegmentnames;
for s = 1 : length(names)
    colData{s}.name = names{s};
end
%save([TPN 'colData.mat'],'colData');

%% Get bounding box
bBox = zeros(nr-1,6);
for i = 1:nr-1
    %data = vast.getsegmentdata(i);
    %bBox(i,:) = double(data.boundingbox);
    bBox(i,:) = colData{i}.boundingbox;
end
max(bBox,[],1);
useBox = sum(bBox>=0,2)==6;
allBBox = [min(bBox(useBox,1:3),[],1)'  max(bBox(useBox,4:6),[],1)']+1;
allBBox2 = allBBox/checkDown;
allBBox2(:,1) = fix(allBBox2(:,1));
allBBox2(:,2) = ceil(allBBox2(:,2));


%% 
eCount = 0; %number of errors
ePos = []; %position of errors

info=vast.getinfo();
segNum = vast.getnumberofsegments
segData = vast.getallsegmentdata;
%segNames = vast.getallsegmentnames


minx=0; miny=0; minz=0;
maxx=double(bitshift(info.datasizex,-miplevel));
maxy=double(bitshift(info.datasizey,-miplevel));
%same as: maxy=floor(info.datasizey/2^miplevel);
maxz=double(info.datasizez);
vSize = [maxy-miny+1 maxx-minx+1 maxz-minz+1];
surfonlyflag=0;


datSize = [maxx; maxy; maxz];
zSteps = 1:zStep:maxz;
xSteps = 1:xStep:maxx;
ySteps = 1:yStep:maxy;

% zSteps = 687:zStep:687+200;
% xSteps = 36673:xStep:36673 + 10000;
% ySteps = 26090:yStep:26090 + 10000;

startTime = clock

i = 0;
numBlocks = length(zSteps) * length(ySteps) ;
countYvox = 0;
countYseg = 0;
startYtime = tic;

for z = 1:length(zSteps);
    disp(sprintf('fetching sections %d-%d of %d',zSteps(z),zSteps(z)+zStep-1,maxz))
    for y = 1:length(ySteps);
        yDur = toc(startYtime);
        disp(sprintf('%0.2f Mseg at %.2f Mvox/sec, %.2f Mseg/sec',countYseg,countYvox/yDur,...
            countYseg/yDur))
        startYtime = tic;
        countYvox = 0;
        countYseg = 0;

        for x = 1:length(xSteps);
            
            if ~mod(y,100)
                disp(sprintf('running %d of %d',y,length(ySteps)))
            end
            
            
            %%Get region
            getReg = [max(xSteps(x)-1,allBBox(1,1)) min(xSteps(x)+xStep -2,allBBox(1,2));
                max(ySteps(y)-1, allBBox(2,1)) min(ySteps(y)+yStep -2,allBBox(2,2));
                max(zSteps(z)-1, allBBox(3,1)) min(zSteps(z)+zStep -2,allBBox(3,2))];
            regSize = getReg(:,2)-getReg(:,1) + 1;
            if sum(regSize>0)==3 %if in seg bounding box
                
            Iv = zeros(regSize(1),regSize(2),regSize(3),'uint16');
            countYvox = countYvox + prod(regSize)/1000000;
            
            %%Test for data
            tic
            %disp('low res check')
            getReg2 = getReg;
            datSize2 = allBBox;
            datSize2(1:2) = datSize2(1:2)/(2^checkMip);
            datSize2 = round(datSize);
            getReg2(1:2,1:2) = round(getReg2(1:2,1:2)/2^checkMip);
            getReg2(1:2,1) = getReg2(1:2,1) ;
            getReg2(1:2,2) = getReg2(1:2,2) ;
            getReg2(getReg2(:,1)<0,1) = 0;
            getReg2(getReg2(:,2)>datSize2,2) = datSize2(getReg2(:,2)>datSize2);
            regSize2 = getReg2(:,2)-getReg2(:,1) + 1;
            Iv2 =  zeros(regSize2(1),regSize2(2),regSize2(3),'uint16');
            [rleimg2, res]=vast.getsegimageRLE(checkMip,...
                getReg2(1,1),getReg2(1,2), getReg2(2,1),getReg2(2,2),...
                getReg2(3,1),getReg2(3,2),surfonlyflag);
            clear lowTiles highTiles
            if 1%writeLowRes
                lastX = 0;
                oIDs = double(rleimg2(1:2:end));
                rls = double(rleimg2(2:2:end));
                for r = 1:length(rls)
                    runID = lastX+1:lastX+rls(r);
                    
                    if oIDs(r)>0
                        Iv2(runID) = oIDs(r);
                        countYseg = countYseg/length(runID)/1000000;
                    end
                    lastX = lastX + rls(r);
                end
                
                %%write 2D images
                    iSums = squeeze(sum(sum(Iv2)));
                    writeIs = find(iSums);
                    if 1
  
                    for zi = 1:length(writeIs)
                        
                        writeI = uint16(writeIs(zi));
                        
                        imName = sprintf('tileLowRes_r%d_c%d_s%d.png',x,y,...
                            getReg(3,1)-1 + writeI);
                        tile = Iv2(:,:,writeI);
%                         tile = flipud(tile);
%                         tile = fliplr(tile);
                        tile = tile * 1000;
                        lowTiles{zi} = tile;
                        %imwrite(tile,[TPN2 imName])
                    end
                end
            end
            %toc
            
            %%Get full resolution
            if sum(iSums) %if low res found something
                [rleimg, res]=vast.getsegimageRLE(miplevel,...
                    getReg(1,1),getReg(1,2), getReg(2,1),getReg(2,2),...
                    getReg(3,1),getReg(3,2),surfonlyflag);
                
                %%write run length into 3D image
                lastX = 0;
                oIDs = double(rleimg(1:2:end));
                rls = double(rleimg(2:2:end));
                for r = 1:length(rls)
                    runID = lastX+1:lastX+rls(r);
                    
                    if oIDs(r)>0
                        Iv(runID) = oIDs(r);
                    end
                    lastX = lastX + rls(r);
                end
                
                %%write 2D images
                iSums = squeeze(sum(sum(Iv)));
                writeIs = find(iSums);
                for zi = 1:length(writeIs)
                    writeI = uint16(writeIs(zi));
                    tile = Iv(:,:,writeI);
                    tile = tile';
%                     tile = flipud(tile);
%                     tile = fliplr(tile);
%                     tile = tile * 1000;
%                     return
                    imName = sprintf('tile_r%d_c%d_s%d.png',y,x,...
                        getReg(3,1)-1 + writeI);
                    highTiles{zi} = tile;
                    %imwrite(tile,[TPN imName])
                end
                
                
            end %if low res found something
            else % if in seg range
                %disp('no segmentation within fetch range')
            end
            
            
            %% Compare lowTiles to highTiles
            if exist('highTiles','var')
                
                compLow = zeros(256);
                compHigh = zeros(256);
                for zi = 1:length(highTiles)
                    
                   highTile = highTiles{zi};
                   lowTile = lowTiles{zi};
                   
                   dSamp = 2^miplevel/2^checkMip;
                   dsHighTile = imresize(highTile,dSamp,'nearest');
                   
                   %compLow(1:size(lowTile,1),1:size(lowTile,2)) = 1;
                   lowTile = lowTile';
                   compLow(1:min(size(lowTile,1),256),1:min(size(lowTile,2),256))= ...
                       lowTile(1:min(size(lowTile,1),256),1:min(size(lowTile,2),256));%(1:size(lowTile,1),1:size(lowTile,2)) = 1;
                   compHigh(1:size(dsHighTile,1),1:size(dsHighTile,2)) = dsHighTile;
    
%                    SE = strel('disk',[3,3]);
%                    diHigh = imdilate(compHigh,SE);
                   
                   
                   diHigh = imresize(compHigh,.5,'bilinear');
                   diHigh = diHigh>0;
                   diHigh = imresize(diHigh,2,'bilinear');
                   diHigh = diHigh>0;
                   
                   diLow = imresize(compLow,.5,'bilinear');
                   diLow = diLow>0;
                   diLow = imresize(diLow,2,'bilinear');
                   diLow = diLow>0;
                   
                   
                   colI = zeros(256,256,3,'uint8');
                   colI(:,:,1) = compLow*100000;
                   colI(:,:,2) = compHigh *1000000;
                   %% colI(:,:,3) = diLow * 10000;
                   image(colI),pause(.1)

                 misLow = find((compHigh>0) & (diLow==0));
                misHigh = find(compLow & (diHigh==0));
    
                %% report
                if (~isempty(misLow) | ~isempty(misHigh))
                    
                    eCount = eCount+1;
                    ePos(eCount,:) = round(mean(getReg,2));
                    
                end
                
                   
                   
                    
                end
                
                
            end
            
            
        end
    end
end
% 
% 
% 
% 
% 
% 
% 
% 
% 
%  %             %%Get whole image
%                 %             tic
%                 %             [img, res]=vast.getsegimageraw(miplevel,...
%                 %                 getReg(1,1),getReg(1,2), getReg(2,1),getReg(2,2),...
%                 %                 getReg(3,1),getReg(3,2));
%                 %             Iv(:) = img;
%                 %             toc
