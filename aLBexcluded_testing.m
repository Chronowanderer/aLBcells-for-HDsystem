% aLB-HD (without aLB cells) learning simulation - Testing

%% Parameters settings
Operation_Dynamic = 1;
if Operation_Dynamic
    decay_rate_dRSC_test = decay_rate_dRSC;
    decay_rate_gRSC_test = decay_rate_gRSC;
    decay_rate_HD_test = decay_rate_HD;
else
    decay_rate_dRSC_test = 1;
    decay_rate_gRSC_test = 1;
    decay_rate_HD_test = 1;
end

start_testing_time = time - 60 * 0;
end_testing_time = start_testing_time + 60 * 1;
bar_beginning = fix(start_testing_time / dt);
T_bar = start_testing_time : dt : end_testing_time;
bar_time = length(T_bar);
cycle = 10;
vlcty_test = 360 * cycle / (end_testing_time - start_testing_time);
angle_merging = 1;

%% Testing preparation
Trajectory_test = zeros(1, bar_time);
Velocity_test = zeros(1, bar_time);
Acceleration_test = zeros(1, bar_time);
Gamma_test = zeros(1, bar_time);

bar_gap = angle_merging;
bar_angle_gap = bar_gap * angle_gap;
Angle_bar = -180 : bar_angle_gap : (180 - bar_angle_gap);
bar_bin = length(Angle_bar);

Trajectory_test(1) = Trajectory(bar_beginning) * 1; 
for jj = 1 : (bar_time - 1)
    Trajectory_test(jj + 1) = AngularDiff(Trajectory_test(jj) + vlcty_test * dt, 0);
end
% Trajectory_test = Trajectory(bar_beginning : (bar_beginning + bar_time - 1)); 
Velocity_test = Differentiation_ascending(Trajectory_test, dt);
Acceleration_test = Differentiation_ascending(Velocity_test, dt);
Gamma_test = -time_constant_HD .* (Velocity_test + rho .* Acceleration_test);
Gamma_test = Gamma_test + asyweightstrength_noise_scale .* randn(1, bar_time);

%% Testing simulation preparation
U_gRSC_test = zeros(bar_time, N_bin);
F_gRSC_test = zeros(bar_time, N_bin);
U_dRSC_test = zeros(bar_time, N_bin);
F_dRSC_test = zeros(bar_time, N_bin);
U_HD_test = zeros(bar_time, N_bin);
F_HD_test = zeros(bar_time, N_bin);
F_visual_test = zeros(bar_time, N_input);
Cue_test = zeros(bar_time, N_env);
Strength_test = zeros(bar_time, N_env);
InternalR_HD_test = zeros(1, bar_time);

W_HDring_test = zeros(bar_time, N_bin);
W_HD_test = zeros(N_bin, N_bin);
W_HDring_test(1, :) = W_stable + Gamma_test(1) .* dW_stable;
InternalR_HD_test(1) = AngularMean(Angle, F_HD_test(1, :));

U_gRSC_test(1, :) = U_gRSC(1, :);
F_gRSC_test(1, :) = F_gRSC(1, :);
F_HD_test(1, :) = F_HD(1, :);
U_HD_test(1, :) = U_HD(1, :);
F_dRSC_test(1, :) = F_dRSC(1, :);
U_dRSC_test(1, :) = U_dRSC(1, :);

Bar_dRSC_firing = zeros(bar_bin, N_bin);
Bar_gRSC_firing = zeros(bar_bin, N_bin);
Bar_HD_firing = zeros(bar_bin, N_bin);
Bar_cal = zeros(1, bar_bin);
    
