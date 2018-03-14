data = dlmread('data3.txt',' ', 5, 0);

X = [ones(200,1), data(:, 1:2)];
y = data(:, 3);

w = (inv(X'*X))*X'*y;

y_hat = sum(bsxfun(@times, w', X), 2);

y_pred = zeros(200,1);
y_pred(find(y_hat > .5)) = 1;

pred_0 = X(find(y == 0), :);
pred_1 = X(find(y == 1), :);

x1 = linspace(-6, 10);
x2 = (1/w(3))*(.5 - w(1) - w(2)*x1);

figure(1)
hold on
scatter(pred_0(:, 2), pred_0(:, 3), 'filled', 'r')
scatter(pred_1(:, 2), pred_1(:, 3), 'filled', 'g')
plot(x1, x2, 'black')
xlabel('x1')
ylabel('x2')
legend('y = 0', 'y = 1', 'decision boundary', 'Location', 'southeast')
