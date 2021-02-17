function output = ReLU(input)
    % Transform negative value to 0
    input(input < 0) = 0;
    output = input;
end
