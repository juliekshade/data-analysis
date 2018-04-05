clear all;
close all;

% import microarray and RNA seq data
rData = xlsread('rnaSeqStudyExprs.csv','B2:DI9224');
[~, rPheno, ~] = xlsread('rnaSeqStudyPheno.csv','Q2:Q110');
[~,rLabels,~] = xlsread('rnaSeqStudyExprs.csv','A2:A9224');

% convert phenotype labels to binary classification (1 = pos)
% this is inefficient sorry :(
for i = 1:size(rPheno,1)
    if rPheno{i} == 'POS'
        rPhenoNum(i) = 1;
    else 
        rPhenoNum(i) = 0;
    end
end

% aggregate into test and training datasets. use 20% of data for testing.
Xtest = rData(:,1:22);
Xtrain = rData(:,23:109);
Ytest = rPhenoNum(1:22);
Ytrain = rPhenoNum(23:109)';

R = nan(size(Xtrain,1),1);
% determine n most differentially expressed genes using RNAseq 
for i = 1:size(Xtrain,1)
    R_full = corrcoef(Xtrain(i,:),Ytrain);
    R(i) = R_full(1,2);
end

R = abs(R);
[R_sorted, ind] = sort(R, 'descend');

numgenes = [1:10:200, 300:100:1000]
a = 1
for i = numgenes
    D_hat = ind(1:i);
    X = [ones(size(Xtrain,2),1), Xtrain(D_hat,:)'];
    w = pinv(X'*X)*X'*Ytrain;
    Xtest_cond = [ones(size(Xtest,2),1),Xtest(D_hat,:)'];
    p_hat_test = 1./(1+exp(w'*Xtest_cond'));
    for t = 0:.01:1
        Yhat_test = zeros(1,size(Xtest,2));
        Yhat_test(find(p_hat_test >= t))=1;
        CP = classperf(Ytest,Yhat_test);
        sens(int16(t*100)+1,a) = CP.sensitivity;
        spec(int16(t*100)+1,a) = CP.specificity;
        acc(int16(t*100)+1,a) = CP.CorrectRate;
    end
    a = a+1;
end

[Mr,Ic] = max(acc)
[Mall,Ir] = max(Mr)

rLabels(ind(1))





