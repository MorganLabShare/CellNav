function[folds] = getDirs(folder)

dirFolder = dir(folder);
isFold = setdiff(find([dirFolder.isdir]),[1 2]);
folds = {dirFolder(isFold).name};