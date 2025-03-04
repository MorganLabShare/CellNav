function[fv] = loadFV(filename)


slashes = regexp(filename,'\');
fvDir = filename(1:slashes(end));

if exist(filename,'file')
    load(filename);
    
    % h = figure
    % scatter3(fv.vertices(:,1),fv.vertices(:,2),fv.vertices(:,3),'.','g')
    % hold on
    % set(gca,'clipping','off')
    dim1 = [2 3];
    dim2 = [3 1];
    
    if exist([fvDir 'volTransform.mat'])
        load([fvDir 'volTransform.mat']);
        if isfield(volTransform,'type')
        transType = volTransform.type;
        switch transType
            case 'YX XZ'
                filename
                fv.vertices(:,dim1) = transformPointsInverse(volTransform.tform1,fv.vertices(:,dim1));
                fv.vertices(:,dim2) = transformPointsInverse(volTransform.tform2,fv.vertices(:,dim2));
        end
        %scatter3(fv.vertices(:,1),fv.vertices(:,2),fv.vertices(:,3),'.','r')
        end
    end
    
    
else
    
    sprintf('%s not found',filename)
    fv.vertices = [];
    fv.faces = [];
end






