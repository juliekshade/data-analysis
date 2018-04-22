clear all
close all

% load image
image = load('brainimage.txt');
image = image./max(max(image));

% set initial parameters
P = [1/3 1/3 1/3];
mu = [.3 .5 .7];
sigma = [var(image(:)) var(image(:)) var(image(:))];

% perform n iterations of k means
for i = 1:10
    z = zeros(151,171,3);
    for j = 1:151
        for k = 1:171
            % assign class to each pixel
            [m, I] = min(abs(image(j,k)-mu));
            z(j,k,I) = 1;
        end
    end
    % update mean and variance, calculate log likelihood
    classcounts = sum(sum(z));
    mu = [(1/classcounts(:,:,1))*sum(sum(image.*z(:,:,1))),
        (1/classcounts(:,:,2))*sum(sum(image.*z(:,:,2))),
        (1/classcounts(:,:,3))*sum(sum(image.*z(:,:,3)))];
    
    sigma = [1/classcounts(:,:,1)*sum(sum(((image-mu(1)).^2).*z(:,:,1))),...
    1/classcounts(:,:,2)*sum(sum(((image-mu(2)).^2).*z(:,:,2))),...
    1/classcounts(:,:,3)*sum(sum(((image-mu(3)).^2).*z(:,:,3)))];

    loglikelihood(i) = -classcounts(:,:,1)/2*(log(2*pi*sigma(1)))-...
        1/(2*sigma(1))* sum(sum(((image-mu(1)).^2).*z(:,:,1)))...
        -classcounts(:,:,2)/2*(log(2*pi*sigma(2)))-...
        1/(2*sigma(2))* sum(sum(((image-mu(2)).^2).*z(:,:,2)))...
        -classcounts(:,:,3)/2*(log(2*pi*sigma(3)))-...
        1/(2*sigma(3))* sum(sum(((image-mu(3)).^2).*z(:,:,3)));
end

x = 0:.001:1;
% plot posterior distributions
figure(1)
plot(x, normpdf(x,mu(1),sqrt(sigma(1))))
hold on
plot(x, normpdf(x,mu(2),sqrt(sigma(2))))
plot(x, normpdf(x,mu(3),sqrt(sigma(3))))
title('Posterior Probabilites for Each Class')
xlabel('Intensity')
ylabel('P(class|intensity)')
legend('P(CSF|intensity)','P(GM|intensity)','P(WM|intensity)')

% plot log likelihood after each iteration
figure(2)
plot(loglikelihood)
title('Log Likelihood of Model After Each Iteration of K-Means')
xlabel('Iteration #')
ylabel('Log Likelihood')

% plot 3 images to show each class
figure(3)
imshow(z(:,:,1))
title('Pixels Classified as CSF')

figure(4)
imshow(z(:,:,2))
title('Pixels Classified as GM')

figure(5)
imshow(z(:,:,3))
title('Pixels Classified as WM')

