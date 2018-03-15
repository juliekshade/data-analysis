clear all
close all

class = dlmread('class_q2.csv',',',1,1);
feat = dlmread('features_q2.csv',',',1,1);

% do wilcoxon rank sum test to find top 100 differentially expressed genes
pvals = nan(20500,1);
for i=1:20500
    pvals(i) = ranksum(feat(i,:),class);
end

[sorted, I] = sort(pvals);
%featuresq2(I(1:10), 'VarName1')
top100feat = feat(I(1:100),:);

% split into test data and training data
[classsort, Ic] = sort(class);
featsort = top100feat(:,Ic);
n = size(class,1);
np = sum(class);
training_feat = [featsort(:,1:((n-np)/2)), featsort(:,(n-np):(n-np)+(np/2))];
training_class = [classsort(1:((n-np)/2)); classsort((n-np):(n-np)+(np/2))];
test_feat = [featsort(:,((n-np)/2):(n-np)-1), featsort(:,(n-np)+(np/2)+1:n)];
test_class = [classsort(((n-np)/2):(n-np)-1); classsort((n-np)+(np/2)+1:n)];

% find most differentially expressed features among top 100 using training
% set
pvals = nan(100,1);
for i=1:100
    pvals(i) = ranksum(training_feat(i,:),training_class);
end
[sorted_tr, I_tr] = sort(pvals);

% plot ROC curve using that feature for both test and training datasets
tmin = floor(min(min(training_feat)));
tmax = floor(max(max(training_feat)));
T = tmin:.001:tmax;
X = training_feat(I_tr(1),:)';
sensitivity = nan(size(T));
specificity = nan(size(T));
for t = T
    pred_class = (X > t);
    CP = classperf(training_class, pred_class, 'Positive', 1, 'Negative', 0);
    sensitivity(int16((t-tmin)/.001 + 1)) = CP.sensitivity;
    specificity(int16((t-tmin)/.001 + 1)) = 1-CP.specificity;
end

figure(1)
plot(specificity, sensitivity)
hold on;
title('ROC');
xlabel('1 - Specificity');
ylabel('Sensitivity');

X = test_feat(I_tr(1),:)';
sensitivity_test = nan(size(T));
specificity_test = nan(size(T));
for t = T
    pred_class = (X > t);
    CP = classperf(test_class, pred_class, 'Positive', 1, 'Negative', 0);
    sensitivity_test(int16((t-tmin)/.001 + 1)) = CP.sensitivity;
    specificity_test(int16((t-tmin)/.001 + 1)) = 1-CP.specificity;
end

plot(specificity_test, sensitivity_test)
legend('training', 'test')

[u, I] = unique(specificity);
AUC_train = sum(sensitivity(I)*u(2))
[u, I] = unique(specificity_test);
AUC_train = sum(sensitivity_test(I)*u(2))