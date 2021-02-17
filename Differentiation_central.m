function dX = Differentiation_central(X, dt)
    % for central differentiation
    len = length(X);
    for j = 2 : (len - 1)
        dX(j) = AngularDiff(X(j + 1), X(j - 1)) * 0.5 / dt;
    end
    dX(1) = AngularDiff(X(2), X(len)) * 0.5 / dt;
    dX(len) = AngularDiff(X(1), X(len - 1)) * 0.5 / dt;
end
