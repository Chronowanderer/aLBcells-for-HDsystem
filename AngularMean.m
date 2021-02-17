function ans = AngularMean(A, W)
    % 1-d angular mean
    if length(A) ~= length(W)
        print('Error for calculating internal HD representation due to incompatible dimensions!')
    else
        x = sum(sin(A .* pi ./ 180) .* W);
        y = sum(cos(A .* pi ./ 180) .* W);
        ans = atan2d(x, y);
        if abs(ans - 180) < 1e-5
            ans = -180;
        end
    end
end
