function [badSegList,overlapDist,newObi,sourceDirs]=cleanObi(oldObi,oldObj)
global MPN
timestamp=datestr(now,'YY-DD-HH-MM');
logFile=fopen([MPN 'log_' timestamp '.txt'],'a');
%this is the cutoff in pixels? What happens with mediumRes?
synDistCut=200;
winRad=10;
winDep=5;
plotz=0;

badSynCounter=1;
overlapDistCounter=1;
compareIter=1;
sourceDirs=repmat(" ",length(oldObi.nameProps.synProp),4);
badList={};
badSegList=[];
overlapDist=zeros(length(oldObi.nameProps.synProp),5);
comparisonSegidList=zeros(length(oldObi.nameProps.synProp),2);
if plotz
    synFig=figure();
    hold on;
end
allColPos=oldObi.colStruc.anchors;
allSynSegids=zeros(length(oldObi.nameProps.synProp),1);
allSynPos=zeros(length(oldObi.nameProps.synProp),3);
allSynNames=cell(length(oldObi.nameProps.synProp),1);
for i=1:length(oldObi.nameProps.synProp)
    curStruct=oldObi.nameProps.synProp{i};
    allSynNames{i}=curStruct.name;
    if isfield(curStruct,'segID')
        allSynSegids(i)=curStruct.segID;
        allSynPos(i,:)=allColPos(curStruct.segID,:);
    end
end
allSynDist=pdist2(allSynPos.*[1 1 40],allSynPos.*[1 1 40]);

