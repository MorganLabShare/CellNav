

mipLevel = 4;
fileType = 'png';

%% mip map directory
SPN = 'G:\IxQ\VAST\scm_ixQ_phys_pyr\'

%% Find section directories
dSPN = dir(SPN)
secNum = 0;
for i = 1:length(dSPN)
   slc =  str2num(dSPN(i).name);
   if ~isempty(slc)
       secNum = secNum+1;
       secID(secNum) = slc;
       secDir{secNum} = dSPN(i).name;
   end   
end

[secID ix] = sort(secID,'ascend');
secDir = secDir(ix);


%% 
for s = 1:length(secID);
    iDir = sprintf('%s%s\\%d\\',SPN,secDir{s},mipLevel);
    dI = dir([iDir '*' fileType])
    for i = 1:length(dI)
        
        
    end    
end
