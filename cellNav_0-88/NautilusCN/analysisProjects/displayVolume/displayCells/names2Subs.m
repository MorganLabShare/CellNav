function[cellSubs, obTarg] = names2Subs(obI,dsObj,cellId);


%%
try
    uCellId = cellId;
    
    for i = 1:length(uCellId)
        
        
        if strcmp(class(uCellId),'cell')
            term = uCellId{i};
        else
            term = uCellId(i);
        end
        if strcmp(class(term),'char')
            for n = 1:length(obI.nameProps.names)
                isTerm(n) = sum(regexp(lower(obI.nameProps.names{n}),lower(term)));
                
            end
            obTarg = find(isTerm);
            obI.nameProps.names(obTarg);
        elseif size(term,2) == 3
            cellSubs{1} = term;
            obTarg = [];
            break
        else
            targ = find(obI.cell.name==term);
            obTarg = obI.cell.obIDs{targ};
        end
        
        stackSubs = double(cat(1,dsObj(obTarg).subs));
%         stackSubs = [];
%         subSize = 0;
%         for o = 1:length(obTarg)
%             o
%             if obTarg(o)<=length(dsObj)
%                 sub = double(dsObj(obTarg(o)).subs);
%                 storeSub(o).sub = sub;
%                 subSize = subSize + size(sub,1);
% %                 if ~isempty(sub)
% %                     stackSubs = cat(1,stackSubs, sub);
% %                 end
%                 
%             end
%             
%         end
            
        
        cellSubs{i} = stackSubs;
    end
catch
    cellSubs{1} = [];
    obTarg = [];
end

