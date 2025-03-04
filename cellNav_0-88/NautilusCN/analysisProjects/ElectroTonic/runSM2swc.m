

load('MPN.mat')
targID = 10;
fileName = sprintf('sm_cid%d.mat',targID);
load([WPN 'SMs\' fileName])
sm2swc(sm) %write swc file
