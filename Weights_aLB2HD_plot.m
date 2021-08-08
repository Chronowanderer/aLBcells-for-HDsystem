% Weights plotting for the aLB-HD model

% Weights from gRSC to dRSC For Fig 5B; S7 Fig
figure('Color', 'w');
[X, Y] = meshgrid(Angle, Angle);
contourf(X, Y, W_g2dRSC, 'LineStyle', 'none');
c = colorbar;
set(gca, 'XLim', [-180, 180 - angle_gap], 'YLim', [-180, 180 - angle_gap], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
set(gcf, 'unit', 'normalized', 'position', [0, 0, 0.4, 0.4]);
xlabel('gRSC')
ylabel('dRSC')
% title('gRSC to dRSC')

% Weights from aLB to dRSC
figure('Color', 'w');
[X, Y] = meshgrid(1 : N_abstract, Angle);
contourf(X, Y, W_arep2dRSC, 'LineStyle', 'none');
c = colorbar;
set(gca, 'XLim', [1, N_abstract], 'YLim', [-180, 180 - angle_gap], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
set(gcf, 'unit', 'normalized', 'position', [0, 0, 0.4, 0.4]);
% title('aLB to dRSC')

% Run the following after testing phase
% % arep2dRSC contribution
% figure('Color', 'w');
% [X, Y] = meshgrid(Angle_bar, Angle);
% contourf(X, Y, Bar_arep2dRSC_activation, 'LineStyle', 'none');
% c = colorbar;
% set(gca, 'XLim', [-180, 180 - bar_angle_gap], 'YLim', [-180, 180 - angle_gap], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
% 
% % g2dRSC contribution
% figure('Color', 'w');
% [X, Y] = meshgrid(Angle_bar, Angle);
% contourf(X, Y, Bar_g2dRSC_activation, 'LineStyle', 'none');
% c = colorbar;
% set(gca, 'XLim', [-180, 180 - bar_angle_gap], 'YLim', [-180, 180 - angle_gap], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
