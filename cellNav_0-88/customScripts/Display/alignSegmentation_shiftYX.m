function[] = alignSegmentation_shiftYX()
%%Find translations for improving alignment 
%%between each plane of segmentations stored as dsObj

fig = figure; %Make temporary figure

clear zHas zCents shifted shifts

global tis glob
if 1
load('MPN.mat')  %Get volume directory
load([MPN '\dsObj.mat']) %load o x n x 3 list of object subs
end

subsMax = max(cat(1,dsObj.subs),[],1); %Get max of subs
subsMin = min(cat(1,dsObj.subs),[],1); %Get min of subs

%%Make list of which objects are in each plane = zHas
% 
% numZ = 480;
% for i = 1:numZ
%     zCents{i} = [];
% end
zCents{1} = []; % Make array to store object centers in

numObs = length(dsObj); %Find the total number of objets
mins = [inf inf inf]; % Make matrix for tracking miniums
maxes = [0 0 0]; % make matrix for tracking maxes
for i = 1:numObs %Start running objects
    subs = double(dsObj(i).subs); %Get subs for each object
    if ~isempty(subs) %if there are subs
        mins = min(mins,min(subs,[],1)); % find mins of object
        maxes = max(maxes,max(subs,[],1)); % find maxes of object
        zs = unique(subs(:,3)); %Make list of all planes that object is in
        for z = 1:length(zs) %Step through list of planes
            zSub = subs(subs(:,3)==zs(z),[1 2]); %Get subs for current plane
            mid = median(zSub,1); %Find median position of subs in current plane
            if zs(z)>length(zCents) % if current plane is larger then the size of the zCents array, add new position to the array
                zCents{zs(z)} = [];
            end
            zCents{zs(z)} = cat(1,zCents{zs(z)},[i mid]); % Add new center point to the plane that records [object id, y, x]
        end
    end
end

numZ = length(zCents); % count the number of planes spanned by objects

%% Find shifts
shifts = zeros(numZ,2); % Create matrix for recording final shifts
clear shifted
if ~isempty(zCents{1}) %if the first plane has a shift record 
    shifted{1} = zCents{1}(2:3); % record shift in shifted matrix
else
    shifted{1} = [];
end

for z = 2:length(zCents);    %Run through all sections using z to and compairng to z-1
    p1 = zCents{z-1}; %Get previous list of centers (z-1)
    p2 = zCents{z}; %Get list of centers for current plane
    if isempty(p2) %if current plane has no centers (objects)
        shifted{z} = []; %enter blank for record of points that have been moved
    else
        shifted{z} = zCents{z}(:,2:3); %enter unshifted points in record of shifted points
    end
    if ~isempty(p1) & ~isempty(~p2) % If points exist in both planes
        inBoth = intersect(p1(:,1),p2(:,1)); % Find objects common to both planes 
        if ~isempty(inBoth) %if the same objects are in both planes
            y1 = zeros(length(inBoth),1); %Create x and y vectors for centers of in both planes
            y2 = y1; x1 = y1; x2 = y1;
            for p = 1:length(inBoth) % Run each common object separately
                t1 = find(p1(:,1)==inBoth(p)); % Get 
                t2 = find(p2(:,1)==inBoth(p));
                y1(p,1) = p1(t1,2);
                y2(p,1) = p2(t2,2);
                x1(p,1) = p1(t1,3);
                x2(p,1) = p2(t2,3);
            end
            shiftY = median(y1-y2);
            shiftX = median(x1-x2);
            shifts(z,:) = shifts(z-1,:) + [shiftY shiftX];
            shifted{z} = p2(:,2:3) + shifts(z,:);
        end
    end
end

%% Propogate shifts
oldP = [];
newP = [];
for z = 1:length(zCents)
    if ~isempty(zCents{z})
    oldP = cat(1,oldP,[zCents{z}(:,2:3) ones(size(zCents{z},1),1) * z]);
    newP = cat(1,newP,[shifted{z} ones(size(shifted{z},1),1) * z]);
    end
end

%% Make minimum shift 0
minShift = min(0,min(shifts,[],1));
shifts = shifts - repmat(minShift,[size(shifts,1) 1]);



clf
subplot(2,1,1)
scatter3(oldP(:,1),oldP(:,2),oldP(:,3),10,'MarkerFaceColor',[0 0 0],'MarkerFaceAlpha',.1,'MarkerEdgeColor','none');
view(-90,0)
subplot(2,1,2)
scatter3(newP(:,1),newP(:,2),newP(:,3),10,'MarkerFaceColor',[0 0 0],'MarkerFaceAlpha',.1,'MarkerEdgeColor','none');
view(-90,0)

shiftZ.type = 'translation';
shiftZ.shifts = shifts;
save([MPN 'shiftZ.mat'],'shiftZ');







