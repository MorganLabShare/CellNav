function[res] = bootMedInt(a,intrv)
%%Stats, find interval (95% by default) including 95% of the bootstraped
%%median values
%%Bootstrapping is performed with replacemnt
%%results are median, lower bound, upper bound



if ~exist('interv','var')
    intrv = 0.95;
end
reps = 10000;

n = size(a,2);
p = size(a,1);

realMed = median(a,2);

y = repmat([1:p]',[1 n]);
randMed = zeros(p,reps);

for r = 1:reps

    x = ceil(rand(p,n)*n);
    ind = sub2ind([p n],y,x);
    randVals = a(ind);
    randMed(:,r) = median(randVals,2);


end


sortRand = sort(randMed,2,'ascend');


b = floor(reps * (1-intrv));

lowBnd = sortRand(:,b);
highBnd = sortRand(:,end-b+1);

res = cat(2,realMed, lowBnd,  highBnd);









