function FRate = FiringRate_sigmoid_HD(Activation, alpha, beta, gamma)
    % Sigmoid function for neural activation of HD attractor
    FRate = 1.0 ./ (1 + exp(-2 * beta .* (Activation - alpha)));
    baseline = 1.0 ./ (1 + exp(-2 * beta .* (gamma - alpha)));
    FRate(FRate <= baseline) = 0;

%     FRate = FiringRate_sigmoid_power2(Activation, alpha, beta, gamma);

%     FRate = FiringRate_sigmoid(Activation, alpha, beta, 0) * (1 - gamma);
%     FRate(FRate > 0) = FRate(FRate > 0) + gamma;
end