for i=1:length(oldObi.nameProps.synProp)
    curStruct=oldObi.nameProps.synProp{i};
    curName=curStruct.name;
    curDistList=allSynDist(:,i);
    curSegid=allSynSegids(i);
    curPos=allSynPos(i,:);
    curPre=curStruct.preID;
    curPost=curStruct.postID;
    curNamedCells=sum([curPre;curPost]>0);
    if curSegid~=0
        closeSyns=find(curDistList<synDistCut);
        closeSynSegids=allSynSegids(closeSyns);
        curVox=oldObj(curSegid).subs;
        if plotz==1
            zCent=round(mean(curVox(:,3)));
            curVoxProj=double(unique(curVox(:,[1 2]),'rows'));
            curVoxProjCent=round(mean(curVoxProj,1));
            curVoxBoxX=[curVoxProjCent(1)-winRad curVoxProjCent(1)+winRad];
            curVoxBoxY=[curVoxProjCent(2)-winRad curVoxProjCent(2)+winRad];
            [meshX,meshY]=meshgrid(curVoxBoxX(1):curVoxBoxX(2), ...
                curVoxBoxY(1):curVoxBoxY(2));
            gridArray=[meshX(:),meshY(:)];
            curVoxBoxProj=curVoxProj(ismember(curVoxProj,gridArray,'rows'),:);
            curVoxBound=boundary(curVoxBoxProj(:,1),curVoxBoxProj(:,2));
            % curVoxProj(curVoxBound(1:end-1),1),curVoxProj(curVoxBound(1:end-1),2));
            curVoxPatch=patch(curVoxBoxProj(curVoxBound(1:end-1),1), ...
                curVoxBoxProj(curVoxBound(1:end-1),2), ...
                [1 0 1]);
            curVoxPatch.FaceAlpha=0.25;
            curVoxPatch.EdgeColor='none';
            curPreObIDs=find(cell2mat(cellfun(@(x) sum(x==curPre)>0, oldObi.nameProps.cids, 'UniformOutput', 0)));
            curPreVox=struct2cell(oldObj(curPreObIDs));
            curPreVox=squeeze(curPreVox);
            curPreVox=vertcat(curPreVox{:});
            curPreProj=double(unique(curPreVox(curPreVox(:,3)>zCent-winDep&curPreVox(:,3)<zCent+winDep,[1 2]),'rows'));
            curPreBoxProj=curPreProj(ismember(curPreProj,gridArray,'rows'),:);
            curPreBound=boundary(curPreBoxProj(:,1),curPreBoxProj(:,2));
            curPrePatch=patch(curPreBoxProj(curPreBound(1:end-1),1), ...
                curPreBoxProj(curPreBound(1:end-1),2), ...
                [.8 .8 0]);
            curPrePatch.FaceAlpha=0.25;
            curPrePatch.EdgeColor='none';
            
            for curPostIt=1:length(curPost)
                curPostCid=curPost(curPostIt);
                curPostObIDs=find(cell2mat(cellfun(@(x) sum(x==curPostCid)>0, oldObi.nameProps.cids, 'UniformOutput', 0)));
                curPostVox=struct2cell(oldObj(curPostObIDs));
                curPostVox=squeeze(curPostVox);
                curPostVox=vertcat(curPostVox{:});
                curPostProj=double(unique(curPostVox(:,[1 2]),'rows'));
                curPostBoxProj=curPostProj(ismember(curPostProj,gridArray,'rows'),:);
                curPostBound=boundary(curPostBoxProj(:,1),curPostBoxProj(:,2));
                curPostPatch{curPostIt}=patch(curPostBoxProj(curPostBound(1:end-1),1), ...
                    curPostBoxProj(curPostBound(1:end-1),2), ...
                    rand([1 3]));
                curPostPatch{curPostIt}.FaceAlpha=0.25;
                curPostPatch{curPostIt}.EdgeColor='none';
            end
        end
        for j=1:length(closeSyns)
            decision=0;
            %clf(synFig)
            curOtherSynSegid=closeSynSegids(j);
            comparisonSegidList(compareIter,:)=[curSegid curOtherSynSegid];
            compareIter=compareIter+1;
            namDebug=[allSynNames(closeSyns(j)) curName;{curSegid} {curOtherSynSegid}];
            if ~ismember(curSegid,badSegList)
                if curOtherSynSegid~=curSegid & ~ismember(curOtherSynSegid,badSegList)
                    if ~ismember([curOtherSynSegid curSegid],comparisonSegidList,'rows')
                        if oldObi.fuse.obSource(curSegid)~=oldObi.fuse.obSource(curOtherSynSegid)
                            %sprintf('%.0f %.0f',i,j)
                            
                            %get the struct data
                            otherStruct=oldObi.nameProps.synProp{closeSyns(j)};
                            
                            %calculate the overlap of the two segmentations
                            otherVox=oldObj(curOtherSynSegid).subs;
                            otherPos=allSynPos(closeSyns(j),:);
                            if length(otherVox)>0 & length(curVox)>0
                                curOverlap=length(intersect(otherVox,curVox,'rows'));
                            else
                                curOverlap=0;
                            end
                            
                            %get the cell ids for the comparison seg
                            otherPre=otherStruct.preID;
                            otherPost=otherStruct.postID;
                            otherNamedCells=sum([otherPre;otherPost]>0);
                            
                            curDist=curDistList(closeSyns(j));
                            [curDist/250 curOverlap curSegid curOtherSynSegid];
                            
                            
                            fprintf(logFile,'- - - - - - - - - - - - - - - - -\n');
                            fprintf(logFile,'%s ||| %s | %.2fum\n',curStruct.name,otherStruct.name,curDist/250);
                            fprintf(logFile,'%s ||| %s\n',oldObi.fuse.exportDir{oldObi.fuse.obSource(curSegid)},oldObi.fuse.exportDir{oldObi.fuse.obSource(curOtherSynSegid)});
                            fprintf(logFile,'%d %d %d ||| %d %d %d\n',curPos(1),curPos(2),curPos(3),otherPos(1),otherPos(2),otherPos(3));
                            fprintf(logFile,'size=%.0f vox || size=%.0f vox -- overlap=%.0f vox\n',length(curVox),length(otherVox),curOverlap);
                            sprintf('%s ||| %s\n%s ||| %s\n%d %d %d ||| %d %d %d\n size=%.0f vox || size=%.0f vox\ndist=%.2fum || overlap=%.0f vox', ...
                                curStruct.name,otherStruct.name, ...
                                oldObi.fuse.exportDir{oldObi.fuse.obSource(curSegid)},oldObi.fuse.exportDir{oldObi.fuse.obSource(curOtherSynSegid)}, ...
                                curPos(1),curPos(2),curPos(3),otherPos(1),otherPos(2),otherPos(3), ...
                                length(curVox),length(otherVox), ...
                                curDist/250,curOverlap)
                            %BPC2RGC_figure_swarm.m	541	clipboard('copy',curLoc([2 1 3]));
                            %sprintf('%s',otherStruct.name)
                            %sprintf('\n%d',curDist)
                            if curOverlap>0 & curNamedCells>otherNamedCells
                                fprintf(logFile,'keeping %s ; removing %s\n\n',curStruct.name,otherStruct.name);
                                fprintf('keeping %s ; removing %s\n',curStruct.name,otherStruct.name);
                                badList{badSynCounter,1}=curOtherSynSegid;
                                badSynCounter=badSynCounter+1;
                                badSegList=[badSegList;curOtherSynSegid];
                                decision=2;
                            elseif curOverlap>0 & curNamedCells<otherNamedCells
                                fprintf(logFile,'keeping %s ; removing %s\n\n',otherStruct.name,curStruct.name);
                                fprintf('keeping %s ; removing %s\n',otherStruct.name,curStruct.name);
                                badList{badSynCounter,1}=curSegid;
                                badSynCounter=badSynCounter+1;
                                badSegList=[badSegList;curSegid];
                                decision=3;
                            elseif curOverlap>0 & mean(curPre==otherPre)==1 & mean(curPost==otherPost)==1
                                if length(curVox)>length(otherVox) | length(curVox)==length(otherVox)
                                    fprintf(logFile,'keeping %s ; removing %s\n\n',curStruct.name,otherStruct.name);
                                    fprintf('keeping %s ; removing %s\n',curStruct.name,otherStruct.name);
                                    badList{badSynCounter,1}=curOtherSynSegid;
                                    badSynCounter=badSynCounter+1;
                                    badSegList=[badSegList;curOtherSynSegid];
                                    decision=2;
                                elseif length(curVox)<length(otherVox)
                                    fprintf(logFile,'keeping %s ; removing %s\n\n',otherStruct.name,curStruct.name);
                                    fprintf('keeping %s ; removing %s\n',otherStruct.name,curStruct.name);
                                    badList{badSynCounter,1}=curSegid;
                                    badSynCounter=badSynCounter+1;
                                    badSegList=[badSegList;curSegid];
                                    decision=3;
                                end
                            elseif curOverlap==0 & sum(curPre==otherPre)==0 & sum(curPost==otherPost)==0
                                fprintf(logFile,'keeping both %s and %s\n\n',otherStruct.name,curStruct.name);
                                fprintf('keeping both %s and %s\n',otherStruct.name,curStruct.name);
                                decision=1;
                            else
                                decision=9;
                                fprintf(logFile,'uncertain, but keeping both %s and %s\n\n',otherStruct.name,curStruct.name);
                                fprintf('uncertain, but keeping both %s and %s\n',otherStruct.name,curStruct.name);
                                %decision=1;
