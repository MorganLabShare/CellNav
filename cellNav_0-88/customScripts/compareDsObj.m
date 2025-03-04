

spn1 = 'C:\Data\CellNavCode\cellNav_0.61\Volumes\checkVol_2020+10+14\Merge\ixQ_scm_noah_2020+10+14';

spn2 = 'C:\Data\CellNavCode\cellNav_0.61\Volumes\checkVol_2020+10+19\Merge\ixQ_scm_noah_2020+10+19';

load([spn1 '\vastSubs.mat']);
vastSubs1 = vastSubs;
load([spn1 '\obI.mat'])
obI1 = obI;
names1 = cat(1,obI1.nameProps.names);



load([spn2 '\vastSubs.mat']);
vastSubs2 = vastSubs;
load([spn2 '\obI.mat'])
obI2 = obI;
names2 = cat(1,obI2.nameProps.names);


num1 = length(vastSubs1)
num2 = length(vastSubs2)

objectNumDif = num2-num1


vox1 = cat(1,vastSubs1{:});
vox2 = cat(1,vastSubs2{:});


allVox = cat(1,vox1,vox2);
maxVox = max(allVox,[],1);



f = figure
set(f,'clipping','off')

%%
showF = 0;
res = zeros(max(num1,num2),3);
for i = 1: max(num1,num2)
    
    
    if i>length(vastSubs1)
        res(i,1) = 1;
        res(i,3) = size(vastSubs2{i},1);
    elseif i>length(vastSubs2)
        res(i,1) = 2;
        res(i,2) = size(vastSubs1{i},1);

    else
        
        
        
        sub1 = vastSubs1{i};
        sub2 = vastSubs2{i};
        
        e = 0;
        if isempty(sub1) & isempty(sub2)
            e = 3;
            
        elseif isempty(sub1)
            e = 1;
            
        elseif isempty(sub2)
            e = 2;
            
        else
            
            
            ind1 = sub2ind(maxVox,sub1(:,1),sub1(:,2),sub1(:,3));
            ind2 = sub2ind(maxVox,sub2(:,1),sub2(:,2),sub2(:,3));
            
            dif1 = setdiff(ind1,ind2);
            dif2 = setdiff(ind2,ind1);
            
            res(i,:) = [e length(dif1) length(dif2)];
            
            
            if length(dif1) | length(dif2)
                disp(sprintf('ob %d, %s, %s',i,names1{i},names2{i}))
                [y x z] = ind2sub(maxVox,dif1);
                difSub1 = [y x z];
                
                [y x z] = ind2sub(maxVox,dif2);
                difSub2 = [y x z];
                
                scatter3(sub1(:,1),sub1(:,2),sub1(:,3),20,'b','o','filled','markerfacealpha',.03,'markeredgealpha',0)
                hold on
                scatter3(difSub1(:,1),difSub1(:,2),difSub1(:,3),50,'g','o','filled','markerfacealpha',1,'markeredgealpha',0)
                scatter3(difSub2(:,1),difSub2(:,2),difSub2(:,3),50,'r','o','filled','markerfacealpha',1,'markeredgealpha',0)
                hold off
                pause(.1)
            end
            
            
            if showF
                scatter3(sub1(:,1),sub1(:,2),sub1(:,3),20,'g','o','filled','markerfacealpha',.9,'markeredgealpha',0)
                hold on
                scatter3(sub2(:,1),sub2(:,2),sub2(:,3),20,'r','o','filled','markerfacealpha',.2,'markeredgealpha',0)
                hold off
                pause(.1)
            end
            
        end
    end
    
end


%% show results


difRes = res(1:min(num1,num2),:);
if num1 ~= num2
    moreRes = res(min(num1,num2)+1:size(res,1),:);
    disp('extra segments on one')
    moreRes
else
    moreRes = [];
end

isDif = find(sum(difRes,2)>0);
disp(' ')
disp(' ')

for i = 1:length(isDif);
    id = isDif(i);
    
    
   try name1 = names1{id};
   catch err
       name1 = 'empty';
   end
   
    try name2 = names2{id};
   catch err
       name2 = 'empty';
    end
   
       anc1(i,:) = obI1.colStruc.anchors(id,:);
      anc2(i,:) = obI2.colStruc.anchors(id,:);
    
   line = sprintf('id%d e=%d vox1=%d vox2=%d %s, %s',id,res(id,1),...
       res(id,2),res(id,3),name1,name2);
   disp(line)
   lines{i} = i;
   
   line2 = [num2str(anc1(i,:)) '        ' num2str(anc1(i,:))];
   disp(line2)
   disp(' ')
   


end







