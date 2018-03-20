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
o1 = o1/size(X_c1,1)
o2 = o2/size(X_c2,1)
o3 = o1/size(X_c3,1)


% compute new variance as weighted average
sigma = (size(X_c1,1)*o1 + size(X_c2,1)*o2 + size(X_c3,1)*o3)./size(Y,1);

% compute desicion boundaries as log odds ratio
x1 = linspace(-8, 2);
x2 = linspace(-8, 2);
[X1,X2] = meshgrid(x1,x2);
p_x_c1 = mvnpdf([X1(:) X2(:)],u1,sigma);
p_x_c1 = reshape(p_x_c1,length(x2),length(x1));
p_x_c2 = mvnpdf([X1(:) X2(:)],u2,sigma);
p_x_c2 = reshape(p_x_c2,length(x2),length(x1));
p_x_c3 = mvnpdf([X1(:) X2(:)],u3,sigma);
p_x_c3 = reshape(p_x_c3,length(x2),length(x1));

p_c1_x = bsxfun(p_x_c1./3 ./(p_x_c1./3+p_x_c2./3+p_x_c3./3);
p_c2_x = p_x_c2./3 ./(p_x_c1./3+p_x_c2./3+p_x_c3./3);
p_c3_x = p_x_c3./3 ./(p_x_c1./3+p_x_c2./3+p_x_c3./3);


figure(1)
surf(x1,x2,p_c1_x,'b');
hold on;
surf(x1,x2,p_x_c2, 'r');
surf(x1,x2,p_x_c3, 'g');
title('Posterior probabilities for each class')
xlabel('x1')
ylabel('x2')
zlabel('p(