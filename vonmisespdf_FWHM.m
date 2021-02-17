function ans = vonmisespdf_FWHM(x, k)
    % Full width at half maximum of von Mises distribution
    y = vonmisespdf(x, 0, k);
    y_max = max(y);
    y = y ./ y_max .* 1;
    ans = sum(y >= .5);
%    plot(x, y);
end
