


fileType = 'png';
SPN = 'G:\IxQ\Matlab\Exports\physVolMip4\'
dSPN = dir([SPN '*' fileType]);
inams = {dSPN.name};

zs = length(inams);
info = imfinfo([SPN inams{1}]);
ys = info.Height;
xs = info.Width;

minVal = 10;
bboxEmpty = [ys 1;xs 1; zs 1]; %reverse bounding box
%I = zeros(ys,xs,zs);
colormap jet(256)
clear secCut secBox
for i = 1:length(dSPN)
    i
    Ir = imread([SPN inams{i}]);
        
        [y x] = find(Ir>minVal);
        if ~isempty(y)
        bbox = [min(y) max(y); min(x) max(x); i i];
        secCut{i} = Ir(bbox(1,1):bbox(1,2),bbox(2,1):bbox(2,2));
        secBox(:,:,i) = bbox;
        else
            secCut{i} = [];
            secBox(:,:,i) = bboxEmpty;
        end
    
    
end

%% one volume
bboxFull = cat(2,min(secBox(:,1,:),[],3),max(secBox(:,2,:),[],3));
vs = bboxFull(:,2)-bboxFull(:,1)+1;
vol = zeros(vs(1),vs(2),vs(3));
for i = 1:length(secCut);
    i
    if ~isempty(secCut{i});
        bbox = secBox(:,:,i);
        bbox = bbox-repmat(bboxFull(:,1),[1 2])+1;
        I = secCut{i};
%        image(I);
%         pause(.01);
        vol(bbox(1,1):bbox(1,2),bbox(2,1):bbox(2,2),bbox(3,1):bbox(3,2)) = I;
    end
end


%%  volshow labelvolshow
%% try capturing and transfering window output
lin = [0:255]'/255;
cmap = cat(2,lin*0, lin, lin*0);
config.BackgroundColor = [0 0 0];
config.Colormap = cmap;
config.Renderer = 'MaximumIntensityProjection';
%volshow(vol,'BackgroundColor',[0 0 0],'colormap',cmap)
hVol = volshow(vol,config)
setVolume(hVol,vol)
 
%%

%fv = (vol,10);




