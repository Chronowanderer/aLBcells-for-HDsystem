function delta = AngularDiff(x, y)
    % 1-d angular difference
    criterion = 180;
    delta = x - y;
    while (delta < (0 - criterion)) || (delta >= criterion)
        if delta < (0 - criterion)
            delta = delta + 2 * criterion;
        elseif delta >= criterion
            delta = delta - 2 * criterion;
        end
    end
end
