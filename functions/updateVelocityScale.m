function updateVelocityScale(app)
    % Ensures both axis are aligned
    
    ax1 = app.UIAxes;
    ax2 = app.VelocityAxes;
    
    % Ensure both axes are valid
    if isvalid(ax1) && isvalid(ax2)
        c = 299792.458; % Speed of light in km/s
        f0 = app.targetFreq; % Emission of neutral hydrogen

        % Calculate velocity from frequencies
        v_start = c * ((f0 - ax1.XLim(1)) / f0);
        v_end   = c * ((f0 - ax1.XLim(2)) / f0);

        % Set limits
        rawVelLimits = [v_start, v_end];
        sortedLimits = sort(rawVelLimits);
        ax2.XLim = sortedLimits;

        % Custom tick markings
        tickStart = ceil(sortedLimits(1) / 50) * 50;  % Find next highest multiple of 50
        tickEnd   = floor(sortedLimits(2) / 50) * 50; % Find next lowest multiple of 50
        ax2.XTick = tickStart:50:tickEnd;             

        % Ensure correct direction
        if rawVelLimits(1) > rawVelLimits(2)
            ax2.XDir = 'reverse';
        else
            ax2.XDir = 'normal';
        end
    end
end
