function updateVelocityScale(app, ax1, ax2)
% Check validity to prevent errors if the UI is closing
    
    c = 3e8;

    if ~isvalid(ax1) || ~isvalid(ax2), return; end
    
    % Get the current visible frequency limits from the user's view window
    currentFreqLimits = ax1.XLim;
    
    % Calculate the matching velocity limits. Uses radio doppler
    v1 = c * ((app.targetFreq - currentFreqLimits(1)) / app.targetFreq) / 1e3;
    v2 = c * ((app.targetFreq - currentFreqLimits(2)) / app.targetFreq) / 1e3;
    
    % Safely assign sorted limits and enforce reverse direction
    ax2.XLim = sort([v1, v2]);
    ax2.XDir = 'reverse';
end
