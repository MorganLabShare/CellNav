function[vals] = fitBounds(vals,span);


if ~exist('span','var')
    span = [.1 .5 .9 .8];
end


sVals = sort(vals,'ascend');
nR = length(vals);
cutOff = floor(nR * span(4)/2);
bot = sVals(cutOff+1);
top = sVals(end-cutOff);

if bot==top
    vals = vals;
else

    vals = vals-bot;
    vals = vals/(top-bot);
    vals = vals*(span(3)-span(1))+span(1);
end



