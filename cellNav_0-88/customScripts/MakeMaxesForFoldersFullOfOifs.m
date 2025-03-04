

SPN = 'H:\GadGFP_Albino\'

%% Find oifs

oList = {};
odList = {};

dirNow = SPN;
od = dir([dirNow '*.oif']);
oList = cat(1,oList,od.name);
d1 = dir(SPN);
for f1 = 3:  length(d1)
    if d1(f1).isdir
        dirNow = [d1(f1).folder '\' d1(f1).name '\'];
        od = dir([dirNow '*.oif']);
        oList = cat(1,oList,od.name);
        odList = cat(1,odList,od.folder);
        d2 = dir(dirNow);
        for f2 = 3:length(d2)
            dirNow = [d2(f2).folder '\' d2(f2).name '\'];
            od = dir([dirNow '*.oif']);
            odList = cat(1,odList,od.folder);
            oList = cat(1,oList,od.name);
            d3 = dir(dirNow);
            for f3 = 3:length(d3)
                dirNow = [d3(f3).folder '\' d3(f3).name '\'];
                od = dir([dirNow '*.oif']);
                odList = cat(1,odList,od.folder);
                oList = cat(1,oList,od.name);
                d4 = dir(dirNow);
                for f4 = 3:length(d4)
                    dirNow = [d4(f4).folder '\' d4(f4).name '\'];
                    od = dir([dirNow '*.oif']);
                    odList = cat(1,odList,od.folder);
                    oList = cat(1,oList,od.name);
                    d5 = dir(dirNow);
                    for f5 = 3:length(d5)
                        dirNow = [d5(f5).folder '\' d5(f5).name '\'];
                        od = dir([dirNow '*.oif']);
                        odList = cat(1,odList,od.folder);
                        oList = cat(1,oList,od.name);
                        d6 = dir(dirNow);
                        for f6 = 3:length(d6)
                            dirNow = [d6(f6).folder '\' d6(f6).name '\'];
                            od = dir([dirNow '*.oif']);
                            odList = cat(1,odList,od.folder);
                            oList = cat(1,oList,od.name);
                            d7 = dir(dirNow);
                        end
                    end
                end
            end
        end
    end
end


%% run maxes
stkChan = {[3 2 1] [5 4  2]};
for d = 1:length(oList)
    disp(sprintf('Running %d of %d, %s%s',d,length(oList),odList{d},oList{d}))
    oifName = oList{d}(1:end-4);
    CPN = [odList{d} '\' oifName '\'];
    RGBs = returnMaxFromOIF(CPN,stkChan);
end


