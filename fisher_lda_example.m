clear all
close all

% create vector of luminosity
x = [140:.1:200];
% calculate given pdf for p(x|bass) and p(x|salmon)
p_x_bass = .6.*normpdf(x,165,7) + + .4.*normpdf(x,180,7);
p_x_salmon = .4.*normpdf(x,160,8) + .6.*normpdf(x,180,3);
% calculate p(x) marginal distribution
p_x = .4.*p_x_bass + .6.*p_x_salmon;
% calculate p(bass|x) and p(salmon|x) posterior probabilities
p_bass_x = bsxfun(@rdivide, .4.*p_x_bass, p_x);
p_salmon_x = ones(1,601) - p_bass_x;
% calculate variance of posterior probability binomial distribution
var_p_c_x = p_bass_x.*p_salmon_x;

figure(1)
plot(x, p_x_bass)
hold on;
plot(x, p_x_salmon)
xlabel('x')
ylabel('P(x|c=species)')
title('Pdf of x given c=bass and c=salmon')
legend('c=bass', 'c=salmon')

figure(2)
plot(x,p_x)
xlabel('x')
ylabel('P(x)')
title('Pdf of x')

figure(3)
plot(x, p_bass_x)
hold on;
plot(x, p_salmon_x)
xlabel('x')
ylabel('P(c=species|x)')
title('Pdf of species given x')
legend('c=bass', 'c=salmon')

figure(4)
plot(x, var_p_c_x)
xlabel('x')
ylabel('var(P(c=species|x))')
title('Variance of pdf of species given x')