%% Testing simulation
for jj = 1 : bar_time
    present_time = start_testing_time + jj * dt;
    present_time_temp = fix(present_time / Plagmatism_time);
    if condition_env == (N_env + 1)
        present_env = mod(present_time_temp, N_env) + 1;
    else
        present_env = condition_env;
    end
    for k = 1 : N_cue
        Cue_test(jj, k) = AngularDiff(Cue_Init(present_env, k), Trajectory_test(jj));
        Strength_test(jj, k) = Strength_Init(present_env, k);
        F_visual_shift = circshift(F_visual_feature(k, :), [0 fix(Cue_test(jj, k) / angle_gap)]);
        F_visual_test(jj, ((k - 1) * N_bin + 1) : (k * N_bin)) = F_visual_shift .* Strength_test(jj, k);
    end
    
    if jj == bar_time
        Ftest_HD_final = F_HD_test(jj - 1, :);
        Ftest_HD_fmax = max(Ftest_HD_final);
        Ftest_HD_final = Ftest_HD_final ./ Ftest_HD_fmax .* 1;
        Ftest_HD_fFWHM = sum(Ftest_HD_final >= .5)
        continue;
    end
    
    U_dRSC_test(jj + 1, :) = U_dRSC_test(jj, :) + decay_rate_dRSC_test .* (0 - U_dRSC_test(jj, :) - ...
        U_dRSC2dRSC_gain_factor .* F_dRSC_test(jj, :) * ones(1, N_bin)' ./ N_bin + ...
        Theta_ff(jj) * U_vis2dRSC_gain_factor .* F_visual_test(jj, :) * W_vis2dRSC' + U_g2dRSC_gain_factor .* F_gRSC_test(jj, :) * W_g2dRSC');
    F_dRSC_test(jj + 1, :) = FiringRate_sigmoid(U_dRSC_test(jj + 1, :), alpha_dRSC, beta_dRSC, gamma_dRSC);
    
    U_gRSC_test(jj + 1, :) = U_gRSC_test(jj, :) + decay_rate_gRSC_test .* (0 - U_gRSC_test(jj, :) ...
        + U_HD2gRSC_gain_factor .* F_HD_test(jj, :) - U_gRSC2gRSC_gain_factor .* F_gRSC_test(jj, :) * ones(1, N_bin)' ./ N_bin);
    F_gRSC_test(jj + 1, :) = FiringRate_sigmoid(U_gRSC_test(jj + 1, :), alpha_gRSC, beta_gRSC, gamma_gRSC);
    
    W_HD_test(1, 1 : (N_bin / 2)) = W_HDring_test(jj, (N_bin / 2 + 1) : N_bin);
    W_HD_test(1, (N_bin / 2 + 1) : N_bin) = W_HDring_test(jj, 1 : (N_bin / 2));
    for k = 2 : N_bin
        W_HD_test(k, :) = circshift(W_HD_test(k - 1, :), [0 1]);
    end
    
    U_HD_test(jj + 1, :) = U_HD_test(jj, :) + decay_rate_HD .* (0 - U_HD_test(jj, :) + F_HD_test(jj, :) * W_HD_test * U_HD_gain_factor ...
        + U_dRSC2HD_gain_factor .* F_dRSC_test(jj, :) * W_dRSC2HD);
    F_HD_test(jj + 1, :) = FiringRate_sigmoid_HD(U_HD_test(jj + 1, :), alpha_HD, beta_HD, gamma_HD);
    InternalR_HD_test(jj + 1) = AngularMean(Angle, F_HD_test(jj + 1, :));
    W_HDring_test(jj + 1, :) = W_stable - W_stable_t + Gamma_test(jj + 1) .* (dW_stable - dW_stable_t);
    
    bar_present = Trajectory_test(jj + 1);
    for k = 1 : bar_bin
        if (bar_present >= Angle_bar(k)) && (bar_present < (Angle_bar(k) + bar_angle_gap))
            Bar_dRSC_firing(k, :) = Bar_dRSC_firing(k, :) + F_dRSC_test(jj + 1, :);
            Bar_gRSC_firing(k, :) = Bar_gRSC_firing(k, :) + F_gRSC_test(jj + 1, :);
            Bar_HD_firing(k, :) = Bar_HD_firing(k, :) + F_HD_test(jj + 1, :);
            Bar_cal(k) = Bar_cal(k) + 1;
            break
        end
    end
end
Bar_dRSC_firing = Bar_dRSC_firing';
Bar_gRSC_firing = Bar_gRSC_firing';
Bar_HD_firing = Bar_HD_firing';
for k = 1 : bar_bin
    if Bar_cal(k)
        Bar_dRSC_firing(:, k) = Bar_dRSC_firing(:, k) / Bar_cal(k);
        Bar_gRSC_firing(:, k) = Bar_gRSC_firing(:, k) / Bar_cal(k);
        Bar_HD_firing(:, k) = Bar_HD_firing(:, k) / Bar_cal(k);
    end
end
