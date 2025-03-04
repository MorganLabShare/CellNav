function  makeObjectLibrary

tic
global glob tis tisDat
% tempFig = figure;
% tempAx = gca(tempFig);

MPN = glob.NA.MPN;
WPN = glob.NA.WPN;

load([MPN 'obI.mat'])
load([MPN 'dsObj.mat'])
%load([WPN 'tis.mat'])

if exist([MPN 'shiftZ.mat']);
    load([MPN 'shiftZ.mat']);
    shouldShiftZ = 1;
else
    shouldShiftZ = 0;
end

flipDim = [1 3 2 ];

downSamp = 1;
renderProps.smooth = 0;
renderProps.resize = 1;
renderProps.smoothPatch = 0;


%% Pick cells
obList = 1:length(dsObj);
col = ones(length(obList),3);
alph = ones(length(obList),1);


%%
fvDir = [WPN 'fvObjects\'];

try
    rmdir(fvDir,'s')
end
mkdir(fvDir)
save([fvDir 'obI.mat'],'obI');

%% Draw cells
for i = 1:length(obList)
    disp(sprintf('running object %d of %d',i,length(obList)))
    sub = dsObj(i).subs;
    fvFilename = sprintf('%s%d.mat',fvDir,i);
    if 1%~exist(fvFilename,'file')
        if ~isempty(sub)



            if exist('crop','var')
                if (fullContext == 0) | (i>1)
                    useSub = ((crop(1,1)<sub(:,1)) & (crop(2,1)>sub(:,1)) & ...
                        (crop(1,2)<sub(:,2)) & (crop(2,2)>sub(:,2)) & ...
                        (crop(1,3)<sub(:,3)) & (crop(2,3)>sub(:,3)));
                    sub = sub(useSub,:);
                end
            end

            if shouldShiftZ %shift each plane
                if strcmp(shiftZ.type, 'translation')
                    shiftY = shiftZ.shifts(sub(:,3),1);
                    shiftX = shiftZ.shifts(sub(:,3),2);
                    sub(:,1) = sub(:,1) + shiftY;
                    sub(:,2) = sub(:,2) + shiftX;
                end
            end

            smallSub = shrinkSub(sub,downSamp);
            smallSub = smallSub(:,flipDim);
        else
            smallSub = [];
        end
        
        if isempty(smallSub)
            fv.vertices = [];
            fv.faces = [];
        else
            fv = subVolFV(smallSub,[],renderProps);
        end
        
        %% Scale
        fv.vertices = fv.vertices * obI.em.dsRes(1);
        save(fvFilename,'fv');
%         cla
%         patch(tempAx,fv)
%         pause(.01)
    end
    
end


disp('Object library time')
toc















