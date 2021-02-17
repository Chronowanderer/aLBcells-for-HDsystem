function dX = Differentiation_ascending(X, dt)
    % for ascending differentiation
    len = length(X);
    for j = 1 : (len - 1)
        dX(j) = AngularDiff(X(j + 1), X(j)) * 1.0 / dt;
    end
    dX(len) = dX(len - 1);
end
