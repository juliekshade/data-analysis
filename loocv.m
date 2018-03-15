close all 
clear all

class = dlmread('class_q1.csv');
feat = dlmread('features_q1.csv');

% find 100 features with highest correlation
correlations = abs(corr(feat, class));
[sorted, I] = sort(correlations, 'descend');
top100feat = feat(:,I(1:100));

err = 0;

% cross validation with k = 50 (LOOCV)
for k = 1:50
    train = top100feat;
    test = train(k,:);
    classtest = class(k,:);
    classtrain = class;
    classtrain(k,:) = [];
    train(k,:) = [];
    D  = sqrt(sum((bsxfun(@minus, train', test')) .^ 2));
    [M, I] = min(D);
    pred = classtrain(I);
    err = err + abs(classtest-pred)/50;
end

disp(err)

% cross validation with k = 50 (LOOCV), reestimating top100 features each time
err = 0
for k = 1:50
    feattrain = feat;
    test = feat(k,:);
    feattrain(k,:) = [];
    classtrain = class;
    classtest = class(k,:);
    classtrain(k,:) = [];
    correlations = abs(corr(feattrain, classtrain));
    [sorted, Icorr] = sort(correlations, 'descend');
    top100feat = feattrain(:,Icorr(1:100));
    D  = sqrt(sum((bsxfun(@minus, top100feat', test(:,Icorr(1:100))')) .^ 2));
    [M, I] = min(D);
    pred = classtrain(I);
    err = err + abs(classtest-pred)/50;
end

disp(err)