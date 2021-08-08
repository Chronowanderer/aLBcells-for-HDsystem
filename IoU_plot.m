function [] = IoU_plot(IoU_map, IoU_axis_label, LineWidth, FontSize)
%    Plotting IoU maps for aLB cells in Fig 4
    size_IoU = size(IoU_map);
    [X, Y] = meshgrid(1 : size_IoU(2), 1 : size_IoU(1));
    IoU_axis = [fix(size_IoU(1) / 2), size_IoU(1)];
    contourf(X, Y, IoU_map, 'LineStyle', 'none');
    heatmap(IoU_map, IoU_axis_label, IoU_axis_label, 'true', 'Colormap', 'money', 'GridLines', '-');
    set(gca, 'LineWidth', LineWidth, 'Fontsize', FontSize, 'FontWeight', 'bold');
    c = colorbar;
    c.Label.FontSize = FontSize;
    caxis([0 1])
end
