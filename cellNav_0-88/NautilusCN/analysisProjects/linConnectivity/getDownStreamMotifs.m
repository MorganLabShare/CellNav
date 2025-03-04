function[check] = getMotifsAroundSyn(sm,checkS,maxDist,targCell)

check.checkS = checkS;
check.targCell = targCell;
check.maxDist = maxDist;

for i = 1:length(checkS) % Define position by input synapse
    checkPos = sm.pos(checkS(i),:);
    check.pos(i,:) = checkPos;
    
    close = find(sm.dist(i,:)<=maxDist);
    synNum(i) = length(close);
    if isempty(close)
        mot{i} = 0;
    else
        
        preClass = sm.preClass(close);
        postClass = sm.postClass(close);
        pre = sm.pre(close);
        post = sm.post(close);
        
        
        rgcIn = (preClass == 1) & (post == targCell);
        tcOut = (postClass == 2) & (pre == targCell);
        linIn = (preClass == 3) & (post == targCell);
        linOut = (postClass == 3) & (pre == targCell);
        unkIn = (preClass == 4) & (post == targCell);
        
        m.inLab = length(checkS);
        m.inTc = 0;
        m.inTcDoub = 0;
        m.inLin = 0;
        m.inLinTc = 0;
        m.inLinLinIn = 0;
        m.inLinLinOut = 0;
        m.inLinLinDoub = 0;
        m.inOneOut = 0;
        m.inLinTcDi = 0;
        m.inLinLinDi = 0; %chain of two
        m.recip = 0;
        m.autapse = 0;
        
        
        %% check as Pre
            inID = checkS(i);
            isID = pre==inID;
            rPostID = post(isID);
            rPostClass = postClass(isID);
            
            if isempty(setdiff(rPostID,targCell))
                m.inOneOut = m.inOneOut + 1;
            end
            
            m.inTc = m.inTc + sum(rPostClass == 2);
            m.inLin = m.inLin + sum(rPostClass == 3);
            
            checkPost = setdiff(unique(rPostID),[0 targCell]);
            m.inTcDoub = m.inTcDoub + sum((rPostClass==2) & (rPostID==0));
            m.inLinLinDoub = m.inLinLinDoub + sum((rPostClass==3) & (rPostID==0));
            
            %%find lin triads
            for p = 1:length(checkPost)
                
                if sum((post == checkPost(p)) & (postClass == 2)) % if post is TC
                    isPost = (pre==targCell) & (post == checkPost(p)) ;
                    if sum(isPost)
                        m.inLinTc = m.inLinTc + 1;
                    else
                        m.inTcDoub = m.inTcDoub + 1;
                    end
                end
                
                if sum((post == checkPost(p)) & (postClass == 3)) %if post is LIN
                    isPre = (pre == checkPost(p)) & (post == targCell)& (preClass == 3);
                    if sum(isPre)
                        m.inLinLinIn = m.inLinLinIn + 1;
                    else
                        m.inLinLinDoub = m.inLinLinDoub +1;
                    end
                end
                
                if sum((post == checkPost(p)) & (postClass == 3))%if post is LIN
                    isPost = (pre==targCell) & (post == checkPost(p)) & (postClass == 3);
                    if sum(isPost)
                        m.inLinLinOut = m.inLinTc + 1;
                    else
                        m.inLinLinDoub = m.inLinLinDoub +1;
                    end
                end
                
            end
            
            %%Find RGC LIN TC diads
            postTarg = post((pre == targCell) & (postClass == 2));
            m.inLinTcDi = m.inLinTcDi + sum(postTarg == 0);
            m.inLinTcDi = m.inLinTcDi + length(setdiff(postTarg,[0; checkPost]));
            
            %%Find RGC LIN LIN diads
            postTarg = post((pre == targCell) & (postClass == 3));
            m.inLinLinDi = m.inLinLinDi + sum(postTarg == 0);
            m.inLinLinDi = m.inLinLinDi + length(setdiff(postTarg,[0; checkPost]));
            
    end
    check.m(i) = m;
        
end
  
