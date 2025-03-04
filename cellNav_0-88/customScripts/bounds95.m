function[ci] = bounds95(vals,interval)
%%find bounds that include at least 'interval' fraction of the values

if ~exist('interval','var')
    interval = 0.95;
end
if isempty(vals)
    ci = [nan nan nan interval];
else

    sVals = sort(vals,'ascend');
    nVal = length(vals);

    cutOff = floor(nVal*(1-interval)/2);

    if (cutOff<0) | (cutOff>(nVal/2))
        disp(spirntf('error - interval must be between 0 and 1'))
        ci = [nan nan nan interval];
    else
        ci = [sVals(cutOff+1) median(vals) sVals(end-cutOff) interval];
    end

end










