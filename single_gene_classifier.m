clear all
close all

class = dlmread('class_q2.csv',',',1,1);
feat = dlmread('features_q2.csv',',',1,1);

% use import tool to import first column of features table as text
% do wilcoxon rank sum test to find top 100 differentially expressed genes
pvals = nan(20500,1);
for i=1:20500
    pvals(i) = ranksum(feat(i,:),class);
end

[sorted, I] = sort(pvals);
%featuresq2(I(1:10), 'VarName1')
top100feat = feat(I(1:100),:);

% split into training and test data
[classsort, Ic] = sort(class);
featsort = top100feat(:,Ic);
n = size(class,1);
np = sum(class);
training_feat = [featsort(:,1:((n-np)/2)), featsort(:,(n-np):(n-np)+(np/2))];
training_class = [classsort(1:((n-np)/2)); classsort((n-np):(n-np)+(np/2))];
test_feat = [featsort(:,((n-np)/2):(n-np)-1), featsort(:,(n-np)+(np/2)+1:n)];
test_class = [classsort(((n-np)/2):(n-np)-1); classsort((n-np)+(np/2)+1:n)];

% train a single gene classifier for each of the top 100 genes
tmin = floor(min(min(training_feat)));
tmax = floor(max(max(training_feat)));
T = tmin:.01:tmax;
training_err = nan(100,size(T,2));
for i = 1:100
    X = training_feat(i,:)';
    for t = T
        pred_class = (X > t);
        training_err(i,int16((t-tmin)/.01 + 1)) = sum(abs(training_class-pred_class))/size(X,1);
    end
end

%find k,t pair that gives the lowest training error
[Mkt, Ikt] = min(training_err(:));
[k_min, t_min_ind] = ind2sub(size(training_err), Ikt);
k_min
t_min = T(t_min_ind)

% evaluate the classifier on the test dataset
pred_class_test = (test_feat(k_min,:) > t_min)';
err = sum(abs(test_class - pred_class_test))/size(test_feat,2);

% repeat, using the training set to pick the top 100 features

% split into training and test data
[classsort, Ic] = sort(class);
featsort = feat(:,Ic);
n = size(class,1);
np = sum(class);
training_feat = [featsort(:,1:((n-np)/2)), featsort(:,(n-np):(n-np)+(np/2))];
training_class = [classsort(1:((n-np)/2)); classsort((n-np):(n-np)+(np/2))];
test_feat = [featsort(:,((n-np)/2):(n-np)-1), featsort(:,(n-np)+(np/2)+1:n)];
test_class = [classsort(((n-np)/2):(n-np)-1); classsort((n-np)+(np/2)+1:n)];

% do wilcoxon rank sum test to find top 100 differentially expressed genes
pvals = nan(20500,1);
for i=1:20500
    pvals(i) = ranksum(training_feat(i,:),training_class);
end

[sorted, I] = sort(pvals);
I(1:10)
featuresq2(I(1:10), 'VarName1')
training_feat = training_feat(I(1:100),:);

% train a single gene classifier for each of the top 100 genes
tmin = floor(min(min(training_feat)));
tmax = floor(max(max(training_feat)));
T = tmin:.01:tmax;
training_err = nan(100,size(T,2));
for i = 1:100
    X = training_feat(i,:)';
    for t = T
        pred_class = (X > t);
        training_err(i,int16((t-tmin)/.01 + 1)) = sum(abs(training_class-pred_class))/size(X,1);
    end
end

% find k,t pair that gives the lowest training error
% k_min, t_min should be used for classification
[Mkt, Ikt] = min(training_err(:));
[k_min, t_min_ind] = ind2sub(size(training_err), Ikt);
t_min = T(t_min_ind);

% evaluate the classifier on the test dataset, using top 100 from training
test_feat = test_feat(I(1:100),:);
pred_class_test = (test_feat(k_min,:) > t_min)';
err = sum(abs(test_class - pred_class_test))/size(test_feat,2);