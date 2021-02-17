function FRate = FiringRate_sigmoid_power2(Activation, alpha, beta, gamma)
    % Mixed sigmoid function for neural activation
    X = Activation;
    len_X = length(X);
    FRate = zeros(1, len_X);
    strength = beta / (beta + 2 / (alpha - gamma));
    for k = 1 : len_X
        if X(k) >= alpha
            FRate(k) = (1 - strength) * tanh(beta * (X(k) - alpha)) + strength;
        elseif X(k) >= gamma
            FRate(k) = strength * ((X(k) - gamma) / (alpha - gamma)) ^ 2;
        end
    end
end
