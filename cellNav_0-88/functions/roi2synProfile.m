function[] = roi2synProfile(roi)

%%Finds distance across skell for defined roi to every type of synapse

load('MPN.mat');
load([MPN 'tis.mat']);

if ~exist('roi','var')
    roi = makeFuncROI;
end

cids = roi.cids;



