function mergeFvLibraries

global glob

%%Merge fv files, tis and tis dat

vols = glob.vol.names;
useLib = glob.NA.export.useLib;
clear libDir libWorks
for i = 1:length(useLib)
    libDir{i} = [glob.dir.Volumes  useLib{i} '\Analysis\fvLibrary\'];
    libWorks(i) = exist(libDir{i},'dir');
end

fvDir = glob.fvDir;
rmdir(fvDir,'s')
mkdir(fvDir)

%% merge cids
clear matNam
clear fCids
for i = 1:length(libDir)
    if ~libWorks(i)
        disp(sprintf('%s not found',libDir{i}))
    else
        dirMat = dir([libDir{i} '*.mat']);
        matNam{i} = {dirMat.name};
        for n = 1:length(matNam{i})
            c = str2num(matNam{i}{n}(1:end-4));
            if ~isempty(c);
                fCids{i}(n) = c;
            else
                fCids{i}(n) = 0;
            end
        end
    end
end

cids = setdiff(unique([fCids{:}]),0);



for i = 1:length(cids)    
    v = 0;
    vert = [];
    faces = [];
   
    for d = 1:length(libDir)
        targ = find(fCids{d}==cids(i));
        if ~isempty(targ)
            fv = loadFV([libDir{d} matNam{d}{targ}]);
            vert = cat(1,vert,fv.vertices);
            faces = cat(1,faces,fv.faces+v);
            v = size(vert,1);
          
        end
    end
    
    fv.vertices = vert;
    fv.faces = faces;
    save([fvDir num2str(cids(i)) '.mat'],'fv');
    
end

mergeDirs = libDir(libWorks>0);


%% Copy other fv

%% Copy Dat (needs testing)
binder.dat.cid = [];
for i = 1:length(useLib)
   if exist([glob.dir.Volumes useLib{i} '\Merge\dat.mat'],'file')
       load([glob.dir.Volumes useLib{i} '\Merge\dat.mat']);
       binder.dat = dat;
   end     
end

%% merge tis

obI = mergeVast_fvLib(mergeDirs,fvDir,vols); %Merge obI files
binder.obI = obI;
tis = makeTis(binder);
save([fvDir 'tis.mat'],'tis')
tisDat = makeTisDat(tis);
save([fvDir 'tisDat.mat'],'tisDat');




