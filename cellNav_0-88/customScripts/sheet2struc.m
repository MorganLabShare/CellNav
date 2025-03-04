function[d] = sheet2struc(rawDat)


heads = rawDat(1,:);
dat = rawDat(2:end,:);

%%Make headers field names
fields = {};
for f = 1:length(heads)
    nam = heads{f};
    s = regexp(nam,' ');
    nam(s) = '_';
    nam = matlab.lang.makeValidName(nam)
    fields{f} = nam;
end
fid = [1:length(heads)];

%% parse Data
clear d
datNum = size(dat,1);
rids = zeros(datNum,1);
ephysXY = zeros(size(datNum,1),2);
vastXYZ = zeros(size(datNum,1),3);
recon = {};

for r = 1:size(dat,1)
    for f = 1:length(heads)
        line = dat{r,fid(f)};
        if strcmp(class(line),'char')
            nums = regexp(line,'\d');
            if length(nums) == 0;
                eval(sprintf('d.%s{r,1} = line',fields{f}));
            else
                new = find(nums(2:end)-nums(1:end-1)>1);
                if isempty(new)
                    num = str2num(line(nums));
                else
                    for n = 1:length(new)
                        num(n) = str2num(line(nums(1):nums(new(1)))) ;
                    end
                    num(n+1) = str2num(line(nums(new(end)+1):nums(end))) ;
                end
                eval(sprintf('d.%s(r,1:length(num)) = num',fields{f}));
            end
        else
            eval(sprintf('d.%s{r,1} = line',fields{f}));
        end
    end
end

