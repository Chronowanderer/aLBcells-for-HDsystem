function Y = Smoothing_plots(X)
    % Smooth plot for HD
    len = length(X);
    Y = X;
    for j = 2 : len
        while abs(Y(j) - Y(j - 1)) > 180
            if Y(j) > Y(j - 1)
                Y(j) = Y(j) - 360;
            else
                Y(j) = Y(j) + 360;
            end
        end
    end
end
