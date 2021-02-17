function Activation = ActivationLevel_sigmoid(FRate, alpha, beta, gamma)
    % Activation level from firing rate

%     Activation = atanh(FRate) / beta + alpha;
%     Activation(Activation <= gamma) = 0;

%     Activation = atanh((FRate - gamma) / (1 - gamma)) / beta + alpha;
% 	  Activation(Activation <= 0) = 0;
    
    baseline = 1.0 ./ (1 + exp(-2 * beta .* (gamma - alpha)));
    Activation = log(1.0 ./ FRate - 1) ./ (-2 * beta) + alpha;
    Activation(Activation <= gamma) = 0;

%     X = FRate;
%     len_X = length(X);
%     Activation = zeros(1, len_X);
%     strength = beta / (beta + 2 / (alpha - gamma));
%     for k = 1 : len_X
%         if X(k) > strength
%             Activation(k) = atanh((X(k) - strength) / (1 - strength)) / beta + alpha;
%         elseif X(k) > 0
%             Activation(k) = sqrt(X(k) / strength) * (alpha - gamma) + gamma;
%         end
%     end

end
