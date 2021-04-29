function Activation = ActivationLevel_sigmoid(FRate, alpha, beta, gamma)
    % Activation level from firing rate

%     Activation = atanh(FRate) / beta + alpha;
%     Activation(Activation <= gamma) = 0;

%     Activation = atanh((FRate - gamma) / (1 - gamma)) / beta + alpha;
% 	  Activation(Activation <= 0) = 0;
    
    baseline = 1.0 ./ (1 + exp(-2 * beta .* (gamma - alpha)));
    Activation = log(1.0 ./ FRate - 1) ./ (-2 * beta) + alpha;
    Activation(Activation <= gamma) = 0;

end
