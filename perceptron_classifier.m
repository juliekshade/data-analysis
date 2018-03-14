clear all;
close all;

%initialize feature matric
feat = zeros(2000, 3);

%open files containing training data for reading
fid_zeros = fopen('data0', 'r');
fid_ones = fopen('data1', 'r');

%set correct output vector (-1 = 0, 1 = 1)
y = [ones(1000, 1).*-1; ones(1000, 1)];

for i =1:1000
    [t0, N] = fread(fid_zeros, [28 28], 'uchar');   % Read one image from zeros file
    [t1, N] = fread(fid_ones, [28 28], 'uchar');    % Read one image from ones file
    t0 = double(logical(t0));                       % convert images to binary numbers
    t1 = double(logical(t1));
    feat(i, 1) = sum(sum(t0))/784;                  %average of all pixels in image
    feat(i+1000, 1) = sum(sum(t1))/784;
    feat(i, 2) = sum(sum(t0(13:15, 13:15)))/9;      %average of 9 pixels in center of image
    feat(i+1000, 2) = sum(sum(t1(13:15, 13:15)))/9;
    feat(i, 3) = size(find(t0(:, 1:14) == fliplr(t0(:, 15:28))), 1)/392; % percent symmetry (left vs right side)
    feat(i+1000, 3) = size(find(t1(:, 1:14) == fliplr(t1(:, 15:28))), 1)/392;
end

%initialize weight vector and vector to store number of wrong predictions
w = zeros(1, 3);
wrong_pred = zeros(500,1);

%Update weight vector based on incorrect predicitons from 200 randomly
%selected training examples 500 times
for i = 1:500
    y_hat = sign(sum(bsxfun(@times,feat,w), 2));    %calculate y_hat = sign[w'x]
    err = y - y_hat;                                %find error (0 if y == y_hat)
    r = randperm(2000,200);                         %randomly select 200 training examples
    x = feat(r, :);
    y_test = y(r);
    err_test = err(r) ;
    wrong_pred(i) = nnz(err_test);                  %count number of wrong predictions
    for j = 1:200
        if err_test(j) ~= 0
            w = w + y_test(j)*x(j, :);              %update weight vector if nonzero error
        end
    end
end

%Plot all results
edges = 0:.05:1;
l = cell(1,2);
l{1}='Zeros'; l{2}='Ones';     

figure(1)
hold on
h1 = histcounts(feat(1:1000,1),edges);
h2 = histcounts(feat(1001:2000,1),edges);
h = bar(edges(1:end-1),[h1; h2;]');
xlim([0 1]);
legend(h,l);
xlabel('Average of All Pixels in Image');
ylabel('Number of Images');
title('Feature #1');

figure(2)
hold on;
h1 = histcounts(feat(1:1000,2),edges);
h2 = histcounts(feat(1001:2000,2),edges);
h = bar(edges(1:end-1),[h1; h2;]');
xlim([0 1]);
legend(h,l);
xlabel('Average of Center 9 Pixels in Image');
ylabel('Number of Images');
title('Feature #2');

figure(3)
hold on;
h1 = histcounts(feat(1:1000,3),edges);
h2 = histcounts(feat(1001:2000,3),edges);
h = bar(edges(1:end-1),[h1; h2;]');
xlim([0 1]);
legend(h,l);
xlabel('Percent Symmetry of Image (Left-Right)');
ylabel('Number of Images');
title('Feature #3');

figure(4)
hold on
plot(wrong_pred);
xlabel('Perceptron Iteration Number')
ylabel('Incorrect Predictions (Out of 200)')
title('Perceptron Classification Using Three Features')
