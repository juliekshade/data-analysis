clear all;
close all;

% import microarray and RNA seq data
rData = xlsread('rnaSeqStudyExprs.csv','B2:DI9224');
[~, rPheno, ~] = xlsread('rnaSeqStudyPheno.csv','Q2:Q110');
[~,rLabels,~] = xlsread('rnaSeqStudyExprs.csv','A2:A9224');

% convert phenotype labels to binary classification (1 = pos)
% this is really inefficient sorry :(
for i = 1:size(rPheno,1)
    if rPheno{i} == 'POS'
        rPhenoNum(i) = 1;
    else 
        rPhenoNum(i) = 0;
    end
end

% aggregate into test and training datasets. use 20% of data for testing.
Xtest = rData(

% determine n most differentially expressed genes using RNAseq and
% microarray

[p,h,stats] = ranksum(x,y)