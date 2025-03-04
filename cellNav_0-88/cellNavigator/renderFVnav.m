function[p] = renderFVnav(fv,col,alph,tag,tform,ax)
global glob

if ~exist('ax','var')
    ax = glob.ax;
end

if ~exist('tag','var')
    tag = 'none';
elseif ~strcmp(class(tag),'char')
     tag = num2str(tag);
end


if ~isempty(fv.vertices)
fv.vertices = fv.vertices(:,[3 2 1]);

else
    disp('Empty FV file')
end

if exist('tform','var')
    if ~isempty(tform) & ~isempty(fv.vertices)
    pcV = pointCloud(fv.vertices);
    pcV = pctransform(pcV,tform);
    fv.vertices = pcV.Location;
    %fv.vertices = pctransform(fv.vertices,tform)
    end
end

p = patch(ax,fv);
%view(30,-15);
axis vis3d;
%colormap copper
set(p,'EdgeColor','none');
if exist('col','var')
    p.FaceColor = col;
end
%

daspect([1,1,1])
%view(3); 
%axis tight
%camlight
%lighting gouraud


%l = lightangle(145,45) ;
p.FaceLighting = 'gouraud';
p.AmbientStrength = .4;%.4; shadowColor
p.DiffuseStrength = 1;%.1;
p.SpecularStrength = .8;
p.SpecularExponent = 3;
p.BackFaceLighting = 'reverselit';
p.Clipping = 'off';
p.Tag = tag;

if exist('alph','var')
    p.FaceAlpha = alph;
end

set(gca,'color',[0 0 0])
%set(gcf,'color',[0 0 0])
set(gca,'visible','off')





