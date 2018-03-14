clear all
close all

rng(4)
nDataPoints = 800;
x0 = [0; 1];
A_1 = [0.5 0; 0 0.3]; A_2 = eye(2); A_3 = eye(2); A_4 = eye(2);
e_x_1 = eye(2); e_x_2 = [25 0; 0 25]; e_x_3 = eye(2); e_x_4 = eye(2);
e_s_1 = eye(2); e_s_2 = eye(2); e_s_3 = eye(2); e_s_4 = [25 0; 0 25];
e_y_1 = 1; e_y_2 = 1; e_y_3 = 25; e_y_4 = 1;
H = [1 1];
P_all = cell([1 nDataPoints]);
P_all{1} = [1 0; 0 1];
K_all = nan(2, nDataPoints);
x_kalman = nan(2, nDataPoints);
x_kalman(:, 1) = x0;
x_LMS = nan(2, nDataPoints);
x_LMS(:, 1) = x0;
LMS_gain = nan(2, nDataPoints);
LMS_gain(:,1) = [0;0]';
x_all = nan(2, nDataPoints);
y_all = nan(1, nDataPoints);
x_all(:,1) = A_1 * x0 + normrnd(zeros(2,1), sqrt([e_x_1(1,1); e_x_1(2,2)]) );
y_all(:,1) = H * (x_all(:,1) + normrnd(zeros(2,1), sqrt((x_all(:,1).^2) .* [e_s_1(1,1); e_s_1(2,2)]) )) + normrnd(zeros(1,1), sqrt(e_y_1) );
for i = 2 : nDataPoints+1
    %% Define State Parameters
    if (i < 201)
        A = A_1; e_x = e_x_1; e_s = e_s_1; e_y = e_y_1;
    elseif (i < 401)
        A = A_2; e_x = e_x_2; e_s = e_s_2; e_y = e_y_2;
    elseif (i < 601)
        A = A_3; e_x = e_x_3; e_s = e_s_3; e_y = e_y_3;
    elseif (i < 801)
        A = A_4; e_x = e_x_4; e_s = e_s_4; e_y = e_y_4;
    end
    %% 
    x_all(:,i) = A * x_all(:,i-1) + normrnd(zeros(2,1), sqrt([e_x(1,1); e_x(2,2)]) );
    % calculate y without signal dependent noise
    y_all(:,i) = H * (x_all(:,i) + normrnd(zeros(2,1), sqrt([e_s(1,1); e_s(2,2)]) )) + normrnd(zeros(1,1), sqrt(e_y) );
    K_all(:, i) = P_all{i-1}*H'.*(H*P_all{i-1}*H' + e_y + e_s(1,1) + e_s(2,2))^-1;
    P_all{i-1} = P_all{i-1}*(eye(2, 2) - H'*K_all(:,i)');
    P_all{i} = A*P_all{i-1}*A' + e_x;
    x_kalman(:, i) = x_kalman(:,i-1) + K_all(:,i)*(y_all(:,i) - H*x_kalman(:,i-1));
    y_kalman(:, i) = H*x_kalman(:, i);
    x_LMS(:,i) = x_LMS(:,i-1) + (H/(H*H'))'*((y_all(:,i)-H*x_LMS(:,i-1)));
    LMS_gain(:,i) = (H/(H*H'))';
    y_LMS(:, i) = H*x_LMS(:,i);
end

figure(1);hold on
plot(y_all);
plot(y_kalman);
title('Predicted and Actual Output y using Kalman filter');
xlabel('Iteration Number');
ylabel('Output (y)');
legend('y all', 'y kalman');
xlim([0 800])

figure(2);hold on
plot(y_all);
plot(y_LMS);
title('Predicted and Actual Output y using LMS');
xlabel('Iteration Number');
ylabel('Output (y)');
legend('y all', 'y LMS');
xlim([0 800])

figure(3);hold on
plot(K_all(1,2:801));
plot(K_all(2,2:801));
plot(LMS_gain(1,:));
plot(LMS_gain(2,:));
title('Kalman and LMS Gain for Each Iteration');
xlabel('Iteration Number');
ylabel('Gain');
legend('Kalman gain(1)', 'Kalman gain(2)', 'LMS gain(1)', 'LMS gain(2)');
xlim([0 800])

figure(5);hold on
plot(x_all(1,:))
plot(x_kalman(1,:))
plot(x_LMS(1,:))
title('Kalman and LMS Estimates of x(1)');
xlabel('Iteration Number');
ylabel('x(1)');
legend('actual x', 'Kalman estimate x(n|n)', 'LMS estimate x_hat(n)');

figure(6);hold on
plot(x_all(2,:))
plot(x_kalman(2,:))
plot(x_LMS(2,:))
title('Kalman and LMS Estimates of x(2)');
xlabel('Iteration Number');
ylabel('x(2)');
legend('actual x', 'Kalman estimate x(n|n)', 'LMS estimate x_hat(n)');
