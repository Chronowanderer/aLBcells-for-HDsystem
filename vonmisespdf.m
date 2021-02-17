function y = vonmisespdf(x, mu, k) 
  % von Mises distribution with mean (mu) and spread kappa (k) parameters. 
  % Computations done in log space to allow much larger k's without
  % overflowing.
  y = (exp((k .* cos((pi / 180) .* (x - mu))) - (log(360) + log(besseli(0, k, 1)) + k)));
%    y = (exp((k.*cos(x - mu)) - (log(2 * pi) + log(besseli(0, k, 1)) + k)));
end