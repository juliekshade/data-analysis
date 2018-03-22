clear all
close all

% load data and define initial weights
data = load('classification_IRLS.dat');
Y = data(:,1);
X = [ones(size(Y)), data(:,2:3)];
w = [0;0;0];

% do iteratively reweighted least squares for 5 iterations
for iter = 1:5
    q = myq(w,X);
    Q = diag(q.*(1-q));
    mse(iter) = (1/size(Y,1))*sum((Y-q).^2);
    w = w + inv(X'*Q*X)*X'*(Y-q);
end

% plot the mean squared classification error for each iteration
figure(1)
plot(1:5,mse)
title('Mean Squared Error per IRLS Iteration')
xlabel('Iteration')
ylabel('MSE')

% plot the points by class and the decision boundary
x1 = linspace(-6.5, 2.5)
figure(2)
plot(x1, (1/w(3))*(-w(1) - w(2).*x1))
hold on;
scatter(X(1:(size(Y,1)-sum(Y)),2),X(1:(size(Y,1)-sum(Y)),3), 'r')
scatter(X((sum(Y)-1:size(Y,1)),2),X((sum(Y)-1:size(Y,1)),3), 'g')
title('Data Points and Classification Line')
xlabel('x1')
ylabel('x2')
legend('Decision Boundary', 'class = 0', 'class = 1')

function q = myq(w,X)
    q = zeros(size(X,1),1);
    for i = 1:size(X,1)
        q(i) = 1/(1+exp(-w'*X(i,:)'));
    end
end