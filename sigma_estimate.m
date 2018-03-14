clear all
close all

% define constant terms throughout all experiments
N = 2500; % total number of data points
w = [.2 .5 .1]'; % weight vector for underlying process
data_rand = rand(1, N); % random numbers from uniform distribution 
x = [ones(1, N); data_rand; data_rand.^2]; % x = [1 x x^2] from uniform distribution
bias_avg = zeros(6, 44); % used to hold average bias for each sigma
n_all = [5:5:100, 200:100:2500]; % sample sizes to compute average bias from
noise = normrnd(0, 1, 1, N); % noise drawn from N~(0, 1)

for o = 1:6 % repeat for 6 different standard deviations
    bias = zeros(500, 44); % store 500 trials for 44 different n
    noise_o = noise.*o; % multiply noise by sigma to get noise for this trial
    k = 1; % counter for number of trials
    for i = n_all % repeat for each sample size
        for j = 1:500 % perform 500 trials at each sample size
            indices = randi(2500, i, 1); % choose which data points to use
            X = x(:, indices); % define X for this trial
            y = w'*X + noise_o(indices); % calculate y with noise added
            o2_ML = (1/i)*(y-w'*X)*(y-w'*X)'; % calculate ML estimate of sigma
            diff = o2_ML - o.^2; % calcualte bias
            bias(j, k) = diff; % set term in bias matrix to the bias for this trial
        end
        k = k + 1; % increment counter for number of trials
    end
    bias_avg(o, :) = mean(bias); % find the mean of bias for all trials for this sigma
end

% plot results for all sigma 
figure(1)
hold on
for i = 1:6
    plot(n_all, bias_avg(i, :));
end
xlabel('Number of Data Points (n)');
ylabel('Bias in estimate of variance (o^2)');
title('Average Bias over 500 Trials vs. n');
legend('o = 1', 'o = 2', 'o = 3', 'o = 4', 'o = 5', 'o = 6');