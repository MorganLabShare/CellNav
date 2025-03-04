function[] = renderRefs()

global glob

MPN = glob.NA.MPN;
WPN = glob.NA.WPN;

%load('MPN.mat')

load([MPN 'obI.mat'])
load([MPN 'dsObj.mat'])
load([WPN 'tis.mat'])

allNames = obI.colStruc.names;
flipDim = [1 3 2 ];
downSamp = 1;

renderProps.smooth = 0;
renderProps.resize = 1;
renderProps.smoothPatch = 0;


renderOb = 0;
objDir = [WPN 'fvLibrary\']
if ~exist(objDir,'dir'),mkdir(objDir),end

%% make fv
refNames = {'gcl nucEdge','inl nucEdge','10 micron bar','10 micron point 1',...
    '10 micron point 2'};
refCol = [1 1 0; 1 0 1; 0 1 0; 1 1 1; 1 1 1];

for i = 1:length(refNames)
    
    refID = find(ismember(allNames,refNames{i}),1);
    if ~isempty(refID)
        sub = dsObj(refID).subs;
        smallSub = shrinkSub(sub,downSamp);
        smallSub = smallSub(:,flipDim);
        fv = subVolFV(smallSub,[],renderProps);
        fv.vertices = fv.vertices * .1;
        fileNameFV= sprintf('%sref_%s.mat',objDir,refNames{i})
        save(fileNameFV,'fv')
    end
end


















