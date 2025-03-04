clear all
load('MPN.mat')

    load([MPN 'obI.mat'])
    load([MPN 'dsObj.mat'])
cellList = [108 201 903 907];
renderOb = 1;

objDir = [MPN 'stlFiles\']
if ~exist(objDir,'dir'),mkdir(objDir),end

downSamp = 2;
for i = 1:length(cellList)
    sub = names2Subs(obI,dsObj,cellList(i));
    obName = cellList(i);
   
    smallSub = shrinkSub(sub{1},downSamp);
    tic
    fv = subVolFV(smallSub,[],renderOb);
    fileNameOBJ = sprintf('%sdSamp%d_%d.obj',objDir,downSamp,obName);
    fileNameSTL = sprintf('%sdSamp%d_%d.stl',objDir,downSamp,obName);
    %STLWRITE(FILE, FACES, VERTICES)
    stlwrite(fileNameSTL,fv.faces,fv.vertices);
    vertface2obj(fv.vertices,fv.faces,fileNameOBJ,obName);
    toc
%     cellDat(i).subs = sub;
%     cellDat(i).fv = fv;
    
end
