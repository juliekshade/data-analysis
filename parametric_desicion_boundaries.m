close all
clear all

% read data
data = load('../classification.dat');
Y = data(:,1);
X = data(:,2:3);

% split data into classes
X_c1 = X(find(Y==1),:);
X_c2 = X(find(Y==2),:);
X_c3 = X(find(Y==3),:);

% parametric density estimate
d = 100;
p_x_c1 = zeros(d,d);
p_x_c2 = zeros(d,d);
p_x_c3 = zeros(d,d);
h = .5;
var = [1 0; 0 1];
x1 = linspace(min(X(:,1)), max(X(:,1)), d);
x2 = linspace(min(X(:,2)), max(X(:,2)), d);
[X1,X2] = meshgrid(x1,x2);
for i = 1:size(x1,2)
    for j = 1:size(x2,2)
        for k = 1:size(X_c1,1)
            p_x_c1(i,j) = p_x_c1(i,j) + mykernel(([x1(j) x2(i)] -X_c1(k,:))/h);
            p_x_c2(i,j) = p_x_c2(i,j) + mykernel(([x1(j) x2(i)] -X_c2(k,:))/h);
            p_x_c3(i,j) = p_x_c3(i,j) + mykernel(([x1(j) x2(i)] -X_c3(k,:))/h);

        end
    end
end

p_x_c1 = p_x_c1./(h^2*size(X_c1,1));
p_x_c2 = p_x_c2./(h^2*size(X_c2,1));
p_x_c3 = p_x_c3./(h^2*size(X_c3,1));

% plot conditional densities to confirm decision boundaries make sense
figure(1)
surf(X1,X2,p_x_c1, 'FaceColor','r');
hold on;
surf(X1,X2,p_x_c2, 'FaceColor','g');
surf(X1,X2,p_x_c3, 'FaceColor','b');
title('p(x|c=i) Using Kernel-Based Density Estimate');
xlabel('x1');
ylabel('x2');
legend('class 1', 'class 2', 'class 3', 'Location', 'eastoutside');

% compute and plot decision boundaries
figure(2)
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

function k = mykernel(u)
    k=(1/sqrt((2*pi)^size(u,2)))*exp(-.5*u*u');
end


