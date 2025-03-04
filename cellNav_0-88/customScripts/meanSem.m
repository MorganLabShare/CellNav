function[ci] = meanSEM(vals)
%%SEM around mean, ci = [meanVal-sem meanVal meanVal+sem sem];

if isempty(vals)
    ci = [nan nan nan];
else
    meanVal = mean(vals);
    sem = std(vals)/sqrt(length(vals));
    ci = [meanVal-sem meanVal meanVal+sem sem];
end