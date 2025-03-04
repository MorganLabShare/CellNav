function[roi] = makeFuncROI()

%%Parse google spreadsheet that containes positional information on
%%functional ROIs

%% Get google sheet data
datSheet = '1afOk6rZaHInpXxEMLvNalMMuEN2GecdNwijAHHPD9Yk';
datGID = '448817604';

rawDat = GetGoogleSpreadsheet2(datSheet,datGID);
heads = rawDat(1,:);
dat = rawDat(2:end,:);

%% Parse header
fields = {'ROI_ID','cid','Ephys XY','VAST XYZ','reconstruction'};
fid = zeros(1,length(fields));
for i = 1:length(fields)
    for f = 1:size(rawDat,2)
        if strcmp(heads{f},fields{i})
            fid(i) = f;
        end
    end
end

%% parse Data
datNum = size(dat,1);
rids = zeros(datNum,1);
cids = zeros(datNum,1);
ephysXY = zeros(size(datNum,1),2);
vastXYZ = zeros(size(datNum,1),3);
recon = {};

for r = 1:size(dat,1)
    rids(r) = str2num(dat{r,fid(1)});
    cids(r) = str2num(dat{r,fid(2)});
    
    line = dat{r,fid(3)};
    nums = regexp(line,'\d');
    new = find(nums(2:end)-nums(1:end-1)>1);
    p1 = str2num(line(nums(1):nums(new(1)))) ;
    p2 = str2num(line(nums(new(1)+1):nums(end))) ;
    ephysXY(r,:) = [p1 p2];
    
    line = dat{r,fid(4)};
    nums = regexp(line,'\d');
    new = find(nums(2:end)-nums(1:end-1)>1);
    p1 = str2num(line(nums(1):nums(new(1)))) ;
    p2 = str2num(line(nums(new(1)+1):nums(new(2)))) ;
    p3 = str2num(line(nums(new(2)+1):nums(end))) ;
    vastXYZ(r,:) = [p1 p2 p3];
    
    recon{r,1} = dat{r,fid(5)};
    
end


roi.rids = rids;
roi.cids = cids;
roi.ephysXY = ephysXY;
roi.vastXYZ = vastXYZ;
roi.recon = recon;
roi
