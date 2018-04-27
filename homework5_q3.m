clear all
close all
rng(1)

p_normDie = 99/200;
p_normSurvive = 101/200;
p_oneMutant = 1/5000;
p_mutantDie = 20/41;
p_mutantSurvive = 21/41;

T = zeros(1,1000);
for sim = 1:1000
    disp(['Are we there yet? ' num2str(sim/1000*100,'%.2f') '% there, stop asking >:('])
    N = zeros(1, 501); % initialize matrix to store number for each gen
    N(1,1) = 100; % start with 100 cells
    clones = 0;
    for t = 2:501
        num_normOffspring = 0;
        % calculate number of mutant offspring and normal offspring from
        % healthy cells N0(t-1)
        for i = 1:N(1,t-1) % update healthy offspring if needed
            if N(1,t-1) > 0 % if not extinct
                if rand(1) < p_normSurvive % cell j out of J has 2 daughter cells
                    if rand(1) < p_oneMutant % one offspring is mutant
                        num_normOffspring = num_normOffspring + 1;
                        N(clones+2,t) = 1; % initialize a clone
                        clones = clones + 1;
                    else
                        num_normOffspring = num_normOffspring + 2;
                    end
                end
            end
        end
        N(1,t) = num_normOffspring;
        for j = 1:clones  % update mutant offspring counts if they exist
            num_mutantOffspring = 0;
            if N(j+1,t-1) > 0 % if not extinct and not created this generation
                for k = 1:N(j+1,t-1)
                    if rand(1) < p_mutantSurvive % cell j out of J has 2 daughter cells
                        num_mutantOffspring = num_mutantOffspring + 2;
                    end
                end
                N(j+1,t) = num_mutantOffspring;
                if (num_mutantOffspring > 100000) && (T(sim) == 0)
                    T(sim)=t;
                end
            end
        end
    end
end

prob = zeros(1,500);
for i = 1:1000
    if T(i) > 0
        prob(T(i):end) = prob(T(i):end)+1;
    end
end
prob = prob./1000;

figure(1)
plot(0:2:500*2, [0 prob])
title('P(T<=t), Time of Cancer Incidence')
xlabel('Months')
ylabel('P(T<=t)')