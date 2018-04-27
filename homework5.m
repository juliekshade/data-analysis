clear all
close all
% simulation GWBP
EN = [1]
rng(1) % for reproducability
p_2 = .52

% analytical answer is last value in this vector! P(N(15) > 0)
p_n15 = [0];
for i = 2:16
    p_n15(i) = .48 + .52*(p_n15(i-1)^2);
end
p_n15 = 1-p_n15;
p_n15(16)

% simulate GWBP 1000 times to calculate P(N(15) > 0)
N = [ones(1000,1), zeros(1000,200)];
for n = 1:1000
    for t = 2:201
        n_offspring = 0;
        if N(n,t-1) > 0
            for j = 1:N(n,t-1)
                if rand(1) < p_2 % cell j out of J has 2 daughter cells
                    n_offspring = n_offspring + 2;
                end
            end
        end
        N(n,t) = n_offspring;
        EN(t) = 1.04^(t-1);
    end 
end

figure(1)
plot(0:1:200, mean(N))
hold on
plot(0:1:200,EN)
xlim([0 200])
xlabel('Generation Number')
ylabel('Analytical and Simulated N(t)')
legend('Mean(N(t)) over 1000 GWBP simulations','E[N(t)]')
title('Comparison of Analytical and Simulated GWBP')

% find probability N(15) > 0
sum(N(:,16)>0)/1000

% find probability of extinction
p_n200 = [0];
for i = 2:201
    p_n200(i) = .48 + .52*(p_n200(i-1)^2);
end
p_n200(201)
sum(N(:,201)==0)/1000

% find expected value given non-extinction
nonextinct = sum(N(:,201)>0) % number that don't go extinct
sum(N(:,201))/nonextinct % average value given non extinction