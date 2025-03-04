function[depthHist] = getHisto(tis,fvDir)



%%Make sure that you are in the fvlibrary folder
%fvDir='G:\IxQ\Matlab\Analysis\fvLibrary\';
plotDest=[fvDir '\dat\'];
if ~exist(plotDest,'dir'), mkdir(plotDest); end


%These are necessary for the IPLdepth function to run
ipl_bord_GCL = load([fvDir 'ref_gcl nucEdge.mat']);
ipl_bord_INL = load([fvDir 'ref_inl nucEdge.mat']);

%fit some planes to the borders of the IPL and INL
GCLbord=ipl_bord_GCL.fv.vertices(:,:);
INLbord=ipl_bord_INL.fv.vertices(:,:);

%convert border vertices to pt cloud
GCLptCloud=pointCloud(GCLbord);
INLptCloud=pointCloud(INLbord);

%fit plane to the pt clouds (result params = ax+by+cz+d=0)
GCLplane=pcfitplane(GCLptCloud,1,'MaxNumTrials',50000);
INLplane=pcfitplane(INLptCloud,1,'MaxNumTrials',50000);

%get the cids of all bpcs
bpcCidList=tis.cids;

%% Loop through all of the bipolar cells and get their depths within the IPL

%save individual histograms of all bpc cells
saveJPGBool=0;

%create empty struct for results
bpcStats=struct;

for i=1:length(bpcCidList)
    %get the cid
    bpcStats(i).cid=bpcCidList(i);
    
    matString=sprintf('%i.mat',bpcStats(i).cid);
    matDat=load([fvDir matString]);
    if isempty(matDat.fv.vertices)
        bpcStats(i).isDat = 0;
    else
        bpcStats(i).isDat = 1;
        %get the depth in the IPL
        bpcStats(i).zDepth=getCellZdepth(bpcCidList(i),GCLplane,INLplane);
        %go ahead and get the old percentage for comparison
        bpcStats(i).zDepthOld=getCellZdepthOld(bpcCidList(i),ipl_bord_GCL,ipl_bord_INL);
        %get area modeled with ellipse
        bpcStats(i).area=getCellArborArea(bpcCidList(i));
        %get average span in x / y
        bpcStats(i).spanMicron=getCellArborSpan(bpcCidList(i));
        %get the average vertex distance from centroid
        [bpcStats(i).densityAvg,bpcStats(i).densityStd]=getCellArborDensity(bpcCidList(i));
        %JOSH; HERE IS THE HISTOGRAM FUNCTION
        %get the data for plotting the histograms
        bpcStats(i).histDat=getDepthDist(bpcCidList(i),GCLplane,INLplane,saveJPGBool,plotDest);
    end
end

depthHist = bpcStats;
%save([fvDir 'tisDat.mat'],'tisDat')



%make histogram of the average zdepths
makeHistFig=0;
if makeHistFig==1
    depths=extractfield( bpcStats,'zDepth');
    histogram(depths,30)
end

%% Histogram makin'

%minimum arbor area for plotting a hist
minArea=3000;

makeHists=0;
if makeHists==1
    figure();
    hold on;
    for i=1:length(bpcStats)
        %check to see if the cell is big enough
        area=bpcStats(i).area;
        if area>minArea
            curPlotDat=bpcStats(i).histDat;
            plot(curPlotDat(:,1),curPlotDat(:,2),'Color',[rand,rand,rand]);
        end
    end
    %set the limit
    xlim([0 1]);
    %turn the camera 90
    camroll(-90);
end


%% Function block

function plotDat=getDepthDist(cid,GCLplane,INLplane,plotBool,plotLoc)
    %bin width for the output histogram ata
    binWidth=5;
    %load the mat file for the cell
    matString=sprintf('%i.mat',cid);
    matDat=load([fvDir matString]);
    %get the vertices
    coords=matDat.fv.vertices(:,:);
    %make the histogram so we can get the data
    figure();
    hist=histogram(coords(:,1),'BinWidth',binWidth);
    %find the gcl and inl boundaries for percentage calcs
    location=getMedianLoc(cid);
    [gclz,inlz,zperc]=getIPLdepth(location(1),location(2),location(3),GCLplane,INLplane);
    %create the histogram data for later
    plotDatX=hist.BinEdges;
    %bin edges are longer than bin counts so remove the last one
    plotDatX=plotDatX(1:end-1);
    %make the array the center of each bin
    plotDatX=plotDatX+(binWidth/2);
    %convert to depth percentages using the gcl and inl depths
    %plotDatXpercs=abs(plotDatX-abs(inlz))/abs(abs(inlz)-abs(gclz));
    plotDatXpercs=-(plotDatX-inlz)/abs(abs(inlz)-abs(gclz));

    %vertex counts at each z location
    plotDatY=hist.BinCounts;
    %OPTIONAL: convert to a percentage of total arbor verts
    plotDatYpercs=plotDatY/sum(plotDatY);
    close;
    %create the exported array (change to plotDatYpercs if you want).
    plotDat=[plotDatXpercs',plotDatY'];
    %this loop saves jpgs of each histogram
    if plotBool==1
        plotFilename=sprintf('%i.jpg',cid);
        plotFilePath=[plotLoc plotFilename];
        figure();
        plot(plotDatXpercs,plotDatYpercs);
        xlim([0 1]);
        camroll(-90);
        title(plotFilename);
        saveas(gcf,plotFilePath);
        close;
    end
    
end

%get the mean distance and standard deviation of vertex dist from centroid
    function [cellArborDensityAvg,cellArborDensityStd]=getCellArborDensity(cid)
        matString=sprintf('%i.mat',cid);
        matDat=load([fvDir matString]);
    coords=matDat.fv.vertices(:,:);
    cellMedianLoc=median(coords);
    coordsTrimmed=coords(abs(coords(:,1)-cellMedianLoc(1))<std(coords(:,1)),:);
    distances=sqrt((coordsTrimmed(:,2)-cellMedianLoc(2)).^2+(coordsTrimmed(:,3)-cellMedianLoc(3)).^2);
    cellArborDensityAvg=mean(distances);
    cellArborDensityStd=std(distances);
end

%get the ranges of the arbor vertices, convert to microns
function cellArborSpanAvg=getCellArborSpan(cid)
    matString=sprintf('%i.mat',cid);
    matDat=load([fvDir matString]);
    coords=matDat.fv.vertices(:,:);
    ranges=range(coords);
    cellArborSpanAvg=mean([ranges(2) ranges(3)])/10.2;
end

%get the area as modeled by ellipse
function cellArborArea=getCellArborArea(cid)
    matString=sprintf('%i.mat',cid);
    matDat=load([fvDir matString]);
    coords=matDat.fv.vertices(:,:);
    ranges=range(coords);
    cellArborArea=pi*ranges(2)*ranges(3);
end

%get the depth from the plane fits
function zDepth=getCellZdepth(cid,GCLplane,INLplane)
    location=getMedianLoc(cid);
    [gclz,inlz,zDepth]=getIPLdepth(location(1),location(2),location(3),GCLplane,INLplane);
end

%deprecated, just here for sanity checking
function zDepth=getCellZdepthOld(cid,ipl_bord_GCL,ipl_bord_INL)
    location=getMedianLoc(cid);
    groupSize=20;
    zDepth=getIPLdepthOld(location(1),location(2),location(3),groupSize,ipl_bord_GCL,ipl_bord_INL);
end

%get the centroid of a cid
function cellMedianLoc = getMedianLoc(cid)
    matString=sprintf('%i.mat',cid);
    matDat=load([fvDir matString]);
    cellMedianLoc=median(matDat.fv.vertices(:,:));
end

%get the depth of a point in the IPL from the fitted planes
function [zGCL,zINL,IPLdepth] = getIPLdepth(z,x,y,GCLplane,INLplane)
    zGCL=(-x*GCLplane.Parameters(2)-y*GCLplane.Parameters(3)-GCLplane.Parameters(4))/GCLplane.Parameters(1);
    zINL=(-x*INLplane.Parameters(2)-y*INLplane.Parameters(3)-INLplane.Parameters(4))/INLplane.Parameters(1);
    
    IPLdepth=abs(z-zINL)/abs(zINL-zGCL);

end

%old method using the points in the border region to calculate.
%deprecated. just here for sanity checks.
function IPLdepth = getIPLdepthOld(z,x,y,groupSize,ipl_bord_GCL,ipl_bord_INL)
    GCLbord=ipl_bord_GCL.fv.vertices(:,:);
    INLbord=ipl_bord_INL.fv.vertices(:,:);
    %get the distances
    distancesGCL=sum((GCLbord(:,2:3)-[x,y]).^2,2);
    distancesINL=sum((INLbord(:,2:3)-[x,y]).^2,2);
    %get the sorted distance idxs
    [distGCL,GCLidx]=sort(distancesGCL);
    [distINL,INLidx]=sort(distancesINL);
    %get mean z locatin of points in border
    zGCL=mean(GCLbord(GCLidx(1:groupSize),1));
    zINL=mean(INLbord(INLidx(1:groupSize),1));
    %calculate percentage
    IPLdepth=(zINL-z)/(zINL-zGCL);
end


end
