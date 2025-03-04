function[res] = parseDevSyn()

global glob tis
app = glob.app;

allNames = tis.obI.nameProps.names;
synObID = tis.syn.obID;
nams = allNames(synObID)';
numSyn = length(synObID);

clear ps st
st.preClass.char{1} = {'S','M','L','G'};
st.preClass.char{2} = {'D','L','N','U'};
st.preClass.char{3} = {'S','L','U'};
st.preClass.char{4} = {'R','F','U'};

ps.preSynLabClass = zeros(length(nams),1);
ps.preSynVal = zeros(length(nams),4);
ps.isSpine = zeros(length(nams),1);
ps.isSheath = zeros(length(nams),1);
ps.isDenseVec = zeros(length(nams),1);
ps.isEnPassant = zeros(length(nams),1);

for n = 1:length(nams)
    nam = nams{n};
    [newStr, match] = split(nam);
    for s = 1:length(newStr)
        str = newStr{s};

        %%Check manual presyn class
        if strcmp(upper(str),'RGC')
            ps.preSynLabClass(n) = 1;
        elseif strcmp(upper(str),'LIN')
            ps.preSynLabClass(n) = 3;
        elseif  strcmp(upper(str),'CTX')
            ps.preSynLabClass(n) = 11; 
        elseif  strcmp(upper(str),'RTN')
            ps.preSynLabClass(n) = 12; 
        elseif  strcmp(upper(str),'ACH')
            ps.preSynLabClass(n) = 13; 
        end    
          
        %%Check presyn properties
        if length(str) == 4
            for c = 1:4
               hit =  find(strcmp(str(c),st.preClass.char{c}));
               if ~isempty(hit)
                   ps.preSynVal(n,c) = hit;
               end
            end
        end
        
        %%Check other labels
        if strcmp(lower(str),'spine')
            ps.isSpine(n) = 1;
        end
        if strcmp(lower(str),'sheath')
            ps.isSheath(n) = 1;
        end
        if strcmp(lower(str),'densevec')
            ps.isDenseVec(n) = 1;
        end

    end
end

%% EM class
%% RGC, Large bouton dark mito (LIN or OT), small medium no bouton, 
%% small no mito spine, small no mito no spine, flat vec, denseVec
st.preClass.char{1} = {'S','M','L','G'};
st.preClass.char{2} = {'D','L','N','U'};
st.preClass.char{3} = {'S','L','U'};
st.preClass.char{4} = {'R','F','U'};

ps.lightMito = ps.preSynVal(:,2) == 2; %light mito
ps.darkMito = ps.preSynVal(:,2) == 1; %dark mito
ps.noMito = ps.preSynVal(:,2) == 3; % no mito
ps.notSmall =  ps.preSynVal(:,1) > 1; %large bouton
ps.notLarge = ps.preSynVal(:,1) < 3; %not large or giant
ps.giant = ps.preSynVal(:,1) == 4; %giant bouton
ps.largeVec = ps.preSynVal(:,3) == 2; %large vec
ps.flatVec = ps.preSynVal(:,4) == 2; % Flat vec

ult.ctx = ps.noMito & ~ps.flatVec & ps.isSpine & ~ps.isDenseVec & ps.notLarge;
ult.rtn = ps.noMito & ps.flatVec & ~ps.isDenseVec & ps.notLarge;
ult.ach = ps.isDenseVec;
ult.rgc = ps.lightMito;
ult.rgcLike = (ps.notSmall & ps.largeVec & ~ps.isDenseVec & ~ps.flatVec);
ult.noMitoNotDense = ps.notLarge & ps.noMito & ~ps.isDenseVec;
ult.darkMitoNotDense = ps.darkMito & ~ps.isDenseVec;


res.ps = ps;
res.st = st;
res.ult = ult;
res.tp.rgc = res.ult.rgc | ps.preSynLabClass == 1| (tis.syn.preClass == 1) ;
res.tp.lin = (ps.preSynLabClass == 3) | (tis.syn.preClass == 3);
res.tp.ctx = res.ult.ctx |(ps.preSynLabClass == 11) | (tis.syn.preClass == 11);
res.tp.rtn = res.ult.rtn |(ps.preSynLabClass == 12) | (tis.syn.preClass == 12);
res.tp.ach = res.ult.ach |(ps.preSynLabClass == 13) | (tis.syn.preClass == 13);








