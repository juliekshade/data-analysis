clear all
close all

% read data
data = dlmread('BRCA1_q4.csv');
X = data(2:1659, :);
y = data(1, :);
y_prob = histc(y,unique(y))./118;

I = zeros(1658, 1);
for i = 1:1658
    x = X(i, :);
    x_prob = histc(x,unique(x))./118;
    H_x = -sum(x_prob.*log2(x_prob));
    x_0 = x(find(y==0));
    x_1 = x(find(y==1));
    x_prob_0 = histc(x_0,unique(x_0))./size(x_0, 2);
    x_prob_1 = histc(x_1,unique(x_1))./size(x_1, 2);
    H_x_y = -sum(x_prob_0.*log2(x_prob_0))*y_prob(1) -sum(x_prob_1.*log2(x_prob_1))*y_prob(2) ;
    I(i) = H_x - H_x_y;
end

[I_sort, ind] = sort(I,'descend');
ind(1:10)'