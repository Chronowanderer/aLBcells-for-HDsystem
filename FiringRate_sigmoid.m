function FRate = FiringRate_sigmoid(Activation, alpha, beta, gamma)
    % Sigmoid function for neural activation
    FRate = tanh(beta .* (Activation - alpha));
    FRate(FRate <= (tanh(beta * (gamma - alpha)))) = 0;

%     FRate = FiringRate_sigmoid_HD(Activation, alpha, beta, gamma);
end
