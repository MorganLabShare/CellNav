function[p] = renderFVs(fvs)

for i = 1:length(fvs.type)
    
    p(i) = patch(fvs.type(i).fv);
    view(30,-15);
    axis vis3d;
    %colormap copper
    set(p(i),'EdgeColor','none');
    p(i).FaceColor = fvs.col(i,:);
    %
    
    daspect([1,1,1])
    view(3); axis tight
    %camlight
    %lighting gouraud
    
    
    %l = lightangle(145,45) ;
    p(i).FaceLighting = 'gouraud';
    p(i).AmbientStrength = .2;%.4; shadowColor
    p(i).DiffuseStrength = .8;%.1;
    p(i).SpecularStrength = .6;
    p(i).SpecularExponent = 3;
    p(i).BackFaceLighting = 'lit';
    p(i).Clipping = 'off';
    
    if exist('alph','var')
        p(i).FaceAlpha = alph;
        
    end
    
    set(gca,'color',[0 0 0])
    set(gcf,'color',[0 0 0])
end