% compute entropies H(x_b) and H(x_c), H(Y), H(x_b|y) and H(x_c|y)
clear all
close all

% read data
data = dlmread('entropy_q3.csv',',', 1, 1);
x_b = data(:, 2);
x_c = data(:, 3);
y = data(:, 1);

% compute probability distributions
x_b_prob = [size(find(x_b==0), 1); size(find(x_b==1), 1); size(find(x_b==2), 1)]./40;
x_c_prob = [size(find(x_c==0), 1); size(find(x_c==1), 1); size(find(x_c==2), 1)]./40;
x_c_prob = x_c_prob(find(x_c_prob ~= 0));
y_prob = [size(find(y==0), 1); size(find(y==1), 1)]./40;

% compute H(x_b), H(x_c), and H(y)
H_x_b = -sum(x_b_prob.*log2(x_b_prob))
H_x_c = -sum(x_c_prob.*log2(x_c_prob))
H_y = -sum(y_prob.*log2(y_prob))

% compute H(x_b|y)
xb_0 = x_b(find(y == 0));
xb_1 = x_b(find(y == 1));
x_b_prob_0 = [size(find(xb_0==0), 1); size(find(xb_0==1), 1); size(find(xb_0==2), 1)]./size(xb_0, 1);
x_b_prob_1 = [size(find(xb_1==0), 1); size(find(xb_1==1), 1); size(find(xb_1==2), 1)]./size(xb_1, 1);
H_x_b_0 = -sum(x_b_prob_0.*log2(x_b_prob_0));
H_x_b_1 = -sum(x_b_prob_1.*log2(x_b_prob_1));

H_xb_y = H_x_b_0*y_prob(1) + H_x_b_1*y_prob(2)

% Computer H(x_c|y)
xc_0 = x_c(find(y == 0));
xc_1 = x_c(find(y == 1));
x_c_prob_0 = [size(find(xc_0==0), 1); size(find(xc_0==1), 1); size(find(xc_0==2), 1)]./size(xc_0, 1);
x_c_prob_1 = [size(find(xc_1==0), 1); size(find(xc_1==1), 1); size(find(xc_1==2), 1)]./size(xc_1, 1);
x_c_prob_0 = x_c_prob_0(find(x_c_prob_0 ~= 0));
x_c_prob_1 = x_c_prob_1(find(x_c_prob_1 ~= 0));
H_x_c_0 = -sum(x_c_prob_0.*log2(x_c_prob_0));
H_x_c_1 = -sum(x_c_prob_1.*log2(x_c_prob_1));

H_xc_y = H_x_c_0*y_prob(1) + H_x_c_1*y_prob(2)

