close all
clear all

% read data
data = load('classification.dat');
Y = data(:,1);
X = data(:,2:3);

% split data into classes
X_c1 = X(find(Y==1),:);
X_c2 = X(find(Y==2),:);
X_c3 = X(find(Y==3),:);

% use ML estimate to compute mean and varaiance
u1 = (1/size(X_c1,1))*sum(X_c1,1);
u2 = (1/size(X_c2,1))*sum(X_c2,1);
u3 = (1/size(X_c3,1))*sum(X_c3,1);
o1 = zeros(2,2);
o2 = zeros(2,2);
o3 = zeros(2,2);
for i = 1:size(X_c1,1) % since all classes have same # data points
    o1 = o1 + (X_c1(i,:)-u1)'*(X_c1(i,:)-u1);
    o2 = o2 + (X_c2(i,:)-u2)'*(X_c2(i,:)-u2);
    o3 = o3 + (X_c3(i,:)-u3)'*(X_c3(i,:)-u3);
end
o1 = o1/size(X_c1,1);
o2 = o2/size(X_c2,1);
o3 = o3/size(X_c3,1);

% compute new variance as weighted average
sigma = (size(X_c1,1)*o1 + size(X_c2,1)*o2 + size(X_c3,1)*o3)./size(Y,1);

% compute the decision boundaries, assuming unequal variance
x1 = linspace(min(X(:,1)), max(X(:,1)), 100);
x2 = linspace(min(X(:,2)), max(X(:,2)), 100);
[X1,X2] = meshgrid(x1,x2);
p_x_c1 = mvnpdf([X1(:) X2(:)],u1,o1);
p_x_c1 = reshape(p_x_c1,length(x2),length(x1));
p_x_c2 = mvnpdf([X1(:) X2(:)],u2,o2);
p_x_c2 = reshape(p_x_c2,length(x2),length(x1));
p_x_c3 = mvnpdf([X1(:) X2(:)],u3,o3);
p_x_c3 = reshape(p_x_c3,length(x2),length(x1));

% compute posterior probabilities for each class
p_c1_x = (p_x_c1./3) ./(p_x_c1./3+p_x_c2./3+p_x_c3./3);
p_c2_x = (p_x_c2./3) ./(p_x_c1./3+p_x_c2./3+p_x_c3./3);
p_c3_x = (p_x_c3./3) ./(p_x_c1./3+p_x_c2./3+p_x_c3./3);

% compute and plot decision boundaries
figure(1)
b12 = contour(X1, X2, log(p_x_c1./p_x_c2) ,[0 0], 'r');
hold on;
b23 = contour(X1, X2, log(p_x_c2./p_x_c3) ,[0 0], 'g');
b31 = contour(X1, X2, log(p_x_c3./p_x_c1) ,[0 0], 'b');
scatter(X_c1(:,1), X_c1(:,2), 'r');
scatter(X_c2(:,1), X_c2(:,2), 'g');
scatter(X_c3(:,1), X_c3(:,2), 'b');
title('Data and Decision Boundaries for Each Class');
xlabel('x1');
ylabel('x2');
legend('class 1-class 2', 'class 2-class 3', 'class 3-class 1', ...
    'class 1', 'class 2', 'class 3', 'Location', 'eastoutside');

% plot conditional densities to confirm decision boundaries make sense
figure(2)
surf(X1,X2,p_x_c1, 'FaceColor','r');
hold on;
surf(X1,X2,p_x_c2, 'FaceColor','g');
surf(X1,X2,p_x_c3, 'FaceColor','b');
title('p(x|c=i)');
xlabel('x1');
ylabel('x2');
legend('class 1', 'class 2', 'class 3', 'Location', 'eastoutside');
