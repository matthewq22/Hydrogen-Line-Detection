function [p, targetLine, ax1, ax2] = createPlots(app)
    ax1 = app.UIAxes;
    
    % Clear any pre-existing plots
    delete(findobj(ax1, 'Type', 'line'));
    delete(findobj(ax1, 'Type', 'constantline'));

    p = plot(ax1, app.freq, zeros(app.fftSize, 1));
    
    % Show hydrogen line
    targetLine = xline(ax1, app.targetFreq, 'Color', 'r', 'LineWidth', 1.5);
    if app.plotLine
        targetLine.Visible = 'on';
    else
        targetLine.Visible = 'off';
    end

    % Configure primary axes (Frequency - Bottom)
    ax1 = app.UIAxes;
    ax1.Box = 'off'; 
    
    % --- CRITICAL FIX FOR APP DESIGNER SYNCHRONIZATION ---
    % Force the primary App Designer axes to use the strict position metric
    ax1.ActivePositionProperty = 'position';

    % Create the secondary axis anchored inside the exact same UI container
   ax2 = axes(ax1.Parent, ...
        'Units', ax1.Units, ...
        'Position', ax1.Position, ...
        'Color', 'none', ...
        'XAxisLocation', 'top', ...
        'YAxisLocation', 'right', ...
        'YTick', [], ...
        'YTickLabel', [], ...
        'Box', 'off', ...                     % CRITICAL: Wipes out the layout bounding box
        'YColor', 'none', ...                 % CRITICAL: Completely hides the invisible right line
        'ActivePositionProperty', 'position'); % Enforce identical positioning engine
    
    xlabel(ax2, 'Velocity (km/s)');
    
    % Strip interactions from the top layer completely
    ax2.HitTest = 'off';
    ax2.PickableParts = 'none';
    ax2.Toolbar = []; 
    if isprop(ax2, 'Interactions')
        ax2.Interactions = [];
    end


    % Define the callback function for dynamic scaling
    updateTopXLim = @(src, evnt) updateVelocityScale(app, ax1, ax2);

    % Run it once immediately to initialize the starting view limits
    updateTopXLim();

    % Add listeners to keep them perfectly synced geometrically and scale-wise
    addlistener(ax1, 'XLim', 'PostSet', updateTopXLim);
    
    % --- PERFECT PIXEL ALIGNMENT ---
    % Because ActivePositionProperty is set to 'position', syncing the 'Position'
    % vector forces the drawable bounding boxes to lock matching pixel-for-pixel.
    addlistener(ax1, 'Position', 'PostSet', @(src, evnt) set(ax2, 'Position', ax1.Position));
    
    % Ensure secondary axis text layers stay on top
    uistack(ax2, 'top');
end
