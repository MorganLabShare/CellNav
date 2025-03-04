


for i = 1: length(sms)
    sm= sms(i).sm;
    load('MPN.mat')
    smxName = sprintf('smx_cid%d.mat',sm.cid);
    save([WPN 'SMs\' smxName],'-struct','sm','nep','syn',...
        'cell','skel2skel','syn2Skel','-v7.3');
end