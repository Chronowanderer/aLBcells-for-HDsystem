function dX = Differentiation_decending(X, dt)
    % for decending differentiation
    len = length(X);
    for j = 1 : (len - 1)
        dX(j + 1) = AngularDiff(X(j + 1), X(j)) * 1.0 / dt;
    end
    dX(1) = dX(2);
end
