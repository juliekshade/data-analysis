data1 = dlmread('enrichment1_q3.csv');
 
phenotype = data1(1, :);
data1 = data1(2:1001, :);
A = zeros(100, 10);
 
for i = 1:100
    A(i, :) = [10*i-9:10*i];
end
 
allR = zeros(1, 1000);
for i = 1:1000
    R = corrcoef(data1(i, :),phenotype);
    allR(i) = R(1, 2);
end
 
[allR_sorted, ind] = sort(allR);
D_hat = ind(951:1000);
D_hat_complement = ind(1:950);
 
t_star = .05/100;
pvals = zeros(1,100);
 
for i = 1:100
    M = zeros(2, 2);
    M(1, 1) = sum(ismember(A(i, :), D_hat));
    M(1, 2) = 50 - M(1, 1);
    M(2, 1) = 10 - M(1, 1);
    M(2, 2) = 1000 - sum([M(1,1), M(1,2), M(2,1)]);
    [H,P, STATS] = fishertest(M);
    pvals(i) = P;
end
 
find(pvals < t_star)
 
[pvals_sorted, indx] = sort(pvals);
[~, rnk] = ismember(pvals,pvals_sorted);
q = .05;
n_diff = 0;
 
for i = 1:100
    p = pvals_sorted(i);
    if i >= (p*100)/q
        n_diff = n_diff + 1;
        diff(n_diff) = indx(i);
    end
end
