function[propCol,colInd] = colorProp(prop,style,v)

%%Create n x 3 array of colors for a entered property
%%also return the color index for the property
%%Options are STD (standard deviation) or RNG (range)


cNum = 100;
cmap = jet(cNum);
colInd = prop;


if ~exist('style','var')
    style = 'RNG';
end

if strcmp(style,'STD')
    if ~exist('v','var')
        v = .25;
    end
    colInd = colInd - mean(colInd(:));
    colInd = colInd / std(colInd(:)) ;
    colInd = colInd * (v * cNum);
    colInd = colInd + 50;
    
else %RNG
    
    colInd = colInd - min(colInd(:));
    colInd = colInd * (cNum-1)/max(colInd(:));
    colInd = colInd + 1;
    
end
if sum(isnan(colInd))
    disp('Warning, NaNs replaced with color index 1')
    colInd(isnan(colInd)) = 1;
end

colInd = round(colInd);
colInd(colInd<1) = 1;
colInd(colInd>cNum) = cNum;

colInd = colInd;

propCol = cmap(colInd,:);
