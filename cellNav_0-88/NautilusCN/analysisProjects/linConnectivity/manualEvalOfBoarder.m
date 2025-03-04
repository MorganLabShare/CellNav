


load('MPN.mat')
if ~exist('MPN','var')
    MPN = GetMyDir;
end

synDir = [MPN 'synPos3\'];
if ~(exist(synDir,'dir')),mkdir(synDir); end

if ~exist('obI','var') | ~exist('dsObj','var')
    disp('loading')
    load([MPN 'obI.mat'])
    load([MPN 'dsObj.mat'])
end


mot = getMotifs(obI);
syn = getSynMat(obI);


%%
colormap gray(256)
from125 = syn.pre==125;
to125 = syn.post==125;
toLIN = syn.postClass == 3;
fromLIN = syn.preClass == 3;

checkListOut = unique(syn.post(from125 & toLIN));
checkListIn = unique(syn.pre(to125 & fromLIN));

checkList = setdiff(checkListIn,checkListOut)

allSub = cat(1,dsObj.subs);

minAll = min(allSub,[],1);
maxAll = max(allSub,[],1);

Ic = zeros(maxAll(1),maxAll(2));
Is = zeros(maxAll(1),maxAll(3));

Iac = Ic;
ind = sub2ind(size(Ic),allSub(:,1),allSub(:,2));
Iac(ind) = 100;

Ias = Is;
ind = sub2ind(size(Is),allSub(:,1),allSub(:,3));
Ias(ind) = 100;


for o = 1:length(checkList)
    
    sprintf('showing cell %d, number %d of %d',checkList(o),o,length(checkList))
    
    targ = find(obI.cell.name == checkList(o));
    
    if length(targ) ~= 1
        sprintf('found %d ids',length(targ));
    else
        ids = obI.cell.obIDs{targ};
        subs = [];
        for i = 1:length(ids)
            sub = dsObj(ids(i)).subs;
            subs = cat(1,subs,sub);
        end
        
        
        
        ind = sub2ind(size(Ic),subs(:,1),subs(:,2));
        Ic = Iac;
        Ic(ind) = 300;
        
        
        
        ind = sub2ind(size(Is),subs(:,1),subs(:,3));
        Is = Ias;
        Is(ind) = 300;
        
        
        
        subplot(1,2,1)
        image(Ic)
        subplot(1,2,2)
        image(Is)
        pause
        
        
    end
    %     maxS = max(subs,[],1);
    %      if isempty(subs)
    %              mins(i,:) = [0 0 0];
    %             maxes(i,:) = [inf inf inf];
%         else        
%          
%         inds = sub2ind(maxS,subs(:,1),subs(:,2),subs(:,3));
%         inds = unique(inds);
%         [y x z] = ind2sub(maxS,inds);
%         subs = [y x z];
%         
%         anc = anchors(o,:);
%         
%         scatter(subs(:,1),subs(:,2),'.')
%         
%         hold on 
%         
%         scatter(anc(1),anc(2),'o')
%         hold off
%        
% 
%             
%            mins(o,:) = min(subs,[],1);
%            maxes(o,:) = max(subs,[],1);
%         end
%    
    
    %     b = hist(dist,[1:100])
    %     bar(b(1:end-1));
    %     ylim([0 50000])
    %     pause
    %     sum(dist<5)
    %
    
end
























