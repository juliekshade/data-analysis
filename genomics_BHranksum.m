data = dlmread('data_q1.csv');
 
Y = data(1, :);
X = data(2:1379, :);
n = 1378;
 
% rank transcripts for each person
for i = 1:size(X, 1)
    for j = 1:size(X, 2)
        rank = 1 + sum(X(i, :) < X(i, j));
        ranks(i, j) = rank;
    end
    W(i) = ranks(i, :) * Y';
end
 
u = sum(Y)*(116+1)/2;
o = sqrt(sum(Y)*(116-sum(Y))*(116+1)/12);
p_vals_norm = zeros(1, n);
 
for i = 1:1378
    p = normcdf(abs(W(i)-u)/o, 0, 1);
    p_vals_norm(i) = 2*(1-p);
end
 
for k = 1:1000
    for j = 1:size(X, 1)
        Y_perm = Y(randperm(length(Y)));
        W_perm(k, j) = ranks(j, :) * Y_perm';
    end
end
 
for i = 1:1378
    U = W(i);
    G_o = (1/1000)*sum(W_perm(:, i) <= U);
    p_vals_perm(i) = G_o;
end
 
figure(1)
histogram(p_vals_norm)
title('Histogram of P-values from Normal Approximation')
ylabel('Frequency')
xlabel('P-value')
 
figure(2)
histogram(p_vals_perm)
title('Histogram of P-values from Permutation Test')
ylabel('Frequency')
xlabel('P-value')
 
size(find(p_vals_perm < (0.01/1378)))
size(find(p_vals_norm < (0.01/1378)))
 
% BH estimator for q = {0.01, 0.05, 0.25}
pvals_sorted = sort(p_vals_perm);
[~, rnk] = ismember(p_vals_perm,pvals_sorted);
q = .01;
n_diff = 0;
 
for i = 1:1378
    p = pvals_sorted(i);
    if i >= (p*1378)/q
        n_diff = n_diff + 1;
    end
end
