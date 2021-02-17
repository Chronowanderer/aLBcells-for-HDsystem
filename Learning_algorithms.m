function W_t = Learning_algorithms(name, input, output, W_t0, lr, ff_coefficient, fb_coefficient)
    % Stepwise learning algorithms
    
    if nargin < 7, fb_coefficient = 1; end % fb = feedback
    if nargin < 6, ff_coefficient = 1; end % ff = feedforward
    if nargin < 5, lr = 0.1; end % lr = learning rate
    if nargin < 4, fprintf('Missing inputs!\n'); end
    
    switch name
        case 'mOSA' % modified Oja's subspace algorithm
            W_t = ReLU(W_t0 + lr * output' * (ff_coefficient * input - fb_coefficient * output * W_t0));
        case 'sOSA' % Oja's single neuron algorithm
            W_t = W_t0 + lr * diag(output) * (ff_coefficient * ones(length(output), 1) * input - fb_coefficient * diag(output) * W_t0);
        case 'STDP' % STDP
            W_t = W_t0 - lr * fb_coefficient * output' * input + lr * ff_coefficient * output' * ones(1, length(input));
        case 'GHA' % Sanger's rule (GHA)
            W_t = W_t0 + lr * (ff_coefficient * output' * input - fb_coefficient * output' * tril(ones(length(output), 1) * output) * W_t0);
        case 'HL' % Classic Hebbian rule    
            W_t = W_t0 + lr * ff_coefficient * output' * input;
            Wv_total = sqrt(sum(W_t.^ 2, 2));
            Wv_total_metric = repmat(Wv_total,[1, length(input)]);
            Wv_target = min(Wv_total, fb_coefficient);
            Wv_target_metric = repmat(Wv_target,[1, length(input)]);
            W_t = W_t ./ Wv_total_metric .* Wv_target_metric;   
        case 'HCL' % Hebbian covariance rule
            W_t = W_t0 + lr * (output - fb_coefficient)' * (input - ff_coefficient);
        case 'BCM' % BCM
            % deviation_M = 1; % Unscaled
            % deviation_M = 1.0 ./ threshold_M; % Law & Cooper (1994)
            deviation_M = ff_coefficient * (1 - output .^ 2); % Intrator & Cooper (1992) with tanh function
            W_t = W_t0 + lr * (output .* (output - fb_coefficient) .* deviation_M)' * input;
        case 'Competitive'  % Competitive learning
            W_t = W_t0;
            [maximum, theta] = max(output);                                                                             
            W_t(theta, :) = W_t(theta, :) + lr * (ff_coefficient * input - fb_coefficient * W_t(theta, :));
        otherwise
            fprintf('Error: Define your learning algorithm first!\n')
    end
end
