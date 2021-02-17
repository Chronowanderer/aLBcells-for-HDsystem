function ans = IoU(x, y)
    % Intersection over union
    ans = length(intersect(x, y)) / length(union(x, y));
end
