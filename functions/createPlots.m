function createPlots(app)
    
    ax1 = app.UIAxes;
    
    % Clear any pre-existing plots
    delete(findobj(ax1, 'Type', 'line'));
    delete(findobj(ax1, 'Type', 'constantline'));
    
    % Create the data handle
    app.PlotLineHandle = plot(ax1, app.freq, zeros(app.fftSize, 1));
    ax1.XLim = [min(app.freq), max(app.freq)];
    
    % Show hydrogen line
    app.HydrogenLineHandle = xline(ax1, app.targetFreq, 'Color', 'r', 'LineWidth', 1.5);
    if app.plotLine
        app.HydrogenLineHandle.Visible = 'on';
    else
        app.HydrogenLineHandle.Visible = 'off';
    end

    ax1.Box = 'off'; 
  
    % Create velocity axes
    app.VelocityAxes = axes(ax1.Parent, ...
        'Units', ax1.Units, ...
        'Position', ax1.Position, ...
        'Color', 'none', ...
        'XAxisLocation', 'top', ...
        'YAxisLocation', 'right', ...
        'YTick', [], ...
        'YTickLabel', [], ...
        'Box', 'off', ...                     
        'YColor', 'none');

    ax2 = app.VelocityAxes;
   
    % Ensure positions overlap 
    ax1.ActivePositionProperty = 'position';
    ax2.ActivePositionProperty = 'position';
    ax2.InnerPosition = ax1.InnerPosition;

    xlabel(ax2, 'Velocity (km/s)');
    
    % Strip interactions from the top layer completely
    ax2.HitTest = 'off';
    ax2.PickableParts = 'none';
    ax2.Toolbar = []; 
    if isprop(ax2, 'Interactions')
        ax2.Interactions = [];
    end

    % Define the callback function for dynamic scaling
    updateTopXLim = @(src, evnt) updateVelocityScale(app);

    % Run it once immediately to initialize the starting view limits
    updateTopXLim();

    % Listeners to ensure positions stay synced
    addlistener(ax1, 'XLim', 'PostSet', updateTopXLim);
    addlistener(ax1, 'Position', 'PostSet', @(src, evnt) set(ax2, 'Position', ax1.Position));
    
    % Ensure secondary axis text layers stay on top
    uistack(ax2, 'top');
end
