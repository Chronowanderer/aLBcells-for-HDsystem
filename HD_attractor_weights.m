% Calculating Weights for HD system
F0 = vonmisespdf(Angle, weight_bias, precision_HD); % firing rate
F0_max = max(F0);
F0 = F0 ./ F0_max .* 0.8;
U0 = ActivationLevel_sigmoid(F0, alpha_HD, beta_HD, gamma_HD); % activation level

if Operation_Runenschrift
    Uf = fft(U0);
    Ff = fft(F0);
    Wf = Uf .* Ff ./ (lambda + abs(Ff) .^ 2);
    W_pi = ifft(Wf);
    for k = 1 : N_bin
        index = find(Angle == AngularDiff(Angle(k), 180));
        W_stable(k) = W_pi(index);
    end
    W_stable_t = ones(1, N_bin) * 0; 
else
    W_stable = 100 .* (vonmisespdf(Angle, weight_bias, 5) - 0.5 .* vonmisespdf(Angle, weight_bias, 0.2) - 0.002);
    W_stable_t = W_stable;
end
dW_stable = Differentiation_central(W_stable, angle_gap);
W_stable = W_stable + weight_noise_scale .* randn(1, N_bin); % stable weights
dW_stable_t = Differentiation_central(W_stable_t, angle_gap) + weight_noise_scale .* randn(1, N_bin);

Velocity = Differentiation_ascending(Trajectory, dt);
Acceleration = Differentiation_ascending(Velocity, dt);
Gamma = -time_constant_HD .* (Velocity + rho .* Acceleration);
Gamma = Gamma + asyweightstrength_noise_scale .* randn(1, T_len);
