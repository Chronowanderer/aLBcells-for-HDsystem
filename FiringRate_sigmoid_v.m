function FRate = FiringRate_sigmoid_v(Activation, alpha, beta, gamma)
    % Neural activation function for aLB cells
    FRate = FiringRate_sigmoid(Activation, alpha, beta, gamma);
%    FRate = FiringRate_sigmoid_HD(Activation, alpha, beta, gamma);
end