%                                 pause(0.01);
%                                 clipboard('copy',otherPos);
%                                 keyin = input( '1=keep both,2=keep left,3=keep right' );
%                                 switch keyin
%                                     case 1
%                                         fprintf(logFile,'leaving both intact\n\n');
%                                         fprintf('leaving both intact\n');
%                                         decision=1;
%                                     case 2
%                                         fprintf(logFile,'keeping %s ; removing %s\n\n',curStruct.name,otherStruct.name);
%                                         fprintf('keeping %s ; removing %s\n',curStruct.name,otherStruct.name);
%                                         badList{badSynCounter,1}=curOtherSynSegid;
%                                         badSynCounter=badSynCounter+1;
%                                         badSegList=[badSegList;curOtherSynSegid];
%                                         decision=2;
%                                     case 3
%                                         fprintf(logFile,'keeping %s ; removing %s\n\n',otherStruct.name,curStruct.name);
%                                         fprintf('keeping %s ; removing %s\n',otherStruct.name,curStruct.name);
%                                         badList{badSynCounter,1}=curSegid;
%                                         badSynCounter=badSynCounter+1;
%                                         badSegList=[badSegList;curSegid];
%                                         decision=3;
%                                 end
                            end
                            overlapDist(overlapDistCounter,:)=[curDist/250 curOverlap curSegid curOtherSynSegid decision];
                            sourceDirs(overlapDistCounter,1)=oldObi.fuse.exportDir{oldObi.fuse.obSource(curSegid)};
                            sourceDirs(overlapDistCounter,2)=curStruct.name;
                            sourceDirs(overlapDistCounter,3)=oldObi.fuse.exportDir{oldObi.fuse.obSource(curOtherSynSegid)};
                            sourceDirs(overlapDistCounter,4)=otherStruct.name;
                            
                            overlapDistCounter=overlapDistCounter+1;
                        end
                    end
                end
            end
        end
    end
end
newObi=oldObi;
end