function vertface2objmtl(v,f,filename,objectname,Kd)
% VERTFACE2OBJ Save a set of vertice coordinates and faces as a Wavefront/Alias Obj file
% VERTFACE2OBJ(v,f,fname)
%     v is a Nx3 matrix of vertex coordinates.
%     f is a Mx3 matrix of vertex indices.
%     fname is the filename to save the obj file.
%%
fid = fopen(filename,'w');

slash =  find(filename =='\');

coreName = filename(slash(end) + 1:end-4);
materialname = [coreName 'MTL'];
mtlLibname = [coreName '.mtl'];
mtlFilename = [filename(1:end-4) '.mtl'];

fileString = ['mtllib ' mtlLibname];
mtlString = ['usemtl ' materialname];
%
% mtllib Glia__4787_Hide.Other.Segment_4787_Mystery_3.mtl
% usemtl Glia__4787_material
%fprintf(fid,'%s\t%d\t%d\r\n',name{nr},ovolmu(nr),osareamu(nr));
fprintf(fid,'%s\n', fileString)
fprintf(fid,'%s\n',mtlString)


for i=1:size(v,1)
    fprintf(fid,'v %f %f %f\n',v(i,1),v(i,2),v(i,3));
end

fprintf(fid,'g %s\n',objectname);

for i=1:size(f,1);
    fprintf(fid,'f %d %d %d\n',f(i,1),f(i,2),f(i,3));
end
fprintf(fid,'g\n');

fclose(fid);


%%

if ~exist('Kd','var'), Kd = [1 1 1]; end


%Define constant material parameters
Ns=50.0000;
Ni=1.5000;
d=0.4000; %Opacity (0.0 is transparent, 1.0 is opaque)
Tr=0.0000;
Tf=[1.0000 1.0000 1.0000 ];
illum=2;
Ka=[0.0000 0.0000 0.0000];
%Kd=[0.5882 0.5882 0.5882];
Ks=[1.0000 1.0000 1.0000];
Ke=[0.0000 0.0000 0.0000];
%
%   %for seg=1:1:param.maxobjectnumber
%   for segnr=1:obNum %param.maxobjectnumber
%     seg=param.objects(segnr,1);
%     %if param.objects(segnr,2)>0
% %       if (usecolorfile==1)
% %         filename=sprintf(param.mtlfilenametemplatefull,seg,name{find(data(:,1)==seg)});
%         filename(filename=='?')='_';
%       else
%         filename=sprintf(param.mtlfilenametemplatefull,seg,'');
%       end;
%       if (max(size(param.vparray{seg}))>0)
%         if (usecolorfile==1)
%           materialname=sprintf(param.materialnametemplate,seg,name{find(data(:,1)==seg)});
%           %materialname(materialname=='?')='_';
%         else
%           materialname=sprintf(param.materialnametemplate,seg,'');
%         end;


%
%
%         Kd = colors(segnr,:);

%filename=[outputdir mtlfilename];
disp(sprintf('Saving %s ...',mtlFilename));
fid = fopen(mtlFilename, 'wt');
fprintf(fid,'# VAST -> MTL script by Daniel Berger, 9.2011\r\n');
%fprintf(fid,'# File Created: 14.06.2010 10:49:56\r\n\r\n');
%fprintf(fid, '%6.2f %12.8f\n', y);

fprintf(fid,'newmtl %s\r\n',materialname);
fprintf(fid,'  Ns %.4f\r\n',Ns);
fprintf(fid,'  Ni %.4f\r\n',Ni);
fprintf(fid,'  d %.4f\r\n',d);
fprintf(fid,'  Tr %.4f\r\n',Tr);
fprintf(fid,'  Tf %.4f %.4f %.4f\r\n',Tf(1),Tf(2),Tf(3));
fprintf(fid,'  illum %d\r\n',illum);
fprintf(fid,'  Ka %.4f %.4f %.4f\r\n',Ka(1),Ka(2),Ka(3));
fprintf(fid,'  Kd %.4f %.4f %.4f\r\n',Kd(1),Kd(2),Kd(3));
fprintf(fid,'  Ks %.4f %.4f %.4f\r\n',Ks(1),Ks(2),Ks(3));
fprintf(fid,'  Ke %.4f %.4f %.4f\r\n',Ke(1),Ke(2),Ke(3));
fprintf(fid,'\r\n');
fclose(fid);
%       else
%         disp(['Object of ' filename ' is empty. Not saving.']);


